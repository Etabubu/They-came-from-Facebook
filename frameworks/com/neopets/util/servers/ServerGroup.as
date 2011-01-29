/* AS3
	Copyright 2009
*/
package com.neopets.util.servers
{
	
	/**
	 *	These objects are just wrappers for grouping linked server urls.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  4.12.2010
	 */
	public class ServerGroup extends Object 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		public var imageServer:String;
		public var scriptServer:String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ServerGroup(site:String,images:String,online:Boolean=true):void{
			super();
			scriptServer = site;
			imageServer = images;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// This function checks if the target url uses one our servers as it's base url.
		
		public function includesURL(url:String):Boolean {
			if(url == null || url.length <= 0) return false;
			if(url.indexOf(imageServer) == 0) return true;
			if(url.indexOf(scriptServer) == 0) return true;
			return false;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
