/* AS3
	Copyright 2008
*/
package com.neopets.util.timer
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**
	 *	This class mimics timer behaviour but synches it's up to a target's enter frame
	 *  events.  This is mainly used to ensure that the timed events will not get out of 
	 *  synch with the animation frames if the system is running slowly.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern None
	 * 
	 *	@author David Cary
	 *	@since  9.8.2009
	 */
	public class FrameTimer extends EventDispatcher
	{
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var delay:Number;
		public var repeatCount:int;
		
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		protected var _frameSource:DisplayObject;
		protected var _currentCount:int;
		protected var _running:Boolean;
		protected var totalTime:Number;
		protected var msPerFrame:Number;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function FrameTimer(src:DisplayObject=null,time:Number=1000,reps:int = 0):void{
			frameSource = src;
			_currentCount = 0;
			_running = false;
			totalTime = 0;
			delay = time;
			repeatCount = reps;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * @Returns the object that's providing us with Enter Frame events.
		 */
		
		public function get frameSource():DisplayObject{ return _frameSource; }
		
		/**
		 * @Sets the object that's providing us with Enter Frame events.
		 */
		
		public function set frameSource(src:DisplayObject){
			_frameSource = src;
			if(src != null) msPerFrame = 1000 / _frameSource.stage.frameRate;
			else msPerFrame = 1000;
		}
		
		/**
		 * @Returns the total number of times the timer has fired since it started at zero.
		 */
		
		public function get currentCount():int{ return _currentCount; }
		
		/**
		 * @Returns the timer's current state; true if the timer is running, otherwise false.
		 */
		
		public function get running():Boolean{ return _running; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Stops the timer, if it is running, and sets the currentCount property back 
		 * @to 0, like the reset button of a stopwatch.
		 */
		
		public function reset():void{
			stop();
			_currentCount = 0;
			totalTime = 0;
		}
		
		/**
		 * @Starts the timer, if it is not already running.
		 */
		
		public function start():void{
			if(!_running && _frameSource != null) {
				_currentCount = 0;
				totalTime = 0;
				_running = true;
				_frameSource.addEventListener(Event.ENTER_FRAME,onFrameEvent);
			}
		}
		
		/**
		 * @Stops the timer.
		 */
		
		public function stop():void{
			if(_running) {
				if(_frameSource != null) {
					_frameSource.removeEventListener(Event.ENTER_FRAME,onFrameEvent);
				}
				_running = false;
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Stops the timer.
		 */
		
		public function onFrameEvent(ev:Event):void{
			totalTime += msPerFrame;
			if(totalTime >= delay) {
				totalTime -= delay;
				dispatchEvent(new TimerEvent(TimerEvent.TIMER));
				if(repeatCount > 0) {
					_currentCount++;
					if(_currentCount >= repeatCount) {
						dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
						stop();
					}
				}
			}
		}
		
	}
}
