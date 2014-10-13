package com.danielfreeman.extendedMadness
{
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class UITouch extends UIContainerBaseClass {
		
		protected var _up:UIForm;
		protected var _down:UIForm;
		
		public function UITouch(screen:Sprite, xml:XML, attributes:Attributes) {
			super(screen, xml, attributes);
			var childAttributes:Attributes = attributes.copy(xml);
			_up = new UI.FormClass(this, <up>{xml.children()[0]}</up>, childAttributes);
			_down = new UI.FormClass(this, <down>{xml.children()[1]}</down>, childAttributes);
			_down.visible = false;
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		}
		
		
		override public function touchCancel():void {
			mouseUp();
		}
		
		
		override public function layout(attributes:Attributes):void {
			var childAttributes:Attributes = attributes.copy(_xml);
			_up.layout(childAttributes);
			_down.layout(childAttributes);
		}
		
		
		protected function mouseDown(event:MouseEvent):void {
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			_up.visible = false;
			_down.visible = true;
		}
		
		
		protected function mouseUp(event:MouseEvent = null):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			_up.visible = true;
			_down.visible = false;
		}
		
		
		override public function destructor():void {
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
	}
}