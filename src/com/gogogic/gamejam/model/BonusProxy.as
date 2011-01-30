package com.gogogic.gamejam.model
{
	import com.gogogic.gamejam.Settings;
	import com.gogogic.gamejam.enum.Gender;
	import com.gogogic.gamejam.enum.Relationship;
	import com.gogogic.gamejam.model.vo.BonusVO;
	import com.gogogic.gamejam.model.vo.FriendVO;
	
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class BonusProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "BonusProxy";
		
		public function BonusProxy()
		{
			super(NAME);
			
			setupBonuses();
		}
		
		public function setupBonuses():void {
			// preload values for all bonuses
			
			data = {};
			
			bonuses["patricide"] = new BonusVO();
			bonuses["patricide"].name = "Patricide!";
			bonuses["patricide"].subtext = "victim was your father!";
			bonuses["patricide"].points = 100;
			
			bonuses["matricide"] = new BonusVO();
			bonuses["matricide"].name = "Matricide!";
			bonuses["matricide"].subtext = "victim was your mother!";
			bonuses["matricide"].points = 100;
			
			bonuses["sororicide"] = new BonusVO();
			bonuses["sororicide"].name = "Sororicide!";
			bonuses["sororicide"].subtext = "victim was your sister!";
			bonuses["sororicide"].points = 50;
			
			bonuses["fratricide"] = new BonusVO();
			bonuses["fratricide"].name = "Fratricide!";
			bonuses["fratricide"].subtext = "victim was your brother!";
			bonuses["fratricide"].points = 50;
			
			bonuses["filicide"] = new BonusVO();
			bonuses["filicide"].name = "Filicide!";
			bonuses["filicide"].subtext = "victim was your child!";
			bonuses["filicide"].points = 75;
			
			bonuses["marital_problems_male"] = new BonusVO();
			bonuses["marital_problems_male"].name = "Marital Problems!";
			bonuses["marital_problems_male"].subtext = "victim was your husband!";
			bonuses["marital_problems_male"].points = 150;
			
			bonuses["marital_problems_female"] = new BonusVO();
			bonuses["marital_problems_female"].name = "Marital Problems!";
			bonuses["marital_problems_female"].subtext = "victim was your wife!";
			bonuses["marital_problems_female"].points = 150;
			
			bonuses["honeymoon_suite"] = new BonusVO();
			bonuses["honeymoon_suite"].name = "The honeymoon suite!";
			bonuses["honeymoon_suite"].subtext = "victim was your fiance!";
			bonuses["honeymoon_suite"].points = 75;
			
			bonuses["on_the_rocks_male"] = new BonusVO();
			bonuses["on_the_rocks_male"].name = "On the rocks";
			bonuses["on_the_rocks_male"].subtext = "victim was your boyfriend!";
			bonuses["on_the_rocks_male"].points = 75;
			
			bonuses["on_the_rocks_female"] = new BonusVO();
			bonuses["on_the_rocks_female"].name = "On the rocks";
			bonuses["on_the_rocks_female"].subtext = "victim was your girlfriend!";
			bonuses["on_the_rocks_female"].points = 75;
			
			/*bonuses["prom_female"] = new BonusVO();
			bonuses["prom_female"].name = "Prom Queen";
			bonuses["prom_female"].subtext = "more than 500 friends";
			bonuses["prom_female"].points = 25;
			
			bonuses["prom_male"] = new BonusVO();
			bonuses["prom_male"].name = "Prom King";
			bonuses["prom_male"].subtext = "more than 500 friends";
			bonuses["prom_male"].points = 25;
			
			bonuses["doublecross"] = new BonusVO();
			bonuses["doublecross"].name = "Double-cross!";
			bonuses["doublecross"].subtext = "more than 25 mutual friends";
			bonuses["doublecross"].points = 25;*/
			
			bonuses["code_freeze"] = new BonusVO();
			bonuses["code_freeze"].name = "Code Freeze";
			bonuses["code_freeze"].subtext = "victim was a developer";
			bonuses["code_freeze"].points = 182;
			
			bonuses["awesome_name"] = new BonusVO();
			bonuses["awesome_name"].name = "Awesome name, dude!";
			bonuses["awesome_name"].subtext = "victim had the same name as a developer";
			bonuses["awesome_name"].points = 120;
			
			bonuses["good_morning_dave"] = new BonusVO();
			bonuses["good_morning_dave"].name = "Good morning, Dave.";
			bonuses["good_morning_dave"].subtext = "victim was in the distant future of 2001";
			bonuses["good_morning_dave"].points = 20;
			
			bonuses["billy_no"] = new BonusVO();
			bonuses["billy_no"].name = "Billy! Noooo!";
			bonuses["billy_no"].subtext = "because that ain't no man";
			bonuses["billy_no"].points = 20;
			
			bonuses["timmeh"] = new BonusVO();
			bonuses["timmeh"].name = "Timmmeehh!";
			bonuses["timmeh"].subtext = "Jimmeh. Jiimeh!";
			bonuses["timmeh"].points = 20;
			
			bonuses["alan_steve"] = new BonusVO();
			bonuses["alan_steve"].name = "Al! Allan! Alan!";
			bonuses["alan_steve"].subtext = "... Steve?!";
			bonuses["alan_steve"].points = 20;
			
			bonuses["alan_steve"] = new BonusVO();
			bonuses["alan_steve"].name = "Al! Allan! Alan!";
			bonuses["alan_steve"].subtext = "... Steve?!";
			bonuses["alan_steve"].points = 20;
		}
		
		public function assignBonuses(friend:FriendVO):void {
			// patricide - relation is father
			if(friend.relationship == Relationship.FATHER) friend.bonuses.push(bonuses["patricide"]);
			
			// matricide - relation is mother
			if(friend.relationship == Relationship.MOTHER) friend.bonuses.push(bonuses["matricide"]);
			
			// sororicide - relation is sister
			if(friend.relationship == Relationship.SISTER) friend.bonuses.push(bonuses["sororicide"]);
			
			// fratricide - relation is brother
			if(friend.relationship == Relationship.BROTHER) friend.bonuses.push(bonuses["fratricide"]);
			
			// Filicide - relation is son/daughter
			if(friend.relationship == Relationship.CHILD) friend.bonuses.push(bonuses["filicide"]);
			
			// marital problems! - relation is married to player - _male and _female
			if(friend.relationship == Relationship.MARRIED && friend.gender == Gender.MALE) friend.bonuses.push(bonuses["marital_problems_male"]);
			if(friend.relationship == Relationship.MARRIED && friend.gender == Gender.FEMALE) friend.bonuses.push(bonuses["marital_problems_female"]);
			
			// The honeymoon suite! - relation is engaged
			if(friend.relationship == Relationship.ENGAGED) friend.bonuses.push(bonuses["honeymoon_suite"]);
			
			// On the rocks - relation is a spouse (not married or engaged) - _male and _female
			if(friend.relationship == Relationship.IN_A_RELATIONSHIP && friend.gender == Gender.MALE) friend.bonuses.push(bonuses["on_the_rocks_male"]);
			if(friend.relationship == Relationship.IN_A_RELATIONSHIP && friend.gender == Gender.FEMALE) friend.bonuses.push(bonuses["on_the_rocks_female"]);
			
			// prom king/queen - has more than 500 friends - _male and _female
			//if(friend.friendCount > 500 && friend.gender == Gender.MALE) friend.bonuses.push(bonuses["prom_male"]);
			//if(friend.friendCount > 500 && friend.gender == Gender.FEMALE) friend.bonuses.push(bonuses["prom_female"]);
			
			// double-cross - has more than 25 mutual friends
			//if(friend.mutualFriendCount > 25) friend.bonuses.push(bonuses["doublecross"]);
			
			// code-freeze - is a developer of the game
			if(friend.developer) friend.bonuses.push(bonuses["doublecross"]);
			
			// awesome name - shares the name of a developer
			if(! friend.developer) {
				for each(var developer:Object in Settings.DEVELOPERS) {
					if(developer.firstName == friend.firstName || developer.lastName == friend.lastName) friend.bonuses.push(bonuses["awesome_name"]);
				}
			}
			
			//good_morning_dave
			//billy_no
			//timmeh
			//alan_steve
			
		}
		
		public function get bonuses():Object {
			return data;
		}
		
		
	}
}