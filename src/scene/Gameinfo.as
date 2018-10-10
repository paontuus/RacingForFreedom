package scene
{
	import flash.display.MovieClip;
	
	import asset.singlePlayerInfoGFX;
	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	
	public class Gameinfo extends DisplayState
	{
		private var m_controls:EvertronControls = new EvertronControls(0);
		private var m_gameInfoMenu:MovieClip;
		private var m_menuLayer:DisplayStateLayer;
		private var m_selectedItem:Number = 1;
		private var soundFlag:Boolean;
		private var clickCounter:int;
		[Embed(source="/sound/select.mp3")]
		private var SelectSoundFile:Class;
		private var selectSound:SoundObject;
		[Embed(source="/sound/click.mp3")]
		private var ClickSoundFile:Class;
		private var clickSound:SoundObject;
		
		/*
		*	Constructor code
		*/
		
		public function Gameinfo()
		{
			super(); 
		}
		
		/*
		*	initiation code
		*/
		
		override public function init():void{
			this.m_initLayers();
			this.m_initSounds();
			
			this.m_gameInfoMenu = new singlePlayerInfoGFX;
			this.m_gameInfoMenu.x = 400;
			this.m_gameInfoMenu.y = 299;
			this.m_menuLayer.addChild(m_gameInfoMenu);
			
		}
		
		/*
		*	Dispose code
		*/
		
		override public function dispose():void{
			this.m_menuLayer.removeChild(m_gameInfoMenu);
			this.m_gameInfoMenu = null;
			this.m_controls = null;
			this.SelectSoundFile = null;
			this.selectSound = null;
			this.ClickSoundFile = null;
			this.clickSound = null;
			
		}
		
		/*
		*	Update code
		*/
		
		override public function update():void{
			this.m_updateControls();
			this.m_checkPress();
			
			if(soundFlag == true){
				this.clickCounter++;
				if(this.clickCounter == 30){
					this.clickCounter = 0;
					this.soundFlag = false;
					if(m_selectedItem == 1){
						Session.application.displayState = new Game();
					}
					else if(m_selectedItem == 2){
						Session.application.displayState = new Highscore();
					}
					else if(m_selectedItem == 3){
						Session.application.displayState = new Menu();
					}
				}
			}
		}
		
		/*
		*	Initiation code for sound
		*/
		
		private function m_initSounds():void{   
			Session.sound.soundChannel.sources.add("selectsound", SelectSoundFile); 
			selectSound = Session.sound.soundChannel.get("selectsound"); 
			selectSound.volume = 0.5;
			
			Session.sound.soundChannel.sources.add("clicksound", ClickSoundFile); 
			clickSound = Session.sound.soundChannel.get("clicksound"); 
			clickSound.volume = 0.5;
			
			
		}
		
		/*
		*	Initiation code for layers
		*/
		
		private function m_initLayers():void{
			this.m_menuLayer = this.layers.add("menu");
		}
		
		/*
		*	Update code for controls
		*/
		
		private function m_updateControls():void{
			
			if(Input.keyboard.justPressed("A")){
				selectSound.play();
				m_selectedItem--;
			}
			if(Input.keyboard.justPressed("D")){
				selectSound.play();
				m_selectedItem++;
			}
			if(m_selectedItem == 4){
				selectSound.stop();
				m_selectedItem = 3;
			}
			else if(m_selectedItem == 0){
				selectSound.stop();
				m_selectedItem = 1
			}
			
		}
		
		/*
		*	Update code for control usage
		*/
		
		private function m_checkPress():void{
			if(Input.keyboard.justPressed(this.m_controls.PLAYER_BUTTON_1)){
				this.soundFlag = true;
				this.clickSound.play();
			}
			if(m_selectedItem == 1){
				if(this.m_gameInfoMenu.currentFrameLabel != "play"){
					this.m_gameInfoMenu.gotoAndStop("play");	
				}
			}
			else if(m_selectedItem == 2){
				if(this.m_gameInfoMenu.currentFrameLabel != "highscore"){
					this.m_gameInfoMenu.gotoAndStop("highscore");	
				}
			} 
			else if(m_selectedItem == 3){
				if(this.m_gameInfoMenu.currentFrameLabel != "back"){
					this.m_gameInfoMenu.gotoAndStop("back");	
				}
			}
		}	 
	}
}