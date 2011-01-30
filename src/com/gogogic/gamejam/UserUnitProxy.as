package com.gogogic.gamejam
{
	import com.gogogic.gamejam.model.vo.FriendVO;
	import com.gogogic.gamejam.model.vo.UnitVO;
	import com.gogogic.gamejam.view.GameBoardMediator;
	import com.gogogic.gamejam.view.components.UnitComponent;
	import com.gogogic.gamejam.view.components.units.DemoUnitComponent;
	import com.gogogic.gamejam.view.components.units.KamikazeUnitComponent;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class UserUnitProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "UserUnitProxy";
		
		private static var _gameBoardUnits:Vector.<UnitVO>;
		
		public function UserUnitProxy()
		{
			super(NAME);
		}
		
		
		public function set gameBoardUnits(value:Vector.<UnitVO>):void {
			_gameBoardUnits = value;
		}
		
		public function friendDropped(friendVO:FriendVO, x:int, y:int):void {
			var unitComponent:UnitComponent;
			
			// TODO: Create different superclasses of unitComponent according to the friendVO
			
			// DEBUG
			unitComponent = new KamikazeUnitComponent();
			
			// Setup all the common, required data
			unitComponent.init(friendVO, _gameBoardUnits, x, y, false);
			sendNotification(GameBoardMediator.ADD_UNIT, unitComponent);
		}
		
	}
}