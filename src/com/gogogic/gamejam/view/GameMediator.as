package com.gogogic.gamejam.view
{
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class GameMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "GameMediator";
		
		public function GameMediator(gameView:GameView)
		{
			super(NAME, gameView);
		}
		
		public function get gameView():GameView {
			return viewComponent as GameView;
		}
	}
}