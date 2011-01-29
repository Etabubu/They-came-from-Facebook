/* AS3
	Copyright 2008
*/
package com.neopets.util.display.scrolling
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import com.neopets.util.loading.LoadingEngineXML;
	import com.neopets.util.loading.LoadedItem;
	import com.neopets.util.general.GeneralFunctions;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	/**
	 *	This abstract class serves as the base class for all movieclips that support scrolling behaviour.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern None
	 * 
	 *	@author David Cary
	 *	@since  7.28.2009
	 */
	public class ScrollingObject extends MovieClip
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const ON_WRAP:String = "on_scroll_wrap";
		public static const SHIFT_BY_ZERO:String = "shift_by_zero";
		public static const SCROLL_BOUND_HIT:String = "scroll_bound_hit";
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var scrollRatio:Number;
		public var loadingEngine:LoadingEngineXML;
		
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		protected var _scrolling:TimedScroll;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ScrollingObject():void{
			scrollRatio = 1;
			addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * @Returns our current timed scrolling effect.
		 */
		
		public function get scrolling():TimedScroll{ return _scrolling; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function adjusts a request shift by our scaling values.
		 * @Sub-classes can use this function to further adjust and constrain shift requests.
		 * @param		dx		Number 		Distance along the x-axis we want to move.
		 * @param		dy		Number 		Distance along the y-axis we want to move.
		 */
		 
		public function calculateShift(dx:Number,dy:Number):Point{
			if(scrollRatio != 1) return new Point(dx * scrollRatio,dy * scrollRatio);
			else return new Point(dx,dy);
		}
		
		/**
		 * @Use this function to perform any remain shift operations like moving bounds and wrapping.
		 * @param		dx		Number 		Distance along the x-axis we want to move.
		 * @param		dy		Number 		Distance along the y-axis we want to move.
		 */
		 
		public function resolveShift(dx:Number,dy:Number):void{}
		
		/**
		 * @This function tries create a new instance of the given class name.
		 * @param		id		String 		Name of the new instance's class.
		 */
		 
		public function getInstanceOf(id:String):Object{
			if(loadingEngine != null) {
				var itm:LoadedItem = loadingEngine.getLoaderObjmID(id);
				if(itm != null) return itm.getObjectOutofLibrary(id);
			} else return GeneralFunctions.getInstanceOf(id);
			return null;
		}
		
		/**
		 * @"Scrolling" the clip moves it's contents opposite the direction we're moving.
		 * @For example, scrolling down a page moves it's content upward and vice versa.
		 * @param		dx		Number 		Distance along the x-axis we want to move.
		 * @param		dy		Number 		Distance along the y-axis we want to move.
		 */
		 
		public function scrollBy(dx:Number,dy:Number):void{
			shiftBy(-dx,-dy);
		}
		
		/**
		 * @This function moves the clip's children by a set amount in the target direction.
		 * @param		dx		Number 		Distance along the x-axis we want to move.
		 * @param		dy		Number 		Distance along the y-axis we want to move.
		 */
		 
		public function shiftBy(dx:Number,dy:Number):void{
			var shift:Point = calculateShift(dx,dy);
			if(shift.x != 0 || shift.y != 0) {
				// When setting x and y value on a movie clip, flash sometimes adjusts decimal values.
				// For example, a shift of 1.333 may be rounded to 1.3.  As such, we'll need to check
				// our shift values against the actual amount the movie clip moved.
				var coord:Number = x;
				x = coord + shift.x;
				shift.x = x - coord;
				// repeat for y values
				coord = y;
				y = coord + shift.y;
				shift.y = y - coord;
				if(shift.x != 0 || shift.y != 0) {
					// if our mask is also our child, keep it's position stable.
					if(mask != null && mask.parent == this) {
						mask.x -= shift.x;
						mask.y -= shift.y;
					}
					// apply sub-class specific reactions here
					resolveShift(shift.x,shift.y);
				} else dispatchEvent(new Event(SHIFT_BY_ZERO));
			}
		}
		
		/**
		 * @This function sets up automatic scrolling over a given time period, much like
		 / @a specialized type of tween.
		 * @param		vx		Number 		X-axis movement per second.
		 * @param		vy		Number 		Y-axis movement per second.
		 * @param		time	Number 		Duration of movement. 0 = loop indefinately
		 * @param		freq	Number 		Updates per second. 0 = use framerate
		 * @param		frames	Boolean		Synch updates to this clip's frames.
		 */
		 
		public function startScrolling(vx:Number,vy:Number,time:Number=0,freq:Number=0,frames:Boolean=false):void{
			if(_scrolling == null) _scrolling = new TimedScroll(this);
			else _scrolling.stop();
			_scrolling.init(vx,vy,time,freq,frames);
			_scrolling.start();
		}
		
		/**
		 * @This function turns off the automatic scrolling on this object.
		 */
		 
		public function stopScrolling():void{
			if(_scrolling != null) _scrolling.stop();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		/**
		 * @When the scrolling object is added to the stage, register it with the ScrollManager.
		 */
		
		public function onAddedToStage(ev:Event):void{
			if(ev.target == this) {
				ScrollManager.addEntry(this);
				removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
				addEventListener(Event.REMOVED_FROM_STAGE,onRemovedFromStage);
			}
		}
		
		/**
		 * @When the scrolling object is removed from the stage, take it out of the ScrollManager.
		 */
		
		public function onRemovedFromStage(ev:Event):void{
			if(ev.target == this) {
				ScrollManager.removeEntry(this);
				removeEventListener(Event.REMOVED_FROM_STAGE,onRemovedFromStage);
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @This function is used to calculate how far a coordinate should move to wrap
		 * @around the given bounds.
		 * @param		val		Number 		Value to be wrapped.
		 * @param		min		Number 		Lower boundary of wrap.
		 * @param		max		Number 		Upper boundary of wrap.
		 */
		 
		protected function getWrapFor(val:Number,min:Number,max:Number):Number{
			// make sure the min and max are valid
			if(min >= max) return 0;
			// check if the value is out of bounds
			var span:Number; // adjustment per loop
			var dist:Number; // distance from nearest boundary to position
			var loops:Number;
			if(val < min) {
				span = max - min;
				dist = min - val;
				if(dist > span) {
					loops = Math.floor(dist / span);
					return span * loops;
				} else return span;
			} else {
				if(val > max) {
					span = min - max;
					dist = max - val;
					if(dist < span) {
						loops = Math.floor(dist / span);
						return span * loops;
					} else return span;
				}
			}
			return 0;
		}
		
	}
	
}
