package uk.co.homletmoo.ld31
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Key;
	import uk.co.homletmoo.ld31.assets.Music;
	import uk.co.homletmoo.ld31.world.GameWorld;
	import uk.co.homletmoo.ld31.world.IntroWorld;
	import uk.co.homletmoo.ld31.world.SplashWorld;
	
	[SWF (width = "960", height = "720", backgroundColor = "#000000")]
	
	/**
	 * Main engine class.
	 * 
	 * @author Homletmoo
	 */
	public class Main extends Engine 
	{
		public static var instance:Main;
		
		public static const WIDTH:uint = 960;
		public static const HEIGHT:uint = 720;
		public static const SCALE:uint = 2;
		
		public function Main()
		{
			super(WIDTH, HEIGHT, 60);
			
			instance = this;
			
			Music.initialize();
			
			//FP.console.enable();
			FP.console.toggleKey = Key.TAB;
		}
		
		override public function init():void
		{
			Controls.register();
			FP.world = new SplashWorld();
		}
	}
}
