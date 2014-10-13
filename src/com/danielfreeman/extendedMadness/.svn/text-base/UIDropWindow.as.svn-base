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
	import com.danielfreeman.madcomponents.Attributes;
	import com.danielfreeman.madcomponents.Colour;
	import com.danielfreeman.madcomponents.UIWindow;
	
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;

/**
 * Window with pointer at the top
 */
	public class UIDropWindow extends UIWindow
	{
		public static const ARROW:Number = 20.0;
		public static const CURVE:Number = 8.0;
		
		protected var _arrowPosition:Number;

		public function UIDropWindow(screen:Sprite, xml:XML, attributes:Attributes=null) {
			_arrowPosition = xml.@arrowPosition.length()>0 ? parseFloat(xml.@arrowPosition) : 0;
			super(screen, xml, attributes);
		}
		
		override public function layout(attributes:Attributes):void {
			super.layout(attributes);
			drawBackground(attributes.backgroundColours);
		}
		
		
		override public function drawBackground(colours:Vector.<uint> = null):void {
			graphics.clear();
			if (!colours)
				colours = _attributes.backgroundColours;
			
			if (colours.length>3) {
				graphics.beginFill(colours[3], SHADOW_ALPHA);
			}
			else {
				graphics.beginFill(SHADOW_COLOUR, SHADOW_ALPHA);
			}
			graphics.drawRoundRect(attributes.x-CURVE + SHADOW_OFFSET, attributes.y-CURVE + SHADOW_OFFSET, attributes.width + 2 * CURVE, attributes.height + 2 * CURVE, 2 * CURVE );
			
			var fillColour:uint = FILL_COLOUR;
			
			if (colours.length==1) {
				graphics.beginFill(fillColour = colours[0]);
			}
			else if (colours.length>1) {
				var matr:Matrix=new Matrix();
				matr.createGradientBox(width,height, Math.PI/2, 0, 0);
				graphics.beginGradientFill(GradientType.LINEAR, [colours[0],colours[1]], [1.0,1.0], [0x00,0xff], matr);
				fillColour = colours[0];
			}
			else {
				graphics.beginFill(FILL_COLOUR);
			}
			
			if (colours.length>2) {
				graphics.lineStyle(OUTLINE,colours[2], 1.0, true);
			}
			else {
				graphics.lineStyle(OUTLINE,Colour.darken(fillColour, -16), 1.0, true);
			}
			
			graphics.moveTo(attributes.x - CURVE, attributes.y);
			
			if (_arrowPosition==0) {
				graphics.lineTo(attributes.x - CURVE + ARROW, attributes.y - CURVE - ARROW);
				graphics.lineTo(attributes.x - CURVE + 2 * ARROW, attributes.y - CURVE);
			}
			else {
				graphics.curveTo(attributes.x - CURVE, attributes.y - CURVE, attributes.x, attributes.y - CURVE);
				graphics.lineTo(_arrowPosition + attributes.x - CURVE - ARROW, attributes.y - CURVE);
				graphics.lineTo(_arrowPosition + attributes.x - CURVE, attributes.y - CURVE - ARROW);
				graphics.lineTo(_arrowPosition + attributes.x - CURVE + ARROW, attributes.y - CURVE);
			}
			
			graphics.lineTo(attributes.x + attributes.width, attributes.y - CURVE);
			graphics.curveTo(attributes.x + attributes.width + CURVE, attributes.y - CURVE, attributes.x + attributes.width + CURVE, attributes.y);
			graphics.lineTo(attributes.x + attributes.width + CURVE, attributes.y + attributes.height);
			graphics.curveTo(attributes.x + attributes.width + CURVE, attributes.y + attributes.height + CURVE, attributes.x + attributes.width, attributes.y + attributes.height + CURVE);
			graphics.lineTo(attributes.x, attributes.y + attributes.height + CURVE);
			graphics.curveTo(attributes.x - CURVE, attributes.y + attributes.height + CURVE, attributes.x - CURVE, attributes.y + attributes.height);
			graphics.lineTo(attributes.x - CURVE, attributes.y);
		}
	}
}