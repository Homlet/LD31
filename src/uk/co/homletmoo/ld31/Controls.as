package uk.co.homletmoo.ld31
{
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	/**
	 * Stores and registers controls with Flashpunk.
	 * @author Homletmoo
	 */
	public class Controls 
	{
		public static const UP:String = "up";
		public static const LEFT:String = "left";
		public static const DOWN:String = "down";
		public static const RIGHT:String = "right";
		
		public static function register():void
		{
			Input.define(UP, Key.UP, Key.W);
			Input.define(LEFT, Key.LEFT, Key.A);
			Input.define(DOWN, Key.DOWN, Key.S);
			Input.define(RIGHT, Key.RIGHT, Key.D);
		}
	}
}
