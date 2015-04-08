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
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Matrix;
	
/**
 * Segmented Control
 * <pre>
 * &lt;segmentedControl
 *    id = "IDENTIFIER"
 *    background = "#rrggbb, #rrggbb, ..."
 *    alignH = "left|right|centre|fill"
 *    alignV = "top|bottom|centre|fill"
 *    visible = "true|false"
 * 	  alt = "true|false"
 * 	  pressedColour = "#rrggbb"
 * /&gt;
 * </pre>
 * */
	public class UISegmentedControl extends UICutCopyPaste implements IComponentUI
	{
		protected static const BUTTON_COLOUR:uint = 0xE6E6E6;
		protected static const BUTTON_COLOUR7:uint = 0xFFFFFF;
		protected static const TEXT_COLOUR:uint = 0x666666;
		protected static const TEXT_COLOUR7:uint = PRESSED_COLOUR;
		protected static const CONTROL_CURVE:Number = 12.0;
		
	//	protected var _attributes:Attributes;
		protected var _xml:XML;
		protected var _textColour:uint;
		
		
		public function UISegmentedControl(screen:Sprite, xml:XML, attributes:Attributes)
		{
			_xml = xml;
			_attributes = attributes;
			_textColour = attributes.style7 ? TEXT_COLOUR7 : TEXT_COLOUR;
			if (xml.@pressedColour.length() > 0) {
				_textColour = UI.toColourValue(xml.@pressedColour);
			}
			if (xml.font.length()>0) {
				_font = xml.font[0];
			}
			var colour:uint = attributes.backgroundColours.length>0 ? attributes.backgroundColours[0] : (attributes.style7 ? BUTTON_COLOUR7 : BUTTON_COLOUR);
			super(screen, 0, 0, 0, colour, attributes.style7 != (xml.@alt == "true"), null, attributes.style7);
			
			colourButtons();
			if (attributes.fillH) {
				fixwidth = attributes.widthH;
			}
			index=0;
		}
		
/**
 * Set width of component
 */
		public function set fixwidth(value:Number):void {
			var textWidth:Number = 0;
			for each (var label0:UILabel in _labels)
				textWidth+=label0.width;
			_gap = (value-textWidth)/(2*_labels.length);
			var left:Number = _gap;
			for each (var label1:UILabel in _labels) {
				label1.x = left;
				left+=label1.width + 2*_gap;
			}
			buttonChrome(value);
			showPressed();
		}
		
		
		override public function layout(attributes:Attributes):void {
			super.layout(attributes);
			if (attributes.fillH) {
				fixwidth = attributes.widthH;
			}
			if (attributes.fillV) {
				_height = attributes.heightV;
			}
			
		}
		
		
		override protected function initialise(words:Vector.<String>):void {
			_lineColour = _attributes.style7 ? TEXT_COLOUR7 : Colour.darken(_colour,-32);
			if (_xml.@lineColour.length() > 0) {
				_lineColour = UI.toColourValue(_xml.@lineColour);
			}
			_curve = _attributes.style7 ? CURVE7 : (_attributes.backgroundColours.length>2 ? _attributes.backgroundColours[2] : CONTROL_CURVE);
			_pressedColour = _attributes.backgroundColours.length>1 ? _attributes.backgroundColours[1] : PRESSED_COLOUR;
			if (_attributes.fillV) {
				_height = _attributes.heightV;
			}
			if (_xml.data.length()==1) {
				drawButtons(extractData(_xml.data[0]));
			}
		}
		
		
		public function set vectorData(value:Vector.<String>):void {
			clear();
			drawButtons(value);
			colourButtons();
			index = _index;
		}
		
		
		public function set data(value:Array):void {
			var vector:Vector.<String> = new <String>[];
			for each (var item:* in value) {
				if (item is String) {
					vector.push(item);
				}
				else {
					vector.push(item.label);
				}
			}
			vectorData = vector;

		}
		
		
		public function set xmlData(value:XML):void {
			vectorData = extractData(value);
		}
		
		
		protected function extractData(xml:XML):Vector.<String> {
			var result:Vector.<String> = new Vector.<String>();
			for each (var item:XML in xml.children()) {
				if (item.@label.length()>0) {
					result.push(item.@label.toString());
				}
				else {
					result.push(item.localName());
				}
			}
			return result;
		}
				
		
		override protected function mouseUp(event:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			if (_ready && event.target == this) {
				if (_index>=0 && !_font) {
					_labels[_index].textColor = _textColour;
				}
				updateIndex();
				dispatchEvent(new Event(Event.CHANGE));
				showPressed();
			}
			_ready = false;
		}
		
		
/**
 * Set index of active segment
 */	
		override public function set index(value:int):void {
			if (_index>=0 && !_font) {
				_labels[_index].textColor = _textColour;
			}
			_index = value;
			showPressed();
		}
		
		
		protected function colourButtons():void {
			if (!_font)
				for each (var label:UILabel in _labels) {
					label.textColor = _textColour;
					label.y = (_height - label.height) / 2;
				}
		}
		
		
		public function clear():void {
			for each (var label:UILabel in _labels)
				removeChild(label);
			_labels = new <UILabel>[];
		}
		
		
		public function clearPressed():void {
			_pressedLayer.graphics.clear();
		}
		
		
		override public function destructor():void {
			super.destructor();
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		}
	}
}