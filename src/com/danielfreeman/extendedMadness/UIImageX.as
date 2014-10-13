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
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.display.PixelSnapping;

/**
 *  Image placeholder
 * <pre>
 * &lt;imageX
 *    id = "IDENTIFIER"
 *    alignH = "left|right|centre|fill"
 *    alignV = "top|bottom|centre|fill"
 *    visible = "true|false"
 *    width = "NUMBER"
 *    height = "NUMBER"
 *    clickable = "true|false"
 *    pixelSnapping = "true|false"
 * /&gt;
 * </pre>
 */
	
	public class UIImageX extends UIImage implements IComponentUI {
		
		protected var _images:Vector.<Bitmap>;
		protected var _pixelSnapping:Boolean;
	//	protected var _attributes:Attributes;
	//	protected var _xml:XML;
		
		
		public function UIImageX(screen:Sprite, xml:XML, attributes:Attributes)
		{
		//	_attributes = attributes;
		//	_xml = xml;
			_pixelSnapping = xml.@pixelSnapping == "true";
			super(screen, xml, attributes);
		}
		
		
/**
 *  Set image by assigning a Class, qualified class name, or bitmap, or displayobject
 */
		override public function set text(source:*):void {
			if (source is Class || source==null) {
				imageClass = source;
			}
			else if (source is BitmapData || source is Bitmap) {
				image = source;
			}
			else if (source is String) {
				var dimensions:Array;
				var i:int;
				_images = new <Bitmap>[];
				if (source=="") {
					imageClass = null;
				}
				else if (!isNaN(Number(source.charAt(0)))) {
					graphics.clear();
					graphics.beginFill(0,0);
					dimensions = source.split(",");
					if (dimensions.length>1) {
						graphics.drawRect(0,0,_width=dimensions[0],_height=dimensions[1]);
					}
					else {
						graphics.drawRect(0,0,_width=dimensions[0],_height=dimensions[0]);
					}
					if (dimensions.length>2) {
						for (i = 2; i < dimensions.length; i++) {
							_images.push(Bitmap(new (getDefinitionByName(dimensions[i]) as Class)));	
						}
					}
				}
				else {
					dimensions = source.split(",");
					for (i = 0; i < dimensions.length; i++) {
						_images.push(Bitmap(new (getDefinitionByName(dimensions[i]) as Class)));	
					}					
				}
				scaleImage();
			}
		}
		
		
		public function set images(value:Vector.<Bitmap>):void {
			_images = value;
		}
		
		
		override public function set imageClass(value:Class):void {
			_images = new <Bitmap>[Bitmap(new value())];
			scaleImage();
		}
		
		
		override public function layout(attributes:Attributes):void {
			super.layout(attributes);
			_attributes = attributes;
			_attributesWidth = attributes.widthH;
			_attributesHeight = attributes.heightV;
			scaleImage();
		}		
		
/**
 *  Scale the image
 */
		override protected function scaleImage():void {
			if (!_images && _images.length>0)
				return;
			
			var rectangle:Rectangle = stageRect();
			var maximumArea:Number = 0;
			var bestFit:Bitmap = null;
			for each (var bitmap:Bitmap in _images) {
				if (bitmap.width <= rectangle.width && bitmap.height <= rectangle.height && bitmap.width * bitmap.height > maximumArea) {
					maximumArea = bitmap.width * bitmap.height;
					bestFit = bitmap;
				}
			}
			if (!bestFit) {
				bestFit = _images[0];
			}
			if (bestFit != _image) {
				image = bestFit;
				bestFit.scaleX = bestFit.scaleY = 1 / UI.scale;
				bestFit.pixelSnapping = _pixelSnapping ? PixelSnapping.ALWAYS : PixelSnapping.NEVER;
			}
		}

	}
}