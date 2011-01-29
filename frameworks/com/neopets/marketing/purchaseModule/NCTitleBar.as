/* AS3
	Copyright 2009
*/
package com.neopets.marketing.purchaseModule
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.neopets.util.events.EventFunctions;
	
	/**
	 *	This class handles the title and close button for a purchase window pop up.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  7.07.2010
	 */
	public class NCTitleBar extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const CLOSE_REQUEST:String = "close_request";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		// components
		public var titleField:TextField;
		protected var _closeButton:DisplayObject;
		
		/**
		 *	@Constructor
		 */
		public function NCTitleBar():void{
			super();
			// initialize components
			titleField = getChildByName("title_txt") as TextField;
			closeButton = getChildByName("close_btn");
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get closeButton():DisplayObject { return _closeButton; }
		
		public function set closeButton(dobj:DisplayObject) {
			// set up listeners
			EventFunctions.transferListener(_closeButton,dobj,MouseEvent.CLICK,onCloseButtonClick);
			// store new component
			_closeButton = dobj;
		}
		
		public function get title():String {
			if(titleField != null) return titleField.htmlText;
			else return null;
		}
		
		public function set title(msg:String) {
			if(titleField != null) {
				titleField.htmlText = msg;
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		// When the close button is clicked, send out a "close pop up" request.
		
		protected function onCloseButtonClick(ev:Event) {
			var transmission:Event = new Event(CLOSE_REQUEST);
			dispatchEvent(transmission);
		}
		
	}
	
}
