package com.gogogic.gamejam.controller
{
	import com.gogogic.gamejam.model.PlayerProxy;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ResetDataCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void {
			(facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy).reset();
		}
	}
}