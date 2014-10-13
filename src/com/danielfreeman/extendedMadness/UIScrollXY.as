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
 *    scrollH = "true|false"
 *    scrollV = "true|false"
 *    visible = "true|false"
 *    border = "true|false"
 *    autoLayout = "true|false"
 *    tapToScale = "NUMBER"
 *    auto = "true|false"
 *    lockSides = "true|false"
 *    alt = "true|false"
 * /&gt;
 * </pre>
 */
	public class UIScrollXY extends UIScrollVertical
	{
		protected static const STEPS:int = 5;
		protected static const ALT_FACTOR:Number = 4.0;
		protected static const ALT_THRESHOLD:Number = 10.0;
		
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
		protected var _auto:Boolean;
		protected var _scrollBarThreshold:Number = ABORT_THRESHOLD;
		protected var _lockSides:Boolean;
		protected var _lockTopBottom:Boolean;
		
	//	protected var _swipeTotalX:Number;
	//	protected var _swipeDurationX:Number;
	//	protected var _oldDeltaX:Number;
	protected var _noSwipeCountX:int = 0;
		protected var _scrollEnabledX:Boolean = true;
		protected var _manhattan:Boolean;
		
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
 *    auto = "true|false"
 *    alignV = "scroll|no scroll"
 *    tapToScale = "NUMBER"
 * /&gt;
 * </pre>
 */	
		public function UIScrollXY(screen:Sprite, xml:XML, attributes:Attributes)
		{
			super(screen, xml, attributes);
			_auto = xml.@auto == "true";
			_lockSides = xml.@lockSides == "true";
			_lockTopBottom = xml.@lockTopBottom == "true";
			_manhattan = xml.@manhattan == "true";
			_scrollEnabledX = xml.@scrollH != "no scroll";
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
		
		
		public function set scrollEnabledX(value:Boolean):void {
			_scrollEnabledX = value;
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
		
		
		protected function adjustHorizontalSlide(sliderWidth:Number):void {
			_maximumSlideX = sliderWidth - _width + PADDING * (_border=="false" ? 0 : 1);
			if (_maximumSlideX < 0)
				_maximumSlideX = 0;
			if (_slider.x < -_maximumSlideX)
				_slider.x = -_maximumSlideX;
		}
		
/**
 *  Adjust vertical and horizontal scroll range
 */
		override protected function adjustMaximumSlide():void {
			super.adjustMaximumSlide();
			var sliderWidth:Number = _scrollerWidth>0 ? _scrollerWidth*_scale : _slider.getBounds(this).right;
			adjustHorizontalSlide(sliderWidth);
			hideScrollBar();
		}
		
		
		override protected function handleFlick():void {
			if (_touchTimer.currentCount <= FLICK_THRESHOLD) {
				var divisor:Number = ((_touchTimer.currentCount == 0) ? 1 : _touchTimer.currentCount);
				_delta = (mouseY - _startMouse.y) / divisor;
				_deltaX = (mouseX - _startMouse.x) / divisor;
			}
		}

/**
 *  Touch move handler
 */
		override protected function mouseMove(event:TimerEvent):void {
			if (_scaleTimer.running) {
				return;
			}

			if (!_noScroll) {
				
				if (_scrollEnabledX && (!_auto || _maximumSlideX > 0)) {
					var deltaX:Number = -sliderX;
					var xSlider:Number = sliderX + (outsideSlideRangeX ? _dampen : 1.0) * (mouseX - _lastMouse.x);
					if (_lockSides) {
						xSlider = Math.max(Math.min(0, xSlider), -_maximumSlideX);
					}
					sliderX = xSlider;
					deltaX += xSlider;	

				if (Math.abs(deltaX) > DELTA_THRESHOLD) {
					if (deltaX * _deltaX > 0) {
						_deltaX = SMOOTH * _deltaX + (1 - SMOOTH) * deltaX;
					}
					else {
						_deltaX = deltaX;
					}
					_noSwipeCountX = 0;
				}
				else if (++_noSwipeCountX > NO_SWIPE_THRESHOLD) {
					_deltaX = 0;
				}
//				_distanceX += Math.abs(mouseY - _lastMouse.y); // + Math.abs(mouseX - _startMouse.x);
			//	_lastMouse.x = mouseX;
			//	_lastMouse.y = mouseY;					
//					if (deltaX * _swipeTotalX < 0 || Math.abs(deltaX) < DELTA_THRESHOLD && Math.abs(_oldDeltaX) < DELTA_THRESHOLD) {
//						_swipeTotalX = 0;
//						_swipeDurationX = 0;
//					}
					
//					_swipeTotalX += deltaX;
//					_swipeDurationX++;
//					_oldDeltaX = deltaX;
//					_deltaX = SWIPE_FACTOR * _swipeTotalX / _swipeDurationX;					
					
				}

				if (!_auto || _maximumSlide > 0) {
					//	_delta = -sliderY;
					//	sliderY += (outsideSlideRange ? _dampen : 1.0) * (mouseY - _lastMouse.y);
					//	_delta += sliderY;
					
					var delta:Number = -sliderY;
					var ySlider:Number = sliderY + (outsideSlideRange ? _dampen : 1.0) * (mouseY - _lastMouse.y);
					if (_lockTopBottom) {
						ySlider = Math.max(Math.min(0, ySlider), -_maximumSlide);
					}
					sliderY = ySlider;
					delta += ySlider; //sliderY;
					
					if (Math.abs(delta) > DELTA_THRESHOLD) {
						if (delta * _delta > 0) {
							_delta = SMOOTH * _delta + (1 - SMOOTH) * delta;
						}
						else {
							_delta = delta;
						}
						_noSwipeCount = 0;
					}
					else if (++_noSwipeCount > NO_SWIPE_THRESHOLD) {
						_delta = 0;
					}

				}
				
				if (_manhattan) {
					justMoveVerticallyOrHorizontally();
				}
				
				_distance += Math.abs(mouseX - _lastMouse.x) + Math.abs(mouseY - _lastMouse.y);
			}
			_lastMouse.x = mouseX;
			_lastMouse.y = mouseY;
			if (!_noScroll && _scrollEnabledX && _distance > ABORT_THRESHOLD) {
				showScrollBar();
			}
			else if (_touchTimer.currentCount == MAXIMUM_TICKS && _classic && _distance < THRESHOLD) {
				pressButton();
			}
			else if (_touchTimer.currentCount == TOUCH_DELAY && !_classic && Math.abs(_delta) <= DELTA_THRESHOLD) {
				pressButton();
			}
		}
		
		
		protected function justMoveVerticallyOrHorizontally():void {
			if (Math.abs(_delta) > ALT_FACTOR * Math.abs(_deltaX) && Math.abs(_delta) > ALT_THRESHOLD) {
				_deltaX = 0;
			}
			else if (Math.abs(_deltaX) > ALT_FACTOR * Math.abs(_delta) && Math.abs(_deltaX) > ALT_THRESHOLD) {
				_delta = 0;
			}
		}
				
		
		protected function get outsideSlideRangeX():Boolean {
			return _slider.x >= 0 || _slider.x <= -_maximumSlideX;
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
		//	hideScrollBar();
		}
		
/**
 *  Animate scrolling movement
 */
		override protected function movement(event:TimerEvent):void {
			if (_scaleTimer.running) {
				return;
			}
			if (!_noScroll) {
				_stopY = false;
				var stopX:Boolean = false;
				super.movement(event);
				if (_endSliderX < FINISHED) {
					_deltaX *= deltaToDecay(_deltaX);
					sliderX = sliderX + _deltaX;
					if (_distance > THRESHOLD) {
						showScrollBar();
					}
					if (Math.abs(_deltaX) < _deltaThreshold || sliderX > 0 || sliderX < -_maximumSlideX) {
						if (!startMovement0())
							stopX = true;
					}
				}
				else {
					_deltaX = (-_endSliderX - sliderX) * BOUNCE;
					sliderX = sliderX + _deltaX;
					showScrollBar();
					if (Math.abs(_deltaX) < _deltaThreshold) {
						stopX = true;
						sliderX = -_endSliderX;
					}
				}
				if (stopX && _stopY) {
					super.stopMovement();
				}
			}
		}
		
		
		protected function getSliderWidth():Number {
			return _scrollerWidth>0 ? _scrollerWidth*_scale : _slider.getBounds(this).right;
		}
		
/**
 *  Show scroll bar
 */
		override public function showScrollBar():void {
			if (!_auto || _maximumSlide > 0) {
				super.showScrollBar();
			}
			else {
				_scrollBarLayer.graphics.clear();
				_scrollBarVisible = true;
			}
			if (!_auto || _maximumSlideX > 0) {
				var sliderWidth:Number = getSliderWidth();
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
			}
		//	_slider.cacheAsBitmap = true;
		}
		

		protected function set sliderX(value:Number):void {
			if (Math.abs(value - _slider.x) < MAXIMUM_DY) {
				_slider.x = value;
			}
		}
		
		
		protected function get sliderX():Number {
			return _slider.x;
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