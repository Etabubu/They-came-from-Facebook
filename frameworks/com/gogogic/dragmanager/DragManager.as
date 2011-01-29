package com.gogogic.dragmanager
{
	import com.gogogic.dragmanager.events.DragEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class DragManager
	{
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constant that specifies that the type of drag action is "none".
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static const NONE:String = "none";
		
		/**
		 *  Constant that specifies that the type of drag action is "copy".
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static const COPY:String = "copy";
		
		/**
		 *  Constant that specifies that the type of drag action is "move".
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static const MOVE:String = "move";
		
		/**
		 *  Constant that specifies that the type of drag action is "link".
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static const LINK:String = "link";
		
		
		private static var instance:DragManager;
		private var _isInitialized:Boolean = false;
		
		private var _stage:Stage;
		private var _dragLayer:DisplayObjectContainer;
		
		private var _mouseIsDown:Boolean = false;
		private var _dragImage:DisplayObject;
		private var _isDragging:Boolean;
		
		private var _curTarget:DisplayObject;
		
		private var _dragInitiator:DisplayObject;
		private var _dragSource:DragSource;
		private var _action:String;
		private var _lastMouseEvent:MouseEvent;
		
		public function DragManager()
		{
		}
		
		public function initialize(stage:Stage, dragLayer:DisplayObjectContainer):void {
			if (!stage || !dragLayer) throw new ArgumentError("stage and dragLayer cannot be null");
			_stage = stage;
			_dragLayer = dragLayer;
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
			_stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			_isInitialized = true;
		}
		
		public static function getInstance():DragManager
		{
			if (!instance)
			{
				instance = new DragManager();
			}
			
			return instance;
		}
		
		public function doDrag(
			dragInitiator:DisplayObject, 
			dragSource:DragSource, 
			mouseEvent:MouseEvent,
			dragImage:DisplayObject, // instance of dragged item(s)
			xOffset:Number = 0,
			yOffset:Number = 0,
			imageAlpha:Number = 0.5,
			allowMove:Boolean = true):void
		{
			if (!_isInitialized)
				throw new Error("Drag manager is not initialized. Call initialize() before using the drag manager.");
			
			_curTarget = null;
			
			_dragImage = dragImage;
			_dragLayer.addChild(_dragImage);
			_dragImage.x = _dragLayer.mouseX;
			_dragImage.y = _dragLayer.mouseY;
			
			_dragInitiator = dragInitiator;
			_dragSource = dragSource;
			
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageDrag);
			_stage.addEventListener(MouseEvent.MOUSE_UP, onDragMouseUp);
		}
		
		protected function onStageDrag(e:MouseEvent):void {
			_lastMouseEvent = e;
			_dragImage.x = _dragLayer.mouseX;
			_dragImage.y = _dragLayer.mouseY;
			
			var dragEvent:DragEvent = new DragEvent(DragEvent.DRAG_DROP);
			dragEvent.ctrlKey = e.ctrlKey;
			dragEvent.altKey = e.altKey;
			dragEvent.shiftKey = e.shiftKey;
			
			var newTarget:DisplayObject = null;
			var dropTarget:DisplayObject = null;
			var targetList:Array = [];
			getObjectsUnderPoint(_stage, new Point(_stage.mouseX, _stage.mouseY), targetList);
			
			// targetList is in depth order, and we want the top of the list. However, we
			// do not want the target to be a decendent of us.
			var targetIndex:int = targetList.length - 1;
			while (targetIndex >= 0)
			{
				newTarget = targetList[targetIndex];
				if (newTarget != _dragLayer && !_dragLayer.contains(newTarget))
					break;
				targetIndex--;
			}
			
			if (_curTarget)
			{
				var foundIt:Boolean = false;
				var oldTarget:DisplayObject = _curTarget;
				
				dropTarget = newTarget;
				
				while (dropTarget)
				{
					if (dropTarget == _curTarget)
					{
						// trace("    dispatch DRAG_OVER on", dropTarget);
						// Dispatch a "dragOver" event
						dispatchDragEvent(DragEvent.DRAG_OVER, e, dropTarget);
						foundIt = true;
						break;
					} 
					else 
					{
						// trace("    dispatch DRAG_ENTER on", dropTarget);
						// Dispatch a "dragEnter" event and see if a new object
						// steals the target.
						dispatchDragEvent(DragEvent.DRAG_ENTER, e, dropTarget);
						
						// If the potential target accepted the drag, our target
						// now points to the dropTarget. Bail out here, but make 
						// sure we send a dragExit event to the oldTarget.
						if (_curTarget == dropTarget)
						{
							foundIt = false;
							break;
						}
					}
					dropTarget = dropTarget.parent;
				}
				
				// If we are no longer over the previous target 
				if (!foundIt)
				{
					// trace("    dispatch DRAG_EXIT on", oldTarget);
					// Dispatch a "dragExit" event on the old target.
					dispatchDragEvent(DragEvent.DRAG_EXIT, e, oldTarget);
					
					if (_curTarget == oldTarget)
						_curTarget = null;
				}
			}
			
			// If we don't have an existing target, go look for one.
			if (!_curTarget)
			{
				_action = DragManager.MOVE;
				
				// Dispatch a "dragEnter" event.
				dropTarget = newTarget;
				while (dropTarget)
				{
					if (dropTarget != _dragLayer)
					{
						// trace("    dispatch DRAG_ENTER on", dropTarget);
						dispatchDragEvent(DragEvent.DRAG_ENTER, e, dropTarget);
						if (_curTarget)
							break;
					}
					dropTarget = dropTarget.parent;
				}
				
				if (!_curTarget)
					_action = DragManager.NONE;
			}
		}
		
		protected function onDragMouseUp(e:MouseEvent):void {
			_lastMouseEvent = e;
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageDrag);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, onDragMouseUp);
			
			// Hide the drag cursor
			_dragLayer.removeChild(_dragImage);
			_dragImage = null;
			
			var dragEvent:DragEvent;
			var wasCancelled:Boolean = false;
			
			if (_curTarget && _action != DragManager.NONE)
			{
				// Dispatch a "dragDrop" event.
				dragEvent = new DragEvent(DragEvent.DRAG_DROP);
				dragEvent.dragInitiator = _dragInitiator;
				dragEvent.dragSource = _dragSource;
				dragEvent.action = _action;
				dragEvent.ctrlKey = e.ctrlKey;
				dragEvent.altKey = e.altKey;
				dragEvent.shiftKey = e.shiftKey;
				var pt:Point = new Point();
				pt.x = _lastMouseEvent.localX;
				pt.y = _lastMouseEvent.localY;
				pt = DisplayObject(_lastMouseEvent.target).localToGlobal(pt);
				pt = DisplayObject(_curTarget).globalToLocal(pt);
				dragEvent.localX = pt.x;
				dragEvent.localY = pt.y;
				wasCancelled = !_curTarget.dispatchEvent(dragEvent);
			}
			else
			{
				_action = DragManager.NONE;
			}
			
			// Dispatch a "dragComplete" event.
			dragEvent = new DragEvent(DragEvent.DRAG_COMPLETE);
			dragEvent.dragInitiator = _dragInitiator;
			dragEvent.dragSource = _dragSource;
			dragEvent.action = _action;
			dragEvent.ctrlKey = e.ctrlKey;
			dragEvent.altKey = e.altKey;
			dragEvent.shiftKey = e.shiftKey;
			dragEvent.wasCancelled = wasCancelled;
			_dragInitiator.dispatchEvent(dragEvent);
			
			
			_lastMouseEvent = null;
		}
		
		private function dispatchDragEvent(type:String, mouseEvent:MouseEvent, eventTarget:Object):void
		{
			var dragEvent:DragEvent = new DragEvent(type);
			var pt:Point = new Point();
			
			dragEvent.dragInitiator = _dragInitiator;
			dragEvent.dragSource = _dragSource;
			dragEvent.action = _action;
			dragEvent.ctrlKey = mouseEvent.ctrlKey;
			dragEvent.altKey = mouseEvent.altKey;
			dragEvent.shiftKey = mouseEvent.shiftKey;
			pt.x = _lastMouseEvent.localX;
			pt.y = _lastMouseEvent.localY;
			pt = DisplayObject(_lastMouseEvent.target).localToGlobal(pt);
			pt = DisplayObject(eventTarget).globalToLocal(pt);
			dragEvent.localX = eventTarget.mouseX;
			dragEvent.localY = eventTarget.mouseY;
			eventTarget.dispatchEvent(dragEvent);
		}
		
		public function acceptDragDrop(target:DisplayObject):void
		{
			_curTarget = target as DisplayObject;
			
			//if (hasEventListener("acceptDragDrop"))
			//{}//dispatchEvent(new Request("acceptDragDrop", false, false, target));*/
		}
		
		public function endDrag():void
		{
			
		}
		
		/**
		 *  Read-only property that returns <code>true</code>
		 *  if a drag is in progress.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get isDragging():Boolean {
			return _isDragging;
		}
		
		private function onStageMouseDown(e:MouseEvent):void {
			_mouseIsDown = true;
		}
		
		private function onStageMouseUp(e:MouseEvent):void {
			_mouseIsDown = false;
		}
		
		private function getObjectsUnderPoint(displayObject:DisplayObject, pt:Point, arr:Array):void {
			if (!displayObject.visible) return;
			if (displayObject is InteractiveObject && !(displayObject as InteractiveObject).mouseEnabled) return;
			
			if (displayObject.hitTestPoint(pt.x, pt.y, true) || displayObject is Stage) {
				arr.push(displayObject);
				if (displayObject is DisplayObjectContainer) {
					var doc:DisplayObjectContainer = displayObject as DisplayObjectContainer;
					if (doc.numChildren > 0)
					{
						var n:int = doc.numChildren;
						for (var i:int = 0; i < n; i++)
						{
							getObjectsUnderPoint(doc.getChildAt(i), pt, arr);
						}
					}
				}
			}
		}
	}
}