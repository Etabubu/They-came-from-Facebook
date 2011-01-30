package com.gogogic.gamejam.view
{
	import com.gogogic.dragmanager.DragManager;
	import com.gogogic.gamejam.Application;
	import com.gogogic.gamejam.ApplicationFacade;
	import com.gogogic.gamejam.enum.SoundName;
	
	import flash.display.Sprite;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class ApplicationMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ApplicationMediator";
		
		private var _mainMenuView:MainMenuView;
		private var _endGameView:EndScreenView;
		private var _gameView:GameView;
		
		private var _viewLayer:Sprite;
		private var _blingLayer:Sprite;
		private var _popupLayer:Sprite;
		private var _dragDropLayer:Sprite;
		
		public function ApplicationMediator(application:Application)
		{
			super(NAME, application);
		}
		
		public function get application():Application {
			return viewComponent as Application;
		}
		
		override public function onRegister():void {
			application.addChild(_viewLayer = new Sprite());
			application.addChild(_blingLayer = new Sprite());
			application.addChild(_popupLayer = new Sprite());
			application.addChild(_dragDropLayer = new Sprite());
			
			DragManager.getInstance().initialize(application.stage, _dragDropLayer);
			
			facade.registerMediator(new PopupMediator(_popupLayer));
			facade.registerMediator(new BlingMediator(_blingLayer));
			
			
			mainMenu();
		}
		
		override public function listNotificationInterests():Array {
			return [
				MainMenuMediator.START_MAIN_GAME,
				EndScreenMediator.PLAY_AGAIN,
				GameMediator.GAME_OVER
			];
		}
		
		override public function handleNotification(notification:INotification):void {
			switch (notification.getName()) {
				case MainMenuMediator.START_MAIN_GAME:
					startClicked();
					break;
				case EndScreenMediator.PLAY_AGAIN:
					restart();
					break;
				case GameMediator.GAME_OVER:
					gameOver();
					break;
			}
		}
		
		private function mainMenu():void {
			_viewLayer.addChild(_mainMenuView = new MainMenuView());
			facade.registerMediator(new MainMenuMediator(_mainMenuView));
			sendNotification(SoundMediator.SET_MUSIC, SoundName.MAIN_MENU_MUSIC);
		}
		
		private function restart():void {
			// Remove end screen
			_viewLayer.removeChild(_endGameView);
			facade.removeMediator(EndScreenMediator.NAME);
			sendNotification(ApplicationFacade.RESET_DATA);
			startTheGame();
		}
		
		private function startClicked():void {
			// Remove the main menu
			_viewLayer.removeChild(_mainMenuView);
			facade.removeMediator(MainMenuMediator.NAME);
			startTheGame();
		}
		
		private function startTheGame():void {
			// Add the game
			_viewLayer.addChild(_gameView = new GameView());
			facade.registerMediator(new GameMediator(_gameView));
			// Start the music
			sendNotification(SoundMediator.SET_MUSIC, SoundName.IN_GAME_MUSIC);
		}
		
		private function gameOver():void {
			// Remove the game
			_viewLayer.removeChild(_gameView);
			facade.removeMediator(GameMediator.NAME);
			endScreen();
		}
		
		private function endScreen():void {
			// Add the end screen
			_viewLayer.addChild(_endGameView = new EndScreenView());
			facade.registerMediator(new EndScreenMediator(_endGameView));
		}
	}
}