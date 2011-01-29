package com.gogogic.gamejam
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	[Frame(factoryClass="com.gogogic.gamejam.PreloaderFactory")]
	// Movie info
	[SWF(backgroundColor="#FFFFFF", frameRate="24", width="800", height="700", pageTitle="Gogogic Gamejam Entry")]
	public class Application extends Sprite
	{
		public function Application()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			init();
		}
		
		private function init():void {
			
		}
	}
}