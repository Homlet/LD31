package uk.co.homletmoo.ld31.world.gen 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Tilemap;
	import uk.co.homletmoo.ld31.assets.Images;
	import uk.co.homletmoo.ld31.assets.Namer;
	import uk.co.homletmoo.ld31.entity.Level;
	import uk.co.homletmoo.ld31.Main;
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
		public static const ROLE_ENTRANCE:uint = 1;
		public static const ROLE_KEY:uint = 2;
		
		public static var namer:Namer = new Namer(Namer.GRAMMAR_ROOM);
		
		public var center:Point;
		public var shape:uint;
		public var role:uint;
		public var variation:uint;
		
		public var name:String;
		
		public var width:uint;
		public var height:uint;
		
		public function Room(center:Point, shape:uint, role:uint=ROLE_NORMAL)
		{
			this.center = center;
			this.shape = shape;
			this.role = role;
			
			name = namer.create;
			
			width = 5 + Math.floor(Math.random() * 6);
			height = 5 + Math.floor(Math.random() * 6);
			while (center.x - width / 2 - 1 < 1
			    || center.x + width / 2 > Level.MAP_WIDTH - 1) {width--}
			while (center.y - height / 2 - 1 < 1
			    || center.y + height / 2 > Level.MAP_HEIGHT - 1) {height--}
		}
		
		/**
		 * Return the index of the default ground tile for this room.
		 */
		public function get ground():uint
		{
			switch (shape)
			{
			case SHAPE_STARBURST: return 4 + Math.floor(Math.random() * 2);
			case SHAPE_RECTANGLE: return 1 + Math.floor(Math.random() * 3);
			case SHAPE_CROSS: return 9 + Math.floor(Math.random() * 2);
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
			case SHAPE_STARBURST: return 4;
			case SHAPE_RECTANGLE: return 0;
			case SHAPE_CROSS: return 9;
			default: return 0;
			}
		}
		
		/**
		 * Return the room dimensions as a Rectangle object.
		 */
		public function get rect():Rectangle
		{
			return new Rectangle(
				center.x - width / 2 - 1,
				center.y - height / 2 - 1,
				width + 0.5, height + 0.5);
		}
		
		public function apply(level:Level):void
		{
			switch(shape)
			{
			case SHAPE_STARBURST:
				starburst(level.tilemap, Math.min(width, height) / 2);
				break;
			
			case SHAPE_RECTANGLE:
				rectangle(level.tilemap);
				break;
			
			case SHAPE_CROSS:
				cross(level.tilemap);
				break;
			}
			
			if (role == ROLE_ENTRANCE)
			{
				var stairs:Image = new Image(Images.STAIR);
				stairs.scale = Main.SCALE;
				stairs.x = center.x * Level.TILE_SIZE - 4 * Main.SCALE;
				stairs.y = center.y * Level.TILE_SIZE - 8 * Main.SCALE;
				level.addGraphic(stairs);
			}
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
					Utils.raytrace(center, generate_endpoint(theta), visit, 3);
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
