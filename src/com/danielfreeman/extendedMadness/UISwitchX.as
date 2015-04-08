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

package com.danielfreeman.extendedMadness {

	import com.danielfreeman.madcomponents.*;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.text.TextFormat;
	import flash.utils.Timer;

/**
 * The switch value has changed
 */
	[Event( name="change", type="flash.events.Event" )]
	
	
/**
 *  MadComponents switch
 * <pre>
 * &lt;slider
 *   id = "IDENTIFIER"
 *   background = "#rrggbb, #rrggbb, ..."
 *   alignH = "left|right|centre|fill"
 *   alignV = "top|bottom|centre"
 *   visible = "true|false"
 *   width = "NUMBER"
 *   alt = "true|false"
 *   state = "true|false"
 *   clickable = "true|false"
 * /&gt;
 * </pre>
 */
	public class UISwitchX extends MadSprite implements IComponentUI {
	
		protected static const DELTA:int = 40;
		protected static const MOVE_X:Number = 10.0;
		protected static const WIDTH:Number = 90.0;
		protected static const HEIGHT:Number = 30.0;
		protected static const BUTTON_WIDTH:Number = 45.0;
		protected static const BUTTON_COLOUR:uint = 0xF9F9F9;
		protected static const OUTLINE:uint = 0xAAAAAA;
		protected static const OFF_COLOUR:uint = 0x333333;
		protected static const CURVE:Number = 8.0;
		protected static const ALT_CURVE:Number = 32.0;
		protected static const THRESHOLD:Number = 10.0;
		protected static const EXTRA:Number = 30.0;
		
		protected const FORMAT_ON:TextFormat = new TextFormat("Tahoma",15, 0x333333);
		protected const FORMAT_OFF:TextFormat = new TextFormat("Tahoma",15, 0xFFFFFF);
		
		protected var _layer:Sprite;
		protected var _button:Sprite;
		protected var _over:Shape;
		protected var _colour:uint;
		protected var _onLabel:UILabel;
		protected var _offLabel:UILabel;
		protected var _start:Number;
		protected var _move:Number;
		protected var _delta:Number;
		protected var _timer:Timer = new Timer(DELTA);
		protected var _state:Boolean = false;
		protected var _formatOn:TextFormat = FORMAT_ON;
		protected var _formatOff:TextFormat = FORMAT_OFF;
		protected var _offColour:uint = OFF_COLOUR;
		protected var _buttonColour:uint = BUTTON_COLOUR;
		protected var _outlineColour:uint = OUTLINE;
		protected var _curve:Number;
		protected var _extra:Number = 0;
		protected var _lastPosition:Number;
		protected var _labels:Array;
		
	
	//	public function UISwitch(screen:Sprite, xx:Number, yy:Number, colour:uint = 0xCC6600, onText:String = "ON", offText:String = "OFF", colours:Vector.<uint> = null, alt:Boolean = false) {
		public function UISwitchX(screen:Sprite, xml:XML, attributes:Attributes) {
		//	screen.addChild(this);
		//	x=xx;y=yy;
			super(screen, attributes);
			
			_extra = (xml.@alt == "true") ? 8 : 0;
			_curve = (xml.@alt == "true") ? ALT_CURVE : CURVE;
			
			_colour = attributes.colour;
			var colours:Vector.<uint> = attributes.backgroundColours;
			if (colours) {
				if (colours.length > 0)
					_colour = colours[0];
				if (colours.length > 1)
					_offColour = colours[1];
				if (colours.length > 2)
					_formatOn.color = _formatOff.color = colours[2];
				if (colours.length > 3)
					_formatOff.color = colours[3];
				if (colours.length > 4)
					_buttonColour = colours[4];
				if (colours.length > 5)
					_outlineColour = colours[5];
			}
			var labels:Array = xml.toString().split(",");
			_labels = (labels.length > 1) ? labels : ["ON", "OFF"];

			initialiseButton(_labels[0], _labels[1]);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			_timer.addEventListener(TimerEvent.TIMER, slide);
			
			var mask:Sprite = new Sprite();
			mask.graphics.beginFill(0);
			mask.graphics.drawRoundRect(0, 0, WIDTH, HEIGHT, _curve);
			_layer.addChild(_layer.mask=mask);
			buttonMode = useHandCursor = true;
			if (xml.@state=="true") {
				state = true;
			}
		}
		
/**
 *  Set the state of the switch
 */	
		public function set state(value:Boolean):void {
			_state = value;
			_button.x = _state ? (WIDTH-BUTTON_WIDTH + _extra) : 0;
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
		
/**
 *  Get the state of the switch as a boolean
 */	
		public function get state():Boolean {
			return _state;
		}
		
/**
 *  Create the switch
 */	
		protected function initialiseButton(onText:String, offText:String):void {
			addChild(_layer = new Sprite());
			_layer.addChild(_button = new Sprite());
			addChild(_over = new Shape());
			_over.graphics.clear();
			_over.graphics.beginFill(0,0);
			_over.graphics.drawRect(-EXTRA, 0, WIDTH + 2 * EXTRA, HEIGHT);
			_over.graphics.endFill();
			_over.graphics.lineStyle(2,OUTLINE);
			_over.graphics.drawRoundRect(0, 0, WIDTH, HEIGHT, _curve);
			drawButton();
			
			_button.addChild(_onLabel=new UILabel(this, 0, 1, onText, _formatOn));
			_onLabel.x = (WIDTH-BUTTON_WIDTH - _onLabel.width) / 2 -WIDTH+BUTTON_WIDTH;
			_button.addChild(_offLabel=new UILabel(this, WIDTH-BUTTON_WIDTH, 1, offText, _formatOff));
			_offLabel.x = BUTTON_WIDTH + (WIDTH-BUTTON_WIDTH - _offLabel.width) / 2 -_extra;
			_onLabel.y = _offLabel.y = ( HEIGHT - _onLabel.height) / 2;// - 1;
		}
		
/**
 *  Draw the sliding part of the switch
 */	
		protected function drawButton(state:Boolean = false):void {


			_button.graphics.clear();
			var matr:Matrix=new Matrix();
			matr.createGradientBox(WIDTH+EXTRA, HEIGHT, Math.PI/2, 0, 0);
			var gradientOn:Array = [Colour.darken(_colour, -16),Colour.lighten(_colour, 64),Colour.lighten(_colour, 64),Colour.lighten(_colour, 32)];
			_button.graphics.beginGradientFill(GradientType.LINEAR, gradientOn, [1.0,1.0,1.0,1.0], [0x00,0x40,0x80,0xff], matr);
			_button.graphics.drawRect(-WIDTH+BUTTON_WIDTH -_extra, 1, WIDTH - BUTTON_WIDTH + 2 + 2*_extra, HEIGHT - 2);
			
			var gradientOff:Array = [Colour.darken(_offColour, -16),Colour.darken(_offColour, -16),Colour.lighten(_offColour, 64),Colour.lighten(_offColour, 32)];
			_button.graphics.beginGradientFill(GradientType.LINEAR, gradientOff, [1.0,1.0,1.0,1.0], [0x00,0x40,0x80,0xff], matr);
			_button.graphics.drawRect(BUTTON_WIDTH-2-2*_extra, 1, WIDTH - BUTTON_WIDTH + 2 + 2*_extra, HEIGHT - 2);
			
			matr.createGradientBox(BUTTON_WIDTH, HEIGHT, Math.PI/2, 0, 0);
			var buttonGradient:Array = state ? [Colour.darken(_buttonColour),Colour.darken(_buttonColour, -32),Colour.lighten(_buttonColour, 32)]
			: [_buttonColour,Colour.darken(_buttonColour, -32),Colour.lighten(_buttonColour, 32)];
			
			_button.graphics.beginFill(OUTLINE);
			_button.graphics.drawRoundRect(0, 0, BUTTON_WIDTH -_curve/4 +2, HEIGHT, _curve);
			_button.graphics.beginGradientFill(GradientType.LINEAR, buttonGradient, [1.0,1.0,1.0], [0x00,0x80,0xff], matr);
			_button.graphics.drawRoundRect(1, 1, BUTTON_WIDTH - 2 -_curve/4 +2, HEIGHT - 2, _curve);
			
		//	_button.cacheAsBitmap = true;
		}
		
		
		protected function mouseDown(event:MouseEvent):void {
			_lastPosition = _button.x;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			_start = mouseX - _button.x;
			_delta = 0;
			drawButton(true);
		//	event.stopPropagation();
		}
		
		
		override public function touchCancel():void {
			_button.x = _lastPosition;
			drawButton(false);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		
		
		protected function mouseMove(event:MouseEvent):void {
			var position:Number = mouseX - _start;
			if (position < 0)
				position = 0;
			else if (position > WIDTH - BUTTON_WIDTH  + _extra)
				position = WIDTH - BUTTON_WIDTH  + _extra;
			_delta += Math.abs(_button.x - position);
			_button.x = position;
		}
		
		
		protected function mouseUp(event:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			drawButton(false);
			if (_delta < THRESHOLD)
				_move = _state ? -MOVE_X : MOVE_X;
			else
				_move = (_button.x < (WIDTH-BUTTON_WIDTH+_extra) / 2) ? -MOVE_X : MOVE_X;
			if (mouseX > 0 && mouseX < WIDTH && mouseY > 0 && mouseY < HEIGHT || _delta>0) {
				_timer.reset();
				_timer.start();
			}
		}
		
/**
 *  Animate switch movement
 */	
		protected function slide(event:TimerEvent):void {
			_button.x += _move;
			if (_button.x <= 0) {
				_button.x = 0;
				_state = false;
				stop();
			}
			else if (_button.x >= WIDTH-BUTTON_WIDTH) {
				_button.x = WIDTH-BUTTON_WIDTH + _extra;
				_state = true;
				stop();
			}
		}
		
		
		override public function get theWidth():Number {
			return WIDTH;
		}
		
/**
 *  Stop switch movement
 */	
		protected function stop():void {
			_timer.stop();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		override public function destructor():void {
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			_timer.removeEventListener(TimerEvent.TIMER, slide);
		}
	}
}
