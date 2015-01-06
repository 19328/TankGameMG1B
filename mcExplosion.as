package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class mcExplosion extends MovieClip 
	{
		
		public function mcExplosion() 
		{
			//check if explosion is on the stage
			addEventListener(Event.ADDED_TO_STAGE, onAdd);
			
		}
		
		private function onAdd(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdd);
			init();
		}
		
		private function init():void 
		{
			addEventListener(Event.ENTER_FRAME, exxplosionLoop);
		}
		
		private function exxplosionLoop(e:Event):void 
		{
			//if our currentframe is at the total amount o frames remove the explosion
			if (this.currentFrame == this.totalFrames)
			{
				parent.removeChild(this)
				//remove the listener
				removeEventListener(Event.ENTER_FRAME, exxplosionLoop);
			}
		}
		
	}

}