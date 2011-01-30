package com.gogogic.gamejam.view.components
{
	import com.gogogic.gamejam.assets.NextUp;
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
			addChild(_enemyContainer = new Sprite());
			var nextUp:NextUp = new NextUp();
			nextUp.y = -4;
			addChild(nextUp);
			draw();
		}

		public function draw():void {
			while (_enemyContainer.numChildren > 0)
				_enemyContainer.removeChildAt(0);
			
			for (var i:int = 0; i < 4; i++) {
				var enemyCard:EnemyCardComponent = new EnemyCardComponent(_friendDeck.getFriendOffset(i));
				enemyCard.x = 65 * i;
				enemyCard.y = 10 + 15 * i;
				_enemyContainer.addChild(enemyCard);
			}
		}
	}
}