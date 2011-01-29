/* AS3
	Copyright 2009
*/
package com.neopets.marketing.purchaseModule
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import com.neopets.util.events.EventFunctions;
	import com.neopets.util.servers.NeopetsServerFinder;
	import com.neopets.util.servers.ServerFinder;
	
	import virtualworlds.lang.TranslationManager;
	
	import com.neopets.marketing.purchaseModule.NCItemData;
	import com.neopets.marketing.purchaseModule.NCImageLoop;
	
	/**
	 *	This class is used by the purchase congradulations pop up to show item details.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  7.15.2010
	 */
	public class NCPurchaseDisplay extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		// components
		public var nameField:TextField;
		public var _priceLabel:TextField;
		public var priceField:TextField;
		public var _balanceLabel:TextField;
		public var balanceField:TextField;
		public var imageArea:DisplayObject;
		protected var _imageLoader:Loader;
		protected var _bannerLoader:Loader;
		// properties
		public var servers:ServerFinder;
		
		/**
		 *	@Constructor
		 */
		public function NCPurchaseDisplay():void{
			super();
			// initialize components
			nameField = getChildByName("name_txt") as TextField;
			priceLabel = getChildByName("price_label_txt") as TextField;
			priceField = getChildByName("price_txt") as TextField;
			balanceLabel = getChildByName("balance_label_txt") as TextField;
			balanceField = getChildByName("balance_txt") as TextField;
			imageArea = getChildByName("image_area_mc");
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get balanceLabel():TextField { return _balanceLabel; }
		
		public function set balanceLabel(txt:TextField) {
			_balanceLabel = txt;
			if(_balanceLabel != null) {
				var translator:TranslationManager = TranslationManager.instance;
				_balanceLabel.htmlText = translator.getTranslationOf("IDS_YOUR_NC_BALANCE");
			}
		}
		
		public function get priceLabel():TextField { return _priceLabel; }
		
		public function set priceLabel(txt:TextField) {
			_priceLabel = txt;
			if(_priceLabel != null) {
				var translator:TranslationManager = TranslationManager.instance;
				_priceLabel.htmlText = translator.getTranslationOf("IDS_PRICE");
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to display the given item's properties and images.
		
		public function loadItem(info:NCItemData):void {
			if(info == null) return;
			// load item name
			if(nameField != null) nameField.htmlText = info.name;
			// initialize server finder
			if(servers == null) servers = new NeopetsServerFinder(this);
			// start loading main item image
			var images:Array = info.imageUrls;
			var url:String;
			if(images != null && images.length > 0) {
				url = servers.getImageURL(images[0],"items","gif");
				loadImage(url);
			}
			// place banner over icons
			url = servers.getImageURL(info.bannerUrl,"items","gif");
			loadBanner(url);
			// get translation manager
			var translator:TranslationManager = TranslationManager.instance;
			// load item price
			if(priceField != null) {
				var base_text:String = translator.getTranslationOf("IDS_NC_PRICE");
				priceField.htmlText = base_text.replace("%1",info.price);
			}
		}
		
		// Use this function to set the new balance text.
		
		public function setBalance(val:Number) {
			if(balanceField != null) {
				var translator:TranslationManager = TranslationManager.instance;
				var base_text:String = translator.getTranslationOf("IDS_NC_PRICE");
				balanceField.htmlText = base_text.replace("%1",val);
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		// This function sets up our banner image.
		
		protected function loadBanner(url:String):void {
			// clear previous banner
			if(_bannerLoader != null) {
				removeChild(_bannerLoader);
				_bannerLoader = null;
			}
			if(url == null || url.length < 1) return; // stop here if the url is invalid
			// create new banner
			_bannerLoader = new Loader();
			if(imageArea != null) {
				_bannerLoader.x = imageArea.x;
				_bannerLoader.y = imageArea.y;
				var index:int = getChildIndex(imageArea) + 2;
				addChildAt(_bannerLoader,index);
			} else addChild(_bannerLoader);
			// load image into banner area
			var req:URLRequest = new URLRequest(url);
			_bannerLoader.load(req);
		}
		
		// This function sets up our main item image.
		
		protected function loadImage(url:String):void {
			// clear previous banner
			if(_imageLoader != null) {
				removeChild(_imageLoader);
				_imageLoader = null;
			}
			if(url == null || url.length < 1) return; // stop here if the url is invalid
			// create new banner
			_imageLoader = new Loader();
			if(imageArea != null) {
				_imageLoader.x = imageArea.x;
				_imageLoader.y = imageArea.y;
				var index:int = getChildIndex(imageArea) + 1;
				addChildAt(_imageLoader,index);
			} else addChild(_imageLoader);
			// load image into banner area
			var req:URLRequest = new URLRequest(url);
			_imageLoader.load(req);
		}
		
	}
	
}
