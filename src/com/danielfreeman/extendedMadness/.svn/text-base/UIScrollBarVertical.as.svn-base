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

package com.danielfreeman.extendedMadness {
	
	import asfiles.ScrollBar;
	
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

/**
 * Vertical Scroll Panel
 * <pre>
 * &lt;scrollBarVertical
 *    id = "IDENTIFIER"
 *    colour = "#rrggbb"
 *    background = "#rrggbb, #rrggbb, ..."
 *    gapV = "NUMBER"
 *    gapH = "NUMBER"
 *    alignH = "left|right|centre|fill"
 *    alignV = "top|bottom|centre|fill"
 *    visible = "true|false"
 *    lines = "i,j,k..."
 *    widths = "i(%),j(%),k(%)…"
 *    heights = "i(%),j(%),k(%)…"
 *    pickerHeight = "NUMBER"
 *    border = "true|false"
 *    autoLayout = "true|false"
 * /&gt;
 * </pre>
 * */	
	public class UIScrollBarVertical extends Sprite implements IContainerUI {
		
		protected static const SCROLLBAR_WIDTH:Number = 16.0;
		protected static const PADDING:Number = 10.0;
		
		protected var _xml:XML;
		protected var _attributes:Attributes;
		protected var _scrollBar:ScrollBar = null;
		protected var _slider:UIPanel;
		protected var _buttons:Boolean;
		
	
		public function UIScrollBarVertical(screen:Sprite, xml:XML, attributes:Attributes) {
			
			screen.addChild(this);
			x = attributes.x;
			y = attributes.y;
			
			_xml = xml;
			_buttons = xml.@buttons.length()>0 && xml.@buttons[0]!="false";
			
			_slider = new UIPanel(this, xml, sliderAttributes(attributes));

			layout(attributes);
		}
		
		
		public function layout(attributes:Attributes):void {
			_attributes = attributes;
			_slider.layout(sliderAttributes(attributes));
			drawBackground(attributes.backgroundColours);
			if (_scrollBar)
				removeChild(_scrollBar);
			_slider.scrollRect = new Rectangle(0,0,attributes.width + 2*PADDING,attributes.height);
			_scrollBar = new ScrollBar(this, attributes.width-SCROLLBAR_WIDTH, 0, attributes.height-1, _slider, false, false, _buttons);
		}
		
		
		public function get attributes():Attributes {
			return _attributes;
		}
		
		
		public function get xml():XML {
			return _xml;
		}
		
		
		public function get pages():Array {
			return [_slider];
		}
		
		
		public function drawComponent():void {	
			drawBackground(_attributes.backgroundColours);
		}
		
		
		protected function drawBackground(colours:Vector.<uint>):void {
			graphics.clear();
			graphics.beginFill(colours.length>0 ? colours[0] : 0xffffff);
			graphics.drawRect(0, 0, _attributes.width, _attributes.height);
		}
		
		
		protected function sliderAttributes(attributes:Attributes):Attributes {
			var result:Attributes = attributes.copy(xml);
			result.x = PADDING;
			result.y = PADDING;
			result.width = attributes.width - 2 * PADDING - SCROLLBAR_WIDTH;
			result.height = attributes.height - PADDING;
			return result;
		}
		
		
		public function findViewById(id:String, row:int=-1, group:int = -1):DisplayObject {
			return IContainerUI(_slider).findViewById(id, row, group);
		}
		
		
		public function clear():void {
			IContainerUI(_slider).clear();
		}
		
		
		public function destructor():void {

		}
	}
}
