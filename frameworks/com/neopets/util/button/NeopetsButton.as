/* AS3
	Copyright 2008
*/

package com.neopets.util.button
{
	import com.neopets.util.general.GeneralFunctions;
	
	import flash.text.Font;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 *	This is for Simple Control of a Button with a Little More Extras
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Clive Henrick
	 *	@since  1.2.2009
	 */
	 
	public class NeopetsButton extends MovieClip implements INeopetButton
	{

		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE / PUBLIC VARIABLES
		//--------------------------------------
		
		protected var mID:String;
		protected var mLockout:Boolean;
		protected var mDataObject:Object;
		protected var mVisibility:Boolean;

		protected var mDefaultFormat:TextFormat;
		
		public var label_txt:TextField;
		public var label_mouseEnabled:Boolean;
		
		

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		
		public function NeopetsButton()
		{
			//trace( "NeopetsButton says: NeopetsButton constructed" );
			
			mDefaultFormat = new TextFormat();
			label_mouseEnabled = false;
			if (label_txt != null)
			{
				label_txt.htmlText = "";
			}
			addEventListener(MouseEvent.MOUSE_OVER,onRollOver,false,0,true);
			addEventListener(MouseEvent.MOUSE_OUT,onRollOut,false,0,true);
			addEventListener(MouseEvent.MOUSE_DOWN,onDown,false,0,true);
			addEventListener(MouseEvent.MOUSE_UP,onUp,false,0,true);
			buttonMode = true;
			
			mLockout = false;
			reset();
		}
		
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get ID():String
		{
			return mID;
		}
		
		public function set ID(pString:String):void
		{
			mID = pString;
		}
		
		public function get lockOut():Boolean
		{
			return mLockout;
		}
		
		public function set lockOut(pFlag:Boolean):void
		{
			mLockout = pFlag;
		}
		
		public function setText(pString:String):void
		{
			if (label_txt != null)
			{
				label_txt.mouseEnabled = label_mouseEnabled;
				label_txt.x = int(label_txt.x);
				label_txt.y = int(label_txt.y);
				label_txt.htmlText = pString;
				label_txt.setTextFormat(mDefaultFormat);
			}
			
		}
		
		public function getText():String
		{
			if (label_txt != null)
			{
				return label_txt.htmlText;
			}
			else
			{
				return null;
			}
			
		}
		
		
		public function get dataObject():Object
		{
			return mDataObject;
		}
		
		public function get displayFlag():Boolean
		{
			return mVisibility;
		}
		
		public function set displayFlag(pFlag:Boolean):void
		{
			mVisibility = pFlag;
			
			if (pFlag)
			{
				visible = true;	
			} 
			else
			{
				visible = false;	
			}
		}
		

		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/** 
		 * @Note: This is the Init
		 * @Note: A Button Does not need to be init if it is not setup with the XML or a Data Object
		 * @param		pID 							String				The Name of the Button
		 * @param		pConstructionData				XML or Object		The Data used for the Button Creation
		 * @param		pObject							Not Used					Must be here for Backward Comp
		 */
		 
		public function init( pConstructionData:Object = null, pID:String = "button", pObject:Object = null):void	
		{
			mID = pID;
	
			mDataObject = pConstructionData;
			
			if (mDataObject.hasOwnProperty("visible"))
			{
				displayFlag = GeneralFunctions.convertBoolean(mDataObject.visible.toString());
			}
			else
			{
				displayFlag = true;
			}
			
		
			
				
			if (mDataObject.hasOwnProperty("text"))
			{
				label_txt.htmlText = mDataObject.text;
				
				if (mDataObject.hasOwnProperty("FORMAT"))
				{
					GeneralFunctions.setParamatersList(mDefaultFormat,mDataObject.FORMAT);	
					
					if (mDataObject.FORMAT.hasOwnProperty("font")) 
					{
						if (checkFont(mDataObject.FORMAT.font))
						{
							mDefaultFormat.font = mDataObject.FORMAT.font;
							label_txt.embedFonts = true;		
						}
						else
						{
							label_txt.embedFonts = false;	
						}
					}
				}
				
				
				label_txt.setTextFormat(mDefaultFormat);
			}

			if (mDataObject.hasOwnProperty("scaleX"))
			{
				scaleX = mDataObject.scaleX.toString();	
			}
			
			if (mDataObject.hasOwnProperty("scaleY"))
			{
				scaleY = mDataObject.scaleY.toString();		
			}
			
					
		}
		
		/**
		 *@Note Resets the Button to the first frame 
		 */
		 
		public function reset():void
		{
			gotoAndStop(1);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		protected function onRollOver(evt:MouseEvent):void 
		{
			if (!mLockout)
			{
				rollOverHandler();
			}
		}
		
		protected function onRollOut(evt:MouseEvent):void 
		{
			if (!mLockout)
			{
				rollOutHandler();
			}
		}
		
		protected function onDown(evt:MouseEvent):void 
		{
			if (!mLockout)
			{
				mouseDownHandler();
			}
		}
		
		protected  function onUp(evt:MouseEvent):void 
		{
			if (!mLockout)
			{
				mouseUpHandler();
			}
				
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected function rollOverHandler():void {
			gotoAndStop("on");
		}
		
		protected function rollOutHandler():void {
			gotoAndStop("off");	
		}
		
		protected function mouseDownHandler():void {
			gotoAndStop("down");
		}
		
		protected function mouseUpHandler():void {
		}
		
		
		/**
		* @Note: Checks to see if the font is embedded
		* @param		pFontName		String			The Name of the Font to Check
		*/
		
	 	protected function checkFont(pFontName:String):Boolean
	 	{
	 		var tFontArray:Array = Font.enumerateFonts(false);
	 		var tCount:uint = tFontArray.length;
	 		
	 		for (var t:uint = 0; t < tCount; t++)
	 		{
	 			if (tFontArray[t].fontName == pFontName)
	 			{
	 				return true;
	 			}
	 		}
	 		
	 		return false;
	 	}
		
		
	}
	
}
