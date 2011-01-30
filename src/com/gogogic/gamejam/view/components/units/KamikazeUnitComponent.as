package com.gogogic.gamejam.view.components.units
{
	import com.gogogic.gamejam.assets.BasicCharacter;
	import com.gogogic.gamejam.assets.BlowupEffect;
	import com.gogogic.gamejam.model.vo.UnitVO;
	import com.gogogic.gamejam.view.components.UnitComponent;
	import com.gogogic.ui.tintDisplayObject;
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class KamikazeUnitComponent extends UnitComponent
	{
		private var _target:UnitVO;
		private var _character:MovieClip;
		
		public function KamikazeUnitComponent()
		{
			var unitVO:UnitVO = new UnitVO();
			unitVO.maxHealth = unitVO.currentHealth = 10;
			
			super(unitVO);
		}
		
		override protected function onInitDone():void {
			_character = new BasicCharacter();
			if (unitVO.isEnemy) _character.gotoAndStop(2);
			addChild(_character);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			tintDisplayObject(this, 0xFF0000, .1);
		}
		
		private function onEnterFrame(e:Event):void {
			if (!_target || _target.currentHealth <= 0) _target = closestEnemy;
			if (!_target) return; // If there are no enemies on stage, just stop
			
			var direction:Number = Math.atan2(_target.y - _unitVO.y, _target.x - _unitVO.x);
			
			unitVO.x += Math.cos(direction) * 5;
			unitVO.y += Math.sin(direction) * 5;
			unitVO.rotation = direction * 180 / Math.PI;
			unitVO.triggerDataChangeEvent();
			
			if (distanceTo(_target) < 20) {
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				_unitVO.currentHealth = 0;
				// onDie will get called here
				_unitVO.triggerDataChangeEvent();
				_target.currentHealth -= 50;
				_target.triggerDataChangeEvent();
			}
		}
		
		override protected function onDie():void {
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			// EXPLODE
			removeChild(_character);
			TweenLite.delayedCall(.3, dispatchEvent, [new Event(Event.COMPLETE)]);
			addChild(new BlowupEffect());
		}
		
		override public function dispose():void {
			super.dispose();
			TweenLite.killDelayedCallsTo(dispatchEvent);
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
	}
}