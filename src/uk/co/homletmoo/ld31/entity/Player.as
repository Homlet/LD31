package uk.co.homletmoo.ld31.entity 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Mask;
	import net.flashpunk.utils.Input;
	import uk.co.homletmoo.ld31.Controls;
	import uk.co.homletmoo.ld31.Types;
	import uk.co.homletmoo.ld31.Utils;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class Player extends Entity 
	{
		public static const SPEED:Number = 100;
		
		public function Player(start:Point, graphic:Graphic=null) 
		{
			super(start.x, start.y, Image.createRect(8, 8, 0xFF0000));
			setHitbox(8, 8);
			
			type = Types.PLAYER;
		}
		
		override public function update():void
		{
			var velocity:Point = new Point(0, 0);
			if (Input.check(Controls.UP)) { velocity.y -= 1 }
			if (Input.check(Controls.LEFT)) { velocity.x -= 1 }
			if (Input.check(Controls.DOWN)) { velocity.y += 1 }
			if (Input.check(Controls.RIGHT)) { velocity.x += 1 }
			velocity.normalize(SPEED * FP.elapsed);
			
			moveBy(velocity.x, velocity.y, Types.LEVEL);
		}
	}
}
