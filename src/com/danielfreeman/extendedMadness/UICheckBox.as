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
	
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;

/**
 * Android-style check box
 * <pre>
 * &lt;checkBox
 *    id = "IDENTIFIER"
 *    background = "#rrggbb, #rrggbb, ..."
 *    alignH = "left|right|centre|fill"
 *    alignV = "top|bottom|centre|fill"
 *    visible = "true|false"
 * 	  alt = "true|false"
 * /&gt;
 * </pre>
 * */	
	public class UICheckBox extends MadSprite implements IComponentUI
	{
		protected static const SIZE:Number = 26.0;
		protected static const ALT_SIZE:Number = 18.0;
		protected static const CURVE:Number = 6.0;
		protected static const ON:Number = 6.0;
		protected static const ON_COLOUR:uint=0xFFF999;
		protected static const COLOUR:uint = 0xFCFCFC;
		protected static const GAP:Number = 10.0;
		protected static const SMALL_GAP:Number = 4.0;

		protected var _colour:uint = COLOUR;
		protected var _tick:UITick;
		protected var _state:Boolean = false;
		protected var _onColour:uint = ON_COLOUR;
		protected var _offColour:uint;
		protected var _alt:Boolean = false;
		protected var _label:UILabel;
		protected var _ready:Boolean = false;
		

		public function UICheckBox(screen:Sprite, xml:XML, attributes:Attributes)
		{
		//	screen.addChild(this);
			super(screen, attributes);
			_alt = xml.@alt.length()>0 && xml.@alt[0]!="false";
			_colour = attributes.backgroundColours.length>0 ? attributes.backgroundColours[0] : COLOUR;
			_onColour = attributes.backgroundColours.length>1 ? attributes.backgroundColours[1] : ON_COLOUR;
			_offColour = Colour.darken(_colour,-90);
				
			buttonChrome();
			makeTick();
			state = xml.@state=="true";
			buttonMode = mouseEnabled = true;
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			_label = new UILabel(this, (_alt ? ALT_SIZE+SMALL_GAP  : SIZE+GAP), 0, xml.toString());
			assignToLabel(xml, _label);
		}
		
		
		protected function assignToLabel(xml:XML, label:UILabel):void {
			if (xml.hasComplexContent()) {
				var xmlString:String = xml.toXMLString();
				var htmlText:String = xmlString.substring(xmlString.indexOf(">")+1,xmlString.lastIndexOf("<"));
				
				label.htmlText = htmlText;
				if (label.text=="") {
					label.text=" ";
				}
			}
			label.y = Math.max(((_alt ? ALT_SIZE : SIZE) - label.height)/2,0);
		}
		
/**
 * Get label component
 */
		public function get label():UILabel {
			return _label;
		}
		
/**
 * Set label text
 */
		public function set text(value:String):void {
			_label.text = value;
			label.y = Math.max((SIZE - label.height)/2,0);
		}
		
/**
 * Set label html text
 */
		public function set htmlText(value:String):void {
			_label.htmlText = value;
			label.y = Math.max((SIZE - label.height)/2,0);
		}
		
		
		protected function makeTick():void {
			var shadow:UITick = new UITick(this,3,2,Colour.darken(_colour,-128),true);
			_tick = new UITick(this,4,2,_offColour,true);
			if (_alt) {
				_tick.scaleX = _tick.scaleY = shadow.scaleX = shadow.scaleY = ALT_SIZE/SIZE;
				_tick.x = 2.5;shadow.x=2.0;
				_tick.y=shadow.y = 1.0;
			}
		}
		
		
		protected function buttonChrome():void {
			var matr:Matrix = new Matrix();
			var gradient:Array = [Colour.lighten(_colour,80),Colour.darken(_colour),Colour.darken(_colour)];
			var size:Number = _alt ? ALT_SIZE :SIZE;
			
			matr.createGradientBox(size, size, Math.PI/2, 0, 0);
			graphics.clear();
			graphics.beginFill(0,0);
			graphics.drawRect(0, 0, size + GAP, size);
			graphics.beginFill(Colour.darken(_colour,-80));
			graphics.drawRoundRect(0, 0, size, size, CURVE);
			graphics.beginGradientFill(GradientType.LINEAR, gradient, [1.0,1.0,1.0], [0x00,0x80,0xff], matr);
			graphics.drawRoundRect(1, 1, size-2, size-2, CURVE);
		}
		
		
		protected function redraw():void {
			_tick.colour = _state ? _onColour : _offColour;
		}
		
		
		protected function mouseDown(event:MouseEvent):void {
			_ready = true;
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		
		
		override public function touchCancel():void {
			_ready = false;
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		
		
		protected function mouseUp(event:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			if (_ready && event.target == this) {
				_state = !_state;
				redraw();
				dispatchEvent(new Event(Event.CHANGE));
			}
			_ready = false;
		}
		
/**
 * Set tickbox state
 */
		public function set state(value:Boolean):void {
			_state = value;
			redraw();
		}
		
/**
 * Get tickbox state
 */
		public function get state():Boolean {
			return _state;
		}
		
		
		override public function destructor():void {
			super.destructor();
			removeEventListener(MouseEvent.MOUSE_UP,mouseUp);
		}
	}
}