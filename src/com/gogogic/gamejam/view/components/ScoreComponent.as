package com.gogogic.gamejam.view.components
{
	import com.gogogic.gamejam.model.vo.PlayerVO;
	import com.gogogic.gamejam.model.vo.event.DataChangeEvent;
	
	import flash.display.Sprite;
	
	public class ScoreComponent extends Sprite
	{
		private var _playerVO:PlayerVO;
		
		public function ScoreComponent(playerVO:PlayerVO)
		{
			_playerVO = playerVO;
			init();
		}
		
		private function init():void {
			_playerVO.addEventListener(DataChangeEvent.DATA_CHANGE, onPlayerVODataChange);
			// TODO: Initialize score graphics and dynamic textfield
			updateScore();
		}
		
		private function onPlayerVODataChange(e:DataChangeEvent):void {
			updateScore();
		}
		
		private function updateScore():void {
			// TODO: Update score textfield
		}
		
	}
}