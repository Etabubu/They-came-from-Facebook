/* AS3
	Copyright 2008
*/
package com.neopets.util.display.scrolling
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import com.neopets.util.events.CustomEvent;
	
	/**
	 *	Horizontal Loops are Scrolling Loops that wrap around the left and right edges.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern None
	 * 
	 *	@author David Cary
	 *	@since  7.28.2009
	 */
	public class HorizontalLoop extends ScrollingLoop
	{
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function HorizontalLoop():void{
			super();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function adds a panel to the loop.
		 * @param		panel		DisplayObject 		Target panel to be added.
		 * @param		gap			Number 				Distance between panel edges.
		 */
		
		override public function addPanel(panel:DisplayObject,gap:Number=0):void{
			if(panel != null) {
				addChild(panel);
				// check our bounds
				var bb:Rectangle = panel.getBounds(this);
				// check if we have any other panels
				if(_contents.length < 1) {
					// if not, this panel sets our bounds
					minBound = bb.left;
					maxBound = bb.right + gap;
				} else {
					// if so, move this panel to the end
					var diff:Number = panel.x - bb.left;
					panel.x = maxBound + diff;
					maxBound += bb.width + gap;
				}
				if(bb.width > maxPanelSpan) maxPanelSpan = bb.width;
				_contents.push(new ScrolledItemData(panel));
			}
		}
		
		/**
		 * @This function adds a panel to the loop.
		 * @param		panel		DisplayObject 		Target panel to be removed
		 */
		
		override public function removePanel(panel:DisplayObject):void{
			if(panel == null) return;
			var entry:Object;
			for(var i:int = _contents.length-1; i >= 0; i--) {
				entry = _contents[i];
				if(entry.target == panel) {
					_contents.splice(i,1);
					maxBound -= panel.width;
					removeChild(panel);
				}
			}
		}
		
		/**
		 * @Use this function to perform any remain shift operations like moving bounds and wrapping.
		 * @param		dx		Number 		Distance along the x-axis we want to move.
		 * @param		dy		Number 		Distance along the y-axis we want to move.
		 */
		 
		override public function resolveShift(dx:Number,dy:Number):void{
			minBound -= dx;
			maxBound -= dx;
			// cycle through all panels
			var entry:Object;
			var wrap:Number;
			var ev:CustomEvent;
			for(var i:int = 0; i < _contents.length; i++) {
				entry = _contents[i];
				wrap = getWrapFor(entry.centerX,minBound,maxBound);
				if(wrap != 0) {
					entry.target.x += wrap;
					ev = new CustomEvent({container:this,target:entry.target,wrap_x:wrap},ScrollingObject.ON_WRAP);
					dispatchEvent(ev);
				}
			} // end of panel loop
		}
		
		/**
		 * @This function puts the target position in the center of our bounds.
		 * @param		pos		Number 		Position the bounds are to be centered around.
		 */
		
		override public function centerAround(pos:Number):void{
			var mid_bound:Number = (minBound + maxBound) / 2;
			var shift:Number = pos - mid_bound;
			minBound += shift;
			maxBound += shift;
			movePanelsBy(shift,0);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
