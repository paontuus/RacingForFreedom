package obstacle
{
	
	import flash.geom.Rectangle;
	
	import asset.brickWallGroundGFX;
	import asset.brickWallWholeGFX;
	
	import obstacleair.Solidobject;
	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	
	public class Obstacle extends DisplayStateLayerSprite
	{
		public var m_brickWall0:brickWallGroundGFX;
		public var m_brickWallWhole0:Solidobject;
		public var m_brickWallWhole1:Solidobject;
		public var m_obstacleRandomGroundx:Vector.<Number>;
		public var m_obstacleRandomGroundmultiplayer1x:Vector.<Number>;
		public var m_obstacleRandomGroundmultiplayer2x:Vector.<Number>;
		protected var m_hitBoxes:Vector.<Rectangle> = new Vector.<Rectangle>();
		private var m_obstacleRandomAirx:Vector.<Number>;
		public var allObstacles:Array;
		private var m_obstacleRandomGroundx1:Number = 850;
		private var m_obstacleRandomGroundx2:Number = 910;
		private var m_obstacleRandomGroundx3:Number = 980;
		private var m_obstacleRandomGroundx4:Number = 850;
		private var m_obstacleRandomGroundx5:Number = 910;
		private var m_obstacleRandomGroundx6:Number = 980;
		private var m_obstacleRandomGroundx7:Number = 850;
		private var m_obstacleRandomGroundx8:Number = 910;
		private var m_obstacleRandomGroundx9:Number = 980;
		private var randomNr:Number;
		public var randomNrPlacement:Number;
		public var randomNrCheck:Number;
		public var obstacleCheck:Number = 0;
		private var airGroundCheck:Number = 1;
		
		private const OFFSET_X:int = 200;
		private const OFFSET_Y:int = 450;
		
		/*
		*	Constructor code
		*/
		public function Obstacle()
		{
			super();
		}
		
		/*
		*	Initiation code
		*/
		
		override public function init():void{
			this.m_initObstacle();
			this.m_initHitBoxes();
		}
		
		/*
		*	Dispose code
		*/
		
		override public function dispose():void{
			this.removeChild(this.allObstacles[0]);
			this.removeChild(this.allObstacles[1]);
			this.removeChild(this.allObstacles[2]);
			this.m_brickWallWhole0.dispose();
			this.m_brickWallWhole1.dispose();
			this.m_brickWallWhole0 = null;
			this.m_brickWallWhole1 = null;;
			this.m_brickWall0 = null;
			this.m_obstacleRandomGroundx = null;
			this.m_obstacleRandomGroundmultiplayer1x = null;
			this.m_obstacleRandomGroundmultiplayer2x = null;
			this.m_hitBoxes = null;
			this.m_obstacleRandomAirx = null;
			this.allObstacles = null;
			
		}
		
		/*
		*	Initiation code for hitboxes
		*/
		
		private function m_initHitBoxes():void{
			//var hitBox:Rectangle = new Rectangle(0,0,);
		}
		
		/*
		*	Initiation code for Obstacles
		*/
		
		private function m_initObstacle():void{
			
			this.m_brickWall0 = new brickWallGroundGFX();
			this.m_brickWallWhole0 = new Solidobject(brickWallWholeGFX);
			this.m_brickWallWhole0.clearHitboxes();
			this.m_brickWallWhole0.addHitbox(new Rectangle(0, 18, 40, 40));
			this.m_brickWallWhole0.addHitbox(new Rectangle(63, 58, 40, 40));
			this.m_brickWallWhole0.addHitbox(new Rectangle(124, 94, 40, 40));
			this.m_brickWallWhole1 = new Solidobject(brickWallWholeGFX);
			this.m_brickWallWhole1.clearHitboxes();
			this.m_brickWallWhole1.addHitbox(new Rectangle(0, 18, 40, 40));
			this.m_brickWallWhole1.addHitbox(new Rectangle(63, 58, 40, 40));
			this.m_brickWallWhole1.addHitbox(new Rectangle(124, 94, 40, 40));
			this.m_brickWall0.scaleX = 0.5;
			this.m_brickWall0.scaleY = 0.5;

			this.allObstacles = [this.m_brickWall0, this.m_brickWallWhole0, this.m_brickWallWhole1];
			
			this.addChild(this.allObstacles[0]);
			this.addChild(this.allObstacles[1]);
			this.addChild(this.allObstacles[2]);
			
			this.allObstacles[0].x = 2000;
			this.allObstacles[0].y = 2000;
			this.allObstacles[1].x = 2000;
			this.allObstacles[1].y = 2000;
			this.allObstacles[2].x = 2000;
			this.allObstacles[2].y = 2000;

			this.m_obstacleRandomGroundx = new <Number>[this.m_obstacleRandomGroundx1,this.m_obstacleRandomGroundx2, this.m_obstacleRandomGroundx3];
			this.m_obstacleRandomGroundmultiplayer1x = new <Number>[this.m_obstacleRandomGroundx1,this.m_obstacleRandomGroundx2, this.m_obstacleRandomGroundx3];
			this.m_obstacleRandomGroundmultiplayer2x = new <Number>[this.m_obstacleRandomGroundx1,this.m_obstacleRandomGroundx2, this.m_obstacleRandomGroundx3];			
			
		}
		public function obstacleScroll(x:Number,y:Number):void{
			this.allObstacles[0].x += x;
			this.allObstacles[0].y -= y * 0.75;
			
			
			
		}
	}
}