// ---------------------------------------------------------------------------------------
// GAME BIOS
//
// Author: Ollie B. , Clive Henrick
// Last Update: 06/10/09
//
// ---------------------------------------------------------------------------------------
package com.neopets.projects.np9.system
{
	// SYSTEM IMPORTS
	import flash.display.MovieClip;
	
	// -----------------------------------------------------------------------------------
	public class NP9_BIOS extends MovieClip{

		public var debug:Boolean;
		public var translation:Boolean;
		public var trans_debug:Boolean;
		public var dictionary:Boolean;
		public var game_id:Number;
		public var game_lang:String;
		public var meterX:Number;
		public var meterY:Number;
		public var script_server:String;
		public var game_server:String;
		public var metervisible:Boolean;
		public var localTesting:Boolean;
		public var localPathway:String;
		public var game_datestamp:String;
		public var game_timestamp:String;
		public var game_infostamp:String;
		public var iBIOSWidth:int;
		public var iBIOSHeight:int;
		public var finalPathway:String;
		public var useConfigFile:Boolean;
		public var useFlexEmbed:Boolean;
		
		// -------------------------------------------------------------------------------
		// CONSTRUCTOR
		// -------------------------------------------------------------------------------
		public function NP9_BIOS(){}
	}
}