package com.gogogic.gamejam.view.components
{
	import com.gogogic.gamejam.model.vo.FriendVO;
	import com.gogogic.gamejam.model.vo.UnitVO;
	import com.gogogic.gamejam.model.vo.event.DataChangeEvent;
	
	import flash.display.Sprite;
	
	public class UnitComponent extends Sprite
	{
		protected var _unitVO:UnitVO;
		protected var _allUnits:Vector.<UnitVO>;
		
		public function UnitComponent(unitVO:UnitVO)
		{
			_unitVO = unitVO;
			_unitVO.addEventListener(DataChangeEvent.DATA_CHANGE, onUnitVODataChange);
		}
		
		public function get unitVO():UnitVO {
			return _unitVO;
		}
		
		public function init(friendVO:FriendVO, allUnits:Vector.<UnitVO>, x:int, y:int, isEnemy:Boolean):void {
			_unitVO.friendVO = friendVO;
			_unitVO.x = x;
			_unitVO.y = y;
			_unitVO.isEnemy = isEnemy;
			_allUnits = allUnits;
			update();
		}
		
		protected function onUnitVODataChange(e:DataChangeEvent):void {
			update();
		}
		
		// A little expensive, do not overuse
		protected function get enemyUnits():Vector.<UnitVO> {
			return getUnits(false);
		}
		
		// A little expensive, do not overuse
		protected function get friendlyUnits():Vector.<UnitVO> {
			return getUnits(true);
		}

		
		private function getUnits(friendly:Boolean):Vector.<UnitVO> {
			var ret:Vector.<UnitVO> = new Vector.<UnitVO>();
			for each (var unit:UnitVO in _allUnits) {
				if (_unitVO.isEnemy == (unit.isEnemy == friendly) && (_unitVO != unit))
					ret.push(unit);
			}
			return ret;
		}
		
		protected function update():void {
			// Basic motor functions
			x = _unitVO.x;
			y = _unitVO.y;
			rotation = _unitVO.rotation;
		}
		
		protected function distanceTo(unit:UnitVO):Number {
			var xDist:Number = unit.x - _unitVO.x;
			var yDist:Number = unit.y - _unitVO.y;
			return Math.sqrt(xDist*xDist + yDist*yDist);
		}
		
		protected function get closestEnemy():UnitVO {
			return getClosestUnit(false);
		}
		
		protected function get closestFriend():UnitVO {
			return getClosestUnit(true);
		}
		
		private function getClosestUnit(isFriend:Boolean):UnitVO {
			var closestEnemy:UnitVO;
			var closestEnemyDistance:Number;
			
			for each (var enemy:UnitVO in (isFriend ? friendlyUnits : enemyUnits)) {
				var dist:Number = distanceTo(enemy);
				if (!closestEnemy || dist < closestEnemyDistance) {
					closestEnemyDistance = dist;
					closestEnemy = enemy;
				}
			}
			
			return closestEnemy;
		}
	}
}