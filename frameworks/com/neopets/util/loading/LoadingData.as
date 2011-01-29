package com.neopets.util.loading
{
	
	/**
	 *	This is a SimpleSetup Loading Item

	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@Clive henrick 
	 *	@since  08.22.09
	 */
	 
	public class LoadingData
	{
		
		//--------------------------------------
		//  PRIVATE / PROTECTED VARIABLES
		//--------------------------------------
		
		public var url:String;
		public var id:String;
		public var data:Object;
		public var overrideURL:String;
		public var applicationdomain:String;
		public var sendEvent:Boolean;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * 	@param		url									String			Required		Default PathWay from the Document Class to the File
		 * 	@param		id									String			Required		What you want the Loaded to be called for reference
		 * 	@param		pApplicationdomain		String			Required		The Default ApplocationDomain For the Item
		 * 	@param		data								Object			Optional		An Object that You can Pass infomation that you want Tied to the Loaded Object. 
		 * 	@param		overrideURL					String			Optional		Will Over ride the defaultURL used for loading an Object.		
		 * 	@param		pSendEvent					Boolean			Optional		Sends Events when Loaded or Initialsed.		
		 *  */
		 
		public function LoadingData(pUrl:String, pId:String, pApplicationdomain:String, pData:Object = null, pOverrideURL:String = null, pSendEvent:Boolean = false)
		{
			url = pUrl;
			id = pId;
			data = pData;
			overrideURL = pOverrideURL;
			applicationdomain = pApplicationdomain;
			sendEvent = pSendEvent;
		}

	}
}