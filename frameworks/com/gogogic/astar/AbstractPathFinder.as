package com.gogogic.astar
{
	public class AbstractPathFinder
	{
		protected var _nodes:Vector.<Vector.<Node>>;
		protected var _open:Vector.<Node>;
		protected var _closed:Vector.<Node>;
		
		protected var _targetNode:Node;
		
		public function AbstractPathFinder()
		{
			
		}
		
		/**
		 * This function should be overrided. 
		 */		
		public function buildIndex(data:Object):void {
			// Override me to build up _nodes
		}
		
		public function aStar(fromX:int, fromY:int, toX:int, toY:int):Vector.<Node> {
			resetNodes();
			
			_open = new Vector.<Node>();
			_open.push(getNodeAt(fromX, fromY));
			_closed = new Vector.<Node>();
			_targetNode = getNodeAt(toX, toY);
			if (!_targetNode) return new Vector.<Node>();
			if (!_targetNode.walkable) return new Vector.<Node>();
			
			var path:Vector.<Node> = new Vector.<Node>();
			var curNode:Node;
			
			while(true) {
				curNode = cheapestOpenNode;
				if (!curNode) return new Vector.<Node>();
				if (curNode == _targetNode) {
					path.push(curNode);
					break;
				}
				
				addToOpen(curNode.x-1, curNode.y, curNode); // left
				addToOpen(curNode.x+1, curNode.y, curNode); // right
				addToOpen(curNode.x, curNode.y-1, curNode); // up
				addToOpen(curNode.x, curNode.y + 1, curNode); // down
				
				_open.splice(_open.indexOf(curNode), 1);
				_closed.push(curNode);
				if (_open.length == 0) {
					return new Vector.<Node>();
				}
			}
			curNode = path[path.length - 1];
			while (curNode.parent != null) {
				curNode = curNode.parent;
				path.push(curNode);
			}
			path.reverse();
			return path;
		}
		
		private function addToOpen(x:int, y:int, parentNode:Node):void {
			var node:Node = getNodeAt(x, y);
			if (!node) return;
			if (!node.walkable) return;
			if (_open.indexOf(node) != -1) return;
			if (_closed.indexOf(node) != -1) return;
			heuristics(node);
			node.parent = parentNode;
			_open.push(node);
		}
		
		private function heuristics(node:Node):void {
			//node.cost = node.walkCost + Math.abs(node.x - _targetNode.x) + Math.abs(node.y - _targetNode.y);
			
			var dx:Number = Math.abs(node.x - _targetNode.x);
			var dy:Number = Math.abs(node.y - _targetNode.y);
			var diag:Number = Math.min(dx, dy);
			var straight:Number = dx + dy;
			node.cost = node.walkCost + 1 * diag + 1.5 * (straight - 2 * diag);
		}
		
		private function get cheapestOpenNode():Node {
			var cheapest:Node = null;
			for each (var node:Node in _open) {
				if (!cheapest) {
					cheapest = node;
				} else {
					if (node.cost < cheapest.cost)
						cheapest = node;
				}
			}
			return cheapest;
		}
		
		private function getNodeAt(x:int, y:int):Node {
			if (x < 0 || y < 0 || x >= _nodes.length || y >= _nodes[x].length) return null;
			return _nodes[x][y];
		}
		
		private function resetNodes():void {
			for each (var xLine:Vector.<Node> in _nodes) {
				for each (var node:Node in xLine) {
					if (!node) continue;
					node.cost = 0;
					node.parent = null;
				}
			}
		}
	}
}