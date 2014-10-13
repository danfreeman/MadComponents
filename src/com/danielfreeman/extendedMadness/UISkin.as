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
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;


/**
 * Image Skin
 * <pre>
 * &lt;skin
 *    id = "IDENTIFIER"
 *    alignH = "left|right|centre|fill"
 *    alignV = "top|bottom|centre|fill"
 *    visible = "true|false"
 *    width = "NUMBER"
 *    height = "NUMBER"
 *    clickable = "true|false"
 * /&gt;
 * </pre>
 * */

	public class UISkin extends UIImage9
	{

		public function UISkin(screen:Sprite, xml:XML, attributes:Attributes) {
			super(screen, xml, attributes);
			includeInLayout = false;
			mouseEnabled = false;
		//	var isRow:Boolean = parent.parent.parent is UIList;
		//	if (isRow) {
				drawSkin();
		//	}
		}

		
		override public function layout(attributes:Attributes):void {
			_attributes = attributes;
			drawSkin();
		}
		
		
		override public function set skinClass(value:Class):void {
			if (_skin) {
				_skinContainer.removeChild(_skin);
			}
			_skinContainer.addChild(_skin = new value());
		}
		
		
		override public function drawComponent():void {
		}
		
		
		protected function drawSkin():void {
			graphics.clear();
			if (_skinBitmap) {
				removeChild(_skinBitmap);
			}
			if (!_skin) {
				graphics.beginFill(_colour);
				graphics.drawRect(-_attributes.paddingH, -_attributes.paddingV, _attributes.widthH+2*_attributes.paddingH, _attributes.height+2*_attributes.paddingV);
			}
			else {
				_skin.width = _attributes.widthH+2*_attributes.paddingH;
				_skin.height = _attributes.heightV+2*_attributes.paddingV;
				var myBitmapData:BitmapData = new BitmapData(_skin.width, _skin.height, true, 0x00FFFFFF);
				myBitmapData.draw(_skinContainer);
				addChild(_skinBitmap = new Bitmap(myBitmapData));
				_skinBitmap.smoothing = true;
				_skinBitmap.x = -_attributes.paddingH;
				_skinBitmap.y = -_attributes.paddingV;	
			}		
		}

	}
}