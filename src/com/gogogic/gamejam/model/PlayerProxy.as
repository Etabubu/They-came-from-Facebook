package com.gogogic.gamejam.model
{
	import com.gogogic.gamejam.model.vo.PlayerVO;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class PlayerProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "PlayerProxy";
		
		private var _frameDispatcher:EventDispatcher;
		
		public function PlayerProxy()
		{
			super(NAME, new PlayerVO());
		}
		
		public function get playerVO():PlayerVO {
			return data as PlayerVO;
		}
		
		public function startEnergyRegen():void {
			if (_frameDispatcher) return;
			_frameDispatcher = new Sprite();
			_frameDispatcher.addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		public function stopEnergyRegen():void {
			_frameDispatcher.removeEventListener(Event.ENTER_FRAME, onFrame);
			_frameDispatcher = null;
		}
		
		private function onFrame(e:Event):void {
			if (playerVO.energy == 1 && playerVO.reserveEnergy == 1) return;
			
			if (playerVO.reserveEnergy == 1 && playerVO.energy < 1) {
				// Switch
				playerVO.reserveEnergy = playerVO.energy;
				playerVO.energy = 1;
				playerVO.dispatchEvent(new Event(PlayerVO.ENERGY_BARS_SWITCHED));
			} else {
				playerVO.reserveEnergy += 0.001;
				if (playerVO.reserveEnergy >= 1) {
					playerVO.reserveEnergy = 1;
				}
				// Switch on next onFrame
			}
			playerVO.triggerDataChangeEvent();
		}
		
		
		public function reset():void {
			playerVO.energy = playerVO.reserveEnergy = 1;
			playerVO.score = 0;
			playerVO.playerUnit = null;
		}
	}
}
