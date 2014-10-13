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
	import asfiles.MyEvent;
	
	import com.danielfreeman.madcomponents.Attributes;
	import com.danielfreeman.madcomponents.Colour;
	
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;

/**
 * Android-style radio button
 * <pre>
 * &lt;radioButton
 *    id = "IDENTIFIER"
 *    background = "#rrggbb, #rrggbb, ..."
 *    alignH = "left|right|centre|fill"
 *    alignV = "top|bottom|centre|fill"
 *    visible = "true|false"
 * 	  alt = "true|false"
 * /&gt;
 * </pre>
 * */
	public class UIRadioButton extends UICheckBox
	{
		public static const TOGGLE:String = "toggle";
		
		protected static var GROUPS:Dictionary = new Dictionary();
		
		protected var _group:EventDispatcher;
		
		public function UIRadioButton(screen:Sprite, xml:XML, attributes:Attributes)
		{
			_group = screen;
			if (xml.@group.length() > 0) {
				var key:String = xml.@group;
				_group = GROUPS[key];
				if (!_group)
					_group = GROUPS[key] = new EventDispatcher();
			}
			super(screen, xml, attributes);
			_group.addEventListener(TOGGLE, toggle);
		}
		
		
		protected function toggle(event:MyEvent):void {
			_state = event.parameters[0] == this;
			buttonChrome();
		}
		
		
		override protected function makeTick():void {
		}
		
		
		override protected function buttonChrome():void {
			var matr:Matrix = new Matrix();
			var gradient:Array = [Colour.lighten(_colour,80),Colour.darken(_colour),Colour.darken(_colour)];
			var size:Number = _alt ? ALT_SIZE : SIZE;

			matr.createGradientBox(size/2, size/2, Math.PI/2, 0, 0);
			graphics.clear();
			graphics.beginFill(0,0);
			graphics.drawRect(0, 0, size+GAP, size);
			graphics.beginFill(_offColour);
			graphics.drawCircle(size/2, size/2, size/2);
			graphics.beginGradientFill(GradientType.LINEAR, gradient, [1.0,1.0,1.0], [0x00,0x80,0xff], matr);
			graphics.drawCircle(size/2, size/2, size/2-1);
			
			var colour:uint = _state ? _onColour : Colour.darken(_colour,-128);
			graphics.beginGradientFill(GradientType.RADIAL, [colour,Colour.lighten(colour)], [1.0,1.0], [0x00,0xff], matr);
			graphics.drawCircle(size/2, size/2, size/4);
		}
		
		
		public function clearState():void {
			_state = false;
			buttonChrome();
		}
		
		
		override protected function redraw():void {
			_group.dispatchEvent(new MyEvent(TOGGLE, this));
			buttonChrome();
		}
		
		
		override public function destructor():void {
			super.destructor();
			_group.removeEventListener(TOGGLE, toggle);
		}
	}
}