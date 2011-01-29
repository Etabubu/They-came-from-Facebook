package com.gogogic.gamejam.view.events
{
	import com.gogogic.gamejam.model.vo.FriendVO;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	public class DropFriendEvent extends Event
	{
		public static const DROP_FRIEND:String = "dropFriend";
		
		public var friendVO:FriendVO;
		public var coordinates:Point;
		
		public function DropFriendEvent(type:String, friendVO:FriendVO, coordinates:Point, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.coordinates = coordinates;
			this.friendVO = friendVO;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			return new DropFriendEvent(type, friendVO, coordinates, bubbles, cancelable);
		}
	}
}