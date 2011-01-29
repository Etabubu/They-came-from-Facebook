package com.gogogic.gamejam.model
{
	import com.gogogic.gamejam.model.vo.OppositionVO;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class OppositionProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "OppositionProxy";
		
		public function OppositionProxy()
		{
			super(NAME, new OppositionVO());
		}
		
		public function get oppositionVO():OppositionVO {
			return data as OppositionVO;
		}
		
		// TODO: spawning code for opposition units
		public function handleSpawning():void {
			
		}
	}
}