package com.gogogic.ui {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
		
	public function makeOutlines(disp:DisplayObject, outlineWidth:int = 2, outlineColor:uint = 0x000000):OutlinesContainer {
		if (disp is DisplayObjectContainer) {
			// If the display object can contain children, we will add the shadow to the bottom of its display list for convenience.
			// Check if it has already been outlined and remove the outlines if found.
			for (var i:int = 0; i < (disp as DisplayObjectContainer).numChildren; i++) {
				var ocToRemove:OutlinesContainer = (disp as DisplayObjectContainer).getChildAt(i) as OutlinesContainer;
				if (ocToRemove) {
					if (ocToRemove.outlinedObject == disp) {
						(disp as DisplayObjectContainer).removeChild(ocToRemove);
						break;
					}
				}
			}
		} else {
			// Otherwise, we will add it to its parent display list, under the object itself.
			if (!disp.parent) {
				// If the object has no parent then we have no where to add the outlines to. Throw an error.
				throw new Error("Cannot add outlines to a display object that is not a DisplayObjectContainer and is not on the display list.");
			}
			// Else, check to see if it's already been added
			for (i = 0; i < disp.parent.numChildren; i++) {
				ocToRemove = disp.parent.getChildAt(i) as OutlinesContainer;
				if (ocToRemove) {
					if (ocToRemove.outlinedObject == disp) {
						disp.parent.removeChild(ocToRemove);
						break;
					}
				}
			}
		}
		var matrix:Matrix = new Matrix();
		var rect:Rectangle = disp.getBounds(disp);
		var orgText:BitmapData = new BitmapData(Math.ceil(rect.width), Math.ceil(rect.height), true, 0x00000000);
		matrix.tx = -rect.x;
		matrix.ty = -rect.y;
		var colorTransform:ColorTransform = new ColorTransform(
			0, 0, 0, 1, (outlineColor & 0xFF0000) >> 16, (outlineColor & 0x00FF00) >> 8, outlineColor & 0x0000FF, 150);
		orgText.draw(disp, matrix, colorTransform, null, null, true);
		var outlines:BitmapData = new BitmapData(orgText.width + outlineWidth * 2, orgText.height + outlineWidth * 2, true, 0x00000000);
		outlines.draw(orgText);
		
		for (i = -outlineWidth; i <= outlineWidth; i++) {
			for (var j:int = -outlineWidth; j <= outlineWidth; j++) {
				matrix.tx = outlineWidth + i;
				matrix.ty = outlineWidth + j;
				outlines.draw(orgText, matrix);
			}
		}
		
		outlines.applyFilter(outlines, new Rectangle(0, 0, outlines.width, outlines.height), new Point(0, 0), new BlurFilter(1.5, 1.5));
		
		var bitmap:OutlinesContainer = new OutlinesContainer(disp, outlines);
		bitmap.x = disp.x - outlineWidth;
		bitmap.y = disp.y - outlineWidth;
		
		if (disp.name != null && disp.name != "")
			bitmap.name = disp.name + "_outlines";
		
		if (disp is DisplayObjectContainer) {
			(disp as DisplayObjectContainer).addChildAt(bitmap, 0);
		} else {
			disp.parent.addChildAt(bitmap, disp.parent.getChildIndex(disp));
		}
		
		return bitmap;
	}
	
}

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;

class OutlinesContainer extends Bitmap {
	private var _outlinedObject:DisplayObject;
	
	function OutlinesContainer(outlinedObject:DisplayObject, bitmapData:BitmapData, pixelSnapping:String = "auto", smoothing:Boolean = false) {
		_outlinedObject = outlinedObject;
		super(bitmapData, pixelSnapping, smoothing);
	}
	
	public function get outlinedObject():DisplayObject {
		return _outlinedObject;
	}
}



