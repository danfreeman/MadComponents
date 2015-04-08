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
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextFormat;
/**
 *  MadComponents circular container
 * <pre>
 * &lt;circular
 *   id = "IDENTIFIER"
 *   background = "#rrggbb, #rrggbb, ..."
 *   alignH = "left|right|centre|fill"
 *   alignV = "top|bottom|centre"
 * /&gt;
 * </pre>
 */
	public class UICircular extends UIContainerBaseClass {

		protected var _radius:uint = uint.MAX_VALUE;
		protected var _maximumWidth:Number = 0.0;
		protected var _maximumHeight:Number = 0.0;
		protected var _startAngle:Number = 0;
		protected var _finishAngle:Number;


		public function UICircular(screen:Sprite, xml:XML, attributes:Attributes) {
			super(screen, xml, attributes);
		}
		
		
		override protected function initialise(xml:XML, attributes:Attributes):void {
			
			if (xml.@radius.length() > 0) {
				_radius = parseInt(xml.@radius);
			}
			if (xml.@startAngle.length() > 0) {
				_startAngle = parseFloat(xml.@startAngle);
			}
			if (xml.@finishAngle.length() > 0) {
				_finishAngle = parseFloat(xml.@finishAngle);
			}
			else {
				_finishAngle = (xml.children().length() - 1) * 360 / xml.children().length();
			}
						
			for each (var xmlChild:XML in xml.children()) {
				var childAttributes:Attributes = attributes.copy(xml, true);
				var localName:String = xmlChild.localName();
				if (UI.isContainer(localName)) {
					var child:DisplayObject = UI.containers(this, xmlChild, childAttributes);
					_maximumWidth = Math.max(_maximumWidth, child.width);
					_maximumHeight = Math.max(_maximumHeight, child.height);
				}
				else {
					trace(localName," not supported by UICircular");
				}
			}
		}
		
		
		override public function layout(attributes:Attributes):void {
			super.layout(attributes);
			drawComponent();
		}
		
		
		override public function drawComponent():void {
			super.drawComponent();
			var useRadius:int = Math.min(_radius, (_attributes.width - _maximumWidth) / 2, (_attributes.height - _maximumHeight) / 2);
			var interval:Number = (_finishAngle - _startAngle) / (numChildren - 1);
			for (var i:int = 0; i < numChildren; i++) {
				var angle:Number = (_startAngle + i * interval) / 180 * Math.PI;
				var item:DisplayObject = getChildAt(i);
				item.x = _attributes.width / 2 + useRadius * Math.sin(angle) - item.width / 2;
				item.y = _attributes.height / 2 - useRadius * Math.cos(angle) - item.height / 2;
			}
		}
	}
}