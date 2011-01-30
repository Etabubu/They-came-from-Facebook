package com.gogogic.gamejam.model.vo
{
	public class PlayerVO extends BaseVO
	{
		// Event
		public static const ENERGY_BARS_SWITCHED:String = "energyBarsSwitched";
		
		public var score:int;
		
		public var energy:Number;
		public var reserveEnergy:Number;
		
		public var playerUnit:UnitVO;
	}
}