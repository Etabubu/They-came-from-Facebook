package com.gogogic.ui {
	
	public class TextScroller {
		import flash.display.Sprite;
		import flash.text.TextField;
		import com.greensock.TweenLite;
		import com.greensock.easing.Linear;
		
		private var _textField:TextField;
		private var _maxHeight:Number;
		private var _originalY:Number;
		private var _scrollSpeedMultiplier:Number;
		private var _mask:Sprite;
		
		public var delayBeforeScrolling:Number = 1.5;
		public var delayBeforeResetting:Number = 1.5;
		public var alphaTweenTime:Number = 1;
		
		public function TextScroller(textField:TextField, maxHeight:Number, scrollSpeedMultiplier:Number = 1) {
			
			_textField = textField;
			_maxHeight = maxHeight;
			_scrollSpeedMultiplier = scrollSpeedMultiplier;
			
			_mask = new Sprite();
			_mask.graphics.beginFill(0);
			_mask.graphics.drawRect(0, 0, textField.width, maxHeight);
			_mask.graphics.endFill();
			
			_mask.x = textField.x;
			_mask.y = textField.y;
			
			textField.parent.addChild(_mask);
			textField.mask = _mask;
			
			_originalY = textField.y;
			start();
		}
		
		public function start():void {
			if (_textField.height < _maxHeight) return;
			_textField.y = _originalY;
			_textField.alpha = 1;
			TweenLite.delayedCall(delayBeforeScrolling, scrollTextDown);  
		}
		
		public function stop():void {
			TweenLite.killDelayedCallsTo(fadeOut);
			TweenLite.killDelayedCallsTo(scrollTextDown);
			TweenLite.killTweensOf(_textField);
		}
		
		public function reset():void {
			stop();
			start();
		}
		
		private function scrollTextDown():void {
			TweenLite.to(_textField, (_textField.height - _maxHeight) * (0.1 / _scrollSpeedMultiplier), {
				y: _originalY - (_textField.height - _maxHeight),
				ease: Linear.easeNone,
				onComplete: onTextScrolledDown
			});
		}
		
		private function onTextScrolledDown():void {
			TweenLite.delayedCall(delayBeforeResetting, fadeOut);  
		}
		
		private function fadeOut():void {
			TweenLite.to(_textField, alphaTweenTime / 2, { alpha: 0, onComplete: onFadedOut });
		}
		
		private function onFadedOut():void {
			_textField.y = _originalY;
			TweenLite.to(_textField, alphaTweenTime / 2, { alpha: 1, onComplete: onFadedIn });
		}
		
		private function onFadedIn():void {
			TweenLite.delayedCall(delayBeforeScrolling, scrollTextDown); 
		}
		
		public function dispose():void {
			stop();
			_textField.y = _originalY;
			_textField.alpha = 1;
			_mask.parent.removeChild(_mask);
		}
	}
}