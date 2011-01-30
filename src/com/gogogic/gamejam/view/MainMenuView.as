package com.gogogic.gamejam.view
{
	import com.gogogic.gamejam.MainMenu;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class MainMenuView extends Sprite
	{
		public static const START_CLICKED:String = "startClicked";
		
		private var _mainMenu:MainMenu;
		private var _doneLoadingFacebook:Boolean = false;
		
		public function MainMenuView()
		{
			init();
		}
		
		private function init():void {
			addChild(_mainMenu = new MainMenu());
		}
		
		public function doneLoadingFacebook():void {
			if (_doneLoadingFacebook) return;
			_doneLoadingFacebook = true;
			
			_mainMenu.btnPlay.buttonMode = true;
			_mainMenu.btnPlay.mouseChildren = false;
			_mainMenu.btnPlay.gotoAndStop(2);
			_mainMenu.btnPlay.addEventListener(MouseEvent.MOUSE_OVER, onPlayBtnOver);
			_mainMenu.btnPlay.addEventListener(MouseEvent.MOUSE_OUT, onPlayBtnOut);
			_mainMenu.btnPlay.addEventListener(MouseEvent.MOUSE_DOWN, onPlayMouseDown);
			_mainMenu.btnPlay.addEventListener(MouseEvent.CLICK, onPlayClicked);
		}
		
		private function onPlayBtnOver(e:MouseEvent):void {
			_mainMenu.btnPlay.gotoAndStop(3);
		}
		
		private function onPlayBtnOut(e:MouseEvent):void {
			_mainMenu.btnPlay.gotoAndStop(2);
		}
		
		private function onPlayMouseDown(e:MouseEvent):void {
			_mainMenu.btnPlay.gotoAndStop(4);
		}
		
		private function onPlayClicked(e:MouseEvent):void {
			dispatchEvent(new Event(START_CLICKED));
		}
	}
}