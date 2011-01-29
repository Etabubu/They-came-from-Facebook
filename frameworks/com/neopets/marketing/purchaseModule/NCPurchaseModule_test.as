//Marks the right margin of code *******************************************************************
package com.neopets.marketing.purchaseModule
{
	import com.neopets.marketing.purchaseModule.NCItemData;
	import com.neopets.marketing.purchaseModule.NCPurchasePopUp;
	import com.neopets.marketing.purchaseModule.NCTranslationData;
	import com.neopets.util.amfphp.NeopetsConnectionManager;
	import com.neopets.util.loading.LibraryLoader;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.Responder;
	import flash.utils.getDefinitionByName;
	
	import virtualworlds.lang.TranslationManager;
	
	/**
	 * public class NCMallModule extends Sprite
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class NCPurchaseModule_test extends MovieClip
	{
		//--------------------------------------------------------------------------
		// Costants
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		//--------------------------------------------------------------------------
		//Public properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		private var mUserName:NCUserName;
		private var mPurchaseModule:NCPurchasePopUp;
		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class NCMallModule extends Sprite instance.
		 * 
		 * <span class="hide">This is an alternative to the Flash test file module. It uses a loaded library of assets.</span>
		 *
		 * 
		 */
		public function NCPurchaseModule_test()
		{
			init();
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * initialize this test app
		 *  
		 */
		public function init ():void {
			
			// initialize managers
			TranslationManager.instance.translationData = new NCTranslationData();
			
			//connect to Neopets backend
			NeopetsConnectionManager.instance.connect(this);
			
			buildPage ();
			
		}
		//--------------------------------------------------------------------------
		// Private Methods
		//--------------------------------------------------------------------------
		private function buildPage ():void {
			var sclass:Class = LibraryLoader.getLibrarySymbol("NCPop_username");
			if (sclass){
				mUserName = new sclass();
				addChild (mUserName);
			}
			
			//Feed input textfield into the pop up's username property
			mUserName.user_txt.addEventListener(Event.CHANGE,onUserChange);
			
			sclass = LibraryLoader.getLibrarySymbol("NCPop_window");
			if (sclass){
				mPurchaseModule = new sclass();
				addChild (mPurchaseModule);
			}
			
			//positioning
			mPurchaseModule.y = mUserName.y+mUserName.height+5;
			
			//initialize the module
			mPurchaseModule.userName = mUserName.user_txt.text;
			mPurchaseModule.helpURL = "http://www.neopets.com/index.phtml";
			
			//get the item data from php
			getItemData(719);
		}
		
		
		private function getItemData(id:Object):void {
			var responder:Responder = new Responder(onItemResult,onItemFault);
			NeopetsConnectionManager.instance.callRemoteMethod("NeopianBattleLegendService.getItemInfo",responder,id);
		}
		
		private function onItemResult(msg:Object):void {
			trace("onItemResult:"+msg);
			// extract data to know format
			var info:NCItemData = new NCItemData(msg[0]);
			// insert game specific properties here
			info.bannerUrl = "http://images.neopets.com/help/question_mark.png";
			// show the item info
			mPurchaseModule.showItem(info);
		}
		
		private function onItemFault(msg:Object):void {
			trace("onItemFault:"+msg);
		}
		
		private function onUserChange(ev:Event):void {
			mPurchaseModule.userName = mUserName.user_txt.text;
		}
	}
}