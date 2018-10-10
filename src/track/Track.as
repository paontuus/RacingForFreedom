package track
{
	import flash.display.MovieClip;
	
	import asset.trackGFX;
	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	
	public class Track extends DisplayStateLayerSprite
	{
		private var m_track:MovieClip;
		private var m_track2:MovieClip;
		private var m_track3:MovieClip;
		public var trackParts:Array;
		
		private const OFFSET_X:int = 200;
		private const OFFSET_Y:int = 450;
		
		
		public function Track()
		{
			super();
		}
		
		/*
		* Initiation code
		*/
		
		override public function init():void{
			m_initTrack();
		}
		
		/*
		* Dispose code
		*/
		
		override public function dispose():void{
			removeChild(this.m_track);
			removeChild(this.m_track2);
			removeChild(this.m_track3);
			this.m_track = null;
			this.m_track2 = null;
			this.m_track3 = null;
			this.trackParts = null;
		}
		
		/*
		* Initiation code for tracks
		*/
		
		private function m_initTrack():void{
			this.m_track = new trackGFX;
			this.m_track2 = new trackGFX;
			this.m_track3 = new trackGFX; 
			
			this.trackParts = [this.m_track,this.m_track2, this.m_track3];
			this.addChild(this.trackParts[0]); 
			this.addChild(this.trackParts[1]);
			this.addChild(this.trackParts[2]);
			
			this.trackParts[1].x = (this.trackParts[0].x+this.trackParts[0].width) - OFFSET_X;
			this.trackParts[1].y = -OFFSET_Y;
			this.trackParts[2].x = (this.trackParts[1].x+this.trackParts[1].width) - OFFSET_X;
			this.trackParts[2].y = -OFFSET_Y;
		}
		
		/*
		* Update code
		*/
		
		override public function update():void{
			this.m_updateBounds();
		}
		
		/*
		* Scroll function for tracks
		*/
		
		public function scroll(x:Number,y:Number):void{
			this.trackParts[0].x += x;
			this.trackParts[0].y -= y * 0.75;
			this.trackParts[1].x = (this.trackParts[0].x+this.trackParts[0].width) - OFFSET_X;
			this.trackParts[1].y = this.trackParts[0].y - OFFSET_Y;
			this.trackParts[2].x = (this.trackParts[1].x+this.trackParts[1].width) - OFFSET_X;
			this.trackParts[2].y = this.trackParts[1].y - OFFSET_Y;
			
		}
		
		/*
		* Code for track replacement
		*/
		
		private function m_updateBounds():void{
			if (this.trackParts[0].y >= 600){
				this.trackParts.push(this.trackParts.shift());
				this.trackParts[0].y = 150;
				this.trackParts[0].x = -200;
				
			}
			if (this.trackParts[0].x >= 1){
				
				this.trackParts[0].y = 150;
				this.trackParts[0].x = -200;

			}
			
			
			
		}
		
	}
}