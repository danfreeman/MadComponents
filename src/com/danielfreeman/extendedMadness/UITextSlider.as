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
	import flash.text.TextField;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextFormat;
	
	import com.danielfreeman.madcomponents.*;
	
/**
 * The slider value has changed
 */
	[Event( name="change", type="flash.events.Event" )]
	

/**
 *  MadComponent textSlider
 * <pre>
 * &lt;textSlider
 *   id = "IDENTIFIER"
 *   background = "#rrggbb, #rrggbb, ..."
 *   alignH = "left|right|centre|fill"
 *   alignV = "top|bottom|centre"
 *   visible = "true|false"
 *   clickable = "true|false"
 *   width = "NUMBER"
 *   alt = "true|false"
 *   value = "NUMBER"
 *   textColour = "#rrggbb"
 *   highlightTextColour = "#rrggbb"
 *   curve = "NUMBER"
 *   index = "INTEGER"
 * /&gt;
 * </pre>
 */
	public class UITextSlider extends UIProgressBar
	{
		protected static const TALL_SLIDER:Number = 40.0;
		protected static const TEXT_SIZE:Number = 11;
		protected static const BIGGER_TEXT_SIZE:Number = 14;
		
		protected var _letters:Vector.<UILabel> = new <UILabel>[];
		protected var _format:TextFormat = new TextFormat("Arial", TEXT_SIZE, 0x666666);
		protected var _highlightFormat:TextFormat = new TextFormat("Arial", BIGGER_TEXT_SIZE, 0x666666);
		protected var _knobText:UILabel;
		protected var _index:int = -1;
		
		
		public function UITextSlider(screen:Sprite, xml:XML, attributes:Attributes) {
			if (xml.@textColour.length() > 0) {
				_format = new TextFormat("Arial", TEXT_SIZE, UI.toColourValue(xml.@textColour));
			}
			if (xml.@highlightTextColour.length() > 0) {
				_highlightFormat = new TextFormat("Arial", BIGGER_TEXT_SIZE, UI.toColourValue(xml.@highlightTextColour));
			}
			addCharacters(xml);
			super(screen, xml, attributes);
			arrangeLetters();
			if (xml.@index.length() > 0) {
				index = parseInt(xml.@index);
			}
		}
		
		
		protected function addCharacters(xml:XML):void {
			var text:Array = xml.toString().split(" ");
			for each (var character:String in text) {
				var label:UILabel = new UILabel(this, 0, 0, character, _format);
				_letters.push(label);
			}
		}
		
		
		protected function arrangeLetters():void {
			var spacing:Number = (_width - _sliderHeight) / (_letters.length - 1);
			var index:int = 0;
			for each (var label:UILabel in _letters) {
				label.x = index * spacing - label.width / 2 + _sliderHeight / 2;
				label.y = _knob.y - label.height / 2;				
				index++;
			}
		}
		
		
		override public function drawComponent():void {
			super.drawComponent();
			var spacing:Number = (_width - _sliderHeight) / (_letters.length - 1);
			_index = Math.round((_knob.x - _sliderHeight / 2) / spacing);
			_index = Math.min(Math.max(0, _index), _letters.length - 1);
			_knobText.text = _letters[_index].text;
			_knobText.x = -_knobText.width / 2;
			_knobText.y = -_knobText.height / 2 - 1;
		}
		
		
		override protected function createKnob():void {
			addChild(_knob=new Sprite());
			_sliderHeight = 2 * _radius + 2;
			drawKnob();
			_knobText = new UILabel(_knob, 0, 0, "", _highlightFormat);
			_knobText.mouseEnabled = false;
			_curve = (_xml.@curve.length() > 0) ? parseFloat(_xml.@curve) : _sliderHeight;
		}
		
		
		protected function snapToPosition():void {
			var spacing:Number = (_width - _sliderHeight) / (_letters.length - 1);
			var position:Number = _index * spacing + _sliderHeight / 2;
			_value = position / _width;
			_knob.x = position;
			super.drawComponent();
		}
		
		
		public function get index():int {
			return _index;
		}
		
		
		public function set index(value:int):void {
			_index = value;
			snapToPosition();
			_knobText.text = _letters[_index].text;
		}
		
		
		public function get textValue():String {
			return _knobText.text;
		}
		
		
		override protected function mouseUp(event:MouseEvent):void {
			super.mouseUp(event);
			snapToPosition();
		}
		
		
		override public function layout(attributes:Attributes):void {
			super.layout(attributes);
			arrangeLetters();
		}
				
/**
 *  Set value of slider, a number between 0 and 1
 */
		override public function set value(valuu:Number):void {
			super.value = valuu;
			snapToPosition();
		}
		
		
	}
}