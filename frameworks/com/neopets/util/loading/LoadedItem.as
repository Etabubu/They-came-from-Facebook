
/* AS3
	Copyright 2008
*/
package com.neopets.util.loading
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;
	
	
	/**
	 *	This is a container for all loaded Items from an LoadingEngine
	 *  It Can give you most information that you could use for a loaded Asset
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  12.12.2008
	 */
	 
	public class LoadedItem implements ILoadedItem
	{
			
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var mLoadObject:Object;
		//private var mClass:Object;
		private var mClass:Class;
		private var mName:String;
		private var mID:String;
		private var mData:Object;
		private var mXML:XML;
		private var isLoaded:Boolean;
		private var mLoader:Loader;
		private var mState:String;
		private var mlocalApplicationDomain:ApplicationDomain;
		private var mLoadingData:LoadingData;
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function LoadedItem():void{}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get objItem():Object
		{
			return mLoadObject;
		}
		
		public function set objItem(pObject:Object):void
		{
			mLoadObject = pObject;
		}
		
		public function get localApplicationDomain():ApplicationDomain
		{
			return mlocalApplicationDomain;
		}
		
		public function set localApplicationDomain(pObject:ApplicationDomain):void
		{
			mlocalApplicationDomain = pObject;
		}
		
		public function get objClass():Class
		{
			return mClass;
		}
		
		public function set objClass(pClass:Class):void
		{
			mClass = pClass;
		}
		
		public function get objName():String
		{
			return mName;
		}
		public function get objID():String
		{
			return mID;
		}
		
		public function get objData():Object
		{
			return mData;
		}
	
		public function set objData(pData:Object):void
		{
			mData = pData;
		}
		
		public function get objXML():XML
		{
			return mXML;
		}
		
		public function get loaded():Boolean
		{
			return isLoaded;
		}
		
		public function set loaded(pFlag:Boolean):void
		{
			isLoaded = pFlag;
		}
		
		public function get loader():Loader
		{
			return mLoader;
		}
		
		public function set state(pString:String):void
		{
			mState = pString;
		}
		
		public function get state():String
		{
			return mState;
		}
		
		public function get loadingData():LoadingData
		{
			return mLoadingData;
		}
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		 /**
		 * onIncommingObj is called when Requested Objects are returned.
		 * @Param		LOADEDCONTENT	Object					The Loaded ITEM
		 * @Param		LOADEDNAME		String					The ASSETNAME of the Object in the LoadList
		 * @Param		COUNT			uint					The Index of the Object in the LoadList
		 * @Param		ID				String					The ID of the Loaded Object. If DUPLICATE is used the it will be ID_ + Duplicate Number (Starts at 0)
		 * @Param		LOADCLASS		Object					The loaded SWF constructor Class
		 * @Param		DATA			OBJECT					The passed Object in the LoadList
		 * @Param		LOADXML			XML						The LoadingEngines XML for the Item
		 * @Param		LOADER			Loader					The Loader used to Load the Item
		 * @Param		pLoadingData		LoadingData		The Data Used to Create the Loading Item
		 */
		 
		public function init(LOADEDCONTENT:Object,LOADEDNAME:String,ID:String,LOADCLASS:Class,DATA:Object,LOADXML:XML = null,LOADER:Loader = null, pLoadingData:LoadingData = null):void
		{
			mLoadObject = LOADEDCONTENT;
			//trace( "mLoadObject: " + mLoadObject );
			mClass = LOADCLASS;
			//trace( "mClass: " + mClass );
			mName = LOADEDNAME;
			//trace( "mName: " + mName );
			mID = ID;
			//trace( "mID: " + mID );
			mData = DATA;
			//trace( "mData: " + mData );
			mXML = LOADXML;
			//trace( "mXML: " + mXML );
			mLoader = LOADER;
			//trace( "mLoader: " + mLoader );
			mState = "notLoaded";
			isLoaded = false;	
			mLoadingData = pLoadingData;
		}
		
		/**
		 * @Note returns a Item out of a Flash Library in a SWF
		 * @param		pObjectClassName		String		The Name of the Linked Class Name you gave it in Flash
		 */
		 
		public function getObjectOutofLibrary(pObjectClassName:String):Object
		{
			if (localApplicationDomain.hasDefinition(pObjectClassName))
			{
				var tClass:Class =  localApplicationDomain.getDefinition(pObjectClassName) as Class;
				return new tClass();
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * @Not Does Not Work
		 */
		 
		public function getCloneofObject():Object
		{
			return null;
				//return new mClass();
		}
		
		/**
		 * @Note This is to Clear Memory for the Loaded Item
		 * ########### This uses Flash 10 Memory Cleanup so it must be used with Player 10 ############## 
		 */
		
		public function clearLoadedItem():void
		{
			if (mLoader.hasOwnProperty("unloadAndStop"))
			{
				Object(mLoader).unloadAndStop();
			}
			
			mLoadObject = null;
			mClass = null;
			mName = "";
			mID = "";
			mData = [];
			mXML = null;
			mLoader = null;
			mState = "notLoaded";
			isLoaded = false;	
			mLoadingData = null;
			
	
		}

		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
