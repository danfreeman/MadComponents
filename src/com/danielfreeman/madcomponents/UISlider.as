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

package com.danielfreeman.madcomponents
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;

/**
 * The slider value has changed
 */
	[Event( name="change", type="flash.events.Event" )]
	

/**
 *  MadComponent slider
 * <pre>
 * &lt;slider
 *   id = "IDENTIFIER"
 *   background = "#rrggbb, #rrggbb, ..."
 *   alignH = "left|right|centre|fill"
 *   alignV = "top|bottom|centre"
 *   visible = "true|false"
 *   clickable = "true|false"
 *   width = "NUMBER"
 *   alt = "true|false"
 *   value = "NUMBER"
 *   curve = "NUMBER"
 * /&gt;
 * </pre>
 */
	public class UISlider extends MadSprite implements IComponentUI
	{
		protected static const WIDTH:Number = 120.0;
		protected static const RADIUS:Number = 14.0;
		protected static const RADIUS7:Number = 16.0;
		protected static const ALT_RADIUS:Number = 10.0;
		protected static const KNOB_COLOUR:uint = 0xDDDDDD;
		protected static const KNOB_COLOUR7:uint = 0xFFFFFF;
		protected static const HIGHLIGHT_COLOUR:uint = 0x3333CC;
		protected static const SLIDER_COLOUR:uint = 0xAAAAAA;
		protected static const SLIDER_HEIGHT:Number = 8.0;
		protected static const SLIDER_HEIGHT7:Number = 3;
		protected static const EXTRA:Number = 30.0;
		
		protected static const SHADOW_COLOUR:uint = 0x000000;
		protected static const SHADOW_ALPHA:Number = 0.1;
		protected static const SHADOW_OFFSET:Number = 2;
		
		protected var _knob:Sprite;
		protected var _sliderColour:uint;
		protected var _highlightColour:uint;
		protected var _knobColour:uint;
		protected var _width:Number = WIDTH;
		protected var _value:Number = 0.5;
		protected var _radius:Number;
		protected var _sliderHeight:Number = SLIDER_HEIGHT;
		protected var _curve:Number = SLIDER_HEIGHT;
		protected var _lastPosition:Number;
		protected var _style7:Boolean;
		
		
		public function UISlider(screen:Sprite, xx:Number, yy:Number, colours:Vector.<uint> = null, alt:Boolean = false, style7:Boolean = false) {
		//	screen.addChild(this);
			super(screen);
			x=xx; y=yy;
			
			_style7 = style7;
			_radius = alt ? ALT_RADIUS : (style7 ? RADIUS7 : RADIUS);

			if (!colours) {
				colours = new <uint>[];
			}
			
			_highlightColour = (colours.length>0) ? colours[0] : HIGHLIGHT_COLOUR;
			_knobColour = (colours.length>1) ? colours[1] : (style7 ? KNOB_COLOUR7 : KNOB_COLOUR);
			_sliderColour = (colours.length>2) ? colours[2] : SLIDER_COLOUR;
			_sliderHeight = style7 ? SLIDER_HEIGHT7 : SLIDER_HEIGHT;

			createKnob();
			value = _value;
			_knob.buttonMode = _knob.useHandCursor = true;
			drawComponent();
		}


		protected function mouseDown(event:MouseEvent):void {
			_lastPosition = _knob.x;
			changePosition(mouseX);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		
		
		protected function changePosition(value:Number):void {
			_knob.x = value;
			if (_knob.x < _radius) {
				_knob.x = _radius;
			}
			else if (_knob.x > _width - _radius) {
				_knob.x = _width - _radius;
			}
			_value = (_knob.x - _radius) / (_width - 2*_radius);
			drawComponent();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		protected function mouseMove(event:MouseEvent):void {
			changePosition(mouseX);
		}
		
		
		override public function touchCancel():void {
			changePosition(_lastPosition);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		
		
		protected function mouseUp(event:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
		protected function createKnob():void {
			addChild(_knob=new Sprite());
			if (_style7) {
				drawIos7Knob();
			}
			else {
				drawKnob();
			}
			_knob.y = _radius;
			_knob.buttonMode = _knob.useHandCursor = true;
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		}
		
		
		protected function drawIos7Knob():void {
			var matr:Matrix = new Matrix();
			matr.createGradientBox(_radius*2 + 2, _radius*2 + 2, Math.PI/2, 0, -_radius - 1);
			_knob.graphics.beginGradientFill(GradientType.LINEAR, [SHADOW_COLOUR, SHADOW_COLOUR], [SHADOW_ALPHA, 0.05], [0x00,0xff], matr);
			_knob.graphics.drawCircle(0, SHADOW_OFFSET - 1, _radius + 1);
			_knob.graphics.beginFill(Colour.darken(_knobColour));
			_knob.graphics.drawCircle(0, -1, _radius);
			_knob.graphics.beginFill(_knobColour);
			_knob.graphics.drawCircle(0, -1, _radius-0.5);
		}
		
		
		protected function drawKnob():void {
			var matr:Matrix = new Matrix();
			matr.createGradientBox(_radius*2, _radius*2, Math.PI/2, 0, -_radius);
			_knob.graphics.beginFill(Colour.darken(_knobColour));
			_knob.graphics.drawCircle(0.3, 0.3, _radius+1);
			_knob.graphics.beginGradientFill(GradientType.LINEAR, [Colour.lighten(_knobColour),Colour.darken(_knobColour)], [1.0,1.0], [0x00,0xff], matr);
			_knob.graphics.drawCircle(0, 0, _radius);
			_knob.graphics.beginGradientFill(GradientType.LINEAR, [Colour.darken(_knobColour),_knobColour,Colour.lighten(_knobColour,32)], [1.0,1.0,1.0], [0x00,0x66,0xFF], matr);
			_knob.graphics.drawCircle(0, 0, _radius-1);
		}
		
		
		public function drawComponent():void {
			var matr:Matrix = new Matrix();
			graphics.clear();
			graphics.beginFill(0,0);
			graphics.drawRect(-EXTRA, 0, _width + 2 * EXTRA, 2 * _radius);
			matr.createGradientBox(_width, _sliderHeight, Math.PI/2, 0, _radius - _sliderHeight/2);
			graphics.beginGradientFill(GradientType.LINEAR, [Colour.darken(_sliderColour,-64),_sliderColour,Colour.lighten(_sliderColour,64),Colour.lighten(_sliderColour,64)], [1.0,1.0,1.0,1.0], [0x00,0x00,0x80,0xff], matr);
			graphics.drawRoundRect(0, _radius - _sliderHeight/2, _width, _sliderHeight, _sliderHeight);
			graphics.beginGradientFill(GradientType.LINEAR, [Colour.darken(_highlightColour,-64),_highlightColour,Colour.lighten(_highlightColour,64),Colour.lighten(_highlightColour,64)], [1.0,1.0,1.0,1.0], [0x00,0x00,0x80,0xff], matr);
			graphics.drawRoundRect(0, _radius - _sliderHeight/2, _knob.x + _curve/2 , _sliderHeight, _sliderHeight);
		}
		
/**
 *  Set value of slider, between "0" and "1"
 */
		public function set text(txt:String):void {
			value = Number(txt);
		}
		
/**
 *  Set value of slider, a number between 0 and 1
 */
		public function set value(valuu:Number):void {
			_value = valuu;
			_knob.x = _radius + valuu * (_width - 2*_radius);
			drawComponent();
		}
		
/**
 *  Current slider calue between 0 and 1
 */
		public function get value():Number {
			return _value;
		}
		
/**
 *  Set width of slider
 */
		public function set fixwidth(valuu:Number):void {
			_width = valuu;
			value = _value;
		}
		
		
		override public function get width():Number {
			return _width;
		}
		
		
		override public function destructor():void {
			super.destructor();
			_knob.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
	}
}