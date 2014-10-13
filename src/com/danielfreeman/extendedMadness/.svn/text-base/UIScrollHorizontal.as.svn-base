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

package com.danielfreeman.extendedMadness
{
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.danielfreeman.madcomponents.Attributes;
	import com.danielfreeman.madcomponents.UIScrollVertical;
	
/**
 *  MadComponents horizontal scrolling area
 * <pre>
 * &lt;scrollHorizontal
 *    id = "IDENTIFIER"
 *    colour = "#rrggbb"
 *    background = "#rrggbb, #rrggbb, …"
 *    gapV = "NUMBER"
 *    gapH = "NUMBER"
 *    alignH = "left|right|centre|fill"
 *    alignV = "top|bottom|centre|fill"
 *    visible = "true|false"
 *    border = "true|false"
 *    autoLayout = "true|false"
 * /&gt;
 * </pre>
 */
	public class UIScrollHorizontal extends UIScrollVertical
	{
		
		public function UIScrollHorizontal(screen:Sprite, xml:XML, attributes:Attributes)
		{
			super(screen, xml, attributes);
		}
		
/**
 *  Adjust horizontal scroll range
 */
		override protected function adjustMaximumSlide():void {
			var sliderWidth:Number = _scrollerWidth>0 ? _scrollerWidth*_scale : _slider.width;
			_maximumSlide = sliderWidth - _width + PADDING * (_border=="false" ? 0 : 1);
			if (_maximumSlide < 0)
				_maximumSlide = 0;
			if (_slider.x < -_maximumSlide)
				_slider.x = -_maximumSlide;
		}

/**
 *  Touch move handler
 */
		override protected function mouseMove(event:TimerEvent):void {
			if (!_noScroll) {
				_delta = -_slider.x;
				sliderX = _startSlider.x + (mouseX - _startMouse.x);
				_delta += _slider.x;
				_distance += Math.abs(_delta);
			}
			if (_distance > THRESHOLD) {
				showScrollBar();
			}
		}
		
		
		override protected function startMovement0():Boolean {
			var result:Boolean = false;
			if (_slider.x > _offset) {
				_endSlider = -_offset;
				result = result || true;
			}
			else if (_slider.x < -_maximumSlide ) {
				_endSlider = _maximumSlide;
				result = result || true;
			}		
			return result;
		}

		
/**
 *  Animate scrolling movement
 */
		override protected function movement(event:TimerEvent):void {
			if (_endSlider<FINISHED) {
				_delta *= _decay;
				sliderX = _slider.x + _delta;
				if (_distance > THRESHOLD)
					showScrollBar();
				if (Math.abs(_delta) < _deltaThreshold || _slider.x > 0 || _slider.x < -_maximumSlide) {
					if (!startMovement0())
						stopMovement();
				}
			}
			else {
				_delta = (-_endSlider - _slider.x) * BOUNCE;
				sliderX = _slider.x + _delta;
				showScrollBar();
				if (Math.abs(_delta) < _deltaThreshold) {
					stopMovement();
					sliderX = -_endSlider;
				}
			}

		}
		
/**
 *  Show scroll bar
 */
		override public function showScrollBar():void {
			var sliderWidth:Number = _scrollerWidth>0 ? _scrollerWidth*_scale : _slider.width;
			_scrollBarLayer.graphics.clear();
			var barWidth:Number = (_width / sliderWidth) * _width;
			var barPositionX:Number = (- _slider.x / sliderWidth) * _width + 2 * SCROLLBAR_POSITION;
			if (barPositionX < SCROLLBAR_POSITION) {
				barWidth += barPositionX;
				barPositionX = SCROLLBAR_POSITION;
			}
			if (barPositionX + barWidth > _width - 4 * SCROLLBAR_POSITION) {
				barWidth -= barPositionX + barWidth - _width + 4 * SCROLLBAR_POSITION;
			}
			if (barWidth > 0 && barPositionX >= 0) {
				_scrollBarLayer.graphics.beginFill(_scrollBarColour);
				_scrollBarLayer.graphics.drawRoundRect(barPositionX, _height - SCROLLBAR_WIDTH - SCROLLBAR_POSITION, barWidth, SCROLLBAR_WIDTH, SCROLLBAR_WIDTH);
			}
			_slider.cacheAsBitmap = true;
		}
		

		protected function set sliderX(value:Number):void {
			if (Math.abs(value - _slider.x) < MAXIMUM_DY) {
				_slider.x = value;
			}
		}
		
/**
 *  Set horizontal scroll position
 */
		public function set scrollPositionX(value:Number):void {
			_slider.x = -value;
			if (value > _maximumSlide) {
				_slider.x = -_maximumSlide;
			}
		}
		
		
		public function get scrollPositionX():Number {
			return -_slider.x;
		}		
	}
}