/* AS3
	Copyright 2009
*/
package com.neopets.marketing.purchaseModule
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import com.neopets.util.events.EventFunctions;
	import com.neopets.util.display.ListPane;
	
	/**
	 *	This class handles the content area for the purchase item pop up window.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  7.07.2010
	 */
	public class NCContentPane extends ListPane 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function NCContentPane():void{
			super();
			_alignment = CENTER_ALIGN;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		// Overriden so backing position and width does not change.  This is done to keep the content area properly
		// aligned with the pop up's title bar.
		
		override protected function updateBacking():void {
			if(_contentBacking == null || contentBounds == null) return;
			// stretch the backing to our content area
			//_contentBacking.width = contentBounds.width; // disabled in override
			_contentBacking.height = contentBounds.height;
			// reposition our backing to overlap the content area
			var bb:Rectangle = _contentBacking.getBounds(this);
			//_contentBacking.x += contentBounds.left - bb.left; // disabled in override
			_contentBacking.y += contentBounds.top - bb.top;
		 }
		
	}
	
}
