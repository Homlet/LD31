package uk.co.homletmoo.ld31.entity 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Mask;
	import net.flashpunk.utils.Input;
	import uk.co.homletmoo.ld31.assets.Images;
	import uk.co.homletmoo.ld31.Controls;
	import uk.co.homletmoo.ld31.Layers;
	import uk.co.homletmoo.ld31.Main;
	import uk.co.homletmoo.ld31.Types;
	import uk.co.homletmoo.ld31.Utils;
	import uk.co.homletmoo.ld31.world.EndWorld;
	import uk.co.homletmoo.ld31.world.GameWorld;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class Player extends Entity implements Living
	{
		public static const SPEED:Number = 55;
		public static const GRACE:Number = 1.5;
		
		private var image:Spritemap;
		
		private var _health:uint;
		private var grace:Number;
		private var _strength:uint;
		
		private var _keys:uint;
		
		public function Player(start:Point) 
		{
			super(start.x, start.y);
			setHitbox(12, 8, 6, 0);
			
			// Initialise variables.
			image = new Spritemap(Images.PLAYER, 10, 8);
			image.add("left", [0, 1, 2, 3], 7);
			image.add("right", [4, 5, 6, 7], 7);
			image.add("backward", [8, 9, 10, 11], 7);
			image.add("forward", [12, 13, 14, 15], 7);
			image.add("still", [8]);
			image.play("still");
			image.centerOrigin()
			image.scale = Main.SCALE;
			graphic = image;
			
			_health = 10;
			grace = GRACE;
			_strength = 4;
			
			_keys = 0;
			
			type = Types.PLAYER;
			layer = Layers.PLAYER;
		}
		
		override public function update():void
		{
			if (health <= 0)
			{
				// Deaded.
				FP.world = new EndWorld(EndWorld.FAILURE);
			}
			
			// We've just been hit, make sure that doesn't happen again.
			if (grace > 0)
			{
				image.alpha = 0.5;
				grace -= FP.elapsed;
			} else
			{
				image.alpha = 1;
			}
			
			var velocity:Point = new Point(0, 0);
			if (Input.check(Controls.UP)) { velocity.y -= 1 }
			if (Input.check(Controls.LEFT)) { velocity.x -= 1 }
			if (Input.check(Controls.DOWN)) { velocity.y += 1 }
			if (Input.check(Controls.RIGHT)) { velocity.x += 1 }
			
			if (velocity.length > 0)
			{
				velocity.normalize(SPEED * FP.elapsed);
				moveBy(velocity.x, velocity.y, [Types.LEVEL, Types.KEY]);
				
				// Play correct animation using trig voodoo magic.
				var anim:Array = ["forward", "right", "backward", "left"];
				image.play(anim[Math.floor((Math.atan2(-velocity.x, velocity.y) + Math.PI) / Math.PI * 2)]);
			} else
			{
				// He's standing still, duh...
				image.play("still");
			}
		}
		
		override public function moveCollideX(e:Entity):Boolean
		{
			if (e.type == Types.KEY && e.active)
			{
				_keys++;
				e.active = false;
				FP.world.remove(e);
				return false;
			}
			return true;
		}
		
		override public function moveCollideY(e:Entity):Boolean
		{
			return moveCollideX(e);
		}
		
		public function get health():uint { return _health; }
		public function get health_bar():String
		{
			var out:String = "";
			for (var i:int = 0; i < health; i++)
			{
				out += "~";
			}
			return out;
		}
		
		public function get armor():uint { return 2; }
		public function get strength():uint { return _strength; }
		
		public function get keys():uint { return _keys; }
		public function get keys_bar():String
		{
			var out:String = "";
			for (var i:int = 0; i < keys; i++)
			{
				out += "+";
			}
			return out;
		}
		
		public function hurt(enemy_strength:uint, source:Point):void
		{
			moveTowards(source.x, source.y, -FP.elapsed * 160, [Types.LEVEL]);
			// Make sure you're not see-though.
			if (grace > 0) { return; }
			
			// Ouch!
			_health -= Math.max(0, enemy_strength - armor);
			grace = GRACE;
		}
	}
}
