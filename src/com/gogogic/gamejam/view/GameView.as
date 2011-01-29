package com.gogogic.gamejam.view
{
	import com.gogogic.gamejam.model.FriendDeck;
	import com.gogogic.gamejam.view.components.FriendCardComponent;
	import com.gogogic.gamejam.view.components.GameDeckComponent;
	
	import flash.display.Sprite;
	
	public class GameView extends Sprite
	{
		private var _friendDeck:FriendDeck;
		private var _gameDeckComponent:GameDeckComponent;
		
		public function GameView()
		{
			
		}
		
		public function init(friendDeck:FriendDeck):void {
			_friendDeck = friendDeck;
			
			addChild(_gameDeckComponent = new GameDeckComponent(_friendDeck));
			
			var cardTest:FriendCardComponent = new FriendCardComponent(_friendDeck.drawNext());
			addChild(cardTest);
			trace("Yahoo");
		}
	}
}