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
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;


/**
 *  MadComponent progress bar
 * <pre>
 * &lt;progressBar
 *   id = "IDENTIFIER"
 *   background = "#rrggbb, #rrggbb, ..."
 *   alignH = "left|right|centre|fill"
 *   alignV = "top|bottom|centre"
 *   visible = "true|false"
 *   clickable = "true|false"
 *   width = "NUMBER"
 *   value = "NUMBER"
 * /&gt;
 * </pre>
 */
	public class UIProgressBar extends UISlider implements IContainerUI {
		
		protected var _xml:XML;
		protected var _attributes:Attributes;

		
		public function UIProgressBar(screen:Sprite, xml:XML, attributes:Attributes) {
			super(screen, 0, 0, attributes.backgroundColours, xml.@alt == "true");
			fixwidth = attributes.widthH;
			if (xml.@value.length()>0)
				value = parseFloat(xml.@value);
			
		}
		
		
		override protected function drawKnob():void {
			_knob=new Sprite();
			_sliderHeight = _radius;
		}
		
		
		public function layout(attributes:Attributes):void {
			_attributes = attributes;
			fixwidth = attributes.widthH;
		}
		
		
		public function get attributes():Attributes {
			return _attributes;
		}
		
		
		public function get xml():XML {
			return _xml;
		}
		
		
		public function findViewById(id:String, row:int = -1, group:int = -1):DisplayObject {
			return null;
		}
		
		
		public function clear():void {
			graphics.clear();
		}
		
		
		public function get pages():Array {
			return [];
		}

	}
}
