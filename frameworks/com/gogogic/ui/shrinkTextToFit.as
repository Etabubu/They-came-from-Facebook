package com.gogogic.ui
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	
	/**
	 * Shrinks the text in the provided textfield(s) to fit in the textfield(s).
	 * 
	 * @param textFields		A textfield or an array or vector of textfields to shrink the text for.
	 * @param minSize			If set, sets the maximum fontsize for the textfield(s).
	 * @param setAsMultiline	If set to true, turns on multiline and wordWrap for the textfield(s).
	 * 
	 * @returns 	The font size that was chosen for the text field, or the last text field
	 */
	public function shrinkTextToFit(textFields:*, maxSize:Number = NaN, setAsMultiline:Boolean = false):Number
	{
		if (textFields is TextField) textFields = [textFields];
		else if (!(textFields is Array) && !(textFields is Vector.<TextField>))
			throw new ArgumentError("The property textFields should be either a text field or an Array or Vector of TextFields.");
		
		for each (var textField:TextField in textFields) {
			if (setAsMultiline)
				textField.multiline = textField.wordWrap = true;
			var targetWidth:Number = textField.width;
			var targetHeight:Number = textField.height;
			var prevAutoSize:String = textField.autoSize;
			textField.autoSize = TextFieldAutoSize.LEFT;
			
			var fontSize:Number = (maxSize || textField.defaultTextFormat.size as Number || 12) + .2;
			var tf:TextFormat;
			
			do {
				tf = new TextFormat(null, fontSize -= .2);
				textField.setTextFormat(textField.defaultTextFormat = tf);
			}
			while (textField.width > targetWidth || textField.height > targetHeight);
			
			textField.autoSize = prevAutoSize;
			textField.width = targetWidth;
			textField.height = targetHeight;
		}
		return fontSize;
	}
}