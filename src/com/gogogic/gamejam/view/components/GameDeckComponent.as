package com.gogogic.gamejam.view.components
{
	import com.gogogic.dragmanager.DragManager;
	import com.gogogic.dragmanager.DragSource;
	import com.gogogic.gamejam.Settings;
	import com.gogogic.gamejam.model.FriendDeck;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class GameDeckComponent extends Sprite
	{
		private var _friendDeck:FriendDeck;
		private var _coolDownComponent:CooldDownComponent;
		
		private var _friendCards:Vector.<FriendCardComponent>;
		
		public function GameDeckComponent(friendDeck:FriendDeck)
		{
			_friendDeck = friendDeck;
			init();
		}
		
		private function init():void {
			// Five slots
			_friendCards = new Vector.<FriendCardComponent>(5);
			
			addChild(_coolDownComponent = new CooldDownComponent());
			// Add the first card and start the timer
			addFriendCard();
			_coolDownComponent.addEventListener(Event.COMPLETE, onCooldownDone);
			_coolDownComponent.start();
		}
		
		private function addFriendCard():void {
			var newFriendCard:FriendCardComponent = new FriendCardComponent(_friendDeck.drawNext());
			// Find the first available index
			var index:int = 0;
			do {
				if (!_friendCards[index]) break;
			} while (index++ < _friendCards.length-1);
			
			_friendCards[index] = newFriendCard;
			newFriendCard.addEventListener(MouseEvent.MOUSE_DOWN, onFriendCardMouseDown);
			var xPosition:Number = index * 100;
			addChild(newFriendCard);
			newFriendCard.x = xPosition;
		}
		
		private function onFriendCardMouseDown(e:MouseEvent):void {
			var friendCard:FriendCardComponent = e.currentTarget as FriendCardComponent;
			var dragSource:DragSource = new DragSource();
			dragSource.addData(friendCard, "friendCard");
			
			DragManager.getInstance().doDrag(friendCard, dragSource, null, new FriendCardComponent(friendCard.friendVO));
		}
		
		private function onCooldownDone(e:Event):void {
			addFriendCard();
			if (friendsCardsAreFull) {
				_coolDownComponent.stop();
			}
		}
		
		private function get friendsCardsAreFull():Boolean {
			for (var i:int = 0; i < _friendCards.length; i++) {
				if (!_friendCards[i])
					return false;
			}
			return true;
		}
	}
}