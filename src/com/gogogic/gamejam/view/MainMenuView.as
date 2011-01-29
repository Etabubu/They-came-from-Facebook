package com.gogogic.gamejam.view
{
	import com.gogogic.gamejam.MainMenu;
	
	import flash.display.Sprite;
	
	public class MainMenuView extends Sprite
	{
		private var _mainMenu:MainMenu;
		
		public function MainMenuView()
		{
			addChild(_mainMenu = new MainMenu());
		}
	}
}