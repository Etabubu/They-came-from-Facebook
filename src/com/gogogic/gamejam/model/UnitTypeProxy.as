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
			// preload values for all unit types
			
			data = {};
			
			unitTypes["kamikazee"] = new UnitTypeKamikazeeVO();
		}
		
		public function assignUnitType(friend:FriendVO):void {
			// TODO: assign relevant unit type based on facebook info
			
			friend.unitType = unitTypes["kamikazee"];
		}
		
		public function get unitTypes():Object {
			return data;
		}
	}
}