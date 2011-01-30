package com.gogogic.gamejam.view.components
{
	import br.com.stimuli.loading.BulkLoader;
	
	import com.gogogic.gamejam.bulkLoad;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.system.JPEGLoaderContext;
	
	public class PortraitComponent extends Sprite
	{
		private var _size:Number;
		
		public function PortraitComponent(portraitUrl:String, size:Number = 86)
		{
			_size = size;
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, _size, _size);
			graphics.endFill();
			bulkLoad(portraitUrl, onPortraitLoaded);
		}
		
		private function onPortraitLoaded(bulkLoader:BulkLoader, path:String):void {
			var portraitDisplayObject:DisplayObject = bulkLoader.getDisplayObjectLoader(path);
			var bm:BitmapData = new BitmapData(portraitDisplayObject.width, portraitDisplayObject.height, true, 0x00000000);
			bm.draw(portraitDisplayObject);
			var portraitBitmap:Bitmap = new Bitmap(bm, "auto", true);
			portraitBitmap.width = portraitBitmap.height = _size;
			addChild(portraitBitmap);
		}
	}
}