package com.gogogic.gamejam.view.components
{
	import com.gogogic.gamejam.model.vo.PlayerVO;
	import com.gogogic.gamejam.model.vo.event.DataChangeEvent;
	
	import flash.display.Sprite;
	
	public class EnergyBar extends Sprite
	{
		private var _playerVO:PlayerVO;
		
		public function EnergyBar(playerVO:PlayerVO)
		{
			_playerVO = playerVO;
			_playerVO.addEventListener(DataChangeEvent.DATA_CHANGE, onPlayerOrUnitVODataChange);
			_playerVO.playerUnit.addEventListener(DataChangeEvent.DATA_CHANGE, onPlayerOrUnitVODataChange);
			update();
		}
		
		private function onPlayerVODataChange(e:DataChangeEvent):void {
			update();
		}
		
		private function update():void {
			
		}
	}
}