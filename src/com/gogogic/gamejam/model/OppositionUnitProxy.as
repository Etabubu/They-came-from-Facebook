package com.gogogic.gamejam.model
{
	import com.gogogic.gamejam.model.vo.FriendVO;
	import com.gogogic.gamejam.model.vo.OppositionVO;
	import com.gogogic.gamejam.model.vo.UnitVO;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class OppositionUnitProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "OppositionProxy";
		
		private static var _gameBoardUnits:Vector.<UnitVO>;
		
		private var _oppositionDeck:FriendDeck;
		
		public function OppositionUnitProxy()
		{
			super(NAME, new OppositionVO());
		}
		
		public function get oppositionVO():OppositionVO {
			return data as OppositionVO;
		}
		
		public function set oppositionFriends(value:Vector.<FriendVO>):void {
			_oppositionDeck = new FriendDeck(value);
		}
		
		public function get oppositionDeck():FriendDeck {
			return _oppositionDeck;
		}
		
		
		// TODO: spawning code for opposition units
		public function handleSpawning():void {
			
		}
		
		public function set gameBoardUnits(value:Vector.<UnitVO>):void {
			_gameBoardUnits = value;
		}
	}
}