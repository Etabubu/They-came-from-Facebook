package com.gogogic.gamejam.model
{
	import com.gogogic.gamejam.model.vo.PlayerVO;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class PlayerProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "PlayerProxy";
		
		public function PlayerProxy()
		{
			super(NAME, new PlayerVO());
		}
		
		public function get playerVO():PlayerVO {
			return data as PlayerVO;
		}
	}
}