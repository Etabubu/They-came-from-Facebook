/* AS3
	Copyright 2008
*/
package com.neopets.util.display.scrolling
{
	import flash.utils.Timer;
	import com.neopets.util.timer.FrameTimer;
	import flash.events.TimerEvent;
	
	/**
	 *	This abstract class serves as the base class for all movieclips that support scrolling behaviour.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern None
	 * 
	 *	@author David Cary
	 *	@since  9.8.2009
	 */
	public class TimedScroll
	{
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public static var DEFAULT_FRAMERATE:Number = 30;
		
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		protected var _target:ScrollingObject;
		protected var xShift:Number;
		protected var yShift:Number;
		protected var _timer:Object;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function TimedScroll(scroller:ScrollingObject=null):void{
			_target = scroller;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * @Returns our current timed scrolling effect.
		 */
		
		public function get target():ScrollingObject{ return _target; }
		
		/**
		 * @Returns our current timed scrolling effect.
		 */
		
		public function set target(scroller:ScrollingObject){
			if(_timer != null) _timer.stop();
			_target = scroller;
		}
		
		/**
		 * @Returns our current timed scrolling effect.
		 */
		
		public function get timer():Object{ return _timer; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function sets up the needed scroll variables.
		 * @param		vx		Number 		X-axis movement per second.
		 * @param		vy		Number 		Y-axis movement per second.
		 * @param		time	Number 		Duration of movement. 0 = loop indefinately
		 * @param		freq	Number 		Updates per second. 0 = use framerate
		 * @param		frames	Boolean		Synch updates to this clip's frames.
		 */
		 
		public function init(vx:Number,vy:Number,time:Number=0,freq:Number=0,frames:Boolean=false):void{
			// make sure we have a target
			if(_target == null) return;
			// calculate delay based on frequency
			if(freq <= 0) {
				if(_target.stage != null) freq = _target.stage.frameRate;
				else freq = DEFAULT_FRAMERATE;
			}
			var delay:Number = 1000 / freq;
			// calculate movement per update
			// use negative values since shifts are opposite our scrolling direction 
			xShift = -vx / freq;
			yShift = -vy / freq;
			// calculate number of cycles needed to complete our movement
			var cycles:Number;
			if(time > 0) cycles = Math.ceil(freq * time);
			else cycles = 0;
			// create timer
			if(frames) {
				_timer = new FrameTimer(_target,delay,cycles);
			} else {
				_timer = new Timer(delay,cycles);
			}
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
		}
		
		/**
		 * @Tries to start the scroll timer.
		 */
		
		public function start():void{
			if(_timer != null) _timer.start();
		}
		
		/**
		 * @Tries to stop the scroll timer.
		 */
		
		public function stop():void{
			if(_timer != null) _timer.stop();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Scrolls the target each time the timer triggers.
		 */
		
		public function onTimer(ev:TimerEvent):void{
			if(_target != null) _target.shiftBy(xShift,yShift);
		}
		
	}
}
