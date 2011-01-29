package com.gogogic.util {
	import flash.events.Event;
	
	
	public function setFrameScriptParams(handler:Function,...args):Function {
		return function():void {
			handler.apply(this, args);
		}
	}
	
}