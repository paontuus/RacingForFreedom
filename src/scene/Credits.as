package scene
{
	import flash.display.MovieClip;
	
	import asset.creditsGFX;
	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	
	public class Credits extends DisplayState
	{
		private var m_controls:EvertronControls = new EvertronControls(0);
		private var m_creditsMenu:MovieClip;
		private var m_menuLayer:DisplayStateLayer;
		private var soundFlag:Boolean = false;
		private var clickCounter:int;
		[Embed(source="/sound/backgroundmenu.mp3")]
		private var CreditsSoundFile:Class;
		private var creditsSound:SoundObject;
		[Embed(source="/sound/click.mp3")]
		private var ClickSoundFile:Class;
		private var clickSound:SoundObject;
		
		/*
		*	Constructor code
		*/
		
		public function Credits()
		{
			super();
		}
		
		/*
		*	Initiation code
		*/
		
		override public function init():void{
			this.m_initLayers();
			this.m_initSounds();
			
			this.m_creditsMenu = new creditsGFX;
			this.m_creditsMenu.x = 400;
			this.m_creditsMenu.y = 299;
			this.m_menuLayer.addChild(this.m_creditsMenu);
			
		}
		
		/*
		*	Dispose code
		*/
		
		override public function dispose():void{
			this.m_menuLayer.removeChild(this.m_creditsMenu);
			this.m_controls = null;
			this.m_creditsMenu = null;
			this.m_menuLayer = null;
			this.CreditsSoundFile = null
			this.creditsSound = null;
			this.ClickSoundFile = null;
			this.clickSound = null;
		}
		/*
		*	Update code
		*/
		
		override public function update():void{
			this.m_checkPress();
			this.timeChecks();
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
					Session.application.displayState = new Menu();
				}
			}
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
			Session.sound.musicChannel.sources.add("creditssound", CreditsSoundFile); 
			creditsSound = Session.sound.musicChannel.get("creditssound"); 
			creditsSound.volume = 0.5;
			creditsSound.play(99);
			
			Session.sound.soundChannel.sources.add("creditssound", ClickSoundFile); 
			clickSound = Session.sound.soundChannel.get("creditssound"); 
		}
		
		/*
		*	update code for control usage
		*/
		
		private function m_checkPress():void{
			if(Input.keyboard.justPressed(this.m_controls.PLAYER_BUTTON_1)){
				clickSound.play();
				this.soundFlag = true;
			}
		}
	} 
}