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
	import flash.events.MouseEvent;

/**
 * The tickIndexes have changed
 */
	[Event( name="change", type="flash.events.Event" )]
/**
 * A list row was initiated - although we don't yet know whether this is a click or a scroll.
 */
	[Event( name="clickStart", type="flash.events.Event" )]
	
/**
 * A list row was clicked.  This is a bubbling event.
 */
	[Event( name="clicked", type="flash.events.Event" )]

/**
 * A list row was clicked.
 */
	[Event( name="listClickedEnd", type="flash.events.Event" )]

/**
 * A list click was cancelled.  This was a scroll, not a click.  
 */
	[Event( name="listClickCancel", type="flash.events.Event" )]
	
/**
 * A list row was long-clicked.
 */
	[Event( name="longClick", type="flash.events.Event" )]

/**
 * The Pull-Down-To-Refresh header was activated
 */
	[Event( name="pullRefresh", type="flash.events.Event" )]
	

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
		protected var _saveTicks:Vector.<Boolean>;
		
		public function UITickList(screen:Sprite, xml:XML, attributes:Attributes) {
			if (xml.@tickColour.length() > 0) {
				_tickColour = UI.toColourValue(xml.@tickColour[0].toString());
			}
			super(screen, xml, attributes);
		}
		
/**
 *  Create a list row
 */	
		override protected function drawCell(position:Number, count:int, record:*):void {
			var tick:UITick = UITick(_slider.getChildByName("tick_"+count.toString()));
			if (tick) {
				tick.x = _width-_attributes.paddingH-UITick.SIZE;
			}
			else {
				var cell:DisplayObject = _slider.getChildByName("label_"+count.toString());
				var yPosition:Number = (cell.y + position - UITick.SIZE) / 2 - (_simple ? 1.0 : 0.5) * _attributes.paddingV;
				tick = new UITick(_slider, _width-_attributes.paddingH-UITick.SIZE, yPosition, _tickColour);//_cellTop + 2 * _attributes.paddingV + 3,
				tick.name = "tick_"+count.toString();
				tick.visible = record.hasOwnProperty("$tick") ? record.$tick : false;
			}
			super.drawCell(position, count, record);
		}
		
		
		override protected function mouseUp(event:MouseEvent):void {
			if (!_classic && _rowClick) {
				doClick();
			}
			super.mouseUp(event);
		}
		
		
		protected function doClick():void {
			var tick:UITick = UITick(_slider.getChildByName("tick_"+_pressedCell.toString()));
			if (tick) {
				tick.visible = !tick.visible;
			}
			_filteredData[_pressedCell].$tick = tick.visible;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		override protected function pressButton(show:Boolean = true):DisplayObject {
			super.pressButton();
			if (_classic && !_pressButton && _clickRow) {
				doClick();
			}
			return _pressButton;
		}
		
/**
 *  Returns a Vector of data objects that have visible ticks.
 *  (Note that $index is the original, unfiltered index position.)
 */	
		public function get tickData():Vector.<Object> {
			var result:Vector.<Object> = new Vector.<Object>;
			var ticks:Vector.<uint> = tickIndexes;
			for each(var tick:uint in ticks) {
				result.push(_filteredData[tick]);
			}
			return result;
		}
		
/**
 *  Returns a Vector of list row indexes that have visible ticks
 */	
		public function get tickIndexes():Vector.<uint> {
			var result:Vector.<uint> = new Vector.<uint>;
			var tick:UITick;
				for (var i:int=0;i<_count;i++) {
					tick = UITick(_slider.getChildByName("tick_"+i.toString()));
					if (tick.visible) {
						result.push(i);
					}
				}
			return result;
		}
	}
}