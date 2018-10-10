package obstacleair
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	import se.lnu.stickossdk.system.Session;
	
	public class Solidobject extends DisplayStateLayerSprite
	{
		private var m_skin:MovieClip;
		private var m_hitboxes:Vector.<Rectangle> = new Vector.<Rectangle>();
		
		/*
		*	Constructor code
		*/
		
		public function Solidobject(skin:Class) {
			this.m_initSkin(skin);
			this.m_initHitboxes();
		}
		
		/*
		*	Dispose code
		*/
		
		override public function dispose():void{
			this.removeChild(this.m_skin);
			this.m_skin = null;
			this.m_hitboxes = null;
		}
		
		/*
		*	Hitbox replacement code
		*/
		
		override public function hitTestObject(obj:DisplayObject):Boolean {
			var a:Rectangle = obj.getRect(Session.application.stage);
			var b:Rectangle = this.getRect(Session.application.stage);
			var c:Rectangle = new Rectangle();
			
			for (var i:int = 0; i < this.m_hitboxes.length; i++) {
				c = this.m_hitboxes[i].clone();
				c.x += b.x;
				c.y += b.y;
				
				if(c.intersects(a)) return true;
			}
			
			return false;
		}
		
		/*
		*	add hitbox code
		*/
		
		public function addHitbox(hitbox:Rectangle):void {
			this.m_hitboxes.push(hitbox);
		}
		
		/*
		*	remove hitbox code
		*/
		
		public function clearHitboxes():void {
			this.m_hitboxes.length = 0;
		}
		
		
		/*
		*	Initiation code for skin
		*/
		
		private function m_initSkin(skin:Class):void {
			this.m_skin = new skin() as MovieClip;
			this.addChild(this.m_skin);
		}
		
		/*
		*	Initiation code for hitboxes
		*/
		
		private function m_initHitboxes():void {
			this.addHitbox(new Rectangle(
				0, 
				0, 
				this.m_skin.width,
				this.m_skin.height
			));
		}
	}
}