package uk.co.homletmoo.ld31.entity 
{
	import flash.geom.Point;
	import net.flashpunk.Graphic;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class Enemy extends Player 
	{
		public function Enemy(start:Point, graphic:Graphic=null) 
		{
			super(start, graphic);
			
		}
	}
}
