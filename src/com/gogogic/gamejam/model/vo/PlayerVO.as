package com.gogogic.gamejam.model.vo
{
	import flash.utils.Dictionary;

	public class PlayerVO extends BaseVO
	{
		// Event
		public static const ENERGY_BARS_SWITCHED:String = "energyBarsSwitched";
		
		public var score:int;
		
		public var energy:Number;
		public var reserveEnergy:Number;
		
		public var playerUnit:UnitVO;
		
		public var id:Number;
		public var firstName:String;
		public var lastName:String;
		public var portraitUrl:String;
		
		public function get name():String {
			return firstName + lastName;
		}
		
		public var gender:String;
		public var developer:Boolean;
		
		public var family:Object = {};
	}
}