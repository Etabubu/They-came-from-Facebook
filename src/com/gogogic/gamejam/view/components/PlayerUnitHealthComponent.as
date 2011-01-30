package com.gogogic.gamejam.view.components
{
	import com.gogogic.gamejam.assets.PlayerUnitHealth;
	import com.gogogic.gamejam.model.vo.PlayerUnitVO;
	import com.gogogic.gamejam.model.vo.UnitVO;
	import com.gogogic.gamejam.model.vo.event.DataChangeEvent;
	
	import flash.display.Sprite;
	
	public class PlayerUnitHealthComponent extends Sprite
	{
		private var _playerUnitHealthBar:PlayerUnitHealth;
		private var _playerUnitVO:UnitVO;
		private var _maskMask:Sprite;
		
		public function PlayerUnitHealthComponent(playerUnitVO:PlayerUnitVO)
		{
			addChild(_playerUnitHealthBar = new PlayerUnitHealth());
			_playerUnitVO = playerUnitVO;
			_playerUnitVO.addEventListener(DataChangeEvent.DATA_CHANGE, onPlayerUnitVODataChange);
			update();
		}
		
		private function onPlayerUnitVODataChange(e:DataChangeEvent):void {
			update();
		}
		
		private function update():void {
			_playerUnitHealthBar.mcHealthMask.scaleX = _playerUnitVO.currentHealth / _playerUnitVO.maxHealth;
		}
	}
}