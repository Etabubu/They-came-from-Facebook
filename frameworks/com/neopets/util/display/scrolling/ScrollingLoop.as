/* AS3
	Copyright 2008
*/
package com.neopets.util.display.scrolling
{
	import flash.display.DisplayObject;
	
	/**
	 *	ScrollingLoops are scroll objects that only wrap along one axis.  Each loop consist of
	 *  a series of panels connected in a line.  Wrapping happens at the edges of that line.
	 *  Loops will usually be created dynamically and will rarely be used as library item classes.
	 *  This class acts as an abstract class.  Use HorizontalLoop and VerticalLoop when creating objects.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern None
	 * 
	 *	@author David Cary
	 *	@since  7.28.2009
	 */
	public class ScrollingLoop extends ScrollingObject
	{
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		protected var _contents:Array;
		protected var minBound:Number;
		protected var maxBound:Number;
		protected var maxPanelSpan:Number;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ScrollingLoop():void{
			minBound = 0;
			maxBound = 0;
			maxPanelSpan = 0;
			_contents = new Array();
			super();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * @Returns the content list.
		 */
		
		public function get contents():Array{ return _contents; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function adds a panel to the loop.
		 * @param		panel		DisplayObject 		Target panel to be added.
		 * @param		gap			Number 				Distance between panel edges.
		 */
		
		public function addPanel(panel:DisplayObject,gap:Number=0):void{
			if(panel != null) {
				addChild(panel);
				_contents.push(new ScrolledItemData(panel));
			}
		}
		
		/**
		 * @This function sets up the loops panels.
		 * @param		pattern		XML 		Guidelines for each panel set added.
		 * @param		span		Number 		Minimum distance the panels should cover.
		 */
		
		public function buildLoop(pattern:XML,span:Number=0):void{
			clearLoop();
			// keep adding panel sets until the target span is covered or we fail to grow
			var prev_max:Number;
			do{
				prev_max = maxBound;
				buildPanels(pattern);
			}while(prev_max < maxBound && maxBound <= span + maxPanelSpan);
			// center the panels
			centerAround(span/2);
		}
		
		/**
		 * @This function tries creating a panel from xml data and adding it to the loop.
		 * @param		xml		XML 		Properties of the panel to be added.
		 */
		
		public function buildPanel(xml:XML):void{
			if(xml != null) {
				var inst:Object = getInstanceOf(xml.localName());
				if(inst != null && inst is DisplayObject) {
					var panel:DisplayObject = inst as DisplayObject;
					if("@x" in xml) panel.x = xml.@x;
					if("@y" in xml) panel.y = xml.@y;
					var gap:Number;
					if("@gap" in xml) gap = xml.@gap;
					else gap = 0;
					addPanel(panel,gap);
				}
			}
		}
		
		/**
		 * @This function tries adding a series of panels to the loop from xml data.
		 * @param		pattern		XML 		List of panels to be added.
		 */
		
		public function buildPanels(pattern:XML):void{
			var list:XMLList = pattern.children();
			var entry:XML;
			for(var i:int = 0; i < list.length(); i++) {
				entry = list[i];
				buildPanel(entry);
			}
		}
		
		/**
		 * @This function puts the target position in the center of our bounds.
		 * @param		pos		Number 		Position the bounds are to be centered around.
		 */
		
		public function centerAround(pos:Number):void{
		}
		
		/**
		 * @This removes all panels from the loop.
		 */
		
		public function clearLoop():void {
			var entry:Object;
			while(_contents.length > 0) {
				entry = _contents.pop();
				removeChild(entry.target);
			}
			minBound = 0;
			maxBound = 0;
			maxPanelSpan = 0;
		}
		
		/**
		 * @This function adds a panel to the loop.
		 * @param		panel		DisplayObject 		Target panel to be removed
		 */
		
		public function removePanel(panel:DisplayObject):void{
			if(panel == null) return;
			var entry:Object;
			for(var i:int = _contents.length-1; i >= 0; i--) {
				entry = _contents[i];
				if(entry.target == panel) {
					_contents.splice(i,1);
					removeChild(panel);
				}
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @This function passes on the scrollBy call to all child Scrolling Clips.
		 * @param		dx		Number 		Distance along the x-axis we want to move.
		 * @param		dy		Number 		Distance along the y-axis we want to move.
		 */
		 
		protected function movePanelsBy(dx:Number,dy:Number)
		{
			// shift contents
			var entry:Object;
			var panel:DisplayObject;
			for(var i:int = 0; i < _contents.length; i++) {
				entry = _contents[i];
				panel = entry.target;
				panel.x += dx;
				panel.y += dy;
			}
		}
		
	}
	
}
