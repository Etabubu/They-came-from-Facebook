package com.gogogic.gamejam
{
	import com.gogogic.gamejam.controller.StartupCommand;
	
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class ApplicationFacade extends Facade implements IFacade
	{
		public static const NAME:String = "ApplicationFacade";
		
		public static const STARTUP:String = NAME + "Startup";
		
		public function ApplicationFacade(key:String)
		{
			super(key);
		}
		
		public static function getInstance( key:String ) : ApplicationFacade 
		{
			if ( instanceMap[ key ] == null ) instanceMap[ key ]  = new ApplicationFacade( key );
			return instanceMap[ key ] as ApplicationFacade;
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			
			registerCommand(ApplicationFacade.STARTUP, StartupCommand);
		}
	}
}