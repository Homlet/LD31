package uk.co.homletmoo.ld31.entity 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import uk.co.homletmoo.ld31.Types;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class Enemy extends Entity implements Living
	{
		public final var speed:Number = 80;
		
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
		}
		
		override public function update():void
		{
			moveTowards(player.x, player.y, speed * FP.elapsed,
				[Types.LEVEL, Types.PLAYER]);
		}
		
		override public function moveCollideX(e:Entity):Boolean
		{
			if (e.type = Types.PLAYER)
			{
				player.hurt(_strength);
			}
			
			return true;
		}
		
		public function get health():uint { return _health; }
		public function get armor():uint { return _armor; }
		public function get strength():uint { return _strength; }
		
		public function hurt(enemy_strength:uint):void
		{
			_health -= Math.max(0, enemy_strength - armor);
		}
	}
}
