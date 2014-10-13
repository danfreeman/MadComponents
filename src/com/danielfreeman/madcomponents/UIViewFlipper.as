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
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
		import flash.events.Event;
	
/**
 *  MadComponents view flipper container
 * <pre>
 * &lt;viewFlipper
 *    id = "IDENTIFIER"
 *    colour = "#rrggbb"
 *    background = "#rrggbb, #rrggbb, …"
 *    gapV = "NUMBER"
 *    gapH = "NUMBER"
 *    width = "NUMBER"
 *    height = "NUMBER"
 *    alignH = "left|right|centre"
 *    alignV = "top|bottom|centre"
 *    visible = "true|false"
 *    border = "true|false"
 *    autoLayout = "true|false"
 * /&gt;
 * </pre>
 */	
	public class UIViewFlipper extends UIScrollVertical {
		
		protected static const RADIUS:Number = 4.0;
		protected static const SPACING:Number = 16.0;
		protected static const SCROLLBAR_GAP:Number = 20.0;
		
		protected static const DISTANCE_PER_TICK:Number = 10.0;
		protected static const TICKS_THRESHOLD:int = 5.0;
		protected static const MAXIMUM_TICKS:int = 3;
	
		protected var _pages:Array = new Array();
		protected var _page:int = 0;
		protected var _lastPage:int = -1;
	
		public function UIViewFlipper(screen:Sprite, xml:XML, attributes:Attributes) {
			var newAttributes:Attributes = attributes.copy();
			newAttributes.x=0;
			newAttributes.y=0;
			super(screen, xml, newAttributes);
			showScrollBar();
		}
		
/**
 *  Rearrange the layout to new screen dimensions
 */	
		override public function layout(attributes0:Attributes):void {
			var attributes:Attributes = attributes0.copy();
			attributes.x=0;
			attributes.y=0;
			_attributes = attributes;
			_width = attributes.width;
			_height = attributes.height;
			drawComponent();
			var children:XMLList = xml.children();
			for (var i:int = 0; i<children.length(); i++) {
				var pageXML:XML = children[i];
			//	var child:XML = XML("<page>"+pageXML.toXMLString()+"</page>");
				var newAttributes:Attributes = attributes.copy();
				var shiftX:Number = i*_width;
				if (pageXML.@border!="false") {
					addPadding(pageXML.localName(),newAttributes);
				}
				var page:UIForm = UIForm(_slider.getChildAt(i));
				attributes.position(page);
				page.layout(newAttributes);
				page.x+=shiftX;
			}
			_maximumSlide = (_pages.length -1) * _width;
			if (_maximumSlide < 0) {
				_maximumSlide = 0;
			}
			_slider.x = - _page * _width;
			_lastPage = -1;
			showScrollBar();
			_scrollBarVisible = false;
			refreshMasking();
		}
		
/**
 *  Add border padding around a page
 */
		protected function addPadding(localName:String,newAttributes:Attributes):void {
			if (localName!="list" && localName!="navigation" && localName!="viewFlipper" && localName!="frame" && localName.indexOf("List")<0) {
				newAttributes.x+=PADDING;
				newAttributes.y+=PADDING;
				newAttributes.width-=2*PADDING;
				newAttributes.height-=2*PADDING;
				newAttributes.hasBorder = true;
			}
		}
		
/**
 *  Set up the scrolling part of the view flipper
 */
		override protected function createSlider(xml:XML, attributes:Attributes):void {
			_width = attributes.width;
			_height = attributes.height;
			addChild(_slider = new Sprite());
			var children:XMLList = xml.children();
			for (var i:int = 0; i<children.length(); i++) {
				var pageXML:XML = children[i];
				var child:XML = XML("<page>"+pageXML.toXMLString()+"</page>");
				var newAttributes:Attributes = attributes.copy();
				var shiftX:Number = i*_width;
				if (pageXML.@border!="false")
					addPadding(pageXML.localName(),newAttributes);
				var page:UIForm = new UIForm(_slider, child, newAttributes);
				attributes.position(page);
				page.x+=shiftX;
				_pages.push(page);
			}
			_maximumSlide = (_pages.length -1) * _width;
			if (_maximumSlide < 0) {
				_maximumSlide = 0;
			}
		}
		
/**
 *  Attach new pages to this container
 */	
		public function attachPages(pages:Array):void {
			var position:Number = 0;
			for each(var page:DisplayObject in pages) {
				_slider.addChild(page);
				_pages.push(page);
				page.x = position;
				position += _width;
			}
			_maximumSlide = (pages.length -1) * _width;
			showScrollBar();
		}

/**
 *  Show the page indicator
 */	
		override protected function drawScrollBar():void {
			_page = Math.round( - _slider.x / _width);
			if (_page == _lastPage || !_scrollBarLayer) return;
			_scrollBarLayer.graphics.clear();
			if (_scrollBarColour != Attributes.TRANSPARENT) {
				var barPosition:Number = (_width - SPACING * _pages.length) / 2;
				_scrollBarLayer.graphics.lineStyle(1.0, _scrollBarColour);
				for (var i:int = 0; i<_pages.length; i++) {
					if (i == _page) {
						_scrollBarLayer.graphics.beginFill(_scrollBarColour);
					}
					_scrollBarLayer.graphics.drawCircle(barPosition + i * SPACING + SPACING/2, _height - SCROLLBAR_GAP, RADIUS);
					_scrollBarLayer.graphics.endFill();
				}
			}
			_lastPage = _page;
		}
		
		
		override protected function mouseMove(event:TimerEvent):void {
			_delta = -_slider.x;
			sliderX = _startSlider.x + (mouseX - _startMouse.x);
			_delta += _slider.x;
			_distance += Math.abs(_delta);
			if (_distance > THRESHOLD) {
				showScrollBar();
			}
			else if (_classic && _touchTimer.currentCount == MAXIMUM_TICKS) {
				pressButton();
			//	if (_pressButton) {
			//		_touchTimer.stop();
			//		_dragTimer.reset();
			//		_dragTimer.start();
			//	}
			}
			else if (_touchTimer.currentCount == TOUCH_DELAY && !_classic && Math.abs(_delta) <= DELTA_THRESHOLD) {
				pressButton();
			}
		}
		
		
		protected function slideCondition():Boolean {
			return !_pressButton && (Math.abs(mouseX-_startMouse.x)/_touchTimer.currentCount) > DISTANCE_PER_TICK && _touchTimer.currentCount < TICKS_THRESHOLD;
		}
		
		
		override protected function startMovement0():Boolean {
			if (slideCondition()) {
				_endSlider = -_startSlider.x + ((mouseX < _startMouse.x) ? _width : -_width);
			}
			else {
				_endSlider = Math.round( - _slider.x / _width) * _width;
			}
			
			if (_endSlider < 0) {
				_endSlider = 0;
			}
			else if (_endSlider > _maximumSlide) {
				_endSlider = _maximumSlide;
			}
			
			return true;
		}
		
/**
 *  Search for component by id
 */
		override public function findViewById(id:String, row:int = -1, group:int = -1):DisplayObject {
			for each (var view:UIForm in _pages) {
				if (view.name == id) {
					return view;
				}
				else {
					var result:DisplayObject = DisplayObject(view.findViewById(id, row, group));
					if (result)
						return result;
				}
			}
			return null;
		}
		
/**
 *  Set horizontal scroll value
 */
		protected function set sliderX(value:Number):void {
			if (Math.abs(value - _slider.x) < MAXIMUM_DY) {
				_slider.x = value;
			}
		}
		
/**
 *  Animate view flipper movement
 */
		override protected function movement(event:TimerEvent):void {
			if (_endSlider<0) {
			//	_delta *= DECAY;
				_delta *= deltaToDecay(_delta);
				sliderX = _slider.x + _delta;
				if (_distance > THRESHOLD)
					showScrollBar();
				if (Math.abs(_delta) < 1.0 || _slider.x > 0 || _slider.x < -_maximumSlide) {
					if (!startMovement0())
						stopMovement();
				}
			}
			else {
				_delta = (-_endSlider - _slider.x) * BOUNCE;
				sliderX = _slider.x + _delta;
				showScrollBar();
				if (Math.abs(_delta) < 1.0) {
					sliderX = -_endSlider;
					stopMovement();
				}
			}
		}
		
		
		public function set pageNumber(value:int):void {
			_page = value;
			_slider.x = - _page * _width;
			showScrollBar();
		}
		
		
		public function get pageNumber():int {
			return _page;
		}
		
		
		override public function hideScrollBar():void {
			dispatchEvent(new Event(STOPPED));
			if (_scrollBarVisible) {
				_scrollBarVisible = false;
			}
		}
		
	}
}
