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
	import flash.geom.Point;
	import com.danielfreeman.madcomponents.Attributes;
	import com.danielfreeman.madcomponents.UIScrollVertical;
	
/**
 *  MadComponents X-Y scrolling area
 * <pre>
 * &lt;scrollXY
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
 *    tapToScale = "NUMBER"
 * /&gt;
 * </pre>
 */
	public class UIScrollXY extends UIScrollVertical
	{
		protected static const STEPS:int = 5;
		
		protected var _maximumSlideX:Number;
		protected var _deltaX:Number = 0;
		protected var _endSliderX:Number = -1;
		protected var _offsetX:Number = 0;
		protected var _stopY:Boolean;
		protected var _tapToScale:Number = -1;
		protected var _scaleTimer:Timer = new Timer(50,STEPS);
		protected var _thisPoint:Point;
		protected var _sliderPoint:Point;
		protected var _oldScale:Number;
		protected var _newScale:Number;
		
/**
 *  XY scrolling container
 * <pre>
 * &lt;scrollXY
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
 *    alignV = "scroll|no scroll"
 *    tapToScale = "NUMBER"
 * /&gt;
 * </pre>
 */	
		public function UIScrollXY(screen:Sprite, xml:XML, attributes:Attributes)
		{
			super(screen, xml, attributes);
			if (xml.@tapToScale.length()>0) {
				_tapToScale = parseFloat(xml.@tapToScale[0]);
				_slider.doubleClickEnabled = true;
				_slider.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClick);
				_scaleTimer.addEventListener(TimerEvent.TIMER, scaleTimerHandler);
			}
		}
		
/**
 *  Double click handler
 */
		protected function doubleClick(event:MouseEvent):void {
			if (!_scaleTimer.running)
				scaleAnimated(Math.abs(_scale-1.0)<1e-6 ? _tapToScale : 1.0, stage.mouseX, stage.mouseY);
		}
		
/**
 *  Animated scale the scrolling content to value, with (x,y) centre of scaling
 *  (x,y) is relative to the global stage coordinate space.
 *  Note that value is absolute - not relative to current scale.
 */
		public function scaleAnimated(value:Number, x:Number, y:Number):void {
			_sliderPoint = _slider.globalToLocal(new Point(x, y));
			_thisPoint = this.globalToLocal(new Point(x, y));
			_oldScale = _scale;
			_newScale = value;
			_scaleTimer.reset();
			_scaleTimer.start();
		}
		
/**
 *  Scale the scrolling content to value, with (x,y) centre of scaling.
 *  (x,y) is relative to the global stage coordinate space.
 *  Note that value is absolute - not relative to current scale.
 */
		public function scaleAtXY(value:Number, x:Number, y:Number):void {
			var sliderPoint:Point = _slider.globalToLocal(new Point(x, y));
			var thisPoint:Point = this.globalToLocal(new Point(x, y));
			doScaleAtXY(value, thisPoint, sliderPoint);
		}
		
		
/**
 *  Scale the scrolling content
 */
		protected function doScaleAtXY(value:Number, thisPoint:Point, sliderPoint:Point):void {
			_slider.x += thisPoint.x - (value*sliderPoint.x + _slider.x);
			if (_slider.x > 0)
				_slider.x = 0;
			sliderY += thisPoint.y - (value*sliderPoint.y + sliderY);
			if (sliderY > 0)
				sliderY = 0;
			scale = value;
		}
		
/**
 *  Animate scaling
 */
		protected function scaleTimerHandler(event:TimerEvent):void {
			doScaleAtXY(_oldScale + _scaleTimer.currentCount * (_newScale - _oldScale)/STEPS, _thisPoint, _sliderPoint);
		}
		
/**
 *  Adjust vertical and horizontal scroll range
 */
		override protected function adjustMaximumSlide():void {
			super.adjustMaximumSlide();
			var sliderWidth:Number = _scrollerWidth>0 ? _scrollerWidth*_scale : _slider.width;
			_maximumSlideX = sliderWidth - _width + PADDING * (_border=="false" ? 0 : 1);
			if (_maximumSlideX < 0)
				_maximumSlideX = 0;
			if (_slider.x < -_maximumSlideX)
				_slider.x = -_maximumSlideX;
			hideScrollBar();
		}

/**
 *  Touch move handler
 */
		override protected function mouseMove(event:TimerEvent):void {
			if (_scaleTimer.running)
				return;
			if (!_noScroll) {
				_deltaX = -_slider.x;
				sliderX = _startSlider.x + (mouseX - _startMouse.x);
				_deltaX += _slider.x;
				
				_delta = -_slider.y;
				sliderY = _startSlider.y + (mouseY - _startMouse.y);
				_delta += _slider.y;
				
				_distance += Math.abs(_deltaX) + Math.abs(_delta);
			}
			if (_distance > THRESHOLD) {
				showScrollBar();
			}
		}
		
/**
 *  Start scrolling movement
 */
		override protected function startMovement():void {
			_endSliderX = FINISHED-1;
			super.startMovement();
		}
		
		
		override protected function startMovement0():Boolean {
			var result:Boolean = false;
			if (_slider.y > _offset) {
				_endSlider = -_offset;
				result = true;
			}
			else if (_slider.y < -_maximumSlide ) {
				_endSlider = _maximumSlide;
				result = result || true;
			}
			if (_slider.x > _offsetX) {
				_endSliderX = -_offsetX;
				result = result || true;
			}
			else if (_slider.x < -_maximumSlideX ) {
				_endSliderX = _maximumSlideX;
				result = result || true;
			}		
			return result;
		}
		
/**
 *  Stop scrolling movement
 */
		override protected function stopMovement():void {
			_stopY = true;
		}
		
/**
 *  Animate scrolling movement
 */
		override protected function movement(event:TimerEvent):void {
			_stopY = false;
			var stopX:Boolean = false;
			super.movement(event);
			if (_endSliderX<FINISHED) {
				_deltaX *= _decay;
				sliderX = _slider.x + _deltaX;
				if (_distance > THRESHOLD)
					showScrollBar();
					if (Math.abs(_deltaX) < _deltaThreshold || _slider.x > 0 || _slider.x < -_maximumSlideX) {
						if (!startMovement0())
							stopX = true;
					}
			}
			else {
				_deltaX = (-_endSliderX - _slider.x) * BOUNCE;
				sliderX = _slider.x + _deltaX;
				showScrollBar();
				if (Math.abs(_deltaX) < _deltaThreshold) {
					stopX = true;
					sliderX = -_endSliderX;
				}
			}
			if (stopX && _stopY)
				super.stopMovement();
		}
		
/**
 *  Show scroll bar
 */
		override public function showScrollBar():void {
			super.showScrollBar();
			var sliderWidth:Number = _scrollerWidth>0 ? _scrollerWidth*_scale : _slider.width;
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
			if (value > _maximumSlideX) {
				_slider.x = -_maximumSlideX;
			}
		}
		
		
		public function get scrollPositionX():Number {
			return -_slider.x;
		}
		
/**
 *  Set scale
 */
		public function set scale(value:Number):void {
			_scale = _slider.scaleX = _slider.scaleY = value;
			adjustMaximumSlide();
		}
		
		
		public function get scale():Number {
			return _scale;
		}
		
		
		override public function destructor():void {
			removeEventListener(MouseEvent.DOUBLE_CLICK, doubleClick);
			_scaleTimer.removeEventListener(TimerEvent.TIMER, scaleTimerHandler);
		}
		
	}
}