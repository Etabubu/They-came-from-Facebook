package com.gogogic.gamejam.view
{
	import com.gogogic.gamejam.model.PlayerProxy;
	
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class EndScreenMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "EndScreenMediator";
		
		public static const PLAY_AGAIN:String = NAME + "PlayAgain";
		
		public function EndScreenMediator(endScreenView:EndScreenView)
		{
			super(NAME, endScreenView);
			endScreenView.addEventListener(MainMenuView.START_CLICKED, onReplayClicked);
		}
		
		override public function onRegister():void {
			endScreenView.playerScore = (facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy).playerVO.score;
		}
		
		public function get endScreenView():EndScreenView {
			return viewComponent as EndScreenView;
		}
		
		private function onReplayClicked(e:Event):void {
			sendNotification(PLAY_AGAIN);
		}
	}
}