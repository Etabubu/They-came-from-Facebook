package com.gogogic.gamejam.model
{
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import com.gogogic.gamejam.model.vo.FriendVO;
	
	public class FriendsProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "FriendsProxy";
		
		public static const FRIEND_LIST_LOADED:String = NAME + "FriendListLoaded";
		
		public function FriendsProxy()
		{
			super(NAME);
		}
		
		public function loadFriends():void {
			// TODO: Start loading friends
			onFriendsLoaded();
		}
		
		private function onFriendsLoaded():void {
			data = new Vector.<FriendVO>();
			
			// TODO: populate friends
			
			var dummyFriend:FriendVO = new FriendVO();
			dummyFriend.id = 644779038;
			dummyFriend.name = "Ari Þór H. Arnbjörnsson";
			dummyFriend.portraitUrl = "http://profile.ak.fbcdn.net/hprofile-ak-snc4/hs1283.snc4/173424_644779038_242735_q.jpg";
			
			friends.push(dummyFriend);
			
			sendNotification(FRIEND_LIST_LOADED, data);
		}
		
		public function get friends():Vector.<FriendVO> {
			return data as Vector.<FriendVO>;
		}
	}
}