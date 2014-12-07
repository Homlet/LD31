package uk.co.homletmoo.ld31.world 
{
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.World;
	import uk.co.homletmoo.ld31.assets.Images;
	import uk.co.homletmoo.ld31.assets.Music;
	import uk.co.homletmoo.ld31.entity.Fog;
	import uk.co.homletmoo.ld31.entity.Key;
	import uk.co.homletmoo.ld31.entity.Level;
	import uk.co.homletmoo.ld31.entity.Player;
	import uk.co.homletmoo.ld31.Layers;
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
		public var fog:Fog;
		
		public function GameWorld()
		{
		}
		
		override public function begin():void
		{
			level = new Level(14);
			player = new Player(level.start);
			level.player = player;
			
			// Initialise variables.
			room_text = new Text(level.get_room_text(player.x, player.y),
				5, 5, { size: 8 } );
			room_text.scale = Main.SCALE;
			fog = new Fog();
			
			// Add entities to the update list.
			add(level);
			add(player);
			addGraphic(room_text, Layers.HUD);
			add(fog);
			
			// Play music.
			Music.playJazz();
		}
		
		override public function update():void
		{
			super.update();
			
			room_text.text = level.get_room_text(
				player.x / Level.TILE_SIZE, player.y / Level.TILE_SIZE);
			
			fog.uncover(new Point(player.x, player.y));
		}
	}
}
