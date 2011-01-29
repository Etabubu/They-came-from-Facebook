package com.gogogic.gamejam.model.vo
{
	import com.gogogic.util.ShallowCloner;
	import com.gogogic.gamejam.model.vo.event.DataChangeEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	/**
	 * Dispatched when any data on a value object is changed. 
	 */	
	[Event(name="dataChange", type="com.neopets.vendor.gogogic.terrarium.model.vo.event.DataChangeEvent")]
	
	[RemoteClass(alias="BaseVO")]
	public class BaseVO extends EventDispatcher
	{
		private var _copy:BaseVO;
		
		public function BaseVO()
		{
			super(null);
		}
		
		/**
		 * Makes an internal copy of this instance to send when <code>triggerDataChangeEvent</code>
		 * is called.
		 */
		public function holdState():void {
			_copy = clone();
		}
		
		/**
		 * Dispatches a data change event. Remember to call <code>holdState</code> before calling
		 * this method so the event can contain a copy of the value object before it changed.
		 * 
		 */
		public function triggerDataChangeEvent(property:String = null, data:Object = null):void {
			dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE, _copy, property, data));
			_copy = null;
		}
		
		public function clone():BaseVO {
			return ShallowCloner.clone(this) as BaseVO;
		}
	}
}