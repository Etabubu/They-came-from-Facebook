package com.gogogic.ui {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	
	public function sortChildrenDepths(container:DisplayObjectContainer, sortFunction:Function, childrenArray:Array = null):void {
		if (!childrenArray) {
			childrenArray = [];
			for (var i:int = 0; i < container.numChildren; i++) {
				childrenArray[i] = container.getChildAt(i);
			}
		}
		
		childrenArray.sort(sortFunction);
		
		for (i = 0; i < childrenArray.length; i++) {
			container.setChildIndex(childrenArray[i] as DisplayObject, i);
		}
	}
}