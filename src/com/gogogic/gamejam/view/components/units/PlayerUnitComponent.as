package com.gogogic.gamejam.view.components.units
{
	import com.gogogic.gamejam.Application;
	import com.gogogic.gamejam.Settings;
	import com.gogogic.gamejam.assets.BasicCharacter;
	import com.gogogic.gamejam.assets.PlayerCharacter;
	import com.gogogic.gamejam.model.vo.UnitVO;
	import com.gogogic.gamejam.view.components.UnitComponent;
	
	public class PlayerUnitComponent extends UnitComponent
	{
		public function PlayerUnitComponent()
		{
			var playerUnitVO:UnitVO = new UnitVO();
			playerUnitVO.maxHealth = playerUnitVO.currentHealth = Settings.PLAYER_UNIT_STARTING_HEALTH;
			
			addChild(new PlayerCharacter());
			
			playerUnitVO.x = Application.APPLICATION_WIDTH / 2;
			playerUnitVO.y = 500;
			
			super(playerUnitVO);
			update();
		}
	}
}