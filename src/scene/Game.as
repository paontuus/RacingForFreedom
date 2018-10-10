package scene
{
	//import flash.geom.Point;
	
	import flash.display.MovieClip;
	import flash.utils.getTimer;
	
	import asset.countDownGFX;
	import asset.goalGFX;
	
	import backgroundelem.Background;
	
	import hud.Hud;
	
	import obstacle.Obstacle;
	
	import obstacleair.Obstacleair;
	
	import player.Player;
	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	
	import track.Track;
	
	public class Game extends DisplayState
	{
		private var m_gameLayer:DisplayStateLayer;
		private var m_bgLayer:DisplayStateLayer;
		private var m_trackLayer:DisplayStateLayer;
		private var m_obstacleLayer:DisplayStateLayer;
		private var m_obstacleLayerAir:DisplayStateLayer;
		private var m_hudLayer:DisplayStateLayer;
		private var m_gameShadowLayer:DisplayStateLayer;
		private var tr:Track;
		private var p:Player;
		private var bg:Background
		private var ob:Obstacle;
		private var obAir:Obstacleair;
		private var h:Hud;
		private var goal:MovieClip;
		private var countDown:MovieClip;
		private var time:Number;
		private var timer:uint;
		private var timerSec:uint = 0;
		private var timerMin:uint = 0 ;
		private var timerHour:uint = 0;
		private var timerFlag:Boolean;
		private var tempSpeed:Number;
		private var tempDistance:Number = 0;
		private var distance:Number = 0;
		private var distanceLeft:Number = 1000;
		private var timerStarted:Boolean = false;
		private var soundFlag:Boolean = false;
		private var goalFlag:Boolean = false;
		private var goalCounter:int = 0;
		private var soundCounter:int = 0;
		private var stopCounter:int = 0;
		private var countFlag:Boolean = false;
		private var countCounter:int;
		private var endScore:Number = 99999999;
		private var score:Number;
		private var finishScore:Number;
		private var randomNr:Number = Math.floor( Math.random() * 2 );
		
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
		
		public function Game()
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
			
			tr = new Track(); 
			
			ob = new Obstacle();
			
			obAir = new Obstacleair();
			
			p = new Player();
			p.x = 150;
			p.y = 450;
			
			h = new Hud();
			
			this.m_bgLayer.addChild(bg);
			this.m_trackLayer.addChild(tr);
			this.m_obstacleLayer.addChild(this.goal);
			this.m_obstacleLayer.addChild(ob);
			this.m_gameLayer.addChild(p);
			this.m_obstacleLayerAir.addChild(obAir);
			this.m_hudLayer.addChild(h);
			  
			this.m_initCountDown();
			
			//this.timer = Session.timer.create(500, this.clock);

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
				this.m_obstacleLayer.removeChild(this.goal);
				this.m_obstacleLayer = null;
				this.ob.dispose();
				this.ob = null;
				this.goal = null;
				
			}
			if(this.m_gameLayer != null){
				this.m_gameLayer.removeChild(p);
				this.m_gameLayer = null;
				this.p.dispose();
				this.p = null;
				
			}
			if(this.m_obstacleLayerAir != null){
				this.m_obstacleLayerAir.removeChild(obAir);
				this.m_obstacleLayerAir = null;
				this.obAir.dispose();
				this.obAir = null;
			}
			if(this.m_hudLayer != null){
				this.m_hudLayer.removeChild(h);
				h.dispose();
				h = null;
				
				this.m_hudLayer = null;
				
			}
			
			this.CrashSoundFile = null;
			this.crashSound = null;
			this.MusicSoundFile = null;
			this.musicSound = null;
			this.CountSoundFile = null
			this.countSound = null;
			this.countDown = null;
			
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
			h.updateBar(this.distance);
			
			this.score = this.endScore / elapsed;
		}
		
		/*
		*	Delay code
		*/
		
		private function timeChecks():void{
			if(timerFlag == true){
				this.timer++
				if(this.timer == 60){
					this.timer = 0;
					this.timerSec++;
					if(this.timerSec == 60){
						this.timerSec = 0;
						this.timerMin++;
					}
					
				}
			}
			
			if(soundFlag == true){
				this.soundCounter++;
				this.stopCounter++;
				if(this.soundCounter == 60){
					this.soundCounter = 0;
					this.soundFlag = false;
					Session.application.displayState = new Gameover();
					
				}
				if(this.stopCounter == 10){
					p.speed = 0;
					p.m_controls = null;
				}
				if(this.stopCounter == 1){
					crashSound.play();
				}
			}
			if(goalFlag == true){
				this.goalCounter++;
				this.stopCounter++;
				if(this.goalCounter == 30){
					this.soundCounter = 0;
					this.soundFlag = false;
					h.pointsHud.speedHudText.text = "Your score:  " + this.score.toFixed();
					h.pointsHud.visible = true;
					h.timeHud.visible = false;
					Session.highscore.smartSend(1,this.finishScore,10,onSubmitComplete)
				}
				if(this.stopCounter == 10){
					p.speed = 0;
					p.m_controls = null;
				}
				if(this.stopCounter == 1){
				}
			}
			if(countFlag == true){
				this.countCounter++;
				if(this.countCounter == 130){
					this.soundCounter = 0;
					this.soundFlag = false;
					p.m_controls = new EvertronControls(0);
					p.y = 450;
					p.x = 150;
					this.m_hudLayer.removeChild(this.countDown);
					this.timerFlag = true;
					this.m_hudLayer.addChild(h.pointsHud);
					h.pointsHud.visible = false;
					this.m_hudLayer.addChild(h.timeHud);
					this.m_initClock();
					
				}
			}
			
		}
		
		/*
		*	Countdown function
		*/
		
		private function m_initCountDown():void{
			this.countDown = new countDownGFX;
			this.countDown.x = 400;
			this.countDown.y = 300
			this.m_hudLayer.addChild(this.countDown);
			countSound.play();
			this.countFlag = true;   
			
			p.y = 450;
			p.x = -400;
			
		}
		
		/*
		*	Initiation code for goal
		*/
		
		private function m_initGoal():void{
			this.goal = new goalGFX;
			this.goal.x = 930;
			this.goal.y = -90;
			this.goal.scaleX = 1.3
			this.goal.scaleY = 1.3
		}
		
		/*
		*	Function for distance measure
		*/
		
		private function measureDistance():void{
			
			this.distance += p.speed * p.speed / 400;
		}
		
		/* 
		*	Function for activating goal
		*/
		
		private function goalCheck():void{
			if(this.distance >= 1000){
				this.goal.x += p.speed;
				this.goal.y -= p.speed * 0.75;
				
			}
			
		}
		
		/*
		*	Highscore smartsend function
		*/
		
		private function onSubmitComplete(data:XML):void{
			Session.application.displayState = new Winnerscreen();
		}
		
		/*
		*	Timer code
		*/
		
		private function m_initClock():void{
			this.time = getTimer();
			this.timerStarted = true;
		}
		
		/*
		*	Elapsed timer code
		*/
		
		private function get elapsed():int { 
			return timerStarted ? getTimer() - time : 0; 
		}
		
		/*
		*	Initiation code for sound
		*/
		
		private function m_initSounds():void{   
			Session.sound.soundChannel.sources.add("crashsound", CrashSoundFile); 
			crashSound = Session.sound.soundChannel.get("crashsound"); 
			crashSound.volume = 0.11;
			
			Session.sound.musicChannel.sources.add("musicsound", MusicSoundFile); 
			musicSound = Session.sound.musicChannel.get("musicsound"); 
			musicSound.volume = 0.5;
			musicSound.play(2);
			
			Session.sound.soundChannel.sources.add("countsound", CountSoundFile); 
			countSound = Session.sound.soundChannel.get("countsound"); 
			countSound.volume = 0.5;
			
		}
		
		/*
		*	Update code for tracks
		*/
		
		private function updateTrack():void{
			if (p != null && tr != null){
				tr.scroll(p.speed,p.speed);
			}
		}
		
		/*
		*	Update code for walldetection
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
				p.currentSpeed = p.speed;
				if (this.randomNr == 0){
					ob.obstacleScroll(p.speed,p.speed);
					if (ob.allObstacles[0].y >= 700){
						ob.allObstacles[0].x = 2000; 
						ob.allObstacles[0].y = 2000;
						this.randomNr = Math.floor( Math.random() * 3 );
						ob.allObstacles.push(ob.allObstacles.shift());
	 
						if(ob.allObstacles[this.randomNr] == ob.m_brickWallWhole0 || ob.allObstacles[this.randomNr] == ob.m_brickWallWhole1){
							ob.randomNrPlacement = 1;
						}else{  
							ob.randomNrPlacement = Math.floor( Math.random() * 3 );
						}
						
						ob.allObstacles[this.randomNr].x = ob.m_obstacleRandomGroundx[ob.randomNrPlacement];
						ob.allObstacles[this.randomNr].y = -100;
						this.randomNr = Math.floor( Math.random() * 2 );
						    
					}    
				}else{
					obAir.obstacleScroll(p.speed,p.speed);
					if (obAir.allObstacles[0].y >= 700){
						obAir.allObstacles[0].x = 2000;
						obAir.allObstacles[0].y = 2000;
						obAir.allObstaclesShadow[0].x = 2000;
						obAir.allObstaclesShadow[0].y = 2000;
						this.randomNr = Math.floor( Math.random() * 2 );
						obAir.randomNrPlacement = Math.floor( Math.random() * 3 );
						obAir.allObstacles.push(obAir.allObstacles.shift());
						obAir.allObstaclesShadow.push(obAir.allObstaclesShadow.shift());
						obAir.allObstacles[this.randomNr].x = obAir.m_obstacleRandomAirx[obAir.randomNrPlacement];
						obAir.allObstacles[this.randomNr].y = -110;	 
						obAir.allObstaclesShadow[this.randomNr].x = obAir.m_obstacleRandomAirx[obAir.randomNrPlacement] +30;
						obAir.allObstaclesShadow[this.randomNr].y = -20;	
					}
				}
				if(ob.allObstacles[0].hitTestObject(p.m_skin) == true){  
					if(p.flightCheck == 0){
						if(ob.allObstacles[0] == ob.m_brickWall0){
							p.m_skinExplosion.x = p.m_skin.x;
							p.m_skinExplosion.y = p.m_skin.y;
							this.soundFlag = true;
						}else if(ob.allObstacles[0] == ob.m_brickWallWhole0){
							p.m_skinExplosion.x = p.m_skin.x; 
							p.m_skinExplosion.y = p.m_skin.y;
							this.soundFlag = true;
						}
						else if(ob.allObstacles[0] == ob.m_brickWallWhole1){
							p.m_skinExplosion.x = p.m_skin.x; 
							p.m_skinExplosion.y = p.m_skin.y;
							this.soundFlag = true;
						}
						
					}
				}else if(obAir.allObstacles[0].hitTestObject(p.m_skin) == true){
					
					if(p.flightCheck == 1){
						
						if(obAir.allObstacles[0] == obAir.m_brickWallAir0){
							p.m_skinExplosion.x = p.m_skin.x;
							p.m_skinExplosion.y = p.m_skin.y;
							this.soundFlag = true;
						}else if(obAir.allObstacles[0] == obAir.m_forceFieldAir0){
							p.m_skinExplosion.x = p.m_skin.x;
							p.m_skinExplosion.y = p.m_skin.y;
							this.soundFlag = true;
						}
					}
				}
				if(p.m_skinShadow.hitTestObject(this.goal) == true){
					this.finishScore = this.endScore / elapsed;
					this.goalFlag = true;
				}
				
			}
		}
		
		/*
		*	Update code for HUD
		*/
		
		private function updateSpeedHud():void{
			this.tempSpeed = p.speed * p.speed;
			h.speedHud.speedHudText.text =  this.tempSpeed.toFixed();
			this.distanceLeft -= p.speed * p.speed / 400;
			this.distanceLeft.toFixed();
			h.timeHud.speedHudText.text = "Time: "+"0" + this.timerMin + ":" + this.timerSec;
			
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