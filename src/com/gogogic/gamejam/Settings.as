package com.gogogic.gamejam
{
	public final class Settings
	{
		// The Developers
		public static const DEVELOPERS:Vector.<Object> = new <Object>[
			{id:644779038, firstName:"Ari", lastName:"Arnbjörnsson"},
			{id:1518282318745, firstName:"Jóhannes", lastName:"Sigurðsson"},
			{id:699804391, firstName:"Jonathan", lastName:"Osborne"},
			{id:593171339, firstName:"Hilmar", lastName:"Jóhannsson"},
			{id:1034256399, firstName:"Marco", lastName:"Bancale"}];
		
		// for drawing a card from the deck
		public static const COOLDOWN_TIME:Number = 3800;
		
		// for playing cards
		public static const MAX_ENERGY:Number = 10000;
		public static const ENERGY_REGEN_PER_FRAME:Number = 8;
		
		// for enemy spawning
		public static const INITIAL_SPAWN_DELAY_MILLIS:Number = 4000;
		
		// Facebook app id
		public static const FACEBOOK_APP_ID:String = "183984731631877";
		
		// Facebook permissions
		public static const FACEBOOK_PERMS:String = "publish_stream,user_about_me,user_relationships,user_relationship_details";
		
		// player properties
		public static const PLAYER_UNIT_STARTING_HEALTH:Number = 200;
		public static const MAX_FRIENDS_ON_TEAM:int = 50;
		
		// Placeholder image
		public static const PLACEHOLDER_IMAGE_URL:String = "http://apps.gogogic.com/tcff/scream.png"; // TODO: change base path to be dynamic where Application.swf, please.
	}
}