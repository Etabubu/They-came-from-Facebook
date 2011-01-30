package com.gogogic.gamejam.view
{
	import com.gogogic.gamejam.MainMenu;
	import com.gogogic.gamejam.assets.EndScore;
	import com.gogogic.gamejam.assets.PlayAgainButton;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class EndScreenView extends Sprite
	{
		private var _mainMenu:MainMenu;
		
		private var _btnPlayAgain:PlayAgainButton;
		private var _endScore:EndScore;
		
		public function EndScreenView()
		{
			addChild(_mainMenu = new MainMenu())
			
			_btnPlayAgain = new PlayAgainButton();
			
			_mainMenu.removeChild(_mainMenu.btnPlay);
			_mainMenu.removeChild(_mainMenu.mcLeaderboard);
			_mainMenu.addChild(_btnPlayAgain);
			_btnPlayAgain.stop();
			_btnPlayAgain.x = _mainMenu.btnPlay.x;
			_btnPlayAgain.y = _mainMenu.btnPlay.y;
			
			_endScore = new EndScore();
			_mainMenu.addChild(_endScore);
			_endScore.x = 200;
			_endScore.y = 400;
			_endScore.txtScore.text = "0";
			
			_btnPlayAgain.mouseChildren = false;
			_btnPlayAgain.buttonMode = true;
			_btnPlayAgain.addEventListener(MouseEvent.MOUSE_OVER, onPlayBtnOver);
			_btnPlayAgain.addEventListener(MouseEvent.MOUSE_OUT, onPlayBtnOut);
			_btnPlayAgain.addEventListener(MouseEvent.MOUSE_DOWN, onPlayMouseDown);
			_btnPlayAgain.addEventListener(MouseEvent.CLICK, onPlayClicked);
		}
		
		public function set playerScore(value:Number):void {
			_endScore.txtScore.text = value.toString();
		}
		
		private function onPlayBtnOver(e:MouseEvent):void {
			_btnPlayAgain.gotoAndStop(2);
		}
		
		private function onPlayBtnOut(e:MouseEvent):void {
			_btnPlayAgain.gotoAndStop(1);
		}
		
		private function onPlayMouseDown(e:MouseEvent):void {
			_btnPlayAgain.gotoAndStop(3);
		}
		
		private function onPlayClicked(e:MouseEvent):void {
			dispatchEvent(new Event(MainMenuView.START_CLICKED));
		}
	}
}