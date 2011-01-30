package com.gogogic.gamejam
{
	public final class Settings
	{
		// for drawing a card from the deck
		public static const COOLDOWN_TIME:Number = 5000;
		
		// for playing cards
		public static const MAX_ENERGY:Number = 1200;
		
		// for enemy spawning
		public static const INITIAL_SPAWN_DELAY_MILLIS:Number = 4000;
		
		public static const MAX_FRIENDS_ON_TEAM:int = 50;
		
		// Facebook Id's of the developers
		public static const DEVELOPERS:Vector.<Number> = new <Number>[644779038, 1518282318745, 699804391, 593171339, 588915126, 1034256399]; // ari, joe, jonathan, hilmar, marco, annamarie
		
		// Facebook app id
		public static const FACEBOOK_APP_ID:String = "183984731631877";
		
		// Facebook permissions
		public static const FACEBOOK_PERMS:String = "publish_stream,user_about_me,friends_about_me,user_relationships,user_relationship_details,friends_birthday,user_birthday,email";

		public static const PLAYER_UNIT_STARTING_HEALTH:Number = 200;
	}
}