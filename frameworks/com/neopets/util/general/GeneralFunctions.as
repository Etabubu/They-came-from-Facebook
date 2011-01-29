
/* AS3
	Copyright 2008
*/
package com.neopets.util.general
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	/**
	 *	This contains useful functions and Methods
	 *	Please use ASDocs if you can for your notes
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  01.27.2009
	 */
	 
	public class GeneralFunctions
	{
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function GeneralFunctions():void{}
	
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note: This will shuffle an Array Elements
		 * @param			pArray			Array			The Array to be Shuffled
		 */
		 
		 public static function shuffleArray(pArray:Array):Array
		 {
		 	var tShuffledArray:Array = [];
			
			while (pArray.length > 0)
			{
				var r:int = Math.floor(Math.random() * pArray.length);
				tShuffledArray.push(pArray[r]);
				pArray.splice(r,1);
			}
			
			return tShuffledArray;
		 }
		
		
		
		/**
		/**
		 * @Note: This will go through a List of Data and set paramaters to values. 
		 * @The parameter name MUST be the same as what the Object is expecting.
		 * @param		pOldObj			Object 		The Old Object that you want to have values set
		 * @param		pNewObj			Object 		The Object that you are using to get params from
		 */
		 
		 public static function syncParamters(pOldObj:Object, pNewObj:Object):Object
		 {
		 	for  (var key:String in pNewObj)
			{
				
				if ( pOldObj.hasOwnProperty(key) )
				{
					pOldObj[key] = pNewObj[key];
				}	
			}
	
			
			return pOldObj;
		 }
		
		
		
		/**
		 * @Note: This will go through a List of Data and set paramaters to values. 
		 * @The parameter name MUST be the same as what the Object is expecting.
		 * @param		pObject			Object 		This is the Item that will be effect by the Passed in List of Paramaters
		 * @param		pDataList		Object 		List of Paramaters with Values to effect the pObject (XML or Object)
		 */
		 
		 public static function setParamatersList(pObject:Object,pDataList:Object):void
		 {
		 	for each (var obj:Object in pDataList.*)
			{
				if (pObject.hasOwnProperty(obj.name()))
				{
					var tValue:* = obj.toString();
					tValue = (isNaN(tValue)) ? tValue : Number(tValue);
					pObject[obj.name()] = convertBoolean(tValue);	
				}	
			}	
		 }
		 
		 /**
		 * @Note: This will set an Object to a Param
		 * @The parameter name MUST be the same as what the Object is expecting.
		 * @param		pObject			Object 		This is the Item that will be effect by the Passed in List of Paramaters
		 * @param		pParm			Object 		A Paramaters with Values to effect the pObject (XML or Object)
		 */
		 
		 public static function setParamater(pObject:Object,pParm:Object):void
		 {
		 	
			if (pObject.hasOwnProperty(pParm.name()))
			{
				var tValue:* = pParm.toString();
				tValue = (isNaN(tValue)) ? tValue : Number(tValue);
				pObject[pParm.name()] = convertBoolean(pParm);
			}	
		
		 }
		 
		 /**
		 * @Note Takes an Object and Trys to convert to a Boolean
		 * @Note If it does not convert to a Boolean, returns the Value
		 * @Param		pObject		Object			The Object to Test
		 */
		 
		public static function convertBoolean(pObject:Object):Object
		{
			var tReturnObj:Object = pObject;
			
			if (pObject is XML|| pObject is XMLList)
			{
				pObject = pObject.toString();
			}
			
			switch (typeof(pObject))
			{
				
				case "number":
					if (pObject == 0)
					{
						tReturnObj = false;
					}
					else if (pObject == 1)
					{
						tReturnObj = true	
					}
				break;
				case "string":
					if ((Number(pObject)) == 0)
					{
						tReturnObj = false;
					}
					else if ((Number(pObject)) == 1)
					{
						tReturnObj = true	
					}
					else
					{
						var tTempString:String = pObject.toLowerCase();
						if (tTempString == "false")
						{
							tReturnObj = false;
						}
						else if (tTempString == "true")
						{
							tReturnObj = true;	
						}
					}
				break;
			}	
			
			return tReturnObj;
		}
		
			
		 /**
		 * @Note: Strips the Params looking for a Common Stated Variable of that name to use its Value
		 */
		 
		 
		public static function convertToArray(pInfo:String,pReferenceObject:Object):Array
		{
			var tArray:Array = [];
			
			var tWorkArray:Array = pInfo.split(",");
			
			var tCount:int = tWorkArray.length;
			
			for (var t:int = 0; t < tCount; t++)
			{
				if (pReferenceObject.hasOwnProperty(tWorkArray[t]))
				{
					tArray.push(pReferenceObject[tWorkArray[t]]);
				}
				else
				{
					tArray.push(tWorkArray[t]);
				}
			}

			return tArray;
		}
		
		/**
		 * @Note: Use this property to try getting the named property from the target object.
		 * @Unlike a normal property accessors, this will return a default value instead of 
		 * @"undefined" if the property doesn't exist.
		 * @You can also specificy a class for the target property.  If the property exists but
		 * @isn't of the target class, the default value will be returned instead.
		 * @param		info		Object 		Source of the target property
		 * @param		prop_name	Object 		Name of the target property
		 * @param		cls			Class		Optional type enforcement for the target property
		 */
		 
		public static function getProperty(info:Object,prop_name:String,cls:Class=null):Object {
			if(info != null) {
				if(prop_name in info) {
					var prop:Object = info[prop_name];
					if(cls != null) {
						if(prop is cls) return prop;
					} else return prop;
				}
			}
			if(cls == Number || cls == int) return 0;
			else return null;
		}
		
		/**
		 * @Note: This function tries to return a random value within a given set on constraints.
		 * @param		base		Number		First part of random value range.
		 * @param		cap			Number		Second part of random value range.
		 * @param		rolls		Number		Number of randomizer calls to make.
		 * @param		units		Number		Force the result to multiples of this value.
		 */
		 
		public static function getRandom(base:Number=0,cap:Number=1,rolls:int=1,units:Number=0):Number {
			// get base random value
			var rand:Number;
			if(rolls > 1) {
				// if more than one roll is made, take the average.
				rand = 0;
				for(var i:int = 1; i <= rolls; i++) {
					rand += Math.random();
				}
				rand = rand / rolls;
			} else {
				// otherwise, just make one random call
				rand = Math.random();
			}
			// map the value to the given range
			var diff:Number = cap - base + units;
			var mapped:Number = base + diff * rand;
			// apply unit scaling
			if(units > 0) {
				var div:int = Math.floor(mapped/units);
				return div * units;
			} else return mapped;
		}
		
		/**
		 * @Note: This function tries getting a file extension from a url string.
		 * @param		pURL			String 				URL extension is being extracted from.
		 */
		 
		public static function getFileExtension(pURL:String):String {
			if(pURL == null || pURL.length < 1) return null;
			// break URL down into directory segments
			var directories:Array = pURL.split("/");
			// extract filename
			var filename:String = directories[directories.length-1];
			// strip any added properties from end of filename
			var sections:Array = filename.split("?");
			filename = sections[0];
			// extract extension from filename
			sections = filename.split(".");
			if(sections.length > 1) return sections[sections.length-1];
			else return null;
		}
		
		/**
		 * @Note: This will try to return an new object of the same class as the target object.
		 * @param		pObj			String 				This is the name of the target class.
		 * @param		pDomain			ApplicationDomain	This is the application domain the class is drawn from.
		 */
		 
		public static function cloneObject(pObj:Object,pDomain:ApplicationDomain=null):Object {
			if(pObj != null) {
				var class_name:String = getQualifiedClassName(pObj);
				return getInstanceOf(class_name,pDomain);
			}
			return null;
		}
		
		/**
		 * @Note: This will try to return the class definition for a given object for a given application domain.
		 * @param		pName			String 				This is the name of the target class.
		 * @param		pDomain			ApplicationDomain	This is the application domain the class is drawn from.
		 */
		 
		public static function getClassOf(pObj:Object,pDomain:ApplicationDomain=null):Object {
			// check the parameters
			if(pObj == null) return null;
			if(pDomain == null) pDomain = ApplicationDomain.currentDomain;
			// If they're valid, find our class name
			var class_name:String = getQualifiedClassName(pObj);
			// convert class name to class definition
			return pDomain.getDefinition(class_name);
		}
		 
		 /**
		 * @Note: This function tries returning an instance of the given display object class.
		 * @param		pName			String 				This is the name of the target class.
		 * @param		pDomain			ApplicationDomain	This is the application domain the class is drawn from.
		 */
		 
		public static function getDisplayInstance(pName:String,pDomain:ApplicationDomain=null):DisplayObject {
			var inst:Object = getInstanceOf(pName,pDomain);
			if(inst != null) {
				if(inst is DisplayObject) return inst as DisplayObject;
				if(inst is BitmapData) return new Bitmap(inst as BitmapData);
			}
			return null;
		}
		 
		/**
		 * @Note: This will try to return an instance of the named class form a given application domain.
		 * @param		pName			String 				This is the name of the target class.
		 * @param		pDomain			ApplicationDomain	This is the application domain the class is drawn from.
		 */
		 
		public static function getInstanceOf(pName:String,pDomain:ApplicationDomain=null):Object {
			// check the parameters
			if(pName == null || pName.length <= 0) return null;
			if(pDomain == null) pDomain = ApplicationDomain.currentDomain;
			// If they're valid, try to get an instance of the target class.
			if(pDomain.hasDefinition(pName)) {
				var tClass:Object = pDomain.getDefinition(pName);
				// check for certain classes that require more than on parameter in the constructor
				// bitmapdata is a prime example as that can be found in library linkages
				var tSuperName:String = getQualifiedSuperclassName(tClass);
				if(tSuperName == getQualifiedClassName(BitmapData)) return new tClass(1,1);
				// otherwise assume the constructor requires no parameters
				return new tClass();
			}
			return null;
		}
		
	}
	
}
