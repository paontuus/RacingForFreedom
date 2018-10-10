package obstacleair
{
	
	import flash.geom.Rectangle;
	
	import asset.brickWallAirGFX;
	import asset.brickWallAirShadowTransGFX;
	import asset.forceFieldWallAirGFX;
	import asset.forceFieldWallAirShadowTransGFX;
	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	
	public class Obstacleair extends DisplayStateLayerSprite
	{
		
		public var m_brickWallAir0:Solidobject;
		public var m_forceFieldAir0:Solidobject;
		
		public var m_brickWallAirShadow0:brickWallAirShadowTransGFX;
		public var m_forceFieldAirShadow0:forceFieldWallAirShadowTransGFX;
		
		public var m_obstacleRandomAirx:Vector.<Number>;
		public var m_obstacleRandomAirShadowx:Vector.<Number>;
		
		public var allObstacles:Array;
		public var allObstaclesMultiplayer:Array;
		public var allObstaclesShadow:Array;
		
		private var m_obstacleRandomAirx1:Number = 705;
		private var m_obstacleRandomAirx2:Number = 780;
		private var m_obstacleRandomAirx3:Number = 850;
		private var m_obstacleRandomAirShadowx1:Number = 805;
		private var m_obstacleRandomAirShadowx2:Number = 880;
		private var m_obstacleRandomAirShadowx3:Number = 950;
		
		private var randomNr:Number;
		public var randomNrPlacement:Number;
		public var randomNrCheck:Number;
		private var airGroundCheck:Number 
		
		public const OFFSET_X:int = 200;
		public const OFFSET_Y:int = 450;
		
		/*
		*	Constructor code
		*/
		
		public function Obstacleair()
		{
			super();
		}
		
		/*
		*	Initiation code
		*/
		
		override public function init():void{
			this.m_initObstacle();
		}
		
		/*
		*	Dispose code
		*/
		
		override public function dispose():void{
			this.removeChild(this.allObstacles[0]);
			this.removeChild(this.allObstacles[1]);
			this.removeChild(this.allObstaclesShadow[0]);
			this.removeChild(this.allObstaclesShadow[1]);
			this.m_brickWallAir0.dispose();
			this.m_forceFieldAir0.dispose();
			this.m_brickWallAir0 = null;
			this.m_forceFieldAir0 = null;
			this.m_brickWallAirShadow0 = null;
			this.m_forceFieldAirShadow0 = null;
			this.m_obstacleRandomAirx = null;
			this.m_obstacleRandomAirShadowx = null;
			this.allObstacles = null;
			this.allObstaclesShadow = null;
		}
		
		/*
		*	Initiation code for obstacles
		*/
		
		private function m_initObstacle():void{
			
			this.m_brickWallAir0 = new Solidobject(brickWallAirGFX);
			this.m_brickWallAir0.clearHitboxes();
			this.m_brickWallAir0.addHitbox(new Rectangle(20, 19, 40, 40));
			this.m_brickWallAir0.scaleY = 0.8;
			this.m_brickWallAir0.scaleX = 0.8;
			this.m_brickWallAirShadow0 = new brickWallAirShadowTransGFX; 
			this.m_brickWallAirShadow0.scaleY = 0.5;
			this.m_brickWallAirShadow0.scaleX = 0.5;
			
			this.m_forceFieldAir0 = new Solidobject(forceFieldWallAirGFX);
			this.m_forceFieldAir0.clearHitboxes();
			this.m_forceFieldAir0.addHitbox(new Rectangle(14, 20, 50, 50));
			this.m_forceFieldAir0.addHitbox(new Rectangle(80, 58, 50, 50));
			this.m_forceFieldAir0.addHitbox(new Rectangle(150, 100, 50, 50));
			this.m_forceFieldAirShadow0 = new forceFieldWallAirShadowTransGFX;
			this.m_forceFieldAirShadow0.scaleX = 1.5
			this.m_forceFieldAirShadow0.scaleY = 1.5
			
			
			this.allObstacles = [this.m_brickWallAir0, this.m_forceFieldAir0];
			this.allObstaclesShadow = [this.m_brickWallAirShadow0, this.m_forceFieldAirShadow0];
			
			this.addChild(this.allObstaclesShadow[0]);
			this.addChild(this.allObstaclesShadow[1]);
			this.addChild(this.allObstacles[0]);
			this.addChild(this.allObstacles[1]);
			
			
			this.allObstacles[0].x = 2000;
			this.allObstacles[0].y = 2000;
			this.allObstacles[1].x = 2000;
			this.allObstacles[1].y = 2000;

			this.allObstaclesShadow[0].x = 2000;
			this.allObstaclesShadow[0].y = 2000;
			this.allObstaclesShadow[1].x = 2000;
			this.allObstaclesShadow[1].y = 2000;

			
			
			this.m_obstacleRandomAirx = new <Number>[this.m_obstacleRandomAirx1,this.m_obstacleRandomAirx2, this.m_obstacleRandomAirx3];
			this.m_obstacleRandomAirShadowx = new <Number>[this.m_obstacleRandomAirShadowx1,this.m_obstacleRandomAirShadowx2, this.m_obstacleRandomAirShadowx3];
			
			
		}
		
		/*
		*	Function for scrolling obstacles
		*/
		
		public function obstacleScroll(x:Number,y:Number):void{
			this.allObstacles[0].x += x;
			this.allObstacles[0].y -= y * 0.75;
			this.allObstaclesShadow[0].x += x;
			this.allObstaclesShadow[0].y -= y * 0.75;
			
			
			
		}
	}
}