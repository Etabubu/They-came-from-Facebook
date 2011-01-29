/* AS3
	Copyright 2009
*/
package com.neopets.util.servers
{
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.servers.ServerGroup;
	
	import flash.display.DisplayObject;
	
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
	public class ServerFinder extends Object 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _isOnline:Boolean;
		protected var _groups:Array;
		protected var _foundGroup:ServerGroup;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ServerFinder():void{
			super();
			_groups = new Array();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get isOnline():Boolean { return _isOnline; }
		
		public function get imageServer():String {
			if(_foundGroup != null) return _foundGroup.imageServer;
			else return "";
		}
		
		public function get scriptServer():String {
			if(_foundGroup != null) return _foundGroup.scriptServer;
			else return "";
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to figure out which server group the target display object should use.
		// The target server group is based on where the stage file was loaded from.
		// param	dobj		DisplayObject		Target display object.
		
		public function findServersFor(dobj:DisplayObject):void {
			useDefaults(); // reset to default values
			// find the url our stage was loaded from
			var url:String = DisplayUtils.getRootURL(dobj);
			// check if we have a valid url
			if(url != null) {
				// scan server group list
				var group:ServerGroup;
				for(var i:int = 0; i < _groups.length; i++) {
					group = _groups[i];
					// check if the url contains any of this group's servers as it's base url
					if(group.includesURL(url)) {
						_foundGroup = group;
						_isOnline = true;
						break;
					}
				} // end of scanning loop
			} // end of valid url check
		}
		
		// Use this function to fill out incomplete image urls.
		// param	ref		String			URL to be expanded.
		// param	dir		String			Default directory on image server.
		// param	ext		String			Default extension for the target file
		
		public function getImageURL(ref:String,dir:String=null,ext:String=null):String {
			// check for valid string
			if(ref == null || ref.length < 1) return null;
			// check if server has been set
			var url:String;
			if(ref.indexOf("://") < 0) {
				// if the server hasn't been set yet, do so now
				url = imageServer;
				// add default directory
				var last_char:String;
				if(dir != null) {
					last_char = url.charAt(url.length-1);
					if(last_char != "/") url += "/" + dir;
					else url += dir;
				}
				// add remainder of url
				last_char = url.charAt(url.length-1);
				if(last_char != "/") url += "/" + ref;
				else url += ref;
			} else url = ref;
			// check if the extension should be set
			if(ext != null) {
				var folders:Array = url.split("/");
				var file_name:String = folders[folders.length-1];
				if(file_name.indexOf(".") < 0) {
					if(ext.indexOf(".") < 0) url += "." + ext;
					else url += ext;
				}
			}
			return url;
		}
		
		// This function loads default values.
		
		public function useDefaults():void {
			_isOnline = false;
			_foundGroup = null;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
