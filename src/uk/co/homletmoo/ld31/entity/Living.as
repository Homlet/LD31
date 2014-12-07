package uk.co.homletmoo.ld31.entity 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Homletmoo
	 */
	public interface Living 
	{
		function get health():uint;
		function get armor():uint;
		function get strength():uint;
		function hurt(enemy_strength:uint, source:Point):void;
	}	
}
