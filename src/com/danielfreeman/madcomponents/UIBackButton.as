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

	import flash.events.MouseEvent;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
/**
 * Arrow button, as used in the navigation bar (for both forward and back buttons)
 */	
	public class UIBackButton extends Sprite {
		
		protected static const FORMAT:TextFormat = new TextFormat("Arial", 14, 0xFFFFFF);
		protected static const SENSOR_HEIGHT : Number = 46.0;
		protected static const HEIGHT : Number = 33.0;
		protected static const ARROW:Number = 10.0;
		protected static const CURVE:Number = 5.0;
		protected static const X:Number = 12.0;
		protected static const Y:Number = 12;
		
		public static const ADJUSTMENT:Number = 0.0;
		
		protected var _label:UILabel;
		protected var _colour:uint = 0x0B79EC;
		protected var _forward:Boolean;
		protected var _width:Number = -1;
		protected var _height:Number = HEIGHT;
		protected var _classic:Boolean;
		protected var _arrow:Boolean;


		public function UIBackButton(screen:Sprite, xx:Number, yy:Number, text:String, colour:uint, forward:Boolean = false, classic:Boolean = true, arrow:Boolean = true) {
			screen.addChild(this);
			_forward = forward;
			if (classic) {
				_colour = colour;
			}
			_label = new UILabel(this, X, Y, "", FORMAT);
			_classic = classic;
			_arrow = arrow;
			x=xx;y=yy;
			this.text = text;
			buttonMode = useHandCursor = true;
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		}
		
		
		public function set arrow(value:Boolean):void {
			_arrow = value;
			synthButton(_colour, _label.width + 20);
		}
		
/**
 * Set the text label of the button
 */	
		public function set text(value:String):void {
			_label.xmlText = _classic ? value : '<font color="#' + _colour.toString(16) + '">' + value + '</font>';
			synthButton(_colour, _label.width + 20);
		}
		
		
		public function get text():String {
			return _label.text;
		}
		
/**
 * Set the text format of the button label
 */	
		public function set textFormat(value:TextFormat):void {
			_label.defaultTextFormat = value;
			_label.setTextFormat(value);
		}
		
/**
 * Set colour of the button
 */	
		public function set colour(value:uint):void {
			_colour = value;
			synthButton(_colour, _label.width + 20);
		}
		
		
		public function set fixwidth(value:Number):void {
			_width = value;
			synthButton(_colour, _label.width + 20);
		}
		
		
		protected function mouseDown(event:MouseEvent):void {
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			if (!_classic) {
				_label.setTextFormat(new TextFormat(null, null, Colour.lighten(_colour, 32)));
			}
			synthButton(Colour.lighten(_colour, 32), _label.width + 20);
		}
		
		
		protected function mouseUp(event:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			if (!_classic) {
				_label.setTextFormat(new TextFormat(null, null, _colour));
			}
			synthButton(_colour, _label.width + 20);
		}
		
		
		protected function makeIos7Button(colour:uint):void {
			graphics.lineStyle(3.0, colour);
			if (_arrow) {
				var xx:Number = _forward ? _label.width + 24 : 8.0;
				graphics.moveTo(xx + (_forward ? -1.0 : 1.0) *ARROW, SENSOR_HEIGHT / 2 - ARROW - 1);
				graphics.lineTo(xx , SENSOR_HEIGHT / 2 - 1);
				graphics.lineTo(xx + (_forward ? -1.0 : 1.0) * ARROW, SENSOR_HEIGHT / 2 + ARROW - 1);
				_label.x = _forward ? 8 : 24;
			}
			else {
				_label.x = (_width > 0) ? (_width - _label.width) / 2 : X;
			}
		}
		
/**
 * Render the button
 */	
		protected function synthButton(colour:uint, width:int):void {
			graphics.clear();
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, (_width > 0) ? _width : _label.width + 30, SENSOR_HEIGHT);
			graphics.endFill();
			if (_classic) {
				var matr:Matrix=new Matrix();
				matr.createGradientBox(width, HEIGHT, Math.PI/2, 0, 0);
				graphics.beginFill(Colour.darken(colour));
				var buttonWidth:Number = Math.round(width/8)*8+2;
				var x:Number = _forward ? 0.0 : 2.0;
				buttonShape(x, 6.0, buttonWidth, _height);
				var gradient:Array = [Colour.lighten(colour),Colour.darken(colour),Colour.darken(colour)];
				graphics.beginGradientFill(GradientType.LINEAR, gradient, [1.0,1.0,1.0], [0x00,0x80,0xff], matr);
				buttonShape(x + 1, 7.0, buttonWidth-2, _height-2);
				_label.x = ( buttonWidth - _label.width) / 2 + ( _forward ? -3 : 4 );
			}
			else {
				makeIos7Button(colour);
			}
		}
		
/**
 * Create the basic button shape
 */	
		protected function buttonShape(x:Number,y:Number,buttonWidth:Number,height:Number):void {
			var quotient:Number = (ARROW-CURVE)/ARROW;
			var s:Number = _forward ? -1.0 : 1.0;
			var adjustment:Number = _forward ? 0.0 : ADJUSTMENT;
			if (_forward) {
				x+= buttonWidth;
			}
			graphics.moveTo(x,y + height/2);
			graphics.lineTo(x+s*quotient*ARROW,y+(1-quotient)*height/2);
			graphics.curveTo(x+s*ARROW,y,x+s*(ARROW+CURVE),y);
			graphics.lineTo(x+s*(buttonWidth-CURVE),y);
			graphics.curveTo(x+s*buttonWidth,y,x+s*buttonWidth,y+CURVE);
			graphics.lineTo(x+s*buttonWidth+adjustment,y+height-CURVE);
			graphics.curveTo(x+s*buttonWidth,y+height,x+s*(buttonWidth-CURVE),y+height);
			graphics.lineTo(x+s*(ARROW+CURVE),y+height);
			graphics.curveTo(x+s*ARROW,y+height,x+s*quotient*ARROW,y+height-(1-quotient)*height/2);
			graphics.lineTo(x,y + height/2);
		}
		
		
		public function destructor():void {
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
	}
}
