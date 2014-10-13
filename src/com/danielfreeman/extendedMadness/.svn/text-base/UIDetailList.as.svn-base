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
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	/**
	 * A list row was clicked.  This is a bubbling event.
	 */
	[Event( name="clicked", type="flash.events.Event" )]
	
	/**
	 * A list row was long-clicked.
	 */
	[Event( name="longClick", type="flash.events.Event" )]

	
/**
 *  MadComponents DetailList
 * <pre>
 * &lt;detailList
 *    id = "IDENTIFIER"
 *    colour = "#rrggbb"
 *    background = "#rrggbb, #rrggbb, ..."
 *    shadowColour="#rrggbb" 
 *    darkenColour="#rrggbb" 
 *    visible = "true|false"
 *    gapV = "NUMBER"
 *    gapH = "NUMBER"
 *    border = "true|false"
 *    autoLayout = "true|false"
 *    lines = "true|false"
 *    pullDownRefresh = "true|false"
 *    pullDownColour = "#rrggbb"
 *    sortBy = "IDENTIFIER"
 *    sortMode = "MODE"
 *    index = "INTEGER"
 *    showPressed = "true|false"
 *    autoFill = "true|false"
 *    mask = "true|false"
 *    alignV = "scroll|no scroll"
 * /&gt;
 * </pre>
 */

	public class UIDetailList extends UIList {
		
		protected static const GAP:Number = 16.0;
		protected static const DAMPEN:Number = 4.0;
		protected static const SHADOW_HEIGHT:Number = 4.0;
		protected static const DIM:Number = 0.8;
		protected static const DELTA_THRESHOLD:Number = 4.0;
		
		public static var STEPS:int = 4;
		public static var DELAY:int = 40;
		
		protected var _detailLayer:Sprite;
		protected var _detailPage:UIForm = null;
		protected var _detailTop:Bitmap;
		protected var _detailBottom:Bitmap;
		protected var _detailAttributes:Attributes;
		protected var _detailTimer:Timer = new Timer(DELAY, STEPS);
		protected var _splitStart:Number;
		protected var _splitHeight:Number;
		protected var _splitFinish:Number;
		protected var _sliderY:Number;
		protected var _doOpen:Boolean;
		protected var _autoFill:Boolean = false;
		protected var _startY:Number;
		protected var _detailShadowColour:uint;
		protected var _detailShadow:Sprite;
		protected var _rowIndex:int = -1;
		protected var _darkenColour:uint = uint.MAX_VALUE;

		
		public function UIDetailList(screen:Sprite, xml:XML, attributes:Attributes) {
			_autoFill = xml.@autoFill == "true";
			super(screen, xml, attributes);
			if (xml.detail) {
				var detailXML:XML = xml.detail[0];					
				addChild(_detailLayer=new Sprite());
				_detailAttributes = attributes.copy();
				_detailAttributes.parse(detailXML);
				_detailPage = new UI.FormClass(_detailLayer, detailXML, _detailAttributes, true);
				_detailLayer.visible = false;
				_detailTimer.addEventListener(TimerEvent.TIMER, animateDetail);
				if (detailXML.@darkenColour.length()>0) {
					_darkenColour = UI.toColourValue(detailXML.@darkenColour[0]);
				}
				if (detailXML.@shadowColour.length()>0) {
					_detailShadowColour = UI.toColourValue(detailXML.@shadowColour[0]);
					_detailLayer.addChild(_detailShadow = new Sprite());
					makeDetailShadow();
				}
				layout(attributes);
			}
		}
		

/**
 * Create the gradient shadow that gives the detail form a recessed appearance.
 */
		protected function makeDetailShadow():void {
			_detailShadow.graphics.clear();
			var matr:Matrix=new Matrix();
			matr.createGradientBox(_attributes.width, SHADOW_HEIGHT, Math.PI/2, 0, 0);
			_detailShadow.graphics.beginGradientFill(GradientType.LINEAR, [Colour.darken(_detailShadowColour),_detailShadowColour], [1.0,1.0], [0x00,0xff], matr);
			_detailShadow.graphics.drawRect(0, 0, _attributes.width, SHADOW_HEIGHT);
		}
		
/**
 * mousedown handler
 */
		override protected function mouseDown(event:MouseEvent):void {
			_rowIndex = -1;
			if (_detailLayer && _detailLayer.visible) {
				if (mouseY > _detailTop.y + _detailTop.height && mouseY < (_detailShadow ? _detailShadow.y : _detailPage.y)) {
					_moveTimer.stop();
					super.mouseDown(event);
				}
				else if (mouseY < _splitFinish - _splitHeight || mouseY > _detailBottom.y) {
					_startY = mouseY;
					calculateRowIndex();
					stage.addEventListener(MouseEvent.MOUSE_UP, detailMouseUp);
					hideDetail();
				}
			}
			else {
				super.mouseDown(event);
			}
		}
		
		
		protected function calculateRowIndex():void {
			var y:Number = (_slider.mouseY < _splitFinish - _slider.y) ? _slider.mouseY : (_slider.mouseY - _detailPage.height - (_detailShadow ? _detailShadow.height : 0));
			if (_autoLayout) {
				_rowIndex = autoLayoutPressedCell(y);
			}
			else {
				_rowIndex = Math.floor((y - _top)/_cellHeight);
			}
		}
		
		
		protected function detailMouseUp(event:MouseEvent):void {
			if (Math.abs(_startY-mouseY) < THRESHOLD && _rowIndex>=0) {
				goToRowIndex();
			}
			else {
				_delta = (mouseY - _startY) / DAMPEN;
				_distance = 0;
				_moveTimer.start();
			}
			_rowIndex = -1;
			stage.removeEventListener(MouseEvent.MOUSE_UP, detailMouseUp);
		}
		
/**
 * Activate detail page when highlight disappears
 */
		override protected function clickUp(event:TimerEvent):void {
			var pressButton:DisplayObject = _pressButton;
			super.clickUp(event);
			if  (!pressButton && _clickRow) {
				if (_doOpen) {
					hideDetail();
				}
				else {
					if (_autoFill)
						_detailPage.data = row;
					showDetail();
				}
			}
			
		}
		
/**
 *  Rearrange the layout to new screen dimensions
 */		
		override public function layout(attributes:Attributes):void {
			_attributes = attributes;
			if (_detailLayer) {
				stage.removeEventListener(MouseEvent.MOUSE_UP, detailMouseUp);
				hideDetailNow();
				_detailAttributes = attributes.copy();
				if (_xml.detail.length()>0)
					_detailAttributes.parse(_xml.detail[0]);
				_detailPage.layout(_detailAttributes);
				if (_detailShadow)
					makeDetailShadow();
			}
			super.layout(attributes);
			UI.drawBackgroundColour(_detailAttributes.backgroundColours, _attributes.width, _detailAttributes.height+UI.PADDING, _detailPage);
		}
		
/**
 *  Show the detail page.
 */	
		public function showDetail():void {
			if (!_detailLayer || _detailLayer.visible || !_detailPage)
				return;
			if (_row) {
				_splitStart = _row.y;
				_splitHeight = _row.height;
			}
			else {
				_splitStart = (_pressedCell) * _cellHeight;
				_splitHeight = _cellHeight;
			}
			
			var bottom:Number = _attributes.heightV - (_slider.y + _splitStart);
			var offset:Number = _slider.y + _splitStart;
			if (bottom<=0) {
				_slider.y -= _cellHeight;
				bottom = _attributes.heightV - (_slider.y + _splitStart);
			}
			else if (offset < 0) {
				_slider.y -= offset - 1;
			}
			
			_sliderY = _slider.y;

			_scrollBarLayer.graphics.clear();
			var bitmapAll:BitmapData = new BitmapData(_attributes.widthH, _attributes.heightV);
			bitmapAll.draw(this);
			if (_darkenColour!=uint.MAX_VALUE)
				bitmapAll.applyFilter(bitmapAll, bitmapAll.rect, new Point(), new ColorMatrixFilter([(_darkenColour>>16 & 0xff)/0xff, 0, 0, 0, 0,
																								0, (_darkenColour>>8 & 0xff)/0xff, 0, 0, 0,
																								0, 0, (_darkenColour & 0xff)/0xff, 0, 0,
																								0, 0, 0, 1.0, 0]));


			
			var bitmapTop:BitmapData = new BitmapData(_attributes.widthH, _slider.y + _splitStart + 1, false, 0xffff00);
			_detailLayer.addChild(_detailTop = new Bitmap(bitmapTop));
			bitmapTop.copyPixels(bitmapAll, new Rectangle(0, 0, _attributes.widthH, _slider.y + _splitStart + 1), new Point(0,0));
			
			var bitmapBottom:BitmapData = new BitmapData(_attributes.widthH, bottom, false, 0xffffff);
			_detailLayer.addChild(_detailBottom = new Bitmap(bitmapBottom));
			var y:Number = _slider.y + _splitStart + _splitHeight;
			bitmapBottom.copyPixels(bitmapAll, new Rectangle(0, y, _attributes.widthH, _attributes.heightV - y), new Point(0,0));
			
			_splitStart+=_slider.y+_splitHeight;
			_detailBottom.y=_splitStart;
			_splitFinish = _splitStart - (_splitStart>_attributes.heightV/3 ? GAP : 0);
			if (_splitFinish > _attributes.heightV - _detailPage.height - GAP)
				_splitFinish = _attributes.heightV - _detailPage.height - GAP;
			
			if (offset < 0) {
				_slider.y += offset;
				_splitStart += offset;
				_sliderY += offset;
			}
			
			_detailLayer.visible = true;			
			_doOpen = true;
			_noScroll = true;
			_detailTimer.reset();
			_detailTimer.start();
		}

/**
 *  Hide the detail page.
 */
		public function hideDetail():void {
			if (!_detailLayer || !_detailLayer.visible)
				return;
			_startY = mouseY;
			_doOpen = false;
			_detailTimer.reset();
			_detailTimer.start();
		}
		
/**
 *  Hide the detail page.  Snap shut.  No animation.
 */
		public function hideDetailNow():void {	
			_noScroll = false;
			_doOpen = false;
			if (_detailLayer) {
				_detailLayer.visible = false;
			}
			if (_detailTop) {
				_detailLayer.removeChild(_detailTop);
				_detailTop = null;
				_detailLayer.removeChild(_detailBottom);
				_detailBottom = null;
			}
		}
		
/**
 *  detail page
 */
		public function get detail():UIForm {
			return _detailPage;
		}
		
/**
 *  detail page setter for procedural for actionscript (sans-XML) approach.
 */
		public function set detail(value:UIForm):void {
			_detailPage = value;
			if (!_detailLayer)
				addChild(_detailLayer = new Sprite());
			_detailLayer.addChild(_detailPage);
			_detailLayer.visible = false;
		}
		
/**
 *  set shadow colour.
 */
		public function set shadowColour(value:uint):void {
			_detailShadowColour = value;
			if (!_detailLayer)
				addChild(_detailLayer = new Sprite());
			if (!_detailShadow)
				_detailLayer.addChild(_detailShadow = new Sprite());
			makeDetailShadow();
		}
		
/**
 *  render a frame of the detail page transition animation.
 */
		protected function animateDetail(event:TimerEvent):void {
			var t:Number = Timer(event.currentTarget).currentCount / STEPS;
			if (!_doOpen) {
				t = 1 - t;
			
				if (Timer(event.currentTarget).currentCount==STEPS) {
						hideDetailNow();
					//	_delta = (mouseY - _startY) / DAMPEN;
					//	_distance = 0;
					//	_moveTimer.start();
						_moveTimer.stop();
					//	if (_rowIndex>=0) {
					//		goToRowIndex();
					//	}
						return;
				}
			}
			
			var split:Number = t * _splitFinish + (1-t) * _splitStart;
			_detailTop.y = split - _splitHeight - _detailTop.height - (_detailShadow ? _detailShadow.height : 0);
			if (_detailShadow)
				_detailShadow.y = split - _detailShadow.height;
			_detailPage.y = split;
			_detailBottom.y = split + t*_detailPage.height+UI.PADDING -2;
			_slider.y = _sliderY + split - _splitStart - (_detailShadow ? _detailShadow.height : 0);
		}
		
		
		protected function goToRowIndex():void {
			illuminate(_rowIndex);
		}
		
		
		override protected function movement(event:TimerEvent):void {
			if (!_noScroll)
				super.movement(event);
		}

		
		
		override public function destructor():void {
			_detailTimer.removeEventListener(TimerEvent.TIMER, animateDetail);
			if (_detailPage)
				_detailPage.destructor();
			super.destructor();
		}
		
	}
}