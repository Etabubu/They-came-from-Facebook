package com.gogogic.gamejam.model.vo
{
	import flash.display.MovieClip;

	public class UnitVO extends BaseVO
	{
		public var friendVO:FriendVO;
		
		public var isEnemy:Boolean;
		public var x:Number;
		public var y:Number;
		public var rotation:Number;
		public var maxHealth:Number;
		public var currentHealth:Number;
	}
}