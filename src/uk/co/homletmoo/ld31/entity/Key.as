package uk.co.homletmoo.ld31.entity 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import uk.co.homletmoo.ld31.assets.Images;
	import uk.co.homletmoo.ld31.Layers;
	import uk.co.homletmoo.ld31.Main;
	import uk.co.homletmoo.ld31.Types;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class Key extends Entity
	{
		private var image:Image;
		
		public function Key(start:Point) 
		{
			super(start.x, start.y);
			setHitbox(20, 16);
			
			// Initialise variables.
			image = new Image(Images.KEY);
			image.scale = Main.SCALE;
			graphic = image;
			
			type = Types.KEY;
			layer = Layers.OBJECTS;
		}
	}
}
