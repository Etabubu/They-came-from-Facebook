
/* AS3
	Copyright 2008
*/

package com.neopets.util.display
{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	import com.neopets.util.display.DisplayUtils;
	
	import com.neopets.util.events.BroadcastEvent;
	import com.neopets.util.events.EventListenerRecord;
	
	/**
	 *	This class lets you send an event up the display object tree.
	 *  This can also be used to attach event listeners to an ancestor in the 
	 *  display object tree.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  05.04.2010
	 */
	 
	public class BroadcasterClip extends MovieClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		public var defaultDispatcher:EventDispatcher;
		protected var _pendingClass:Class;
		protected var _pendingListeners:Array;
		protected var _parentListeners:Array;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function BroadcasterClip():void{
			super();
			_pendingListeners = new Array();
			_parentListeners = new Array();
			// set up listeners
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to route a message through our shared dispatcher.
		// param	type		String				Event type indentifier.
		// param	info		Object				Optional parameter for passing out extra data.
		// param	dispatcher	EventDispatcher		Target dispatcher the event is sent through.
		// param	bubbles		Boolean				As per the Event constructor.
		// param	cancelable	Boolean				As per the Event constructor.
		
		public function broadcast(type:String,info:Object=null,dispatcher:EventDispatcher=null,
								  bubbles:Boolean=false,cancelable:Boolean=false):void {
			// build broadcast
			var transmission:BroadcastEvent = new BroadcastEvent(this,type,info,bubbles,cancelable);
			// redirect through target
			if(dispatcher != null) {
				dispatcher.dispatchEvent(transmission);
			} else {
				// if no dispatcher was provided, try using our default.
				if(defaultDispatcher != null) {
					defaultDispatcher.dispatchEvent(transmission);
				} else {
					// otherwise, send the event out ourselves
					dispatchEvent(transmission);
				}
			} // end of target dispatcher check
		}
		
		// Display Object Tree Functions
		
		// Use this function to attach an event listener to the first member of the target class
		// in our parent list.
		// param	class_def		Class		Class definition for the target object.
		// All other parameters are inheritted from the addEventListener function.
		
		public function addParentListener(class_def:Class,type:String,listener:Function,useCapture:Boolean=false,
										  priority:int=0,useWeakReference:Boolean=true):void {
			// check if this object has been added to the stage
			if(stage != null) {
				var dispatcher:EventDispatcher = DisplayUtils.getAncestorInstance(this,class_def) as EventDispatcher;
				if(dispatcher != null) {
					dispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
					// make a record of the listener for later removal
					var record:EventListenerRecord = new EventListenerRecord(dispatcher,type,listener,useCapture);
					_parentListeners.push(record);
				}
			} else {
				// push listener request
				_pendingListeners.push(arguments);
				addEventListener(Event.ADDED_TO_STAGE,onParentCheck);
			}
		}
		
		// This function removes all recorded event listeners attached to parent objects.
		
		public function clearParentListener():void {
			var record:EventListenerRecord;
			var dispatcher:EventDispatcher;
			while(_parentListeners.length > 0) {
				record = _parentListeners.pop();
				dispatcher = record.dispatcher;
				if(dispatcher != null) {
					dispatcher.removeEventListener(record.type,record.listener,record.useCapture);
				}
			}
		}
		
		// Use this function to get our record of the given event listener which has been attached
		// to a higher level of the display object tree.
		// param	class_def		Class		Class definition for the target object.
		// All other parameters are inheritted from the removeEventListener function.
		
		public function getParentListenerRecord(class_def:Class,type:String,listener:Function,
												useCapture:Boolean=false):EventListenerRecord {
			var record:EventListenerRecord;
			for(var i:int = 0; i < _parentListeners.length; i++) {
				record = _parentListeners[i];
				if(record.dispatcher is class_def) {
					if(record.type == type && record.listener == listener && record.useCapture == useCapture) {
						return record;
					}
				}
			} // end of loop
			return null;
		}
		
		// Use this function to remove an event listener added through the addParentListener function.
		// param	class_def		Class		Class definition for the target object.
		// All other parameters are inheritted from the removeEventListener function.
		
		public function removeParentListener(class_def:Class,type:String,listener:Function,
											 useCapture:Boolean=false):EventListenerRecord {
			var record:EventListenerRecord = getParentListenerRecord(class_def,type,listener,useCapture);
			// if the record was found, remove it and it's associated listener now
			if(record != null) {
				// clear listener
				var dispatcher:EventDispatcher = record.dispatcher;
				if(dispatcher != null) {
					dispatcher.removeEventListener(record.type,record.listener,record.useCapture);
				}
				// remove record from list
				var index:int = _parentListeners.indexOf(record);
				_parentListeners.splice(index,1);
			}
			return record;
		}
		
		// Use this function to use a containing display object of the target class as 
		// our default dispatcher.
		// param	class_def		Class		Class definition for the target object.
		
		public function useParentDispatcher(class_def:Class):void {
			// check if this object has been added to the stage
			if(stage != null) {
				defaultDispatcher = DisplayUtils.getAncestorInstance(this,class_def);
			} else {
				_pendingClass = class_def;
				addEventListener(Event.ADDED_TO_STAGE,onParentCheck);
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// This function is called when added to stage to use a containing display object as 
		// our shared dispatcher.
		
		protected function onParentCheck(ev:Event) {
			if(ev.target ==  this) {
				// check for a default dispatcher request
				if(_pendingClass != null) {
					defaultDispatcher = DisplayUtils.getAncestorInstance(this,_pendingClass);
				}
				// check for listener requests
				applyPendingListeners();
				// remove listener
				removeEventListener(Event.ADDED_TO_STAGE,onParentCheck);
			}
		}
		
		// This function cleans up our links when we're taken off stage.
		
		protected function onRemoved(ev:Event) {
			if(ev != null && ev.target == this) {
				defaultDispatcher = null;
				// strip out all recorded parent listeners
				clearParentListener();
				// remove all other listeners
				removeEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		// This function tries to attach all pending listener calls to an appropriate dispatcher.
		
		protected function applyPendingListeners():void {
			// process all pending listener requests
			var params:Array;
			while(_pendingListeners.length > 0) {
				params = _pendingListeners.shift();
				if(stage != null) addParentListener.apply(this,params);
			}
		}
		
	}
	
}
