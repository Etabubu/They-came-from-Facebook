package com.gogogic.gamejam.view.components
{
	import br.com.stimuli.loading.BulkLoader;
	
	import com.gogogic.gamejam.assets.NextUpIcon;
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
		
		public function EnemyCardComponent(friendVO:FriendVO)
		{
			_friendVO = friendVO;
			init();
		}
		
		private function init():void {
			var nextUpIcon:NextUpIcon = new NextUpIcon();
			addChild(nextUpIcon);
			
			
			if (_friendVO) {
				nextUpIcon.txtClass.text = _friendVO.name;
				nextUpIcon.mcPortrait.addChild(new PortraitComponent(_friendVO.portraitUrl, 50));
			} else {
				// TODO: Show a question mark instead
				nextUpIcon.txtClass.text = "?";
			}
		}
	}
}