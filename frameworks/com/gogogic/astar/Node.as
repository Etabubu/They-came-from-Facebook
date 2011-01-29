package com.gogogic.astar
{
	public class Node
	{
		public var x:int;
		public var y:int;
		public var index:int;
		public var walkable:Boolean;
		public var parent:Node;
		public var walkCost:Number = 1;
		
		public var cost:Number;
		
		public function toString():String 
		{
			return index + " (x: " + x + ", y: " + y + ")";
		}
	}
}