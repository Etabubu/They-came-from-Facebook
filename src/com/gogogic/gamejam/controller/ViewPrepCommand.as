package com.gogogic.gamejam.controller
{
	import com.gogogic.gamejam.Application;
	import com.gogogic.gamejam.view.ApplicationMediator;
	import com.gogogic.gamejam.view.SoundMediator;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ViewPrepCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void {
			facade.registerMediator(new SoundMediator());
			facade.registerMediator(new ApplicationMediator(notification.getBody() as Application));
		}
	}
}