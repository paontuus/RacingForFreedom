package scene
{
	import flash.display.MovieClip;
	
	import asset.winnerGFX;
	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	
	public class Winnerscreen extends DisplayState
	{
		private var m_controls:EvertronControls = new EvertronControls(0);
		private var m_winnerScreenMenu:MovieClip;
		private var m_menuLayer:DisplayStateLayer;
		private var m_selectedItem:Number = 1;
		[Embed(source="/sound/fireworks.mp3")]
		private var winnerScreenSoundFile:Class;
		private var winnerScreenSound:SoundObject;
		
		public function Winnerscreen()
		{
			super();
		}
		
		/*
		*	Initiation code
		*/
		
		override public function init():void{
			this.m_initLayers();
			this.m_initSounds();
			 
			this.m_winnerScreenMenu = new winnerGFX;
			this.m_winnerScreenMenu.x = 400;
			this.m_winnerScreenMenu.y = 250; 
			this.m_menuLayer.addChild(m_winnerScreenMenu);
			
		}
		
		/*
		*	Dispose code
		*/
		
		override public function dispose():void{
			this.m_menuLayer.removeChild(m_winnerScreenMenu);
			this.m_controls = null;
			this.m_winnerScreenMenu = null;
			this.m_menuLayer = null;
			this.winnerScreenSoundFile = null;
			this.winnerScreenSound = null;
		}
		
		/*
		*	Update code
		*/
		
		override public function update():void{
			this.m_checkPress();
			this.m_updateControls();
		}
		
		/*
		*	Initiation code for layers
		*/
		
		private function m_initLayers():void{
			this.m_menuLayer = this.layers.add("menu");
		}
		
		/*
		*	Initiation code for sound
		*/
		
		private function m_initSounds():void{
			Session.sound.soundChannel.sources.add("winnerScreensound", winnerScreenSoundFile); 
			winnerScreenSound = Session.sound.soundChannel.get("winnerScreensound"); 
			winnerScreenSound.volume = 2;
			winnerScreenSound.play();
		}
		
		/*
		*	Update code for controls
		*/
		
		private function m_updateControls():void{
			
			if(Input.keyboard.justPressed("A")){
				m_selectedItem--;
			}
			if(Input.keyboard.justPressed("D")){
				m_selectedItem++;
			}
			if(m_selectedItem == 3){
				m_selectedItem = 2;
			}
			else if(m_selectedItem == 0){
				m_selectedItem = 1
			}
		}
		
		/*
		*	Update code for control usage
		*/
		
		private function m_checkPress():void{
			if(Input.keyboard.justPressed(this.m_controls.PLAYER_BUTTON_1)){
				if(m_selectedItem == 1){
					Session.application.displayState = new Game();
				}
				else if(m_selectedItem == 2){
					Session.application.displayState = new Menu();
				}
			}
			if(m_selectedItem == 1){
				if(this.m_winnerScreenMenu.currentFrameLabel != "winplay"){
					this.m_winnerScreenMenu.gotoAndStop("winplay");	
				}
			}
			else if(m_selectedItem == 2){
				if(this.m_winnerScreenMenu.currentFrameLabel != "winback"){
					this.m_winnerScreenMenu.gotoAndStop("winback");	
				}
			} 
		}
	} 
}