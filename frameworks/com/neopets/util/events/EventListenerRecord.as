
/* AS3
	Copyright 2008
*/

package com.neopets.util.events 
{
	import flash.events.EventDispatcher;
	
	/**
	 *	This class tracks the parameters of an addEventListener request needed to make a 
	 *  corresponding removeEventListener call.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  05.06.2010
	 */
	 
	public class EventListenerRecord extends Object
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		public var dispatcher:EventDispatcher;
		public var type:String;
		public var listener:Function;
		public var useCapture:Boolean;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function EventListenerRecord(disp:EventDispatcher=null,id:String=null,func:Function=null,
											capture:Boolean=false):void{
			super();
			dispatcher = disp;
			type = id;
			listener = func;
			useCapture = capture;
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
		
	}
	
}
