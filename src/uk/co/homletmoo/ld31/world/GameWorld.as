package uk.co.homletmoo.ld31.world 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.World;
	import uk.co.homletmoo.ld31.entity.Level;
	import uk.co.homletmoo.ld31.entity.Player;
	import uk.co.homletmoo.ld31.Main;
	import uk.co.homletmoo.ld31.Utils;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class GameWorld extends World
	{
		public var level:Level;
		public var player:Player;
		public var room_text:Text;
		
		public function GameWorld()
		{
			// Initialise variables.
			level = new Level();
			player = new Player(level.start);
			room_text = new Text(level.get_room_text(player.x, player.y),
				5, 5, { size: 8 } );
			room_text.scale = Main.SCALE;
		}
		
		override public function begin():void
		{
			// Add entities to the update list.
			add(level);
			add(player);
			addGraphic(room_text);
		}
		
		override public function update():void
		{
			super.update();
			
			room_text.text = level.get_room_text(
				player.x / Level.TILE_SIZE, player.y / Level.TILE_SIZE);
		}
	}
}
