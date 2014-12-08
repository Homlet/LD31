package uk.co.homletmoo.ld31.assets 
{
	import net.flashpunk.Sfx;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class Music 
	{
		[Embed (source = "music/jazz_intro.mp3")]
		private static const JAZZ_INTRO_RAW:Class;
		private static var JAZZ_INTRO:Sfx;
		
		[Embed (source = "music/jazz_loop.mp3")]
		private static const JAZZ_LOOP_RAW:Class;
		private static var JAZZ_LOOP:Sfx;
		
		[Embed (source = "music/jazz_end.mp3")]
		private static const JAZZ_END_RAW:Class;
		private static var JAZZ_END:Sfx;
		
		public static function initialize():void
		{			
			JAZZ_INTRO = new Sfx(JAZZ_INTRO_RAW, loopJazz);
			JAZZ_LOOP  = new Sfx(JAZZ_LOOP_RAW);
			JAZZ_END   = new Sfx(JAZZ_END_RAW);
		}
		
		public static function playJazz():void
		{
			JAZZ_INTRO.play(0.6);
		}
		
		private static function loopJazz():void
		{
			JAZZ_LOOP.loop(0.6);
		}
		
		public static function stopJazz():void
		{
			JAZZ_INTRO.stop();
			JAZZ_LOOP.stop();
			JAZZ_END.play(0.6);
		}
	}
}
