/* AS3
	Copyright 2009
*/
package com.virtualworlds.lang
{
	/**
	 *	This class holds all the TranslationManager costants.
	 *
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Neopets Translation System
	 * 
	 *	@author Viviana Baldarelli
	 *	@since  012.10.2009
	 */
	public class TranslationManagerInfo
	{
		
		public const LABEL_ID:String = "txtFld";  	//All the DisplayObjects TextFields should be Called this.
		
		// WESTERN
		static public const ENGLISH:String = "EN";
		static public const PORTUGUESE:String = "PT";
		static public const GERMAN:String = "DE";
		static public const FRENCH:String = "FR";
		static public const SPANISH:String = "ES";
		static public const DUTCH:String = "NL";
		
		// NON-WESTERN
		static public const CHINESE_SIMPLIFIED:String = "CH"; 
		static public const CHINESE_TRADITIONAL:String = "ZH";
		
		// type game
		public static const TYPE_ID_GAME : int = 4;
		
		// type content (non-game)
		public static const TYPE_ID_CONTENT : int = 14;
		
		//events
		public static const TRANSLATION_DONE:String = "translation_done";

	}
}