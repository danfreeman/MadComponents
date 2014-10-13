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

package com.danielfreeman.extendedMadness {

	import com.danielfreeman.madcomponents.*;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

/**
 *  MadComponents star rating
 * <pre>
 * &lt;starRating
 *    id = "IDENTIFIER"
 *    colour = "#rrggbb"
 *    background = "#rrggbb, #rrggbb, …"
 *    alignH = "left|right|centre|fill"
 *    alignV = "top|bottom|centre|fill"
 *    visible = "true|false"
 *    alt = "true|false"
 * /&gt;
 * </pre>
 */	
	public class UIStarRating extends MadSprite
	{
		protected static const STARS:int=5;
		protected static const ALT_SIZE:Number=18;
		protected static const SIZE:Number=40;
		
		protected var _stars:Array=[];
		protected var _amount:Number = 0.0;
		protected var _backColour:uint;
		protected var _frontColour:uint;
		
		
		public function UIStarRating(screen:Sprite, xml:XML, attributes:Attributes) {
			var size:Number = (xml.@alt.length()>0 && xml.@alt[0]=="true") ? ALT_SIZE : SIZE;
			var onColour:uint = attributes.backgroundColours.length>0 ? attributes.backgroundColours[0] : Star.FRONT_COLOUR;
			var offColour:uint = attributes.backgroundColours.length>1 ? attributes.backgroundColours[1] : Star.BACK_COLOUR;
			
			screen.addChild(this);
			for (var i:int=0;i<STARS;i++) {
				var star:Star=new Star(this,i*(Star.GAP+size), 0, size, onColour, offColour);
				star.name=i.toString();
				_stars.push(star);
			}
			addEventListener(MouseEvent.MOUSE_UP,mouseUp);
			if (xml.@value.length()>0) {
				value = parseFloat(xml.@value[0]);
			}
		}
		
		
		protected function mouseUp(event:MouseEvent):void {
			value=parseInt(event.target.name) + 1.0;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		public function set value(valu:Number):void {
			_amount = valu;
			var i:int;
			var fractional:Number=valu-Math.floor(valu);
			for (i=0;i<Math.floor(valu);i++) Star(_stars[i]).amount=1.0;
			for (i=Math.floor(valu)+1;i<STARS;i++) Star(_stars[i]).amount=0.0;
			if (valu<5)
				Star(_stars[Math.floor(valu)]).amount=fractional;
		}
		
		
		public function get value():Number {
			return _amount;
		}
		
	}
}