package 
{
	/**
	 * 
	 * @author blackstorm
	 */
	import org.flixel.*;
	
	[SWF(width = "640", height = "480", title = "Hello", backgroundColor = "#646060")]
	
	public class Main extends FlxGame 
	{
		public function Main():void 
		{
			super(640, 480, PlayState, 1);
		}
		
	}
	
}