package com.gogogic.gamejam.view.components
{
	import com.gogogic.dragmanager.DragManager;
	import com.gogogic.dragmanager.DragSource;
	import com.gogogic.dragmanager.events.DragEvent;
	import com.gogogic.gamejam.Settings;
	import com.gogogic.gamejam.model.FriendDeck;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
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
			
			// Add the first card and start the timer
			addFriendCard();
			
			addChild(_coolDownComponent = new CooldDownComponent());
			_coolDownComponent.x = 695;
			_coolDownComponent.y = 60;
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
			var xPosition:Number = 10 + index * 120;
			addChild(newFriendCard);
			newFriendCard.x = xPosition;
		}
		
		private function onFriendCardMouseDown(e:MouseEvent):void {
			var friendCard:FriendCardComponent = e.currentTarget as FriendCardComponent;
			
			var coords:Point = localToGlobal(new Point(mouseX, mouseY));
			if (friendCard.discardButton.hitTestPoint(coords.x, coords.y, true)) {
				// Discard
				removeCard(friendCard);
			} else {
				// Drag
				var dragSource:DragSource = new DragSource();
				dragSource.addData(friendCard.friendVO, "friendCard");
				
				friendCard.alpha = .5;
				
				DragManager.getInstance().doDrag(friendCard, dragSource, null, new PortraitComponent(friendCard.friendVO.portraitUrl, 50));
				friendCard.addEventListener(DragEvent.DRAG_COMPLETE, onDragComplete);
			}
			
		}
		
		private function onDragComplete(e:DragEvent):void {
			var friendCard:FriendCardComponent = e.currentTarget as FriendCardComponent;
			friendCard.removeEventListener(DragEvent.DRAG_COMPLETE, onDragComplete);
			
			if (e.wasCancelled || e.action == DragManager.NONE) {
				// Not successfull
				friendCard.alpha = 1;
			} else {
				// Successfull
				removeCard(friendCard);
			}
		}
		
		private function onCooldownDone(e:Event):void {
			addFriendCard();
			if (friendsCardsAreFull) {
				_coolDownComponent.stop();
			}
		}
		
		private function removeCard(friendCard:FriendCardComponent):void {
			var wasFull:Boolean = friendsCardsAreFull;
			
			_friendCards[_friendCards.indexOf(friendCard)] = null;
			removeChild(friendCard);
			// It it was full (that causes the cooldown to stop), restart the cooldown
			if (wasFull)
				_coolDownComponent.start();
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