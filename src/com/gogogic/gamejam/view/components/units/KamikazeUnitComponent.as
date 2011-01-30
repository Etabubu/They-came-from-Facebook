package com.gogogic.gamejam.view.components.units
{
	import com.gogogic.gamejam.assets.BasicCharacter;
	import com.gogogic.gamejam.model.vo.UnitVO;
	import com.gogogic.gamejam.view.components.UnitComponent;
	import com.gogogic.ui.tintDisplayObject;
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	
	public class KamikazeUnitComponent extends UnitComponent
	{
		private var _target:UnitVO;
		
		public function KamikazeUnitComponent()
		{
			var unitVO:UnitVO = new UnitVO();
			unitVO.maxHealth = unitVO.currentHealth = 10;
			
			super(unitVO);
			addChild(new BasicCharacter());
			tintDisplayObject(this, 0xFF0000, .5);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
		}
		
		private function onEnterFrame(e:Event):void {
			if (!_target) _target = closestEnemy;
			if (!_target) return; // If there are no enemies on stage, just stop
			
			var direction:Number = Math.atan2(_target.x - _unitVO.x, _target.y - _unitVO.y);
			
			unitVO.x += Math.sin(direction) * 5;
			unitVO.y += Math.cos(direction) * 5;
			unitVO.triggerDataChangeEvent();
			
			if (distanceTo(_target) < 20) {
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				// EXPLODE
				// TODO: Explode animation
				_target.currentHealth -= 50;
				_target.triggerDataChangeEvent();
				_unitVO.currentHealth = 0;
				_unitVO.triggerDataChangeEvent();
				alpha = .3;
				TweenLite.delayedCall(1, dispatchEvent, [new Event(Event.COMPLETE)]);
			}
		}
	}
}