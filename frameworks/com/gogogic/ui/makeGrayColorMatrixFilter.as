package com.gogogic.ui {
	import flash.filters.ColorMatrixFilter;
	
	public function makeGrayColorMatrixFilter(redScale:Number = 0.3086, greenScale:Number = 0.6094, blueScale:Number = 0.082):ColorMatrixFilter {
		// Grayscale matrix
		var nocolor:Array = [redScale, greenScale, blueScale,  0,      0,		// red
							 redScale, greenScale, blueScale,  0,      0,		// green
							 redScale, greenScale, blueScale,  0,      0,		// blue
							 0,      0,      0,      1,      0];	// alpha
		var grayOutFilter:ColorMatrixFilter = new ColorMatrixFilter(nocolor);
		return grayOutFilter;
	}
}