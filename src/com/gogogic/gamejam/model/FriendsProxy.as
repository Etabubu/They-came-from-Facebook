package com.gogogic.gamejam.model
{
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class FriendsProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "FriendsProxy";
		
		public static const FRIEND_LIST_LOADED:String = NAME + "FriendListLoaded";
		
		public function FriendsProxy()
		{
			super(NAME);
		}
		
		private function onFriendsLoaded():void {
			data = new Vector.<FriendVO>();
			
			// TODO: populate friends
			
			sendNotification(FRIEND_LIST_LOADED, data);
		}
		
		public function get friends():Vector.<FriendVO> {
			return data as Vector.<FriendVO>;
		}
	}
}