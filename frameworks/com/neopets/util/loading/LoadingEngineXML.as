/* AS3
	Copyright 2008
*/

package com.neopets.util.loading
{

	import com.neopets.projects.np9.system.NP9_BIOS;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.xml.ObjectXMLParser;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.getQualifiedClassName;
	
	/**
	 *	This is for the Loading of External Assets from an XML
	 * 
	 * 	It can also Store Loaded Assets for retrieval later using mLoadedItems.
	 * 
	 * ### As of now this can NOT handle Loading Sound Files
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@Clive henrick 
	 *	@since  12.03.08
	 */
	 
	public class LoadingEngineXML extends EventDispatcher
	{

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mLoadList:Array;
		protected var mCount:uint;
		protected var mID:String;
		protected var mLoadedItems:Array;
		protected var mAllLoaded:Boolean;
		
		protected var mLoadXMLList:XML;
		protected var mNumberToLoad:uint;
		protected var mCurrentXMLItem:XML;
		protected var mLoader:Loader;
		protected var mLoadedItem:LoadedItem;
		protected var mActiveLoading:Boolean;
	
		protected var mBIOS:NP9_BIOS;
		
		//--------------------------------------
		//  CONST
		//--------------------------------------
		
		public const LOADING_COMPLETE:String = "loadingEngine_Complete";
		public const LOADING_PROGRESS:String = "loadingEngine_On_Progress";
		public const LOADING_OBJINT:String = "loadingEngine_ObjectINT";
		public const LOADING_OBJLOADED:String = "loadingEngine_ObjectLoaded";
		public const LOADING_CLEANED:String = "AllMemoryShouldBeFree";
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		**/
		
		//Constructor
		public function LoadingEngineXML():void {
			setVars();
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 *	@init sets up the Loaded Object. It Starts the Process of Loading all the Items.
		 *  @param			pToLoadObject		Array or XML			The pToLoadObject needs to be an XML List
		 *  @param			pID					String					Sets mID. Used as an Property of the Loading Engine.
		 * 	@param			pOverrideNP9BIOS	NP9_BIOS				This is the mBIOS from the GameContainer System. This will override anything used in
		 * 																the Config XML File. This allows for the NP9_GS to take control of file locations.
		 * **/
		
		 /**
		 * 	@Setup List				
		 *  @LoadObject		assetname		String			Required		SWF Name
		 * 	@LoadObject		url				String			Required		Default PathWay from the Document Class to the File
		 * 	@LoadObject		id				String			Required		What you want the Loaded to be called for reference
		 * 	@LoadObject		DATA			Object			Required		An Object that You can Pass infomation that you want Tied to the Loaded Object. 
		 * * 																	Sent Back to you as a DATA Property on a Returned Object.
		 **/
		
		public function init(pXMLLoadList:XML,pID:String = "LoadingEngineXML",pOverrideNP9BIOS:NP9_BIOS = null):void 
		{
			mID = pID;
			
			mBIOS = pOverrideNP9BIOS;
			
			mLoadXMLList = lowercaseXML(pXMLLoadList);
	
			mNumberToLoad = mLoadXMLList.ITEM.length();
			
			startLoadingObject();
		}
		
		/**
		 * @Note: For Adding Item to a LoadingEngine.
		 * @Note: Will Only Add Items once the mLoadXMLList is Completed as they are added to the end of the List.
		 * @Note: 		#### For the Moment you can only add one off items once the loadingEngine is Complete ####
		 * /**
		 * 	@Setup List				
		 *  @LoadObject		assetname		String			Required		SWF Name
		 * 	@LoadObject		url				String			Required		Default PathWay from the Document Class to the File
		 * 	@LoadObject		id				String			Required		What you want the Loaded to be called for reference
		 * 	@LoadObject		data			Object			Required		An Object that You can Pass infomation that you want Tied to the Loaded Object. 
		 * 																	Sent Back to you as a DATA Property on a Returned Object.
		 * **/

		 
		 public function addItemToLoad(pLoadingData:XML):void
		 {
		 	if (mAllLoaded || !mActiveLoading)
		 	{
		 		mLoadXMLList.appendChild(pLoadingData);
		 		mNumberToLoad++;
		 		
		 		if (!mActiveLoading)
		 		{
		 			startLoadingObject();
		 		}
		 	}
		 }
		 
		 /**
		 * @Note: This is for adding a new List
		 * @Note: Will Only Add Items once the mLoadXMLList is Completed as they are added to the end of the List.
		 * @Note: 		#### For the Moment you can only add one off items once the loadingEngine is Complete ####
		 *  /**
		 * 	@Setup List				
		 *  @LoadObject		assetname		String			Required		SWF Name
		 * 	@LoadObject		url				String			Required		Default PathWay from the Document Class to the File
		 * 	@LoadObject		id				String			Required		What you want the Loaded to be called for reference
		 * 	@LoadObject		data			Object			Required		An Object that You can Pass infomation that you want Tied to the Loaded Object. 
																Sent Back to you as a DATA Property on a Returned Object.
		**/

		 
		 public function addListToLoad(pLoadingData:XML):void
		 {
	
	 		for each (var newITEM:XML in pLoadingData.*)
			{
				mLoadXMLList.appendChild(newITEM);
				mNumberToLoad++;
			}

	 		if (!mActiveLoading)
	 		{
	 			startLoadingObject();
	 		}

		 }
		 
		 /**
		 * @Note: Unloads all the Objects for Memory CleanUp.
		 */
		 
		 public function cleanUpAllMemory():void
		 {
		 	var tCount:int = mLoadedItems.length;
		 	
		 	for (var t:int = 0; t < tCount; t++)
		 	{
		 		var tLoadedItem:LoadedItem = mLoadedItems[t];
		 		tLoadedItem.clearLoadedItem();
		 		tLoadedItem = null;
		 	}
		 	
		 	mLoadedItem = null;
		 	mLoadedItems = [];
		 	mLoader = null;
		 	
		 	dispatchEvent(new Event(LOADING_CLEANED));
				
		 }
		 
		 
		 
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @Note: Converts all the sections to Lowercase
		 */
		 
		 protected function lowercaseXML(pXML:XML):XML
		 {
		 	var returnXML:XML = pXML;
		 	
		 	for each (var node:XML in returnXML.*.*)
			{
				if (node.nodeKind() == "element")
				{
					node.setName(node.name().toString().toLowerCase());
				}
			}
			
			return returnXML;	
		 }
		
		
		/**
		 *	@setVars sets up the variables used in this class
		**/
		 
		protected function setVars():void {
			mLoadedItems = [];
			mCount= 0;
			mLoadList = [];
			mAllLoaded = false;
			mNumberToLoad = 0;
			mActiveLoading = false;
			mLoadXMLList = <LIST></LIST>;
		}
			
		/**
		 *	@startLoadingObject starts the Load Process.
		 * 	@All addEventListeners use Weak References.
		 **/
		 
		protected function startLoadingObject(pDefault:XML = null):void {
				try {
					
				if(pDefault != null)
				{
					mCurrentXMLItem = pDefault;		
				}
				else
				{
					mCurrentXMLItem = mLoadXMLList.ITEM[mCount];	
				}
				
				mActiveLoading = true;

				mLoader = new Loader();
				mLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onItemLoaded,false,0,true);
				mLoader.contentLoaderInfo.addEventListener(Event.INIT, onItemInit,false,0,true);
				mLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError,false,0,true);
				mLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);
				
				
				var loaderContext:LoaderContext = new LoaderContext();
				
				if (mCurrentXMLItem.hasOwnProperty("applicationdomain"))
				{
					trace( "LoadingEngineXML says: " + mCurrentXMLItem.applicationdomain.toString( ) );
					
					switch(mCurrentXMLItem.applicationdomain.toString())
					{
					case "use_parent":
						// child SWF uses parent domain definitions
						// if defined there, otherwise its own
						loaderContext.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
					break;
					case "seperate":
						// child SWF domain is completely separate and
						// each SWF uses its own definitions
						loaderContext.applicationDomain = new ApplicationDomain();
					break;
					default:
						//"add_child"
						// child SWF adds its unique definitions to
						// parent SWF; both SWFs share the same domain
						// child SWFs definitions do not overwrite parents
						loaderContext.applicationDomain = ApplicationDomain.currentDomain;				
					break;
					}
				} 
				else
				{
					loaderContext.applicationDomain = ApplicationDomain.currentDomain;	
				}
				
				loaderContext.checkPolicyFile = true;
				
				mLoadedItem = new LoadedItem();
				mLoadedItem.init(null,mCurrentXMLItem.assetname.toString(),mCurrentXMLItem.id.toString(),null,{},mCurrentXMLItem,mLoader);
				
				if (mCurrentXMLItem.data != null) {
					
					var tData:Object = {};
					if (mCurrentXMLItem.hasOwnProperty("data"))
					{
						tData = ObjectXMLParser.xmlToObject(mCurrentXMLItem.data[0]);
					}
					mLoadedItem.objData = tData;
				}
				
				var itemPath:String;
				
				 
				if (mCurrentXMLItem.hasOwnProperty("url"))
				{
					itemPath = mBIOS.finalPathway + mCurrentXMLItem.url.toString() + mCurrentXMLItem.assetname.toString();	
				}
				else
				{
					itemPath = mBIOS.finalPathway + mCurrentXMLItem.assetname.toString();	
				}
				
				if (! mBIOS.localTesting) //TESTING ON A SERVER
				{
					loaderContext.checkPolicyFile = true;
					loaderContext.securityDomain = SecurityDomain.currentDomain;		
				}
				
				var tURLRequest:URLRequest = new URLRequest(itemPath);
				trace( itemPath );
				
				mLoader.load(tURLRequest, loaderContext);	
			
			} catch (e:ArgumentError) {
   					 trace("Error on LoadingEngine: " + mID + " with " + e);
			}
		}
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 *	@onItemInit starts the Load Process.
		 * 	@ When Object is Initalised. Many Objects then Load there own assets. In this Example There is no init called
		 *  @ as these are in game assets and as such do not have document classes that require external loading.
		 *  @param			evt			Event		From Event.INIT		
		 **/

		protected function onItemInit(evt:Event):void {
			try {
				var tID:String = mCurrentXMLItem.id.toString();
				
				var LoadedClassName:String = getQualifiedClassName(evt.target.content);
				var appDomain:ApplicationDomain = evt.target.content.loaderInfo.applicationDomain;
				var LoadedClass:Class = appDomain.getDefinition(LoadedClassName) as Class;
				var downloadedObj:* = LoadedClass(evt.target.content);
				
				mLoadedItem.objItem = downloadedObj;
				mLoadedItem.objClass = LoadedClass;
				mLoadedItem.state = "initalised";
				mLoadedItem.localApplicationDomain = appDomain;
				
				if (downloadedObj == null) {
					throw new Error("LoadingEngine " + mID + "ErrorLoaded Object>" + tID + " is TypeCasted Wrong thus Not Loaded");
				}
				
				dispatchEvent(new CustomEvent({LOADEDITEM:mLoadedItem},LOADING_OBJINT));
							
			} catch (e:ArgumentError) {
   					 trace(e);
			} 
		}
		
		/**
		 *	@onItemLoaded handles when a Item are loaded Complete
		 *  @param			evt			Event		From Event.COMPLETE	
		**/
		 
		protected function onItemLoaded(evt:Event):void {
			try {
				var tName:String = mCurrentXMLItem.assetname.toString();
				trace( "tName: " + tName );
				trace( "mCurrentXMLItem: " + mCurrentXMLItem );
				var tID:String = mCurrentXMLItem.id.toString();
				trace( "tID: " + tID );
				var tData:Object = {};
				
				mLoadedItem.state = "ready";
				mLoadedItem.loaded = true;
				trace( "mLoadedItem: " + mLoadedItem );
				trace( "mLoadedItem.localApplicationDomain: " + mLoadedItem.localApplicationDomain );
				
				mLoadedItems.push(mLoadedItem);
			
				mActiveLoading = false;
				
				mCount++;
				
				dispatchEvent(new CustomEvent({LOADEDITEM:mLoadedItem},LOADING_OBJLOADED));
				
				if ( (mNumberToLoad) > mCount) 
				{	
					startLoadingObject();
				} 
				else
				{
					if (!mAllLoaded)
					{
						mAllLoaded = true;
						dispatchEvent(new CustomEvent({ID:mID},LOADING_COMPLETE));
					}
				}	
				
			} catch (e:ArgumentError) {
   					 trace("LoadingEngine " + mID + "ErrorLoadeding at:" + e);
			} 
		}
		
		/**
		 *	@onError handles when a Loader has an Error
		 *  @param			evt			Event		From Event.ERROR	
		**/
		
		protected function onError(error:IOErrorEvent):void {
			trace("Error on LoadingArray >" + error);
			var tAsset:String = mCurrentXMLItem.assetname.toString();
			
			var tIndexStart:uint = tAsset.lastIndexOf(".");
			var tIndexEnd:uint =  tAsset.length;
			var tType:String = tAsset.substring(tIndexStart+1, tIndexEnd);
			
			mLoadedItem.state = "errorOnLoading";
			
		}
		
		
		/**
		 *	@onProgress handles whild a loder is loading, meant to be overridden
		 *  @param			evt			Event		From Event.ERROR	
		**/
		protected function onProgress(e:ProgressEvent):void 
		{
			//trace("LoadingEngineXML, onProgress: bytesLoaded=" + e.bytesLoaded + " bytesTotal=" + e.bytesTotal);
			dispatchEvent(new CustomEvent({TOTAL_ITEMS:mNumberToLoad, TOTAL_LOADED:mCount, BYTES_LOADED:e.bytesLoaded, BYTES_TOTAL:e.bytesTotal},LOADING_PROGRESS));
		}
		
	//--------------------------------------
	//  UTILITIES 
	//--------------------------------------
	
	/**
	 * Converts a String into An Object
	 * @Param 	tString	String 		The String you want to convert
	 */
	 
	public function convertStringToObject(tString:String):Object
	{
		var tObject:Object = {};
		
		if (tString.charAt(0) == "{") {
			var tSubObject:Object = {};
			
			//If The Object is emptey
			if (tString.charAt(1) == "}") {
				tObject = tSubObject;
				return tObject;
			}
					
			
			
			tString = tString.substring(1,tString.length - 1);	
			/* Split the Array Up */
			var tObjArray:Array = tString.split(",");
			
			/* Clean up the Results */
			for (var q:uint = 0; q < tObjArray.length; q++) {
				var tSubString:String = tObjArray[q];
				
				var tSubArray:Array = tSubString.split(":");
				
				if (Number(tSubArray[1])) {
					tSubArray[1] = Number(tSubArray[1]);
				} else {
					tSubArray[1] = String(tSubArray[1]);
				}
				
				tSubObject[tSubArray[0]] = tSubArray[1];
			}
			
			tObject = tSubObject;
		}	
		
		return tObject;
	}
	
	/**
	 * @Note: Unloads named Loader Object for Memory CleanUp.
	*/
		 
		 public function deleteLoaderObj(pObjectName:String):void
		 {
		 	try {
				var tCount:uint = mLoadedItems.length;
				for (var t:uint = 0; t < tCount; t++) {
					if (mLoadedItems[t].objName == pObjectName) {
						var tLoadedItem:LoadedItem = mLoadedItems[t];
		 				tLoadedItem.clearLoadedItem();
		 				tLoadedItem = null;
		 				mLoadedItems.splice(t,1);
					}
				}
				throw new Error("deleteLoaderObj Not Found "  + pObjectName);
			} catch (e:ArgumentError) {
   					 trace(e);
			}	
		 }
		 
		 /**
		 *  * Returning an LoadingEngine Storage Object by ObjectName
		 * @param			pObjectName			String			Name of the Object you want returned
	**/
		public function deleteLoadedObj(pObjectName:String):void {
			try {
				var tCount:uint = mLoadedItems.length;
				for (var t:uint = 0; t < tCount; t++) {
					if (mLoadedItems[t].objName == pObjectName) {
						var tLoadedItem:LoadedItem = mLoadedItems[t];
		 				tLoadedItem.clearLoadedItem();
		 				tLoadedItem = null;
		 				mLoadedItems.splice(t,1);
					}
				}
				throw new Error("deleteLoadedObj Not Found "  + pObjectName);
			} catch (e:ArgumentError) {
   					 trace(e);
			}
		}
		
		 
	/**
		 * Returning an Object that has been Loaded its Name
		 * @param			pObjectName			String			Name of the Object you want returned
	**/
		public function getLoadedObj(pObjectName:String):* {
			try {
				var tCount:uint = mLoadedItems.length;
				for (var t:uint = 0; t < tCount; t++) {
					if (mLoadedItems[t].objName == pObjectName) {
						return mLoadedItems[t].objItem;
						break;
					}
				}
				throw new Error("getLoadedObj Not Found "  + pObjectName);
			} catch (e:ArgumentError) {
   					 trace(e);
			}
		}
		
	/**
		 *  * Returning an LoadingEngine Storage Object by ObjectName
		 * @param			pObjectName			String			Name of the Object you want returned
	**/
		public function getLoaderObj(pObjectName:String):* {
			try {
				var tCount:uint = mLoadedItems.length;
				for (var t:uint = 0; t < tCount; t++) {
					if (mLoadedItems[t].objName == pObjectName) {
						return mLoadedItems[t] as LoadedItem;
						break;
					}
				}
				throw new Error("getLoadedObj Not Found "  + pObjectName);
			} catch (e:ArgumentError) {
   					 trace(e);
			}
		}
	/**
		 * Returning an Object that has been Loaded by its ID
		 * @param			pObjectID			String			ID of the Object you want returned
	**/
		public function getLoadedObjmID(pObjectID:String):* {
			try {
				var tCount:uint = mLoadedItems.length;
				
				for (var t:uint = 0; t < tCount; t++) {
					if (mLoadedItems[t].objID == pObjectID) {
						return mLoadedItems[t].objItem;
						break;
					}
				}
				throw new Error("getItemObjmID Not Found " + pObjectID);
			} catch (e:ArgumentError) {
   					 trace(e);
			}
		}
		
		/**
		 * Returning an LoadingEngine Storage Object by ID.
		 * @param			pObjectID			String			ID of the Object you want returned
		**/
		public function getLoaderObjmID(pObjectID:String):* {
			try {
				var tCount:uint = mLoadedItems.length;
				
				for (var t:uint = 0; t < tCount; t++) {
					if (mLoadedItems[t].objID == pObjectID) {
						return mLoadedItems[t] as LoadedItem;
						break;
					}
				}
				throw new Error("getLoaderObjmID Not Found " + pObjectID);
			} catch (e:ArgumentError) {
   					 trace(e);
			}
		}
		
		/**
		 * Returning a Copy of the Loaded Object using the Objects creator Class
		 * @param			pObjectID			String			ID of the Object Copy that you want returned
		 * **/
		
		
		public function cloneObject(pObjectID:String):*
		{
			
			try {
				var tCount:uint = mLoadedItems.length;
				for (var t:uint = 0; t < tCount; t++) 
				{
					
					if (mLoadedItems[t].ID == pObjectID) 
					{
						var tLoadedItem:LoadedItem = mLoadedItems[t];
						var tNewObjectClass:Class = tLoadedItem.objClass;
						return new tNewObjectClass();
						break;
					}
				}
				
				return null;
				
			} catch (e:ArgumentError) {
   				trace(e);
   				return 0;
			}
			
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get loadedItems():Array {
			return mLoadedItems;
		}
		
		public function get ID ():String
		{
			return mID;
		}
		
		public function get activeLoading():Boolean
		{
			return mActiveLoading;
		}
		
		public function get allLoaded():Boolean
		{
			return mAllLoaded;
		}
		
		public function get count():uint
		{
			return mCount;
		}
	}
}