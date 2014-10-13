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
	
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import asfiles.ScrollBar;

/**
 * Scroll Panel Horizontal
 * <pre>
 * &lt;scrollBarHorizontal
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
	public class UIScrollBarHorizontal extends UIScrollBarVertical implements IContainerUI {
		
	
		public function UIScrollBarHorizontal(screen:Sprite, xml:XML, attributes:Attributes) {
			var xmlH:XML = XML("<horizontal" + xml.toXMLString().substring(xml.toXMLString().indexOf(">"),xml.toXMLString().lastIndexOf("<")) + "</horizontal>");
			super(screen, xmlH, attributes);
		}
		
		
		override public function layout(attributes:Attributes):void {
			_attributes = attributes;
			drawBackground(attributes.backgroundColours);
			if (_scrollBar)
				removeChild(_scrollBar);
			_slider.scrollRect = new Rectangle(0,0,attributes.width,attributes.height-SCROLLBAR_WIDTH);
			_scrollBar = new ScrollBar(this, 0, attributes.height-SCROLLBAR_WIDTH, attributes.width-1,_slider, true, false, _buttons);
		}
		
		
		override protected function sliderAttributes(attributes:Attributes):Attributes {
			var result:Attributes = attributes.copy(xml);
			result.x = PADDING;
			result.y = PADDING;
			result.width = attributes.width - 2 * PADDING;
			result.height = attributes.height - 2 * PADDING - SCROLLBAR_WIDTH;
			return result;
		}

	}
}
