package  
{
	/**
	 * ...
	 * @author blackstorm
	 */
	 import org.flixel.*;
	
     public class Backdrop extends FlxSprite
     {
		[Embed(source = "C:/Users/Jason/Documents/FlashGames/RPG/lib/Backdrop.png")]
		private var ImgBackdrop:Class;
        public function Backdrop(x:Number, y:Number)
        {
               super(x, y);
               loadGraphic(ImgBackdrop, false);					//False parameteer means this is not a sprite sheet
               //scrollFactor.x = scrollFactor.y = BackdropScroll;
               solid = false;  //Just to make sure no collisions with the backdrop ever take place
        }
     }
}