package com.gogogic.gamejam.view
{
	import com.gogogic.gamejam.UserUnitProxy;
	import com.gogogic.gamejam.model.OppositionUnitProxy;
	import com.gogogic.gamejam.model.PlayerProxy;
	import com.gogogic.gamejam.model.vo.UnitVO;
	import com.gogogic.gamejam.view.components.GameBoardComponent;
	import com.gogogic.gamejam.view.components.UnitComponent;
	import com.gogogic.gamejam.view.events.DropFriendEvent;
	
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class GameBoardMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "GameBoardMediator";
		
		public static const ADD_UNIT:String = NAME + "AddUnit";
		public static const UNIT_DIE:String = NAME + "UnitDie";
		
		private var _units:Vector.<UnitVO>;
		
		public function GameBoardMediator(gameBoardComponent:GameBoardComponent)
		{
			super(NAME, gameBoardComponent);
			_units = new Vector.<UnitVO>();
			
			gameBoardComponent.addEventListener(DropFriendEvent.DROP_FRIEND, onFriendDropped);
		}
		
		override public function onRegister():void {
			// Let the unit handler proxies have references to all of the units
			(facade.retrieveProxy(OppositionUnitProxy.NAME) as OppositionUnitProxy).gameBoardUnits = _units;
			(facade.retrieveProxy(UserUnitProxy.NAME) as UserUnitProxy).gameBoardUnits = _units;
			// Add the player unit to the units list, the gameboardcomponent will create the unit component on its own
			_units.push((facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy).playerVO.playerUnit);
		}
		
		public function get gameBoardComponent():GameBoardComponent {
			return viewComponent as GameBoardComponent;
		}
		
		private function onFriendDropped(e:DropFriendEvent):void {
			(facade.retrieveProxy(UserUnitProxy.NAME) as UserUnitProxy).friendDropped(e.friendVO, e.coordinates.x, e.coordinates.y);
		}
		
		override public function listNotificationInterests():Array {
			return [
				ADD_UNIT
			];
		}
		
		override public function handleNotification(notification:INotification):void {
			switch (notification.getName()) {
				case ADD_UNIT:
					var unitComponent:UnitComponent = notification.getBody() as UnitComponent;
					// Insert the UnitVO for all to see
					_units.push(unitComponent.unitVO);
					// And insert the unitComponent into the gameboard
					gameBoardComponent.insertUnit(unitComponent);
					unitComponent.addEventListener(UnitComponent.DIE, onUnitDie);
					break;
			}
		}
		
		private function onUnitDie(e:Event):void {
			var unitComponent:UnitComponent = e.currentTarget as UnitComponent;
			unitComponent.removeEventListener(UnitComponent.DIE, onUnitDie);
			_units.splice(_units.indexOf(unitComponent.unitVO), 1);
			sendNotification(UNIT_DIE, unitComponent.unitVO);
		}
	}
}