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
	import asfiles.MyEvent;
	import asfiles.MyTextMenu;
	
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;

/**
 * Menu (combo-box) component
 * <pre>
 * &lt;menu
 *    id = "IDENTIFIER"
 *    background = "#rrggbb, #rrggbb, ..."
 *    alignH = "left|right|centre|fill"
 *    alignV = "top|bottom|centre|fill"
 *    visible = "true|false"
 * 	  alt = "true|false"
 *    value = "TEXT"
 *    prompt = "TEXT"
 * /&gt;
 * </pre>
 * */
	public class UIMenu extends MyTextMenu implements IComponentUI {
		
		public static const SELECTED:String = "selected";
		protected static const COLOUR:uint = 0xFEFEFE;
		protected static const EXTRA:Number = 32.0;
		protected static const CURVE:Number = 8.0;
		protected static const ARROW_COLOUR:uint = 0x333333;
		protected static const ARROW_SIZE:Number = 6.0;
		protected static const WIDTH:Number = 90.0;
			
		protected var _font:String = "";
		protected var _attributes:Attributes;
		protected var _clickable:Boolean = true;
		protected var _includeInLayout:Boolean = true;
		protected var _colour:uint;
		protected var _width:Number;


		public function UIMenu(screen:Sprite, xml:XML, attributes:Attributes) {
			_attributes = attributes;
			_colour = (attributes.backgroundColours.length>0) ? attributes.backgroundColours[0] : COLOUR;
			super(screen,attributes.x,attributes.y,null,(xml.@value.length()>0) ? xml.@value[0].toString() : "menu", (xml.@hint.length()>0) ? xml.@hint[0].toString() : "");
			txt.x = ARROW_SIZE;
			if (xml.data.length()>0) {
				xmlData = xml.data[0];
			}
			if (xml.font.length()>0) {
				_font = xml.font[0].toXMLString();
				txt.htmlText = _font.substr(0,_font.length-2) + ">" + txt.text + "</font>";
			}
			if (xml.@alt.length()==0 || xml.alt[0]=="false") {
				txt.scaleX=txt.scaleY=mnu.scaleX=mnu.scaleY=2.0;
			}
			_width = attributes.fillH ? attributes.widthH : Math.max(width+EXTRA, WIDTH);
			drawComponent();
		}
		
		
		public function drawComponent():void {
			var matr:Matrix = new Matrix();
			var gradient:Array = [Colour.lighten(_colour,80),_colour,Colour.darken(_colour, -32)];
			matr.createGradientBox(_width, height, Math.PI/2, 0, 0);
			graphics.clear();
			graphics.beginFill(Colour.darken(_colour));
			graphics.drawRoundRect(0, 0, _width, height, CURVE);
			graphics.beginGradientFill(GradientType.LINEAR, gradient, [1.0,1.0,1.0], [0x00,0x80,0xff], matr);
			graphics.drawRoundRect(1, 1, _width-2, height-2, CURVE);
			graphics.beginFill(ARROW_COLOUR);
			graphics.moveTo(_width-2*ARROW_SIZE, (height-ARROW_SIZE)/2);
			graphics.lineTo(_width-ARROW_SIZE, (height-ARROW_SIZE)/2);
			graphics.lineTo(_width-1.5*ARROW_SIZE, (height+ARROW_SIZE)/2);
			graphics.lineTo(_width-2*ARROW_SIZE, (height-ARROW_SIZE)/2);
		}
		
		
		public function get attributes():Attributes {
			return _attributes;
		}
		
		
	//	public function get xml():XML {
	//		return _xml;
	//	}
		
		
		public function get pages():Array {
			return [];
		}
		
		
		override protected function mnuselected(ev:MyEvent):void {
			if (showop) text=ev.parameters[1];
			dispatchEvent(new MyEvent(SELECTED,val=ev.parameters[0],ev.parameters[1]));
		}
		
/**
 * Set text
 */
		public function set text(value:String):void {
			if (_font=="") {
				txt.text = value;
			}
			else {
				txt.htmlText = txt.htmlText = _font.substr(0,_font.length-2) + ">" + value + "</font>";
			}
		}
		
/**
 * Set menu item labels
 */
		public function set data(value:Array):void {
			options = value;
		}
		
/**
 * Set menu item labels from XML
 */
		public function set xmlData(value:XML):void {
			var result:Array = [];
			var children:XMLList = value.children();
			for each (var child:XML in children) {
				result.push((child.@label.length()>0) ? child.@label[0].toString() : child.localName().toString());
			}
			options = result;
		}
		
		
		public function touchCancel():void {
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
		
		public function layout(attributes:Attributes):void {
			_attributes = attributes;
		}
		
		
		public function destructor():void {	
		}
	}
}