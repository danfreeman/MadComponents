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
	import flash.utils.getDefinitionByName;


/**
 * Patch Nine image
 * <pre>
 * &lt;image9
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

	public class UIImage9 extends UIContainerBaseClass
	{
		protected var _skin:DisplayObject = null;
		protected var _skinContainer:Sprite = new Sprite();
		protected var _skinBitmap:Bitmap = null;
		protected var _colour:uint = 0xffffff;


		public function UIImage9(screen:Sprite, xml:XML, attributes:Attributes) {
			super(screen, xml, attributes);
			text = xml.toString();
		}
		
		
		override public function drawComponent():void {
			graphics.clear();
			if (_skinBitmap) {
				removeChild(_skinBitmap);
			}
			if (!_skin) {
				graphics.beginFill(_colour);
				graphics.drawRect(0, 0, _attributes.widthH, _attributes.heightV);
			}
			else {
				_skin.width = _attributes.widthH;
				_skin.height = _attributes.heightV;
				var myBitmapData:BitmapData = new BitmapData(_attributes.widthH, _attributes.heightV, true, 0x00FFFFFF);
				myBitmapData.draw(_skinContainer);
				addChild(_skinBitmap = new Bitmap(myBitmapData));
				_skinBitmap.smoothing = true;
			}
		}		
		
/**
 * Set image
 */	
		public function set text(value:String):void {
			if (value.substr(0,1) == "#") {
				_colour = parseInt(value.substr(1), 16);
			}
			else if (value!="") {
				skinClass = getDefinitionByName(value) as Class;
			}
		}
		
		
		public function set skinClass(value:Class):void {
			if (_skin)
				_skinContainer.removeChild(_skin);
			_skinContainer.addChild(_skin = new value());
			drawComponent();
		}
	}
}