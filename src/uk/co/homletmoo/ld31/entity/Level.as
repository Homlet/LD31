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
	import uk.co.homletmoo.ld31.world.gen.Room;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class Level extends Entity 
	{
		public static const TILE_SIZE:uint = 8;
		public static const MAP_WIDTH:uint = uint(Main.WIDTH / TILE_SIZE);
		public static const MAP_HEIGHT:uint = uint(Main.HEIGHT / TILE_SIZE);
		
		private var _start:Point;
		private var room_count:uint;
		
		private var tilemap:Tilemap;
		private var grid:Grid;
		
		public function Level(room_count:uint=20)
		{
			super();
			
			// Initialise variables.
			_start = new Point(0, 0);
			this.room_count = room_count;
			
			tilemap = new Tilemap(Images.TILES,
				Main.WIDTH, Main.HEIGHT, TILE_SIZE, TILE_SIZE);
			tilemap.floodFill(0, 0, 0);
			
			graphic = tilemap;
			mask = grid;
			type = Types.LEVEL;
			
			// Generate the dungeon!
			generate();
			grid = tilemap.createGrid([0]);
		}
		
		public function get start():Point
		{
			return new Point(_start.x * TILE_SIZE, _start.y * TILE_SIZE);
		}
		
		private function generate():void
		{
			// Create list of rooms.
			var rooms:Vector.<Room> = new Vector.<Room>();
			
			var room_spread:Number = Math.ceil(Math.sqrt(room_count));
			var grid_points:uint = Math.pow(room_spread, 2);
			var slack:uint = grid_points - room_count;
			
			for (var j:uint = 0; j < room_spread; j++)
			for (var i:uint = 0; i < room_spread; i++)
			{
				// Skip some grid points so we get the correct number of rooms.
				if (slack > 0)
				{
					if (grid_points - rooms.length < slack
					 || Math.random() > 1) // TODO
					{
						slack--;
						continue;
					}
				}
				
				// Do a weighted random on room shape.
				var weights:Array = [3, 4, 1];
				var rand:uint = Math.floor(Math.random() * 8);
				var shape:uint = Room.SHAPE_STARBURST;
				for (var k:int = 0; k < weights.length; k++)
				{
					if (rand < weights[k])
					{
						shape = k;
					}
					rand -= weights[k];
				}
				
				// Offset the rooms slightly.
				rooms.push(new Room(
					new Point(
						(i + 0.5) * MAP_WIDTH / room_spread + Math.random() * 8 - 4,
						(j + 0.5) * MAP_HEIGHT / room_spread + Math.random() * 8 - 4),
					shape, Room.ROLE_NORMAL));
			}
			rooms[0].role = Room.ROLE_START;
			_start = rooms[0].center;
			
			// Apply rooms to tilemap.
			for each (var room:Room in rooms)
				room.apply(tilemap);
			
			/* Generate tunnels.
			var unvisited:Array = room_centers.slice(0, rooms + 1);
			var index_start:uint = 0;
			while (unvisited.length > 1)
			{
				var start:Point = unvisited[index_start];
				var end:Point;
				var nearest:Number = Number.MAX_VALUE;
				for each (center in unvisited)
				{
					if (center == start)
						continue;
					
					var dist:Number = Point.distance(center, start);
					if (dist <= nearest)
					{
						end = center;
						nearest = dist;
					}
				}
				level.line(start.x, start.y, end.x, start.y, 1);
				level.line(end.x, start.y, end.x, end.y, 1);
				
				unvisited.splice(index_start, 1);
				index_start = unvisited.indexOf(end);
			}*/
		}
	}
}
