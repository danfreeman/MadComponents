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
	import flash.text.engine.TextLine;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import com.danielfreeman.madcomponents.*;
	import flash.display.Sprite;

/**
 *  MadComponent labelFTE
 * <pre>
 * &lt;labelFTE
 *   id = "IDENTIFIER"
 *   background = "#rrggbb, #rrggbb, ..."
 *   alignH = "left|right|centre|fill"
 *   alignV = "top|bottom|centre"
 *   visible = "true|false"
 *   clickable = "true|false"
 *   leading = "NUMBER"
 *   rightToLeft = "true|false"
 *   cffHinting = "STRING"
 *   fontLookup = "STRING"
 *   fontName = "STRING"
 *   fontPosture = "STRING"
 *   fontWeight = "STRING"
 *   locked = "true|false"
 *   renderMode = "STRING"
 *   alignmentBaseline = "STRING"
 *   alpha = "NUMBER"
 *   baselineShift ="NUMBER"
 *   breakOpportunity = "STRING"
 *   color = "#rrggbb"
 *   digitCase = "STRING"
 *   digitWidth = "STRING"
 *   dominantBaseline = "STRING"
 *   fontSize = "Number"
 *   kerning = "STRING"
 *   ligatureLevel = "STRING"
 *   local = "STRING"
 *   locked = "true|false"
 *   textRotation = "STRING"
 *   trackingLeft = "NUMBER"
 *   trackingRight = "NUMBER"
 *   typographicCase = "STRING"
 * /&gt;
 * </pre>
 */
	public class UILabelFTE extends MadSprite {
		
		protected static const DEFAULT_FONT_SIZE:Number = 16;
		
		protected var _fontDescription:FontDescription = new FontDescription();
		protected var _elementFormat:ElementFormat;
		protected var _leading:Number = 1.2;
		protected var _rightToLeft:Boolean = false;
		protected var _textElement:TextElement;
		protected var _textBlock:TextBlock = new TextBlock();
		protected var _xml:XML;
		

		public function UILabelFTE(screen:Sprite, xml:XML, attributes:Attributes) {
			super(screen, attributes);
			xmlText = xml;
		}
		
		
		protected function extractText():void {
			if (_xml.@leading.length() > 0) {
				_leading = parseFloat(_xml.@leading);
			}
			if (_xml.@rightToLeft == "true") {
				_rightToLeft = true;
			}

			var xmlAttributes:XMLList = _xml.attributes();
			for each (var fontAttribute:XML in xmlAttributes) {
				var fontKey:String = fontAttribute.name();
				if (_fontDescription.hasOwnProperty(fontKey)) {
					if (fontAttribute.toString().substr(0, 1) == "#") {
						_fontDescription[fontKey] = UI.toColourValue(fontAttribute.toString());
					}
					else {
						_fontDescription[fontKey] = fontAttribute.toString();
					}
				}
			}

			_elementFormat = new ElementFormat(_fontDescription);
			_elementFormat.fontSize = DEFAULT_FONT_SIZE;
			for each (var elementAttribute:XML in xmlAttributes) {
				var elementKey:String = elementAttribute.name();
				if (_elementFormat.hasOwnProperty(elementKey)) {
					if (elementAttribute.toString().substr(0,1) == "#") {
						_elementFormat[elementKey] = UI.toColourValue(elementAttribute.toString());
					}
					else {
						_elementFormat[elementKey] = elementAttribute.toString();
					}
				}
			}
			
			_textElement = new TextElement(_xml.toString(), _elementFormat);
			_textBlock.content = _textElement;
		}
		
/**
 * Set the label text. 
 */		
		public function set xmlText(value:XML):void {
			_xml = value;
			extractText();
			drawComponent();
		}
		
		
		override public function layout(attributes:Attributes):void {
			super.layout(attributes);
			drawComponent();
		}
		
		
		public function drawComponent():void {
			clear();
			
			var currentLine:TextLine;
			var previousLine:TextLine;

			currentLine = _textBlock.createTextLine(null, attributes.widthH);
			previousLine = null;
			 
			while (currentLine != null)
			{
				if (_rightToLeft) {
					currentLine.x = int(attributes.widthH - currentLine.width);
				}
				currentLine.y = int(previousLine ? previousLine.y + currentLine.height * _leading : currentLine.ascent);
				previousLine = currentLine;	
				currentLine = _textBlock.createTextLine(previousLine, attributes.widthH);
			}
			currentLine = _textBlock.firstLine;
			while (currentLine != null) {
				this.addChild(currentLine);
				currentLine = currentLine.nextLine;
			}
		}
		
/**
 * Clear the text. 
 */	
		public function clear():void {
			if (_textBlock.firstLine) {
				_textBlock.releaseLines(_textBlock.firstLine, _textBlock.lastLine);
			}
			removeChildren();
		}
		
	}
}