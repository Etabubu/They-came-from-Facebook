package com.gogogic.gamejam.model
{
	import com.gogogic.gamejam.Settings;
	import com.gogogic.gamejam.model.vo.FriendVO;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class FriendsProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "FriendsProxy";
		
		public static const FRIEND_LIST_LOADED:String = NAME + "FriendListLoaded";
		
		private var _friends:Vector.<FriendVO>;
		private var _enemies:Vector.<FriendVO>;
		
		public function FriendsProxy()
		{
			super(NAME);
		}
		
		public function loadFriends():void {
			// TODO: Start loading friends
			onFriendsLoaded();
		}
		
		private function onFriendsLoaded():void {
			var allFriends:Vector.<FriendVO> = new Vector.<FriendVO>();
			
			_enemies = new Vector.<FriendVO>();
			_friends = new Vector.<FriendVO>();
			
			// TODO: populate friends
			
			
			// ----- DEBUG DATA ---------------------
			var dummyFriend:FriendVO = new FriendVO();
			dummyFriend.id = 644779038;
			dummyFriend.name = "Ari";
			dummyFriend.portraitUrl = "http://profile.ak.fbcdn.net/hprofile-ak-snc4/hs1283.snc4/173424_644779038_242735_q.jpg";
			
			var dummyFriend2:FriendVO = new FriendVO();
			dummyFriend2.id = 699804391;
			dummyFriend2.name = "Jonathan";
			dummyFriend2.portraitUrl = "http://profile.ak.fbcdn.net/hprofile-ak-snc4/hs1319.snc4/161115_699804391_191693_q.jpg";
			
			allFriends.push(dummyFriend);
			allFriends.push(dummyFriend2);
			// --------------------------------------
			
			
			
			// Get minimum friend count with dummies if necessary
			while (allFriends.length < 2)
				allFriends.push(createDummyFriend());
			
			// Shuffle
			var shuffledFriends:Vector.<FriendVO> = new Vector.<FriendVO>();
			while (allFriends.length > 0)
				shuffledFriends.push(allFriends.splice(Math.round(Math.random() * (allFriends.length - 1)), 1)[0]);
			
			var enemyCount:int = allFriends.length > Settings.MAX_FRIENDS_ON_TEAM * 2 ?
				allFriends.length - Settings.MAX_FRIENDS_ON_TEAM :
				Math.floor(shuffledFriends.length / 2);
			// Hand out friends to user and enemy
			for (var i:int = 0; i < shuffledFriends.length; i++) {
				if (i < enemyCount)
					_enemies.push(shuffledFriends[i]);
				else
					_friends.push(shuffledFriends[i]);
			}
			
			sendNotification(FRIEND_LIST_LOADED, { friends: friends, enemies: enemies });
		}
		
		public function get friends():Vector.<FriendVO> {
			return _friends;
		}
		
		public function get enemies():Vector.<FriendVO> {
			return _enemies;
		}
		
		private function createDummyFriend():FriendVO {
			// TODO: Randomize and populate friendVO before returning it
			return new FriendVO();
		}
	}
}