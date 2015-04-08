package com.danielfreeman.madcomponents {
	
	import flash.utils.getDefinitionByName;
	import flash.system.Capabilities;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
/**
 *  MadComponents tabbed pages container
 * <pre>
 * &lt;tabPages
 *    id = "IDENTIFIER"
 *    colour = "#rrggbb"
 *    background = "#rrggbb, #rrggbb, ..."
 *    visible = "true|false"
 *    gapV = "NUMBER"
 *    gapH = "NUMBER"
 *    alignH = "left|right|centre"
 *    alignV = "top|bottom|centre"
 *    border = "true|false"
 *    mask = "true|false"
 *    alt = "true|false"
 *    pixelSnapping = "true|false"
 *    iconOffset = "NUMBER"
 *    style7 = "true|false"
 *    lazyRender = "true|false"
 *    recycle = "true|false"
 * /&gt;
 * </pre>
 */
	public class UITabPages extends UIPages {
		
		protected static const PADDING:Number = 1.0;
		protected static const TWEAK:Number = 6.0;
		
		protected var _buttonBar:Sprite = null;
		protected var _buttons:Array = [];
		protected var _mouseDownTarget:UITabButton = null;
		protected var _colour:uint;
		protected var _alt:Boolean;
		protected var _fullPageAttributes:Attributes;
		protected var _pagesAttributes:Attributes;
		protected var _pixelSnapping:Boolean;
		protected var _iconOffset:Number = 0;
		protected var _fullPage:Array = [];
		

		public function UITabPages(screen:Sprite, xml:XML, attributes:Attributes) {
			_fullPageAttributes = _attributes = attributes;
			_colour = attributes.colour;
			_alt = xml.@alt == "true";
			_pixelSnapping = xml.@pixelSnapping == "true" || (xml.data && xml.data.length() > 0);
			_iconOffset = xml.@iconOffset.length() > 0 ? parseFloat(xml.@iconOffset) : 0;
			initialiseButtonBar(xml, attributes);
			for each (var child:XML in xml.children()) {
				_fullPage.push(child.@fullPage == "true");
			}
			super(screen, xml, attributes);
			_buttonBar.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);			
			_buttonBar.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			setChildIndex(_buttonBar, numChildren-1);
			extractData(xml);
		}
		
		
		public function get fullPage():Boolean {
			return _fullPage[_page];
		}
		
		
		public function set fullPage(value:Boolean):void {
			_fullPage[_page] = value;
			_buttonBar.visible = !value;
			doLayout();
		}
		
		
		public function get buttonBar():Sprite {
			return _buttonBar;
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
				} */
				else if (data.@size.substr(-3,3).toUpperCase() == "DPI" && parseFloat(data.@size.substr(0,-3)) >= Capabilities.screenDPI) {
					xmlData = data;
					return;
				}
			}
		}
		
		
		protected function imageAttributeClass(item:Object):Class {
			if (item.ldpi && Capabilities.screenDPI < 160 ) {
				_pixelSnapping = true;
				return Class(getDefinitionByName(item.ldpi));
			}
			else if (item.mdpi && Capabilities.screenDPI < 240) {
				_pixelSnapping = true;
				return Class(getDefinitionByName(item.mdpi));
			}
			else if (item.hdpi && Capabilities.screenDPI < 320) {
				_pixelSnapping = true;
				return Class(getDefinitionByName(item.hdpi));
			}
			else if (item.xhdpi && Capabilities.screenDPI < 400) {
				_pixelSnapping = true;
				return Class(getDefinitionByName(item.xhdpi));
			}
			else if (item.xxhdpi && Capabilities.screenDPI >= 400) {
				_pixelSnapping = true;
				return Class(getDefinitionByName(item.xxhdpi));
			}
			else if (item.image) {
				return Class(getDefinitionByName(item.image));
			}
			else {
				return null;
			}
		}
		
		
		public function set data(value:Array):void {
			var index:int = 0;
			for each (var item:Object in value) {
				if (item is String) {
					setTab(index++, String(item));
				}
				else {
					setTab(index++, item.hasOwnProperty("label") ? item.label : "", imageAttributeClass(item));
				}
			}
		}
		
		
