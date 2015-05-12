package
{
	import org.flixel.*;
	/**
	 * ...
	 * @author blackstorm
	 */
	public class Particle extends FlxParticle
	{	
		public function Particle():void 
		{
			makeGraphic(2, 2, 0xFF597137);
		}
		override public function update():void
		{
			super.update();
		}
	}

}