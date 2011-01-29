package com.gogogic.common.backend 
{	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	/**
	 * Manages and instantiates backend services.
	 */
	public dynamic class BackendGateway extends Proxy implements IEventDispatcher
	{
		protected var _gatewayUrl:String;
		protected var _services:Object;
		protected var _debug:Boolean;
		
		public function BackendGateway(gateway:String, debug:Boolean = false)
		{
			_dispatcher = new EventDispatcher()
			_gatewayUrl = gateway;
			_services = new Object();
			_debug = debug;
		}
		
		public function getService(serviceName:String):BackendService {
			if (_services[serviceName])
				return _services[serviceName];
			return _services[serviceName] = new BackendService(this, serviceName);
		}
		
		flash_proxy override function getProperty(propertyName:*):* {
			return getService(propertyName);
		}
		
		public function get gatewayUrl():String {
			return _gatewayUrl;
		}
		public function get debug():Boolean {
			return _debug;
		}
		
		// IEventDispatcher \\
		
		private var _dispatcher:EventDispatcher;
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			_dispatcher.addEventListener(type, listener, useCapture, priority);
		}
		
		public function dispatchEvent(evt:Event):Boolean {
			return _dispatcher.dispatchEvent(evt);
		}
		
		public function hasEventListener(type:String):Boolean {
			return _dispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			_dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean {
			return _dispatcher.willTrigger(type);
		}
		
		
	}
	
}