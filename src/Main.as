package
{
	import scene.Menu;
	
	import se.lnu.stickossdk.system.Engine;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="#000000")]
	
	public class Main extends Engine
	{
		
		/*
		*	Constructor code
		*/
		
		public function Main()
		{
			
		}
		
		/*
		*	Setup code
		*/
		
		override public function setup():void {
			this.initId = 35;
			this.initBackgroundColor = 0x000000;
			this.initDebugger = false;
			this.initDisplayState = Menu;
		}
	}
}