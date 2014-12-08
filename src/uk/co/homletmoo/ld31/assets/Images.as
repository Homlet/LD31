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
		[Embed (source = "images/tiles.png")] public static var TILES:Class;
		[Embed (source = "images/stair.png")] public static var STAIR:Class;
		[Embed (source = "images/torch.png")] public static var TORCH:Class;
		[Embed (source = "images/player.png")] public static var PLAYER:Class;
		[Embed (source = "images/enemy.png")] public static var ENEMY:Class;
		[Embed (source = "images/key.png")] public static var KEY:Class;
		[Embed (source = "images/escape.png")] public static var ESCAPE:Class;
		[Embed (source = "images/killed.png")] public static var KILLED:Class;
		[Embed (source = "images/slide_0.png")] public static var SLIDE_0:Class;
		[Embed (source = "images/slide_1.png")] public static var SLIDE_1:Class;
		[Embed (source = "images/slide_3.png")] public static var SLIDE_2:Class;
		public static var SLIDES:Array = [SLIDE_0, SLIDE_1, SLIDE_2];
		[Embed (source = "images/thexofy.png")] public static var TITLE:Class;
		
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
