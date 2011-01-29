package com.gogogic.gamejam.view.components
{
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
		private var _scoreField:TextField;
		
		public function ScoreComponent(playerVO:PlayerVO)
		{
			_playerVO = playerVO;
			init();
		}
		
		private function init():void {
			_playerVO.addEventListener(DataChangeEvent.DATA_CHANGE, onPlayerVODataChange);
			// TODO: Initialize score graphics and dynamic textfield
			
			_scoreField = new TextField();
			_scoreField.selectable = false;
			_scoreField.autoSize = TextFieldAutoSize.CENTER;
			addChild(_scoreField);
			setTextFormat(_scoreField, null, 20, 0x000000, null, null, null, null, null, TextFormatAlign.CENTER);
			_scoreField.embedFonts = false;
			
			updateScore();
		}
		
		private function onPlayerVODataChange(e:DataChangeEvent):void {
			updateScore();
		}
		
		private function updateScore():void {
			// TODO: Update score textfield
			_scoreField.text = "SCORE:\n" + _playerVO.score.toString();
			_scoreField.x = -Math.round(_scoreField.width / 2);
		}
		
	}
}