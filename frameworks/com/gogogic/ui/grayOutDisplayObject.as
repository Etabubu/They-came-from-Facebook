package com.gogogic.ui {
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	
	public function grayOutDisplayObject(obj:DisplayObject, all:Boolean = true, redScale:Number = 0.3086, greenScale:Number = 0.6094, blueScale:Number = 0.082):void {
		if (obj == null) return;
		var grayOutFilter:ColorMatrixFilter = makeGrayColorMatrixFilter(redScale, greenScale, blueScale);
		if (all) obj.filters = new Array().concat(obj.filters, grayOutFilter);
		else obj.filters = new Array().concat(grayOutFilter, obj.filters);
	}
}