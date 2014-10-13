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
	import com.danielfreeman.madcomponents.Attributes;
	
	import flash.display.Sprite;
	import asfiles.HBarGraph;
	import asfiles.Packet;

/**
 * Horizontal bar chart component
 * <pre>
 * &lt;horizontalChart
 *    id = "IDENTIFIER"
 *    colours = "#rrggbb, #rrggbb, ..."
 *    render = "2d|2D|3d|3D"
 *    stack = "true|false"
 *    palette = "#rrggbb, #rrggbb, ..."
 *    paletteStart = "n"
 *    order = "rows|columns"
 * /&gt;
 * </pre>
 * */
	public class UIHorizontalChart extends UIPieChart
	{
		public function UIHorizontalChart(screen:Sprite, xml:XML, attributes:Attributes)
		{
			super(screen, xml, attributes);
		}
		
		
		override protected function createGraph(packet:Packet):void {
			_graph = new HBarGraph(this, 0, 0, packet);
		}
	}
}