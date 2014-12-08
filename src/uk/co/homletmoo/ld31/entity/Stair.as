package uk.co.homletmoo.ld31.entity 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import uk.co.homletmoo.ld31.assets.Images;
	import uk.co.homletmoo.ld31.Layers;
	import uk.co.homletmoo.ld31.Main;
	import uk.co.homletmoo.ld31.Types;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class Stair extends Entity
	{
		private var image:Spritemap;
		
		public function Stair(start:Point) 
		{
			super(start.x, start.y - 4 * Main.SCALE);
			setHitbox(8 * Main.SCALE, 8 * Main.SCALE, 0, -4 * Main.SCALE);
			
			// Initialise variables.
			image = new Spritemap(Images.scale(Images.STAIR, Main.SCALE),
				8 * Main.SCALE, 12 * Main.SCALE);
			image.add("2", [0]);
			image.add("1", [1]);
			image.add("0", [2]);
			image.play("2");
			graphic = image;
			
			type = Types.STAIR;
			layer = Layers.OBJECTS;
		}
		
		public function set_keys(keys:uint):void
		{
			switch(keys)
			{
			case 0:
				image.play("2");
				break;
			case 1:
				image.play("1");
				break;
			case 2:
				image.play("0");
				break;
			}
		}
	}
}
