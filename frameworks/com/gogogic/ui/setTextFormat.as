package com.gogogic.ui {
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
		
	public function setTextFormat(textFields:*, font:String = null, size:Object = null, color:Object = null, bold:Object = null, italic:Object = null,
	underline:Object = null, url:String = null, target:String = null, align:String = null, leftMargin:Object = null, rightMargin:Object = null,
	indent:Object = null, leading:Object = null, letterSpacing:Number = NaN):void {
		var tf:TextFormat = new TextFormat(font, size, color, bold, italic, underline, url, target, align, leftMargin, rightMargin, indent, leading);
		if (textFields is TextField) textFields = [textFields];
		else if (!(textFields is Array)) throw new ArgumentError("The property textFields should be either a text field or an Array of textFields.");
		
		for each (var textField:TextField in textFields) {
			if (isNaN(letterSpacing)) {
				try {
					var tf2:TextFormat = textField.getTextFormat();
					if( tf2 )
						tf.letterSpacing = tf2.letterSpacing;
				} catch ( error:Error ) {
					trace( "********* setTextFormat error" );
				}
			} else {
				tf.letterSpacing = letterSpacing;
			}
			textField.embedFonts = true;
			textField.defaultTextFormat = tf;
			textField.setTextFormat(tf);
			textField.antiAliasType = AntiAliasType.ADVANCED;
		}
	}
}
