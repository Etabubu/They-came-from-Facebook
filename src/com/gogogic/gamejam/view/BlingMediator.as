package com.gogogic.gamejam.view
{
	import com.gogogic.gamejam.model.vo.BonusVO;
	import com.gogogic.gamejam.view.components.BlingComponent;
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class BlingMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "BlindMediator";
		
		public static const SHOW_BLING:String = NAME + "ShowBling";
		
		private var _pendingBonuses:Vector.<BonusVO>;
		private var _isBusy:Boolean = false;
		
		public function BlingMediator(blingLayer:Sprite)
		{
			super(NAME, blingLayer);
			_pendingBonuses = new Vector.<BonusVO>();
		}
		
		override public function listNotificationInterests():Array {
			return [
				SHOW_BLING
			];
		}
		
		override public function handleNotification(notification:INotification):void {
			switch (notification.getName()) {
				case SHOW_BLING:
					showBling(notification.getBody() as BonusVO);
					break;
			}
		}
		
		public function get blingLayer():Sprite {
			return viewComponent as Sprite;
		}
		
		public function showBling(bonusVO:BonusVO):void {
			if (_isBusy) {
				_pendingBonuses.unshift(bonusVO);
				return;
			}
			
			_isBusy = true;
			TweenLite.delayedCall(1, onCooledDown);
			
			var blingComponent:BlingComponent = new BlingComponent(bonusVO);
			blingLayer.addChild(blingComponent);
			blingComponent.addEventListener(Event.COMPLETE, onBlingDone);
		}
		
		private function onBlingDone(e:Event):void {
			var blingComponent:BlingComponent = e.currentTarget as BlingComponent;
			blingComponent.removeEventListener(Event.COMPLETE, onBlingDone);
			blingLayer.removeChild(blingComponent);
		}
		
		private function onCooledDown():void {
			_isBusy = false;
			if (_pendingBonuses.length > 0) {
				showBling(_pendingBonuses.pop());
			}
		}
	}
}