package  
{
	import org.flixel.*;
	import PlayState;
	/**
	 * ...
	 * @author blackstorm
	 */
	public class Enemy extends FlxSprite
	{	
		public function Enemy(x:int, y:int, color:uint, width:int, height:int):void 
		{
			super(x, y);
			makeGraphic(width, height, color);
		}
		override public function update():void
		{
			super.update();
		}
		
		public function chaseTarget(sprite1:FlxSprite):void
		{
			//MOVEMENT
			this.acceleration.x = 0;
			this.acceleration.y = 0;
			
			if(this.x > (sprite1.x + sprite1.width/2))
			{
				this.acceleration.x -= this.drag.x;
			}
			else if(this.x < (sprite1.x + sprite1.width/2))
			{
				this.acceleration.x += this.drag.x;
			}
			if(this.y < (sprite1.y + sprite1.height/2))
			{
				this.acceleration.y += this.drag.y;
			}
			else if(this.y > (sprite1.y + sprite1.height/2))
			{
				this.acceleration.y -= this.drag.y;
			}
		}
		
		private function smartChase():void 
		{
			
		}
	}

}