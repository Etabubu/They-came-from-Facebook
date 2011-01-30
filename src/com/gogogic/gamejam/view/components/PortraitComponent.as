package com.gogogic.gamejam.view.components
{
	import br.com.stimuli.loading.BulkLoader;
	
	import com.gogogic.gamejam.bulkLoad;
	
	import flash.display.Bitmap;
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
			var portraitBitmap:Bitmap = new Bitmap(bulkLoader.getBitmapData(path), "auto", true);
			portraitBitmap.width = portraitBitmap.height = _size;
			addChild(portraitBitmap);
		}
	}
}