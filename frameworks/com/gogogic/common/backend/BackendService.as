package com.gogogic.common.backend 
{
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	/**
	 * Represents a backend service and allows calling methods on it asynchronously.
	 */
	public dynamic class BackendService extends Proxy
	{
		private var _gateway:BackendGateway;
		private var _serviceName:String;
		
		public function BackendService(gateway:BackendGateway, serviceName:String) 
		{
			_gateway = gateway;
			_serviceName = serviceName;
		}
		
		flash_proxy override function callProperty(methodName:*, ... args):* {
			return Call(methodName, args);
		}
		
		public function Call(methodName : String, args:Array):PendingCall {
			return new PendingCall(_gateway, _serviceName, methodName, args);
		}
	}
}