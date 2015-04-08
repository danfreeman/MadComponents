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
	
	import flash.display.Sprite;
	import com.danielfreeman.madcomponents.*;


/**
 *  MadComonents tick icon
 * <pre>
 * &lt;tick
 *   id = "IDENTIFIER"
 *   colour = "#rrggbb"
 *   background = "#rrggbb, #rrggbb, ..."
 *   alignH = "left|right|centre"
 *   alignV = "top|bottom|centre"
 *   visible = "true|false"
 *   alt = "true|false"
 *   clickable = "true|false"
 * /&gt;
 * </pre>
 */	
	public class UITick extends Sprite {
		
		public static const SIZE:Number = 18.0;
		public static const HEAD:Number = 6.0;
		protected static const HEIGHT:Number = SIZE - HEAD + WIDTH;		
		protected static const WIDTH:Number = 4.0;
		
		protected var _width:Number = WIDTH;
		
		
		public function UITick(screen:Sprite, xx:Number, yy:Number, colour:uint, alt:Boolean = false) {
			screen.addChild(this);
			x=xx;y=yy;
		//	clickable = 
			mouseEnabled = false;
			if (alt)
				_width = 6;
			this.colour = colour;
		}
		
/**
 *  Set the colour of the tick
 */	
		public function set colour(value:uint):void {
			graphics.clear();
			graphics.beginFill(value);
			graphics.moveTo(0, HEIGHT-HEAD);
			graphics.lineTo(0, HEIGHT-HEAD+_width);
			graphics.lineTo(HEAD, HEIGHT+_width);
			graphics.lineTo(SIZE, _width);
			graphics.lineTo(SIZE, 0);
			graphics.lineTo(HEAD, HEIGHT);
			graphics.lineTo(0, HEIGHT-HEAD);
		}
		
/**
 *  Set the visibility of the tick "true" or "false"
 */	
		public function set text(value:String):void {
			visible = value!="false";
		}
	}
}