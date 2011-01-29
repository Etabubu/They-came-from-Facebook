package com.gogogic.gamejam.view
{
	import com.gogogic.gamejam.Application;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PopupMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PopupMediator";
		
		public static const SHOW_POPUP:String = NAME + "ShowPopup";
		public static const SHOW_POPUP_TOPMOST:String = NAME + "ShowPopupTopmost";
		public static const REMOVE_POPUP:String = NAME + "RemovePopup";
		
		private var _currentPopups:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		private var _pendingPopups:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		
		private var _modalSprite:Sprite;
		
		public function PopupMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			init();
		}
		
		private function init():void {
			_modalSprite = new Sprite();
			_modalSprite.graphics.beginFill(0, 0);
			_modalSprite.graphics.drawRect(0, 0, Application.APPLICATION_WIDTH, Application.APPLICATION_HEIGHT);
			_modalSprite.graphics.endFill();
		}
		
		override public function onRegister():void {
			
		}
		
		override public function listNotificationInterests():Array {
			return [
				PopupMediator.SHOW_POPUP,
				PopupMediator.REMOVE_POPUP,
				PopupMediator.SHOW_POPUP_TOPMOST
			];
		}
		
		override public function handleNotification(notification:INotification):void {
			switch (notification.getName()) {
				case PopupMediator.SHOW_POPUP:
					showPopup(notification.getBody() as DisplayObject, false);
					break;
				case PopupMediator.SHOW_POPUP_TOPMOST:
					showPopup(notification.getBody() as DisplayObject, true);
					break;
				case PopupMediator.REMOVE_POPUP:
					removePopup(notification.getBody() as DisplayObject);
					break;
			}
		}
		
		public function showPopup(popup:DisplayObject, forceOnTop:Boolean = false):void {
			if (!forceOnTop) { // If it is pendable
				// If there are any popups on the display list already
				if (_currentPopups.length > 0) {
					// Pend it
					_pendingPopups.unshift(popup);
				} else {
					// Otherwise just show it
					displayPopup(popup);
				}
			} else {
				// If it must be shown immediately (not pendable), just show it on top of the other ones
				displayPopup(popup);
			}
			
		}
		
		private function displayPopup(popup:DisplayObject):void {
			popupLayer.addChild(popup);
			popup.x = Application.APPLICATION_WIDTH / 2;
			popup.y = (Application.APPLICATION_HEIGHT - 120) / 2;
			popup.scaleX = popup.scaleY = 0.1;
			TweenLite.to(popup, .4, { scaleX: 1, scaleY: 1, ease: Back.easeOut });
			_currentPopups.unshift(popup);
			// Put the modal blocker under the top popup.
			if (_modalSprite.parent != popupLayer) {
				popupLayer.addChild(_modalSprite);
			}
			popupLayer.setChildIndex(_modalSprite, popupLayer.numChildren - 2);
		}
		
		public function removePopup(popup:DisplayObject):void {
			// It it is already on the display list
			if (_currentPopups.indexOf(popup) != -1) {
				// Remove it
				_currentPopups.splice(_currentPopups.indexOf(popup), 1);
				TweenLite.to(popup, .3, { scaleX: 0.1, scaleY: 0.1, ease: Back.easeIn,
					onComplete: onPopupTweenedOut, onCompleteParams: [popup] });
			}
				// Else, if it is pending
			else if (_pendingPopups.indexOf(popup) != -1) {
				// Stop pending it
				_pendingPopups.splice(_pendingPopups.indexOf(popup), 1);
			}
		}
		
		private function onPopupTweenedOut(popup:DisplayObject):void {
			popupLayer.removeChild(popup);
			
			if (_currentPopups.length > 0) { // If there are more popups
				popupLayer.setChildIndex(_modalSprite, popupLayer.numChildren - 2);
			} else if (_pendingPopups.length > 0) { // If there are no more popups on the display list but there are popups pending to be shown
				// Show the next pending popup
				showPopup(_pendingPopups.pop());
			} else {
				// No popups left, remove the modal sprite
				popupLayer.removeChild(_modalSprite);
			}
		}
		
		private function get popupLayer():Sprite {
			return viewComponent as Sprite;
		}
	}
}