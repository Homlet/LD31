package uk.co.homletmoo.ld31.world 
{
	import net.flashpunk.World;
	import uk.co.homletmoo.ld31.entity.Level;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class GameWorld extends World
	{
		public var level:Level;
		
		public function GameWorld() 
		{
			// Initialise variables.
			level = new Level();
		}
		
		override public function begin():void
		{
			// Add entities to the update list.
			add(level);
		}
		
		override public function update():void
		{
			super.update()
		}
	}
}
