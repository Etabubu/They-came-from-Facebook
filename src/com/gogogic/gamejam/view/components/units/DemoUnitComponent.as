package com.gogogic.gamejam.view.components.units
{
	import com.gogogic.gamejam.assets.BasicCharacter;
	import com.gogogic.gamejam.model.vo.UnitVO;
	import com.gogogic.gamejam.view.components.UnitComponent;
	
	import flash.events.Event;
	
	public class DemoUnitComponent extends UnitComponent
	{
		public function DemoUnitComponent(unitVO:UnitVO)
		{
			super(unitVO);
			addChild(new BasicCharacter());
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void {
			unitVO.x += 1.5 - Math.random() * 3;
			unitVO.y += 1.5 - Math.random() * 3;
			unitVO.triggerDataChangeEvent();
		}
	}
}