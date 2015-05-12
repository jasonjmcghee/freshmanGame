package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author blackstorm
	 */
	public class Hero extends FlxSprite
	{	
		public function Hero(_x:int, _y:int):void 
		{
			super(_x, _y);
			makeGraphic(8,8, 0xffffffff);
		}
		override public function update():void
		{
			super.update();
		}
	}

}