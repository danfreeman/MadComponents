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
	import flash.events.MouseEvent;
	import com.danielfreeman.madcomponents.*;
	import flash.geom.Matrix;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.GradientType;
	import flash.text.TextFormat;
	import flash.events.Event;
	
/**
 * PopUp Created
 */
		[Event( name="popUpCreated", type="flash.events.Event" )]
		
	

	public class UIPopUpButton extends UIContainerBaseClass {
		
		public static const CLICKED:String = "clicked";
		public static const POPUP_CREATED:String = "popUpCreated";
		
		protected static const CURVE:Number = 4.0;
		protected static const COLOUR:uint = 0xCCCCCC;
		protected static const TEXT_FORMAT:TextFormat = new TextFormat("Tahoma", 17, 0x333333);
		protected static const SHADOW_FORMAT:TextFormat = new TextFormat("Tahoma", 17, 0xEEEEEE);
		protected static const HEIGHT:Number = 38.0;
		protected static const ENDING:Number = 40.0;
		protected static const ARROW:Number = 10.0;
		protected static const ARROW_COLOUR:uint = 0x666666;
		protected static const SHADOW_OFFSET:Number = 1.0;
		protected static const X:Number = 8.0;
		protected static const Y:Number = 6.0;

		protected var _curve:Number = CURVE;
		protected var _height:Number = HEIGHT;
		protected var _width:Number = -1;
		protected var _arrow:Number = ARROW;
		protected var _colour:uint = COLOUR;
		protected var _arrowColour:uint = ARROW_COLOUR;
		protected var _format:TextFormat = TEXT_FORMAT;
		protected var _shadowFormat:TextFormat = SHADOW_FORMAT;
		protected var _label:UILabel = null;
		protected var _shadowLabel:UILabel;
		protected var _popUp:UIWindow = null;
		protected var _enabled:Boolean = false;
		

		public function UIPopUpButton(screen:Sprite, xml:XML, attributes:Attributes) {
			if (attributes.fillH)
				_width = attributes.widthH;
			super(screen, xml, attributes);
			buttonMode = useHandCursor = true;
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		}
			
		
		protected function mouseDown(event:MouseEvent):void {
			_enabled = true;
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		
	
		public function createPopUp():UIWindow {	
			var popUpXML:XML = _xml.children()[0];
			var width:Number = popUpXML.@width.length()>0 ? parseFloat(popUpXML.@width) : -1;
			var height:Number = popUpXML.@height.length()>0 ? parseFloat(popUpXML.@height) : -1; 
			var curve:Number = popUpXML.@curve.length()>0 ? parseFloat(popUpXML.@curve) : -1;
			_popUp = UI.createPopUp(popUpXML, width, height, curve);
			dispatchEvent(new Event(POPUP_CREATED));
			return _popUp;
		}
		
		
		protected function mouseUp(event:MouseEvent):void {
			if (_enabled && event.target== this) {
				if (_popUp) {
					UI.showPopUp(_popUp);
				}
				else if (_xml.children().length()>0) {
					createPopUp();
				}
				dispatchEvent(new Event(CLICKED));
			}
			_enabled = false;
			
		}


		override public function drawComponent():void {

			if (!_label) {
				_shadowLabel = new UILabel(this, X-SHADOW_OFFSET, Y-SHADOW_OFFSET, _xml.@value, _shadowFormat);
				_label = new UILabel(this, X, Y, _xml.@value, _format);
				if (_width<0)
					_width = width + 2*X + ENDING;
			}

			var matr:Matrix = new Matrix();
			const gradient:Array = [Colour.lighten(_colour,128),_colour,_colour];
			matr.createGradientBox(_width, _height, Math.PI/2, 0, 0);
			graphics.clear();
			graphics.beginGradientFill(GradientType.LINEAR, gradient, [1.0,1.0,1.0], [0x00,0x80,0xff], matr);
			graphics.lineStyle(1, Colour.darken(_colour,-32), 1.0, true);
			graphics.moveTo(0,_curve);
			graphics.curveTo(0, 0, _curve, 0);
			graphics.lineTo(_width - _curve, 0);
			graphics.curveTo(_width, 0, _width, _curve);
			graphics.lineTo(_width, _height - _curve);
			graphics.curveTo(_width, _height, _width - _curve, _height);
			graphics.lineTo(_curve, _height);
			graphics.curveTo(0, _height, 0, _height - _curve);
			graphics.lineTo(0, _curve);

			graphics.lineStyle(0,0,0);
			var position:Number = _width - ENDING;
			graphics.beginGradientFill(GradientType.LINEAR, [Colour.lighten(_colour,128), Colour.lighten(_colour,192), _colour], [1.0,1.0,1.0], [0x00,0x80,0xff], matr);
			graphics.drawRect(position, 1, 1, _height-1);
			graphics.beginGradientFill(GradientType.LINEAR, [Colour.lighten(_colour,128), Colour.darken(_colour), _colour], [1.0,1.0,1.0], [0x00,0x80,0xff], matr);
			graphics.drawRect(position + 1, 1, 1, _height-1);

			graphics.beginGradientFill(GradientType.LINEAR, [Colour.darken(_arrowColour), Colour.lighten(_arrowColour), _arrowColour], [1.0,1.0,1.0], [0x33,0x40,0xff], matr);
			graphics.moveTo(_width-ENDING/2, _height/2 + _arrow/2);
			graphics.lineTo(_width-ENDING/2 + _arrow, _height/2 - _arrow/2);
			graphics.lineTo(_width-ENDING/2 - _arrow, _height/2 - _arrow/2);
			graphics.lineTo(_width-ENDING/2, _height/2 + _arrow/2);

		}
		
		
		public function set text(value:String):void {
			_shadowLabel.text = value;
			_label.text = value;
		}
		
		
		public function get popUp():UIWindow {
			return _popUp;
		}
		
		
		public function hidePopUp():void {
			UI.hidePopUp(_popUp);
		}


		override public function layout(attributes:Attributes):void {
			if (attributes.fillH)
				_width = attributes.widthH;
			super.layout(attributes);
		}
		
	
		override public function destructor():void {
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			if (_popUp) {
				UI.removePopUp(_popUp);
			}
		}
		
		
		override public function findViewById(id:String, row:int = -1, group:int = -1):DisplayObject {
			return _popUp ? _popUp.findViewById(id, row, group) : null;
		}
	}
}