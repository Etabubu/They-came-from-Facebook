package com.gogogic.gamejam.view
{
	import com.facebook.graph.Facebook;
	import com.facebook.graph.utils.FacebookDataUtils;
	import com.gogogic.gamejam.Settings;
	import com.gogogic.gamejam.model.FriendsProxy;
	import com.gogogic.gamejam.model.PlayerProxy;
	import com.gogogic.gamejam.model.vo.FriendVO;
	
	import flash.events.Event;
	
	import mx.core.mx_internal;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class MainMenuMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MainMenuMediator";
		
		public static const START_MAIN_GAME:String = NAME + "StartMainGame";
		public static const FACEBOOK_READY:String = NAME + "FacebookReady";
		
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
				// TODO: handle facebook permissions/login
				//while(Facebook.getSession() == null) {
					//ExternalInterface.call("redirect","THE APPLICATION ID", "user_birthday,read_stream,publish_stream","http://apps.facebook.com/THE CANVAS PAGE/");
				//}
				
				// if login/auth fail - keep prompting.
				//Facebook.init(
				// if logged in
				//friendsProxy.loadFriends();
				// TODO: Disable start game button
				// TODO: Show a message in main menu view that it is loading the friends
				
				
				
				//var topURL:String=Facebook.ExternalInterface.call('top.location.toString');
				//if(topURL != "FACEBOOKURL") {
					// redirect to the Facebook app page
					
				//}
				
				
				//Facebook.login(facebookLoginHandler, {perms:"publish_stream,user_about_me,friends_about_me,user_relationships,user_relationship_details,friends_birthday,user_birthday,email"});
			}
			Facebook.init(Settings.FACEBOOK_APP_ID, facebookLoginHandler, {perms:Settings.FACEBOOK_PERMS});
			//Facebook.login(facebookLoginHandler, {perms:Settings.FACEBOOK_PERMS});
		}
		
		public function facebookLoginHandler(success:Object,fail:Object):void {
			trace("login handler got back", success, fail);
			if(fail == null && success && Facebook.getSession() != null) {
				// yay!
				//Facebook.api("/me/feed",facebookSubmitPostHandler,{message:"HAHA! I did it!"}, "POST");
				trace("session uid: ", Facebook.getSession().uid);
				
				// now that we have the facebook api lets load the friends
				sendNotification(FACEBOOK_READY);
				//(facade.retrieveProxy(FriendsProxy.NAME) as FriendsProxy).loadFriends();
				(facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy).loadPlayer();
				
				Facebook.setCanvasAutoResize();
				//trace(Facebook.getImageUrl("/me/picture/"));
			} else {
				// keep prompting them
				Facebook.login(facebookLoginHandler, {perms:Settings.FACEBOOK_PERMS});
			}
		}
		
		public function getPicture(success:Object, fail:Object):void {
			trace(success, fail);
			if(success) {
				
			}
		}
		
		public function facebookSubmitPostHandler(success:Object,fail:Object):void {
			trace("submit post handler got back", success, fail);
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
					break;
			}
		}
		
		private function friendsLoaded():void {
			mainMenuView.doneLoadingFacebook();
			mainMenuView.addEventListener(MainMenuView.START_CLICKED, onStartClicked);
		}
		
		private function onStartClicked(e:Event):void {
			sendNotification(START_MAIN_GAME);
		}
	}
}