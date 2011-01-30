package com.gogogic.gamejam.view.components
{
	import com.gogogic.gamejam.assets.Score;
	import com.gogogic.gamejam.model.vo.PlayerVO;
	import com.gogogic.gamejam.model.vo.event.DataChangeEvent;
	import com.gogogic.ui.setTextFormat;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	
	public class ScoreComponent extends Sprite
	{
		private var _playerVO:PlayerVO;
		private var _score:Score;
		
		public function ScoreComponent(playerVO:PlayerVO)
		{
			_playerVO = playerVO;
			init();
		}
		
		private function init():void {
			_playerVO.addEventListener(DataChangeEvent.DATA_CHANGE, onPlayerVODataChange);
			// TODO: Initialize score graphics and dynamic textfield
			
			addChild(_score = new Score());
			_score.txtScore.autoSize = TextFieldAutoSize.LEFT;
			updateScore();
		}
		
		private function onPlayerVODataChange(e:DataChangeEvent):void {
			updateScore();
		}
		
		private function updateScore():void {
			// TODO: Update score textfield
			_score.txtScore.text = _playerVO.score.toString();
			
			_score.txtScore.x = -Math.round(_score.txtScore.width / 2);
		}
		
	}
}