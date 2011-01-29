package com.gogogic.gamejam.view.components
{
	import com.gogogic.gamejam.Settings;
	import com.gogogic.ui.drawPieMask;
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class CooldDownComponent extends Sprite
	{
		private var _timer:Timer;
		private var _wasStopped:Boolean = false;
		
		public var timeLeft:Number;
		
		public function CooldDownComponent()
		{
			
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
			
			graphics.clear();
			graphics.beginFill(0);
			drawPieMask(graphics, scale, 50, 0, 0, -Math.PI/2, 20);
			graphics.endFill();
		}
	}
}