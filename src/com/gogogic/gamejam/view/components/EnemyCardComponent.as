package com.gogogic.gamejam.view.components
{
	import br.com.stimuli.loading.BulkLoader;
	
	import com.gogogic.gamejam.bulkLoad;
	import com.gogogic.gamejam.model.vo.FriendVO;
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class EnemyCardComponent extends Sprite
	{
		private var _portraitHolder:Sprite;
		private var _friendVO:FriendVO;
		private var _friendName:TextField;
		
		public function EnemyCardComponent(friendVO:FriendVO)
		{
			_friendVO = friendVO;
			init();
		}
		
		private function init():void {
			addChild(_portraitHolder = new Sprite());
			_portraitHolder.x = -25;
			_portraitHolder.graphics.lineStyle(1, 0x000000);
			_portraitHolder.graphics.beginFill(0xFFFFFF);
			_portraitHolder.graphics.drawRect(.5, .5, 49, 49);
			_portraitHolder.graphics.endFill();
			
			_friendName = new TextField();
			_friendName.selectable = false;
			_friendName.autoSize = TextFieldAutoSize.LEFT;
			
			if (_friendVO) {
				_friendName.text = _friendVO.name;
				bulkLoad(_friendVO.portraitUrl, onPortraitLoaded);
			} else {
				// TODO: Show a question mark instead
				_friendName.text = "?";
			}
			
			_friendName.x = -Math.round(_friendName.width / 2);
			addChild(_friendName);
			_friendName.filters = [new GlowFilter(0xFFFFFF1, 1, 3, 3, 1)];
		}
		
		private function onPortraitLoaded(bulkLoader:BulkLoader,path:String):void {
			var bitmap:Bitmap = new Bitmap(bulkLoader.getBitmapData(path));
			_portraitHolder.addChild(bitmap);
			bitmap.alpha = 0;
			TweenLite.to(bitmap, .5, { alpha: 1 });
		}
	}
}