package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class mcEnemy extends MovieClip 
	{
		public var sDirection:String;
		private var nSpeed:Number;
		public function mcEnemy() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdd);
			
		}
		
		private function onAdd(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdd);
			init();
		}
		
		private function init():void 
		{
			var nEnemies:Number = 3;
			//pik the random number between 1 & nEnemies
			var nRandom:Number = randomNumber(1, nEnemies);
			//setup our palyhead of this enemy clip to our random number
			this.gotoAndStop(nRandom);
			// setup enemy start position
			setupStartPosition();
		}
		
		private function setupStartPosition():void 
		{
			//pick random enemy speed
			nSpeed = randomNumber(2, 8);
			var nLeftOrRight:Number = randomNumber(1, 2);
			//if or nLeftOrRight == 1, start enemy on the left side
			if (nLeftOrRight == 1)
			{		//start enemy on the left side
					this.x = -(this.width / 2);
					sDirection = "R";
					
			}	
			else {
					//start enemy on the right side
					this.x = stage.stageWidth + (this.width / 2);
					sDirection = "L";
				}
					//set a random altitude for enemies
					//setup 2 variables for the minimum altitude and maximum altitude
					var nMinimumAltitude:Number = stage.stageHeight / 2;
					var nMaximumAltitude:Number = (this.height / 2);
					
					//setup enemy altitude to a random starting pos between a minimum and a maximum
					this.y = randomNumber(nMinimumAltitude, nMaximumAltitude);
					
					//move enemy
					startMoving();
					
		}
		
		private function startMoving():void 
		{
			addEventListener(Event.ENTER_FRAME, enemyLoop)
		}
		
		private function enemyLoop(e:Event):void 
		{
			//test what direction enemy is moving in
			//if enemy is moving right
			if (sDirection == "R")
			{	//move right
				this.x += nSpeed
			} else
			{	//move left
				this.x -= nSpeed;
			}
				
		}
		public function destroyEnemy():void
		{
			//remove this enemy from the stage
			parent.removeChild(this)
			//remove any eventlisteners in the enemy object
			removeEventListener(Event.ENTER_FRAME, enemyLoop);
		}
		
		function randomNumber(low:Number=0, high:Number=1):Number
		{
			return Math.floor(Math.random() * (1+high-low)) + low;
		}
		
	}

}