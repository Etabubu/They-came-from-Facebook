package com.gogogic.common.backend {
	import com.adobe.serialization.json.JSON;
	import com.gogogic.common.backend.event.BackendErrorEvent;
	
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;

	//import nl.demonsters.debugger.MonsterDebugger;
	/**
	 * A temporary proxy for pending calls, is used to register event handlers 
	 */
	public class PendingCall {
		protected static var _referenceHolder:Array = [];
		
		protected var _connection:NetConnection;
		protected var _gateway:BackendGateway;
		protected var _serviceName:String;
		protected var _methodName:String;
		protected var _arguments:Array;
		protected var _responder:Responder;
		protected var _handler:Function;
		protected var _handlerArgs:Array;
		protected var _important:Boolean;
		protected var _tryCount:int;
		
		public function PendingCall(gateway:BackendGateway, serviceName:String, methodName:String, args:Array) {
			_gateway = gateway;
			_serviceName = serviceName;
			_methodName = methodName;
			_tryCount = 0;
			_arguments = args;
			_handlerArgs = [];
			initConnection();
			_referenceHolder.push(this);
		}
		
		protected function initConnection():void {
			_connection = new NetConnection();
			_connection.connect(_gateway.gatewayUrl);
			_connection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
		}
		
		
		
		/**
		 * Starts the call with the specified onSuccess handler.
		 */
		public function set handler(handler:Function): void {
			call(handler);
		}
		
		/**
		 * Runs the webservice call if no handler is to be used.
		 */
		public function call(handler:Function = null, important:Boolean = true, ...args):void {
			if (important)
				trace("Calling backend: " + _serviceName + "." + _methodName + "(" + joinArgs(_arguments) + ")");
			
			if (important)
				_tryCount = 3;
			_handlerArgs = args;
			_handler = handler;
			
			performCall();
		}
		
		private function joinArgs(args:Array):String {
			// This function was made to not trace out whole byte arrays which can get pretty big
			var ret:String = "";
			for each (var arg:Object in args) {
				if (arg is ByteArray)
					ret += "[ByteArray]";
				else
					ret += String(arg);
				ret += ", ";
			}
			
			return ret.substring(0, ret.length - 2);
		}
		
		protected function performCall():void {
			var argArray:Array = [ _serviceName + "." + _methodName, new Responder(onSuccess, onBackendError)];
			argArray = argArray.concat(_arguments);
			_connection.call.apply(_connection, argArray);
		}
		
		protected function onSuccess( data:Object ):void {
			trace("Data recieved for " +  _serviceName + "." + _methodName);
			if ( _gateway.debug ) {
				trace("DEBUG: " + JSON.encode(data));
			}
			
			if ( _handler != null ) {
				_handler.apply(null, [data].concat(_handlerArgs));
			}
			dereference();
		}
		
		protected function onBackendError(e:Object): void {
			var detailString:String = "";
			for (var infoCode:String in e)
				detailString += infoCode + ": " + e[infoCode] + "\n";
			fail("Backend Error", e.description,  detailString);
		}
		
		protected function onNetStatus(e:NetStatusEvent):void {
			if (e.info.level == "error")
				fail("Network Error", e.info.code, "Code: " + e.info.code + "\nDescription: " + e.info.description + "\nDetails: " + e.info.details);
		}
		
		protected function fail(error:String, errorDescription:String = "", errorDetails:String = ""):void {
			// Is this an important call? 
			if (_tryCount > 0) {
				if (_tryCount == 1) {
					dereference();
					trace("Could not call ",  _serviceName + "." + _methodName, "() after 3 tries.");
					_gateway.dispatchEvent(new BackendErrorEvent(BackendErrorEvent.BACKEND_ERROR, this, error, errorDescription, errorDetails));
				} else {
					trace("Retrying important call");
					_tryCount -= 1;
					performCall();
				}
			}
			else {
				dereference();
				_gateway.dispatchEvent(new BackendErrorEvent(BackendErrorEvent.BACKEND_ERROR, this, error, errorDescription, errorDetails));
			}
		}
		
		protected function dereference():void {
			_connection.removeEventListener(NetStatusEvent.NET_STATUS, onBackendError);
			if (_referenceHolder.indexOf(this) != -1) {
				_referenceHolder.splice(_referenceHolder.indexOf(this), 1);
			}
		}
	}
	
}