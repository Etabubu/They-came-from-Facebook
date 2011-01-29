package com.gogogic.gamejam.view
{
	import com.gogogic.gamejam.Application;
	
	import flash.display.Sprite;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class ApplicationMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ApplicationMediator";
		
		private var _mainMenuView:MainMenuView;
		private var _gameView:GameView;
		
		private var _viewLayer:Sprite;
		private var _popupLayer:Sprite;
		
		public function ApplicationMediator(application:Application)
		{
			super(NAME, application);
		}
		
		public function get application():Application {
			return viewComponent as Application;
		}
		
		override public function onRegister():void {
			application.addChild(_viewLayer = new Sprite());
			application.addChild(_popupLayer = new Sprite());
			
			facade.registerMediator(new PopupMediator(_popupLayer));
			
			_viewLayer.addChild(_mainMenuView = new MainMenuView());
			facade.registerMediator(new MainMenuMediator(_mainMenuView));
		}
		
		override public function listNotificationInterests():Array {
			return [
				MainMenuMediator.START_MAIN_GAME,
			];
		}
		
		override public function handleNotification(notification:INotification):void {
			switch (notification.getName()) {
				case MainMenuMediator.START_MAIN_GAME:
					startTheGame();
					break;
			}
		}
		
		private function startTheGame():void {
			_viewLayer.removeChild(_mainMenuView);
			
			_viewLayer.addChild(_gameView = new GameView());
			facade.registerMediator(new GameMediator(_gameView));
		}
	}
}