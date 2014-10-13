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
	
	import flash.display.Shape;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;

/**
 * UIWindow for popup windows
 * <pre>
 * &lt;
 *    colour = "#rrggbb"
 *    background = "#rrggbb, #rrggbb, ..."
 *    gapV = "NUMBER"
 *    gapH = "NUMBER"
 *    alignH = "left|right|centre|fill"
 *    alignV = "top|bottom|centre|fill"
 *    visible = "true|false"
 *    lines = "true|false"
 *    widths = "i(%),j(%),k(%)…"
 *    heights = "i(%),j(%),k(%)…"
 *    pickerHeight = "NUMBER"
 *    border = "true|false"
 *    autoLayout = "true|false"
 *    lazyRender = "true|false"
 *	  alt = "true|false"
 * /&gt;
 * </pre>
 * */	
	public class UIWindow extends UIForm {
		
		public static const CURVE:Number = 32.0;
		protected static const OUTLINE:Number = 2.0;
		protected static const LINE_COLOUR:uint = 0xBABABA;
		protected static const FILL_COLOUR:uint = 0x666666;
		protected static const FILL_COLOUR7:uint = 0xF5F5F5;
		protected static const SHADOW_OFFSET:Number = 4.0;
		protected static const SHADOW_COLOUR:uint = 0x000000;
		protected static const SHADOW_ALPHA:Number = 0.2;
		protected static const OVERLAP:Number = 24.0;
		protected static const BUTTON_BAR_HEIGHT:Number = 26.0;
		
		protected var _curve:Number = CURVE;
		protected var _centred:Boolean = false;
		protected var _iMask:Shape = null;
		protected var _colour:uint;
		protected var _leftButton:UIBackButton = null;
		protected var _rightButton:UIBackButton = null;
		protected var _lineColour:uint = LINE_COLOUR;

/**
 *  A MadComponents pop-up window
 */
		public function UIWindow(screen:Sprite, xml:XML, attributes:Attributes = null, curve:Number = -1, centre:Boolean = true) {
			super(screen,xml,attributes);
			_centred = centre;
			if (curve>=0) {
				_curve = curve;
			}
			if (_xml.@alt != "true" && !_attributes.style7) {
				addChild(mask = _iMask = new Shape());
			}
			if (_xml.@leftButton.length() > 0) {
				leftButtonText = _xml.@leftButton;
			//	_leftButton = new UIBackButton(this, -_curve, _attributes.height - BUTTON_BAR_HEIGHT - 4, _xml.@leftButton, 0, false, false, false);
			//	_leftButton.fixwidth = _attributes.width / 2 + _curve;
			}
			if (_xml.@rightButton.length() > 0) {
				rightButtonText = _xml.@rightButton;
			//	_rightButton = new UIBackButton(this, _attributes.width / 2, _attributes.height - BUTTON_BAR_HEIGHT - 4, _xml.@rightButton, 0, false, false, false);
			//	_rightButton.fixwidth = _attributes.width / 2 + _curve;
			}
			if (!_leftButton && !_rightButton) {
				drawBackground();
			}
		}
		
/**
 *  Draw window chrome
 */
		override public function drawBackground(colours:Vector.<uint> = null):void {
			graphics.clear();
			if (!colours) {
				colours = _attributes.backgroundColours;
			}
			
			if (!_attributes.style7) {
				if (colours.length>3) {
					graphics.beginFill(colours[3], SHADOW_ALPHA);
				}
				else {
					graphics.beginFill(SHADOW_COLOUR, SHADOW_ALPHA);
				}
				graphics.drawRoundRect(_attributes.x-_curve + SHADOW_OFFSET, _attributes.y-_curve + SHADOW_OFFSET, _attributes.width + 2 * _curve, _attributes.height + 2 * _curve, _curve);
			}
			
			if (colours.length==1) {
				graphics.beginFill(_colour = colours[0]);
			}
			else if (colours.length>1) {
				var matr:Matrix=new Matrix();
				matr.createGradientBox(width,height, Math.PI/2, 0, 0);
				graphics.beginGradientFill(GradientType.LINEAR, [_colour = colours[0],colours[1]], [1.0,1.0], [0x00,0xff], matr);
			}
			else {
				graphics.beginFill(_colour = (_attributes.style7 ? FILL_COLOUR7 : FILL_COLOUR));
			}

			graphics.drawRoundRect(_attributes.x-_curve, _attributes.y-_curve, _attributes.width + 2 * _curve, _attributes.height + 2 * _curve, _curve);
			graphics.endFill();
			
			if (_iMask) {
				_iMask.graphics.beginFill(0);
				_iMask.graphics.drawRoundRect(_attributes.x-_curve, _attributes.y-_curve, _attributes.width + 2 * _curve, _attributes.height + 2 * _curve, _curve);
				_iMask.graphics.endFill();
			
				var matr0:Matrix=new Matrix();
				matr0.createGradientBox(2 * _attributes.width, _attributes.width / 2 + OVERLAP, 0, -_attributes.width / 2, - _attributes.width / 2 + OVERLAP);
				graphics.beginGradientFill(GradientType.RADIAL, [Colour.lighten(_colour, 64), _colour], [1,1], [0,255], matr0);
				graphics.drawEllipse(-_attributes.width / 2, - _attributes.width / 2 + OVERLAP, 2 * _attributes.width, _attributes.width / 2);
				graphics.endFill();
			}
			
			if (colours.length>2) {
				_lineColour = colours[2];
			}
			
			if (!_attributes.style7) {
				graphics.lineStyle(OUTLINE + (_iMask ? OUTLINE : 0), _lineColour, 1.0, true);
			}
			
			graphics.drawRoundRect(_attributes.x-_curve, _attributes.y-_curve, _attributes.width + 2 * _curve, _attributes.height + 2 * _curve, _curve);
			graphics.endFill();
			if (_leftButton && _leftButton.visible || _rightButton && _rightButton.visible) {
				graphics.beginFill(_lineColour);
				graphics.lineStyle(0,0,0);
				graphics.drawRect(-_curve, _attributes.height - BUTTON_BAR_HEIGHT, _attributes.width + 2 * _curve, 1);
				if (_leftButton && _leftButton.visible && _rightButton && _rightButton.visible) {
					graphics.drawRect(_attributes.width / 2, _attributes.height - BUTTON_BAR_HEIGHT + 1, 1, BUTTON_BAR_HEIGHT + _curve);
				}
			}
		}
		
		
		public function get curve():Number {
			return _curve;
		}
		
		
		public function get centred():Boolean {
			return _centred;
		}
		
		
		public function get leftButton():UIBackButton {
			return _leftButton;
		}
		
		
		public function get rightButton():UIBackButton {
			return _rightButton;
		}
		
		
		public function set rightButtonText(value:String):void {
			if (_rightButton) {
				_rightButton.text = value;
			}
			else {
				_rightButton = new UIBackButton(this, _attributes.width / 2, _attributes.height - BUTTON_BAR_HEIGHT - 4, value, 0, false, false, false);
			}
			_rightButton.visible = value != "";
			_rightButton.fixwidth = _attributes.width / 2 + _curve;
			drawBackground();
		}
		
		
		public function get rightButtonText():String {
			return _rightButton ? _rightButton.text : "";
		}
		
		
		public function set leftButtonText(value:String):void {
			if (_leftButton) {
				_leftButton.text = value;
			}
			else {
				_leftButton = new UIBackButton(this, -_curve, _attributes.height - BUTTON_BAR_HEIGHT - 4, value, 0, false, false, false);
			}
			_leftButton.visible = value != "";
			_leftButton.fixwidth = _attributes.width / 2 + _curve;
			drawBackground();
		}
		
		
		public function get leftButtonText():String {
			return _leftButton ? _leftButton.text : "";
		}
		
		
		public function resize(width:Number, height:Number):void {
			_xml.@width = width.toString();
			_xml.@height = height.toString();
			layout(_attributes);
		}

	}
}