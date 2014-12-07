package uk.co.homletmoo.ld31.world.gen 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.graphics.Tilemap;
	import uk.co.homletmoo.ld31.assets.Namer;
	import uk.co.homletmoo.ld31.entity.Level;
	import uk.co.homletmoo.ld31.Utils;
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class Room 
	{
		public static const SHAPE_STARBURST:uint = 0;
		public static const SHAPE_RECTANGLE:uint = 1;
		public static const SHAPE_CROSS:uint = 2;
		
		public static const ROLE_NORMAL:uint = 0;
		public static const ROLE_START:uint = 1;
		public static const ROLE_EXIT:uint = 2;
		public static const ROLE_LOOT:uint = 3;
		
		public static var namer:Namer = new Namer(Namer.GRAMMAR_ROOM);
		
		public var center:Point;
		public var shape:uint;
		public var role:uint;
		
		public var name:String;
		
		public var width:uint;
		public var height:uint;
		
		public function Room(center:Point, shape:uint, role:uint=ROLE_NORMAL)
		{
			this.center = center;
			this.shape = shape;
			this.role = role;
			
			name = namer.create;
			
			width = 3 + Math.random() * 8;
			height = 3 + Math.random() * 8;
		}
		
		public function apply(level:Tilemap):void
		{
			switch(shape)
			{
			case SHAPE_STARBURST:
				starburst(level, Math.min(width, height) / 2);
				break;
			
			case SHAPE_RECTANGLE:
				rectangle(level);
				break;
			
			case SHAPE_CROSS:
				cross(level);
				break;
			}
		}
		
		/**
		 * Return the index of the default ground tile for this room.
		 */
		public function get ground():uint
		{
			switch (shape)
			{
			case SHAPE_STARBURST: return 9;
			case SHAPE_RECTANGLE: return 1;
			case SHAPE_CROSS: return 10;
			default: return 1;
			}
		}
		
		/**
		 * Return the index of the default wall tile for this room.
		 */
		public function get wall():uint
		{
			switch (shape)
			{
			case SHAPE_STARBURST: return 9;
			case SHAPE_RECTANGLE: return 0;
			case SHAPE_CROSS: return 10;
			default: return 0;
			}
		}
		
		/**
		 * Return the room dimensions as a Rectangle object.
		 */
		public function get rect():Rectangle
		{
			return new Rectangle(center.x - width / 2, center.y - height / 2, width, height);
		}
		
		/**
		 * Create a room in a given tilemap by projecting rays from a point.
		 * @param	level   The tilemap to add the room to.
		 * @param	center  Point from which to project rays.
		 * @param	size    Max length of rays.
		 * @param	detail  Number of rays.
		 */
		private function starburst(level:Tilemap, size:Number = 7.0,
			detail:uint=30, smooth:Boolean=true):void
		{			
			function visit(i:int, j:int):void
			{
				if (0 <= i && i < Level.MAP_WIDTH
				 && 0 <= j && j < Level.MAP_HEIGHT)
					level.setTile(i, j, wall);
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
				level.floodFill(center.x, center.y, ground);
			}
		}
		
		private function rectangle(level:Tilemap):void
		{
			level.setRect(
				center.x - width / 2 - 1, center.y - height / 2 - 1,
				width + 2, height + 2, wall);
			level.setRect(
				center.x - width / 2, center.y - height / 2,
				width, height, ground);
		}
		
		private function cross(level:Tilemap, dip:uint = 3):void
		{
			level.setRect(
				center.x - width / 2, center.y - (height - dip) / 2,
				width, height - dip, ground);
			level.setRect(
				center.x - (width - dip) / 2, center.y - height / 2,
				width - dip, height, ground);
		}
	}
}
