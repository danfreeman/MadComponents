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
	
/**
 *  MadSprite adds clickable property
 */
	public class MadSprite extends Sprite implements IComponentUI
	{
		protected var _clickable:Boolean = true;
		protected var _includeInLayout:Boolean = true;
		protected var _attributes:Attributes = null;

		
		public function MadSprite(screen:Sprite, attributes:Attributes = null) {
			if (screen) {
				screen.addChild(this);
			}
			if (attributes) {
				_attributes = attributes;
			}
			else {
				_attributes = new Attributes();
			}
		}
		
		public function set clickable(value:Boolean):void {
			_clickable = value;
		}
		
		public function get clickable():Boolean {
			return _clickable;
		}
		
		public function set includeInLayout(value:Boolean):void {
			_includeInLayout = value;
		}
		
		public function get includeInLayout():Boolean {
			return _includeInLayout;
		}
		
		public function touchCancel():void {
			//override to implement scroll cancel
		}
		
		public function get attributes():Attributes {
			return _attributes;
		}
		
		public function layout(attributes:Attributes):void {
			_attributes = attributes;
		}
		
		public function get theWidth():Number {
			return width;
		}
		
		public function get theHeight():Number {
			return height;
		}
		
		public function set isVisible(value:Boolean):void {
			visible = value;
		}
		
		public function get isVisible():Boolean {
			return visible;
		}
		
		public function destructor():void {
		}
	}
}