package com.danielfreeman.madcomponents
{
	
	import flash.display.Sprite;
	import flash.display.DisplayObject;

	public class UIContainerBaseClass extends MadSprite implements IContainerUI {
		
		protected var _xml:XML;
		
		
		public function UIContainerBaseClass(screen:Sprite, xml:XML, attributes:Attributes) {
			_xml = xml;
		//	_attributes = attributes;
		//	screen.addChild(this);
			super(screen, attributes);
			initialise(xml, attributes);
			drawComponent();
		}
		
		
		override public function layout(attributes:Attributes):void {
			super.layout(attributes);
			drawComponent();
		}
		
		
		protected function initialise(xml:XML, attributes:Attributes):void {
		}
		
		
		public function drawComponent():void {	
		}
		
		
		public function get xml():XML {
			return _xml;
		}
		
		
		public function findViewById(id:String, row:int = -1, group:int = -1):DisplayObject {
			return getChildByName(id);
		}
		
		
		public function clear():void {
			graphics.clear();
		}
		
		
		public function get pages():Array {
			return [];
		}
	}
}