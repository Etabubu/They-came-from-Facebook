/**
 *	This class is used by BroadcasterClips to indirectly dispatch event while still keep track
 *  of the originator of the event.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  01.04.2010
 */

package com.neopets.util.events 
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.neopets.util.events.CustomEvent;
	
	public class BroadcastEvent extends CustomEvent
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _sender:Object;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function BroadcastEvent(caller:Object, type:String, srcData:Object=null, bubbles:Boolean=false, 
									   cancelable:Boolean=false):void {
			super(srcData,type,bubbles,cancelable);
			_sender = caller;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get sender():Object { return _sender; }
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------

	}
	
}