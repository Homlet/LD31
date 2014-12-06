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
		public static const ROOM_RECTANGLE:uint = 1;
		public static const ROOM_CROSS:uint = 2;
		
		private var _start:Point;
		private var rooms:uint;
		
		private var tilemap:Tilemap;
		private var grid:Grid;
		
		public function Level(rooms:uint=14)
		{
			super();
			
			// Initialise variables.
			_start = new Point(0, 0);
			this.rooms = rooms;
			
			tilemap = generate();
			grid = tilemap.createGrid([0]);
			
			graphic = tilemap;
			mask = grid;
			type = Types.LEVEL;
		}
		
		public function get start():Point
		{
			return new Point(_start.x * TILE_SIZE, _start.y * TILE_SIZE);
		}
		
		private function generate():Tilemap
		{
			var level:Tilemap = new Tilemap(Images.TILES,
				Main.WIDTH, Main.HEIGHT, TILE_SIZE, TILE_SIZE);
			level.floodFill(0, 0, 0);
			
			// Create list of room centres.
			var room_centers:Array = [];
			var room_spread:Number = Math.ceil(Math.sqrt(rooms));
			
			var grid_points:uint = Math.pow(room_spread, 2);
			var slack:uint = grid_points - rooms;
			
			for (var j:uint = 0; j < room_spread; j++)
			for (var i:uint = 0; i < room_spread; i++)
			{
				if (slack > 0)
				{
					if (grid_points - room_centers.length <= slack
					 || Math.random() > 0.8)
					{
						slack--;
						continue;
					}
				}
				
				room_centers.push(new Point(
					(i + 0.5) * MAP_WIDTH / room_spread + Math.random() * 8 - 4,
					(j + 0.5) * MAP_HEIGHT / room_spread + Math.random() * 8 - 4));
			}
			_start = room_centers[0].clone();
			
			// Generate rooms.
			for each (var center:Point in room_centers)
			{
				switch (Math.floor(Math.random() * 2.8))
				{
				case ROOM_STARBURST:
					var size:Number = 4 + 5 * Math.random();
					apply_starburst(level, center, size, size, true);
					break;
				
				case ROOM_RECTANGLE:
					var width:uint = uint(6 + 8 * Math.random());
					var height:uint = uint(5 + 5 * Math.random());
					level.setRect(
						center.x - width / 2, center.y - height / 2,
						width, height, 1);
					break;
				
				case ROOM_CROSS:
					var breadth:uint = uint(6 + 3 * Math.random());
					var dip:uint = uint(3 + 2 * Math.random());
					level.setRect(
						center.x - breadth / 2, center.y - (breadth - dip) / 2,
						breadth, breadth - dip, 1);
					level.setRect(
						center.x - (breadth - dip) / 2, center.y - breadth / 2,
						breadth - dip, breadth, 1);
					break;
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
			size:Number=7.0, detail:uint=30, smooth:Boolean=false):void
		{			
			function visit(i:int, j:int):void
			{
				if (0 <= i && i < MAP_WIDTH
				 && 0 <= j && j < MAP_HEIGHT)
				{
					level.setTile(i, j, 1);
				}
			}
			
			function generate_endpoint(theta:Number):Point
			{
				var length:Number = size * (0.5 + Math.log(1 + Math.random()));
				return new Point(
					center.x + length * Math.cos(theta),
					center.y + length * Math.sin(theta));
			}
			
			const tau:Number = Math.PI * 2;
			var sweep:Number = tau / detail;
			var ends:Array = [];
			for (var theta:Number = 0; theta < tau; theta += sweep)
			{
				if (smooth)
					ends.push(generate_endpoint(theta));
				else
					Utils.raytrace(center, generate_endpoint(theta), visit);
			}
			
			if (smooth)
			{
				var last:Point = ends[ends.length - 1];
				for each(var end:Point in ends)
				{
					Utils.raytrace(last, end, visit);
					last = end;
				}
				level.floodFill(center.x, center.y, 1);
			}
		}
	}
}
