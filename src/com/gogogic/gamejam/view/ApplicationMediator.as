package com.gogogic.gamejam.view
{
	import com.gogogic.gamejam.Application;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class ApplicationMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ApplicationMediator";
		
		private var _mainMenuView:MainMenuView;
		private var _gameView:GameView;
		
		public function ApplicationMediator(application:Application)
		{
			super(NAME, application);
		}
		
		public function get application():Application {
			return viewComponent as Application;
		}
		
		override public function onRegister():void {
			application.addChild(_mainMenuView = new MainMenuView());
			facade.registerMediator(new MainMenuMediator(_mainMenuView));
		}
	}
}