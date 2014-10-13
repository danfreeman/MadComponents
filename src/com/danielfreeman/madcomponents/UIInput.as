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

	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;

/**
 * The input has lost input focus
 */
	[Event( name="focusOut", type="flash.events.FocusEvent" )]
	
/**
 * The text has changed
 */
	[Event( name="textInput", type="flash.events.TextEvent" )]
	
	
/**
 *  Input component
 * <pre>
 * &lt;input
 *   id = "IDENTIFIER"
 *   colour = "#rrggbb"
 *   background = "#rrggbb, #rrggbb, ..."
 *   alignH = "left|right|centre|fill"
 *   alignV = "top|bottom|centre"
 *   visible = "true|false"
 *   width = "NUMBER"
 *   alt = "true|false"
 *   prompt = "TEXT"
 *   promptColour = "#rrggbb"
 *   password = "true|false"
 * /&gt;
 * </pre>
 */
	public class UIInput extends MadSprite implements IComponentUI {
	
		protected static const SHADOW_OFFSET:Number = 1.0;
		protected static const WIDTH:Number = 80.0;
		protected static const CURVE:Number = 16.0;
		protected static const CURVE7:Number = 6.0;
		protected static const SIZE_X:Number = 10.0;
		protected static const SIZE_Y:Number = 7.0;
		protected static const SIZE_ALT:Number = 4.0;
		protected static const COLOUR:uint = 0x333339;
		protected static const SHADOW_COLOUR:uint = 0xAAAAAC;
		protected static const BACKGROUND:uint = 0xF0F0F0;
		protected static const BACKGROUND7:uint = 0xFFFFFF;
		
		protected const FORMAT:TextFormat = new TextFormat("_sans", 16, 0x333333);
		
		protected var _format:TextFormat = FORMAT;
		protected var _label:*; //UIBlueText;
		protected var _colours:Vector.<uint>;
		protected var _fixwidth:Number = WIDTH;
		protected var _alt:Boolean;
		protected var _style7:Boolean;
		
	
		public function UIInput(screen:Sprite, xx:Number, yy:Number, text:String, colours:Vector.<uint> = null, alt:Boolean = false, prompt:String="", promptColour:uint = 0x999999, style7:Boolean = false) {
		//	screen.addChild(this);
			super(screen, null);
			x=xx;y=yy;
			_alt = alt;
			_style7 = style7;
			_colours = colours ? colours : new <uint>[];
			inputField = new UIBlueText(this, alt ? SIZE_ALT : SIZE_X, (alt ? SIZE_ALT : SIZE_Y) + 1, prompt, -1, _format, prompt!="", promptColour);
			if (XML(text).hasSimpleContent()) {
				_label.text = text;
			}
			else {
				_label.htmlText = XML(text).children()[0].toXMLString();
			}
			if (_colours.length>4 && _label.hasOwnProperty("highlightColour")) {
				_label.highlightColour = _colours[4];
			}
			if (text != "") {
				UIBlueText(_label).txtchange();
				UIBlueText(_label).focusout();
			}
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			drawOutline();
		}
		
/**
 *  By default, the input field is based on flash.text.TextField.  This allows you to specify an alternative object such as TLFTextField
 */
		public function set inputField(value:*):void {
			if (_label) {
				_label.removeEventListener(Event.CHANGE,textChanged);
				_label.removeEventListener(FocusEvent.FOCUS_OUT,focusOut);
				removeChild(_label);
			}
			_label = value;
			_label.fixwidth = _fixwidth - 2 * (_alt ? SIZE_ALT : SIZE_X);
			_label.addEventListener(Event.CHANGE,textChanged);
			_label.addEventListener(FocusEvent.FOCUS_OUT,focusOut);
			drawOutline();
		}
		
		
		public function get inputField():* {
			return _label;
		}
		
		
		protected function focusOut(event:FocusEvent):void {
			dispatchEvent(new FocusEvent(FocusEvent.FOCUS_OUT));
		}
		
		
		protected function textChanged(event:Event):void {
			dispatchEvent(new TextEvent(TextEvent.TEXT_INPUT));
			event.stopPropagation();
		}
		
		
		protected function mouseDown(event:MouseEvent):void {
			drawOutline(true);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			event.stopPropagation();
		}
		
		
		protected function mouseUp(event:MouseEvent):void {
			drawOutline();
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			if (stage.focus is UIBlueText && UIBlueText(stage.focus).selectionBeginIndex<=0) {
				UIBlueText(stage.focus).setSelection(UIBlueText(stage.focus).text.length, UIBlueText(stage.focus).text.length);
			}
		}
		
/**
 *  Set text of input
 */
		public function set text(value:String):void {
		//	if (value == "") {
		//		text = " ";
		//	}
			_label.text = value;
			drawOutline();
		}
		
/**
 *  Set html text of input
 */
		public function set htmlText(value:String):void {
			_label.htmlText = value;
			drawOutline();
		}
		
		
		public function get text():String {
			return _label.text;
		}
		
/**
 *  Width of input field
 */
		public function set fixwidth(value:Number):void {
			_fixwidth = value;
			_label.fixwidth = value - 2 * (_alt ? SIZE_ALT : SIZE_X);
			drawOutline();
		}
		
		
		public function focus():void {
			stage.focus = _label;
		}
		
/**
 *  Draw input field chrome
 */
		protected function drawOutline(pressed:Boolean = false):void {
			var height:Number = _label.height + 2 * (_alt ? SIZE_ALT : SIZE_Y);
			graphics.clear();
			if (_colours.length > 3) {
				graphics.beginFill(_colours[3]);
				graphics.drawRect(0, 0, _fixwidth, height+1);
			}
			var curve:Number = _style7 ? CURVE7 : CURVE;
			graphics.beginFill(_colours.length > 0 ? _colours[0] : COLOUR);
			graphics.drawRoundRect(0, 0, _fixwidth, height, curve);
			if (_style7) {
				graphics.beginFill(_colours.length > 1 ? _colours[1] : BACKGROUND7);
				graphics.drawRoundRect(1, 1, _fixwidth-2, height-2, curve-1);
			}
			else {
				graphics.beginFill(_colours.length > 2 ? _colours[2] : SHADOW_COLOUR);
				graphics.drawRoundRect(1, 1, _fixwidth-2, height-2, curve-1);
				graphics.beginFill(_colours.length > 1 ? _colours[1] : BACKGROUND);
				graphics.drawRoundRect(2.5, 3, _fixwidth-3.5, height-4, curve-2);
			}
		}
		
		
/**
 *  Stage rectangle
 */		
		public function stageRect():Rectangle {
			var leftTop:Point = _label.localToGlobal(new Point(0,0));
			var rightBottom:Point = _label.localToGlobal(new Point(_label.width,_label.height));
			return new Rectangle(leftTop.x, leftTop.y, rightBottom.x - leftTop.x, rightBottom.y - leftTop.y);
		}
		
		
		override public function destructor():void {
			super.destructor();
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			_label.removeEventListener(Event.CHANGE,textChanged);
			_label.removeEventListener(FocusEvent.FOCUS_OUT,focusOut);
			_label.destructor();
		}
	}
}