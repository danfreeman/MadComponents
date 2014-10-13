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
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;

/**
 * Scroll Panel with Horizontal and Vertical Scroll Bars
 * <pre>
 * &lt;scrollBarPanel
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
	public class UIScrollBarPanel extends UIScrollBarVertical implements IContainerUI {

		protected var _scrollBarHorizontal:ScrollBar = null;
		protected var _panelMode:Boolean;

		
		public function UIScrollBarPanel(screen:Sprite, xml:XML, attributes:Attributes) {
			_panelMode = xml.@width.length()>0 && xml.@height.length()>0;
			super(screen, xml, attributes);
		}
		
		
		override public function layout(attributes:Attributes):void {
			_attributes = attributes;
			drawBackground(attributes.backgroundColours);
			if (_scrollBar) {
				removeChild(_scrollBar);
				removeChild(_scrollBarHorizontal);
				_slider.scrollRect = new Rectangle(0,0,attributes.width-SCROLLBAR_WIDTH,attributes.height-SCROLLBAR_WIDTH);
			}
			_scrollBar = new ScrollBar(this, attributes.width-SCROLLBAR_WIDTH, 0, attributes.height-SCROLLBAR_WIDTH, _slider, false, false, _buttons);
			_scrollBarHorizontal = new ScrollBar(this, 0, attributes.height-SCROLLBAR_WIDTH, attributes.width-SCROLLBAR_WIDTH,_slider, true, false, _buttons);
		}
		
		
		override protected function drawBackground(colours:Vector.<uint>):void {
			super.drawBackground(colours);
			if (_panelMode) {
				_slider.x = Math.max(0, (_attributes.width - Number(_xml.@width[0]) -SCROLLBAR_WIDTH) / 2);
				_slider.y = Math.max(0, (_attributes.height - Number(_xml.@height[0]) -SCROLLBAR_WIDTH) / 2);
					
				if (colours.length>1) {
					graphics.clear();
					graphics.lineStyle(1,Colour.darken(colours[1]));
					graphics.beginFill(colours[1]);
					graphics.drawRect(_slider.x,_slider.y,Number(_xml.@width[0]),Number(_xml.@height[0]));
				}
				_slider.setSize(Number(_xml.@width[0]),Number(_xml.@height[0]));
			}
		}
		
		
		override protected function sliderAttributes(attributes:Attributes):Attributes {
			var result:Attributes = attributes.copy(xml);
			
			result.x = PADDING;
			result.y = PADDING;
			
			if (_xml.@width.length()>0) {
				result.width = Number(_xml.@width[0]) - 2 * PADDING;
			}
			else {
				result.width = attributes.width - 2 * PADDING - SCROLLBAR_WIDTH;			
			}
			
			if (_xml.@height.length()>0) {
				result.height = Number(_xml.@height[0]);
			}
			else {
				result.height = attributes.height -SCROLLBAR_WIDTH;				
			}
			
			return result;
		}

	}
}
