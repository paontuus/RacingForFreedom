package scene
{
	import flash.display.MovieClip;
	
	import asset.menuGFX;
	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.EvertronInput;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	
	public class Menu extends DisplayState
	{
		private var m_controls:EvertronControls = new EvertronControls(0);
		private var m:MovieClip;
		private var m_menuLayer:DisplayStateLayer;
		private var m_selectedItem:Number = 1;
		private var soundFlag:Boolean;
		private var creditsFlag:Boolean;
		private var clickCounter:int;
		[Embed(source="/sound/select.mp3")]
		private var SelectSoundFile:Class;
		private var selectSound:SoundObject;
		[Embed(source="/sound/click.mp3")]
		private var ClickSoundFile:Class;
		private var clickSound:SoundObject;
		[Embed(source="/sound/backgroundmenu.mp3")]
		private var MenuSoundFile:Class;
		private var menuSound:SoundObject;
		
		public function Menu() {
			super();
		}
		
		/*
		*	Initiation code
		*/
		
		override public function init():void{
			this.m_initLayers();
			this.m_initSounds();
			
			this.m = new menuGFX;
			this.m.x = 400;
			this.m.y = 298;
			this.m_menuLayer.addChild(m);
			
		}
		
		/*
		 *	Update code
		*/
		
		override public function update():void{
			this.m_updateControls();
			this.m_checkPress();
			this.timeChecks();
		}
		
		/*
		 * Dispose code
		*/
		
		override public function dispose():void{
			this.m_menuLayer.removeChild(m);
			this.m_menuLayer = null;
			this.m = null;
			this.m_controls = null;
			this.SelectSoundFile = null;
			this.selectSound = null;	
			this.ClickSoundFile = null;
			this.clickSound = null;
			this.MenuSoundFile = null;
			this.menuSound = null;
			
		}
		
		/*
		*	Delay code
		*/
		
		private function timeChecks():void{
			if(soundFlag == true){
				this.clickCounter++;
				if(this.clickCounter == 40){
					this.clickCounter = 0;
					this.soundFlag = false;
					if(m_selectedItem == 1){
						Session.application.displayState = new Gameinfo();
					}
					else if(m_selectedItem == 2){
						Session.application.displayState = new Gameinfomultiplayer();
					}
					else if(m_selectedItem == 3){  
						Session.application.displayState = new Highscore();
					}
				}
			}
			if(creditsFlag == true){
				this.clickCounter++;
				if(this.clickCounter == 40){
					this.clickCounter = 0;
					this.creditsFlag = false;
					Session.application.displayState = new Credits();
				}
			}
		}
		
		/*
		*	Initiate sound
		*/
		
		private function m_initSounds():void{   
			Session.sound.soundChannel.sources.add("selectsound", SelectSoundFile); 
			selectSound = Session.sound.soundChannel.get("selectsound"); 
			selectSound.volume = 0.5;
			
			Session.sound.soundChannel.sources.add("clicksound", ClickSoundFile); 
			clickSound = Session.sound.soundChannel.get("clicksound"); 
			clickSound.volume = 0.5;
			
			Session.sound.musicChannel.sources.add("menusound", MenuSoundFile); 
			menuSound = Session.sound.musicChannel.get("menusound"); 
			menuSound.volume = 0.5;
			menuSound.play(99);
			
			
		}
		
		/*
		*	Initiate code
		*/
		
		private function m_updateControls():void{
			
			if(Input.keyboard.justPressed("W")){
				m_selectedItem--;
				selectSound.play();
			}
			if(Input.keyboard.justPressed("S")){
				m_selectedItem++;
				selectSound.play();
			}
			if(m_selectedItem == 4){
				m_selectedItem = 3;
			}
			else if(m_selectedItem == 0){
				m_selectedItem = 1
			}

		}
		
		/*
		*	Checking for control usage
		*/
		
		private function m_checkPress():void{
			if(Input.keyboard.justPressed(this.m_controls.PLAYER_BUTTON_1)){
				this.soundFlag = true;
				this.clickSound.play();
			}
			if(m_selectedItem == 1){
				if(this.m.currentFrameLabel != "singleplayer"){
					this.m.gotoAndStop("singleplayer");	
				}
			}
			else if(m_selectedItem == 2){
				if(this.m.currentFrameLabel != "multiplayer"){
					this.m.gotoAndStop("multiplayer");	
				}
			} 
			else if(m_selectedItem == 3){
				if(this.m.currentFrameLabel != "highscore"){
					this.m.gotoAndStop("highscore");	
				}
			}
			if(Input.keyboard.justPressed(EvertronInput.UNIVERSAL_START_1)){
				this.creditsFlag = true;
				this.clickSound.play();
			}
		}
		
		/*
		*	Initiate layers
		*/
		
		private function m_initLayers():void{
			this.m_menuLayer = this.layers.add("menu");
		}
	}
}