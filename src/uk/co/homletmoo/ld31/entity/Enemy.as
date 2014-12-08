package uk.co.homletmoo.ld31.entity 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import uk.co.homletmoo.ld31.assets.Images;
	import uk.co.homletmoo.ld31.Layers;
	import uk.co.homletmoo.ld31.Main;
	import uk.co.homletmoo.ld31.Types;
	import uk.co.homletmoo.ld31.Utils;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class Enemy extends Entity implements Living
	{
		public var speed:Number = 32;
		
		private var image:Spritemap;
		
		private var player:Player;
		
		private var _health:uint;
		private var _armor:uint;
		private var _strength:uint;
		
		public function Enemy(start:Point, player:Player) 
		{
			super(start.x, start.y);
			setHitbox(12, 8, 6, 0);
			
			// Initialise variables.
			image = new Spritemap(Images.ENEMY, 10, 8);
			image.add("left", [0, 1, 2, 3], 7);
			image.add("right", [4, 5, 6, 7], 7);
			image.add("backward", [8, 9, 10, 11], 7);
			image.add("forward", [12, 13, 14, 15], 7);
			image.add("still", [8]);
			image.play("still");
			image.centerOrigin()
			image.scale = Main.SCALE;
			graphic = image;
			
			this.player = player;
			
			_health = 10;
			_armor = 2;
			_strength = 3;
			
			type = Types.ENEMY;
			layer = Layers.CREATURES;
		}
		
		override public function update():void
		{
			var heading:Point;
			if (Utils.hypot(player.x - x, player.y - y) < 8 * Level.TILE_SIZE)
			{
				moveTowards(player.x, player.y, speed * FP.elapsed,
					[Types.LEVEL, Types.PLAYER, Types.ENEMY]);
				
				heading = new Point(player.x - x, player.y - y);
			} else
			{
				heading = new Point(Math.random() * 2 - 1, Math.random() * 2 - 1);
				moveBy(heading.x, heading.y, [Types.LEVEL, Types.PLAYER, Types.ENEMY]);
			}
			
			// Play correct animation using trig voodoo magic.
			var anim:Array = ["forward", "right", "backward", "left"];
			image.play(anim[Math.floor((Math.atan2(-heading.x, heading.y) + Math.PI) / Math.PI * 2)]);
		}
		
		override public function moveCollideX(e:Entity):Boolean
		{
			if (e.type == Types.PLAYER)
			{
				moveTowards(player.x, player.y, -speed * 5 * FP.elapsed, [Types.LEVEL]);
				player.hurt(_strength, new Point(x, y));
			}
			
			if (e.type == Types.ENEMY)
			{
				moveTowards(e.x, e.y, -speed * FP.elapsed,
					[Types.LEVEL, Types.PLAYER]);
			}
			
			return true;
		}
		
		override public function moveCollideY(e:Entity):Boolean
		{
			return moveCollideX(e);
		}
		
		public function get health():uint { return _health; }
		public function get armor():uint { return _armor; }
		public function get strength():uint { return _strength; }
		
		public function hurt(enemy_strength:uint, source:Point):void
		{
			moveTowards(source.x, source.y, -FP.elapsed * 160, [Types.LEVEL]);
			_health -= Math.max(0, enemy_strength - armor);
		}
	}
}
