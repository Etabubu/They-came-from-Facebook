package com.gogogic.gamejam.model
{
	import com.facebook.graph.Facebook;
	import com.facebook.graph.data.FacebookSession;
	import com.gogogic.gamejam.enum.Gender;
	import com.gogogic.gamejam.enum.Relationship;
	import com.gogogic.gamejam.Settings;
	import com.gogogic.gamejam.model.vo.PlayerVO;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class PlayerProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "PlayerProxy";
		
		private var _frameDispatcher:EventDispatcher;
		
		public function PlayerProxy()
		{
			super(NAME, new PlayerVO());
			playerVO.energy = playerVO.reserveEnergy = Settings.MAX_ENERGY;
		}
		
		public function get playerVO():PlayerVO {
			return data as PlayerVO;
		}
		
		public function loadPlayer():void {
			Facebook.api("/me", facebookPlayerCallback, {fields:"id,first_name,last_name,name,picture,gender,family,significant_other,relationship_status"});
		}
		
		public function facebookPlayerCallback(success:Object, fail:Object):void {
			if(success){
				onPlayerLoaded(success);
			} else {
				trace("facebookPlayerCallback failed", success, fail);
				loadPlayer(); // try again
			}
		}
		
		private function onPlayerLoaded(result:Object):void {
			var session:FacebookSession = Facebook.getSession();
			
			playerVO.id = result.id;
			playerVO.firstName = result.first_name;
			playerVO.lastName = result.last_name;
			playerVO.name = result.name;
			playerVO.portraitUrl = result.picture;
			playerVO.gender = (result.hasOwnProperty("gender") && result.gender == Gender.MALE ? Gender.MALE : Gender.FEMALE);
			
			var internalRelationship:String;
			if(result.hasOwnProperty("significant_other")){
				if(result.hasOwnProperty("relationship_status") &&
					(result.relationship_status == "In a relationship" || result.relationship_status == "In an open relationship" || result.relationship_status == "It's complicated")) {
					internalRelationship = Relationship.IN_A_RELATIONSHIP;
				} else if(result.hasOwnProperty("relationship_status") &&
					(result.relationship_status == "Engaged")) {
					internalRelationship = Relationship.ENGAGED;
				} else if(result.hasOwnProperty("relationship_status") &&
					(result.relationship_status == "Married")) {
					internalRelationship = Relationship.MARRIED;
				}
				if(internalRelationship.length > 0) playerVO.family[result.significant_other.id] = internalRelationship;
			}
			
			if(result.hasOwnProperty("family")) {
				internalRelationship = "";
				for each (var familyMember:Object in result.family.data) {
					if(familyMember.relationship == "son" || familyMember.relationship == "daughter") internalRelationship = Relationship.CHILD;
					if(familyMember.relationship == "father") internalRelationship = Relationship.FATHER;
					if(familyMember.relationship == "mother") internalRelationship = Relationship.MOTHER;
					if(familyMember.relationship == "brother") internalRelationship = Relationship.BROTHER;
					if(familyMember.relationship == "sister") internalRelationship = Relationship.SISTER;
					if(internalRelationship.length > 0) playerVO.family[familyMember.id] = internalRelationship;
				}
			}
			
			(facade.retrieveProxy(FriendsProxy.NAME) as FriendsProxy).loadFriends();
		}
			
		public function startEnergyRegen():void {
			if (_frameDispatcher) return;
			_frameDispatcher = new Sprite();
			_frameDispatcher.addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		public function stopEnergyRegen():void {
			_frameDispatcher.removeEventListener(Event.ENTER_FRAME, onFrame);
			_frameDispatcher = null;
		}
		
		private function onFrame(e:Event):void {
			if (playerVO.energy == Settings.MAX_ENERGY && playerVO.reserveEnergy == Settings.MAX_ENERGY) return;
			
			if (playerVO.reserveEnergy == Settings.MAX_ENERGY && playerVO.energy < Settings.MAX_ENERGY) {
				// Switch
				playerVO.reserveEnergy = playerVO.energy;
				playerVO.energy = Settings.MAX_ENERGY;
				playerVO.dispatchEvent(new Event(PlayerVO.ENERGY_BARS_SWITCHED));
			} else {
				playerVO.reserveEnergy += Settings.ENERGY_REGEN_PER_FRAME;
				if (playerVO.reserveEnergy >= Settings.MAX_ENERGY) {
					playerVO.reserveEnergy = Settings.MAX_ENERGY;
				}
				// Switch on next onFrame
			}
			playerVO.triggerDataChangeEvent();
		}
		
		
		public function reset():void {
			playerVO.energy = playerVO.reserveEnergy = Settings.MAX_ENERGY;
			playerVO.score = 0;
			playerVO.playerUnit = null;
		}
	}
}
