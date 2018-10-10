package track
{
	import flash.display.MovieClip;
	
	import asset.trackGFX;
	import asset.track2GFX;
	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	
	public class Trackmultiplayer extends DisplayStateLayerSprite
	{
		private var m_track:MovieClip;
		private var m_track2:MovieClip;
		private var m_track3:MovieClip;
		private var m_track4:MovieClip;
		private var m_track5:MovieClip;
		private var m_track6:MovieClip;
		public var trackParts:Array;
		public var trackParts2:Array;
		
		private const OFFSET_X:int = 200;
		private const OFFSET_Y:int = 450;

		/*
		*	Constructor code
		*/
		
		public function Trackmultiplayer()
		{
			super();
		}
		
		
		/*
		*	Initiation code
		*/
		override public function init():void{
			m_initTrack();
		}
		
		/*
		*	Dispose code
		*/
		
		override public function dispose():void{
			this.removeChild(this.trackParts[0]); 
			this.removeChild(this.trackParts[1]);
			this.removeChild(this.trackParts[2]);
			this.removeChild(this.trackParts2[0]); 
			this.removeChild(this.trackParts2[1]);
			this.removeChild(this.trackParts2[2]);
			this.m_track = null;
			this.m_track2 = null; 
			this.m_track3 = null;
			this.m_track4 = null;
			this.m_track5 = null;
			this.m_track6 = null;
			this.trackParts = null;
			this.trackParts2 = null;
		} 
		
		/*
		*	Update code
		*/
		
		override public function update():void{
			this.m_updateBounds();
		}
		
		/*
		*	initiation code for tracks
		*/
		
		private function m_initTrack():void{ 
			this.m_track = new trackGFX;
			this.m_track2 = new trackGFX;
			this.m_track3 = new trackGFX;
			this.m_track4 = new track2GFX;
			this.m_track5 = new track2GFX;
			this.m_track6 = new track2GFX;
			
			
			this.trackParts = [this.m_track,this.m_track2, this.m_track3];
			this.trackParts2 = [this.m_track4,this.m_track5, this.m_track6];
			this.addChild(this.trackParts[0]); 
			this.addChild(this.trackParts[1]);
			this.addChild(this.trackParts[2]);
			this.addChild(this.trackParts2[0]); 
			this.addChild(this.trackParts2[1]);
			this.addChild(this.trackParts2[2]);
			this.trackParts[0].x = -160;
			this.trackParts[0].y = 20;
			this.trackParts[1].x = (this.trackParts[0].x+this.trackParts[0].width) - OFFSET_X;
			this.trackParts[1].y = -OFFSET_Y;
			this.trackParts[2].x = (this.trackParts[1].x+this.trackParts[1].width) - OFFSET_X;
			this.trackParts[2].y = -OFFSET_Y;
			this.trackParts2[0].x = 20;
			this.trackParts2[0].y = 160;
			this.trackParts2[1].x = (this.trackParts2[0].x+this.trackParts2[0].width) - OFFSET_X;
			this.trackParts2[1].y = -OFFSET_Y;
			this.trackParts2[2].x = (this.trackParts2[1].x+this.trackParts2[1].width) - OFFSET_X;
			this.trackParts2[2].y = -OFFSET_Y;
		}
		
		/*
		*	Function for scrolling tracks
		*/
		
		public function scroll(x:Number,y:Number,xRed:Number,yRed:Number):void{
			this.trackParts[0].x += x;
			this.trackParts[0].y -= y * 0.75;
			this.trackParts[1].x = (this.trackParts[0].x+this.trackParts[0].width) - OFFSET_X;
			this.trackParts[1].y = this.trackParts[0].y - OFFSET_Y;
			this.trackParts[2].x = (this.trackParts[1].x+this.trackParts[1].width) - OFFSET_X;
			this.trackParts[2].y = this.trackParts[1].y - OFFSET_Y;
			this.trackParts2[0].x += xRed;
			this.trackParts2[0].y -= yRed * 0.75;
			this.trackParts2[1].x = (this.trackParts2[0].x+this.trackParts2[0].width) - OFFSET_X;
			this.trackParts2[1].y = this.trackParts2[0].y - OFFSET_Y;
			this.trackParts2[2].x = (this.trackParts2[1].x+this.trackParts2[1].width) - OFFSET_X;
			this.trackParts2[2].y = this.trackParts2[1].y - OFFSET_Y;
			
		}
		
		/*
		*	Function for track replacement
		*/
		
		private function m_updateBounds():void{
			if (this.trackParts[0].y >= 600){
				this.trackParts.push(this.trackParts.shift());
			}
			if (this.trackParts[0].x >= -160){
				
				this.trackParts[0].x = -160;
				this.trackParts[0].y = 20;
			}
			if (this.trackParts2[0].y >= 900){
				this.trackParts2.push(this.trackParts2.shift());
			}
			if (this.trackParts2[0].x >= 20){

				this.trackParts2[0].x = 20;
				this.trackParts2[0].y = 160;
			}
		}
		
	}
}