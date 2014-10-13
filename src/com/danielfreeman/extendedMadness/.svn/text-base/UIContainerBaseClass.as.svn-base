package com.danielfreeman.extendedMadness
{
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.Sprite;
	import flash.display.DisplayObject;

	public class UIContainerBaseClass extends MadSprite implements IContainerUI {
		
		protected var _xml:XML;
		protected var _attributes:Attributes;
		
		
		public function UIContainerBaseClass(screen:Sprite, xml:XML, attributes:Attributes) {
			_xml = xml;
			_attributes = attributes;
			screen.addChild(this);
			drawComponent();
		}
		
		
		public function layout(attributes:Attributes):void {
			_attributes = attributes;
			drawComponent();
		}
		
		
		public function drawComponent():void {	
		}
		
		
		public function get attributes():Attributes {
			return _attributes;
		}
		
		
		public function get xml():XML {
			return _xml;
		}
		
		
		public function findViewById(id:String, row:int = -1, group:int = -1):DisplayObject {
			return null;
		}
		
		
		public function clear():void {
			graphics.clear();
		}
		
		
		public function get pages():Array {
			return [];
		}
		
		
		public function destructor():void {
		}
	}
}