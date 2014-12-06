package uk.co.homletmoo.ld31.world 
{
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import uk.co.homletmoo.ld31.entity.Level;
	import uk.co.homletmoo.ld31.entity.Player;
	import uk.co.homletmoo.ld31.Utils;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class GameWorld extends World
	{
		public var level:Level;
		public var player:Player;
		
		public function GameWorld() 
		{
			// Initialise variables.
			level = new Level();
			player = new Player(level.start);
		}
		
		override public function begin():void
		{
			// Add entities to the update list.
			add(level);
			add(player);
		}
		
		override public function update():void
		{
			super.update();
		}
	}
}
