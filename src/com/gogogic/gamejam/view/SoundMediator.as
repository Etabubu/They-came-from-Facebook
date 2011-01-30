package com.gogogic.gamejam.view
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class SoundMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "SoundMediator";
		
		public static const PLAY_SOUND:String = NAME + "PlaySound";
		public static const SET_MUSIC:String = NAME + "SetMusic";
		
		private var _sounds:Dictionary;
		
		private var _musicChannel:SoundChannel;
		
		public function SoundMediator()
		{
			super(NAME);
		}
		
		override public function listNotificationInterests():Array {
			return [
				PLAY_SOUND,
				SET_MUSIC
			];
		}
		
		override public function handleNotification(notification:INotification):void {
			switch (notification.getName()) {
				case PLAY_SOUND:
					((new (notification.getBody() as Class)()) as Sound).play(0, int.MAX_VALUE);
					trace("Play sound");
					break;
				case SET_MUSIC:
					if (_musicChannel)
						_musicChannel.stop();
					_musicChannel = ((new (notification.getBody() as Class)()) as Sound).play(0, int.MAX_VALUE);
					trace("Play music");
					break;
			}
		}
	}
}