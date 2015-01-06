package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author 
	 */
	public class firstGame extends MovieClip 
	{
		public var mcPlayer:MovieClip;
		private var leftKeyIsDown:Boolean
		private var rightKeyIsDown:Boolean
		
		private var aMissileArray:Array;
		private var aEnemyArray:Array;
		
		public var scoreText:TextField;
		public var ammoText:TextField;
		public var menuEnd:mcEndGameScreen;
		
		private var nScore:Number;
		private var nAmmo:Number;
		private var tEnemyTimer:Timer;
		
		public function firstGame() 
		{
			//initialize var
			aMissileArray = new Array();
			aEnemyArray = new Array();
			nScore = 0;
			nAmmo = 20;
			menuEnd.hideScreen();
			
			
			updateScoreText();
			updateAmmoText();
			
			
			
			
			//trace("First Game Loaded")
			//keypress listeners
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp)
			//loop listener
			stage.addEventListener(Event.ENTER_FRAME, gameLoop)
			
			
			//create timer object
			tEnemyTimer = new Timer(1000, 0)
			//listen for timer intervals
			tEnemyTimer.addEventListener(TimerEvent.TIMER, addEnemy)
			//start timer object
			tEnemyTimer.start();
		}
		
		private function updateScoreText():void
		{
			scoreText.text = "Score: " + nScore;
		}
		
		private function updateAmmoText():void
		{
			ammoText.text = "Ammo: " + nAmmo;
		}
		
	
		
		private function addEnemy(e:TimerEvent):void 
		{
			//create new enemy object
			var newEnemy:mcEnemy = new mcEnemy();
			//add enemy object to the stage
			stage.addChild(newEnemy);
			//add our new enemy to enemy array
			aEnemyArray.push(newEnemy);
			//trace(aEnemyArray.length);
		}
		
		private function gameLoop(e:Event):void 
		{
			playerControl();
			clampPlayerToStage();
			deleteMissiles();
			deleteEnemies();
			checkMissilesHitEnemy();
			checkEndGameCondition();
		}
		
		private function checkEndGameCondition():void 
		{
			//check if the player has zero missiles and there are no missiles on the stage
			if (nAmmo == 0 && aMissileArray.length == 0)
			{
				//stop player movement
				stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
				//hide the player
				mcPlayer.visible = false;
				//stop spawning enemies
				tEnemyTimer.stop();
				//clear enemies that are on the screen
				for each(var enemy:mcEnemy in aEnemyArray)
				{
					//destroy the enemy that is in the loop
					enemy.destroyEnemy();
					//remove that enemy from the array
					aEnemyArray.splice(0,1)
					
				}
				//end game loop
				if(aEnemyArray.length==0)
				{
					stage.removeEventListener(Event.ENTER_FRAME, gameLoop);
				}	
			}
		}
		
		private function checkMissilesHitEnemy():void 
		{
			//loop through all curren missiles
			for (var i:int = 0; i < aMissileArray.length; i++)
			{
				//get current missile in i loop
				var currentMissile:mcMissile = aMissileArray[i];
				// loop through all our enemies
				for (var j:int = 0; j < aEnemyArray.length; j++ )
				{
					// get current enemy in j loop
					var currentEnemy:mcEnemy = aEnemyArray[j];
					
					// test if curren missiles is coliding with current enemy
					if (currentMissile.hitTestObject(currentEnemy))
					{
						
						// create the explosion
						//create new explosion movieclip
						var newExplosion:mcExplosion = new mcExplosion()
						//add the explosion to the stage
						stage.addChild(newExplosion)
						//position the explosion on the enemy
						newExplosion.x = currentEnemy.x;
						newExplosion.y = currentEnemy.y;
						//remove the missile array & and stage
						currentMissile.destroyMissile()
						aMissileArray.splice(i, 1);
						//remove the enemy of the array and the stage
						currentEnemy.destroyEnemy()
						aEnemyArray.splice(j, 1)
						//add one to score
						nScore++
						updateScoreText();
					}
				}
			}
		}
		
		private function deleteEnemies():void 
		{
			//loop through enemies in array
			for (var i:int = 0; i < aEnemyArray.length; i++)
			{
				//get current enemy is the loop
				var currentEnemy:mcEnemy = aEnemyArray[i];
				//
				//when enemy starts on left side and of the screen
				if (currentEnemy.sDirection == "L" && currentEnemy.x < -(currentEnemy.width / 2))
				{
					//remove enemy from array
					aEnemyArray.splice(i, 1);
					// remove enemy from stage
					currentEnemy.destroyEnemy();
				} else
				if (currentEnemy.sDirection == "R" && currentEnemy.x > (stage.stageWidth + currentEnemy.width / 2))
				{
					//remove enemy from array
					aEnemyArray.splice(i, 1);
					// remove enemy from stage
					currentEnemy.destroyEnemy();
				}
			}
		}
		
		private function deleteMissiles():void 
		{
			//loop through missiles in array
			for (var i:int = 0; i < aMissileArray.length; i++)
			{
				//get current missiles in loop
				var currentMissile:mcMissile = aMissileArray[i]
				//test if missile is above the screen
				if (currentMissile.y < 0)
				{
					//remove from array if true
					aMissileArray.splice(i,1);
					//destroy missiles if true
					currentMissile.destroyMissile();
				}
			}
		}
		
		private function clampPlayerToStage():void 
		{
			//if player reaches left edge stop moving
			if (mcPlayer.x < 0) 
			{
				mcPlayer.x = 0;
			}
			//if player reaches right edge stop moving
			if (mcPlayer.x > stage.stageWidth - mcPlayer.width)
			{
				mcPlayer.x = stage.stageWidth - mcPlayer.width;
			}
		}
		
		private function playerControl():void 
		{
			//if left key is down move left
			if (leftKeyIsDown)
			{
				mcPlayer.x -= 8;
			}
			// if right key is down move right
			if (rightKeyIsDown == true)
			{
				mcPlayer.x += 8;
			}
		}
		
		private function keyUp(e:KeyboardEvent):void 
		{
			
			//trace(e.keyCode)
			if (e.keyCode == 37)
			{
				//left key released
				leftKeyIsDown = false;
				
			}
			if (e.keyCode == 39)
			{
				//right key released
				rightKeyIsDown = false;
			}
			if (e.keyCode == 32)
			{
				
				//test if the player has missiles left
				if (nAmmo > 0) 
				{
					nAmmo--;
					updateAmmoText();
					//FIRE MISSILE
					fireMissile();
				}
				
			}
		}
		
		private function fireMissile():void 
		{
			//create a missile
			var newMissile:mcMissile = new mcMissile();
			//add that missile to the stage
			stage.addChild(newMissile);
			// position it above our mcPlayer
			newMissile.x = mcPlayer.x+mcPlayer.width/2;
			newMissile.y = mcPlayer.y;
			//aad new missile to missile array
			aMissileArray.push(newMissile);
			//trace(aMissileArray.length);
			
		}
		private function keyDown(e:KeyboardEvent):void
		{
			
			if (e.keyCode == 37)
			{
				//left key down
				leftKeyIsDown = true;
				
			}
			if (e.keyCode == 39)
			{
				//right key down
				rightKeyIsDown = true;
			
		}
		
	}
}}

