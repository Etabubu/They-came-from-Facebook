package com.gogogic.gamejam.model.vo.event
{
	import com.neopets.vendor.gogogic.terrarium.model.vo.BaseVO;
	
	import flash.events.Event;
	
	public class DataChangeEvent extends Event
	{
		public static const DATA_CHANGE:String = "dataChange";
		
		private var _property:String;
		private var _oldVO:BaseVO;
		private var _data:Object;
		
		public function DataChangeEvent(type:String, oldVO:BaseVO, property:String = null, data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_oldVO = oldVO;
			_property = property;
			_data = data;
			super(type, bubbles, cancelable);
		}
		
		public function get property():String {
			return _property;
		}
		
		public function get oldVO():BaseVO {
			return _oldVO;
		}
		
		public function get data():Object {
			return _data;
		}
		
		override public function clone():Event {
			return new DataChangeEvent(type, _oldVO.clone(), property, data, bubbles, cancelable);
		}
		
	}
}