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
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.</p>
 *
 * <p>Licensed under The MIT License</p>
 * <p>Redistributions of files must retain the above copyright notice.</p>
 */

package com.danielfreeman.extendedMadness {
	
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import com.danielfreeman.madcomponents.*;
	
/**
 *  MadComponents tick one list.  Only one row may be ticked.
 * <pre>
 * &lt;tickOneList
 *    id = "IDENTIFIER"
 *    colour = "#rrggbb"
 *    background = "#rrggbb, #rrggbb, ..."
 *    visible = "true|false"
 *    gapV = "NUMBER"
 *    gapH = "NUMBER"
 *    border = "true|false"
 *    autoLayout = "true|false"
 *    lines = "true|false"
 *    pullDownRefresh = "true|false"
 *    pullDownColour = "#rrggbb"
 *    sortBy = "IDENTIFIER"
 *    index = "INTEGER"
 *    mask = "true|false"
 *    showPressed = "true|false"
 *    highlightPressed = "true|false"
 *    alignV = "scroll|no scroll"
 *    tickColour = "#rrggbb"
 * /&gt;
 * </pre>
 */	
	public class UITickOneList extends UITickList {
		
		public function UITickOneList(screen:Sprite, xml:XML, attributes:Attributes) {
			super(screen, xml, attributes);
		}
		
		
		override protected function pressButton():DisplayObject {
			var lastPressedCell:int = _pressedCell;
			super.pressButton();
			if (lastPressedCell != _pressedCell && _clickRow) {
				var lastTick:UITick = UITick(_slider.getChildByName("tick_"+lastPressedCell.toString()));
				if (lastTick) {
					lastTick.visible = false;
				}
				dispatchEvent(new Event(Event.CHANGE));
			}
			return _pressButton;
		}
		
		
	}
}