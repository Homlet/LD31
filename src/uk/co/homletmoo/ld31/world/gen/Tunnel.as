package uk.co.homletmoo.ld31.world.gen 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.graphics.Tilemap;
	import uk.co.homletmoo.ld31.Utils;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class Tunnel 
	{
		private var start:Room;
		private var end:Room;
		
		public function Tunnel(start:Room, end:Room)
		{
			this.start = start;
			this.end = end;
		}
		
		public function apply(level:Tilemap):void
		{
			function visit(x:int, y:int):void
			{
				var in_start:Boolean = start.rect.contains(x + 0.5, y + 0.5);
				var in_end:Boolean = end.rect.contains(x + 0.5, y + 0.5);
				if (in_start && !in_end)
					level.setTile(x, y, start.ground);
				else if (!in_start && in_end)
					level.setTile(x, y, end.ground);
				else if (!in_start && !in_end)
				{
					if (start.ground == end.ground)
						level.setTile(x, y, start.ground);
					else
						level.setTile(x, y, 9);
				}
			}
			
			var intermediate:Point = new Point(end.center.x, start.center.y);
			Utils.raytrace(start.center, intermediate, visit);
			Utils.raytrace(intermediate, end.center, visit);
		}
	}
}
