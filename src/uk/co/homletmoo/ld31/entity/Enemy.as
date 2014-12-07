package uk.co.homletmoo.ld31.entity 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import uk.co.homletmoo.ld31.Layers;
	import uk.co.homletmoo.ld31.Types;
	import uk.co.homletmoo.ld31.Utils;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class Enemy extends Entity implements Living
	{
		public var speed:Number = 32;
		
		private var player:Player;
		
		private var _health:uint;
		private var _armor:uint;
		private var _strength:uint;
		
		public function Enemy(start:Point, player:Player) 
		{
			super(start.x, start.y, Image.createRect(8, 8, 0x00FF00));
			setHitbox(8, 8);
			
			// Initialise variables.
			this.player = player;
			
			_health = 10;
			_armor = 2;
			_strength = 4;
			
			type = Types.ENEMY;
			layer = Layers.CREATURES;
		}
		
		override public function update():void
		{
			if (Utils.hypot(player.x - x, player.y - y) < 8 * Level.TILE_SIZE)
			{
				moveTowards(player.x, player.y, speed * FP.elapsed,
					[Types.LEVEL, Types.PLAYER, Types.ENEMY]);
			} else
			{
			}
		}
		
		override public function moveCollideX(e:Entity):Boolean
		{
			if (e.type == Types.PLAYER)
			{
				player.hurt(_strength, new Point(x, y));
				moveTowards(player.x, player.y, -FP.elapsed * 160, [Types.LEVEL]);
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
			_health -= Math.max(0, enemy_strength - armor);
		}
	}
}
