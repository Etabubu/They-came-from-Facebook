/* AS3
	Copyright 2009
*/
package com.neopets.util.servers
{
	import flash.display.DisplayObject;
	
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.servers.ServerGroup;
	
	/**
	 *	This class extracts the script server and image server from a display object's root url.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  4.12.2010
	 */
	public class NeopetsServerFinder extends ServerFinder 
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
		public function NeopetsServerFinder(dobj:DisplayObject=null):void{
			super();
			_groups = new Array();
			_groups.push(new ServerGroup("http://dev.neopets.com","http://images50.neopets.com"));
			_groups.push(new ServerGroup("http://www.neopets.com","http://images.neopets.com"));
			// if a display object is provided, initialize our server from that object.
			if(dobj != null) findServersFor(dobj);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// This function loads default values.
		
		override public function useDefaults():void {
			_isOnline = false;
			_foundGroup = _groups[0];
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
