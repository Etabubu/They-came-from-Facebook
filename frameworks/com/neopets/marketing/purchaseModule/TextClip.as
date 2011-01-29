/* AS3
	Copyright 2009
*/
package com.neopets.marketing.purchaseModule
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	
	import com.neopets.util.display.DisplayUtils;
	
	/**
	 *	This class simply acts as a movieclip wrapper for a text field.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  7.08.2010
	 */
	public class TextClip extends MovieClip 
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
		// components
		public var textField:TextField;
		
		/**
		 *	@Constructor
		 */
		public function TextClip():void{
			super();
			// initialize components
			textField = getChildByName("main_txt") as TextField;
			// if the named text field wasn't found, use the first textfield within this container as our default.
			if(textField == null) {
				textField = DisplayUtils.getDescendantInstance(this,TextField) as TextField;
			}
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get text():String {
			if(textField != null) return textField.htmlText;
			else return null;
		}
		
		public function set text(msg:String) {
			if(textField != null) {
				textField.htmlText = msg;
				textField.height = textField.textHeight + 4;
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
		
	}
	
}
