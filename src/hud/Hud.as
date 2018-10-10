package hud
{
	import flash.display.MovieClip;
	
	import asset.distanceGFX;
	import asset.speedHudGFX;
	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	
	public class Hud extends DisplayStateLayerSprite
	{
		public var speedHud:MovieClip;
		public var speedHudText:MovieClip;
		public var pointsHud:MovieClip;
		public var timeHud:MovieClip;
		private var distanceHud:MovieClip;
		public var tempHud:MovieClip;
		public function Hud()
		{
			super();
		}
		
		/*
		* Initiation code
		*/
		
		override public function init():void{
			this.m_initHud();
		}
		
		/*
		* Dispose code
		*/
		
		override public function dispose():void{
			this.removeChild(this.speedHud)
			this.speedHud = null;
			this.removeChild(this.speedHudText);
			this.speedHudText = null;
			if (this.pointsHud.parent) this.pointsHud.parent.removeChild(this.pointsHud);
			this.pointsHud = null;
			if (this.timeHud.parent) this.timeHud.parent.removeChild(this.timeHud);
			this.timeHud = null;
			this.removeChild(this.distanceHud);
			this.distanceHud = null;
		}
		
		/*
		* Initiation code for HUD
		*/
		
		private function m_initHud():void{ 

			this.speedHud = new speedHudGFX; 
			this.speedHud.x = 645; 
			this.speedHud.y = 530;
			this.timeHud = new speedHudGFX;
			this.timeHud.x = 150;
			this.timeHud.y = 100;
			this.speedHudText = new speedHudGFX; 
			this.speedHudText.x = 725;  
			this.speedHudText.y = 530;
			this.speedHudText.speedHudText.text = " km/h";
			this.pointsHud = new speedHudGFX; 
			this.pointsHud.x = 405 //375;  
			this.pointsHud.y = 130;
			this.distanceHud = new distanceGFX;
			this.distanceHud.x = 700;
			this.distanceHud.y = 475;
			this.distanceHud.scaleX = 1.5;
			this.distanceHud.scaleY = 1.5;
			
			this.distanceHud.getChildByName("redBar").scaleX = 0.001;
			     
			     
			this.addChild(this.speedHud);
			this.addChild(this.speedHudText);       
			this.addChild(this.distanceHud);
			
		} 
		
		/*
		* Updating the distance bar
		*/
		
		public function updateBar(distance:Number):void{
			this.distanceHud.getChildByName("redBar").scaleX = distance/1000;
		}
	}
}