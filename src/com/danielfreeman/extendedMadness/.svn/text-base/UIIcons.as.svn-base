package com.danielfreeman.extendedMadness
{
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;


	public class UIIcons extends UIContainerBaseClass {

		protected var _icons:Vector.<DisplayObject>;
		protected var _timer:Timer = new Timer(50,1);
		protected var _index:int = -1;
		protected var _highlightColour:uint = UIList.HIGHLIGHT;
		
		public function UIIcons(screen:Sprite, xml:XML, attributes:Attributes) {
			if (xml.@highlightColour.length()>0)
				_highlightColour = UI.toColourValue(xml.@highlightColour);
			super(screen, xml, attributes);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			_timer.addEventListener(TimerEvent.TIMER, unHighlight);
			text = xml.toString();
		}
		
		
		protected function mouseDown(event:MouseEvent):void {
			_index = -1;
			for (var i:int = 0; i < _icons.length; i++) {
				var icon:DisplayObject = _icons[i];
				if (mouseX < icon.x + icon.width + _attributes.paddingH/2) {
					_index = i;
					highlight();
					dispatchEvent(new Event(Event.CHANGE));
					return;
				}
			}					
		}
		
		
		protected function mouseUp(event:MouseEvent):void {
			_timer.reset();
			_timer.start();
		}
		
		
		protected function highlight():void {
			var colour:ColorTransform = new ColorTransform();
			colour.color = _highlightColour;
			DisplayObject(_icons[_index]).transform.colorTransform = colour;
		}
		
		
		protected function unHighlight(event:TimerEvent):void {
			for each (var icon:DisplayObject in _icons)
				icon.transform.colorTransform = new ColorTransform();
		}
		
		
		public function get index():int {
			return _index;
		}
		
		
		public function set index(value:int):void {
			_index = value;
			highlight();
			_timer.reset();
			_timer.start();
		}
		
		
		override public function drawComponent():void {
			graphics.clear();
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, width + _attributes.paddingH, height);
		}
		
		
		public function set text(source:String):void {
			var position:Number = 0;
			var dimensions:Array = source.split(",");
			if (_icons)
				clear();
			_icons = new <DisplayObject>[];
			for (var i:int = 0; i < dimensions.length; i++) {
				var icon:DisplayObject = DisplayObject(new (getDefinitionByName(dimensions[i]) as Class));
				_icons.push(icon);
				if (icon is Bitmap) {
					Bitmap(icon).smoothing = true;
				}
				addChild(icon);
				icon.x = position;
				position += icon.width + _attributes.paddingH;
			}
			drawComponent();
		}
		
		
		override public function clear():void {
			for each (var icon:DisplayObject in _icons) {
				removeChild(icon);
			}
			graphics.clear();
			_icons = null;
		}
		
		
		public function set icons(value:Vector.<DisplayObject>):void {
			if (_icons)
				clear();
			_icons = value;
		}
	
	
		override public function destructor():void {
			removeEventListener(MouseEvent.MOUSE_UP, mouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			_timer.removeEventListener(TimerEvent.TIMER, unHighlight);
		}
	}
}
