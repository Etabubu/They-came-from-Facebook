package com.gogogic.ui
{
	import flash.display.Graphics;

	public function drawPieMask(graphics:Graphics, percentage:Number, radius:Number = 50, x:Number = 0, y:Number = 0, rotation:Number = 0, sides:int = 3):void {
		// graphics should have its beginFill function already called by now
		graphics.moveTo(x, y);
		if (sides < 3) sides = 3; // 3 sides minimum
		// Increase the length of the radius to cover the whole target
		radius /= Math.cos(1/sides * Math.PI);
		// Shortcut function
		var lineToRadians:Function = function(rads:Number):void {
			graphics.lineTo(Math.cos(rads) * radius + x, Math.sin(rads) * radius + y);
		};
		// Find how many sides we have to draw
		var sidesToDraw:int = Math.floor(percentage * sides);
		for (var i:int = 0; i <= sidesToDraw; i++)
			lineToRadians((i / sides) * (Math.PI * 2) + rotation);
		// Draw the last fractioned side
		if (percentage * sides != sidesToDraw)
			lineToRadians(percentage * (Math.PI * 2) + rotation);
	}
}