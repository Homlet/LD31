package uk.co.homletmoo.ld31.world 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.World;
	import uk.co.homletmoo.ld31.assets.Images;
	import uk.co.homletmoo.ld31.Main;
	
	/**
	 * Displays the HM and FlashPunk logos in sequence, then changes the world.
	 * 
	 * @author Homletmoo
	 */
	public class SplashWorld extends World 
	{
		private var hm_logo:Image;
		private var fp_logo:Spritemap;
		
		private var tweens:Array;
		private var stage:uint;
		
		
		public function SplashWorld() 
		{
			hm_logo = new Image(Images.HM_LOGO);
			hm_logo.scale = Main.SCALE * 2;
			hm_logo.alpha = 0;
			hm_logo.centerOrigin();
			
			fp_logo = new Spritemap(Images.FP_LOGO, 100, 100);
			fp_logo.scale = Main.SCALE;
			fp_logo.alpha = 0;
			fp_logo.add("play", [0, 1, 2, 3], 8);
			
			tweens = [
				function():void { FP.tween(fp_logo, {alpha: 1}, 0.8, {complete: next, easing: Ease.expoIn}); },
				function():void { FP.tween(null, null, 0.8, {complete: next}); },
				function():void { FP.tween(fp_logo, {alpha: 0}, 0.5, {complete: next}); },
				
				function():void { FP.tween(hm_logo, {alpha: 1}, 0.8, {complete: next, easing: Ease.expoIn}); },
				function():void { FP.tween(null, null, 0.8, {complete: next}); },
				function():void { FP.tween(hm_logo, {alpha: 0}, 0.5, {complete: done}); }
			];
		}
		
		override public function begin():void
		{
			addGraphic(hm_logo, 0, Main.WIDTH / 2, Main.HEIGHT / 2);
			addGraphic(fp_logo, 0, 0, Main.HEIGHT - fp_logo.scaledHeight);
			
			fp_logo.play("play");
			
			tweens[0]();
		}
		
		private function next():void
		{
			tweens[++stage]();
		}
		
		private function done():void
		{
			// Set next world.
		}
	}
}
