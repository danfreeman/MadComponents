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
	
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	public class Star extends Sprite
	{
		public static const BACK_COLOUR:uint=0x222222;
		public static const FRONT_COLOUR:uint=0xEEEEEE;
		public static const GAP:Number=2.0;
		protected static const UNDEFINED_COLOUR:uint=0x444444;
		
		protected static const SIZE:Number=18;
		protected static const RADIUS:Number=SIZE/2;
		protected static const INNER_RADIUS:Number=SIZE/4;
		protected static const SIDES:int=5;
		
		protected var _amount:Number=-1.0;
		protected var _radius:Number;
		protected var _backColour:uint;
		protected var _frontColour:uint;
		protected var _lineColour:uint;
		
		public function Star(screen:Sprite,xx:Number,yy:Number, size:Number = SIZE, frontColour:uint = FRONT_COLOUR, backColour:uint = BACK_COLOUR)
		{
			_backColour = backColour;
			_frontColour = frontColour;
			_lineColour = frontColour;
			_radius = size/2;
			screen.addChild(this);
			x=xx;y=yy;
			redraw();
			buttonMode=useHandCursor=true;
		}
		
		
		protected function redraw():void
		{
			var matr:Matrix=new Matrix();
			matr.createGradientBox(2*_radius,2*_radius,0);
			graphics.clear();
			graphics.beginFill(0,0);
			graphics.drawRect(0, 0, 2*_radius + GAP, 2*_radius);
			graphics.lineStyle(1,_lineColour);
			if (_amount<0.0) graphics.beginFill(UNDEFINED_COLOUR);
			else graphics.beginGradientFill(GradientType.LINEAR,[_frontColour,_frontColour,_backColour,_backColour],[1.0,1.0,1.0,1.0],[0,_amount*255,_amount*255,255],matr);
			graphics.moveTo(_radius,0);
			for (var i:int=1;i<=SIDES;i++)
			{
				graphics.lineTo(_radius+_radius/2*Math.sin(2*Math.PI*(i-.5)/SIDES),_radius-_radius/2*Math.cos(2*Math.PI*(i-.5)/SIDES));
				graphics.lineTo(_radius+_radius*Math.sin(2*Math.PI*i/SIDES),_radius-_radius*Math.cos(2*Math.PI*i/SIDES));
			}
		}
		
/**
 * Set the star amount between 0 and 1
 */
		public function set amount(value:Number):void
		{
			_amount=value;
			redraw();
		}

	}
}