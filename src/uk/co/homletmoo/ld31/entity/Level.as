package uk.co.homletmoo.ld31.entity 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.Mask;
	import net.flashpunk.masks.Grid;
	import uk.co.homletmoo.ld31.assets.Images;
	import uk.co.homletmoo.ld31.Main;
	import uk.co.homletmoo.ld31.Types;
	import uk.co.homletmoo.ld31.Utils;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class Level extends Entity 
	{
		public static const TILE_SIZE:uint = 8;
		public static const MAP_WIDTH:uint = uint(Main.WIDTH / TILE_SIZE);
		public static const MAP_HEIGHT:uint = uint(Main.HEIGHT / TILE_SIZE);
		
		public static const ROOM_STARBURST:uint = 0;
		
		private var rooms:uint;
		
		private var tilemap:Tilemap;
		private var grid:Grid;
		
		public function Level(rooms:uint=10)
		{
			super();
			
			// Initialise variables.
			this.rooms = rooms;
			
			tilemap = generate();
			grid = tilemap.createGrid([0]);
			
			graphic = tilemap;
			mask = grid;
			type = Types.LEVEL;
		}
		
		private function generate():Tilemap
		{
			var level:Tilemap = new Tilemap(Images.TILES,
				Main.WIDTH, Main.HEIGHT, TILE_SIZE, TILE_SIZE);
			level.floodFill(0, 0, 0);
			
			// Create list of room centres.
			var room_centers:Array = [];
			for (var i:int = 0; i < rooms; i++)
			{
				room_centers.push(new Point(
					uint(Math.random() * MAP_WIDTH),
					uint(Math.random() * MAP_HEIGHT)));
			}
			
			// Generate rooms.
			for each (var center:Point in room_centers)
			{
				switch (Math.floor(Math.random()))
				{
				case ROOM_STARBURST:
					apply_starburst(level, center);
				}
			}
			
			return level;
		}
		
		/**
		 * Create a room in a given tilemap by projecting rays from a point.
		 * @param	level   The tilemap to add the room to.
		 * @param	center  Point from which to project rays.
		 * @param	size    Max length of rays.
		 * @param	detail  Number of rays.
		 */
		private function apply_starburst(level:Tilemap, center:Point,
			size:Number = 10.0, detail:uint = 30):void
		{			
			function visit(i:int, j:int):void
			{
				if (0 <= i && i < MAP_WIDTH
				 && 0 <= j && j < MAP_HEIGHT)
				{
					level.setTile(i, j, 1);
				}
			}
			
			const tau:Number = Math.PI * 2;
			var sweep:Number = tau / detail;
			for (var theta:Number = 0; theta < tau; theta += sweep)
			{
				var length:Number = size * (
					0.75 +
					0.25 * Math.pow(Math.sin(theta * 2), 2) +
					0.15 * Math.random());
				var end:Point = new Point(
					center.x + length * Math.cos(theta),
					center.y + length * Math.sin(theta));
				
				Utils.raytrace(center, end, visit);
			}
		}
	}
}
