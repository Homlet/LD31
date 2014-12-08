package uk.co.homletmoo.ld31.world 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import uk.co.homletmoo.ld31.assets.Images;
	import uk.co.homletmoo.ld31.Main;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class IntroWorld extends World
	{
		public var image:Image;
		public var current:uint;
		
		public function IntroWorld()
		{
			current = 0;
		}
		
		override public function begin():void
		{
			image = new Image(Images.SLIDES[current]);
			image.scale = Main.SCALE;
			addGraphic(image);
		}
		
		override public function update():void
		{
			if (Input.pressed(Key.ANY))
			{
				try {
					image = new Image(Images.SLIDES[++current]);
					image.scale = Main.SCALE;
					addGraphic(image);
				} catch (e:Error)
				{
					FP.world = new GameWorld();
				}
			}
		}
	}
}
