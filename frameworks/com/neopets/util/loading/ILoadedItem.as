package com.neopets.util.loading
{
	import flash.display.Loader;
	import flash.system.ApplicationDomain;
	import com.neopets.util.loading.LoadingData;
	
	public interface ILoadedItem
	{
		function init(LOADEDCONTENT:Object,LOADEDNAME:String,ID:String,LOADCLASS:Class,DATA:Object,LOADXML:XML = null,LOADER:Loader = null, pLoadingData:LoadingData = null):void;
		function get objItem():Object;
		function set objItem(pObject:Object):void;
		function get objClass():Class;
		function set objClass(pClass:Class):void;
		function get objName():String;
		function get objID():String;
		function get objData():Object;
		function set objData(pData:Object):void;
		function get objXML():XML;
		function get loaded():Boolean;
		function set loaded(pFlag:Boolean):void;
		function get loader():Loader;
		function get state():String;
		function set state(pString:String):void;
		function get localApplicationDomain():ApplicationDomain;
		function set localApplicationDomain(pObject:ApplicationDomain):void;
		function get loadingData():LoadingData;
		function getObjectOutofLibrary(pObjectClassName:String):Object;
		function getCloneofObject():Object;

	}
}