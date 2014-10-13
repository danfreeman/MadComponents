/**
 * <p>Original Author: Daniel Freeman</p>
 *
 * <p>Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:</p>
 *
 * <p>The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.</p>
 *
 * <p>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS' OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.</p>
 *
 * <p>Licensed under The MIT License</p>
 * <p>Redistributions of files must retain the above copyright notice.</p>
 */

package com.danielfreeman.extendedMadness
{
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

/**
 *  MadComponents Split View
 * <pre>
 * &lt;splitView
 *    id = "IDENTIFIER"
 *    colour = "#rrggbb"
 *    background = "#rrggbb, #rrggbb, ..."
 *    visible = "true|false"
 *    gapV = "NUMBER"
 *    gapH = "NUMBER"
 *    width = "NUMBER"
 *    height = "NUMBER"
 *    title = "text"
 *    alignH = "left|right|centre|fill"
 *    alignV = "top|bottom|centre|fill"
 *    border = "true|false"
 *    mask = "true|false"
 *    topColour = "#rrggbb"
 * /&gt;
 * </pre>
 */
	public class UISplitView extends MadSprite implements IContainerUI {
		
		protected static const LEFT:Number = 260.0;
		protected static const LINE:Number = 2.0;
		protected static const BUTTON_COLOUR:uint = 0xAA7777;
		protected static const PORTRAIT_MENU_X:Number = 20.0;
		protected static const PORTRAIT_MENU_Y:Number = 60.0;
		protected static const LIST:XML = <list id="list" mask="true" background="#FFFFFF"/>;
		
		protected var _xml:XML;
	//	protected var _attributes:Attributes;

		protected var _leftXML:XML = <navigation mask="true"/>;
		protected var _rightXML:XML = <pages/>;
		protected var _top:UINavigationBar;
		protected var _button:UIButton;
		protected var _right:UIPages;
		protected var _menu:UIDropWindow;
		protected var _landscape:Boolean;
		protected var _list:UIList;
		protected var _hideDelay:Timer = new Timer(50,1);

		public function UISplitView(screen:Sprite, xml:XML, attributes:Attributes) {
		//	screen.addChild(this);
			_xml = xml;
		//	_attributes = attributes;
			super(screen, attributes);
			for each(var child:XML in xml.children()) {
				if (child.localName() != "data") {
					_rightXML.appendChild(child);
				}
			}
			
			_landscape = attributes.width > attributes.height;

			var listAttributes:Attributes = slice(LEFT, attributes.height - UINavigationBar.HEIGHT);
			listAttributes.parse(LIST);
			_list = new UIList(this, LIST, listAttributes);
			_list.visible = _landscape;
			_list.y = UINavigationBar.HEIGHT;
			_list.showPressed = true;
			if (xml.data.length()>0) {
				_list.xmlData = xml.data[0];
			}
			var menuAttributes:Attributes = new Attributes(PORTRAIT_MENU_X, PORTRAIT_MENU_Y, LEFT, 2/3*attributes.height);
			menuAttributes.parse(xml);
			_menu = new UIDropWindow(this, <image/>, menuAttributes);
			_menu.visible = !_landscape;

			_right = new UIPages(this, _rightXML, slice(attributes.width - (_landscape ? LEFT : 0) - LINE, _attributes.height - UINavigationBar.HEIGHT));
			_right.x = LEFT + LINE;
			_right.y = UINavigationBar.HEIGHT;
			_top = new UINavigationBar(this, xml, attributes);
			_top.backButton.visible = false;
			if (xml.@topColour.length()>0)
				_top.colour = UI.toColourValue(xml.@topColour[0]);
			_button = new UIButton(_top, 8, 5, '<font size="14">menu</font>', BUTTON_COLOUR, new <uint>[], true, attributes.style7);
			this.swapChildren(_menu, _list);
			
			_button.addEventListener(UIButton.CLICKED, showMenu);
			_list.addEventListener(UIList.CLICKED_END, hideMenu);

			layout(attributes);
			_hideDelay.addEventListener(TimerEvent.TIMER, hideMenuDelayed);
		}
		
		
		public function get navigationBar():UINavigationBar {
			return _top;
		}
		
		
		public function get list():UIList {
			return _list;
		}
		
		
		public function get right():UIPages {
			return _right;
		}
		
		
		protected function showMenu(event:Event):void {
			if (!_landscape) {
				_menu.visible = _list.visible = !_menu.visible;
				if (_menu.visible)
					stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			}
		}
		
		
		protected function mouseUp(event:MouseEvent):void {
			if (!_landscape && !_list.hitTestPoint(stage.mouseX,stage.mouseY) && !_button.hitTestPoint(stage.mouseX,stage.mouseY)) {
				stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
				_menu.visible = _list.visible = false;
			}
		}
		
		
		protected function hideMenu(event:Event):void {
			if (!_landscape) {
				_hideDelay.reset();
				_hideDelay.start();
			}
		}
		
		
		protected function hideMenuDelayed(event:TimerEvent):void {
			if (!_landscape) {
				_menu.visible = _list.visible = false;
				stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			}
		}
		
		
		protected function slice(width:Number, height:Number):Attributes {
			var result:Attributes = _attributes.copy();
			result.width = width;
			result.height = height;
			return result;
		}
		
		
		public function clear():void {
			_list.clear();
			_right.clear();
		}
		
		
		public function findViewById(id:String, row:int = -1, group:int = -1):DisplayObject {
			var result:DisplayObject = _list.findViewById(id, row, group);
			if (!result)
				result = _right.findViewById(id, row, group);
			return result;
		}
		
		
		public function drawComponent():void {
		}
		
		
		override public function layout(attributes:Attributes):void {
			super.layout(attributes);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			_landscape = attributes.width > attributes.height;
			_attributes = attributes;
			_top.fixwidth= attributes.width;
			if (_landscape) {
				_top.graphics.beginFill(attributes.colour);
				_top.graphics.drawRect(LEFT, UINavigationBar.HEIGHT, LINE, _attributes.height - UINavigationBar.HEIGHT);
				_list.x = 0;
				_list.y = UINavigationBar.HEIGHT;
				_menu.layout(slice(LEFT, attributes.height));
				_list.layout(slice(LEFT, attributes.height - UINavigationBar.HEIGHT));
				_right.layout(slice(attributes.width - LEFT, _attributes.height - UINavigationBar.HEIGHT));
				_right.x = LEFT + LINE;
			}
			else {
				_menu.layout(slice(LEFT, 2/3*attributes.height));
				_menu.x = PORTRAIT_MENU_X;
				_menu.y = PORTRAIT_MENU_Y;
				_list.layout(slice(LEFT, 2/3*attributes.height));
				_list.x = PORTRAIT_MENU_X;
				_list.y = PORTRAIT_MENU_Y;
				_right.layout(slice(attributes.width, _attributes.height - UINavigationBar.HEIGHT));
				_right.x = 0;
			}
			_list.scrollPositionY = 0;
			_button.visible = !_landscape;
			_list.visible = _landscape;
			_menu.visible = false;
		}
		
		
		public function get pages():Array {
			return _right.pages;
		}
		
		
	//	public function get attributes():Attributes {
	//		return _attributes;
	//	}
		
		
		public function get xml():XML {
			return _xml;
		}
		
		
		override public function destructor():void {
			super.destructor();
			_hideDelay.removeEventListener(TimerEvent.TIMER, hideMenuDelayed);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			_button.removeEventListener(UIButton.CLICKED, showMenu);
			_list.removeEventListener(UIList.CLICKED_END, hideMenu);
			_list.destructor();
			_right.destructor();
		}
	}
}