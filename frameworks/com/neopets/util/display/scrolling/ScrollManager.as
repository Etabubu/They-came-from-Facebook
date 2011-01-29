/* AS3
	Copyright 2008
*/
package com.neopets.util.display.scrolling
{
	/**
	 *	This class acts as global list of all available scrolling objects.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Singleton
	 * 
	 *	@author David Cary
	 *	@since  7.28.2009
	 */
	public class ScrollManager
	{
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		protected static var entries:Array = new Array();;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ScrollManager():void{
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * @Note: This is an example
		 * @param		pCMD			String 		This is an Example of a Passed parameter
		 * @param		pBuyHowMuch		uint 		This is an Example of a Passed parameter
		 */
		 
		public static function getEntry(pID:String):Object{
			var entry:Object;
			for(var i:int = 0; i < entries.length; i++) {
				entry = entries[i];
				if(entry.name == pID) return entry;
			}
			return null;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function adds an object to the manager's registry.
		 * @param		pObject			ScrollingObject 		This the object to be added.
		 */
		 
		public static function addEntry(pObject:ScrollingObject=null):void{
			if(entries == null) entries = new Array();
			entries.push(pObject);
		}
		
		/**
		 * @This function removes an object fro the manager's registry.
		 * @param		pObject			ScrollingObject 		This the object to be removed.
		 */
		 
		public static function removeEntry(pObject:ScrollingObject=null):void{
			if(entries != null) {
				var entry:Object;
				for(var i:int = entries.length - 1; i >= 0; i--) {
					entry = entries[i];
					if(entry == pObject) entries.splice(i,1);
				}
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
