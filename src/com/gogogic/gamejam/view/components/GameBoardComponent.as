package com.gogogic.gamejam.view.components
{
	import com.gogogic.dragmanager.DragManager;
	import com.gogogic.dragmanager.events.DragEvent;
	import com.gogogic.gamejam.Application;
	import com.gogogic.gamejam.assets.GameBoardBackground;
	import com.gogogic.gamejam.assets.PlayerUnitHealth;
	import com.gogogic.gamejam.model.vo.FriendVO;
	import com.gogogic.gamejam.model.vo.PlayerVO;
	import com.gogogic.gamejam.view.components.units.PlayerUnitComponent;
	import com.gogogic.gamejam.view.events.DropFriendEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class GameBoardComponent extends Sprite
	{
		private var _unitLayer:Sprite;
		private var _unitComponents:Vector.<UnitComponent>;
		private var _playerVO:PlayerVO;
		private var _playerUnitHealth:PlayerUnitHealthComponent;
		
		public function GameBoardComponent(playerVO:PlayerVO)
		{
			_playerVO = playerVO;
			init();
		}
		
		private function init():void {
			addChild(new GameBoardBackground());
			addChild(_unitLayer = new Sprite());
			addChild(_playerUnitHealth = new PlayerUnitHealthComponent(_playerVO.playerUnit));
			
			_unitComponents = new Vector.<UnitComponent>();
			
			_playerUnitHealth.x = Application.APPLICATION_WIDTH / 2;
			_playerUnitHealth.y = 650;
			
			addEventListener(DragEvent.DRAG_ENTER, onDragEnter);
			addEventListener(DragEvent.DRAG_DROP, onDragDrop);
			
			insertUnit(new PlayerUnitComponent(_playerVO.playerUnit));
			_playerVO.playerUnit
		}
		
		private function onDragEnter(e:DragEvent):void {
			DragManager.getInstance().acceptDragDrop(this);
		}
		
		private function onDragDrop(e:DragEvent):void {
			var friendVO:FriendVO = e.dragSource.dataForFormat("friendCard") as FriendVO;
			dispatchEvent(new DropFriendEvent(DropFriendEvent.DROP_FRIEND, friendVO, new Point(mouseX, mouseY)));
		}
		
		public function insertUnit(unit:UnitComponent):void {
			_unitLayer.addChild(unit);
			_unitComponents.push(unit);
			unit.addEventListener(Event.COMPLETE, onUnitComplete);
		}
		
		public function removeUnit(unit:UnitComponent):void {
			unit.removeEventListener(Event.COMPLETE, onUnitComplete);
			_unitLayer.removeChild(unit);
			_unitComponents.splice(_unitComponents.indexOf(unit), 1);
			unit.dispose();
		}
		
		private function onUnitComplete(e:Event):void {
			removeUnit(e.currentTarget as UnitComponent);
		}
		
		public function dispose():void {
			while (_unitComponents.length > 0) {
				removeUnit(_unitComponents[0]);
			}
		}
	}
}