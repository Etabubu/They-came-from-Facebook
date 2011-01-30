package com.gogogic.gamejam.view.components.units
{
	import com.gogogic.gamejam.assets.BasicCharacter;
	import com.gogogic.gamejam.model.vo.UnitVO;
	import com.gogogic.gamejam.view.components.UnitComponent;
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	public class ShooterUnitComponent extends UnitComponent
	{
		private var _target:UnitVO;
		private var _shotIsCoolingDown:Boolean = false;
		
		public function ShooterUnitComponent()
		{
			var unitVO:UnitVO = new UnitVO();
			unitVO.maxHealth = unitVO.currentHealth = 5;
			
			super(unitVO);
			addChild(new BasicCharacter());
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void {
			if (!_target || _target.currentHealth <= 0) _target = closestEnemy;
			if (!_target) return; // If there are no enemies on stage, just stop
			
			var targetPoint:Point = getLocationWithDistanceTo(_target, 130);
			var direction:Number = Math.atan2(targetPoint.x - _unitVO.x, targetPoint.y - _unitVO.y);
			var distance:Number = distanceTo(_target);
			
			if (!_shotIsCoolingDown && distance < 150) {
				// SHOOT
				_shotIsCoolingDown = true;
				TweenLite.delayedCall(.5, shotCooledDown);
				_target.currentHealth -= 4;
				_target.triggerDataChangeEvent();
				// TODO: show bullet
				// TODO: Target show blood, eww
			}
			unitVO.x += Math.sin(direction) * 1.4;
			unitVO.y += Math.cos(direction) * 1.4;
			unitVO.triggerDataChangeEvent();
		}
		
		private function shotCooledDown():void {
			_shotIsCoolingDown = false;
		}
		
		override protected function onDie():void {
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}