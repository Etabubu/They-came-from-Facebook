package com.gogogic.gamejam.controller
{
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;
	
	public class StartupCommand extends MacroCommand implements ICommand
	{
		override protected function initializeMacroCommand( ) : void {
			addSubCommand(ModelPrepCommand);
			addSubCommand(ViewPrepCommand);
		}
	}
}