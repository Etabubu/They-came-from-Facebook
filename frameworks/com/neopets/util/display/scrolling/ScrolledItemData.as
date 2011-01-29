/* AS3
	Copyright 2008
*/
package com.neopets.util.display.scrolling
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	/**
	 *	This class just acts as a way to attach offset values to content within a scrolling object.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern None
	 * 
	 *	@author David Cary
	 *	@since  7.28.2009
	 */
	dynamic public class ScrolledItemData
	{
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		protected var _target:DisplayObject;
		protected var _offset:Point;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 *  @param		obj		DisplayObject 		Content to be tracked.
		 *  @param		px		Number		 		X-axis offset of content.
		 *  @param		py		Number		 		Y-axis offset of content.
		 */
		public function ScrolledItemData(obj:DisplayObject):void{
			_offset = new Point();
			target = obj;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * @Returns this object's target.
		 */
		
		public function get target():DisplayObject{ return _target; }
		
		/**
		 * @Sets this object's target and updates the offsets.
		 * @param		obj		DisplayObject 		New target object
		 */
		
		public function set target(obj:DisplayObject):void{
			if(_target != obj) {
				_target = obj;
				if(_target != null && _target.parent != null) {
					var bb:Rectangle = _target.getBounds(_target.parent);
					var mid:Number = (bb.left + bb.right) / 2;
					_offset.x = mid - _target.x;
					mid = (bb.top + bb.bottom) / 2;
					_offset.y = mid - _target.y;
				} else {
					_offset.x = 0;
					_offset.y = 0;
				}
			}
		}
		
		/**
		 * @Returns this object's x-axis midpoint.
		 */
		
		public function get centerX():Number{
			if(_target != null) return _target.x + _offset.x;
			else return _offset.x;
		}
		
		/**
		 * @Returns this object's y-axis midpoint.
		 */
		
		public function get centerY():Number{
			if(_target != null) return _target.y + _offset.y;
			else return _offset.y;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Returns a string representation of this object.
		 */
		 
		 public function toString():String {
			 return "[" + _target + ", offset:" + _offset + "]";
		 }
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
