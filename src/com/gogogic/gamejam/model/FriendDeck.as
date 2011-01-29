package com.gogogic.gamejam.model
{
	import com.gogogic.gamejam.model.vo.FriendVO;

	public class FriendDeck
	{
		private var _friends:Vector.<FriendVO>;
		private var _discarded:Vector.<FriendVO>;
		
		public function FriendDeck(friends:Vector.<FriendVO>)
		{
			if (!friends || friends.length == 0)
				throw new Error("Error, no friends provided");
			
			_friends = friends;
		}
		
		public function drawNext():FriendVO {
			var drawnFriend:FriendVO = _friends.pop();
			_discarded.push(drawnFriend);
			
			if (_friends.length == 0)
				restockFriends();
			
			return drawnFriend;
		}
		
		/**
		 * Returns the offset friend in the deck. If the offset is more than what is left of the deck, null is returned. 
		 * @param offset	The offset of the FriendVO to get.
		 * @return The FriendVO with the specified offset if available, otherwise null.
		 */
		public function getFriendOffset(offset:int):FriendVO {
			if (offset >= _friends.length)
				return null;
			return _friends[_friends.length - 1 - offset];
		}
		
		public function get countLeft():int {
			return _friends.length;
		}
		
		private function restockFriends():void {
			while (_discarded.length > 0) {
				_friends.push(_discarded.splice(Math.round(Math.random() * (_discarded.length - 1)), 1)[0]);
			}
		}
	}
}