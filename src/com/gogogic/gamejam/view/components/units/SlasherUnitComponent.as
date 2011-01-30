package com.gogogic.gamejam.view.components.units
{
	import com.gogogic.gamejam.assets.BasicCharacter;
	import com.gogogic.gamejam.model.vo.UnitVO;
	import com.gogogic.gamejam.view.components.UnitComponent;
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;

	public class SlasherUnitComponent extends UnitComponent
	{
		private var _target:UnitVO;
		private var _resting:Boolean = false;
		private var _character:MovieClip;
		
		public function SlasherUnitComponent()
		{
			var unitVO:UnitVO = new UnitVO();
			unitVO.maxHealth = unitVO.currentHealth = 50;
			
			super(unitVO);
		}
		
		
		
		override protected function onInitDone():void {
			_character = new BasicCharacter();
			if (unitVO.isEnemy) _character.gotoAndStop(2);
			addChild(_character);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void {
			if (_resting) return;
			if (!_target || _target.currentHealth <= 0) _target = closestEnemy;
			if (!_target) return; // If there are no enemies on stage, just stop
			
			var direction:Number = Math.atan2(_target.y - _unitVO.y, _target.x - _unitVO.x);
			var distance:Number = distanceTo(_target);
			
			if (distance < 60) {
				// Dash
				var dashDistance:Number = distance + 130;
				
				TweenLite.to(unitVO, .3, { x: unitVO.x + Math.cos(direction) * 120, y: unitVO.y + Math.sin(direction) * 120, onUpdate: unitVO.triggerDataChangeEvent });
				
				unitVO.triggerDataChangeEvent();
				// TODO: Show dash animation
				_target.currentHealth -= 8;
				_resting = true;
				TweenLite.delayedCall(1, onDoneResting);
			} else {
				// Just move
				unitVO.x += Math.cos(direction) * 2;
				unitVO.y += Math.sin(direction) * 2;
				unitVO.rotation = direction * 180 / Math.PI;
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
		
		override public function dispose():void {
			super.dispose();
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
	}
}