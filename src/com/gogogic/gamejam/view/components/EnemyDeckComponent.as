package com.gogogic.gamejam.view.components
{
	import com.gogogic.gamejam.model.FriendDeck;
	
	import flash.display.Sprite;
	
	public class EnemyDeckComponent extends Sprite
	{
		private var _friendDeck:FriendDeck;
		
		public function EnemyDeckComponent(friendDeck:FriendDeck)
		{
			_friendDeck = friendDeck;
		}
	}
}