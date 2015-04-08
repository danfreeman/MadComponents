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
	
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.display.Sprite;
	import flash.display.DisplayObject;

/**
 *  MadComponents renderer
 * <pre>
 * &lt;navigation
 *    id = "IDENTIFIER"
 *    colour = "#rrggbb"
 *    background = "#rrggbb, #rrggbb, ..."
 *    visible = "true|false"
 *    gapV = "NUMBER"
 *    gapH = "NUMBER"
 *    style7 = "true|false"
 * </pre>
 */
	public class UIRenderer extends UIContainerBaseClass {

		protected var _childAttributes:Vector.<Attributes>;
		protected var _children:Vector.<DisplayObject>;
		protected var _alignRight:Vector.<Boolean>;
		
		
		public function UIRenderer(screen:Sprite, xml:XML, attributes:Attributes) {
			super(screen, xml, attributes);
		}
		
		
		override protected function initialise(xml:XML, attributes:Attributes):void {
			_childAttributes = new <Attributes>[];
			_children = new <DisplayObject>[];
			_alignRight = new <Boolean>[];
			for each (var xmlChild:XML in xml.children()) {
				var childAttributes:Attributes = attributes.copy(xml, true);
				childAttributes.y = 0;
				var localName:String = xmlChild.localName();
				if (UI.isContainer(localName)) {
					_childAttributes.push(childAttributes);
					_children.push(UI.containers(this, xmlChild, childAttributes));
					_alignRight.push(xmlChild.@alignH == "right");
				}
				else {
					trace(localName," not supported by UIRenderer");
				}
			}
		}

		
		override public function drawComponent():void {
			var left:Number = 0;
			var right:Number = _attributes.widthH;
			var lastY:Number = 0;
			var image:UIImage = (_children.length > 0 && _children[0] is UIImage) ? UIImage(_children[0]) : null;
			if (image) {
				left = image.width + _attributes.paddingH;
			}
		//	var childAttributes:Attributes = _attributes.copy(_xml, true);
			for (var i:int = image ? 1 : 0; i < _children.length; i++) {
				var child:DisplayObject = _children[i];
				if (child is IComponentUI) {
					var childAttributes:Attributes = _childAttributes[i];
					childAttributes.x = left;
					childAttributes.width = right - left;
					IComponentUI(child).layout(childAttributes);
					child.y = lastY;
					if (_alignRight[i]) {
						right = right - child.width;
						child.x = right;
					}
					else {
						child.x = left;
						lastY += child.height + _attributes.paddingV;
					}
				}
			}
			if (image) {
				var offset:Number = (image.height - lastY + _attributes.paddingV) / 2;
				if (offset > 0) {
					for (var j:int = 1; j < _children.length; j++) {
						_children[j].y += offset;
					}
				}
			}
		}
		
		
		override public function destructor():void {
			super.destructor();
			for each (var child:DisplayObject in _children) {
				if (child is IComponentUI) {
					IComponentUI(child).destructor();
				}
			}
		}
	}
}