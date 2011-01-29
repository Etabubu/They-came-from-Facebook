package com.gogogic.gamejam.view.components
{
	import com.gogogic.gamejam.Settings;
	import com.gogogic.gamejam.model.FriendDeck;
	
	import flash.display.Sprite;
	
	public class GameDeckComponent extends Sprite
	{
		private var _friendDeck:FriendDeck;
		private var _coolDownComponent:CooldDownComponent;
		
		public function GameDeckComponent(friendDeck:FriendDeck)
		{
			_friendDeck = friendDeck;
			addChild(_coolDownComponent = new CooldDownComponent());
			
		}
	}
}