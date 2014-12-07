package uk.co.homletmoo.ld31.entity 
{
	/**
	 * ...
	 * @author Homletmoo
	 */
	public interface Living 
	{
		function get health():uint;
		function get armor():uint;
		function get strength():uint;
		function hurt(enemy_strength:uint):void;
	}	
}
