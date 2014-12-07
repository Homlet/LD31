package uk.co.homletmoo.ld31.world.gen 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import uk.co.homletmoo.ld31.entity.Level;
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
		
		public function apply(level:Level):void
		{
			function visit(x:int, y:int):void
			{
				var location:Room = level.get_room(x, y);
				if (location != null)
					level.tilemap.setTile(x, y, location.ground);
				else
					level.tilemap.setTile(x, y, 10);
			}
			
			var intermediate:Point = new Point(end.center.x, start.center.y);
			Utils.raytrace(start.center, intermediate, visit);
			Utils.raytrace(intermediate, end.center, visit);
		}
	}
}
