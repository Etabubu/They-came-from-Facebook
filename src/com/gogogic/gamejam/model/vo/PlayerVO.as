package com.gogogic.gamejam.model.vo
{
	public class PlayerVO extends BaseVO
	{
		// Event
		public static const ENERGY_BARS_SWITCHED:String = "energyBarsSwitched";
		
		public var score:int;
		
		public var energy:Number = 1;
		public var reserveEnergy:Number = 1;
		
		public var playerUnit:PlayerUnitVO;
	}
}