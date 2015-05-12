package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author blackstorm
	 */
	public class Projectile extends FlxSprite
	{
		[Embed(source = "C:/Users/Jason/Documents/FlashGames/RPG/lib/bullet.png")]
		private var ImgLazer:Class;
		
		public function Projectile(_x:int, _y:int) 
		{
			super(_x, _y);
			//makeGraphic(6, 6, 0xFF597137);
			loadGraphic(ImgLazer, false, false, 12, 12); 
		}
		
		override public function update():void
		{
			super.update();
		}
		
	}

}