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

	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
/**
 *  MadComponents search input field
 * <pre>
 * &lt;search
 *   id = "IDENTIFIER"
 *   colour = "#rrggbb"
 *   background = "#rrggbb, #rrggbb, ..."
 *   alignH = "left|right|centre|fill"
 *   alignV = "top|bottom|centre"
 *   visible = "true|false"
 *   width = "NUMBER"
 *   prompt = "TEXT"
 *   promptColour = "#rrggbb"
 *   field = "IDENTIFIER"
 *   begins = "true|false"
 *   clearButton = "true|false"
 * /&gt;
 * </pre>
 */
	public class UISearch extends UIInput implements IComponentUI {

		protected static const HEIGHT:Number = 40.0;
		protected static const GAP:Number = 10.0;
		protected static const WINDOW_HEIGHT:Number = 25.0;	
		protected static const ICON_COLOUR:uint = 0x999999;
		protected static const RADIUS:int = 9;
		protected static const LINE:int = 6;
		protected static const RIGHT_GAP:int = 45;
		protected static const CURVE7:Number = 10.0;
		

	//	protected var _attributes:Attributes;
		protected var _over:Shape;
		protected var _iconColour:uint;
		protected var _clear:Sprite;
		

		public function UISearch(screen:Sprite, xml:XML, attributes:Attributes) {
			_attributes = attributes;
			addChild(_over = new Shape());
			_iconColour = attributes.backgroundColours.length>2 ? attributes.backgroundColours[2] : ICON_COLOUR;
			super(screen,attributes.x,attributes.y,xml.toString(),attributes.backgroundColours, xml.@alt == "true");
			this.setChildIndex(_label, 0);
			if (xml.@clearButton == "true") {
				makeClearButton();
			}
		}
		
/**
 *  Draw search input field chrome
 */
		override protected function drawOutline(pressed:Boolean = false):void {
			var matr:Matrix=new Matrix();
			var colour:uint = _colours.length>0 ? _colours[0] : _attributes.colour;
			var curve:Number = _attributes.style7 ? CURVE7 : WINDOW_HEIGHT;
			matr.createGradientBox(_attributes.width, HEIGHT, Math.PI/2, 0, 0);
			_over.graphics.clear();
			if (!_alt) {
				if (_attributes.style7) {
					_over.graphics.beginFill(colour);
				}
				else {
					_over.graphics.beginGradientFill(GradientType.LINEAR, [Colour.lighten(colour,64),Colour.darken(colour)], [1.0,1.0], [0x00,0xff], matr);					
				}
				_over.graphics.drawRect(0, 0, _attributes.width, HEIGHT);
				_over.graphics.drawRoundRect(GAP, (HEIGHT-WINDOW_HEIGHT)/2, _attributes.width-2*GAP, WINDOW_HEIGHT, curve);
				_over.graphics.beginFill(Colour.lighten(colour,64));
				if (!_attributes.style7) {
					_over.graphics.drawRect(0, 0, _attributes.width, 1);
					_over.graphics.beginFill(Colour.darken(colour,-64));
					_over.graphics.drawRect(0, HEIGHT, _attributes.width, 2);
				}
			}
			_over.graphics.beginFill(0, 0);
			_over.graphics.lineStyle(2, _iconColour);
			_over.graphics.drawCircle(GAP+WINDOW_HEIGHT/2,HEIGHT/2-1,6);
			_over.graphics.moveTo(GAP+WINDOW_HEIGHT/2+5,HEIGHT/2+4);
			_over.graphics.lineTo(GAP+WINDOW_HEIGHT/2+8,HEIGHT/2+7);
			
			var fieldColour:uint = _colours.length>1 ? _colours[1] : 0xFFFFFF;
			graphics.clear();
			graphics.beginFill(_attributes.style7 ? fieldColour : Colour.darken(colour,-64));
			graphics.drawRect(0,0, _attributes.width, HEIGHT);
			graphics.beginFill(fieldColour);
			graphics.drawRoundRect(GAP+1, (HEIGHT-WINDOW_HEIGHT)/2+1, _attributes.width-2*GAP, WINDOW_HEIGHT, curve);
			
			_label.x = GAP + WINDOW_HEIGHT;
			_label.fixwidth = _attributes.width-RIGHT_GAP - (_alt ? GAP : 0);
			_label.y = (HEIGHT-WINDOW_HEIGHT)/2 + 1.0;
		}
		
/**
 *  Set width of search component
 */
		override public function set fixwidth(value:Number):void {
			_attributes.width = value;
			if (_clear) {
				_clear.x = _attributes.width-GAP - WINDOW_HEIGHT/2;
			}
			drawOutline();
		}
		
		
		protected function clearLabel(event:MouseEvent):void {
			_label.text = "";
		//	_clear.visible = false;
			super.focus();
		}
		
		
		protected function makeClearButton():void {
			addChild(_clear = new Sprite());
			_clear.graphics.beginFill(0,0);
			_clear.graphics.drawCircle(0,0,2 * RADIUS);
			_clear.graphics.beginFill(_iconColour);
			_clear.graphics.drawCircle(0,0,RADIUS);
			_clear.graphics.beginFill(_colours.length>1 ? _colours[1] : _attributes.colour);
			_clear.graphics.drawRect(-1,-LINE,2,LINE-1);
			_clear.graphics.drawRect(-1,1,2,LINE-1);
			_clear.graphics.drawRect(-LINE,-1,2*LINE,2);
			_clear.rotation = 45;
			_clear.y = HEIGHT/2;
		//	_clear.visible = false;
		_clear.x = _attributes.width-GAP - WINDOW_HEIGHT/2;
			_clear.addEventListener(MouseEvent.MOUSE_UP, clearLabel);
		}
		
		
		override public function layout(attributes:Attributes):void {
			super.layout(attributes);
			fixwidth = attributes.width;
		}
		
		
		override public function destructor():void {
			super.destructor();
			if (_clear) {
				_clear.removeEventListener(MouseEvent.MOUSE_UP, clearLabel);
			}
		}

	}
}
