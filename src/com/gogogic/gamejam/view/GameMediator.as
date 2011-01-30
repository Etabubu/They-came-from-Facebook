package com.gogogic.gamejam.view
{
	import com.gogogic.gamejam.Settings;
	import com.gogogic.gamejam.assets.Bling;
	import com.gogogic.gamejam.model.FriendDeck;
	import com.gogogic.gamejam.model.FriendsProxy;
	import com.gogogic.gamejam.model.OppositionUnitProxy;
	import com.gogogic.gamejam.model.PlayerProxy;
	import com.gogogic.gamejam.model.vo.BonusVO;
	import com.gogogic.gamejam.model.vo.FriendVO;
	import com.gogogic.gamejam.model.vo.PlayerUnitVO;
	import com.gogogic.gamejam.model.vo.UnitVO;
	import com.gogogic.gamejam.model.vo.event.DataChangeEvent;
	import com.gogogic.gamejam.view.components.units.PlayerUnitComponent;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class GameMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "GameMediator";
		
		public static const GAME_OVER:String = NAME + "GameOver";
		
		private var _friendsProxy:FriendsProxy;
		private var _playerProxy:PlayerProxy;
		private var _oppositionProxy:OppositionUnitProxy;
		
		private var _playerUnitComponent:PlayerUnitComponent;
		
		public function GameMediator(gameView:GameView)
		{
			super(NAME, gameView);
		}
		
		public function get gameView():GameView {
			return viewComponent as GameView;
		}
		
		override public function onRegister():void {
			_friendsProxy = facade.retrieveProxy(FriendsProxy.NAME) as FriendsProxy;
			_playerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			_oppositionProxy = facade.retrieveProxy(OppositionUnitProxy.NAME) as OppositionUnitProxy;
			
			if (_friendsProxy.friends) {
				friendsLoaded();
			}
		}
		
		public override function listNotificationInterests():Array {
			return [
				FriendsProxy.FRIEND_LIST_LOADED
			];
		}
		
		public override function handleNotification(notification:INotification):void {
			switch (notification.getName()) {
				case FriendsProxy.FRIEND_LIST_LOADED:
					friendsLoaded();
					break;
			}
		}
		
		private function friendsLoaded():void {
			start();
		}
		
		private function start():void {
			_playerProxy.playerVO.playerUnit = createPlayerUnit();
			_playerProxy.playerVO.playerUnit.addEventListener(DataChangeEvent.DATA_CHANGE, onPlayerUnitVODataChange);
			// Set up the opposition friendDeck by supplying the "enemy friends" to the opposition proxy
			_oppositionProxy.oppositionFriends = _friendsProxy.enemies;
			gameView.init(_playerProxy.playerVO, new FriendDeck(_friendsProxy.friends), _oppositionProxy.oppositionDeck);
			// Register the mediator for the game board
			facade.registerMediator(new GameBoardMediator(gameView.gameBoardComponent));
			// Start the enemy
			_oppositionProxy.start();
			// Start the energy regeneration
			_playerProxy.startEnergyRegen();
		}
		
		private function createPlayerUnit():PlayerUnitVO {
			var playerUnit:PlayerUnitVO = new PlayerUnitVO();
			playerUnit.maxHealth = playerUnit.currentHealth = Settings.PLAYER_UNIT_STARTING_HEALTH;
			playerUnit.isEnemy = false;
			return playerUnit;
		}
		
		private function onPlayerUnitVODataChange(e:DataChangeEvent):void {
			if (_playerProxy.playerVO.playerUnit.currentHealth <= 0) {
				// That's it man, game over man, game OVer!
				sendNotification(GAME_OVER);
			}
		}
	}
}




