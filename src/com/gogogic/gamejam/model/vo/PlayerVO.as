package com.gogogic.gamejam.model.vo
{
	import flash.utils.Dictionary;

	public class PlayerVO extends BaseVO
	{
		// Event
		public static const ENERGY_BARS_SWITCHED:String = "energyBarsSwitched";
		
		public var score:int;
		
		public var energy:Number = 1;
		public var reserveEnergy:Number = 1;
		
		public var id:Number;
		public var firstName:String;
		public var lastName:String;
		public var name:String;
		public var portraitUrl:String;
		
		public var gender:String;
		public var developer:Boolean;
		
		public var family:Object = {};
		
		public var playerUnit:PlayerUnitVO;
	}
}