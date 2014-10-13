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
	
	import flash.display.PixelSnapping;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	
/**
 *  Button for MadComponents tab bar
 */	
	public class UITabButton extends UIButton {
	
		public static const CLEAR:String="clear";

		public static const TAB_HEIGHT:Number = 26.0;
		protected static const ICON_Y:Number = 6.0;
		protected var _state:Boolean = false;
		protected var _screen:Sprite;
		protected var _icon:Sprite;
		protected var _tiny:Boolean;
		protected var _iconBitmap:Bitmap;
		
		
		protected const SMALL_FORMAT:TextFormat = new TextFormat("Tahoma", 12, 0xFFFFFF);
		
		
		public function UITabButton(screen:Sprite, xx:Number, yy:Number, text:String, colour:uint, tiny:Boolean = false, style7:Boolean = false) {
			addChild(_icon = new Sprite());
			_tiny = tiny;
			super(_screen = screen, xx, yy, text, colour, new <uint>[0,0,0,0,0], tiny, style7);
			_icon.mouseEnabled = _icon.mouseChildren = false;
			filters = null;
			screen.addEventListener(CLEAR, clearState);
		}
		
		
		override protected function init():void {
			if (!_tiny)
				_format = SMALL_FORMAT;
			_border = 0.5;
		}
		
		
		protected function clearState(event:Event):void {
			drawButton(_state = false);
		}
		
/**
 *  Set the state of the button
 */	
		public function set state(value:Boolean):void {
			drawButton(_state = value);
		}
		
/**
 *  Set the button label
 */	
		override public function set text(value:String):void {
			_label.text = value;
			drawButton(_state);
		}
		
/**
 *  Draw the button
 */
		override protected function drawButton(pressed:Boolean = false):void {
			super.drawButton(pressed);
			var height:Number = _skinHeight>0 ? _skinHeight : _label.height + sizeY();
			if (_style7) {
				var width:Number = Math.max(_fixwidth,_label.width + 2 * _gap);
				if (_buttonSkin && _alt) {
					_buttonSkin.scaleX = 1.0;
					width = _buttonSkin.width;
				}
				graphics.clear();
				graphics.beginFill(_colour);
				graphics.drawRect(0, 0, width, height);
			}
			var myColor:ColorTransform = new ColorTransform();
			_icon.visible = true;
			if (pressed)
				myColor.color = 0xCCCCFF;
			_icon.transform.colorTransform = myColor;
			_label.x = Math.max((_fixwidth-_label.width)/2, 0);
			_shadowLabel.x = _label.x - 1;
			if (!_tiny) {
				_label.y = height - _label.height;
				_shadowLabel.y = _label.y - 1;
			}
		}
		
/**
 *  Set the button icon
 */
		public function set image(value:String):void {
			imageClass= getDefinitionByName(value) as Class;
		}
		
/**
 *  Set the button icon class
 */
		public function set imageClass(value:Class):void {
			if (_icon.numChildren>0)
				_icon.removeChildAt(0);
			if (value) {
				_iconBitmap = new value();
				_icon.addChild(_iconBitmap);
				_icon.x = ( _fixwidth - _icon.width ) / 2;
				_icon.y = ICON_Y;
			}
			drawButton(_state);
		}
		
		
		public function pixelSnapImage(offset:Number):void {
		//	_iconBitmap.scaleX = _iconBitmap.scaleY = 1 / UI.scale;
			_icon.scaleX = _icon.scaleY = 1 / UI.scale;
			_icon.y = (TAB_HEIGHT - _icon.height) / 2 + 2 + offset;
			_iconBitmap.pixelSnapping = PixelSnapping.ALWAYS;
		}
		
		
		override protected function sizeY():Number {
			return _tiny ? 2*_sizeY : TAB_HEIGHT;
		}
		
/**
 *  Set the width of the button
 */
		override public function set fixwidth(value:Number):void {
			_fixwidth = value;
			drawButton(_state);
			_icon.x = ( _fixwidth - _icon.width ) / 2;
		}
		
		
		override protected function mouseUp(event:MouseEvent):void {
			if (event.target==this) {
				_screen.dispatchEvent(new Event(CLEAR));
				drawButton(_state = true);
			}
			else {
				drawButton(_state);
			}
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		
		
		override public function destructor():void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			_screen.removeEventListener(CLEAR, clearState);
			super.destructor();
		}
	}
}