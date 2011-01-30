package com.gogogic.gamejam.view.components
{
	import com.gogogic.gamejam.Settings;
	import com.gogogic.gamejam.assets.FriendDeckGraphic;
	import com.gogogic.ui.drawPieMask;
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class CooldDownComponent extends Sprite
	{
		private var _timer:Timer;
		private var _wasStopped:Boolean = false;
		private var _overlayDeck:FriendDeckGraphic;
		private var _overlayDeckMask:Sprite;
		
		public var timeLeft:Number;
		
		public function CooldDownComponent()
		{
			var cardGraphic:FriendDeckGraphic = new FriendDeckGraphic();
			addChild(cardGraphic);
			addChild(_overlayDeck = new FriendDeckGraphic());
			_overlayDeck.blendMode = BlendMode.MULTIPLY;
			_overlayDeckMask = new Sprite();
			_overlayDeck.addChild(_overlayDeckMask);
			_overlayDeck.mask = _overlayDeckMask;
		}
		
		public function start():void {
			timeLeft = Settings.COOLDOWN_TIME;
			TweenLite.to(this, Settings.COOLDOWN_TIME / 1000, { timeLeft: 0, onComplete: onCooldownFinished, onUpdate: onTimeProgress, ease: Linear.easeNone });
			onTimeProgress();
		}
		
		public function stop():void {
			TweenLite.killTweensOf(this);
			_wasStopped = true;
		}
		
		private function onCooldownFinished():void {
			dispatchEvent(new Event(Event.COMPLETE));
			// If the timer was stopped during the event dispatching, do not start again.
			if (_wasStopped) {
				_wasStopped = false;
			} else {
				start();
			}
		}
		
		private function onTimeProgress():void {
			var scale:Number = timeLeft / Settings.COOLDOWN_TIME ;
			// TODO: Draw the progress
			
			_overlayDeckMask.graphics.clear();
			_overlayDeckMask.graphics.beginFill(0);
			drawPieMask(_overlayDeckMask.graphics, scale, 100, 0, 0, -Math.PI/2, 3);
			_overlayDeckMask.graphics.endFill();
		}
	}
}