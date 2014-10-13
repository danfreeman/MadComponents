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
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.danielfreeman.madcomponents.*;


/**
 * The tickIndexes have changed
 */
	[Event( name="change", type="flash.events.Event" )]
	

/**
 *  MadComponents tick list
 * <pre>
 * &lt;tickList
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
	public class UITickList extends UIList {
		
		protected static const TICK_COLOUR:uint = 0x9999AA;
		
		protected var _tickColour:uint = TICK_COLOUR;
		
		public function UITickList(screen:Sprite, xml:XML, attributes:Attributes) {
			if (xml.@tickColour.length()>0)
				_tickColour = UI.toColourValue(xml.@tickColour[0].toString());
			super(screen, xml, attributes);
		}
		
/**
 *  Create a list row
 */	
		override protected function drawCell(position:Number, count:int):void {
			var tick:UITick = UITick(_slider.getChildByName("tick_"+count.toString()));
			if (tick) {
				tick.x = _width-_attributes.paddingH-UITick.SIZE;
			}
			else {
				tick = new UITick(_slider, _width-_attributes.paddingH-UITick.SIZE, _cellTop + 2 * _attributes.paddingV + 3, _tickColour);
				tick.name = "tick_"+count.toString();
				tick.visible = false;
			}
			super.drawCell(position, count);
		}
		
		
		override protected function pressButton():DisplayObject {
			super.pressButton();
			if (!_pressButton && _clickRow) {
				var tick:UITick = UITick(_slider.getChildByName("tick_"+_pressedCell.toString()));
				if (tick) {
					tick.visible = !tick.visible;
				}
				dispatchEvent(new Event(Event.CHANGE));
			}
			return _pressButton;
		}
		
/**
 *  Returns a Vector of list row indexes that have visible ticks
 */	
		public function get tickIndexes():Vector.<uint> {
			var result:Vector.<uint> = new Vector.<uint>;
			var tick:UITick;
			if (_simple) {
				for (var i:int=0;i<_count;i++) {
					tick = UITick(_slider.getChildByName("tick_"+i.toString()));
					if (tick.visible) {
						result.push(i);
					}
				}
			}
			else {
				for (var j:int=0;j<_slider.numChildren - 1;j++) {
					var cell:UIForm = UIForm(_slider.getChildAt(j+1));
					if (cell && (tick=UITick(cell.getChildByName("tick")))) {
						if (tick.visible) {
							result.push(j);
						}
					}
				}
			}
			return result;
		}
	}
}