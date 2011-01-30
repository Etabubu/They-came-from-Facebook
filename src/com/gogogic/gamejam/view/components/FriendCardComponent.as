package com.gogogic.gamejam.view.components
{
	import br.com.stimuli.loading.BulkLoader;
	
	import com.gogogic.gamejam.Application;
	import com.gogogic.gamejam.assets.FriendCardGraphic;
	import com.gogogic.gamejam.bulkLoad;
	import com.gogogic.gamejam.model.vo.FriendVO;
	import com.gogogic.gamejam.model.vo.PlayerVO;
	import com.gogogic.gamejam.model.vo.event.DataChangeEvent;
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
		private var _playerVO:PlayerVO;
		
		private var _enabled:Boolean = true;
		
		public function FriendCardComponent(friendVO:FriendVO, playerVO:PlayerVO)
		{
			buttonMode = true;
			addChild(_friendCard = new FriendCardGraphic());
			_friendVO = friendVO;
			_playerVO = playerVO;
			_playerVO.addEventListener(DataChangeEvent.DATA_CHANGE, onPlayerVODataChange);
			var portrait:PortraitComponent = new PortraitComponent(_friendVO.portraitUrl);
			_friendCard.mcPortrait.addChild(portrait);
			_friendCard.txtName.text = _friendVO.name;
			_friendCard.txtClass.text = "Random";
			_friendCard.txtPowerLevel.text = _friendVO.energyCost.toString();
			discardButton.buttonMode = true;
			discardButton.addEventListener(MouseEvent.ROLL_OVER, onDiscardOver);
			discardButton.addEventListener(MouseEvent.ROLL_OUT, onDiscardOut);
			update();
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
		
		private function onPlayerVODataChange(e:DataChangeEvent):void {
			update();
		}
		
		public function get canAfford():Boolean {
			return _enabled;
		}
		
		private function update():void {
			var hasEnergy:Boolean = _playerVO.energy >= _friendVO.energyCost;
			if (hasEnergy == _enabled) return;
			_enabled = hasEnergy;
			if (_enabled) {
				alpha = 1;
			} else {
				alpha =.5;
			}
		}
	}
}