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
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	public class UITabButtonRow extends Sprite
	{
		public static const OFF_COLOUR:uint = 0x999999;
		public static const ON_COLOUR:uint = 0xF9F9F9;
		public static const BACKGROUND_COLOUR:uint = 0x000000;
		
		protected static const HEIGHT:Number = 64.0;
		protected static const GAP:Number = 2.0;
		protected static const CURVE:Number = 8.0;
		protected static const CURVE2:Number = 14.0;
		protected static const BAR_HEIGHT:Number = 4.0;
		
		protected var _index:int = 0;
		protected var _pressedIndex:int = -1;
		protected var _width:Number;
		protected var _height:Number = HEIGHT;
		protected var _numButtons:int;
		protected var _buttonWidth:Number;
		protected var _pressed:Sprite;
		protected var _highlight:Sprite;
		protected var _offColour:uint = OFF_COLOUR;
		protected var _onColour:uint = ON_COLOUR;
		protected var _backgroundColour:uint = BACKGROUND_COLOUR;
		
		public function UITabButtonRow(screen:Sprite, xml:XML, attributes:Attributes)
		{
			var tabButtonColours:String = xml.@tabButtonColours;
			if (tabButtonColours) {
				var colourVector:Vector.<uint> = UI.toColourVector(tabButtonColours);
				if (colourVector.length > 0)
					_backgroundColour = colourVector[0];
				if (colourVector.length > 1)
					_onColour = colourVector[1];
				if (colourVector.length > 2)
					_offColour = colourVector[2];				
			}
			else { 
				var colours:Vector.<uint> = attributes.backgroundColours;
				if (colours.length > 0)
					_onColour = colours[0];
				if (colours.length > 1)
					_offColour = colours[1];
			}
			screen.addChild(this);
			_numButtons = xml.children().length();
			addChild(_pressed  = new Sprite());
			addChild(_highlight  = new Sprite());
			buttonMode = useHandCursor = true;
			layout(attributes);
		}
		
		
		public function get onColour():uint {
			return _onColour;
		}
		
		
		public function get offColour():uint {
			return _offColour;
		}
		
		
		public function get backgroundColour():uint {
			return _backgroundColour;
		}


		public function set onColour(value:uint):void {
			_onColour = value;
			refresh();
		}
		
		
		public function set offColour(value:uint):void {
			_offColour = value;
			refresh();
		}
		
		
		public function set backgroundColour(value:uint):void {
			_backgroundColour = value;
			refresh();
		}

		
		public function get index():int {
			return _index;
		}
		
		
		public function set index(value:int):void {
			_index = value;
			_highlight.graphics.clear();
			drawAButton(_highlight, _index, _onColour);
		}
		
		
		protected function refresh():void {
			_pressed.graphics.clear();
			_highlight.graphics.clear();
			drawTabButtons(_numButtons);
			drawAButton(_highlight, _index, _onColour);	
		}
		
		
		public function layout(attributes:Attributes):void {
			_width = attributes.width;
			_buttonWidth = _width / _numButtons;
			refresh();
		}
		
		
		protected function drawTabButtons(n:int):void {
			graphics.clear();
			graphics.beginFill(_backgroundColour);
			graphics.drawRect(0, 0, _width, _height);
			for (var i:int = 0; i<n; i++) {
				drawAButton(this, i, _offColour);
			}
			graphics.beginFill(Colour.darken(_onColour));
			graphics.drawRect(0, _height, _width, BAR_HEIGHT);
		}
		
		
		protected function drawAButton(layer:Sprite,i:int, colour:uint):void {
			var matr:Matrix = new Matrix();
			matr.createGradientBox(_buttonWidth, _height, Math.PI/2, 0, 0);
			layer.graphics.beginGradientFill(GradientType.LINEAR, [colour, colour, Colour.darken(colour)], [1.0, 1.0, 1.0], [0x00, 0xAA, 0xFF], matr);
			layer.graphics.moveTo(i*_buttonWidth+GAP, CURVE+1);
			layer.graphics.curveTo(i*_buttonWidth+GAP, 1, i*_buttonWidth+GAP+CURVE, 1);
			layer.graphics.lineTo((i+1)*_buttonWidth-GAP-CURVE, 1);
			layer.graphics.curveTo((i+1)*_buttonWidth-GAP, 1, (i+1)*_buttonWidth-GAP, CURVE+1);
			layer.graphics.lineTo((i+1)*_buttonWidth-GAP, _height-CURVE2);
			layer.graphics.curveTo((i+1)*_buttonWidth-GAP, _height, (i+1)*_buttonWidth-GAP+CURVE2, _height);
			layer.graphics.lineTo(i*_buttonWidth - CURVE2, _height);
			layer.graphics.curveTo(i*_buttonWidth + GAP, _height, i*_buttonWidth + GAP, _height - CURVE2);
			layer.graphics.lineTo(i*_buttonWidth+GAP, CURVE+1);
		}
		
		
		public function mouseDown():void {
			_pressedIndex = Math.floor(mouseX/_buttonWidth);
			drawAButton(_pressed, _pressedIndex, UIList.HIGHLIGHT);
			stage.addEventListener(MouseEvent.MOUSE_UP, clearPressed);
		}
		
		
		public function clearPressed(event:MouseEvent):void {
			_pressed.graphics.clear();
			stage.removeEventListener(MouseEvent.MOUSE_UP, clearPressed);
		}
		
		
		public function mouseUp():int {
			var index:int = Math.floor(mouseX/_buttonWidth);
			if (index == _pressedIndex)
				_index = index;
			_highlight.graphics.clear();
			drawAButton(_highlight, _index, _onColour);
			return _index;
		}
		
	}
}