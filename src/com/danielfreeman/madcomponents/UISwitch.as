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
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import flash.events.Event;
	import flash.display.Shape;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.events.MouseEvent;
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class UISwitch extends MadSprite implements IComponentUI {
		
		protected static const ON_COLOUR:uint = 0x4CD263;
		protected static const OFF_COLOUR:uint = 0xFFFFFF;
		protected static const OUTLINE_COLOUR:uint = 0xDDDDDD;
		protected static const SHADOW_COLOUR:uint = 0x000000;
		protected static const SHADOW_ALPHA:Number = 0.1;
		protected static const SHADOW_OFFSET:Number = 2;
		protected static const WIDTH:Number = 52.0;
		protected static const HEIGHT:Number = 31.0;
		protected static const RADIUS:Number = 14.0;
		protected static const STEPS:Number = 8;
		protected static const DELTA:Number = 0.1;

		protected var _onColour:uint = ON_COLOUR;
		protected var _offColour:uint = OFF_COLOUR;
		protected var _outlineColour:uint = OUTLINE_COLOUR;
		protected var _shadowColour:uint = SHADOW_COLOUR;
		protected var _sliderColour:uint = OFF_COLOUR;
		protected var _state:Boolean = false;
		protected var _position:Number = 0;
		protected var _timer:Timer = new Timer(32, STEPS);
		protected var _deltaPosition:Number;
		protected var _ready:Boolean = false;


		public function UISwitch(screen:Sprite, xml:XML, attributes:Attributes) {
		//	screen.addChild(this);
			super(screen, attributes);
			if (xml.@onColour.length() > 0) {
				_onColour = UI.toColourValue(xml.@onColour);
			}
			if (xml.@offColour.length() > 0) {
				_offColour = UI.toColourValue(xml.@offColour);
			}
			if (xml.@outlineColour.length() > 0) {
				_outlineColour = UI.toColourValue(xml.@outlineColour);
			}
			if (xml.@shadowColour.length() > 0) {
				_shadowColour = UI.toColourValue(xml.@shadowColour);
			}
			if (xml.@sliderColour.length() > 0) {
				_sliderColour = UI.toColourValue(xml.@sliderColour);
			}
			if (xml.@state.length() > 0) {
				_state = xml.@state == "true";
			}
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			_timer.addEventListener(TimerEvent.TIMER, animate);
			drawComponent();
		}
		
		
		protected function animate(event:TimerEvent):void {
			var timer:Timer = Timer(event.currentTarget);
			var factor:Number = (timer.currentCount + 1) / STEPS;
			var position:Number = (1 - factor) * _position + factor * (_state ? 1.0 : 0.0);
			drawSwitch(position);
		}
		
		
		protected function mouseDown(event:MouseEvent):void {
			_ready = true;
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			_deltaPosition = 0;
		}
		
		
		protected function mouseUp(event:MouseEvent):void {
			if (_ready) {
				removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
				addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
				stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
				if (_deltaPosition > RADIUS) {
					_state = _position > 0.5;
				}
				else {
					_state = !_state;
				}
				_timer.reset();
				_timer.start();
				dispatchEvent(new Event(Event.CHANGE));
				_ready = false;
			}
		}
		
		
		protected function mouseMove(event:MouseEvent):void {
			var position:Number = Math.min(1.0, Math.max(0, (mouseX - RADIUS) / (WIDTH - 2.0 * RADIUS)));
			if (Math.abs(position - _position) > DELTA) {
				position = _position + ((position > _position) ? DELTA : -DELTA);
			}
			_deltaPosition += position;
			drawSwitch(position);
		}
		
		
		protected function interpolate(colourA:uint, colourB:uint, factor:Number):uint {
			return (Math.round((1 - factor) * (colourA & 0xFF0000) + factor * (colourB & 0xFF0000)) & 0xFF0000) +
				(Math.round((1 - factor) * (colourA & 0x00FF00) + factor * (colourB & 0x00FF00)) & 0x00FF00) +
				(Math.round((1 - factor) * (colourA & 0x0000FF) + factor * (colourB & 0x0000FF)) & 0x0000FF);
		}
		
		
		protected function drawSwitch(position:Number):void {
			var colour:uint = interpolate(_outlineColour, _onColour, position);
			
			graphics.clear();
			graphics.beginFill(colour);
			graphics.drawRoundRect(0, 0, WIDTH, HEIGHT, HEIGHT, HEIGHT);
			graphics.endFill();
			graphics.beginFill(_offColour);
			var width:Number = (1 - position) * (WIDTH - 3.0);
			var height:Number = (1 - position) * (HEIGHT - 3.0);
			graphics.drawRoundRect((WIDTH - width) / 2, (HEIGHT - height) / 2, width, height, HEIGHT - 2.0, HEIGHT - 2.0);
			graphics.endFill();
			
			var sliderPosition:Number = position * (WIDTH - 2 - 2 * RADIUS) + 1;

		//	graphics.beginFill(_shadowColour, SHADOW_ALPHA);
			var matr:Matrix = new Matrix();
			matr.createGradientBox(RADIUS*2 + 2, RADIUS*2 + 2, Math.PI/2, 0, -RADIUS - 1);
			graphics.beginGradientFill(GradientType.LINEAR, [SHADOW_COLOUR, SHADOW_COLOUR], [SHADOW_ALPHA, 0.05], [0x00,0xff], matr);
			
			graphics.drawCircle(sliderPosition + RADIUS, 1 + RADIUS + 1 + SHADOW_OFFSET, RADIUS + 1);
			graphics.endFill();
			graphics.beginFill(_sliderColour);
			graphics.lineStyle(0, Colour.darken(colour, -32));
			graphics.drawCircle(sliderPosition + RADIUS, 1 + RADIUS, RADIUS);
			graphics.endFill();
			
			_position = position;
		}
		
		
		public function get state():Boolean {
			return _state;
		}
		
		
		public function set state(value:Boolean):void {
			drawSwitch(value ? 1.0 : 0.0);
			_state = value;
		}
		
/**
 *  Set the state of the switch "on" or "off"
 */	
		public function set text(value:String):void {
			state = value=="on";
		}
		
/**
 *  Get the state of the switch "on" or "off"
 */	
		public function get text():String {
			return _state ? "on" : "off";
		}
		
		
		public function drawComponent():void {
			drawSwitch(_state ? 1.0 : 0.0);
		}
		
		
		override public function destructor():void {
			super.destructor();
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			_timer.removeEventListener(TimerEvent.TIMER, animate);
		}
	}
}