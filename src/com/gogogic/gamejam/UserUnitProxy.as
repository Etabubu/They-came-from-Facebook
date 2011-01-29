package com.gogogic.gamejam
{
	import com.gogogic.gamejam.model.vo.FriendVO;
	import com.gogogic.gamejam.model.vo.UnitVO;
	import com.gogogic.gamejam.view.GameBoardMediator;
	import com.gogogic.gamejam.view.components.UnitComponent;
	import com.gogogic.gamejam.view.components.units.DemoUnitComponent;
	
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
			var unitVO:UnitVO = new UnitVO();
			
			unitVO.friendVO = friendVO;
			unitVO.x = x;
			unitVO.y = y;
			
			var unitComponent:DemoUnitComponent = new DemoUnitComponent(unitVO);
			
			sendNotification(GameBoardMediator.ADD_UNIT, unitComponent);
		}
	}
}