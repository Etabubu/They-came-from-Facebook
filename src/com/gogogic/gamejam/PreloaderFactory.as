package com.gogogic.gamejam
{
	import com.gogogic.gamejam.view.LoadingView;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	public class PreloaderFactory extends MovieClip
	{
		private var _loadingView:LoadingView;
		
		public function PreloaderFactory()
		{
			init();
		}
		
		private function init():void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			addEventListener(Event.ENTER_FRAME, onFrame);
			addChild(_loadingView = new LoadingView());
		}
		
		private function onFrame(e:Event):void 
		{
			// The actual loading
			var loadingProgress:Number = Number(root.loaderInfo.bytesLoaded) / root.loaderInfo.bytesTotal;
			_loadingView.loadingProgress = loadingProgress;
			
			if (currentFrame == totalFrames) { // If the game has loaded in real time
				stop();
				startup();
			}
		}
		
		private function startup():void 
		{
			removeChild(_loadingView);
			_loadingView = null;
			
			removeEventListener(Event.ENTER_FRAME, onFrame);
			var mainClass:Class = getDefinitionByName("com.gogogic.gamejam.Application") as Class;
			addChildAt(new mainClass() as DisplayObject, 0);
		}
	}
}