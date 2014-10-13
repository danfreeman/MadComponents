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
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
/**
 * UIPanel (overrides extended madness UIForm)
 * <pre>
 * &lt;horizontal|vertical|columns|rows|group|clickableGroup|frame
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
	public class UIPanel extends UIForm {

		protected static const PADDING:Number = 16.0;
	
		protected var _totalWidth:Number;
		protected var _totalHeight:Number;


		public function UIPanel(screen:Sprite, xml:XML, attributes:Attributes = null, row:Boolean = false, inGroup:Boolean = false) {
			super(screen, xml, attributes, row, inGroup);
			_totalWidth = width;
			_totalHeight = height + PADDING;
		}
		
		
		public function setSize(width:Number, height:Number):void {
			_totalWidth = width;
			_totalHeight = height;
		}
		
		
		public function get totalheight():Number {
			return _totalHeight;
		}
		
		
		public function get totalwidth():Number {
			return _totalWidth;
		}
		
		
		override protected function parseBlock(xml:XML, attributes:Attributes, mode:String, row:Boolean):DisplayObject {
			var result:DisplayObject = super.parseBlock(xml, attributes, mode, row);
			UIe.listListener(result, xml);
			return result;
		}

	}
}