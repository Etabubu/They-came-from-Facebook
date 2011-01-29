package com.virtualworlds.lang
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.unescapeMultiByte;
	
	/**
	 *	This is based on the TranslationManager but more open to expansion for outside Vendors
	 * 	
	 *  You create an TranslateItem on a as needed basis, with one Returned XML from neopets per
	 *  Instance of this Class.
	 *
	 *  ############## TO DO ###################
	 *  > Load the XML from Neopets
	 *  > Translate the XML
	 *  > Update the Graphic
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Neopets Translation System
	 * 
	 *	@author Clive Henrick
	 *	@since  01.12.2009
	 */
	
	public class TranslationManager extends EventDispatcher implements ITranslationManager
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//All class constant are in the TranslationManagerInfo class;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		/** 
		 * Translation XML data.
		 */
		public function get translationXMLData():XML{return _translationXMLData;}
		private var _translationXMLData:XML;
		
		private var _loader:URLLoader;
		private var _langCode:String;
		private var _gameID:int = 0;
		private var _typeID:int = 0;
		private var _shouldEmbedFonts:Boolean;
		
		public function set externalURLforTranslation(pURL:String):void {_translationURL = pURL;}
		private var _translationURL:String;
		
		public function get translationData(): TranslationData { return _translationData;}
		public function set translationData(value:TranslationData): void { _translationData = value;}
		private var _translationData : TranslationData;
		
		public static function get instance():ITranslationManager
		{ 
			return _instance;
			
		} 
		
		private static const _instance:ITranslationManager = new TranslationManager( SingletonEnforcer ); 
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function TranslationManager(singletonEnforcer : Class = null)
		{
			if(singletonEnforcer != SingletonEnforcer){
				throw new Error( "Invalid Singleton access.  Use TranslationManager.instance." ); 
			}
			
			setupVars();
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		/** 
		 * @Note This is the Setup for this Object
		 * @Note in Games, init is called in GameEngineSupport, function: setupTranslation
		 * @param	pLang 					String			A Language Code (See LanguageID Class)
		 * @Param	pGame_id				int				The Game Code
		 * @Param	pType_id				uint			// 14 Application , 4 Game Content
		 * @param translationData The <code>TranslationData</code> subclass to store the values in. 
		 */
		
		public function init ( pLang:String,pGame_id:int, pType_id:int, translationData : TranslationData, pTranslationURL:String = null):void
		{
			trace ("TranslationManager init called")
			_langCode = pLang;
			_gameID = pGame_id;
			_typeID = pType_id;
			_translationData = translationData;
			
			if (pLang == TranslationManagerInfo.CHINESE_SIMPLIFIED || pLang == TranslationManagerInfo.CHINESE_TRADITIONAL)
			{
				_shouldEmbedFonts = false;	
			}
			
			if (pTranslationURL != null)
			{
				if (pTranslationURL.substr(0,4) == "http")
				{
					trace ("pTranslationURL contains 'http' already" )
					_translationURL = pTranslationURL +"transcontent/gettranslationxml.phtml";
				}
				else
				{
					trace ("pTranslationURL does not contain 'http://', thus added" )
					_translationURL = "http://" + pTranslationURL +"/transcontent/gettranslationxml.phtml";
				}
			}
			else
			{
				_translationURL = "http://dev.neopets.com/transcontent/gettranslationxml.phtml";
			}
			
			trace("TranslationManager URL:" +_translationURL,"- External translation URL:", pTranslationURL);
			loadTranslationData();
		}
		
		/**
		 * Set a textField using the translation system. The <code>TranslationManager</code>
		 * will decide whether to set the font and embed or not depending on the language.	
		 * @param pTextField The textField.
		 * @param pValue The already translated string to display.
		 * @param pFontName The font name (optional).
		 * @param pFontName The font format (optional).
		 */
		public function setTextField(pTextField:TextField, pValue:String, pFontName:String = null, pFontFormat: TextFormat = null ):void
		{
			
			if( pTextField == null || pValue == null ) 
			{ 
				return;
				
				
				
			}
			
			pTextField.htmlText = pValue;
			
			if(pFontName)
			{
				if(pFontFormat)
				{
					pFontFormat.font = pFontName;
				}
				else
				{
					pFontFormat = pTextField.getTextFormat();
					pFontFormat.font = pFontName;
					pFontFormat.size = null;
					pFontFormat.align = null;
					pFontFormat.bold = null;
					pFontFormat.italic = null;
					
				}
			}
			pTextField.multiline = true;
			pTextField.wordWrap = true;
			
			//pTextField.htmlText = pValue;
			
			pTextField.embedFonts = _shouldEmbedFonts;
			
			if(pFontFormat )
			{
				pTextField.setTextFormat(pFontFormat);
			}
			
		}
		
		public function getTranslationOf(str : String ) : String
		{
			if(translationData[str] == null )
			{
				return str;	
			} 
			
			return translationData[str]; 
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Note the Neopets XML has been returned, so now it processes it.
		 */
		private function onCompleteHandler(a_evt:Event = null):void
		{
			_translationXMLData = new XML(_loader.data);
			
			if(_translationXMLData.hasOwnProperty("errors"))
			{
				
			}
			
			var transUnitList:XMLList;
			transUnitList = _translationXMLData.file.body.child("trans-unit");
			var	total:int = transUnitList.length();
			var i:int = 0;
			
			while(i < total)
			{
				var transUnit:XML = transUnitList[i];
				var resName:XMLList = transUnit.attribute("resname");
				var source:String = unescapeMultiByte(transUnit.source);	
				// pack it in the TranslationData object				
				_translationData[resName.toString()] = source;
				
				
				i++;
			}
			
			dispatchEvent(new Event(TranslationManagerInfo.TRANSLATION_DONE));	
			
		}
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function setupVars():void
		{
			
			_shouldEmbedFonts = true;
		}
		
		/**
		 * @Note: Checks to see if the font is embedded
		 * @param		pFontName		String			The Name of the Font to Check
		 */
		
		private function checkFont(pFontName:String):Boolean
		{
			var tFontArray:Array = Font.enumerateFonts(true);
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
		
		/**
		 * Request the Game's XML depending on
		 * language code from Neopet's server.
		 */
		
		private function loadTranslationData():void 
		{
			//
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, dispatchEvent);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, dispatchEvent, false, 0, true);
			
			var vars:URLVariables = new URLVariables();
			vars.lang = _langCode;
			vars.type_id = _typeID;
			vars.item_id = _gameID;
			vars.r = (Math.random() * _gameID);
			
			trace ("game ID = ", _gameID,"-", "type ID =",  _typeID);
			
			var request:URLRequest= new URLRequest();
			request.url = _translationURL;
			request.data = vars;
			request.method = URLRequestMethod.POST;
			
			_loader.load(request);
		}
	}
	
}

internal class SingletonEnforcer{}
