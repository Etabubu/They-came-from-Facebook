package com.gogogic.gamejam.model
{
	import com.adobe.utils.DateUtil;
	import com.facebook.graph.Facebook;
	import com.facebook.graph.utils.FacebookDataUtils;
	import com.gogogic.gamejam.Settings;
	import com.gogogic.gamejam.enum.Gender;
	import com.gogogic.gamejam.model.vo.FriendVO;
	import com.gogogic.gamejam.model.vo.PlayerVO;
	
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
			Facebook.api("/me/friends", facebookFriendsCallback, {fields:"id,first_name,last_name,name,picture,gender"}); //,birthday
		}
		
		public function facebookFriendsCallback(success:Object, fail:Object):void {
			if(success){
				onFriendsLoaded(success);
			} else {
				trace("facebookFriendsCallback failed", success, fail);
				loadFriends(); // try again
			}
		}
		
		private function onFriendsLoaded(facebookFriends:Object):void {
			var allFriends:Vector.<FriendVO> = new Vector.<FriendVO>();
			
			_enemies = new Vector.<FriendVO>();
			_friends = new Vector.<FriendVO>();
			
			var playerVO:PlayerVO = (facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy).playerVO;
			
			// populate friends
			var friendCount:int = 0;
			for each(var facebookFriend:Object in facebookFriends) {
				friendCount++;
				if(friendCount > 2000) break; // not likely but let's make sure this doesn't get out of hand
				
				var newFriend:FriendVO = new FriendVO();
				
				newFriend.id = facebookFriend.id;
				newFriend.firstName = facebookFriend.first_name;
				newFriend.lastName = facebookFriend.last_name;
				newFriend.name = facebookFriend.name;
				newFriend.portraitUrl = facebookFriend.hasOwnProperty("picture") ? facebookFriend.picture : Settings.PLACEHOLDER_IMAGE_URL;
				newFriend.gender = (facebookFriend.hasOwnProperty("gender") && facebookFriend.gender == Gender.MALE ? Gender.MALE : Gender.FEMALE);
				
				for each(var developer:Object in Settings.DEVELOPERS) {
					if(developer.id == newFriend.id) newFriend.developer = true;
				}
				
				//if(facebookFriend.hasOwnProperty("birthday"))
				//	if(new String(facebookFriend.birthday).length == 10)
				//		newFriend.age = ( new Date() - new Date(facebookFriend.birthday) ).fullYear();
				
				// relationship
				if(playerVO.family[newFriend.id]) {
					newFriend.relationship = playerVO.family[newFriend.id];
				}
				
				// assign unit type (class)
				(facade.retrieveProxy(UnitTypeProxy.NAME) as UnitTypeProxy).assignUnitType(newFriend);
				
				// assign bonuses
				(facade.retrieveProxy(BonusProxy.NAME) as BonusProxy).assignBonuses(newFriend);
				
				newFriend.energyCost = Math.random()*8000+650;
				
				allFriends.push(newFriend);
			}
			
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
		
		private var friendOne:Boolean = true;
		private function createDummyFriend():FriendVO {
			var dummyFriend:FriendVO = new FriendVO();;
			if(friendOne) {
				dummyFriend.id = 644779038;
				dummyFriend.firstName = "Ari";
				dummyFriend.lastName = "Arnbjörnsson";
				dummyFriend.portraitUrl = Settings.PLACEHOLDER_IMAGE_URL;
				dummyFriend.gender = Gender.MALE;
				dummyFriend.developer = true;
			} else {
				dummyFriend.id = 699804391;
				dummyFriend.firstName = "Jonathan";
				dummyFriend.lastName = "Osborne";
				dummyFriend.portraitUrl = Settings.PLACEHOLDER_IMAGE_URL;
				dummyFriend.gender = Gender.MALE;
				dummyFriend.developer = true;
			}
			friendOne = (! friendOne);
			
			return dummyFriend;
		}
	}
}