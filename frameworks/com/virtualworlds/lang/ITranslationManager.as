package com.virtualworlds.lang
{
	import flash.events.IEventDispatcher;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 *	TranslationManager interface.
	 * 
	 * 	Every TranslationManager has to implement this Interface. 
	 * 	It will have to be a Singleton. 
	 * 	<code>init (...)</code> will call the translation and load all translated text in the application. 
	 * 	Translated text will then be available thru the TranslationData object.
	 * 
	 * 	Use <code>setTextField(...)</code> to set the translated text in the individual text fields.
	 * 	
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Neopets Translation System
	 * 
	 *	@author Clive Henrick/Viviana Baldarelli
	 *	@since  01.12.2009
	 */
	public interface ITranslationManager extends IEventDispatcher
	{
		
		/** 
		 * @Note 	Initialization. 
		 * @Note 	in Games, init is called in GameEngineSupport, function: setupTranslation
		 * 
		 * @param	pLang 					String			A Language Code (See LanguageID Class)
		 * @Param	pGame_id				int				The Game Code
		 * @Param	pType_id				uint			// 14 Application , 4 Game Content
		 * @param 	translationData The <code>TranslationData</code> subclass to store the values in. 
		 */
		function init ( pLang:String,pGame_id:int, pType_id:int, translationData : TranslationData, pTranslationURL:String = null):void
		
		
		/** 
		 * This sets the URL to the translation text file on Neopets.com
		 */
		function set externalURLforTranslation(pURL:String):void;
		
		/** 
		 * This represents the XML returned by Neopets.com with the translated text.
		 */
		function get translationXMLData():XML;
		
		/** 
		 * Once the XML with the translation is returned from Neopets.com, its content it's translated in the TranslationData object passed in the init function.
		 */
		function get translationData(): TranslationData;
		function set translationData(value:TranslationData): void 
		
		
		/**
		 * Set a textField using the translation system. The <code>TranslationManager</code>
		 * will decide whether to set the font and embed or not depending on the language.	
		 * 
		 * @param pTextField  The textField.
		 * @param pValue      The already translated string to display.
		 * @param pFontName   The font name (optional).
		 * @param pFontName   The font format (optional).
		 */
		function setTextField(pTextField:TextField, pValue:String, pFontName:String = null, pFontFormat: TextFormat = null ):void
		
		
		/** 
		 * This method is to call the translation value of a single string of text; If the string is not one of the one translated, it returns itself un-translated. 
		 */
		function getTranslationOf(str : String ) : String;
	
		
	}
}