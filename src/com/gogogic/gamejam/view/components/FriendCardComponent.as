package com.gogogic.gamejam.view.components
{
	import br.com.stimuli.loading.BulkLoader;
	
	import com.gogogic.gamejam.Application;
	import com.gogogic.gamejam.assets.FriendCardGraphic;
	import com.gogogic.gamejam.bulkLoad;
	import com.gogogic.gamejam.model.vo.FriendVO;
	import com.gogogic.ui.tintDisplayObject;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class FriendCardComponent extends Sprite
	{
		private var _friendVO:FriendVO;
		private var _friendCard:FriendCardGraphic;
		
		public function FriendCardComponent(friendVO:FriendVO)
		{
			addChild(_friendCard = new FriendCardGraphic());
			_friendVO = friendVO;
			var portrait:PortraitComponent = new PortraitComponent(_friendVO.portraitUrl);
			_friendCard.mcPortrait.addChild(portrait);
			_friendCard.txtName.text = _friendVO.name;
			_friendCard.txtClass.text = "Berserker";
			_friendCard.txtPowerLevel.text = "6";
			discardButton.buttonMode = true;
			discardButton.addEventListener(MouseEvent.ROLL_OVER, onDiscardOver);
			discardButton.addEventListener(MouseEvent.ROLL_OUT, onDiscardOut);
		}
		
		public function get friendVO():FriendVO {
			return _friendVO;
		}
		
		public function get discardButton():MovieClip {
			return _friendCard.btnDiscard;
		}
		
		private function onDiscardOver(e:MouseEvent):void {
			tintDisplayObject(discardButton, 0xFFFFFF, .3);
		}
		
		private function onDiscardOut(e:MouseEvent):void {
			tintDisplayObject(discardButton, 0, 0);
		}
	}
}