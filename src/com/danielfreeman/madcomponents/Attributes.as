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

	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;

/**
* Contains properties such as the colours, width, height, padding, and dimensions of a component
*/
	public class Attributes extends Rectangle {
	
		public static const TRANSPARENT:uint = uint.MAX_VALUE;
		public static const FILL:String = "fill";
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		public static const CENTRE:String = "centre";
		public static const TOP:String = "top";
		public static const BOTTOM:String = "bottom";
	//	public static const NO_SCROLL:String = "no scroll";

		protected static const GAP:Number = 8;
		protected static const GAP7:Number = 16;
		public static const COLOUR:uint = 0x9999AA;
		public static const COLOUR7:uint = 0xEFEFF4;
		protected static const SCROLLBAR_COLOUR:uint = 0x555555;
		protected static const ALIGN_V:String = "top";
		protected static const ALIGN_H:String = "left";
		
		protected var _scrollBarColour:uint = SCROLLBAR_COLOUR;
		protected var _paddingV:Number = GAP;
		protected var _paddingH:Number = GAP;
		protected var _colour:uint = COLOUR;
		protected var _alignV:String = ALIGN_V;
		protected var _alignH:String = ALIGN_H;
		protected var _visible:Boolean = true;
		protected var _id:String = "";
		protected var _colours:Vector.<uint> = new Vector.<uint>;
		protected var _width:int = -1;
		protected var _height:int = -1;
		protected var _hasBorder:Boolean = false;
		protected var _clickable:String = "";
		protected var _style7:Boolean = false;


		public function Attributes(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0) {
			if (width<0) {
				width = 0;
			}
			if (height<0) {
				height = 0;
			}	
			super(x, y, width, height);
		}
		
		
/**
* Extracts Attribute properties from XML
*/
		public function parse(xml:XML):void {
			if (xml.@style7.length() > 0) {
				_style7 = xml.@style7 == "true";
				_colour = _style7 ? COLOUR7 : COLOUR;
			}
			var value:* = xml.@gapV;
			if (value)
				_paddingV = (isNaN(value) || value==undefined) ? GAP : parseFloat(value);
			value = xml.@gapH;
			if (value)
				_paddingH = (isNaN(value) || value==undefined) ? (_style7 ? GAP7 : GAP) : parseFloat(value);
			
			if ((value = xml.@width).length() > 0) {
				_width = parseInt(value);
			}
			
			if ((value = xml.@height).length() > 0) {
				_height = parseInt(value);
			}
			
			value = xml.@visible;
			if (value) {
				_visible = value!="false";
			}
			
			var colour:String = xml.@colour;
			if (colour) {
				_colour = UI.toColourValue(colour);
			}
			colour = xml.@scrollBarColour;
			if (colour) {
				_scrollBarColour = UI.toColourValue(colour);
			}
			colour = xml.@background;
			if (colour) {
				_colours = UI.toColourVector(colour);
			}
			if (xml.@clickable.length() > 0) {
				_clickable = xml.@clickable[0].toString();
			}
			_alignV = (xml.@alignV.length() > 0) ? xml.@alignV : _alignV;
			_alignH = (xml.@alignH.length() > 0) ? xml.@alignH : _alignH;
			
			var size:String = String(xml.@size).toUpperCase();
			if (size.substr(-1,1) == "C") {
				_alignH = CENTRE;
				_alignV = CENTRE;
			}
			_id = xml.@id;
		}
		
/**
* Returns a duplicate of this Attributes class
*/
		public function copy(xml:XML=null, container:Boolean = false):Attributes {
			var result:Attributes = new Attributes(x, y, width, height);
			result._paddingV = _paddingV;
			result._paddingH = _paddingH;
			result._colour = _colour;
			result._scrollBarColour = _scrollBarColour;
			result._alignH = (!container || _alignH == FILL) ? _alignH : ALIGN_H;
			result._alignV = !container ? _alignV : ALIGN_V;
			result._hasBorder = _hasBorder;
			result._style7 = _style7;
			if (xml) {
				result.parse(xml);
			}
			return result;
		}
		
/**
* Vertical gap between child components
*/
		public function get paddingV():uint {
			return _paddingV;
		}
		
/**
 * Horizontal gap between child components
 */		
		public function get paddingH():uint {
			return _paddingH;
		}
		
/**
 * Main colour of component
 */		
		public function get colour():uint {
			return _colour;
		}
		
/**
 * Main colour of component
 */		
		public function set colour(value:uint):void {
			_colour = value;
		}
		
/**
 * Scroll Bar Colour
 */
		public function get scrollBarColour():uint {
			return _scrollBarColour;
		}
		
/**
 * Background Colours
 */
		public function get backgroundColours():Vector.<uint> {
			return _colours;
		}
		
/**
 * true if alignH="fill", or width is specified
 */
		public function get fillH():Boolean {
			return _alignH == FILL || _width > 0;
		}
		
/**
 * true if alignV="fill", or height is specified
 */	
		public function get fillV():Boolean {
			return _alignV == FILL || _height > 0;
		}
		
/**
 * Width of the component
 */
		public function get widthH():Number {
			if (_width > 0) {
				return _width;
			}
			else {
				return width;
			}
		}
		
/**
 * Height of the component
 */	
		public function get heightV():Number {
			if (_height > 0) {
				return _height;
			}
			else {
				return height;
			}
		}
		
/**
 * Is the container component scrollable?
 */
//		public function get noScroll():Boolean {
//			return _alignV == NO_SCROLL;
//		}
		
/**
 * Initial visiblity of the component
 */		
		public function get visible():Boolean {
			return _visible;
		}
		
/**
 * Text Alignment
 */		
		public function get textAlign():String {
			if (_alignH==CENTRE)
				return "center";
			else if (_alignH==RIGHT)
				return "right";
			else
				return "";
		}
	
		public function set hasBorder(value:Boolean):void {
			_hasBorder = value;
		}
		
		
		public function get hasBorder():Boolean {
			return _hasBorder;
		}
		
		
		public function get style7():Boolean {
			return _style7;
		}
		
		
		public function set style7(value:Boolean):void {
			_style7 = value;
		}
		
/**
 * Positions a component according to its positioning attributes
 */	
		public function position(item:DisplayObject, inhibitV:Boolean = false):void {
			if (_id!="" && item.name!="+" && item.name!="-") {
				item.name = _id;
			}
			switch (_alignH) {
				case FILL:
				case LEFT:		item.x = x;
								break;
				case RIGHT: 	item.x = x + width - item.width;
								break;
				case CENTRE:	item.x = x + (width - item.width)/2;
			}
			if (inhibitV) {
				item.y = y;
			}
			else if (!(item is UIList)) {
				switch (_alignV) {
					case FILL:
					case TOP:		item.y = y;
									break;
					case BOTTOM: 	item.y = y + height - item.height;
									break;
					case CENTRE:	item.y = y + (height - item.height)/2;
				}
			}
			if (item is MadSprite && _clickable!="") {
				MadSprite(item).mouseEnabled = MadSprite(item).mouseChildren = MadSprite(item).clickable = _clickable == "true";
			}
		}
		
		
		public function initPosition(item:DisplayObject):void {
			if (_id!="" && item.name!="+" && item.name!="-")
				item.name = _id;
			item.y = y;
		}

	}
}
