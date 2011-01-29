package com.gogogic.ui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Uses mip mapping to ensure good performance. 
	 * @author ari
	 * 
	 */
	public class BigDisplayObjectCacher extends Sprite
	{
		private static const DIMENSION_SIZE:int = 256;
		
		private var _displayObject:DisplayObject;
		private var _bitmapPool:Vector.<Bitmap>;
		private var _bitmapsInUse:Vector.<Bitmap>;
		
		public function BigDisplayObjectCacher(displayObject:DisplayObject)
		{
			_displayObject = displayObject;
			init();
		}
		
		private function init():void {
			_bitmapPool = new Vector.<Bitmap>();
			_bitmapsInUse = new Vector.<Bitmap>();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			//addChild(_displayObject);
		}
		
		public function invalidate():void {
			cache();
		}
		
		public function moved():void {
			
		}
		
		
		private function cache():void {
			if (!stage) return;
			
			recycleBitmaps();
			
			var absPoint:Point = localToGlobal(new Point());
			
			var areaScale:Point = getAbsoluteScale();
			var renderWidth:Number = 1 / areaScale.x * stage.stageWidth;
			var renderHeight:Number = 1 / areaScale.y * stage.stageHeight;
			
			var widthUnits:int = Math.ceil(renderWidth / DIMENSION_SIZE);
			var heightUnits:int = Math.ceil(renderHeight / DIMENSION_SIZE);
			
			for (var y:int = 0; y < heightUnits; y++) {
				for (var x:int = 0; x < widthUnits; x++) {
					var bitmap:Bitmap = getBitmap();
					var bitmapData:BitmapData = bitmap.bitmapData;
					
					clearBitmapData(bitmapData);
					// draw..
				}
			}
		}
		
		private function clearBitmapData(bitmapData:BitmapData):void {
			bitmapData.lock();
			for (var y:int = 0; y < bitmapData.height; y++) {
				for (var x:int = 0; x < bitmapData.width; x++) {
					bitmapData.setPixel32(x, y, 0);
				}
			}
			bitmapData.unlock();
		}
		
		private function onAddedToStage(e:Event):void {
			stage.addEventListener(Event.RESIZE, onStageResize);
			cache();
		}
		
		private function onRemovedFromStage(e:Event):void {
			stage.removeEventListener(Event.RESIZE, onStageResize);
		}
		
		private function onStageResize(e:Event):void {
			
		}
		
		public function get displayObject():DisplayObject {
			return _displayObject;
		}
		
		private function getAbsoluteScale():Point {
			var target:DisplayObject = this;
			var ret:Point = new Point(scaleX, scaleY);
			while (target.parent) {
				target = target.parent;
				ret.x *= target.scaleX;
				ret.y *= target.scaleY;
			}
			return ret;
		}
		
		private function recycleBitmaps():void {
			while (_bitmapsInUse.length > 0) {
				var bitmap:Bitmap = _bitmapsInUse.pop();
				_bitmapPool.push(bitmap);
				if (bitmap.parent == this)
					removeChild(bitmap);
			}
		}
		
		private function getBitmap():Bitmap {
			if (_bitmapPool.length == 0) {
				return new Bitmap(new BitmapData(DIMENSION_SIZE, DIMENSION_SIZE, true, 0), "auto", true);
			}
			return _bitmapPool.pop();
		}
	}
}