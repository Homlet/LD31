package uk.co.homletmoo.ld31
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Key;
	import uk.co.homletmoo.ld31.world.SplashWorld;
	
	[SWF (width = "800", height = "600", backgroundColor = "#523e29")]
	
	/**
	 * Main engine class.
	 * 
	 * @author Homletmoo
	 */
	public class Main extends Engine 
	{
		public static var instance:Main;
		
		public static const WIDTH:uint = 800;
		public static const HEIGHT:uint = 600;
		
		public function Main()
		{
			super(WIDTH, HEIGHT, 60);
			
			instance = this;
			
			FP.console.enable();
			FP.console.toggleKey = Key.TAB;
		}
		
		override public function init():void
		{
			Controls.register();
			FP.world = new SplashWorld();
		}
	}
}
