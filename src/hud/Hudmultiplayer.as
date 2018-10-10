package hud
{
	import flash.display.MovieClip;
	
	import asset.distanceGFX;
	import asset.lifesGFX;
	import asset.speedHudGFX;
	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	
	public class Hudmultiplayer extends DisplayStateLayerSprite
	{
		public var speedHud:MovieClip;
		public var speedHud2:MovieClip;
		public var lifeHud:MovieClip;
		public var lifeRedHud:MovieClip;
		private var distanceHud:MovieClip;
		private var distanceHudRed:MovieClip;
		
		/*
		*	Contstructor code
		*/
		
		public function Hudmultiplayer()
		{
			super();
		}
		
		/*
		*  Initiation code
		*/
		
		override public function init():void{
			this.m_initHud();
		}
		
		/*
		*  Dispose code
		*/
		
		override public function dispose():void{
			this.removeChild(this.speedHud);
			this.removeChild(this.speedHud2);
			this.removeChild(this.lifeHud);
			this.removeChild(this.lifeRedHud);
			this.removeChild(this.distanceHud);
			this.removeChild(this.distanceHudRed);
			this.speedHud = null;
			this.speedHud2 = null;
			this.lifeHud = null;
			this.lifeRedHud = null;
			this.distanceHud = null;
			this.distanceHudRed = null;
		}
		
		/*
		*  Initiation code for HUD
		*/
		
		private function m_initHud():void{ 
			this.speedHud = new speedHudGFX; 
			this.speedHud.x = 100; 
			this.speedHud.y = 135;
			this.speedHud.scaleX = 0.8;
			this.speedHud.scaleY = 0.8;
			this.speedHud2 = new speedHudGFX; 
			this.speedHud2.x = 700; 
			this.speedHud2.y = 560;
			this.speedHud2.scaleX = 0.8;
			this.speedHud2.scaleY = 0.8;
			this.lifeHud = new lifesGFX; 
			this.lifeHud.x = 100; 
			this.lifeHud.y = 100; 
			this.lifeHud.scaleX = 0.7;
			this.lifeHud.scaleY = 0.7;
			this.lifeRedHud = new lifesGFX; 
			this.lifeRedHud.x = 700; 
			this.lifeRedHud.y = 525;
			this.lifeRedHud.scaleX = 0.7;
			this.lifeRedHud.scaleY = 0.7;
			this.distanceHud = new distanceGFX; 
			this.distanceHud.x = 102;
			this.distanceHud.y = 50;
			this.distanceHud.scaleX = 1.3;
			this.distanceHud.scaleY = 1.3;
			this.distanceHud.getChildByName("redBar").scaleX = 0.001;
			this.distanceHudRed = new distanceGFX;
			this.distanceHudRed.x = 702;
			this.distanceHudRed.y = 475;
			this.distanceHudRed.scaleX = 1.3;
			this.distanceHudRed.scaleY = 1.3;
			this.distanceHudRed.getChildByName("redBar").scaleX = 0.001;
			
			
			this.addChild(this.speedHud);
			this.addChild(this.speedHud2);
			this.addChild(this.distanceHud);
			this.addChild(this.distanceHudRed);
			this.addChild(this.lifeHud);
			this.addChild(this.lifeRedHud);
			
			
		}
		
		/*
		*  Function for scaling distance bar
		*/
		
		public function updateBar(distance:Number,distanceRed:Number):void{
			this.distanceHud.getChildByName("redBar").scaleX = distance/1200;
			this.distanceHudRed.getChildByName("redBar").scaleX = distanceRed/1200;
		}
	}
}