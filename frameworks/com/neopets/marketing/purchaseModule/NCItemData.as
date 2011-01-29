/* AS3
	Copyright 2009
*/
package com.neopets.marketing.purchaseModule
{
	
	/**
	 *	This class is simply a wrapper for item information used by the "purchase item" window.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  7.06.2010
	 */
	public class NCItemData extends Object 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		public var itemID:int;
		public var name:String;
		public var description:String;
		public var bannerUrl:String;
		public var imageUrls:Array;
		public var defaultMessage:String;
		public var purchaseMessage:String;
		public var price:Number;
		public var buyable:Boolean;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function NCItemData(src:Object=null):void{
			super();
			initFromAMF(src);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to load default values for offline testing.
		
		public function initDefaults():void {
			itemID = 719; // testing item id
			name = "Thingy";
			description = "Twas brilling and the slithy toves..\ndaS\nFASFSA\nIASI\nFUHUGWA\nEIEIO";
			bannerUrl = "http://images.neopets.com/help/question_mark.png";
			imageUrls = new Array();
			imageUrls.push("http://images.neopets.com/items/cardboard_petpet_1.gif");
			imageUrls.push("http://images.neopets.com/items/cardboard_petpet_2.gif");
			imageUrls.push("http://images.neopets.com/items/cardboard_petpet_3.gif");
			defaultMessage = "Gwark!";
			purchaseMessage = "Congradulations! Your purchase is complete.  This map is now available for use in Battlefield Legends.  Your Buying Log has been updated and a Neomail cofirmation has been sent to you.";
			buyable = true;
			price = 100;
		}
		
		// Use this function to initialize our properties from an amf response to a getItemInfo call.
		
		public function initFromAMF(msg:Object):void {
			if(msg == null) return;
			// extract item id
			if("id" in msg) itemID = Number(msg.id);
			else itemID = 0;
			// extract name
			if("name" in msg) name = msg.name;
			else name = "?";
			// extract description
			if("description" in msg) description = msg.description;
			else description = "?";
			// clear image list
			if(imageUrls != null) {
				while(imageUrls.length > 0) imageUrls.pop();
			} else imageUrls = new Array();
			// extract image urls
			if("Image" in msg) {
				if(msg.Image is String) {
					imageUrls.push(msg.Image);
				} else {
					for(var i in msg.Image) imageUrls.push(msg.Image[i]);
				}
			}
			// extract buyable property
			if("buyable" in msg && msg.buyable != null) buyable = msg.buyable;
			else buyable = true;
			// extract item price
			if("price" in msg && msg.price != null) price = msg.price;
			else price = 1;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
