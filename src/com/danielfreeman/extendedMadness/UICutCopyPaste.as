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
 * AUTHORS' OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
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
	
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	

	public class UICutCopyPaste extends MadSprite
	{
		public static const CLICKED:String = "clicked";
		
		public static const ARROW:Number = 14.0;
		protected static const HEIGHT:Number = 38.0;
		protected static const ALT_HEIGHT:Number = 22.0;
		protected static const GAP:Number = 10.0;
		protected static const CURVE:Number = 16.0;
		protected static const CURVE7:Number = 4.0;
		protected static const COLOUR:uint = 0x555555;
		protected static const PRESSED_COLOUR:uint = 0x6666CC;
		protected static const PRESSED_TEXT_COLOUR:uint = 0xFFFFFF;
		
		protected const FORMAT:TextFormat = new TextFormat("_sans",16,0xFFFFFF);
		
		protected var _labels:Vector.<UILabel> = new Vector.<UILabel>();
		protected var _arrowPosition:Number;
		protected var _index:int = -1;
		protected var _colour:uint = COLOUR;
		protected var _gap:Number = GAP;
		protected var _curve:Number;
		protected var _height:Number = HEIGHT;
		protected var _alt:Boolean;
		protected var _font:XML = null;
		protected var _pressedLayer:Sprite;
		protected var _pressedColour:uint = UIList.HIGHLIGHT;
		protected var _timer:Timer;
		protected var _ready:Boolean = false;
		protected var _style7:Boolean;
		protected var _lineColour:uint;
		
/**
 * Cut / Copy / Paste style buttons
 */
		public function UICutCopyPaste(screen:Sprite, xx:Number, yy:Number, arrowPosition:Number = 0, colour:uint = 0x666666, alt:Boolean = false, words:Vector.<String> = null, style7:Boolean = false) {
		//	screen.addChild(this);
			super(screen, _attributes);
			x=xx;y=yy;
			_colour = colour;
			_style7 = style7;
			_curve = style7 ? CURVE7 : CURVE;
			_height = alt ? ALT_HEIGHT : HEIGHT;
			_arrowPosition = arrowPosition;
			addChild(_pressedLayer = new Sprite());
			initialise(words);
			buttonMode=useHandCursor = true;
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		}
		
		
		public function set font(value:XML):void {
			_font = value;
		}
		
		
		protected function initialise(words:Vector.<String>):void {
			_lineColour = Colour.darken(_colour,-32);
			drawButtons(words ? words : new <String>["Cut","Copy","Paste"], _arrowPosition);
			_timer = new Timer(50, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, resetHighlight);
		}
		
		
		protected function mouseDown(event:MouseEvent):void {
			_ready = true;
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);									
		}
		
		
		protected function mouseUp(event:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			if (_ready && event.target == this) {
				updateIndex();
				dispatchEvent(new Event(Event.CHANGE));
				showPressed();
				_timer.reset();
				_timer.start();
			}
			_ready = false;
		}


		override public function touchCancel():void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			_ready = false;
		}


		protected function updateIndex():void {
			for (var i:int = _labels.length-1; i>=0 ; i--) {
				var position:Number = _labels[i].x - _gap;
				if (mouseX>position) {
					_index = i;
					return;
				}
			}
			_index = 0;
		}
		
/**
 * Get the index of the button clicked
 */
		public function get index():int {
			return _index;
		}
		
		
/**
 * Get the string value of the button clicked
 */
		public function get value():String {
			return _index>=0 ? _labels[_index].text : "";
		}


