/* AS3
	Copyright 2009
*/
package com.neopets.marketing.purchaseModule
{
	import com.neopets.marketing.purchaseModule.NCBuyBar;
	import com.neopets.marketing.purchaseModule.NCItemData;
	import com.neopets.marketing.purchaseModule.NCTitleBar;
	import com.neopets.util.amfphp.NeopetsConnectionManager;
	import com.neopets.util.display.ListPane;
	import com.neopets.util.events.EventFunctions;
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.servers.NeopetsServerFinder;
	import com.neopets.util.servers.ServerFinder;
	import com.virtualworlds.lang.ITranslationManager;
	import com.virtualworlds.lang.TranslationManager;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.Responder;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	/**
	 *	This class is simply a wrapper for item information used by the "purchase item" window.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  7.07.2010
	 */
	public class NCPurchasePopUp extends MovieClip 
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		// components
		protected var _titleBar:NCTitleBar;
		protected var _buyBar:NCBuyBar;
		public var contentPane:ListPane;
		protected var _cashButton:MovieClip;
		protected var messageClip:MovieClip;
		// properties
		public var spacing:Number;
		public var userName:String;
		public var helpURL:String;
		public var serviceName:String;
		public var cashURL:String;
		public var servers:ServerFinder;
		// stored data
		protected var _itemData:NCItemData;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function NCPurchasePopUp():void{
			super();
			// hide the pop up by default
			visible = false;
			// initialize components
			titleBar = getChildByName("title_mc") as NCTitleBar;
			contentPane = getChildByName("content_mc") as ListPane;
			// initialize defaults
			spacing = 4;
			serviceName = "NeopianBattleLegendService";
			helpURL = "http://ncmall.neopets.com/mall/shop.phtml";
			cashURL = "http://ncmall.neopets.com/mall/shop.phtml?page=nc&cat=";
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get buyBar():NCBuyBar { return _buyBar; }
		
		public function set buyBar(dobj:NCBuyBar):void {
			// set up listeners
			EventFunctions.transferListener(_buyBar,dobj,NCBuyBar.PURCHASE_REQUEST,onPurchaseRequest);
			// store new component
			_buyBar = dobj;
		}
		
		public function get cashButton():MovieClip { return _cashButton; }
		
		public function set cashButton(dobj:MovieClip):void {
			// set up listeners
			EventFunctions.transferListener(_buyBar,dobj,MouseEvent.CLICK,onCashRequest);
			// store new component
			_cashButton = dobj;
			// set label
			if(_cashButton != null) {
				var translator:ITranslationManager = TranslationManager.instance;
				_cashButton.setText(translator.getTranslationOf("IDS_GET_NEOCASH"));
			}
		}
		
		public function get titleBar():NCTitleBar { return _titleBar; }
		
		public function set titleBar(dobj:NCTitleBar):void {
			// set up listeners
			EventFunctions.transferListener(_titleBar,dobj,NCTitleBar.CLOSE_REQUEST,onCloseRequest);
			// store new component
			_titleBar = dobj;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Open / Close Functions
		
		public function close():void {
			visible = false;
		}
		
		// Display Functions
		
		// This function displays an error message with appropriate font color changes.
		
		public function showErrorMessage(msg:String):void {
			if(messageClip != null) {
				messageClip.text = "<font color='#FF0000'>"+msg+"</font>";
			}
		}
		
		// Use this function to show into on a selected item.
		
		public function showItem(info:NCItemData):void {
			if(info == null) return;
			// store new info
			_itemData = info;
			// get translation manager
			var translator:ITranslationManager = TranslationManager.instance;
			// load pop up title
			if(_titleBar != null) _titleBar.title = translator.getTranslationOf("IDS_PURCHASE_ITEM");
			// initialize server finder
			if(servers == null) servers = new NeopetsServerFinder(this);
			// load new pop up contents
			if(contentPane != null) {
				contentPane.clearItems();
				// add item display
				var clip:MovieClip = GeneralFunctions.getInstanceOf("NCPop_item_display") as MovieClip;
				if(clip != null) {
					clip.loadItem(info);
					clip.servers = servers;
					contentPane.addItem(clip,spacing,spacing);
				}
				// load message area
				messageClip = GeneralFunctions.getInstanceOf("NCPop_text") as MovieClip;
				if(messageClip != null) {
					// load default message
					if(info.defaultMessage != null) messageClip.text = info.defaultMessage;
					else messageClip.text = "";
					// add message area to content pane
					contentPane.addItem(messageClip,spacing,spacing);
				}
				// load purchase are if applicable
				if(info.buyable) {
					buyBar = GeneralFunctions.getInstanceOf("NCPop_buy_bar") as NCBuyBar;
					if(_buyBar != null) contentPane.addItem(_buyBar,spacing,spacing);
				}
			}
			// show pop up
			visible = true;
		}
		
		// Use this function to load text into our message textfield.
		
		public function showMessage(msg:String):void {
			if(messageClip != null) {
				messageClip.text = msg;
				contentPane.forceUpdate();
			}
		}
		
		// Use this function to display a successful purchase.
		
		public function showPurchase(info:Object):void {
			// get translation manager
			var translator:ITranslationManager = TranslationManager.instance;
			// initialize server finder
			if(servers == null) servers = new NeopetsServerFinder(this);
			// load pop up title
			if(_titleBar != null) _titleBar.title = translator.getTranslationOf("IDS_CONGRADULATIONS");
			// load new pop up contents
			if(contentPane != null) {
				contentPane.clearItems();
				// add item display
				var clip:MovieClip = GeneralFunctions.getInstanceOf("NCPop_purchase_display") as MovieClip;
				if(clip != null) {
					clip.servers = servers;
					clip.loadItem(_itemData);
					// extract remaining balance
					if(info != null && "balance" in info) clip.setBalance(info.balance);
					else clip.setBalance(0);
					// add display to content area
					contentPane.addItem(clip,spacing,spacing);
				}
				// load message area
				messageClip = GeneralFunctions.getInstanceOf("NCPop_text") as MovieClip;
				if(messageClip != null) {
					// check for item message
					var item_msg:String;
					if(_itemData != null) item_msg = _itemData.purchaseMessage;
					// if message is not set, get default from translation
					if(item_msg == null || item_msg.length < 1) {
						item_msg = translator.getTranslationOf("IDS_NC_PURCHASE_MESSAGE");
					}
					// load message into clip
					messageClip.text = item_msg;
					// add message area to content pane
					contentPane.addItem(messageClip,spacing,spacing);
				}
				// add help link section
				if(helpURL != null) {
					var link_msg:String = translator.getTranslationOf("IDS_NC_HELP_LINK");
					link_msg = link_msg.replace("%1",helpURL);
					clip = GeneralFunctions.getInstanceOf("NCPop_text") as MovieClip;
					if(clip != null) {
						clip.text = link_msg;
						// add message area to content pane
						contentPane.addItem(clip,spacing,spacing);
					}
				}
			}
			// show pop up
			visible = true;
		}
		
		// This function swaps out the "get neocash" button for the "buy" bar.
		
		public function swapInBuyBar():void {
			// remove neocash button
			if(_cashButton != null) {
				contentPane.removeItem(_cashButton);
				cashButton = null;
			}
			// add buy bar to content pane
			if(_buyBar == null) {
				buyBar = GeneralFunctions.getInstanceOf("NCPop_buy_bar") as NCBuyBar;
				if(_buyBar != null) contentPane.addItem(_buyBar,spacing,spacing);
			}
		}
		
		// This function swaps out the "buy" bar for the "get neocash" button.
		
		public function swapInCashButton():void {
			// remove buy bar
			if(_buyBar != null) {
				contentPane.removeItem(_buyBar);
				buyBar = null;
			}
			// add neocash button to content pane
			if(_cashButton == null) {
				cashButton = GeneralFunctions.getInstanceOf("NCPop_get_nc_button") as MovieClip;
				if(_cashButton != null) contentPane.addItem(_cashButton,spacing,spacing);
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		// Hide the pop up when a close request comes in.
		
		protected function onCloseRequest(ev:Event):void { close(); }
		
		// When a purchase request is made, send the request on to php.
		
		protected function onPurchaseRequest(ev:Event):void {
			// temporarily lock out the buy bar
			if(_buyBar != null) _buyBar.lockOut = true;
			// let the user know the request was sent out
			var translator:ITranslationManager = TranslationManager.instance;
			showMessage(translator.getTranslationOf("IDS_PROCESSING_PURCHASE"));
			// set up amf call
			var responder:Responder = new Responder(onBuyResult,onBuyFault);
			var connection:NeopetsConnectionManager = NeopetsConnectionManager.instance;
			var id:int = _itemData.itemID;
			var pass:String;
			if(_buyBar != null) pass = _buyBar.password;
			else pass = "";
			connection.callRemoteMethod(serviceName + ".buyItem",responder,id,pass,userName);
		}
		
		protected function onBuyResult(msg:Object):void {
			trace("onBuyResult");
			// check if the purchase was a success
			if(msg.status) showPurchase(msg);
			else {
				// if not show the error message
				if("message" in msg) showErrorMessage(msg.message);
				// if the user's balance is too low, swap in the "buy neocash" button
				if("code" in msg && msg.code == 402) swapInCashButton();
			}
			// re-enable the buy bar
			if(_buyBar != null) _buyBar.lockOut = false;
		}
		
		protected function onBuyFault(msg:Object):void {
			trace("onBuyFault");
			// re-enable the buy bar
			if(_buyBar != null) _buyBar.lockOut = false;
		}
		
		// When the "get neocash" button is clicked, pull up the appropriate URL.
		
		protected function onCashRequest(ev:Event):void {
			// call up buy nc url
			var req:URLRequest = new URLRequest(cashURL);
			navigateToURL(req);
			// switch back to the buy bar
			swapInBuyBar();
		}
		
	}
	
}
