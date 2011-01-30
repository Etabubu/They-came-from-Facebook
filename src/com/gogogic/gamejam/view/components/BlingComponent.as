package com.gogogic.gamejam.view.components
{
	import com.gogogic.gamejam.Application;
	import com.gogogic.gamejam.assets.Bling;
	import com.gogogic.gamejam.model.vo.BonusVO;
	import com.gogogic.ui.shrinkTextToFit;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Sine;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class BlingComponent extends Sprite
	{
		private var _bling:Bling;
		
		public function BlingComponent(bonusVO:BonusVO)
		{
			addChild(_bling = new Bling());
			_bling.txtTitle.text = bonusVO.name;
			_bling.txtPoints.text = "+" + bonusVO.points.toString();
			_bling.txtDescription.text = bonusVO.subtext;
			shrinkTextToFit([_bling.txtPoints, _bling.txtDescription]);
			
			x = Application.APPLICATION_WIDTH / 2;
			y = 500;
			
			var app:BlingComponent = this;
			
			scaleX = scaleY = .2;
			TweenLite.to(this, .6, { scaleX: 1, scaleY: 1, ease: Bounce.easeOut });
			TweenLite.to(this, 2.5, { y: 150, ease: Linear.easeNone, overwrite: false, onComplete: dispatchEvent, onCompleteParams: [new Event(Event.COMPLETE)] });
			TweenLite.delayedCall(2.1, function():void {
				TweenLite.to(app, .4, { scaleX: .2, scaleY: .2, ease: Back.easeIn, overwrite: false });
			});
		}
	}
}