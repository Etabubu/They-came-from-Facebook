package com.gogogic.gamejam.model.vo
{
	
	public class FriendVO extends BaseVO
	{
		public var id:int;
		public var name:String;
		public var portraitUrl:String;
		public var bonuses:Vector.<BonusVO>;
		
		// facebook info
		public var relationship:String; //son/daughter/brother/sister/father/mother/engaged/married/complicated etc
		public var friendCount:int;
		public var mutualFriendCount:int;
		public var gender:String; // male or female
		public var developer:Boolean;
	}
}