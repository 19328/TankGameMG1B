package  
{
	import flash.display.Sprite;
	import flash.events.Event
	
	/**
	 * ...
	 * @author 
	 */
	public class mcMissile extends Sprite 
	{
		
		public function mcMissile() 
		{
			//setup listener for checking if the missile is on stage
			addEventListener(Event.ADDED_TO_STAGE, onAdd);
			
		}
		
		private function onAdd(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdd);
			init();
		}
		
		private function init():void 
		{
			addEventListener(Event.ENTER_FRAME, missileLoop)
		}
		
		private function missileLoop(e:Event):void 
		{
			this.y -= 10;
		}
		
		
		public function destroyMissile():void
		{
			//remove the missile from the stage
			parent.removeChild(this);
			//remove any eventlisteners
			removeEventListener(Event.ENTER_FRAME, missileLoop);
		}
		
	}

}