package com.neopets.util.button
{

		
	public interface INeopetButton
	{
		function get ID():String;
		function set ID(pString:String):void;
		function get lockOut():Boolean;
		function set lockOut(pFlag:Boolean):void;
		function setText(pString:String):void
		function getText():String;
		function get dataObject():Object;
		function get displayFlag():Boolean;
		function set displayFlag(pFlag:Boolean):void;
		function init( pConstructionData:Object = null, pID:String = "button", pObject:Object = null):void	
		function reset():void;
	}
}