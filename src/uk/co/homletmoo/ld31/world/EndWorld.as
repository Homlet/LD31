package uk.co.homletmoo.ld31.world 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import uk.co.homletmoo.ld31.assets.Images;
	import uk.co.homletmoo.ld31.assets.Music;
	import uk.co.homletmoo.ld31.Main;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class EndWorld extends World
	{
		public static const SUCCESS:uint = 0;
		public static const FAILURE:uint = 1;
		
		public static const GRACE:Number = 1;
		
		public var state:uint;
		public var timer:Number;
		
		public function EndWorld(state:uint)
		{
			this.state = state;
			timer = GRACE;
		}
		
		override public function begin():void
		{
			switch(state)
			{
			case SUCCESS:
				addGraphic(new Image(Images.scale(Images.ESCAPE, Main.SCALE)));
				break;
				
			case FAILURE:
				addGraphic(new Image(Images.scale(Images.KILLED, Main.SCALE)));
				break;
			}
			
			Music.stopJazz();
		}
		
		override public function update():void
		{
			timer -= FP.elapsed;
			if (Input.check(Key.ANY) && timer <= 0)
			{
				FP.world = new GameWorld();
			}
		}
	}
}
