package com.gogogic.ui.tooltip
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	public class ToolTipManager
	{
		protected static var _toolTips:Dictionary = new Dictionary();
		protected static var _currentTarget:DisplayObject;
		protected static var _currentToolTip:ToolTip;
		protected static var _toolTipLayer:Sprite;
		
		public static function registerToolTip(target:DisplayObject, toolTip:String = null):void {
			if (!target) return;
			if (toolTip == null) {
				target.removeEventListener(MouseEvent.MOUSE_OVER, onTargetMouseOver);
				target.removeEventListener(MouseEvent.MOUSE_OUT, onTargetMouseOut);
				delete _toolTips[target];
				if (_currentToolTip && _currentToolTip.target == target) {
					_toolTipLayer.removeChild(_currentToolTip);
					_currentToolTip = null;
				}
				return;
			}
			if (!_toolTips[target]) {
				target.addEventListener(MouseEvent.ROLL_OVER, onTargetMouseOver);
				target.addEventListener(MouseEvent.ROLL_OUT, onTargetMouseOut);
			}
			_toolTips[target] = toolTip;
			if (_currentToolTip && _currentToolTip.target == target)
				_currentToolTip.text = toolTip;
		}
		
		protected static function onTargetMouseOver(e:MouseEvent):void {
			if (!_toolTipLayer) DisplayObject(e.currentTarget).stage.addChild(_toolTipLayer = new Sprite());
			if (_currentToolTip) _toolTipLayer.removeChild(_currentToolTip);
			
			_currentToolTip = new ToolTip(e.currentTarget as DisplayObject, _toolTips[e.currentTarget]);
			_toolTipLayer.addChild(_currentToolTip);
		}
		
		protected static function onTargetMouseOut(e:MouseEvent):void {
			if (_currentToolTip && _currentToolTip.target == e.currentTarget) {
				_toolTipLayer.removeChild(_currentToolTip);
				_currentToolTip = null;
			}
		}
		
		public static function removeToolTip(target:DisplayObject):void {
			registerToolTip(target);
		}
		
		protected static function findTarget(displayObject:DisplayObject):void {
			_currentTarget = null;
			while (displayObject) {
				if (_toolTips[displayObject] != undefined)
					break;
				displayObject = displayObject.parent;
			}
			_currentTarget = displayObject;
		}
	}
}
import com.gogogic.ui.setTextFormat;
import com.greensock.TweenLite;
import com.neopets.vendor.gogogic.terrarium.util.FontManager;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.utils.Timer;
import flash.utils.getTimer;

class ToolTip extends Sprite {
	public var target:DisplayObject;
	public var text:String;
	
	protected static var _delayTimer:Timer;
	protected static var _lastHide:Number = -1;
	
	public function ToolTip(target:DisplayObject, text:String) {
		this.target = target;
		this.text = text || "";
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}
	
	protected function onAddedToStage(e:Event):void {
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		init();
	}
	
	protected function init():void {
		setupToolTip();
		
		if (!_delayTimer) _delayTimer = new Timer(700, 1);
		_delayTimer.stop();
		
		if (_lastHide > 0 && getTimer() - _lastHide < 200) {
			// show now!
			show(false);
		} else {
			// show later with delay
			_delayTimer.addEventListener(TimerEvent.TIMER, onDelayComplete);
			_delayTimer.start();
		}
		addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
	}
	
	protected function setupToolTip():void {
		var txt:TextField = new TextField();
		txt.text = text;
		txt.selectable = false;
		txt.autoSize = TextFieldAutoSize.LEFT;
		setTextFormat(txt, FontManager.HELVETICA_FONT_NAME);
		addChild(txt);
		txt.x = 6;
		txt.y = 3;
		graphics.lineStyle(1);
		graphics.beginFill(0xC3E31A);
		graphics.drawRect(0, 0, txt.width + 12, txt.height + 6);
		visible = false;
	}
	
	protected function show(transition:Boolean = true):void {
		var globalCoords:Point = localToGlobal(new Point(mouseX, mouseY));
		x = globalCoords.x + 8;
		y = globalCoords.y + 22;
		if (stage) {
			if (x + width + 3 > stage.stageWidth) x = stage.stageWidth - width - 3;
			if (y + height + 3 > stage.stageHeight) y = globalCoords.y - 28;
		}
		visible = true;
		if (transition) {
			alpha = 0;
			TweenLite.to(this, .25, { alpha: 1 });
		}
	}
	
	protected function onDelayComplete(e:TimerEvent):void {
		disposeTimer();
		show();
	}
	
	protected function onRemovedFromStage(e:Event):void {
		if (visible) _lastHide = getTimer();
		removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		disposeTimer();
	}
	
	protected function disposeTimer():void {
		_delayTimer.stop();
		_delayTimer.removeEventListener(TimerEvent.TIMER, onDelayComplete);
	}
	
}





