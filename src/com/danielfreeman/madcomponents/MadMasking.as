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
	import flash.display.Shape;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	

	public class MadMasking extends MadSprite {

	protected var _masking:Boolean = false;
	protected var _mask:Shape = null;
	protected var _xml:XML;
	protected var _maskSize:Point;
	
		
		public function MadMasking(screen:Sprite, xml:XML, attributes:Attributes) {
			_xml = xml;
			super(screen, attributes.copy());
			_maskSize = new Point(attributes.widthH, attributes.heightV);
		}
		
		
		public function set masking(value:Boolean):void {
			if (value) {
				doMasking();
			}
			else if (_mask) {
				_mask.graphics.clear();
				_mask.graphics.beginFill(0);
			}
		}
		
		
		public function startMasking():void {
			masking = _masking = _xml.@mask.length()>0 && _xml.@mask[0]!="false";
		}
		
		
		public function refreshMasking(attributes:Attributes = null):void {
			setMaskSize(attributes ? attributes : _attributes);
			masking = _masking;
		}
		
		
		public function setMaskSize(attributes:Attributes):void {
			_maskSize.x = attributes.widthH;
			_maskSize.y = attributes.heightV;
		}
		
		
		protected function doMasking(attributes:Attributes = null):void {
			if (!attributes) {
				attributes = _attributes;
			}
			if (!_mask) {
				_mask = new Shape();
				addChild(mask = _mask);
			}
			else {
				_mask.graphics.clear();
			}
			_mask.graphics.beginFill(0);
			_mask.graphics.drawRect(0, 0, _maskSize.x, _maskSize.y);
		}
		
		
		public function cutout(rectangle:Rectangle):void {
			if (!_mask) {
				doMasking();
			}
			_mask.graphics.drawRect(rectangle.x, rectangle.y, rectangle.width, rectangle.height);
		}
	}
}
