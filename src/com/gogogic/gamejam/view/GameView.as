package com.gogogic.gamejam.view
{
	import com.gogogic.gamejam.Application;
	import com.gogogic.gamejam.model.FriendDeck;
	import com.gogogic.gamejam.model.vo.PlayerVO;
	import com.gogogic.gamejam.view.components.EnemyDeckComponent;
	import com.gogogic.gamejam.view.components.EnergyBar;
	import com.gogogic.gamejam.view.components.FriendCardComponent;
	import com.gogogic.gamejam.view.components.GameBoardComponent;
	import com.gogogic.gamejam.view.components.GameDeckComponent;
	import com.gogogic.gamejam.view.components.ScoreComponent;
	
	import flash.display.Sprite;
	
	public class GameView extends Sprite
	{
		private var _playerVO:PlayerVO;
		
		private var _gameBoardComponent:GameBoardComponent;
		private var _energyBar:EnergyBar;
		private var _scoreComponent:ScoreComponent
		private var _friendDeck:FriendDeck;
		private var _enemyDeckComponent:EnemyDeckComponent;
		private var _gameDeckComponent:GameDeckComponent;
		
		public function GameView()
		{
			
		}
		
		public function init(playerVO:PlayerVO, friendDeck:FriendDeck, enemyDeck:FriendDeck):void {
			_friendDeck = friendDeck;
			_playerVO = playerVO;
			
			addChild(_gameBoardComponent = new GameBoardComponent());
			
			addChild(_energyBar = new EnergyBar(_playerVO));
			_energyBar.y = Application.APPLICATION_HEIGHT;
			
			addChild(_gameDeckComponent = new GameDeckComponent(_friendDeck));
			_gameDeckComponent.x = 0;
			_gameDeckComponent.y = 690;
			
			addChild(_enemyDeckComponent = new EnemyDeckComponent(enemyDeck));
			_enemyDeckComponent.x = 500;
			_enemyDeckComponent.y = 20;
			
			addChild(_scoreComponent = new ScoreComponent(_playerVO));
			_scoreComponent.x = Application.APPLICATION_WIDTH / 2;
			_scoreComponent.y = 20;
		}
		
		public function get gameBoardComponent():GameBoardComponent {
			return _gameBoardComponent;
		}
	}
}