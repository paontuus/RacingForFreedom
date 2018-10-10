package scene
{
	import flash.display.MovieClip;
	
	import asset.highScoreGFX;
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input; 
	import se.lnu.stickossdk.media.SoundObject;   
	import se.lnu.stickossdk.system.Session;
	
	public class Highscore extends DisplayState
	{
		private var m_controls:EvertronControls = new EvertronControls(0);
		private var m_highScoreMenu:MovieClip;
		private var m_menuLayer:DisplayStateLayer;
		private var m_selectedItem:Number = 1;
		private var i:int;
		private var tempInt:int = 0;
		private var tempIntPoints:int = 0;
		private var tempText:Object;
		private var tempTextPoints:Object;
		private var tempTextString:String;
		private var soundFlag:Boolean;
		private var clickCounter:int;
		[Embed(source="/sound/click.mp3")]
		private var ClickSoundFile:Class;
		private var clickSound:SoundObject;
		[Embed(source="/sound/backgroundmenu.mp3")]
		private var MenuSoundFile:Class;
		private var menuSound:SoundObject;
		
		public function Highscore()
		{
			super();
		}
		
		/*
		*	Initiation code
		*/
		
		override public function init():void{
			this.m_initLayers();
			this.m_initSounds();
			
			this.m_highScoreMenu = new highScoreGFX;
			this.m_highScoreMenu.x = 398;
			this.m_highScoreMenu.y = 300;
			this.m_menuLayer.addChild(m_highScoreMenu);
			
			this.m_receiveHighScore();
			
		}
		
		/*
		*	Update code
		*/
		
		override public function update():void{
			this.m_checkPress();
			if(soundFlag == true){
				this.clickCounter++;
				if(this.clickCounter == 30){
					this.clickCounter = 0;
					this.soundFlag = false;
					Session.application.displayState = new Menu();
				}
			}
		}
		
		/*
		*	Dispose code
		*/
		
		override public function dispose():void{
			this.m_menuLayer.removeChild(m_highScoreMenu);
			this.m_highScoreMenu = null;
			this.m_controls = null;  
			this.tempText = null;
			this.tempTextPoints = null;
			this.tempTextString = null;
			this.ClickSoundFile = null;
			this.clickSound = null;
			this.MenuSoundFile = null
			this.menuSound = null;
			
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
			Session.sound.soundChannel.sources.add("clicksound", ClickSoundFile); 
			clickSound = Session.sound.soundChannel.get("clicksound"); 
			clickSound.volume = 0.5;
			Session.sound.musicChannel.sources.add("menusound", MenuSoundFile); 
			menuSound = Session.sound.musicChannel.get("menusound"); 
			menuSound.volume = 0.5;
			menuSound.play(99);
		}
		
		/*
		*	Function to get highscore data
		*/
		
		private function m_receiveHighScore():void{
			Session.highscore.receive(1,10,m_initHighScore);
		}
		
		/*
		*	Initiation code for highscore
		*/
		
		private function m_initHighScore(data:XML):void{
			for (i = 0; i < this.m_highScoreMenu.numChildren; i++) 
			{ 
				if(this.m_highScoreMenu.getChildAt(i).name == "topname"){
					this.tempText = this.m_highScoreMenu.getChildAt(i);  
					if(data.items.item[this.tempInt] != undefined){ 
						this.tempInt++;
						this.tempText.text = this.tempInt.toString().toLowerCase() + ".  " + data.items.item[this.tempInt-1].name.toLowerCase();
						
					}
				}
				else if(this.m_highScoreMenu.getChildAt(i).name == "toppoints"){ 
					this.tempTextPoints = this.m_highScoreMenu.getChildAt(i);  
					if(data.items.item[this.tempIntPoints] != undefined){
						this.tempIntPoints++;
						this.tempTextPoints.text = data.items.item[this.tempIntPoints-1].score;
						
					}
				}
			}  
		}
		
		/*
		*	Update code for control usage
		*/
		
		private function m_checkPress():void{
			if(Input.keyboard.justPressed(this.m_controls.PLAYER_BUTTON_1)){
				this.clickSound.play();
				this.soundFlag = true;
			
			}
		}	 
	}
}