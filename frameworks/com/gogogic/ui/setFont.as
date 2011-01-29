package com.gogogic.ui {
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public function setFont(textFields:*, font:String = null, autoSize:Boolean = false):void {
		if (textFields is TextField) textFields = [textFields];
		else if (!(textFields is Array)) throw new ArgumentError("The property textFields should be either a text field or an Array of textFields.");
		
		var tf:TextFormat = TextField(textFields[0]).getTextFormat();
		tf.font = font;
		
		for each (var textField:TextField in textFields) {
			textField.embedFonts = true;
			textField.defaultTextFormat = tf;
			textField.setTextFormat(tf);
			textField.antiAliasType = AntiAliasType.ADVANCED;
			if (autoSize) {
				if (tf.align == TextFormatAlign.LEFT)
					textField.autoSize = TextFieldAutoSize.LEFT;
				else if (tf.align == TextFormatAlign.RIGHT)
					textField.autoSize = TextFieldAutoSize.RIGHT;
				else if (tf.align == TextFormatAlign.CENTER)
					textField.autoSize = TextFieldAutoSize.CENTER;
				else
					textField.autoSize = TextFieldAutoSize.NONE;
			}
		}
	}
}
