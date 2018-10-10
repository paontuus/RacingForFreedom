package scene
{
	import flash.display.MovieClip;
	
	import asset.gameOverGFX;
	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	
	public class Gameover extends DisplayState
	{
		private var m_controls:EvertronControls = new EvertronControls(0);
		private var m_gameOverMenu:MovieClip;
		private var m_menuLayer:DisplayStateLayer;
		private var m_selectedItem:Number = 1;
		[Embed(source="/sound/gameover.mp3")]
		private var GameOverSoundFile:Class;
		private var gameOverSound:SoundObject;
		
		public function Gameover()
		{
			super();
		}
		
		/*
		* Initiation code
		*/
		
		override public function init():void{
			this.m_initLayers();
			this.m_initSounds();
			
			this.m_gameOverMenu = new gameOverGFX;
			this.m_gameOverMenu.x = 400;
			this.m_gameOverMenu.y = 325;
			this.m_menuLayer.addChild(m_gameOverMenu);
			
		}

		/*
		* Update
		*/
		
		override public function dispose():void{
			this.m_menuLayer.removeChild(this.m_gameOverMenu);
			this.m_menuLayer = null;
			this.m_controls = null;
			this.m_gameOverMenu = null;
			this.GameOverSoundFile = null;
			this.gameOverSound = null;
		}
		
		override public function update():void{
			this.m_updateControls();
			this.m_checkPress();
		}
		
		/*
		* Initiation code for layers
		*/
		
		private function m_initLayers():void{
			this.m_menuLayer = this.layers.add("menu");
		}
		
		/*
		* Initiation code for sound
		*/
		
		private function m_initSounds():void{
			Session.sound.soundChannel.sources.add("gameoversound", GameOverSoundFile); 
			gameOverSound = Session.sound.soundChannel.get("gameoversound"); 
			gameOverSound.volume = 0.5;
			gameOverSound.play();
		}
		
		/*
		* Update code for controls
		*/
		
		private function m_updateControls():void{
			
			if(Input.keyboard.justPressed("W")){
				m_selectedItem--;
			}
			if(Input.keyboard.justPressed("S")){
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
		* Update code for control usage
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
				if(this.m_gameOverMenu.currentFrameLabel != "try"){
					this.m_gameOverMenu.gotoAndStop("try");	
				}
			}
			else if(m_selectedItem == 2){
				if(this.m_gameOverMenu.currentFrameLabel != "back"){
					this.m_gameOverMenu.gotoAndStop("back");	
				}
			} 
		}
	} 
}