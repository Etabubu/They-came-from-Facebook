package com.gogogic.gamejam.view
{
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class MainMenuMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MainMenuMediator";
		
		public function MainMenuMediator(mainMenuView:MainMenuView)
		{
			super(NAME, mainMenuView);
		}
		
		public function get mainMenuView():MainMenuView {
			return viewComponent as MainMenuView;
		}
	}
}