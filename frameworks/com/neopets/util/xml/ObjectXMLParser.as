package com.neopets.util.xml
{
	
	import flash.system.ApplicationDomain;
	
	/**
	 *	This is for converting a XML to an Object
	 *	Please use ASDocs if you can for your notes
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Sean Chatman
	 *	@since  02.01.2009
	 */
	 
	public class ObjectXMLParser
	{
		public function ObjectXMLParser()
		{
		}

		public static function xmlToObject(pValue:XML):Object
		{
			var obj:Object = typeValue(pValue.@type);
				
			for each(var prop:XML in pValue.children())
		    {
		    	if (prop.children().length() > 1)
		    	{
		    		var tInnerObject:Object = {};
		    		var tCount:uint = 0;
		    		
		    		for each(var innerProp:XML in prop.children())
		    		{
		    			if (tInnerObject.hasOwnProperty(innerProp.localName()))
		    			{
		    				tInnerObject[innerProp.localName()+tCount] = typeValue(innerProp.@type, innerProp.toString());			
		    			}
		    			else
		    			{
		    				tInnerObject[innerProp.localName()] = typeValue(innerProp.@type, innerProp.toString());		
		    			}
		    			tCount++;
		    		}
		    		
		    		obj[prop.localName()] = tInnerObject;
		    	}
		    	else
		    	{
		    		obj[prop.localName()] = typeValue(prop.@type, prop.toString());
		    	}
		    	
		    	
		    }
		    
		    return obj;
		}
		
		public static function typeValue(pType:String, value:String = ""):Object
		{
			switch(pType)
			{
				case "String":
					return String(value);
				case "Number":
					return Number(value);
				case "Boolean":
					return value == "true" ? true : false;
				case "Combo":
					return String(value);
				default:
					return strongType(pType);
			}
			
			return null;
		}
		
		public static function strongType(type:String):Object
		{
			try
			{
				var clazz:Class = Class(ApplicationDomain.currentDomain.getDefinition(type));
				
				return new clazz();
		 	} 
		 	catch(e:*)
		 	{
		 		return null;
		 	}
		 	
		 	return null;
		}
	}
}