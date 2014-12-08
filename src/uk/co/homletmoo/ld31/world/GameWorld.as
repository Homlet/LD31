package uk.co.homletmoo.ld31.world 
{
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.World;
	import uk.co.homletmoo.ld31.assets.Images;
	import uk.co.homletmoo.ld31.assets.Music;
	import uk.co.homletmoo.ld31.entity.Fog;
	import uk.co.homletmoo.ld31.entity.Key;
	import uk.co.homletmoo.ld31.entity.Level;
	import uk.co.homletmoo.ld31.entity.Player;
	import uk.co.homletmoo.ld31.entity.Stair;
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
		public var health_text:Text;
		public var keys_text:Text;
		public var fog:Fog;
		public var stair:Stair;
		
		public var title:Image;
		
		public function GameWorld() { }
		
		override public function begin():void
		{
			// Initialise variables.
			level = new Level(14);
			player = new Player(level.start);
			level.player = player;
			
			room_text = new Text(level.get_room_text(player.x, player.y),
				5, 5, { size: 8 } );
			room_text.scale = Main.SCALE;
			
			health_text = new Text(player.health_bar, 10, Main.HEIGHT - 35,
				{ size: 16, color: 0xFF0000 } );
			health_text.scale = Main.SCALE;
			
			keys_text = new Text(player.keys_bar, 10, Main.HEIGHT - 75,
				{ size: 16, color: 0xFFFF00 } );
			keys_text.scale = Main.SCALE;
			
			fog = new Fog();
			
			title = new Image(Images.TITLE);
			title.scale = Main.SCALE;
			
			// Add entities to the update list.
			add(level);
			add(player);
			addGraphic(room_text, Layers.HUD);
			addGraphic(health_text, Layers.HUD);
			addGraphic(keys_text, Layers.HUD);
			addGraphic(title, Layers.TITLE);
			add(fog);
			
			FP.tween(title, { alpha: 0 }, 2.5, { ease: Ease.expoIn } );
			
			// Play music.
			Music.playJazz();
		}
		
		override public function update():void
		{
			super.update();
			
			room_text.text = level.get_room_text(
				player.x / Level.TILE_SIZE, player.y / Level.TILE_SIZE);
			health_text.text = player.health_bar;
			keys_text.text = player.keys_bar;
			
			stair.set_keys(player.keys);
			
			if (player.keys == 2 && player.collideWith(stair, player.x, player.y))
			{
				FP.world = new EndWorld(EndWorld.SUCCESS);
			}
			
			fog.uncover(new Point(player.x, player.y));
		}
	}
}
