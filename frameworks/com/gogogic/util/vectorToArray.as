package com.gogogic.util
{
	public function vectorToArray(vector:*):Array
	{
		if (!vector) return null;
		var i:int = vector.length;
		var ret:Array = new Array(i);

		while (i--)
			ret[i] = vector[i];
		
		return ret;
	}
}