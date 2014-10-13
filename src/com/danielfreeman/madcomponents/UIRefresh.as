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
	import flash.display.Sprite;
	import flash.text.TextFormat;

/**
 *  MadComponents "Pull down to refresh" item above lists
 */	
	public class UIRefresh extends Sprite
	{
		protected var _refresh:UIActivity;
		protected var _label:UILabel;
		
		public function UIRefresh(screen:Sprite, xx:Number, yy:Number, colour:uint, label:String)
		{
			screen.addChild(this);
			x=xx;y=yy;
			_refresh = new UIActivity(this, 0, 0, true);
			_refresh.scaleX = _refresh.scaleY = 0.3;
			_label = new UILabel(this, 16, -10, label,new TextFormat("Arial",14,colour));
		}
		
		
		public function changeState(label:String, rotate:Boolean):void {
			_label.text = label;
			_refresh.rotate = rotate;
		}
	}
}