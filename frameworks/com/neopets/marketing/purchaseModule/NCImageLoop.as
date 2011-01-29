/* AS3
	Copyright 2009
*/
package com.neopets.marketing.purchaseModule
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import com.neopets.util.display.scrolling.HorizontalLoop;
	import com.neopets.util.display.scrolling.TimedScroll;
	import com.neopets.util.servers.NeopetsServerFinder;
	import com.neopets.util.servers.ServerFinder;
	
	/**
	 *	This class handles cycling though a list of loaded images.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  7.12.2010
	 */
	public class NCImageLoop extends HorizontalLoop 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _pendingList:Array;
		protected var _pendingLoader:Loader;
		protected var _contentIndex:int;
		protected var _displayTimer:Timer;
		protected var _readyToScroll:Boolean;
		protected var _scrollingEnabled:Boolean;
		public var servers:ServerFinder;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function NCImageLoop():void{
			super();
			// initialize variables
			_pendingList = new Array();
			_contentIndex = -1;
			_scrollingEnabled = false;
			// set up display timer
			_displayTimer = new Timer(1000,1);
			_displayTimer.addEventListener(TimerEvent.TIMER,onDisplayDone);
			// add mouse listeners
			addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get contentIndex():int { return _contentIndex; }
		
		public function set contentIndex(val:int) {
			_contentIndex = val;
			// start the countdown to scroll to the next image
			if(_contentIndex >= 0 && _contentIndex < _contents.length) _displayTimer.start();
		}
		
		public function get scrollingEnabled():Boolean { return _scrollingEnabled; }
		
		public function set scrollingEnabled(dobj:Boolean) {
			_scrollingEnabled = dobj;
			// if we've already gone past the scroll timer
			if(_scrollingEnabled && _readyToScroll) scrollImage();
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to add images to our pending urls list.
		
		public function loadImages(list:Array):void {
			// check for a valid list
			if(list == null) return;
			// initialize server finder
			if(servers == null) servers = new NeopetsServerFinder(this);
			// load new entries
			var entry:Object;
			var url:String;
			for(var i:int = 0; i < list.length; i++) {
				entry = list[i];
				url = servers.getImageURL(String(entry),"items","gif");
				_pendingList.push(url);
			}
			// start loading images
			loadNextImage();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// When the display timer runs out, start scrolling if possible.
		
		protected function onDisplayDone(ev:Event) {
			if(_scrollingEnabled) {
				scrollImage();
			} else {
				// track the fact the timer has finished
				_readyToScroll = true;
			}
		}
		
		// When a new image is loaded, add it as a new panel.
		
		protected function onImageLoaded(ev:Event):void {
			var info:LoaderInfo = ev.target as LoaderInfo;
			if(info == null) return;
			// push the completed loader into our line up
			var ev_loader:Loader = info.loader;
			if(ev_loader != null) {
				addPanel(ev_loader,1);
				// clear the pending loader entry
				if(ev_loader == _pendingLoader) _pendingLoader = null;
				// check if there are any which still need to be loaded
				if(_pendingList.length > 0) loadNextImage();
				else initLooping();
				// set our content index to the first item if not already set
				if(_contentIndex < 0) contentIndex = 0;
			}
		}
		
		// When the mouse rolls over our images, turn scrolling back on.
		
		protected function onMouseOver(ev:Event) {
			if(_pendingLoader == null) scrollingEnabled = true;
		}
		
		// When scrolling is done, start the display count down for the new image.
		
		protected function onScrollDone(ev:Event) {
			// mark the next item in the content list as our active image
			contentIndex = (_contentIndex + 1) % _contents.length;
			// if we've moved into the last slot, turn off scrolling
			var last_index:int = _contents.length - 1;
			if(_contentIndex >= last_index) scrollingEnabled = false;
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		// Use this function to start up image cycling once all images have been loaded.
		
		protected function initLooping():void {
			// shift scroll bounds over by half a panel
			var shift:Number = Math.floor(maxPanelSpan / -2);
			minBound += shift;
			maxBound += shift;
			// turn on scrolling
			scrollingEnabled = true;
		}
		
		// This function tries loading the next image of our pending urls list.
		
		protected function loadNextImage():void {
			// abort if a load is already in progress or if there are no more urls to load
			if(_pendingLoader != null || _pendingList.length <= 0) return;
			// set up a new loader
			_pendingLoader = new Loader();
			_pendingLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onImageLoaded);
			var url:String = _pendingList.shift();
			var req:URLRequest = new URLRequest(url);
			_pendingLoader.load(req);
		}
		
		// This function scrolls past the current image and bring up the next one.
		
		protected function scrollImage():void {
			// cancel loop if we don't have at least 2 images.
			if(_contents.length < 2) return;
			// scroll to left by the current image's width over 1 second
			if(_contentIndex >= 0 && _contentIndex < _contents.length) {
				// extract scrolling data info for the current index
				var info:Object = _contents[_contentIndex];
				if(info != null) {
					// use the target's width to set up scroll distance
					var shift:Number = Math.ceil(info.target.width) + 1;
					startScrolling(shift,0,1);
					_scrolling.timer.addEventListener(TimerEvent.TIMER_COMPLETE,onScrollDone);
				}
			}
			// delay the next scroll until after the next image is shown
			_readyToScroll = false;
		}
		
	}
	
}
