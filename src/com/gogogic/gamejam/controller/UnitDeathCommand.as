package com.gogogic.gamejam.controller
{
	import com.gogogic.gamejam.model.PlayerProxy;
	import com.gogogic.gamejam.model.vo.BonusVO;
	import com.gogogic.gamejam.model.vo.UnitVO;
	import com.gogogic.gamejam.view.BlingMediator;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class UnitDeathCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void {
			var theUnit:UnitVO = notification.getBody() as UnitVO;
			
			// mark the friend as killed
			theUnit.friendVO.killedThisSession = true;
			
			for each(var bonus:BonusVO in theUnit.friendVO.bonuses) {
				if (!bonus) {
					trace("JONATHAN, your code is broken!");
					continue;
				}
				// display bonus
				sendNotification(BlingMediator.NAME, bonus);
				// add to score
				(facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy).playerVO.score += bonus.points;
				(facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy).playerVO.triggerDataChangeEvent();
			}
		}
	}
}