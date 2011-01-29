package com.neopets.util.events
{
	import flash.events.*;

	public class CustomEvent extends Event
	{
		public static const SEND:String = "send";
		public var oData:Object;
		
		public function CustomEvent(srcData:Object, type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			oData = srcData;
		}
		
	}
}
