package  
{
	import flash.geom.Point;
	import org.flixel.*;
	import Enemy;
	/**
	 * ...
	 * @author blackstorm
	 */
	public class PlayState extends FlxState
	{
		private var spawnTime:FlxTimer = new FlxTimer;
		private var enemyVersionNum:int = 0;
		private var enemyVersion:String = "0";
		
		public var hero:Hero;
		public var backdrop:Backdrop;
		
		private var _bullets: FlxGroup;
		private var enemies:FlxGroup;
		private var enemiesArray:Array = new Array;
		
		private var bulletVelocity : Point = new Point();
		
		private var _scoreText:FlxText = new FlxText(2, 0, 200, "Score: 0");
		private var _highScoreText:FlxText = new FlxText(530, 0, 200, "High Score: 0");
		private var _gameOverText:FlxText = new FlxText(260, 180, 200, "GAME OVER");
		private var _smallNote:FlxText = new FlxText(290, 220, 200, "Click to Restart");
		private var _bombs:FlxText = new FlxText(290, 0, 200, "Bombs: 0");
		private var highScore:int = 0;
		
		private var GameOver:Boolean = false;
		private var killedBefore:Boolean = false;
		
		private var time:int = 0;
		
		private var enemyNum:int;
		private var enemyBombNum:int;
		private var spawnSide:int = 0;
		private var spawnSide2:int = 0;
		
		private var gameOverDelay:int = 0;
		
		private var clickCount:int = 0;
		private var bombs:int = 0;
		
		private var bombScore:int = 0;
		private var subtractCount:int = 0;
		
		[Embed(source = "C:/Users/Jason/Documents/FlashGames/RPG/lib/gameTrack.mp3")] public var gameTrack:Class;
		[Embed(source = "C:/Users/Jason/Documents/FlashGames/RPG/lib/Laser.mp3")] public var laser:Class;
		[Embed(source = "C:/Users/Jason/Documents/FlashGames/RPG/lib/Grenade.mp3")] public var grenade:Class;
		
		
		public function PlayState() 
		{	
			backdrop = new Backdrop(0,0);
			add(backdrop);
			
			_scoreText.setFormat(null, 8, 0xffffffff);
			add(_scoreText);
			_highScoreText.setFormat(null, 8, 0xffffffff);
			add(_highScoreText);
			_bombs.setFormat(null, 8, 0xffffffff);
			add(_bombs);
			
			setupPlayer();
			
			_bullets = new FlxGroup();
			add(_bullets);
			
			enemies = new FlxGroup();
			add(enemies);
			
			FlxG.mouse.show();
		}
		override public function create():void
		{
			FlxG.playMusic(gameTrack, .2);
		}
		
		override public function update():void
		{
			super.update();
			updatePlayer();
			updateScore();
			
			//if (enemies.members.length > 0) moveAllEnemies();
			if(enemiesArray.length >0) moveAllEnemies();
			
			_scoreText.text = "Score: " + FlxG.score.toString();
			_highScoreText.text = "High Score: " + highScore.toString();
			_bombs.text = "Bombs: " + bombs.toString();
			
			iscollideBulletsEnemies();
			iscollideEnemiesHero();
			
			spawnSide = findSpawnSide();
			spawnSide2 = findSpawnSide();
			
			checkGameOver();
			if (!GameOver) timeToSpawn();
			if (GameOver) gameOverDelay++;
			
			if (bombScore >= 10000) {
				bombs += 1;
				bombScore -= 10000;
				subtractCount++;
			}
			
			bombScore = ((FlxG.score + 10000)-((10000)*(subtractCount-1)));
		}
		
		private function setupPlayer():void
		{
			hero = new Hero (320, 240);

			//bounding box tweaks
			hero.width = 8;
			hero.height = 8;
			hero.offset.x = 1;
			hero.offset.y = 1;

			//basic hero physics
			hero.drag.x = 2000;
			hero.drag.y = 2000;
			hero.maxVelocity.x = 200;
			hero.maxVelocity.y = 200;

			add(hero);
		}
		
		private function updatePlayer():void
		{
			wrap(hero);

			//MOVEMENT
			hero.acceleration.x = 0;
			hero.acceleration.y = 0;
			if(FlxG.keys.A)
			{
				hero.acceleration.x -= hero.drag.x;
			}
			else if(FlxG.keys.D)
			{
				hero.acceleration.x += hero.drag.x;
			}
			if(FlxG.keys.W)
			{
				hero.acceleration.y -= hero.drag.y;
			}
			else if(FlxG.keys.S)
			{
				hero.acceleration.y += hero.drag.y;
			}
			//FIRE!
			if (FlxG.mouse.pressed() && !GameOver){ 
				if (clickCount % 8 == 0) {
					spawnBullet(hero.x /*+ (hero.width/2)*/, hero.y /*+(hero.height/2)*/ );
				}
				clickCount++;
			}
			
			if (FlxG.keys.justPressed("SHIFT") && !GameOver && bombs > 0) {
				killAllEnemies();
				bombs--;
			}
		}
		
		private function moveAllEnemies():Boolean
		{
			enemyNum = 0;
			while (enemyNum < enemiesArray.length)
			{
				enemiesArray[enemyNum].chaseTarget(hero);
				enemyNum += 1;
			}
			return true
		}
		
		private function spawnBullet(x:int, y:int):void
		{
			var bullet: Projectile = new Projectile(x, y);
			_bullets.add(bullet);
			bulletVelocity.x = (FlxG.mouse.x - hero.x);
			bulletVelocity.y = (FlxG.mouse.y - hero.y);
			bulletVelocity.normalize(400);
			bullet.velocity.x = bulletVelocity.x;
			bullet.velocity.y = bulletVelocity.y;
		}
		
		private function spawnEnemies(x:int, y:int):void
		{
			//var enemy:String = "enemy" + enemyVersion; 
			//enemy = 
			var enemy:Enemy = new Enemy(x, y, 0xffff0000, 16, 16);
			
			//bounding box tweaks
			enemy.width = 16;
			enemy.height = 16;
			enemy.offset.x = 1;
			enemy.offset.y = 1;

			//basic enemy physics
			enemy.drag.x = randNum(700,900);
			enemy.drag.y = randNum(700,900);
			enemy.maxVelocity.x = randNum(250,500);
			enemy.maxVelocity.y = randNum(250,500);
			enemiesArray.push(enemy);
			add(enemy);
		}
		
		private function spawnEnemies2(x:int, y:int):void
		{
			//var enemy:String = "enemy" + enemyVersion; 
			//enemy = 
			var enemy2:Enemy = new Enemy(x, y, 0xff00ff00, 8, 8);
			
			//bounding box tweaks
			enemy2.width = 8;
			enemy2.height = 8;
			enemy2.offset.x = 1;
			enemy2.offset.y = 1;

			enemy2.drag.x = randNum(1800,1900);
			enemy2.drag.y = randNum(1800,1900);
			enemy2.maxVelocity.x = randNum(500, 700);
			enemy2.maxVelocity.y = randNum(500, 700);
			enemiesArray.push(enemy2);
			add(enemy2);
		}
		
		public function randNum(min:int, max:int):int {
			return Math.floor(min + (Math.random()*(max - min + 1)));
		}
		
		public function updateScore():void 
		{
			if (!GameOver) FlxG.score++;
			if (FlxG.score >= highScore) highScore = FlxG.score;
		}
		
		public function gameLoss():void
		{
			GameOver = true;
			time = 0;
			bombs = 0;
			bombScore = 0;
		}
		
		public function iscollideBulletsEnemies():void
		{
			var i:int;
			while(i <enemiesArray.length){
				if (FlxG.collide(_bullets, enemiesArray[i], overlapBulletEnemy)) FlxG.score += 1000;
				i++;
			}
		}
		public function iscollideEnemiesHero():void
		{
			var i:int;
			while(i<enemiesArray.length){
				if (FlxG.collide(enemiesArray[i], hero, overlapEnemyHero)) gameLoss();
				i++;
			}
		}
		
		private function overlapEnemyHero(enemy:Enemy, hero:Hero):void
		{
			FlxG.shake(.05, .5, null, true, 0);
			FlxG.play(grenade, .3);
			enemy.kill();
			//enemies.members.length -= 1;
			var emitter:FlxEmitter = createEmitter();
			emitter.at(hero);
			hero.kill();
		}
		
		private function overlapBulletEnemy(bullet:Projectile, enemy:Enemy):void
		{
			FlxG.play(laser, .3);
			enemy.kill();
			var emitter:FlxEmitter = createEmitter();
			emitter.at(enemy);
			//enemies.members.length -= 1;
			bullet.kill();
		}
		
		private function wrap(obj:FlxObject):void
		{
			obj.x = (obj.x + obj.width / 2 + FlxG.width) % FlxG.width - obj.width / 2;
			obj.y = (obj.y + obj.height / 2 + FlxG.height) % FlxG.height - obj.height / 2;
		}
		
		private function colliding(object1:FlxSprite, object2:FlxSprite):Boolean
		{
			if ((object1.x + object1.width > object2.x) && (object1.x < object2.x + object2.width) && (object1.y + object1.height > object2.y) && (object1.y < object2.y + object2.height))
				return true;
			return false;
		}
		
		private function findSpawnSide():int
		{
			return randNum(0, 3);
		}
		
		public function getHeroXpos():int
		{
			return hero.x;
		}
		
		public function getHeroYpos():int
		{
			return hero.y;
		}
	
		public function checkGameOver():void
		{		
			if (GameOver) { 
				if(!killedBefore){
					_gameOverText.setFormat(null, 20, 0xffffffff);
					add(_gameOverText);
					_smallNote.setFormat(null, 8, 0xffffffff);
					add(_smallNote);
					killedBefore = true;
				}
				else { 
					_gameOverText.revive(); 
					_smallNote.revive();
				}
				
				if (FlxG.mouse.justPressed() && gameOverDelay >= 100) {
					GameOver = false;
					FlxG.score = 0;
					_gameOverText.kill();
					_smallNote.kill();
					enemiesArray.length = 0;
					hero.revive();
					gameOverDelay = 0;
				}
			}
		}
	
		public function timeToSpawn():void //use system time...
		{
			var spawnRate:int = 200;
			var spawnRate2:int = 800;
			
			if (time % 1000) spawnRate/=2;
			
			if (time % spawnRate == 0)
				if (spawnSide == 0) spawnEnemies(randNum(10, 630), 10);
				else if (spawnSide == 1) spawnEnemies(630, randNum(10, 470));
				else if (spawnSide == 2) spawnEnemies(randNum(10, 630), 470);
				else spawnEnemies(0, randNum(10, 470));
				
			if (time % 1000) spawnRate2/=2;
			
			if (time % spawnRate2 == 0  && time != 0)
				if (spawnSide == 0) spawnEnemies2(randNum(10, 630), 10);
				else if (spawnSide == 1) spawnEnemies2(630, randNum(10, 470));
				else if (spawnSide == 2) spawnEnemies2(randNum(10, 630), 470);
				else spawnEnemies2(0, randNum(10, 470));
			
			time++;
		}
		
		private function createEmitter(bx:Number = 0, by:Number = 0, s:Number = 100):FlxEmitter 
		{	
			var emitter:FlxEmitter = new FlxEmitter(bx, by, s);
			emitter.gravity = 0;
			emitter.maxRotation = 0;
			emitter.setXSpeed(-500, 500);
			emitter.setYSpeed(-500, 500);
			var particles: int = 5;
			for(var i: int = 0; i < particles; i++)
			{
				var particle:Particle = new Particle();
				particle.makeGraphic(2, 2, 0xFF597137);
				particle.exists = false;
				particle.lifespan = 1;
				emitter.add(particle);
			}
			emitter.start();
			add(emitter);
			return emitter;
		}
		private function killAllEnemies():void
		{
			enemyBombNum = 0
			while (enemyBombNum < enemiesArray.length)
			{
				var emitter:FlxEmitter = createEmitter();
				emitter.at(enemiesArray[enemyBombNum]);
				enemiesArray[enemyBombNum].kill();
				enemyBombNum += 1;
			}
			FlxG.play(laser, .3);
		}
	}
}