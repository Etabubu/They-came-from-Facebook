package com.gogogic.gamejam.view
{
	import com.gogogic.gamejam.model.FriendDeck;
	import com.gogogic.gamejam.model.FriendsProxy;
	import com.gogogic.gamejam.model.OppositionUnitProxy;
	import com.gogogic.gamejam.model.PlayerProxy;
	import com.gogogic.gamejam.model.vo.FriendVO;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class GameMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "GameMediator";
		
		private var _friendsProxy:FriendsProxy;
		private var _playerProxy:PlayerProxy;
		private var _oppositionProxy:OppositionUnitProxy;
		
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
			// Set up the opposition friendDeck by supplying the "enemy friends" to the opposition proxy
			_oppositionProxy.oppositionFriends = _friendsProxy.enemies;
			gameView.init(_playerProxy.playerVO, new FriendDeck(_friendsProxy.friends), _oppositionProxy.oppositionDeck);
			// Register the mediator for the game board
			facade.registerMediator(new GameBoardMediator(gameView.gameBoardComponent));
		}
	}
}