/**
 *  Set XML data
 */
		public function set xmlData(value:XML):void {
			var result:Array = [];
			var children:XMLList = value.children();
			for each (var child:XML in children) {
				if (child.nodeKind()!="text") {
					result.push(attributesToObject(child));
				}
			}
			data = result;
		}
		
		
		protected function attributesToObject(child:XML):Object {
			var attributes:XMLList = child.attributes();
			if (attributes.length()==0) {
				return {label:child.localName()};
			}
			else {
				var result:Object = new Object();
				for (var i:int=0; i<attributes.length(); i++) {
					result[attributes[i].name().toString()] = attributes[i].toString();
				}
				return result;
			}
		}
		
		
		protected function initialiseButtonBar(xml:XML, attributes:Attributes):void {
			addChild(_buttonBar=new Sprite());
			var count:int = 0;
			for each(var child:XML in xml.children()) {
				if (child.nodeKind() != "text" && child.localName() != "data") {
					count++;
				}
			}
			makeTabButtons(attributes, count, _alt);
			_pagesAttributes = attributes.copy();
			_pagesAttributes.height -= (_buttonBar.height - (_alt ? 1 : TWEAK));
			_buttonBar.y = _pagesAttributes.height;
		}
		
		
		protected function mouseDown(event:MouseEvent):void {
			if (event.target is UITabButton) {
				_mouseDownTarget = UITabButton(event.target);
			}
		}
		
		
		override public function goToPage(page:int, transition:String = ""):void {
			super.goToPage(page, transition);
			_buttonBar.visible = !_fullPage[page];
			if (!_buttonBar.visible) {
				_thisPage.y = 0;
			}
		}
		
		
		
		protected function mouseUp(event:MouseEvent):void {
			if (_mouseDownTarget && event.target == _mouseDownTarget) {
				goToPage(parseInt(event.target.name));
			}
			_mouseDownTarget = null;
		}

/**
 *  Set the label and icon of a particular tab button
 */
		public function setTab(index:int, label:String, imageClass:Class = null):void {
			var button:UITabButton = UITabButton(_buttons[index]);
			button.text = label;
			if (imageClass) {
				button.imageClass = imageClass;
				if (_pixelSnapping) {
					button.pixelSnapImage(_iconOffset);
				}
			}
		}
		
		
		protected function superLayout(attributes:Attributes):void {
			super.layout(attributes);
		}
		
/**
 *  Rearrange the layout to new screen dimensions
 */	
		override public function layout(attributes:Attributes):void {
			_fullPageAttributes = attributes;
			_pagesAttributes = attributes.copy();
			_pagesAttributes.height -= _buttonBar.height - (_alt ? 1 : TWEAK);
			_buttonBar.y = _pagesAttributes.height;
			superLayout(_pagesAttributes);
			var buttonWidth:Number = attributes.width / _buttonBar.numChildren;
			for (var i:int=0; i<_buttonBar.numChildren; i++) {
				var button:UITabButton = UITabButton(_buttonBar.getChildAt(i));
				button.x = i * buttonWidth;
				button.fixwidth = buttonWidth;
			}
			drawTabButtonBackground();
			_attributes = attributes;
			if (_thisPage && !_buttonBar.visible) {
				_thisPage.y = 0;
			}
		}
		
/**
 *  Attach new pages to this container
 */	
		override public function attachPages(pages:Array, alt:Boolean = false):void {
			super.attachPages(pages, alt);
			makeTabButtons(_attributes, pages.length, alt);
			_buttonBar.y = _attributes.height + (alt ? 1 : TWEAK);
		}


		override public function set pageNumber(value:int):void {
			for (var i:int=0; i<_buttonBar.numChildren; i++) {
				var button:UITabButton = UITabButton(_buttonBar.getChildAt(i));
				button.state = (i == value);
			}
			goToPage(value);
		}
		
		
		override public function get attributes():Attributes {
			return _fullPageAttributes;
		}
		

		override protected function childAttributes(index:int):Attributes {
			if (_fullPage[index]) {
				return _fullPageAttributes.copy();
			}
			else {
				return _pagesAttributes.copy();
			}
		}


/**
 *  Draw the tab buttons
 */	
		protected function makeTabButtons(attributes:Attributes, numberOfPages:int, alt:Boolean):void {
			if (numberOfPages > 0) {
				var buttonWidth:Number = attributes.width / numberOfPages;
				for (var i:int = 0; i < numberOfPages; i++) {
					var _tab:UITabButton = new UITabButton(_buttonBar, i * buttonWidth - 0.5, 0, i.toString(), _colour, alt, _attributes.style7);
					_buttons.push(_tab);
					_tab.name = i.toString();
					_tab.fixwidth = buttonWidth + 1;
				}
				drawTabButtonBackground();
				UITabButton(_buttons[0]).state = true;
			}
		}
		
/**
 *  Set the colour of the tab buttons
 */	
		public function set colour(value:uint):void {
			_colour = value;
			drawTabButtonBackground();
			for each (var button:UITabButton in _buttons) {
				button.colour = value;
			}
		}
		
/**
 *  Draw the tab buttons background
 */	
		public function drawTabButtonBackground():void {
			var matr:Matrix=new Matrix();
			var gradient:Array = [Colour.lighten(_colour,96),Colour.darken(_colour),Colour.darken(_colour)];
			matr.createGradientBox(width, height, Math.PI/2, 0, 0);
			_buttonBar.graphics.clear();
			_buttonBar.graphics.beginGradientFill(GradientType.LINEAR, gradient, [1.0,1.0,1.0], [0x00,0x80,0xff], matr);
			_buttonBar.graphics.drawRect(0, -PADDING, _buttonBar.width, _buttonBar.height + PADDING);
		}
		
		
		public function button(index:int):UITabButton {
			return UITabButton(_buttons[index]);
		}
		
		
		override public function destructor():void {
			_buttonBar.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			_buttonBar.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			super.destructor();
		}
	}
}