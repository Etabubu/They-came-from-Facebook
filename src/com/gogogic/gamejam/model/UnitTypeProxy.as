package com.gogogic.gamejam.model
{
	import com.gogogic.gamejam.model.vo.BonusVO;
	import com.gogogic.gamejam.model.vo.FriendVO;
	import com.gogogic.gamejam.model.vo.UnitTypeKamikazeeVO;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class UnitTypeProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "UnitTypeProxy";
		
		public function UnitTypeProxy()
		{
			super(NAME);
			
			setupUnitTypes();
		}
		
		public function setupUnitTypes():void {
			// preload values for all bonuses
			
			data = new Dictionary.<string, UnitTypeBaseVO>();
			
			unitTypes["kamikazee"] = new UnitTypeKamikazeeVO();
		}
		
		private function assignUnitType(FriendVO friend):void {
			// TODO: assign relevant unit type based on facebook info
			
		}
		
		public function get unitTypes():Dictionary.<string, UnitTypeBaseVO>() {
			return data as Dictionary.<string, UnitTypeBaseVO>();
		}
	}
}