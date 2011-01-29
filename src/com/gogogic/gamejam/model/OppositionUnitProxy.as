package com.gogogic.gamejam.model
{
	import com.gogogic.gamejam.model.vo.FriendVO;
	import com.gogogic.gamejam.model.vo.OppositionVO;
	import com.gogogic.gamejam.model.vo.UnitVO;
	import com.gogogic.gamejam.view.GameBoardMediator;
	import com.gogogic.gamejam.view.components.UnitComponent;
	import com.gogogic.gamejam.view.components.units.DemoUnitComponent;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class OppositionUnitProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "OppositionProxy";
		
		private static var _gameBoardUnits:Vector.<UnitVO>;
		
		private var _oppositionDeck:FriendDeck;
		
		private var _spawnTimer:Timer;
		
		public function OppositionUnitProxy()
		{
			super(NAME, new OppositionVO());
		}
		
		public function get oppositionVO():OppositionVO {
			return data as OppositionVO;
		}
		
		public function set oppositionFriends(value:Vector.<FriendVO>):void {
			_oppositionDeck = new FriendDeck(value);
		}
		
		public function get oppositionDeck():FriendDeck {
			return _oppositionDeck;
		}
		
		public function set gameBoardUnits(value:Vector.<UnitVO>):void {
			_gameBoardUnits = value;
		}
		
		public function start():void {
			if (!_spawnTimer) {
				_spawnTimer = new Timer(5500);
				_spawnTimer.addEventListener(TimerEvent.TIMER, onSpawnTimer);
			}
			_spawnTimer.start();
		}
		
		public function stop():void {
			_spawnTimer.removeEventListener(TimerEvent.TIMER, onSpawnTimer);
			_spawnTimer.stop();
			_spawnTimer = null;
		}
		
		private function onSpawnTimer(e:TimerEvent):void {
			var unitComponent:UnitComponent;
			
			// TODO: Create different superclasses of unitComponent according to the friendVO
			
			// DEBUG
			unitComponent = new DemoUnitComponent();
			
			// Setup all the common, required data
			unitComponent.init(_oppositionDeck.drawNext(), _gameBoardUnits, 30 + Math.random() * 700, 100, true);
			sendNotification(GameBoardMediator.ADD_UNIT, unitComponent);
		}
	}
}