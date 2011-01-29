package com.neopets.util.display
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import com.neopets.util.array.ArrayUtils;
	import flash.geom.Rectangle;
	
	/**
	 *	This class arranges display objects in a vertical list.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern ?
	 * 
	 *	@author David Cary
	 *	@since  6.16.2009
	 */
	public class ListPane extends MovieClip 
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const NO_ALIGN:int = 0;
		public static const LEFT_ALIGN:int = 1;
		public static const RIGHT_ALIGN:int = 2;
		public static const CENTER_ALIGN:int = 3;
		public static const LIST_UPDATED:String = "list_updated";
		
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		protected var _contents:Array;
		protected var contentBounds:Rectangle;
		protected var updateNeeded:Boolean;
		protected var _alignment:int;
		protected var _contentBacking:DisplayObject;
		protected var _padding:Number;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ListPane():void{
			_contents = new Array();
			updateNeeded = false;
			_alignment = NO_ALIGN;
			_padding = 4;
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			addEventListener(Event.ENTER_FRAME,update);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get alignment():int { return _alignment; }
		
		public function set alignment(val:int) {
			_alignment = val;
			updateNeeded = true;
		}
		
		public function get contentBacking():DisplayObject { return _contentBacking; }
		
		public function set contentBacking(dobj:DisplayObject) {
			_contentBacking = dobj;
			updateBacking();
		}
		
		public function get contents():Array { return _contents; }
		
		public function get padding():Number { return _padding; }
		
		public function set padding(val:Number) {
			// update the content area
			if(contentBounds != null) {
				var diff:Number = val - _padding;
				contentBounds.left -= diff;
				contentBounds.right += diff;
				contentBounds.top -= diff;
				contentBounds.bottom += diff;
			}
			_padding = val;
			updateBacking();
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Use this function to add contents to the end of the list.
		 * @param		item			* 		This is the display object to be added to the list.
		 * @param		top_gap			* 		This is used to set the spacing above the item.
		 * @param		bottom_gap		* 		This is used to set the spacing below the item.
		 */
		 
		public function addItem(item:DisplayObject,top_gap:Number=2,bottom_gap:Number=2):void
		{
			addItemAt(item,_contents.length,top_gap,bottom_gap);
		}
		
		/**
		 * @Use this function to add contents to the end of the list.
		 * @param		item			* 		This is the display object to be added to the list.
		 * @param		index			* 		This is where in the list the item should be placed.
		 * @param		top_gap			* 		This is used to set the spacing above the item.
		 * @param		bottom_gap		* 		This is used to set the spacing below the item.
		 */
		 
		public function addItemAt(item:DisplayObject,index:int,top_gap:Number=2,bottom_gap:Number=2):void
		{
			// abort if there is no item
			if(item == null) return;
			// make sure the item is one of our children
			if(item.parent != null) {
				if(item.parent != this) return; // don't add the item if we can't add it as a child
			} else addChild(item);
			// if this is a loader, make sure we update when it's done loading.
			if(item is Loader) {
				var ldr:Loader = item as Loader;
				ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,onUpdateTrigger);
			}
			// put the item into our content list
			var entry:Object = {item:item,top_space:top_gap,bottom_space:bottom_gap};
			ArrayUtils.insertIfAbsent(_contents,entry,index);
			updateNeeded = true;
		}
		
		/**
		 * @Use this function to take all contents from the pane.
		 */
		 
		public function clearItems():void
		{
			var entry:Object;
			while(_contents.length > 0) {
				entry = _contents.pop();
				removeChild(entry.item);
			}
			updateNeeded = true;
		}
		
		/**
		 * @Use this function to make the list update it's layout on the next frane.
		 */
		
		public function forceUpdate():void {
			updateNeeded = true;
		}
		
		/**
		 * @Use this function to retrieve an display object in the pane's content list
		 * @param		index			* 		This is the item's index in our content list.
		 */
		 
		public function getItemAt(index:int):DisplayObject
		{
			var entry:Object = getEntryAt(index);
			if(entry != null) return entry.item as DisplayObject;
			else return null;
		}
		
		/**
		 * @This function returns the content list index of the target item.  If the item is not on the 
		 * @list -1 is return, as with the getIndexOf function for Arrays.
		 * @param		item			* 		This is the display object to be added to the list.
		 */
		
		public function getItemIndex(item:DisplayObject):int {
			var entry:Object;
			for(var i:int = 0; i < _contents.length; i++) {
				entry = _contents[i];
				if(entry.item == item) return i;
			}
			return -1;
		}
		
		/**
		 * @Use this function to retrieve an entry in the pane's content list.
		 * @Entries include spacing data as well as a display object.
		 * @param		index			* 		This is the entry's index in our content list.
		 */
		 
		public function getEntryAt(index:int):Object
		{
			if(_contents.length <= 0) return null;
			index = ArrayUtils.getValidIndex(index,_contents);
			return _contents[index];
		}
		
		/**
		 * @Use this function to remove a specific item from the content list.
		 * @param		item			* 		This is the display object to be added to the list.
		 */
		
		public function removeItem(item:DisplayObject):void {
			// find the item's position in the content list
			var index:int = getItemIndex(item);
			// if the item is in the content list, remove it now
			if(index >= 0) {
				_contents.splice(index,1);
				removeChild(item);
				// update the remaining list elements
				updateNeeded = true;
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @This function is called when the pane is added to the stage.
		 */
		public function onAddedToStage(ev:Event):void
		{
			if(ev.target == this) {
				// check our contents
				var child:DisplayObject;
				for(var i:int = 0; i < numChildren; i++) {
					child = getChildAt(i);
					if(child.name == "backing_mc") {
						contentBacking = child;
						break;
					}
				}
				// remove listener
				removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			}
		}
		
		/**
		 * @This function is called every frame to make sure the pane stays up to date.
		 */
		public function update(ev:Event=null):void
		{
			// only make adjustments if something has changed
			if(updateNeeded) {
				// reposition the pane's contents
				contentBounds = new Rectangle();
				var ty:Number = 0;
				var entry:Object;
				var bb:Rectangle;
				var dx:Number;
				for(var i:int = 0; i < _contents.length; i++) {
					entry = _contents[i];
					// apply horizontal alignment
					bb = entry.item.getBounds(this);
					switch(_alignment) {
						case LEFT_ALIGN:
							dx = -bb.left;
							break;
						case RIGHT_ALIGN:
							dx = -bb.right;
							break;
						case CENTER_ALIGN:
							dx = (bb.left + bb.right) / -2;
							break;
						default:
							dx = 0;
					}
					if(dx != 0) {
						entry.item.x += dx;
						bb.x += dx;
					}
					// set the item's y position
					ty += entry.top_space;
					entry.item.y += ty - bb.top;
					// shift down the top y value for the next entry
					ty += bb.height + entry.bottom_space;
					// update the content bounds
					if(bb.left < contentBounds.left) contentBounds.left = bb.left;
					if(bb.right > contentBounds.right) contentBounds.right = bb.right;
					contentBounds.bottom = ty;
				}
				// apply padding
				contentBounds.left -= _padding;
				contentBounds.right += _padding;
				contentBounds.top -= _padding;
				contentBounds.bottom += _padding;
				// update content area backing
				updateBacking();
				// turn off updates until something else changes
				updateNeeded = false;
				dispatchEvent(new Event(LIST_UPDATED));
			}
		}
		
		/**
		 * @This function just gives use a way to trip the update request flag when certain events occur.
		 */
		public function onUpdateTrigger(ev:Event=null) {
			updateNeeded = true;
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @This function makes sure the backing image stays consistent with the content area.
		 */
		 protected function updateBacking():void {
			 if(_contentBacking == null || contentBounds == null) return;
			 // stretch the backing to our content area
			 _contentBacking.width = contentBounds.width;
			 _contentBacking.height = contentBounds.height;
			 // reposition our backing to overlap the content area
			 var bb:Rectangle = _contentBacking.getBounds(this);
			 _contentBacking.x += contentBounds.left - bb.left;
			 _contentBacking.y += contentBounds.top - bb.top;
		 }
		
	}
	
}