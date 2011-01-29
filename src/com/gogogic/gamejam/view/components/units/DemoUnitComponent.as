package com.gogogic.gamejam.view.components.units
{
	import com.gogogic.gamejam.assets.BasicCharacter;
	import com.gogogic.gamejam.model.vo.UnitVO;
	import com.gogogic.gamejam.view.components.UnitComponent;
	
	import flash.events.Event;
	
	public class DemoUnitComponent extends UnitComponent
	{
		private var _target:UnitVO;
		
		public function DemoUnitComponent()
		{
			var unitVO:UnitVO = new UnitVO();
			unitVO.maxHealth = unitVO.currentHealth = 20;
			
			super(unitVO);
			addChild(new BasicCharacter());
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void {
			if (!_target) _target = closestEnemy;
			if (!_target) return; // If there are no enemies on stage, just stop
			
			var direction:Number = Math.atan2(_target.x - _unitVO.x, _target.y - _unitVO.y);
			
			unitVO.x += Math.sin(direction) * 2;
			unitVO.y += Math.cos(direction) * 2;
			unitVO.triggerDataChangeEvent();
		}
		
		private function findTarget():void {
			// Find the closest enemy
			var closestEnemy:UnitVO;
			var closestEnemyDistance:Number;
			
			for each (var enemy:UnitVO in enemyUnits) {
				var dist:Number = distanceTo(enemy);
				if (!closestEnemy || dist < closestEnemyDistance) {
					closestEnemyDistance = dist;
					closestEnemy = enemy;
				}
			}
			
			_target = closestEnemy;
		}
		
		
	}
}