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
	 *	This class show a given item's name, description, an associated images.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  7.07.2010
	 */
	public class NCItemDisplay extends MovieClip 
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
		public var descriptionField:TextField;
		public var priceField:TextField;
		protected var _imageArea:DisplayObject;
		protected var _imageLoop:NCImageLoop;
		protected var _bannerLoader:Loader;
		public var servers:ServerFinder;
		
		/**
		 *	@Constructor
		 */
		public function NCItemDisplay():void{
			super();
			// initialize components
			nameField = getChildByName("name_txt") as TextField;
			descriptionField = getChildByName("desc_txt") as TextField;
			priceField = getChildByName("price_txt") as TextField;
			imageArea = getChildByName("image_area_mc");
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get imageArea():DisplayObject { return _imageArea; }
		
		public function set imageArea(dobj:DisplayObject) {
			// store new component
			_imageArea = dobj;
			// set up image loop
			initImageLoop();
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to display the given item's properties and images.
		
		public function loadItem(info:NCItemData):void {
			if(info == null) return;
			// load item name
			if(nameField != null) nameField.htmlText = info.name;
			// load item description
			if(descriptionField != null) {
				descriptionField.htmlText = info.description;
				descriptionField.height = descriptionField.textHeight + 4;
			}
			// initialize server finder
			if(servers == null) servers = new NeopetsServerFinder(this);
			// start loading icons
			if(_imageLoop != null) _imageLoop.loadImages(info.imageUrls);
			// place banner over icons
			var url:String = servers.getImageURL(info.bannerUrl,"items","gif");
			loadBanner(url);
			// get translation manager
			var translator:TranslationManager = TranslationManager.instance;
			// load item price
			if(priceField != null) {
				var base_text:String = translator.getTranslationOf("IDS_NC_PRICE");
				priceField.htmlText = base_text.replace("%1",info.price);
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		// This functio tries adding the image loop area if it hasn't already been created.
		
		protected function initImageLoop():void {
			// create the handler if it doesn't exist.
			if(_imageLoop == null) {
				_imageLoop = new NCImageLoop();
				_imageLoop.servers = servers;
				addChild(_imageLoop);
			}
			// initialize handler properties
			if(_imageLoop != null) {
				if(_imageArea != null) {
					_imageLoop.x = _imageArea.x;
					_imageLoop.y = _imageArea.y;
					var index:int = getChildIndex(_imageArea) + 1;
					setChildIndex(_imageLoop,index);
					_imageLoop.mask = _imageArea;
				}
			}
		}
		
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
			if(_imageArea != null) {
				_bannerLoader.x = _imageArea.x;
				_bannerLoader.y = _imageArea.y;
				var index:int = getChildIndex(_imageArea) + 2;
				addChildAt(_bannerLoader,index);
			} else addChild(_bannerLoader);
			// load image into banner area
			var req:URLRequest = new URLRequest(url);
			_bannerLoader.load(req);
		}
		
	}
	
}
