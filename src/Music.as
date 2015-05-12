package  
{
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author blackstorm
	 */
	public class Music extends FlxSprite 
	{
		[Embed(source = "C:/Users/Jason/Documents/FlashGames/RPG/lib/gameTrack.mp3")]
		private var Mp3gameTrack:Class;
		
		public function Music() 
		{
			super
			loadEmbedded()
		}
		
	}

}