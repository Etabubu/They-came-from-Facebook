package com.gogogic.gamejam.model
{
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import com.gogogic.gamejam.model.vo.FriendVO;
	
	public class BonusProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "BonusProxy";
		
		public function BonusProxy()
		{
			super(NAME);
		}
		
		public function setupBonuses():void {
			// TODO: preload values for all bonuses
			
			data = new Dictionary.<string, BonusVO>();
		}
		
		private function onFriendsLoaded():void {
			// TODO: assign relevant bonuses to any friends needing it
		}
		
		public function get bonuses():Dictionary.<string, BonusVO>() {
			return data as Dictionary.<string, BonusVO>();
		}
	}
}