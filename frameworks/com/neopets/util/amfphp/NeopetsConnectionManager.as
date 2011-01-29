//Marks the right margin of code *******************************************************************
package com.neopets.util.amfphp
{
	import com.neopets.util.servers.NeopetsServerFinder;
	import com.neopets.util.servers.ServerFinder;
	
	import flash.display.DisplayObject;
	import flash.events.AsyncErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	
	
	/**
	 * 
	 * This class is for external vendors to be able to work with Neopets backend. 
	 * It handles the connection to the Neopets servers, establishing connection, managing calls, registering classes, parsing VOs.
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/29/2010</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class NeopetsConnectionManager extends EventDispatcher
	{
		//--------------------------------------------------------------------------
		// Costants
		//--------------------------------------------------------------------------	

		private static const _instance:NeopetsConnectionManager = new NeopetsConnectionManager( SingletonEnforcer ); 
		
		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
		
		private var mConnection:NetConnection;
		private var mGatewayURL : String;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Creates a new public class NeopetsConnectionManager extends EventDispatcher instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function NeopetsConnectionManager(singletonEnforcer : Class = null)
		{
			super(null);
			
			if(singletonEnforcer != SingletonEnforcer){
				throw new Error( "Invalid Singleton access.  Use TranslationManager.instance." ); 
			}

		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * This is called to connect to the  Neopets AMFPHP Server. 
		 * The document class is passed in to allow the ServerFinder utility to find the correct location to call.
		 * 
		 * @param document  DisplayObject  the project document class.
		 */
		public function connect(document:DisplayObject):void {
			//reset all
			onRemove();
			
			//find the server URL
			var sv:NeopetsServerFinder = new NeopetsServerFinder (document);
			gatewayURL = sv.scriptServer+"/amfphp/gateway.php";
			
			//create connection
			mConnection = new NetConnection ();
			mConnection.objectEncoding = ObjectEncoding.AMF3;
			if (gatewayURL) {
				mConnection.connect( gatewayURL );
			} else {
				throw new Error ("Error: the gateway URL is null");
			}
			
			//TODO handle errors (popup? dispatch events?)
			mConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			mConnection.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
			mConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR , aSyncErrorHandler);            
			mConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
				
		/**
		 * Register remote classes. This is used when the classes are explicitly declared in the PHP functions with:
		 * 
		 * <code>// explicit actionscript package
		 * 			var $_explicitType = "com.packagename.ClassName";</code>
		 * 
		 * @param classesArray An array of classes to register.
		 * 
		 */
		public function registerRemoteClasses(classesArray:Array):void
		{
			var i : int;
			var iMax : int = classesArray.length;
			for(i = 0; i < iMax; i ++ ){
				classesArray[i].register();
			}
		}
		
		/**
		 * Call a remote method.
		 * 
		 * @param functionName The name of the function to call(example: GameService.sendScore).
		 * @param responder The responder Object responsible for handling service call success and fault.
		 * @param ...rest optional arguments.
		 * 
		 */
		public function callRemoteMethod(functionName:String, responder:Responder, ... rest):void
		{
			var temp : Array = [functionName, responder].concat(rest);
			mConnection.call.apply(this, temp);
			
		}
		
		/**
		 * Called by the Model when the Proxy is removed
		 */ 
		public function onRemove():void {
			if (mConnection){
				mConnection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				mConnection.removeEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
				mConnection.removeEventListener(AsyncErrorEvent.ASYNC_ERROR , aSyncErrorHandler);            
				mConnection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			
				mConnection.close();
			
				mConnection = null;
			}
		};
		//--------------------------------------------------------------------------
		// Protected Methods
		//--------------------------------------------------------------------------
	
		//--------------------------------------------------------------------------
		// Private Methods
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		// Event Handlers
		//--------------------------------------------------------------------------	
		/**
		 * Handler for the connection status. 
		 * It passes the event to the class that will handle the messaging.
		 * 
		 * @param event The <code>NetStatusEvent</code>. It contains the info object with properties that describe the connection status or error condition.
		 * 
		 */
		public function netStatusHandler (event:NetStatusEvent):void {
			trace (this, "Connection Status:", event.info);
			dispatchEvent(event);
		}
		
		
		/**
		 *  Handlers for connection errors.
		 */
		public function IOErrorHandler( e:IOErrorEvent) : void
		{
			trace (this, "IOErrorHandler: " + e);
		}
		public function aSyncErrorHandler( e:AsyncErrorEvent ) : void
		{
			trace (this, "aSyncErrorHandler: " + e);
		}
		public function securityErrorHandler( e:SecurityErrorEvent) : void
		{
			trace (this, "securityErrorHandler: " + e);
		}
		
		
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------
		/**
		 *  This is used to get the Singleton instance of this class.
		 */
		public static function get instance():NeopetsConnectionManager
		{ 
			return _instance;
		} 
		
		/**
		 * The amfphp gateway url. 
		 */
		public function get gatewayURL():String { return mGatewayURL; }
		public function set gatewayURL(value:String):void{ mGatewayURL = value;}
	}
}

internal class SingletonEnforcer{}