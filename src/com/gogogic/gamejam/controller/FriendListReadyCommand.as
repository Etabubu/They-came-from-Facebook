package com.gogogic.gamejam.controller
{
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class FriendListReadyCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void {
			
		}
	}
}