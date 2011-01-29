package com.gogogic.gamejam.view
{
	import com.gogogic.gamejam.model.vo.FriendVO;
	import com.gogogic.gamejam.model.FriendsProxy;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class GameMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "GameMediator";
		
		private var _friends:Vector.<FriendVO>;
		private var _friendsProxy:FriendsProxy;
		
		public function GameMediator(gameView:GameView)
		{
			super(NAME, gameView);
		}
		
		public function get gameView():GameView {
			return viewComponent as GameView;
		}
		
		override public function onRegister():void {
			_friendsProxy = facade.retrieveProxy(FriendsProxy.NAME) as FriendsProxy;
			
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
					_friends = notification.getBody() as Vector.<FriendVO>;
					friendsLoaded();
					break;
			}
		}
		
		private function friendsLoaded():void {
			// TODO: Setup the game
		}
	}
}