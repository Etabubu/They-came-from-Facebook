package com.gogogic.gamejam.view.components
{
	import com.gogogic.gamejam.model.FriendDeck;
	import com.gogogic.gamejam.model.vo.FriendVO;
	
	import flash.display.Sprite;
	
	public class EnemyDeckComponent extends Sprite
	{
		private var _friendDeck:FriendDeck;
		private var _enemyContainer:Sprite;
		
		public function EnemyDeckComponent(friendDeck:FriendDeck)
		{
			_friendDeck = friendDeck;
			init();
		}

		public function draw():void {
			while (_enemyContainer.numChildren > 0)
				_enemyContainer.removeChildAt(0);
			
			for (var i:int = 0; i < 4; i++) {
				var friendVO:FriendVO = _friendDeck.getFriendOffset(i);
				if (friendVO) {
					
				}
			}
		}
	}
}