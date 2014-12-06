package uk.co.homletmoo.ld31.assets 
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * Stores static references to image sources.
	 * 
	 * @author Homletmoo
	 */
	public class Images 
	{
		[Embed (source = "images/hm.png")] public static var HM_LOGO:Class;
		[Embed (source = "images/flashpunk.png")] public static var FP_LOGO:Class;
		
		public static var cache:Dictionary;
		public static function scale(source:Class, factor:uint):BitmapData
		{
			if (cache == null) { cache = new Dictionary(); }
			if (cache[source] != null) { return cache[source]; }
			
			var bitmap:BitmapData = FP.getBitmap(source);
			
			var width:uint = (bitmap.width * factor) || 1;
			var height:uint = (bitmap.height * factor) || 1;
			
			var scaled:BitmapData = new BitmapData(width, height, true, 0);
			var matrix:Matrix = new Matrix();
			matrix.scale(factor, factor);
			scaled.draw(bitmap, matrix);
			
			cache[source] = scaled;
			
			return scaled;
		}
	}
}
