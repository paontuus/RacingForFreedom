package player
{
	import flash.display.MovieClip;
	
	import asset.explosionGFX;
	import asset.laserSmallGFX;
	import asset.laserBigGFX; 
	import asset.shipGFX;
	import asset.shipShadowGFX;
	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	
	public class Player extends DisplayStateLayerSprite
	{
		public var m_skin:MovieClip;
		public var m_skinExplosion:MovieClip;
		private var m_skinLaserSmall:MovieClip;
		private var m_skinLaserBig:MovieClip;
		public var m_skinShadow:MovieClip;
		public var m_controls:EvertronControls// = new EvertronControls(0);
		public var flightCheck:Number = 0;
		public var speed:Number = 0;
		public var goal:Number = 1000;
		public var currentSpeed:Number = 0;
		public const maxSpeed:Number = -25; 
		public const accelerate:Number = 0.10; 
		public const decelerate:Number = 0.10;
		[Embed(source="/sound/enginesound.mp3")]
		private var EngineSoundFile:Class;
		private var engineSound:SoundObject;

		/*
		*	Constructor code
		*/
		public function Player()
		{
			super();
		}
		
		/*
		*	Initiation code
		*/
		
		override public function init():void
		{
			m_initSkin();
			m_initSounds();
		}
		
		/*
		*	Dispose code
		*/
		
		override public function dispose():void{
			this.removeChild(this.m_skinShadow);
			this.removeChild(this.m_skinLaserSmall);
			this.removeChild(this.m_skinLaserBig);
			this.removeChild(this.m_skin);
			this.removeChild(this.m_skinExplosion);
			this.EngineSoundFile = null;
			this.engineSound = null;
			this.m_skin = null;
			this.m_skinExplosion = null;
			this.m_skinLaserSmall = null;
			this.m_skinLaserBig = null;
			this.m_skinShadow = null;
			this.m_controls = null;
		}
		
		/*
		*	Update code
		*/
		
		override public function update():void{
			this.m_updateControls();
			this.m_checkSpeed();
			this.m_checkLaserHeight();
		}
		
		/*
		*	Initiation code for sound
		*/
		
		private function m_initSounds():void{
			Session.sound.soundChannel.sources.add("enginesound", EngineSoundFile); 
			engineSound = Session.sound.soundChannel.get("enginesound"); 
			engineSound.volume = 0.35;
		}
		
		/*
		*	Initiation code for skin
		*/
		
		private function m_initSkin():void
		{
			this.m_skinShadow = new shipShadowGFX;
			this.m_skinShadow.scaleX = 0.45;
			this.m_skinShadow.scaleY = 0.45;
			this.m_skinShadow.y = 10;
			this.m_skinShadow.x = 10;
			this.addChild(this.m_skinShadow);
			this.m_skinLaserSmall = new laserSmallGFX;
			this.addChild(this.m_skinLaserSmall);
			this.m_skinLaserBig = new laserBigGFX;
			this.addChild(this.m_skinLaserBig);
			this.m_skin = new shipGFX;
			this.m_skin.scaleX = 0.45;
			this.m_skin.scaleY = 0.45; 
			this.addChild(this.m_skin);
			this.m_skinExplosion = new explosionGFX;
			this.m_skinExplosion.x = 2000;
			this.m_skinExplosion.y = 2000;
			this.addChild(this.m_skinExplosion);
		}
		
		/*
		*	Function that checks for skins laser height
		*/
		
		private function m_checkLaserHeight():void{
			if(flightCheck == 0){
				this.m_skinLaserSmall.x = 5
				this.m_skinLaserSmall.y = 10
				this.m_skinLaserBig.x = 2000
				this.m_skinLaserBig.y = 2000
			}else{
				this.m_skinLaserBig.x = 5
				this.m_skinLaserBig.y = 60
				this.m_skinLaserSmall.x = 2000
				this.m_skinLaserSmall.y = 2000
			}
		}
		
		/*
		*	Function that limits skins speed
		*/
		
		private function m_checkSpeed():void{
			if (this.speed <= this.maxSpeed){
				this.speed = this.maxSpeed;
			}
		}
		
		/*
		*	Wall detection for skin
		*/
		
		public function m_wallDetection(p,ps):void{
			if(flightCheck == 0){
				if (p.y <= 394){
					p.y = 394;
					p.x = 122;
				}
				
				if (p.y >= 554){
					p.y = 554;
					p.x = 202;
				}
				
			}else{
				if (p.y <= 294){
					p.y = 294;
					p.x = 122;
				}
				if (p.y >= 454){
					p.y = 454;
					p.x = 202;
				}
				
			}
		}
		
		/*
		*	Update code for controls
		*/
		
		private function m_updateControls():void{
			if (this.m_controls != null){
				if (Input.keyboard.pressed(this.m_controls.PLAYER_RIGHT)) {
					if(this.m_skin.currentFrameLabel != "right"){
						this.m_skin.gotoAndStop("right");	
					}
					if(this.m_skinShadow.currentFrameLabel != "rightShadow"){
						this.m_skinShadow.gotoAndStop("rightShadow");	
					}
					this.y += 8;
					this.x += 4;
					if (Input.keyboard.pressed(this.m_controls.PLAYER_BUTTON_1)){
						this.speed -= this.accelerate;
					}else{
						if(this.speed == 0){
							return;
						}else{
							this.speed += this.decelerate;
						}
					}
					
				}
					
				else if (Input.keyboard.pressed(this.m_controls.PLAYER_LEFT)){
					if(this.m_skin.currentFrameLabel != "left"){
						this.m_skin.gotoAndStop("left");	
					}
					if(this.m_skinShadow.currentFrameLabel != "leftShadow"){
						this.m_skinShadow.gotoAndStop("leftShadow");	
					}
					this.y -= 8;
					this.x -= 4;
					if (Input.keyboard.pressed(this.m_controls.PLAYER_BUTTON_1)){
						this.speed -= this.accelerate;
					}else{
						if(this.speed == 0){
							return;
						}else{
							this.speed += this.decelerate;
						}
					}
					
				}
					
				else if (Input.keyboard.justPressed(this.m_controls.PLAYER_UP)){
					
					
					if(flightCheck == 0){
						this.y -= 100;
						this.m_skinShadow.y += 100
						this.m_skinShadow.scaleX = 0.25
						this.m_skinShadow.scaleY = 0.25
						flightCheck = 1;
					}else{
						return;
					}
				}
					
				else if (Input.keyboard.justPressed(this.m_controls.PLAYER_DOWN)){
					if(flightCheck == 1){
						this.y += 100;
						this.m_skinShadow.y -= 100
						this.m_skinShadow.scaleX = 0.45
						
						this.m_skinShadow.scaleY = 0.45
						flightCheck = 0;
					}else{
						return;
					}
				}
				else if (Input.keyboard.pressed(this.m_controls.PLAYER_BUTTON_1)) {
					if(this.m_skin.currentFrameLabel != "run"){
						this.m_skin.gotoAndStop("run");	
					}
					
					if(this.m_skinShadow.currentFrameLabel != "runShadow"){
						this.m_skinShadow.gotoAndStop("runShadow");	
					}
					
					this.speed -= this.accelerate;
					
					
				}
				else {
					engineSound.play(99);
					if (this.m_skin.currentFrameLabel != "idle"){
						this.m_skin.gotoAndStop("idle");
					}
					if (this.m_skinShadow.currentFrameLabel != "idleShadow"){
						this.m_skinShadow.gotoAndStop("idleShadow");
					}
					if (this.speed <= -1){
						this.speed += this.decelerate;
					}else{
						this.speed = 0;
					}
					
				}
			}
		}
	}
}