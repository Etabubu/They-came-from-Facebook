package com.gogogic.util {
	import flash.events.Event;
	
	
	/*
	Example usage:
	stage.addEventListener(MouseEvent.MOUSE_DOWN, setEventListenerParams(onStageMouseDown, "A fun click"));
	
	function onStageMouseDown(e:MouseEvent, msg:String, functionRef:Function):void {
		trace(msg);
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, functionRef);
	}
	*/
	
	public function setEventListenerParams(handler:Function,...args):Function {
		return function(e:Event):void {
			try { handler.apply( this,[e].concat(args).concat(arguments.callee)); }
			catch (error:ArgumentError) { handler.apply(this,[e].concat(args)); }
		}
	}
	
}