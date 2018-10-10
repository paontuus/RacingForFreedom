package player
{
	import flash.display.MovieClip;
	
	import asset.explosionGFX;
	import asset.laserBigGFX;
	import asset.laserSmallGFX;
	import asset.laserBigRedGFX;
	import asset.laserSmallRedGFX;
	import asset.shipGFX;
	import asset.shipRedGFX;
	import asset.shipShadowGFX;
	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	
	public class Playermultiplayer extends DisplayStateLayerSprite
	{
		public var m_skin:MovieClip;
		public var m_skinExplosion:MovieClip;
		public var m_skinRed:MovieClip;
		public var m_skinShadow:MovieClip;
		public var m_skinShadowRed:MovieClip;
		public var m_skinLaserSmall:MovieClip; 
		public var m_skinLaserBig:MovieClip
		public var m_skinLaserSmallRed:MovieClip;
		public var m_skinLaserBigRed:MovieClip;
		public var m_controls:EvertronControls// = new EvertronControls(0);
		public var m_controlsRed:EvertronControls// = new EvertronControls(1);
		public var flightCheck:Number = 0;
		public var flightCheckRed:Number = 0;
		public var speed:Number = 0;
		public var speedRed:Number = 0;
		public var currentSpeed:Number = 0;
		public const maxSpeed:Number = -20; 
		public const accelerate:Number = 0.10; 
		public const decelerate:Number = 0.10;
		[Embed(source="/sound/enginesound.mp3")]
		private var EngineSoundFile:Class;
		private var engineSound:SoundObject;
		[Embed(source="/sound/enginesound.mp3")]
		private var EngineSoundFile2:Class;
		private var engineSound2:SoundObject;
		
		/*
		*	Constructor code 
		*/
		
		public function Playermultiplayer() 
		{
			super();
		}
		
		/*
		*	initiation code
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
			this.removeChild(this.m_skin); 
			this.removeChild(this.m_skinLaserBigRed); 
			this.removeChild(this.m_skinLaserBig); 
			this.removeChild(this.m_skinLaserSmall); 
			this.removeChild(this.m_skinLaserSmallRed); 
			this.removeChild(this.m_skinRed);
			this.removeChild(this.m_skinShadowRed);
			this.removeChild(this.m_skinExplosion);
			this.m_skin = null;
			this.m_skinExplosion = null;
			this.m_skinRed = null;
			this.m_skinShadow = null;
			this.m_skinShadowRed = null;
			this.m_skinLaserSmall = null;
			this.m_skinLaserBig = null;
			this.m_skinLaserSmallRed = null;
			this.m_skinLaserBigRed = null;
			this.m_controls = null;
			this.m_controlsRed = null;
		}
		
		/*
		*	Update code
		*/
		
		override public function update():void{
			this.m_updateControls();
			//this.m_updateControlsRed();
			this.m_checkSpeed();
		}
		
		/*
		*	Initiation code for sound
		*/
		
		private function m_initSounds():void{
			Session.sound.soundChannel.sources.add("enginesound", EngineSoundFile); 
			engineSound = Session.sound.soundChannel.get("enginesound"); 
			engineSound.volume = 0.5;
			Session.sound.soundChannel.sources.add("enginesound2", EngineSoundFile2); 
			engineSound2 = Session.sound.soundChannel.get("enginesound2"); 
			engineSound2.volume = 0.5;
		}
		
		/*
		*	Initiation code for skin
		*/
		
		private function m_initSkin():void
		{
			this.m_skinShadow = new shipShadowGFX;
			this.m_skinShadow.scaleX = 0.45;
			this.m_skinShadow.scaleY = 0.45;
			this.addChild(this.m_skinShadow); 
			
			this.m_skinLaserSmall = new laserSmallGFX;
			this.addChild(this.m_skinLaserSmall);
			this.m_skinLaserBig = new laserBigGFX;
			this.addChild(this.m_skinLaserBig);
			
			this.m_skin = new shipGFX;
			this.m_skin.scaleX = 0.45;
			this.m_skin.scaleY = 0.45;
			this.addChild(this.m_skin);
			
			this.m_skinShadowRed = new shipShadowGFX;
			this.m_skinShadowRed.scaleX = 0.45; 
			this.m_skinShadowRed.scaleY = 0.45;
			this.addChild(this.m_skinShadowRed); 
			
			this.m_skinLaserSmallRed = new laserSmallRedGFX;
			this.addChild(this.m_skinLaserSmallRed);
			this.m_skinLaserBigRed = new laserBigRedGFX;
			this.addChild(this.m_skinLaserBigRed);
			
			this.m_skinRed = new shipRedGFX;
			this.m_skinRed.scaleX = 0.45;
			this.m_skinRed.scaleY = 0.45;
			this.addChild(this.m_skinRed);
			
			this.m_skinExplosion = new explosionGFX;
			this.m_skinExplosion.x = 2000;
			this.m_skinExplosion.y = 2000;
			this.addChild(this.m_skinExplosion);
			
		}
		
		/*
		*	Function for limiting speed
		*/
		
		private function m_checkSpeed():void{
			if (this.speed <= this.maxSpeed){
				this.speed = this.maxSpeed;
			}
			if (this.speedRed <= this.maxSpeed){
				this.speedRed = this.maxSpeed;
			}
		}
		
		/*
		*	Function for wall detection
		*/
		
		public function m_wallDetection(p,ps):void{
			if(flightCheck == 0){
				if (p.m_skin.y <= 370){
					p.m_skin.y = 370;
					p.m_skin.x = 20;
					this.m_skinShadow.y = 380;
					this.m_skinShadow.x = 30;
					
				}
				else if (p.m_skin.y >= 512){
					p.m_skin.y = 512;
					p.m_skin.x = 128;
					this.m_skinShadow.y = 522;
					this.m_skinShadow.x = 138;
					
				}
				
				
			}else{
				if (p.m_skin.y <= 270){
					p.m_skin.y = 270;
					p.m_skin.x = 20;
					this.m_skinShadow.y = 370;
					this.m_skinShadow.x = 30;
					
				}
				else if (p.m_skin.y >= 414){
					p.m_skin.y = 414;
					p.m_skin.x = 128; 
					this.m_skinShadow.y = 524;
					this.m_skinShadow.x = 138;
					
				}
				
			}
			if(flightCheckRed == 0){
				if (p.m_skinRed.y <= 448){
					p.m_skinRed.y = 448;
					p.m_skinRed.x = 276;
					this.m_skinShadowRed.y = 458;
					this.m_skinShadowRed.x = 286;
				}
				
				if (p.m_skinRed.y >= 600){
					p.m_skinRed.y = 600;
					p.m_skinRed.x = 390;
					this.m_skinShadowRed.y = 610;
					this.m_skinShadowRed.x = 400;
				}
				
			}else{
				if (p.m_skinRed.y <= 348){
					p.m_skinRed.y = 348;
					p.m_skinRed.x = 276;
					this.m_skinShadowRed.y = 448;
					this.m_skinShadowRed.x = 286;
				}
				if (p.m_skinRed.y >= 500){
					p.m_skinRed.y = 500;
					p.m_skinRed.x = 390;
					this.m_skinShadowRed.y = 600;
					this.m_skinShadowRed.x = 400;
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
					this.m_skin.y += 8;
					this.m_skin.x += 6;
					this.m_skinShadow.y += 8;
					this.m_skinShadow.x += 6;
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
					this.m_skin.y -= 8;
					this.m_skin.x -= 6;
					this.m_skinShadow.y -= 8;
					this.m_skinShadow.x -= 6;
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
						this.m_skin.y -= 100;
						this.m_skinShadow.scaleX = 0.25
						this.m_skinShadow.scaleY = 0.25
						flightCheck = 1;
					}else{
						return;
					}
				}
					
				else if (Input.keyboard.justPressed(this.m_controls.PLAYER_DOWN)){
					if(flightCheck == 1){
						this.m_skin.y += 100;
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
					if (Input.keyboard.pressed(this.m_controls.PLAYER_RIGHT)){
						this.m_skin.y += 8;
						this.m_skin.x += 6;
						this.m_skinShadow.y += 8;
						this.m_skinShadow.x += 6; 
					}
					if (Input.keyboard.pressed(this.m_controls.PLAYER_LEFT)){
						this.m_skin.y -= 8;
						this.m_skin.x -= 6;
						this.m_skin.y -= 8;
						this.m_skin.x -= 6; 
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
			
			/*
				Controls for Red player
			*/
			
			if (this.m_controlsRed != null){
				if (Input.keyboard.pressed(this.m_controlsRed.PLAYER_RIGHT)) {
					if(this.m_skinRed.currentFrameLabel != "right"){
						this.m_skinRed.gotoAndStop("right");	
					}
					if(this.m_skinShadowRed.currentFrameLabel != "rightShadow"){
						this.m_skinShadowRed.gotoAndStop("rightShadow");	
					}
					this.m_skinRed.y += 8;
					this.m_skinRed.x += 6;
					this.m_skinShadowRed.y += 8;
					this.m_skinShadowRed.x += 6; 
					if (Input.keyboard.pressed(this.m_controlsRed.PLAYER_BUTTON_1)){
						this.speedRed -= this.accelerate;
					}else{
						if(this.speedRed == 0){
							return;
						}else{
							this.speedRed += this.decelerate;
						}
					}
					
				}
					
				if (Input.keyboard.pressed(this.m_controlsRed.PLAYER_LEFT)){
					if(this.m_skinRed.currentFrameLabel != "left"){
						this.m_skinRed.gotoAndStop("left");	
					}
					if(this.m_skinShadowRed.currentFrameLabel != "leftShadow"){
						this.m_skinShadowRed.gotoAndStop("leftShadow");	
					}
					this.m_skinRed.y -= 8;
					this.m_skinRed.x -= 6;
					this.m_skinShadowRed.y -= 8;
					this.m_skinShadowRed.x -= 6; 		
				}
					
				else if (Input.keyboard.justPressed(this.m_controlsRed.PLAYER_UP)){
					if(flightCheckRed == 0){
						this.m_skinRed.y -= 100;
						this.m_skinShadowRed.scaleX = 0.25
						this.m_skinShadowRed.scaleY = 0.25
						flightCheckRed = 1;
					}else{
						return;
					}
				}
					
				else if (Input.keyboard.justPressed(this.m_controlsRed.PLAYER_DOWN)){
					if(flightCheckRed == 1){
						this.m_skinRed.y += 100;
						this.m_skinShadowRed.scaleX = 0.45
						
						this.m_skinShadowRed.scaleY = 0.45
						flightCheckRed = 0;
					}else{
						return;
					}
				}
				else if (Input.keyboard.pressed(this.m_controlsRed.PLAYER_BUTTON_1)) {
					if(this.m_skinRed.currentFrameLabel != "run"){
						this.m_skinRed.gotoAndStop("run");	
					}
					
					if(this.m_skinShadowRed.currentFrameLabel != "runShadow"){
						this.m_skinShadowRed.gotoAndStop("runShadow");	
					}				
					
					this.speedRed -= this.accelerate;
					
				}
				else {
					engineSound2.play(99);
					if (this.m_skinRed.currentFrameLabel != "idle"){
						this.m_skinRed.gotoAndStop("idle");
					}
					if (this.m_skinShadowRed.currentFrameLabel != "idleShadow"){
						this.m_skinShadowRed.gotoAndStop("idleShadow");
					}
					if (this.speedRed <= -1){
						this.speedRed += this.decelerate;
					}else{
						this.speedRed = 0;
					}
					
				}
				
			}
		}
	}
}