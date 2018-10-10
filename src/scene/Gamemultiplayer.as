package scene
{
	
	import flash.display.MovieClip;
	
	import asset.countDownGFX;
	import asset.goalGFX;
	
	import backgroundelem.Background;
	
	import hud.Hudmultiplayer;
	
	import obstacle.Obstacle;
	
	import obstacleair.Obstacleair;
	
	import player.Playermultiplayer;
	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	
	import track.Trackmultiplayer;
	
	public class Gamemultiplayer extends DisplayState
	{
		private var m_gameLayer:DisplayStateLayer;
		private var m_bgLayer:DisplayStateLayer;
		private var m_trackLayer:DisplayStateLayer;
		private var m_obstacleLayer:DisplayStateLayer;
		private var m_obstacleLayerAir:DisplayStateLayer;
		private var m_hudLayer:DisplayStateLayer;
		private var tr:Trackmultiplayer;
		private var p:Playermultiplayer;
		private var bg:Background;
		private var ob:Obstacle;
		private var ob2:Obstacle
		private var obAir:Obstacleair;
		private var obAir2:Obstacleair
		private var h:Hudmultiplayer;
		private var goal:MovieClip;
		private var goal2:MovieClip;
		private var countDown:MovieClip;
		private var tempSpeed:Number;
		private var tempDistance:Number = 0;
		private var distance:Number = 0;
		private var distanceRed:Number = 0;
		private var soundFlag:Boolean = false;
		private var goalFlag:Boolean = false;
		private var goalFlagRed:Boolean = false;
		private var countFlag:Boolean = false;
		private var redCrashFlag:Boolean = false;
		private var blueCrashFlag:Boolean = false;
		private var life:int = 3;
		private var lifeRed:int = 3;
		private var goalCounter:int = 0;
		private var countCounter:int;
		private var soundCounter:int = 0;
		private var stopCounter:int = 0;
		private var endScore:Number = 99999999;
		private var finishScore:Number;
		private var randomNr:Number = Math.floor( Math.random() * 3 );
		private var randomNr2:Number = Math.floor( Math.random() * 3 );
		private var randomNrOb:Number = Math.floor( Math.random() * 3 );
		private var randomNrOb2:Number = Math.floor( Math.random() * 3 );
		
		[Embed(source="/sound/crash.mp3")]
		private var CrashSoundFile:Class;
		private var crashSound:SoundObject;
		[Embed(source="/sound/music.mp3")]
		private var MusicSoundFile:Class;
		private var musicSound:SoundObject;
		[Embed(source="/sound/countdown.mp3")]
		private var CountSoundFile:Class;
		private var countSound:SoundObject;
		
		/*
		*	Constructor code
		*/
		public function Gamemultiplayer()
		{
			super();
		}
		
		/*
		*	Initiation code
		*/
		
		override public function init():void{
			this.m_initLayers();
			this.m_initSounds();
			this.m_initGoal();
			

			
			bg = new Background(); 	
			
			tr = new Trackmultiplayer();
			
			ob = new Obstacle();
			ob2 = new Obstacle();
			
			obAir = new Obstacleair();
			obAir2 = new Obstacleair();
			
			p = new Playermultiplayer();
			
			h = new Hudmultiplayer();

			this.m_bgLayer.addChild(bg);
			this.m_trackLayer.addChild(tr);
			this.m_obstacleLayer.addChild(this.goal);
			this.m_obstacleLayer.addChild(this.goal2);
			this.m_obstacleLayer.addChild(ob);
			this.m_obstacleLayer.addChild(ob2);
			this.m_gameLayer.addChild(p);
			this.m_obstacleLayerAir.addChild(obAir);
			this.m_obstacleLayerAir.addChild(obAir2);
			this.m_hudLayer.addChild(h);
			
			this.m_initCountDown();
			
		}
		
		/*
		*	Update code
		*/
		
		override public function update():void{
			this.updateTrack();
			this.updateWall();
			this.updateObstacle();
			this.updateSpeedHud();
			this.goalCheck();
			this.measureDistance();
			this.timeChecks();
			this.m_checkLaserHeight();
			this.lifeCheck();
			
			h.updateBar(this.distance, this.distanceRed);
		}
		
		/*
		*	Dispose code
		*/
		
		override public function dispose():void{
			if(this.m_bgLayer != null){
				this.m_bgLayer.removeChild(bg);
				this.m_bgLayer = null;
				this.bg.dispose();
				this.bg = null;
			}
			if(this.m_trackLayer != null){
				this.m_trackLayer.removeChild(tr);
				this.m_trackLayer
				this.tr.dispose();
				this.tr = null;
			}
			if(this.m_obstacleLayer != null){
				this.m_obstacleLayer.removeChild(ob);
				this.m_obstacleLayer.removeChild(ob2);
				this.m_obstacleLayer.removeChild(this.goal);
				this.m_obstacleLayer.removeChild(this.goal2);
				this.m_obstacleLayer = null;
				this.ob.dispose();
				this.ob = null;
				this.ob2.dispose();
				this.ob2 = null;
				this.goal = null;
				this.goal2 = null;
			}
			if(this.m_gameLayer != null){
				this.m_gameLayer.removeChild(p);
				this.m_gameLayer = null;
				this.p.dispose();
				this.p = null;
				
			}
			if(this.m_obstacleLayerAir != null){
				this.m_obstacleLayerAir.removeChild(obAir);
				this.m_obstacleLayerAir.removeChild(obAir2);
				this.m_obstacleLayerAir = null;
				this.obAir.dispose();
				this.obAir = null;
				this.obAir2.dispose();
				this.obAir2 = null;
			}
			if(this.m_hudLayer != null){
				this.m_hudLayer.removeChild(h);
				this.m_hudLayer = null;
				this.h.dispose();
				this.h = null;
			}
			this.countDown = null;
			this.CrashSoundFile = null;
			this.crashSound = null;
			this.MusicSoundFile = null;
			this.musicSound = null;
			this.CountSoundFile = null
			this.countSound = null;
			
		}
		
		/*
		*	Function to show right life
		*/
		
		private function lifeCheck():void{
			if(this.life == 3){
				if (h.lifeHud.currentFrameLabel != "blue3"){
					h.lifeHud.gotoAndStop("blue3");
				}
			}else if(life == 2){
				if (h.lifeHud.currentFrameLabel != "blue2"){
					h.lifeHud.gotoAndStop("blue2");
				}
			}else{
				if (h.lifeHud.currentFrameLabel != "blue1"){
					h.lifeHud.gotoAndStop("blue1");
				}
			}
			
			if(this.lifeRed == 3){
				if (h.lifeRedHud.currentFrameLabel != "red3"){
					h.lifeRedHud.gotoAndStop("red3");
				}
			}else if(lifeRed == 2){
				if (h.lifeRedHud.currentFrameLabel != "red2"){
					h.lifeRedHud.gotoAndStop("red2");
				}
			}else{
				if (h.lifeRedHud.currentFrameLabel != "red1"){
					h.lifeRedHud.gotoAndStop("red1");
				}
			}
		}
		
		/*
		*	Delay code
		*/
		
		private function timeChecks():void{
			if(redCrashFlag == true){

				if(this.lifeRed <= 1){
					this.soundCounter++;
					this.stopCounter++;
					if(this.soundCounter == 60){
						this.soundCounter = 0;
						this.redCrashFlag = false;
						Session.application.displayState = new Winnerscreenblue();
						
					}
					if(this.stopCounter == 5){
						p.speed = 0;
						p.speedRed = 0;
						p.m_controls = null;
						p.m_controlsRed = null;
					}
					
				}else if(this.lifeRed != 1){
					this.soundCounter++;
					this.stopCounter++;
					if(p.m_skinRed.currentFrameLabel != "blinkred"){
						p.m_skinRed.gotoAndStop("blinkred");	
						p.m_controlsRed = null;
					}
					if(this.soundCounter == 30){
						this.soundCounter = 0; 
						this.redCrashFlag = false;
						this.lifeRed--;
						p.m_controlsRed = new EvertronControls(1);
						if(p.m_skinRed.currentFrameLabel != "idle"){
							p.m_skinRed.gotoAndStop("idle");	
						}
					}
				}
			}
			if(blueCrashFlag == true){
				
				if(this.life <= 1){
					this.soundCounter++;
					this.stopCounter++;
					if(this.soundCounter == 60){
						this.soundCounter = 0;
						this.blueCrashFlag = false;
						Session.application.displayState = new Winnerscreenred();
						
					}
					if(this.stopCounter == 5){
						p.speed = 0;
						p.speedRed = 0;
						p.m_controls = null;
						p.m_controlsRed = null; 
					}

				}else if(this.life != 1){
					this.soundCounter++;
					this.stopCounter++;
					if(p.m_skin.currentFrameLabel != "blinkblue"){
						p.m_skin.gotoAndStop("blinkblue");	
					}
					p.m_controls = null;
					if(this.soundCounter == 30){
						if(p.m_skin.currentFrameLabel != "idle"){
							p.m_skin.gotoAndStop("idle");	
						}
						p.m_controls = new EvertronControls(0);
						
						this.soundCounter = 0;
						this.blueCrashFlag = false;
						this.life--;
					}
				}
				
			}
			if(goalFlag == true){
				this.goalCounter++;
				this.stopCounter++;
				if(this.goalCounter == 30){
					this.soundCounter = 0;
					this.goalFlag = false;
					Session.application.displayState = new Winnerscreenblue();
					
				}
				if(this.stopCounter == 10){
					p.speed = 0;
					p.speedRed = 0;
					p.m_controls = null; 
					p.m_controlsRed = null;
				}
			}
			if(goalFlagRed == true){
				this.goalCounter++;
				this.stopCounter++;
				if(this.goalCounter == 30){
					this.soundCounter = 0;
					this.goalFlagRed = false;
					Session.application.displayState = new Winnerscreenred();
					
				}
				if(this.stopCounter == 10){
					p.speedRed = 0;
					p.speed = 0;
					p.m_controlsRed = null;
				}
			}
			if(countFlag == true){
				this.countCounter++;
				if(this.countCounter == 130){
					this.soundCounter = 0;
					this.countFlag = false;
					p.m_controls = new EvertronControls(0);
					p.m_controlsRed = new EvertronControls(1);
					p.m_skinShadow.y = 450;
					p.m_skinShadow.x = 70;
					p.m_skin.y = 440;
					p.m_skin.x = 60;
					p.m_skinShadowRed.x = 340;
					p.m_skinShadowRed.y = 530;
					p.m_skinRed.x = 330;
					p.m_skinRed.y = 520;
					this.m_hudLayer.removeChild(this.countDown);
					
				}
			}
			
		}
		
		/*
		*	Function for right laser version under ship
		*/
		
		private function m_checkLaserHeight():void{
			if(p.flightCheck == 0){
				p.m_skinLaserSmall.x = p.m_skin.x + 5
				p.m_skinLaserSmall.y = p.m_skin.y +10
				p.m_skinLaserBig.x = 2000
				p.m_skinLaserBig.y = 2000
			}else if(p.flightCheck == 1){
				p.m_skinLaserBig.x = p.m_skin.x + 5
				p.m_skinLaserBig.y = p.m_skin.y + 60
				p.m_skinLaserSmall.x = 2000
				p.m_skinLaserSmall.y = 2000
			}
			if(p.flightCheckRed == 0){
				p.m_skinLaserSmallRed.x = p.m_skinRed.x + 5
				p.m_skinLaserSmallRed.y = p.m_skinRed.y +10
				p.m_skinLaserBigRed.x = 2000
				p.m_skinLaserBigRed.y = 2000
			}else if(p.flightCheckRed == 1){
				p.m_skinLaserBigRed.x = p.m_skinRed.x + 5
				p.m_skinLaserBigRed.y = p.m_skinRed.y + 60
				p.m_skinLaserSmallRed.x = 2000
				p.m_skinLaserSmallRed.y = 2000
			}
		}
		
		/*
		*	Initiation code for countdown
		*/
		
		private function m_initCountDown():void{
			this.countDown = new countDownGFX;
			this.countDown.x = 400;
			this.countDown.y = 300
			this.m_hudLayer.addChild(this.countDown);
			countSound.play();
			this.countFlag = true;
			
			p.m_skinShadow.y = 450;
			p.m_skinShadow.x = -400;
			p.m_skin.y = 440;
			p.m_skin.x = -400;
			p.m_skinShadowRed.x = -400;
			p.m_skinShadowRed.y = 530;
			p.m_skinRed.x = -400;
			p.m_skinRed.y = 520;
			
		}
		
		/*
		*	Initiation code for goal
		*/
		
		private function m_initGoal():void{
			this.goal = new goalGFX;
			this.goal.x = 800;
			this.goal.y = -90;
			this.goal.scaleX = 1.3
			this.goal.scaleY = 1.3
			this.goal2 = new goalGFX;
			this.goal2.x = 1050;
			this.goal2.y = 0;
			this.goal2.scaleX = 1.3
			this.goal2.scaleY = 1.3
		}
		
		/*
		*	Code for distance measure
		*/
		
		private function measureDistance():void{
			this.distance += p.speed * p.speed / 400;
			this.distanceRed += p.speedRed * p.speedRed / 400;
		}
		
		/*
		*	Function for activating goal
		*/
		
		private function goalCheck():void{
			if(this.distance >= 1200){
				this.goal.x += p.speed;
				this.goal.y -= p.speed * 0.75;
			}
			if(this.distanceRed >= 1200){
				this.goal2.x += p.speedRed;
				this.goal2.y -= p.speedRed * 0.75;
			}
			
		}
		
		/*
		*	Initiation code for sound
		*/
		
		private function m_initSounds():void{
			Session.sound.soundChannel.sources.add("crashsound", CrashSoundFile); 
			crashSound = Session.sound.soundChannel.get("crashsound"); 
			crashSound.volume = 0.35;
			
			Session.sound.musicChannel.sources.add("musicsound", MusicSoundFile); 
			musicSound = Session.sound.musicChannel.get("musicsound"); 
			musicSound.volume = 0.35;
			musicSound.play(2);
			
			Session.sound.soundChannel.sources.add("countsound", CountSoundFile); 
			countSound = Session.sound.soundChannel.get("countsound"); 
			countSound.volume = 0.35;
			
		}
		
		/*
		*	Update code for track scrolling
		*/
		
		private function updateTrack():void{
			if (p != null && tr != null){
				tr.scroll(p.speed,p.speed,p.speedRed,p.speedRed);
			}
		}
		
		/*
		*	function for Hitdetection on walls
		*/
		
		private function updateWall():void{
			if (p != null){
				p.m_wallDetection(p,p.m_skinShadow); 
				
			}
		}
		
		/*
		*	Update code for hitdetection and track replacement
		*/
		
		private function updateObstacle():void{
			if (ob != null && p != null){ 
				if (this.randomNr == 0 || this.randomNr == 1){
					ob.obstacleScroll(p.speed,p.speed);
					if (ob.allObstacles[0].y >= 600){
						ob.allObstacles.push(ob.allObstacles.shift());
						
						if(ob.allObstacles[this.randomNrOb] == ob.m_brickWallWhole0 || ob.allObstacles[this.randomNrOb] == ob.m_brickWallWhole1){
							ob.randomNrPlacement = 1;
						}else{
							ob.randomNrPlacement = Math.floor( Math.random() * 3 );
						}
						
						ob.allObstacles[this.randomNrOb].x = ob.m_obstacleRandomGroundx[ob.randomNrPlacement] +220;
						ob.allObstacles[this.randomNrOb].y = -340;
						this.randomNr = 2
						this.randomNrOb = Math.floor( Math.random() * 3 );
						 
					}
				}else{
					obAir.obstacleScroll(p.speed,p.speed);
					if (obAir.allObstacles[0].y >= 600){
						this.randomNr = Math.floor( Math.random() * 2 );
						obAir.randomNrPlacement = Math.floor( Math.random() * 3 );

						obAir.allObstacles.push(obAir.allObstacles.shift());
						obAir.allObstaclesShadow.push(obAir.allObstaclesShadow.shift());
						
						obAir.allObstacles[this.randomNr].x = obAir.m_obstacleRandomAirx[obAir.randomNrPlacement] +200;
						obAir.allObstacles[this.randomNr].y = -300;	 
						obAir.allObstaclesShadow[this.randomNr].x = obAir.m_obstacleRandomAirx[obAir.randomNrPlacement] +200;
						obAir.allObstaclesShadow[this.randomNr].y = -200;	
						this.randomNr = 0;
					}
				}
			}
				/*
					Track 2 Obstacles
				*/
				if (ob2 != null && p != null){ 
					if (this.randomNr2 == 0 || this.randomNr2 == 1){
						ob2.obstacleScroll(p.speedRed,p.speedRed);
						if (ob2.allObstacles[0].y >= 900){
							ob2.allObstacles.push(ob2.allObstacles.shift());
							
							
							if(ob2.allObstacles[this.randomNrOb2] == ob2.m_brickWallWhole0 || ob2.allObstacles[this.randomNrOb2] == ob2.m_brickWallWhole1){
								ob2.randomNrPlacement = 1;
							}else{
								ob2.randomNrPlacement = Math.floor( Math.random() * 3 );
							}
							
							ob2.allObstacles[this.randomNrOb2].x = ob2.m_obstacleRandomGroundx[ob2.randomNrPlacement] + 200;
							ob2.allObstacles[this.randomNrOb2].y = -80;
							this.randomNr2 = 2;
							this.randomNrOb2 = Math.floor( Math.random() * 3 );
							
						}
					}else{
						obAir2.obstacleScroll(p.speedRed,p.speedRed);
						if (obAir2.allObstacles[0].y >= 900){

							this.randomNr2 = Math.floor( Math.random() * 2);
							obAir2.randomNrPlacement = Math.floor( Math.random() * 3 );

							obAir2.allObstacles.push(obAir2.allObstacles.shift());
							obAir2.allObstaclesShadow.push(obAir2.allObstaclesShadow.shift());
							
							obAir2.allObstacles[this.randomNr2].x = obAir2.m_obstacleRandomAirx[obAir2.randomNrPlacement] +200;
							obAir2.allObstacles[this.randomNr2].y = -40;	 
							obAir2.allObstaclesShadow[this.randomNr2].x = obAir2.m_obstacleRandomAirx[obAir2.randomNrPlacement] +200;
							obAir2.allObstaclesShadow[this.randomNr2].y = 60;
							
							this.randomNr2 = 0
						}
					}
				if(ob.allObstacles[0].hitTestObject(p.m_skin) == true){ 
					
					if(p.flightCheck == 0){
						if(ob.allObstacles[0] == ob.m_brickWall0){
							this.blueCrashFlag = true;
							crashSound.play();
							if(this.life == 1){
								p.m_skinExplosion.x = p.m_skin.x;
								p.m_skinExplosion.y = p.m_skin.y;
							}
						}else if(ob.allObstacles[0] == ob.m_brickWallWhole0){
							this.blueCrashFlag = true;
							crashSound.play();
							if(this.life == 1){
								p.m_skinExplosion.x = p.m_skin.x;
								p.m_skinExplosion.y = p.m_skin.y;
							}
						}else if(ob.allObstacles[0] == ob.m_brickWallWhole1){
							this.blueCrashFlag = true;
							crashSound.play();
							if(this.life == 1){
								p.m_skinExplosion.x = p.m_skin.x;
								p.m_skinExplosion.y = p.m_skin.y;
							}
						}
						
					}
				}
				if(obAir.allObstacles[0].hitTestObject(p.m_skin) == true){
					
					if(p.flightCheck == 1){
						
						if(obAir.allObstacles[0] == obAir.m_brickWallAir0){
							this.blueCrashFlag = true;
							crashSound.play();
							if(this.life == 1){
								p.m_skinExplosion.x = p.m_skin.x;
								p.m_skinExplosion.y = p.m_skin.y;
							}
						}else if(obAir.allObstacles[0] == obAir.m_forceFieldAir0){
							this.blueCrashFlag = true;
							crashSound.play();
							if(this.life == 1){
								p.m_skinExplosion.x = p.m_skin.x;
								p.m_skinExplosion.y = p.m_skin.y;
							}
						}
					}
				}
				if(p.m_skinShadow.hitTestObject(this.goal) == true){
					this.goalFlag = true;
				}
				
				/*
					Hitdetection for Red player
				
				*/
				if(ob2.allObstacles[0].hitTestObject(p.m_skinRed) == true){ 
					if(p.flightCheckRed == 0){
						if(ob2.allObstacles[0] == ob2.m_brickWall0){
							this.redCrashFlag = true;
							crashSound.play();
							if(this.lifeRed == 1){
								p.m_skinExplosion.x = p.m_skinRed.x;
								p.m_skinExplosion.y = p.m_skinRed.y;
							}
						}else if(ob2.allObstacles[0] == ob2.m_brickWallWhole0){
							this.redCrashFlag = true;
							crashSound.play();
							if(this.lifeRed == 1){
								p.m_skinExplosion.x = p.m_skinRed.x;
								p.m_skinExplosion.y = p.m_skinRed.y;
							}
						}else if(ob2.allObstacles[0] == ob2.m_brickWallWhole1){
							this.redCrashFlag = true;
							crashSound.play();
							if(this.lifeRed == 1){
								p.m_skinExplosion.x = p.m_skinRed.x;
								p.m_skinExplosion.y = p.m_skinRed.y;
							}
						}
						
					}
				}
				if(obAir2.allObstacles[0].hitTestObject(p.m_skinRed) == true){  
					
					if(p.flightCheckRed == 1){
						
						if(obAir2.allObstacles[0] == obAir2.m_brickWallAir0){
							this.redCrashFlag = true;
							crashSound.play();
							if(this.lifeRed == 1){
								p.m_skinExplosion.x = p.m_skinRed.x;
								p.m_skinExplosion.y = p.m_skinRed.y;
							}
						}else if(obAir2.allObstacles[0] == obAir2.m_forceFieldAir0){
							this.redCrashFlag = true;
							crashSound.play();
							if(this.lifeRed == 1){
								p.m_skinExplosion.x = p.m_skinRed.x;
								p.m_skinExplosion.y = p.m_skinRed.y;
							}
						}
					}
				}
				if(p.m_skinShadowRed.hitTestObject(this.goal2) == true){
					this.goalFlagRed = true;
				}
				
			}
		}   
		
		/*
		*	Update code for HUD
		*/
		private function updateSpeedHud():void{
			this.tempSpeed = p.speed * p.speed;
			h.speedHud.speedHudText.text =  tempSpeed.toFixed() + " km/h";
			this.tempSpeed = p.speedRed * p.speedRed;
			h.speedHud2.speedHudText.text =  tempSpeed.toFixed() + " km/h";
		} 
		 
		/*
		*	Initiation code for layers
		*/
		
		private function m_initLayers():void{
			this.m_bgLayer = this.layers.add("background");
			this.m_trackLayer = this.layers.add("track");
			this.m_obstacleLayer = this.layers.add("obstacle");
			this.m_gameLayer = this.layers.add("game");
			this.m_obstacleLayerAir = this.layers.add("obstacleair");
			this.m_hudLayer = this.layers.add("hud");
			
		}
	}
}