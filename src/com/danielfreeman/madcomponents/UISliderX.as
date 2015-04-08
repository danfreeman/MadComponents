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

	import flash.display.Sprite;


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

	public class UISliderX extends UISlider implements IComponentUI {

		public function UISliderX(screen : Sprite, xml:XML, attributes:Attributes) {
				super(screen, attributes.x, attributes.y, attributes.backgroundColours, xml.@alt == "true", attributes.style7);
				_attributes = attributes;
				
				if (attributes.fillH) {
					fixwidth = attributes.widthH;
				}
				if (xml.@value.length()>0) {
					value = Number(xml.@value);
				}
		}
		
		
		override public function layout(attributes:Attributes):void {
			super.layout(attributes);
			if (attributes.fillH) {
				fixwidth = attributes.widthH;
			}
		}

	}
}
