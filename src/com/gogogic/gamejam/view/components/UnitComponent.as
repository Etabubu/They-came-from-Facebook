package com.gogogic.gamejam.view.components
{
	import com.gogogic.gamejam.model.vo.UnitVO;
	import com.gogogic.gamejam.model.vo.event.DataChangeEvent;
	
	import flash.display.Sprite;
	
	public class UnitComponent extends Sprite
	{
		protected var _unitVO:UnitVO;
		
		public function UnitComponent(unitVO:UnitVO)
		{
			_unitVO = unitVO;
			_unitVO.addEventListener(DataChangeEvent.DATA_CHANGE, onUnitVODataChange);
			update();
		}
		
		public function get unitVO():UnitVO {
			return _unitVO;
		}
		
		protected function onUnitVODataChange(e:DataChangeEvent):void {
			update();
		}
		
		protected function update():void {
			// Basic motor functions
			x = _unitVO.x;
			y = _unitVO.y;
			rotation = _unitVO.rotation;
		}
	}
}