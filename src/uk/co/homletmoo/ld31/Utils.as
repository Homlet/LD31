package uk.co.homletmoo.ld31 
{
	import flash.geom.Point;
	
	/**
	 * Various utility functions.
	 * @author Homletmoo
	 */
	public class Utils 
	{
		public static function raytrace(start:Point, end:Point, visit:Function):void
		{
			var delta:Point = new Point(
				Math.abs(end.x - start.x),
				Math.abs(end.y - start.y));
			var increment:Point = new Point(
				(end.x > start.x) ? 1 : -1,
				(end.y > start.y) ? 1 : -1);
			
			var position:Point = start.clone();
			var steps:uint = 1 + delta.x + delta.y;
			var error:int = delta.x - delta.y;
			
			delta.x *= 2;
			delta.y *= 2;
			
			while (steps > 0)
			{
				visit(int(position.x), int(position.y));
				
				if (error > 0)
				{
					position.x += increment.x;
					error -= delta.y;
				} else
				{
					position.y += increment.y;
					error += delta.x;
				}
				
				steps--;
			}
		}
	}
}
