package com.gogogic.gamejam.model
{
	import com.gogogic.gamejam.model.vo.BonusVO;
	import com.gogogic.gamejam.model.vo.FriendVO;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class BonusProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "BonusProxy";
		
		public function BonusProxy()
		{
			super(NAME);
		}
		
		public function setupBonuses():void {
			// preload values for all bonuses
			
			data = new Dictionary.<string, BonusVO>();
			
			bonuses["patricide"] = new BonusVO();
			bonuses["patricide"].name = "Patricide!";
			bonuses["patricide"].subtext = "killed your father";
			bonuses["patricide"].points = 100;
			
			bonuses["matricide"] = new BonusVO();
			bonuses["matricide"].name = "Matricide!";
			bonuses["matricide"].subtext = "killed your mother";
			bonuses["matricide"].points = 100;
			
			bonuses["sororicide"] = new BonusVO();
			bonuses["sororicide"].name = "Sororicide!";
			bonuses["sororicide"].subtext = "killed your sister";
			bonuses["sororicide"].points = 50;
			
			bonuses["fratricide"] = new BonusVO();
			bonuses["fratricide"].name = "Fratricide!";
			bonuses["fratricide"].subtext = "killed your brother";
			bonuses["fratricide"].points = 50;
			
			bonuses["filicide"] = new BonusVO();
			bonuses["filicide"].name = "Filicide!";
			bonuses["filicide"].subtext = "child killer";
			bonuses["filicide"].points = 75;
			
			bonuses["marital_problems_male"] = new BonusVO();
			bonuses["marital_problems_male"].name = "Marital Problems!";
			bonuses["marital_problems_male"].subtext = "killed your husband";
			bonuses["marital_problems_male"].points = 150;
			
			bonuses["marital_problems_female"] = new BonusVO();
			bonuses["marital_problems_female"].name = "Marital Problems!";
			bonuses["marital_problems_female"].subtext = "killed your wife";
			bonuses["marital_problems_female"].points = 150;
			
			bonuses["honeymoon_suite"] = new BonusVO();
			bonuses["honeymoon_suite"].name = "The honeymoon suite!";
			bonuses["honeymoon_suite"].subtext = "killed your fiance";
			bonuses["honeymoon_suite"].points = 75;
			
			bonuses["on_the_rocks_male"] = new BonusVO();
			bonuses["on_the_rocks_male"].name = "On the rocks";
			bonuses["on_the_rocks_male"].subtext = "killed your boyfriend";
			bonuses["on_the_rocks_male"].points = 75;
			
			bonuses["on_the_rocks_female"] = new BonusVO();
			bonuses["on_the_rocks_female"].name = "On the rocks";
			bonuses["on_the_rocks_female"].subtext = "killed your girlfriend";
			bonuses["on_the_rocks_female"].points = 75;
			
			bonuses["prom_female"] = new BonusVO();
			bonuses["prom_female"].name = "Prom Queen";
			bonuses["prom_female"].subtext = "more than 500 friends";
			bonuses["prom_female"].points = 25;
			
			bonuses["prom_male"] = new BonusVO();
			bonuses["prom_male"].name = "Prom King";
			bonuses["prom_male"].subtext = "more than 500 friends";
			bonuses["prom_male"].points = 25;
		}
		
		private function assignBonuses(FriendVO friend):void {
			// TODO: assign relevant bonuses to any friends needing it
			
			// patricide - relation is father
			
			// matricide - relation is mother
			
			// sororicide - relation is sister
			
			// fratricide - relation is brother
			
			// Filicide - relation is son/daughter
			
			// marital problems! - relation is married to player - _male and _female
			
			// The honeymoon suite! - relation is engaged
			
			// On the rocks - relation is a spouse (not married or engaged) - _male and _female
			
			// prom king/queen - has more than 500 friends - _male and _female
			
			
		}
		
		public function get bonuses():Dictionary.<string, BonusVO>() {
			return data as Dictionary.<string, BonusVO>();
		}
	}
}