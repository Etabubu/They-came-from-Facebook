package com.gogogic.gamejam.view.components.units
{
	import com.gogogic.gamejam.assets.BasicCharacter;
	import com.gogogic.gamejam.model.vo.UnitVO;
	import com.gogogic.gamejam.view.components.UnitComponent;
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.geom.Point;

	public class SlasherUnitComponent extends UnitComponent
	{
		private var _target:UnitVO;
		private var _resting:Boolean = false;
		
		public function SlasherUnitComponent()
		{
			var unitVO:UnitVO = new UnitVO();
			unitVO.maxHealth = unitVO.currentHealth = 50;
			
			super(unitVO);
			addChild(new BasicCharacter());
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void {
			if (_resting) return;
			if (!_target || _target.currentHealth <= 0) _target = closestEnemy;
			if (!_target) return; // If there are no enemies on stage, just stop
			
			var direction:Number = Math.atan2(_target.x - _unitVO.x, _target.y - _unitVO.y);
			var distance:Number = distanceTo(_target);
			
			if (distance < 60) {
				// Dash
				var dashDistance:Number = distance * 2 < 50 ? 50 : distance * 2;
				unitVO.x += Math.sin(direction) * 120;
				unitVO.y += Math.cos(direction) * 120;
				unitVO.triggerDataChangeEvent();
				// TODO: Show dash animation
				_target.currentHealth -= 8;
				_resting = true;
				TweenLite.delayedCall(1, onDoneResting);
			} else {
				// Just move
				unitVO.x += Math.sin(direction) * 2;
				unitVO.y += Math.cos(direction) * 2;
				unitVO.triggerDataChangeEvent();
			}
			
			
		}
		
		private function onDoneResting():void {
			_resting = false;
		}
		
		override protected function onDie():void {
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}