package com.gogogic.util
{
	import flash.utils.getQualifiedClassName;

	public function getClassName(o:Object):String
	{
		var fullClassName:String = getQualifiedClassName(o);
		return fullClassName.slice(fullClassName.lastIndexOf("::") + 2);
	}
}