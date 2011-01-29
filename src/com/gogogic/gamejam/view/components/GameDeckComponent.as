package com.gogogic.gamejam.view.components
{
	import com.gogogic.gamejam.model.FriendDeck;
	
	import flash.display.Sprite;
	
	public class GameDeckComponent extends Sprite
	{
		private var _friendDeck:FriendDeck;
		
		public function GameDeckComponent(friendDeck:FriendDeck)
		{
			_friendDeck = friendDeck;
		}
	}
}