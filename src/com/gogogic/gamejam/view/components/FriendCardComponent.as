package com.gogogic.gamejam.view.components
{
	import br.com.stimuli.loading.BulkLoader;
	
	import com.gogogic.gamejam.Application;
	import com.gogogic.gamejam.bulkLoad;
	import com.gogogic.gamejam.model.vo.FriendVO;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class FriendCardComponent extends Sprite
	{
		private var _friendVO:FriendVO;
		
		public function FriendCardComponent(friendVO:FriendVO)
		{
			_friendVO = friendVO;
			bulkLoad(friendVO.portraitUrl, onPortraitLoaded);
		}
		
		public function get friendVO():FriendVO {
			return _friendVO;
		}
		
		private function onPortraitLoaded(bulkLoader:BulkLoader, path:String):void {
			var portraitBitmap:Bitmap = new Bitmap(bulkLoader.getBitmapData(path));
			addChild(portraitBitmap);
		}
	}
}