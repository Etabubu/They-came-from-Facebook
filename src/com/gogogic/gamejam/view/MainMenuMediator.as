package com.gogogic.gamejam.view
{
	import com.gogogic.gamejam.model.FriendsProxy;
	import com.gogogic.gamejam.model.vo.FriendVO;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class MainMenuMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MainMenuMediator";
		
		public static const START_MAIN_GAME:String = NAME + "StartMainGame";
		
		private var _friends:Vector.<FriendVO>;
		
		public function MainMenuMediator(mainMenuView:MainMenuView)
		{
			super(NAME, mainMenuView);
		}
		
		override public function onRegister():void {
			var friendsProxy:FriendsProxy = facade.retrieveProxy(FriendsProxy.NAME) as FriendsProxy;
			if (friendsProxy.friends) {
				friendsLoaded();
			} else {
				friendsProxy.loadFriends();
				// TODO: Disable start game button
				// TODO: Show a message in main menu view that it is loading the friends
			}
		}
		
		public function get mainMenuView():MainMenuView {
			return viewComponent as MainMenuView;
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
					sendNotification(START_MAIN_GAME);
					break;
			}
		}
		
		private function friendsLoaded():void {
			// TODO: Enable start game button
			// TODO: Show in main menu view that the friends have been loaded
		}
	}
}