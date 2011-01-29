
/* AS3
	Copyright 2008
*/
package com.neopets.util.events
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 *	This contains useful functions and Methods for manipulating events and event listeners.
	 *	Please use ASDocs if you can for your notes
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author David Cary
	 *	@since  06.22.2010
	 */
	 
	public class EventFunctions
	{
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function EventFunctions():void{}
	
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function remove the target listener from one dispatcher and adds a duplicate of it to another dispatcher.
		 * @param		src			EventDispatcher 	The dispatcher the listener is being taken from.
		 * @param		dest		EventDispatcher		The dispatcher the listener is being added to.
		 * @The remaining properties are inherited from the EventDispatcher.removeEventListener function.
		 */
		 
		public static function transferListener(src:EventDispatcher,dest:EventDispatcher,type:String,listener:Function,useCapture:Boolean=false):void 
		{
			if(src != null) src.removeEventListener(type,listener,useCapture);
			if(dest != null) dest.addEventListener(type,listener,useCapture,0,true);
		}
		
	}
	
}
