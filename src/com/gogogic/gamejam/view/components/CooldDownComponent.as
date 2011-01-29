package com.gogogic.gamejam.view.components
{
	import com.gogogic.gamejam.Settings;
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class CooldDownComponent extends Sprite
	{
		private var _timer:Timer;
		
		public var timeLeft:Number;
		
		public function CooldDownComponent()
		{
			
		}
		
		public function start():void {
			timeLeft = Settings.COOLDOWN_TIME;
			TweenLite.to(this, Settings.COOLDOWN_TIME / 1000, { timeLeft: 0, onComplete: onCooldownFinished, onProgress: onTimeProgress });
			onTimeProgress();
		}
		
		public function stop():void {
			TweenLite.killTweensOf(this);
		}
		
		private function onCooldownFinished():void {
			dispatchEvent(new Event(Event.COMPLETE));
			start();
		}
		
		private function onTimeProgress():void {
			var scale:Number = Settings.COOLDOWN_TIME / timeLeft;
			// TODO: Draw the progress
		}
	}
}