/**
 * Set index of active segment
 */	
		public function set index(value:int):void {
			_index = value;
			showPressed();
		}
		
		
		protected function drawButtons(labels:Vector.<String>, arrowPosition:Number = 0):void {
			var left:Number = 0;
			for each (var label:String in labels) {
				var uiLabel:UILabel = new UILabel(this, left+_gap, 0, "", FORMAT);
				if (_font) {
					uiLabel.htmlText = _font.toXMLString().substr(0,_font.toXMLString().length-2)+ ">" + label + "</font>";
				}
				else {
					uiLabel.text = label;
				}
				uiLabel.y = (_height - uiLabel.height) / 2;
				left += uiLabel.width + 2*_gap;
				_labels.push(uiLabel);
			}
			buttonChrome(left, arrowPosition);
		}
		
		
		public function drawComponent():void {	
		}

			
		protected function buttonChrome(left:Number, arrowPosition:Number = 0):void {
			var matr:Matrix = new Matrix();
			var gradient:Array = [Colour.lighten(_colour,128),_colour,_colour];
			
			matr.createGradientBox(left, _height, Math.PI/2, 0, 0);
			graphics.clear();
			if (_style7) {
				graphics.beginFill(gradient[1]);
			} else {
				graphics.beginGradientFill(GradientType.LINEAR, gradient, [1.0,1.0,1.0], [0x00,0x80,0xff], matr);
			}
			graphics.lineStyle(1, _lineColour, 1.0, true);
			graphics.moveTo(0,_curve);
			graphics.curveTo(0, 0, _curve, 0);
			if (arrowPosition<0) {
				graphics.lineTo(-arrowPosition - ARROW, 0);
				graphics.lineTo(-arrowPosition, - ARROW);
				graphics.lineTo(-arrowPosition + ARROW, 0);
			}
			graphics.lineTo(left - _curve, 0);
			graphics.curveTo(left, 0, left, _curve);
			graphics.lineTo(left, _height - _curve);
			graphics.curveTo(left, _height, left - _curve, _height);
			if (arrowPosition>0) {
				graphics.lineTo(arrowPosition + ARROW, _height);
				graphics.lineTo(arrowPosition, _height + ARROW);
				graphics.lineTo(arrowPosition - ARROW, _height);
			}
			graphics.lineTo(_curve, _height);
			graphics.curveTo(0, _height, 0, _height - _curve);
			graphics.lineTo(0, _curve);
			
			graphics.lineStyle(0,0,0);
			for (var i:int = 1; i < _labels.length; i++) {
				var position:Number = _labels[i].x;
				if (_style7) {
					graphics.beginFill(_lineColour);
					graphics.drawRect(position - _gap + 1, 1, 1, _height-1);
				}
				else {
					graphics.beginGradientFill(GradientType.LINEAR, [Colour.lighten(_colour,126), _colour], [1.0,1.0], [0x00,0xff], matr);
					graphics.drawRect(position - _gap, 1, 1, _height-1);
					graphics.beginGradientFill(GradientType.LINEAR, [Colour.darken(_colour), _colour], [1.0,1.0], [0x00,0xff], matr);
					graphics.drawRect(position - _gap + 1, 1, 1, _height-1);
				}
			}
		}
		
		
		protected function showPressed():void {
			var matr:Matrix = new Matrix();
			_pressedLayer.graphics.clear();
			matr.createGradientBox(width, _height, Math.PI/2, 0, 0);
			if (_style7) {
				_pressedLayer.graphics.beginFill(_pressedColour);
			} else {
				_pressedLayer.graphics.beginGradientFill(GradientType.LINEAR, [Colour.darken(_pressedColour,-32),_pressedColour,Colour.lighten(_pressedColour,48),Colour.lighten(_pressedColour,48)], [1.0,1.0,1.0,1.0], [0x00,0x20,0x80,0xff], matr);
			}
			if (_index<0 || _labels.length<=0) {
				return;
			}
			else if (_labels.length==1) {
				_pressedLayer.graphics.drawRoundRect(1, 1, width-2, _height-1,_curve);
			}
			else if (_index==0) {
				var right:Number = _labels[1].x - _gap +1;
				_pressedLayer.graphics.moveTo(1, _curve);
				_pressedLayer.graphics.curveTo(1, 1, _curve, 1);
				_pressedLayer.graphics.lineTo(right, 1);
				_pressedLayer.graphics.lineTo(right, _height);
				_pressedLayer.graphics.lineTo(_curve, _height);
				_pressedLayer.graphics.curveTo(1, _height, 1, _height - _curve);
				_pressedLayer.graphics.lineTo(1, _curve-1);
			}
			else if (_index==_labels.length-1) {
				var left:Number = _labels[_index].x - _gap +2;
				_pressedLayer.graphics.moveTo(left, 1);
				_pressedLayer.graphics.lineTo(width-_curve, 1);
				_pressedLayer.graphics.curveTo(width-1, 1, width-1, _curve);
				_pressedLayer.graphics.lineTo(width-1, _height-_curve);
				_pressedLayer.graphics.curveTo(width-1, _height, width-_curve-1, _height);
				_pressedLayer.graphics.lineTo(left, _height);
				_pressedLayer.graphics.lineTo(left, 1);
			}
			else {
				var left0:Number = _labels[_index].x - _gap + 2;
				var width0:Number = _labels[_index].width + 2*_gap - 1;
				_pressedLayer.graphics.drawRect(left0, 1, width0, _height-1);
			}
			if (!_font)
				_labels[_index].textColor = PRESSED_TEXT_COLOUR;
		}
		
		
		protected function resetHighlight(event:TimerEvent):void {
			_pressedLayer.graphics.clear();
			dispatchEvent(new Event(CLICKED));
		}
		
		
		override public function destructor():void {
			super.destructor();
			removeEventListener(MouseEvent.MOUSE_UP,mouseUp);
		}
	}
}