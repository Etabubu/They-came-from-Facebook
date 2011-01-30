package com.gogogic.gamejam.model
{
	import com.facebook.graph.Facebook;
	import com.facebook.graph.data.FacebookSession;
	import com.gogogic.gamejam.enum.Gender;
	import com.gogogic.gamejam.enum.Relationship;
	import com.gogogic.gamejam.model.vo.PlayerVO;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class PlayerProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "PlayerProxy";
		
		public function PlayerProxy()
		{
			super(NAME, new PlayerVO());
		}
		
		public function get playerVO():PlayerVO {
			return data as PlayerVO;
		}
		
		public function loadPlayer():void {
			Facebook.api("/me", facebookPlayerCallback);
		}
		
		public function facebookPlayerCallback(success:Object, fail:Object):void {
			if(success){
				onPlayerLoaded(success);
			} else {
				trace("facebookPlayerCallback failed", success, fail);
				Facebook.api("/me", facebookPlayerCallback);
			}
		}
		
		private function onPlayerLoaded(result:Object):void {
			var session:FacebookSession = Facebook.getSession();
			
			playerVO.id = result.id;
			playerVO.firstName = result.first_name;
			playerVO.lastName = result.last_name;
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
				for each (var familyMember:Object in result.family) {
					if(familyMember.relationship == "son" || familyMember.relationship == "daughter") internalRelationship = Relationship.CHILD;
					if(familyMember.relationship == "father") internalRelationship = Relationship.FATHER;
					if(familyMember.relationship == "mother") internalRelationship = Relationship.MOTHER;
					if(familyMember.relationship == "brother") internalRelationship = Relationship.BROTHER;
					if(familyMember.relationship == "sister") internalRelationship = Relationship.SISTER;
					if(internalRelationship.length > 0) playerVO.family[familyMember.id] = internalRelationship;
				}
			}
		}
	}
}