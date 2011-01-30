package com.gogogic.gamejam.model.vo
{
	
	public class FriendVO extends BaseVO
	{
		public var id:Number;
		public var name:String;
		public var portraitUrl:String;
		public var bonuses:Vector.<BonusVO>;
		public var unitType:UnitTypeBaseVO;
		public var energyCost:Number;
		
		// facebook info
		public var relationship:String; //son/daughter/brother/sister/father/mother/engaged/married/complicated etc
		public var friendCount:int;
		public var mutualFriendCount:int;
		public var gender:String; // male or female
		public var developer:Boolean;
	}
}