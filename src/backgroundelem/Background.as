package backgroundelem
{	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	import se.lnu.stickossdk.display.ScrollingTexture;
	
	public class Background extends DisplayStateLayerSprite
	{
		
		[Embed(source="/png/backgroundBlack.png")]
		private var LAYER_ONE:Class;
		[Embed(source="/png/backgroundStars.png")]
		private var LAYER_TWO:Class;
		
		private var m_layerOne:ScrollingTexture = new ScrollingTexture(LAYER_ONE, 800, 600, 0, 0);
		private var m_layerTwo:ScrollingTexture = new ScrollingTexture(LAYER_TWO, 800, 600, -0.3, 0.3);
		
		/*
		*	Constructor code
		*/
		
		public function Background()
		{
			super();
		}
		
		/*
		*	Initiation code
		*/
		
		override public function init():void{
			this.m_initLayerOne(); 
			this.m_initLayerTwo();
		}
		
		override public function dispose():void{
			this.removeChild(this.m_layerOne);
			this.removeChild(this.m_layerTwo);
			this.m_layerOne = null;
			this.m_layerTwo = null;
			this.LAYER_ONE = null;
			this.LAYER_TWO = null;
		}
		/*
		*	Initiation code for layer one
		*/
		
		private function m_initLayerOne():void {
			if (this.m_layerOne != null && this.m_layerOne.parent == null) {
				this.addChild(this.m_layerOne);
			}
		}
		
		/*
		*	Initiation code for layer two
		*/
		
		private function m_initLayerTwo():void {
			if (this.m_layerTwo != null && this.m_layerTwo.parent == null) {
				this.addChild(this.m_layerTwo);
			}
		}
		
		/*
		*	Update code
		*/
		
		override public function update():void{
			this.m_layerOne.update();
			this.m_layerTwo.update();
		}
	}
}