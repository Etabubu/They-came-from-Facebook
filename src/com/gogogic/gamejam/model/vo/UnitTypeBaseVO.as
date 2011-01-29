package com.gogogic.gamejam.model.vo
{
	
	public class UnitTypeBaseVO extends BaseVO
	{
		public var powerLevel:Number;
		public var comments:Vector.<String>;
		
		public function UnitTypeBaseVO() {
			powerLevel = 100; //TODO: make this based on something from facebook
			comments = new Vector.<String>();
		}
		
		// TODO: make this a nice formula
		private var _maxHealth:Number;
		public function get maxHealth():Number {
			if(isNaN(_maxHealth)) _maxHealth = Math.ceil(powerLevel / 10);
			return _maxHealth;
		}
		
		private var _health:Number;
		public function get health():Number {
			if(isNaN(_health)) _health = maxHealth;
			return _health;
		}
		
		// TODO: make this a nice formula
		private var _damage:Number;
		public function get damage():Number {
			if(isNaN(_damage)) _damage = Math.ceil(powerLevel / 10);
			return _damage;
		}
		
		// TODO: here or in concrete class - talk() move() attack() and one to call these doAction()
	}
}