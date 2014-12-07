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
	import uk.co.homletmoo.ld31.world.gen.Tunnel;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class Level extends Entity 
	{
		public static const TILE_SIZE:uint = 8 * Main.SCALE;
		public static const MAP_WIDTH:uint = uint(Main.WIDTH / TILE_SIZE);
		public static const MAP_HEIGHT:uint = uint(Main.HEIGHT / TILE_SIZE);
		
		private var _start:Point;
		private var room_count:uint;
		
		private var rooms:Vector.<Room>;
		private var tunnels:Vector.<Tunnel>;
		
		public var tilemap:Tilemap;
		private var grid:Grid;
		
		public function Level(room_count:uint=14)
		{
			super();
			
			// Initialise variables.
			_start = new Point(0, 0);
			this.room_count = room_count;
			
			rooms = new Vector.<Room>();
			tunnels = new Vector.<Tunnel>();
			
			tilemap = new Tilemap(Images.scale(Images.TILES, Main.SCALE),
				Main.WIDTH, Main.HEIGHT, TILE_SIZE, TILE_SIZE);
			tilemap.floodFill(0, 0, 8);
			
			graphic = tilemap;
			type = Types.LEVEL;
			
			// Generate the dungeon!
			generate();
			
			// Sort out the collision grid.
			grid = tilemap.createGrid([0, 8]);
			mask = grid;
		}
		
		public function get start():Point
		{
			return new Point(_start.x * TILE_SIZE, _start.y * TILE_SIZE);
		}
		
		public function get_room_text(x:int, y:int):String
		{
			var location:Room = get_room(x, y);
			if (location != null)
				return get_room(x, y).name;
			else
				return "Tunnels.";
		}
		
		public function get_room(x:int, y:int):Room
		{			
			for each (var room:Room in rooms)
			{
				if (room.rect.contains(x, y))
					return room;
			}
			
			return null;
		}
		
		private function generate():void
		{
			// For-each variables, because AS3 scope sucks.
			var room:Room;
			var tunnel:Tunnel;
			
			// Create list of rooms.			
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
						(i + 0.5) * MAP_WIDTH / room_spread + Math.random() * 4 - 2,
						(j + 0.5) * MAP_HEIGHT / room_spread + Math.random() * 4 - 2),
					shape, Room.ROLE_NORMAL));
			}
			rooms[0].role = Room.ROLE_ENTRANCE;
			_start = rooms[0].center;
			
			// Generate tunnels.
			var unvisited:Vector.<Room> = rooms.slice();
			var visited:Vector.<Room> = rooms.slice(0, 0);
			while (visited.length < rooms.length - 1)
			{
				var start:Room = Utils.random(unvisited);
				var end:Room = Utils.random(unvisited);
				var nearest:Number = Number.MAX_VALUE;
				for each (room in visited)
				{
					if (room == start)
						continue;
					
					var dist:Number = Point.distance(
						room.center, start.center);
					if (dist <= nearest)
					{
						end = room;
						nearest = dist;
					}
				}
				tunnels.push(new Tunnel(start, end));
				
				if (unvisited.indexOf(start) != -1)
					unvisited.splice(unvisited.indexOf(start), 1);
				if (unvisited.indexOf(end) != -1)
					unvisited.splice(unvisited.indexOf(end), 1);
				if (visited.indexOf(start) == -1)
					visited.push(start);
				if (visited.indexOf(end) == -1)
					visited.push(end);
			}
			
			// First apply rooms to tilemap.
			for each (room in rooms)
				room.apply(this);
			
			// Then apply tunnels.
			for each(tunnel in tunnels)
				tunnel.apply(this);
		}
	}
}
