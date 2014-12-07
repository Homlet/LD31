package uk.co.homletmoo.ld31.entity 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	import uk.co.homletmoo.ld31.assets.Images;
	import uk.co.homletmoo.ld31.Layers;
	import uk.co.homletmoo.ld31.Main;
	import uk.co.homletmoo.ld31.Utils;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class Fog extends Entity
	{
		public static const STAGES:uint = 4;
		
		private var tilemap:Tilemap;
		private var uncovered:Grid;
		
		public function Fog()
		{
			super();
			
			// Initialise variables.
			tilemap = new Tilemap(
				Images.scale(Images.TORCH, Level.TILE_SIZE),
				Main.WIDTH, Main.HEIGHT, Level.TILE_SIZE, Level.TILE_SIZE);
			tilemap.floodFill(0, 0, STAGES - 1);
			uncovered = tilemap.createGrid([]);
			graphic = tilemap;
			
			layer = Layers.FOG;
		}
		
		public function uncover(center:Point, radius:Number=12):void
		{
			center = center.clone();
			center.x /= Level.TILE_SIZE;
			center.y /= Level.TILE_SIZE;
			var start:Point = new Point(
				Math.max(0, Math.floor(center.x - radius)),
				Math.max(0, Math.floor(center.y - radius)));
			var end:Point = new Point(
				Math.min(Level.MAP_WIDTH - 1,  Math.ceil(center.x + radius)),
				Math.min(Level.MAP_HEIGHT - 1, Math.ceil(center.y + radius)));
			for (var i:int = start.x; i <= end.x; i++)
			for (var j:int = start.y; j <= end.y; j++)
			{
				var dist:Number = Point.distance(center, new Point(i, j));
				if (dist > radius)
				{
					if (uncovered.getTile(i, j))
						tilemap.setTile(i, j, STAGES - 2);
					else
						tilemap.setTile(i, j, STAGES - 1);
				} else
				{
					var light:uint = Math.floor((STAGES - 2) * Math.min(radius, dist) / radius);
					tilemap.setTile(i, j, light);
					uncovered.setTile(i, j, true);
				}
			}
		}
	}
}
