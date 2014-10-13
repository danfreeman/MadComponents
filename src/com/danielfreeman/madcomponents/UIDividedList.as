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

package com.danielfreeman.madcomponents {
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextFormat;
	
/**
 * MadComponents divided list
 * <pre>
 * &lt;dividedList
 *    id = "IDENTIFIER"
 *    colour = "#rrggbb"
 *    background = "#rrggbb, #rrggbb, ..."
 *    visible = "true|false"
 *    gapV = "NUMBER"
 *    gapH = "NUMBER"
 *    border = "true|false"
 *    lines = "true|false"
 *    pullDownRefresh = "true|false"
 *    pullDownColour = "#rrggbb"
 *    sortBy = "IDENTIFIER"
 *    mask = "true|false"
 *    alignV = "scroll|no scroll"
 *    highlightPressed = "true|false"
 *    autoLayout = "true|false"
 *    headingColour = "#rrggbb"
 *    headingTextColour = "#rrggbb"
 *    headingShadowColour = "#rrggbb"
 *    headingHeight = "NUMBER"
 * /&gt;
 * </pre>
 */	
	public class UIDividedList extends UIGroupedList {
		
		protected var _headingColour:uint;
		protected var _headingOffColour:uint; // Depreciated
		
		public function UIDividedList(screen:Sprite, xml:XML, attributes:Attributes) {
			_headingOffColour = _headingColour = (xml.@headingColour.length() > 0) ? UI.toColourValue(xml.@headingColour) : attributes.colour;
			super(screen, xml, attributes);

		//	doLayout();
		}
		
		
		public function set headingColour(value:uint):void {
			_headingColour = value;
		}
		
		
		override protected function drawCell(position:Number, count:int, record:*):void {
			drawSimpleCell(position, count, record.hasOwnProperty("$colour") ? record.$colour : uint.MAX_VALUE);
			if (!(record is String) && hasLines(record)) {
				drawLines(position);
			}
			_cellTop = position;
		}
		
/**
 *  When a list row is clicked, display a highlight
 */	
		override protected function drawHighlight():void {
			if (highlightForIndex(_pressedCell) && _groupPositions && _groupPositions.length > _group) {
				_highlight.graphics.clear();
				var groupDetails:Object = _groupPositions[_group];
				var autoLayout:Boolean = _autoLayoutGroup && !_simple;
				var top:Number = autoLayout ? _row.y - _attributes.paddingV + 1 : groupDetails.top + _pressedCell * groupDetails.cellHeight;
				var bottom:Number = top + (autoLayout ? _row.height + 2 * _attributes.paddingV - 1 : groupDetails.cellHeight);
				_highlight.graphics.beginFill(_highlightColour);
			//	_highlight.graphics.drawRect(_cellLeft, top + 1, _cellWidth + 1, bottom - top - 1);
				_highlight.graphics.drawRect(0, top + 1, _attributes.widthH, bottom - top - 1);
			}
		}
		
		
		override protected function headingChrome():void {
			initDraw();
		}
		
		
	//	override protected function positionHeading(top:Number, heading:DisplayObject):void {
	//		heading.y = top - _groupSpacing / 3; // + heading.height;// + (_groupSpacing < _attributes.paddingV ? _attributes.paddingV : 0); // + (_groupSpacing - heading.height) / 2 + 1.5 * _attributes.paddingV;
	//	}
		
/**
 *  Draw a group heading
 */	
		override protected function initDraw():void {
			var top:int = _cellTop;// - 3 * _attributes.paddingV;
			var matr:Matrix=new Matrix();
			var headingColour:uint = (_groupPositions.length > _group ? _groupPositions[_group].visible : false) ? _headingColour : _headingOffColour;
			var gradient:Array = [Colour.lighten(headingColour,64), headingColour];
			var autoLayout:Boolean = !_simple && _autoLayoutGroup;
			super.initDraw();

			if (autoLayout && _groupPositions[_group]) {
				var barTop:Number = (_group > 0) ? _groupPositions[_group-1].bottom - _groupSpacing : 0;
				var barBottom:Number = _groupPositions[_group].top;
				if (_attributes.style7) {
					_slider.graphics.beginFill(headingColour);
				}
				else {
					matr.createGradientBox(_width, barBottom - barTop, Math.PI/2, 0, barTop);
					_slider.graphics.beginGradientFill(GradientType.LINEAR, gradient, [1.0,1.0], [0x00,0xff], matr);
				}
				_slider.graphics.drawRect(0, barTop, _width, barBottom - barTop);
				_slider.graphics.beginFill(_colour);
				_slider.graphics.drawRect(0, barBottom - 1, _width, 1);
			}
			else {
				var last:int = (_group > 0) ? _groupPositions[_group-1].bottom + (autoLayout ? _attributes.paddingV : 0) : 0;
				var filling:Boolean = (_group == 0) || (top-last) > 2;
				if (_attributes.style7) {
					_slider.graphics.beginFill(headingColour);
				}
				else {
					matr.createGradientBox(_width, last - top, Math.PI/2, 0, top);
					_slider.graphics.beginGradientFill(GradientType.LINEAR, gradient, [1.0,1.0], [0x00,0xff], matr);
				}
				_slider.graphics.drawRect(0, last, _width, top - last);
				_slider.graphics.beginFill(_colour);
				_slider.graphics.drawRect(0, filling ? last : top, _width, 1);
			}
			
			_slider.graphics.beginFill(_attributes.style7 ? headingColour : Colour.darken(_colour,-32));
			_slider.graphics.drawRect(0, _cellTop - 1, _width, _attributes.style7 ? 2 : 1);
		//	_gapBetweenGroups = ((autoLayout && false) ? -2 * _attributes.paddingV : -_attributes.paddingV) - 1;
			_gapBetweenGroups = -_attributes.paddingV - 1;
		}
		
/**
 *  Draw the background
 */	
		override public function drawComponent():void {
			graphics.clear();  //<- could this be the cause of the problems?
			if (_colours && _colours.length>0) {
				graphics.beginFill(_colours[0]);
			}
			else {
				graphics.beginFill(0,0);
			}
			graphics.drawRect(0, 0, _attributes.width, _attributes.height);
		}

/**
 *  Set up the scrolling part of the list
 */	
		override protected function initDrawGroups():void {
			_slider.graphics.clear();
			if (_simple) {
				_autoLayout = _autoLayoutGroup = false;
			}
			resizeRefresh();
		}
		
		
		override protected function calculateMaximumSlide():void {
			superCalculateMaximumSlide();
		}
		
	}
}