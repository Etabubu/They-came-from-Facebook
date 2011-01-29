package com.gogogic.gamejam.view
{
	import com.gogogic.gamejam.model.FriendDeck;
	import com.gogogic.gamejam.model.vo.PlayerVO;
	import com.gogogic.gamejam.view.components.FriendCardComponent;
	import com.gogogic.gamejam.view.components.GameDeckComponent;
	import com.gogogic.gamejam.view.components.ScoreComponent;
	
	import flash.display.Sprite;
	
	public class GameView extends Sprite
	{
		private var _playerVO:PlayerVO;
		
		private var _scoreComponent:ScoreComponent
		private var _friendDeck:FriendDeck;
		private var _gameDeckComponent:GameDeckComponent;
		
		public function GameView()
		{
			
		}
		
		public function init(playerVO:PlayerVO, friendDeck:FriendDeck):void {
			_friendDeck = friendDeck;
			
			addChild(_scoreComponent = new ScoreComponent(_playerVO));
			addChild(_gameDeckComponent = new GameDeckComponent(_friendDeck));
		}
	}
}