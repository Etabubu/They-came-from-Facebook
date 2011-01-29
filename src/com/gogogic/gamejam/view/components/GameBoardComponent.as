package com.gogogic.gamejam.view.components
{
	import com.gogogic.dragmanager.DragManager;
	import com.gogogic.dragmanager.events.DragEvent;
	import com.gogogic.gamejam.Application;
	import com.gogogic.gamejam.model.vo.FriendVO;
	import com.gogogic.gamejam.view.events.DropFriendEvent;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class GameBoardComponent extends Sprite
	{
		private var _unitLayer:Sprite;
		
		public function GameBoardComponent()
		{
			init();
		}
		
		private function init():void {
			addChild(_unitLayer = new Sprite());
			
			addEventListener(DragEvent.DRAG_ENTER, onDragEnter);
			addEventListener(DragEvent.DRAG_DROP, onDragDrop);
			
			graphics.beginFill(0x125412);
			graphics.drawRect(0, 0, Application.APPLICATION_WIDTH, 600);
			graphics.endFill();
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
		}
		
		public function removeUnit(unit:UnitComponent):void {
			_unitLayer.removeChild(unit);
		}
	}
}