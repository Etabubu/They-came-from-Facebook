package com.gogogic.gamejam.view.components
{
	import com.gogogic.dragmanager.DragManager;
	import com.gogogic.dragmanager.events.DragEvent;
	import com.gogogic.gamejam.Application;
	import com.gogogic.gamejam.model.vo.FriendVO;
	
	import flash.display.Sprite;
	
	public class GameBoardComponent extends Sprite
	{
		public function GameBoardComponent()
		{
			init();
		}
		
		private function init():void {
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
		}
	}
}