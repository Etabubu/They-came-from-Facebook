package com.gogogic.gamejam.model
{
	import com.gogogic.gamejam.Settings;
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
			playerVO.energy = playerVO.reserveEnergy = Settings.MAX_ENERGY;
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
			if (playerVO.energy == Settings.MAX_ENERGY && playerVO.reserveEnergy == Settings.MAX_ENERGY) return;
			
			if (playerVO.reserveEnergy == Settings.MAX_ENERGY && playerVO.energy < Settings.MAX_ENERGY) {
				// Switch
				playerVO.reserveEnergy = playerVO.energy;
				playerVO.energy = Settings.MAX_ENERGY;
				playerVO.dispatchEvent(new Event(PlayerVO.ENERGY_BARS_SWITCHED));
			} else {
				playerVO.reserveEnergy += Settings.ENERGY_REGEN_PER_FRAME;
				if (playerVO.reserveEnergy >= Settings.MAX_ENERGY) {
					playerVO.reserveEnergy = Settings.MAX_ENERGY;
				}
				// Switch on next onFrame
			}
			playerVO.triggerDataChangeEvent();
		}
		
		
		public function reset():void {
			playerVO.energy = playerVO.reserveEnergy = Settings.MAX_ENERGY;
			playerVO.score = 0;
			playerVO.playerUnit = null;
		}
	}
}
