package com.gogogic.common.backend.event
{
	import com.gogogic.common.backend.PendingCall;
	
	import flash.events.Event;

	public class BackendErrorEvent extends Event
	{
		public static const BACKEND_ERROR:String = "onBackendError";
		
		public var error:String;
		public var errorDescription:String;
		public var errorDetails:String;
		public var pendingCall:PendingCall;
		
		public function BackendErrorEvent(type:String, pendingCall:PendingCall, error:String, errorDescription:String = "", errorDetails:String = "", bubbles:Boolean = false, cancelable:Boolean = false)
		{
			this.error = error;
			this.errorDescription = errorDescription;
			this.errorDetails = errorDetails;
			super(type, bubbles, cancelable);
		}
	}
}