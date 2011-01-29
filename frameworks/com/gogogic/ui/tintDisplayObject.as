package com.gogogic.ui {
	
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;

	public function tintDisplayObject(obj:DisplayObject, color:uint, alpha:Number):void {
		if (alpha == 0) {
			obj.transform.colorTransform = new ColorTransform();
			return;
		} 
        var colTrans:ColorTransform = obj.transform.colorTransform;
        colTrans.redMultiplier = colTrans.greenMultiplier = colTrans.blueMultiplier = (1 - alpha);
        colTrans.redOffset = Math.round(((color >> 16) & 0xFF) * alpha);
        colTrans.greenOffset = Math.round(((color >> 8) & 0xFF) * alpha);
        colTrans.blueOffset = Math.round((color & 0xFF) * alpha);
        obj.transform.colorTransform = colTrans;
    } 
}