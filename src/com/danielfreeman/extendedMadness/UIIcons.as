package com.danielfreeman.extendedMadness
{
	import flash.system.Capabilities;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.text.TextField;
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
	import flash.text.TextFormat;
	
/**
 *  MadComponents icons component
 * <pre>
 * &lt;icons
 *    id = "IDENTIFIER"
 *    highlightColour = "#rrggbb"
 *    iconColour = "#rrggbb"
 *    activeColour = "#rrggbb"
 *    background = "#rrggbb, #rrggbb, ‚Ä¶"
 *    gapV = "NUMBER"
 *    gapH = "NUMBER"
 *    alignH = "left|right|centre|fill"
 *    alignV = "top|bottom|centre|fill"
 *    visible = "true|false"
 *    border = "true|false"
 *    leftMargin = "NUMBER"
 *    pixelSnapping = "true|false"
 *    scaleHeight = "NUMBER"
 *    &lt;data&gt;LABELS&lt;/data&gt;
 *    &lt;font&gt;FORMAT&lt;/font&gt;
 *    &lt;activeFont&gt;FORMAT&lt;/activeFont&gt;
 *    &lt;disableFont&gt;FORMAT&lt;/disableFont&gt;
 * /&gt;
 * </pre>
 */	
	public class UIIcons extends MadSprite implements IComponentUI {

		protected static const COLOUR_OFFSET:Number = 0.5;
		protected static const COLOUR_FACTOR:Number = 0.5;
		protected static const DISABLED_COLOUR:uint = 0x333366;
		protected static const CENTRE_OFFSET:Number = 5;
		
		protected const LABEL_FORMAT:TextFormat = new TextFormat("Arial", 10, 0xCCCCCC);
		protected const LABEL_HIGHLIGHT:TextFormat = new TextFormat("Arial", 10, 0xFFFFFF);
		protected const LABEL_DISABLE:TextFormat = new TextFormat("Arial", 10, DISABLED_COLOUR);
		
		protected var _icons:Vector.<Bitmap>;
		protected var _timer:Timer = new Timer(50,1);
		protected var _index:int = -1;
		protected var _pressIndex:int = -1;
		protected var _iconColour:uint = uint.MAX_VALUE;
		protected var _activeColour:uint = uint.MAX_VALUE;
		protected var _highlightColour:uint = UIList.HIGHLIGHT;
		protected var _disableColour:uint = DISABLED_COLOUR;
		protected var _leftMargin:Number = 0;
		protected var _data:Vector.<String> = null;
		protected var _labels:Vector.<UILabel> = null;
		protected var _labelFormat:TextFormat = LABEL_FORMAT;
		protected var _labelHighlight:TextFormat = LABEL_HIGHLIGHT;
		protected var _labelDisable:TextFormat = LABEL_DISABLE;
		protected var _enabled:Vector.<Boolean> = null;
		protected var _pixelSnapping:Boolean;
		protected var _scaleHeight:Number = 0;
		protected var _text:String = "";
		
		
		public function UIIcons(screen:Sprite, xml:XML, attributes:Attributes) {
			
			xml = xml.copy();
			if (xml.@highlightColour.length() > 0) {
				_highlightColour = UI.toColourValue(xml.@highlightColour);
			}
			if (xml.@iconColour.length() > 0) {
				_iconColour = UI.toColourValue(xml.@iconColour);
			}
			if (xml.@activeColour.length() > 0) {
				_activeColour = UI.toColourValue(xml.@activeColour);
			}
			if (xml.@disableColour.length() > 0) {
				_disableColour = UI.toColourValue(xml.@disableColour);
			}
			if (xml.@leftMargin.length() > 0) {
				_leftMargin = parseFloat(xml.@leftMargin);
			}
			if (xml.@scaleHeight.length() > 0) {
				_scaleHeight = parseFloat(xml.@scaleHeight);
			}
			_pixelSnapping = xml.@pixelSnapping == "true" || xml.data.length() > 1;
			super(screen, attributes);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			_timer.addEventListener(TimerEvent.TIMER, unHighlight);

			if (xml.font.length() > 0) {
				_labelFormat = UIe.toTextFormat(xml.font[0] ,LABEL_FORMAT);
				delete xml.font;
			}
			if (xml.activeFont.length() > 0) {
				_labelHighlight = UIe.toTextFormat(xml.activeFont[0] ,LABEL_HIGHLIGHT);
				delete xml.activeFont;
			}
			if (xml.disableFont.length() > 0) {
				_labelDisable = UIe.toTextFormat(xml.disableFont[0] ,LABEL_DISABLE);
				delete xml.disableFont;
			}
			if (xml.data.length() > 0) {
			//	_data = new <String>[];
			//	_labels = new <UILabel>[];
			//	for each(var item:XML in xml.data.children()) {
			//		_data.push((item.@label.length() > 0) ? item.@label : item.localName());
			//	}
			//	xmlData = xml.data[0];
			//	for each (var data:XML in xml.data) {
			//		if (data.@size.length() == 0 || (String(data.@size).substr(-3,3).toUpperCase() == "DPI" && parseFloat(data.@size.substr(0,-3)) >= Capabilities.screenDPI)) {
			//			xmlData = data;
			//		}
			//	}
				extractData(xml);
				delete xml.data;
			}
			if (_text == "" && xml.toString() != "") {
				text = xml.toString().replace(/[\s\r\n\t]/g,"");
				unHighlight();
			}
			
		}
		
		
		protected function extractData(xml:XML):void {
			for each (var data:XML in xml.data) {
				if (data.@size.length() == 0) {
					xmlData = data;
					return;
				}
			/*	else if (String(data.@size).toUpperCase() == "LDPI" && Capabilities.screenDPI < 160 ) {
					xmlData = data;
					return;
				}
				else if (String(data.@size).toUpperCase() == "MDPI" && Capabilities.screenDPI < 240) {
					xmlData = data;
					return;
				}
				else if (String(data.@size).toUpperCase() == "HDPI" && Capabilities.screenDPI < 320) {
					xmlData = data;
					return;
				}
				else if (String(data.@size).toUpperCase() == "XHDPI" && Capabilities.screenDPI < 400) {
					xmlData = data;
					return;
				}
				else if (String(data.@size).toUpperCase() == "XXHDPI" && Capabilities.screenDPI >= 400) {
					xmlData = data;
					return;
				}*/
				else if (data.@size.substr(-3,3).toUpperCase() == "DPI" && parseFloat(data.@size.substr(0,-3)) >= Capabilities.screenDPI) {
					xmlData = data;
					return;
				}
			}
		}
		
		
		protected function imageAttributeText(item:XML):String {
			if (item.@ldpi.length() > 0 && Capabilities.screenDPI < 160 ) {
				_pixelSnapping = true;
				return item.@ldpi + ",";
			}
			else if (item.@mdpi.length() > 0 && Capabilities.screenDPI < 240) {
				_pixelSnapping = true;
				return item.@mdpi + ",";
			}
			else if (item.@hdpi.length() > 0 && Capabilities.screenDPI < 320) {
				_pixelSnapping = true;
				return item.@hdpi + ",";
			}
			else if (item.@xhdpi.length() > 0 && Capabilities.screenDPI < 400) {
				_pixelSnapping = true;
				return item.@xhdpi + ",";
			}
			else if (item.@xxhdpi.length() > 0 && Capabilities.screenDPI >= 400) {
				_pixelSnapping = true;
				return item.@xxhdpi + ",";
			}
			else if (item.@image.length() > 0) {
				return item.@image + ",";
			}
			else {
				return "";
			}
		}
		
		
		public function set xmlData(value:XML):void {
			if (_icons) {
				clear();
			}
			_data = new <String>[];
			_labels = new <UILabel>[];
			_text = "";
			for each(var item:XML in value.children()) {
				_data.push((item.@label.length() > 0) ? item.@label : item.localName());
			//	if (item.@image.length() > 0) {
			//		_text += item.@image + ",";
			//	}
				_text += imageAttributeText(item);
			}
			if (_text != "") {
				text = _text.substr(0, -1);
				unHighlight();
			}
		}
		
		
		public function get labels():Vector.<UILabel> {
			return _labels;
		}
		
		
		public function enable(index:int, state:Boolean):void {
		//	var colour:ColorTransform = new ColorTransform();
		//	colour.color = state ? _iconColour : _disableColour;
		//	DisplayObject(_icons[index]).transform.colorTransform = colour;
			_enabled[index] = state;
			unHighlight();
			labelHighlight();
		}
		
		
		protected function mouseDown(event:MouseEvent):void {
			_pressIndex = -1;
			for (var i:int = 0; i < _icons.length; i++) {
				var icon:DisplayObject = _icons[i];
				if (mouseX < icon.x + icon.width + _attributes.paddingH/2) {
					if (_enabled[i]) {
						_pressIndex = i;
						highlight();
					}
					break;
				}
			}
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);					
		}
		
		
		public function clearHighlight():void {
			var index:int = 0;
			for each(var label:UILabel in _labels) {
				label.setTextFormat(_enabled[index++] ? _labelFormat : _labelDisable);
			}
		}
		
		
		override public function touchCancel():void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			unHighlight();
		}
		
		
		protected function labelHighlight():void {
			clearHighlight();
			if (_labels && _index >= 0 && _index < _labels.length) {
				_labels[_index].setTextFormat(_enabled[_index] ? _labelHighlight : _labelDisable);
			}
		}
		
		
		protected function mouseUp(event:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			var index:int = -1;
			for (var i:int = 0; i < _icons.length; i++) {
				var icon:DisplayObject = _icons[i];
				if (mouseX < icon.x + icon.width + _attributes.paddingH/2) {
					if (_enabled[i]) {
						index = i;
					}
					break;
				}
			}
			if (index >=0 && _pressIndex == index) {
				_index = _pressIndex;
				dispatchEvent(new Event(Event.CHANGE));
				labelHighlight();
			}
			_timer.reset();
			_timer.start();
			_pressIndex = -1;
		}
		
		
		protected function highlight():void {
			var colour:ColorTransform = new ColorTransform();
			colour.color = _highlightColour;
			DisplayObject(_icons[_pressIndex]).transform.colorTransform = colour;
		}
		
		
		protected function newColourTransform(colour:uint):ColorTransform {
				if (colour < uint.MAX_VALUE) {
					return new ColorTransform(
						COLOUR_OFFSET, COLOUR_OFFSET, COLOUR_OFFSET, 1.0,
						Math.round(COLOUR_FACTOR * (( colour >> 16 ) & 0xFF)),
						Math.round(COLOUR_FACTOR * (( colour >> 8 ) & 0xFF)),
						Math.round(COLOUR_FACTOR * ( colour & 0xFF)), 0
					);
				}
				else {
					return new ColorTransform();
				}
		}
		
		
		protected function unHighlight(event:TimerEvent = null):void {
			var disableColourTransform:ColorTransform = new ColorTransform();
			disableColourTransform.color = _disableColour;
			var index:int = 0;
			graphics.clear();
			if (_attributes.backgroundColours.length > 0) {
				graphics.beginFill(_attributes.backgroundColours[0])
			}
			else {
				graphics.beginFill(0, 0);
			}
			for each (var icon:DisplayObject in _icons) {
				graphics.drawRect(icon.x - _attributes.paddingH / 2, 0, icon.width + _attributes.paddingH, _attributes.heightV);
				icon.transform.colorTransform = _enabled[index++] ? newColourTransform( _iconColour) : disableColourTransform;
			}
			if (_index >= 0 && _activeColour < uint.MAX_VALUE) {
				_icons[_index].transform.colorTransform = _enabled[_index] ? newColourTransform(_activeColour) : disableColourTransform;
				if (_attributes.backgroundColours.length > 1) {
					graphics.beginFill(_attributes.backgroundColours[1]);
					graphics.drawRect(_icons[_index].x - _attributes.paddingH / 2, 0, _icons[_index].width + _attributes.paddingH, _attributes.heightV);
				}
			}
		}
		
		
		public function get index():int {
			return _index;
		}
		
		
		public function set index(value:int):void {
			_pressIndex = _index = value;
			unHighlight();
			labelHighlight();
			_timer.reset();
			_timer.start();
		}
		
		
	//	override public function drawComponent():void {
	//		graphics.clear();
	//		graphics.beginFill(0, 0);
	//		graphics.drawRect(0, 0, width + _attributes.paddingH, height);
	//	}
		
		
		public function set text(source:String):void {
			var position:Number = _leftMargin;
			var dimensions:Array = source.split(",");
			if (_icons) {
				clear();
			}
			_icons = new <Bitmap>[];
			_enabled = new <Boolean>[];
			_labels = new <UILabel>[];
			for (var i:int = 0; i < Math.max(_data ? _data.length : 0, dimensions.length); i++) {
				var icon:Bitmap = (i < dimensions.length && dimensions[i] != "") ? Bitmap(new (getDefinitionByName(dimensions[i]) as Class)) : new Bitmap(new BitmapData(20 * UI.scale, 20 * UI.scale));
				_icons.push(icon);
				
			/*	if (icon is Bitmap) {
					Bitmap(icon).smoothing = !_pixelSnapping;
					if (_pixelSnapping) {
						icon.scaleX = icon.scaleY = 1 / UI.scale;
					}
					Bitmap(icon).pixelSnapping = _pixelSnapping ? PixelSnapping.ALWAYS : PixelSnapping.NEVER;;
				}*/
				icon.smoothing = !_pixelSnapping;
				if (_scaleHeight > 0) {
					icon.scaleX = icon.scaleY = icon.scaleY * _scaleHeight / icon.height;
					icon.y = (_attributes.heightV - icon.height) / 2 - (_data ? CENTRE_OFFSET : 0);					
				}
				else if (_pixelSnapping) {
					icon.scaleX = icon.scaleY = 1 / UI.scale;
					icon.y = (_attributes.heightV - icon.height) / 2 - (_data ? CENTRE_OFFSET : 0);
				}
				icon.pixelSnapping = _pixelSnapping ? PixelSnapping.ALWAYS : PixelSnapping.NEVER;
				
				addChild(icon);
				icon.x = position;

				if (_data && i < _data.length) {
					var label:UILabel = new UILabel(this, 0, icon.y + icon.height - 3, _data[i], _labelFormat);
					label.x = position + icon.width / 2 - label.width / 2;
					_labels.push(label);
				}
				_enabled.push(true);
				position += icon.width + _attributes.paddingH;
			}
		//	drawComponent();
		}
		
		
		public function clear():void {
			for each (var icon:DisplayObject in _icons) {
				removeChild(icon);
			}
			for each (var label:UILabel in _labels) {
				removeChild(label);
			}
			graphics.clear();
			_icons = null;
		}
		
		
		public function set icons(value:Vector.<Bitmap>):void {
			if (_icons) {
				clear();
			}
			_icons = value;
		}
		
		
		public function get icons():Vector.<Bitmap> {
			return _icons;
		}
	
	
		override public function destructor():void {
			super.destructor();
			removeEventListener(MouseEvent.MOUSE_UP, mouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			_timer.removeEventListener(TimerEvent.TIMER, unHighlight);
		}
	}
}
