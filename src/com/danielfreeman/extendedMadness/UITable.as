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
	import flash.display.DisplayObject;
	import com.danielfreeman.extendedMadness.*;
	import com.danielfreeman.madcomponents.*;

	import flash.display.Sprite;

	/**
	 * table container
	 * <pre>
	 * &lt;table
	 *    id = "IDENTIFIER"
	 *    colour = "#rrggbb"
	 *    background = "#rrggbb, #rrggbb, ..."
	 *    gapV = "NUMBER"
	 *    gapH = "NUMBER"
	 *    alignH = "left|right|centre|fill"
	 *    alignV = "top|bottom|centre|fill"
	 *    visible = "true|false"
	 *    lines = "true|false"
	 *    lineColour = "#rrggbb"
	 * /&gt;
	 * </pre>
	 * */
	public class UITable extends UIPanel {
		
		protected var _lines:Boolean;
		protected var _lineColour:uint = LINE_COLOUR;
		
		public function UITable(screen : Sprite, xml : XML, attributes : Attributes) {
			_lines = xml.@lines != "false";
			if (xml.@lineColour.length() > 0) {
				_lineColour = UI.toColourValue(xml.@lineColour);
			}
			super(screen, xml, attributes);
		}
		
		
		override public function drawBackground(colours:Vector.<uint> = null):void {
			

			var border:Number = _attributes.hasBorder ? UI.PADDING : 0;
			var maxWidth:Number = _attributes.width + 2 * border - 1;
			var maxHeight:Number = _attributes.height + 2 * border - 1;
			var x2:Number = border - _attributes.paddingH / 2;
			var x3:Number = Math.max(x2, 0);
			var y2:Number = _attributes.heightV + border + _attributes.paddingV;
			
			if (!colours) {
				colours = _attributes.backgroundColours;
			}
			
			graphics.clear();
			graphics.beginFill(colours.length > 0 ? colours[0] : 0xFFFFFF);
			graphics.drawRect(x3, border, Math.min(_attributes.widthH + _attributes.paddingH, maxWidth) - (x3 - x2), Math.min(_attributes.heightV + border, maxHeight - border));
			graphics.beginFill(_lineColour);
			var panel:UIPanel;
			for (var i:int = 0; i < numChildren; i++) {
				panel = UIPanel(getChildAt(i));
				var x0:Number = border - panel.attributes.paddingH / 2;
				var y0:Number = panel.y - _attributes.paddingV / 2;
				var x1:Number = Math.max(x0, 0);
				var y1:Number = Math.max(y0, 0);
				graphics.drawRect(x1, y1, _attributes.widthH + panel.attributes.paddingH - (x1 - x0), 1);
				for (var j:int = 0; j < panel.numChildren; j++) {
					var cell:UIPanel = UIPanel(panel.getChildAt(j));
					graphics.drawRect(Math.max(x0 + cell.x, 0), y1 +1, 1, panel.attributes.heightV + _attributes.paddingV - (y1 - y0) - 1);
				}
			}
			graphics.drawRect(Math.min(border + _attributes.widthH + panel.attributes.paddingH / 2, maxWidth), border, 1, Math.min(_attributes.heightV + border, maxHeight - border));
			graphics.drawRect(x3, Math.min(y2, maxHeight), Math.min(_attributes.widthH + panel.attributes.paddingH, maxWidth) - (x3 - x2), 1);
		}
		
		
		override public function findViewById(id:String, row:int = -1, group:int = -1):DisplayObject {
			if (row < 0 || group < 0) {
				return super.findViewById(id);
			}
			else {
				var panel:UIPanel = UIPanel(getChildAt(row));
				if (panel) {
					var cell:UIPanel = UIPanel(panel.getChildAt(group));
					return cell ? cell.findViewById(id) : null;
				}
				else {
					return null;
				}
			}
		}
		
		
		override public function set data(value:Object):void {
			if (value is Array) {
				for (var i:int = 0; i < numChildren; i++) {
				var panel:UIPanel = UIPanel(getChildAt(i));
				for (var j:int = 0; j < panel.numChildren; j++) {
					var cell:UIPanel = UIPanel(panel.getChildAt(j));
					if (i < value.length && j < value[i].length) {
						cell.data = value[i][j];
					}
				}
			}
			}
			else if (value is Object) {
				super.data = value;
			}
		}
	}
}
