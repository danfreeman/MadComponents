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

package com.danielfreeman.extendedMadness
{
	import flash.text.TextFormat;
	import com.danielfreeman.madcomponents.*;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

/**
 * The slider value has changed
 */
	[Event( name="sliderChange", type="flash.events.Event" )]

/**
 * A slider value is selected
 */
	[Event( name="sliderSelect", type="flash.events.Event" )]
	

/**
 *  MadComponent radialSlider
 * <pre>
 * &lt;radialSlider
 *   id = "IDENTIFIER"
 *   background = "#rrggbb, #rrggbb, ..."
 *   alignH = "left|right|centre|fill"
 *   alignV = "top|bottom|centre"
 *   visible = "true|false"
 *   clickable = "true|false"
 *   width = "NUMBER"
 *   numberOfSliders = "NUMBER"
 *   alt = "true|false"
 *   value = "NUMBER, NUMBER..."
 *   minimum = "NUMBER"
 *   maximum = "NUMBER"
 *   rounded = "true|false"
 *   offsetAngle = "DEGREES"
 *   colours = "#rrggbb, #rrggbb, ..."
 *   buttonColours = "#rrggbb, #rrggbb, ..."
 *   outlineColours = "#rrggbb, #rrggbb, ..."
 *   sliderThickness = "NUMBER"
 *   spacing = "NUMBER"
 *   margin = "NUMBER"
 * /&gt;
 * </pre>
 */
	public class UIRadialSlider extends MadSprite implements IComponentUI
	{
		public static const CHANGE:String = "sliderChange";
		public static const SELECT:String = "sliderSelect";
		
		protected static const RADIUS:Number = 80.0;
		protected static const INNER:Number = 32.0;
		protected static const WIDTH:Number = 22.0;
		protected static const GAP:Number = 4.0;
		protected static const MARGIN:Number = 0.0;
		protected static const DEFAULT_VALUE:Number = 0.3;
		protected static const THRESHOLD:Number = 2048.0;
		protected static const FORMAT:TextFormat = new TextFormat("Arial", 20, 0xCCCCCC, true);
		
		protected static const RCOS_HALF:Number = 1 / Math.cos(Math.PI / 8);
		
		protected var _maximumRadius:Number = RADIUS;
		protected var _numberOfSliders:int = 2;
		protected var _alt:Boolean;
		protected var _values:Array;
		protected var _minimum:Number = 0;
		protected var _maximum:Number = 1.0;
		protected var _rounded:Boolean;
		protected var _offset:Number = 0;
		protected var _colours:Vector.<uint> = null;
		protected var _buttonColours:Vector.<uint> = null;
		protected var _outlineColours:Vector.<uint> = null;
		protected var _sliderThickness:Number = WIDTH;
		protected var _spacing:Number = GAP;
		protected var _margin:Number = MARGIN;
		
		protected var _index:int = -1;
		protected var _saveValue:Number;
		protected var _label:UILabel;
		

		public function UIRadialSlider(screen:Sprite, xml:XML, attributes:Attributes) {
			super(screen, attributes);
			extractParameters(xml);
			drawBackground();
			makeRadials();
			_label = new UILabel(this, 0, 0, "", FORMAT);
			text = xml.toString();
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		}
		
		
		protected function toIndex(x:Number, y:Number):int {
			var thickness:Number = (2 * _margin + _sliderThickness + _spacing);
			var distance:Number = Math.sqrt((x - _maximumRadius) * (x - _maximumRadius) + (y - _maximumRadius) * (y - _maximumRadius));
			var result:int = Math.ceil(_maximumRadius - distance) / thickness;
			if (result >= 0 && result < _numberOfSliders) {
				var angle:Number = 2 * Math.PI * _values[result];
				var xx:Number = _maximumRadius + (_maximumRadius - (result + 0.5) * thickness) * Math.sin(_offset + angle);
				var yy:Number = _maximumRadius - (_maximumRadius - (result + 0.5) * thickness) * Math.cos(_offset + angle);
				var closeness:Number = (xx - x) * (xx - x) + (yy - y) * (yy -y);
				if (closeness < THRESHOLD) {
					return result; 
				}
				else {
					return -1;
				}
			}
			return -1;
		}
		
		
		protected function mouseDown(event:MouseEvent):void {
			_index = toIndex(mouseX, mouseY);
			if (_index >= 0) {
				_saveValue = _values[_index % _numberOfSliders];
				stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
				stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			}
		}
		
		
		protected function mouseMove(event:MouseEvent):void {
			var angle:Number = Math.atan2(mouseY - _maximumRadius, mouseX - _maximumRadius) - _offset + Math.PI / 2;
			while (angle < 0) {angle += 2 * Math.PI}
			while (angle > 2 * Math.PI) {angle -= 2 * Math.PI}
			var oldValue:Number = _values[_index];
			var value:Number = angle / (2 * Math.PI);

			if (Math.abs(oldValue - (value - 1)) < 0.5) {
				value = value - 1;
			}
			else if (_minimum >= 0 && oldValue - value > 0.5) {
				value = 1.0;
			}

			if (value > _maximum) {
				value = _maximum;
			}
			else if (value < _minimum) {
				value = _minimum;
			}
			
			_values[_index] = value;
			drawRadial(_index);
			dispatchEvent(new Event(CHANGE));
		}
		
		
		protected function mouseUp(event:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			mouseMove(event);
			dispatchEvent(new Event(SELECT));
		}
		
		
		protected function extractParameters(xml:XML):void {
			if (xml.@width.length() > 0) {
				_maximumRadius = parseFloat(xml.@width) / 2;
			}
			if (xml.@numberOfSliders.length() > 0) {
				_numberOfSliders = parseInt(xml.@numberOfSliders);
			}
			_alt = xml.@alt == "true";
			if (xml.@values.length() > 0) {
				_values = String(xml.@values).split(",");
				_numberOfSliders = Math.max(_numberOfSliders, _values.length);
			}
			else {
				_values = [DEFAULT_VALUE];
			}
			if (xml.@minimum.length() > 0) {
				_minimum = parseFloat(xml.@minimum);
			}
			if (xml.@maximum.length() > 0) {
				_maximum = parseFloat(xml.@maximum);
			}
			_rounded = xml.@rounded != "false";
			if (xml.@offsetAngle.length() > 0) {
				_offset = Math.PI * parseFloat(xml.@offsetAngle) / 180;
			}
			if (xml.@colours.length() > 0) {
				_colours = UI.toColourVector(xml.@colours);
			}
			if (xml.@buttonColours.length() > 0) {
				_buttonColours = UI.toColourVector(xml.@buttonColours);
			}
			if (xml.@outlineColours.length() > 0) {
				_outlineColours = UI.toColourVector(xml.@outlineColours);
			}
			if (xml.@sliderThickness.length() > 0) {
				_sliderThickness = parseFloat(xml.@sliderThickness);
			}
			if (xml.@spacing.length() > 0) {
				_spacing = parseFloat(xml.@spacing);
			}
			if (xml.@margin.length() > 0) {
				_margin = parseFloat(xml.@margin);
				if (_margin < 0) {
					_spacing -= 2 * _margin;
				}
			}
			_maximumRadius = Math.max(_maximumRadius, INNER + _numberOfSliders * (2 * _margin + _spacing + _sliderThickness));
		}
		
		
		protected function drawBackground():void {
			graphics.beginFill(0, 0);
			graphics.drawCircle(_maximumRadius, _maximumRadius, _maximumRadius);			
			var barWidth:Number = _sliderThickness + 2 * _margin;
			var saveOffset:Number = _offset;
			
			if (_minimum < 0) {
				_offset += _minimum * 2 * Math.PI;
			}
			
			for (var i:int = 0; i < _numberOfSliders; i++) {
				var colour:uint;
				if (_attributes.backgroundColours && _attributes.backgroundColours.length > 0) {
					colour = _attributes.backgroundColours[i % _attributes.backgroundColours.length];
				}
				else {
					colour = Colour.lighten((_colours && _colours.length > 0) ? _colours[i % _colours.length] : _attributes.colour, 80);
				}
				if (_maximum - _minimum < 1.0 && _rounded) {
					drawRoundedArc(this, (_maximum - _minimum) * 2 * Math.PI, _maximumRadius - (i + 0.5) * (barWidth + _spacing), barWidth, colour);
				}
				else {
					drawArc(this, (_maximum - _minimum) * 2 * Math.PI, _maximumRadius - (i + 0.5) * (barWidth + _spacing), barWidth, colour);
				}
			}
			_offset = saveOffset;
		}
		
		
		protected function drawRadial(index:int):void {
			var sprite:Sprite = Sprite(getChildAt(index));
			var angle:Number = 2 * Math.PI * _values[index % _values.length];
			var buttonAngle:Number = angle;
			var radius:Number = _maximumRadius - (index + 0.5) * (_sliderThickness + _spacing + 2 * _margin);
			var colour:uint = (_colours && _colours.length > 0) ? _colours[index % _colours.length] : _attributes.colour;
			var saveOffset:Number = _offset;
			sprite.graphics.clear();
			
			if (angle < 0) {
				_offset += angle;
				angle = -angle;
			}
			
			if (_outlineColours && _outlineColours.length > 0) {
				sprite.graphics.lineStyle(0, _outlineColours[index % _outlineColours.length]);
			}
			if (_rounded) {
				drawRoundedArc(sprite, angle, radius, _sliderThickness, colour);
			}
			else {
				drawArc(sprite, angle, radius, _sliderThickness, colour);					
			}
			_offset = saveOffset;
			if (!_alt) {
				sprite.graphics.lineStyle();
				var buttonColour:uint = (_buttonColours && _buttonColours.length > 0) ? _buttonColours[index % _buttonColours.length] : Colour.lighten(colour, 64);
				if (_rounded) {
					drawButton(sprite, buttonAngle, radius, _sliderThickness - 2, buttonColour);
				}
				else {
					drawSquareButton(sprite, buttonAngle, radius, _sliderThickness, buttonColour);
				}
			}
			
		}
		
		
		protected function makeRadials():void {
			for (var i:int = 0; i < _numberOfSliders; i++) {
				this.addChild(new Sprite());
				if (_values.length <= i) {
					_values.push(DEFAULT_VALUE);
				}
				drawRadial(i);
			}	
		}
		
		
		override public function touchCancel():void {
			_values[_index % _numberOfSliders] = _saveValue;
			drawRadial(_index);
			dispatchEvent(new Event(CHANGE));
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		
/**
 *  Set value of slider, between "0" and "1"
 */
		public function set text(value:String):void {
			_label.xmlText = value;
			_label.x = _maximumRadius - _label.width / 2;
			_label.y = _maximumRadius - _label.height / 2 - 2;
		}
				
		
		public function set index(value:int):void {
			_index = value;
		}
		
/**
 *  The index of the slider that has changed or selected. (0 is the outermost slider)
 */
		public function get index():int {
			return _index;
		}
		
/**
 *  Set value of slider, a number between 0 and 1
 */
		public function set value(valuu:Number):void {
			_values[_index] = valuu;
			drawRadial(_index);
		}
		
/**
 *  Current slider calue between 0 and 1
 */
		public function get value():Number {
			return (_index < 0) ? Number.NaN : _values[_index];
		}
		
		
/**
 *  Set value of all sliders, an array of values between 0 and 1
 */
		public function set values(valuu:Array):void {
			_values = valuu;
			for (var i:int = 0; i < _numberOfSliders; i++) {
				drawRadial(i);
			}
		}
		
/**
 *  Current slider values between 0 and 1
 */
		public function get values():Array {
			return _values;
		}
		
		
		override public function get theWidth():Number {
			return 2 * _maximumRadius;
		}
		
		
		override public function get theHeight():Number {
			return 2 * _maximumRadius;
		}
				
		
		protected function drawRoundedArc(sprite:Sprite, angle:Number, radius:Number, width:Number, colour:uint):void {
			sprite.graphics.beginFill(colour);
			drawRoundStart(sprite, radius, width);
			drawArcOut(sprite, angle, radius - width / 2);
			drawRoundEnd(sprite, angle, radius, width);
			drawArcBack(sprite, angle, radius + width / 2);
			sprite.graphics.endFill();
		}


		protected function drawArc(sprite:Sprite, angle:Number, radius:Number, width:Number, colour:uint):void {
			sprite.graphics.beginFill(colour);
			drawStart(sprite, radius, width);
			drawArcOut(sprite, angle, radius - width / 2);
			drawEnd(sprite, angle, radius, width);
			drawArcBack(sprite, angle, radius + width / 2);
			sprite.graphics.endFill();
		}
		
		
		protected function drawButton(sprite:Sprite, angle:Number, radius:Number, width:Number, colour:uint):void {
			sprite.graphics.beginFill(colour);
			sprite.graphics.drawCircle(_maximumRadius + radius * Math.sin(_offset + angle), _maximumRadius - radius * Math.cos(_offset + angle), width / 2);
			sprite.graphics.endFill();
		}
		
		
		protected function drawStart(sprite:Sprite, radius:Number, width:Number):void {
			sprite.graphics.moveTo(_maximumRadius + (radius + width / 2) * Math.sin(_offset),
							_maximumRadius - (radius + width / 2) * Math.cos(_offset));
			sprite.graphics.lineTo(_maximumRadius + (radius - width / 2) * Math.sin(_offset),
							_maximumRadius - (radius - width / 2) * Math.cos(_offset));
		}


		protected function drawEnd(sprite:Sprite, angle:Number, radius:Number, width:Number):void {
			sprite.graphics.lineTo(_maximumRadius + (radius + width / 2) * Math.sin(_offset + angle),
							_maximumRadius - (radius + width / 2) * Math.cos(_offset + angle));
		}
		
		
		protected function drawRoundStart(sprite:Sprite, radius:Number, width:Number):void {
			var _offset:Number = -this._offset;
			var cx:Number = _maximumRadius + radius * Math.sin(-_offset);
			var cy:Number = _maximumRadius - radius * Math.cos(-_offset);
			sprite.graphics.moveTo(cx - width / 2 * Math.sin(_offset),
							cy - width / 2 * Math.cos(_offset));
			sprite.graphics.curveTo(cx - RCOS_HALF * width / 2 * Math.sin(_offset + Math.PI / 8),
							cy - RCOS_HALF * width / 2 * Math.cos(_offset + Math.PI / 8),
							cx - width / 2 * Math.sin(_offset + Math.PI / 4),
							cy - width / 2 * Math.cos(_offset + Math.PI / 4));
			sprite.graphics.curveTo(cx - RCOS_HALF * width / 2 * Math.sin(_offset + 3 * Math.PI / 8),
							cy - RCOS_HALF * width / 2 * Math.cos(_offset + 3 *Math.PI / 8),
							cx - width / 2 * Math.sin(_offset + Math.PI / 2),
							cy - width / 2 * Math.cos(_offset + Math.PI / 2));
			sprite.graphics.curveTo(cx - RCOS_HALF * width / 2 * Math.sin(_offset + 5 * Math.PI / 8),
							cy - RCOS_HALF * width / 2 * Math.cos(_offset + 5 *Math.PI / 8),
							cx - width / 2 * Math.sin(_offset + 6 * Math.PI / 8),
							cy - width / 2 * Math.cos(_offset + 6 * Math.PI / 8));
			sprite.graphics.curveTo(cx - RCOS_HALF * width / 2 * Math.sin(_offset + 7 * Math.PI / 8),
							cy - RCOS_HALF * width / 2 * Math.cos(_offset + 7 *Math.PI / 8),
							cx - width / 2 * Math.sin(_offset + Math.PI),
							cy - width / 2 * Math.cos(_offset + Math.PI));
		}
		
		
		protected function drawRoundEnd(sprite:Sprite, angle:Number, radius:Number, width:Number):void {
			var cx:Number = _maximumRadius + radius * Math.sin(_offset + angle);
			var cy:Number = _maximumRadius - radius * Math.cos(_offset + angle);
			sprite.graphics.curveTo(cx + RCOS_HALF * width / 2 * Math.sin(_offset + angle + 7 * Math.PI / 8),
							cy - RCOS_HALF * width / 2 * Math.cos(_offset + angle + 7 * Math.PI / 8),
							cx + width / 2 * Math.sin(_offset + angle + 6 * Math.PI / 8),
							cy - width / 2 * Math.cos(_offset + angle + 6 * Math.PI / 8));
			sprite.graphics.curveTo(cx + RCOS_HALF * width / 2 * Math.sin(_offset + angle + 5 * Math.PI / 8),
							cy - RCOS_HALF * width / 2 * Math.cos(_offset + angle + 5 *Math.PI / 8),
							cx + width / 2 * Math.sin(_offset + angle + Math.PI / 2),
							cy - width / 2 * Math.cos(_offset + angle + Math.PI / 2));
			sprite.graphics.curveTo(cx + RCOS_HALF * width / 2 * Math.sin(_offset + angle + 3 * Math.PI / 8),
							cy - RCOS_HALF * width / 2 * Math.cos(_offset + angle + 3 *Math.PI / 8),
							cx + width / 2 * Math.sin(_offset + angle + 2 * Math.PI / 8),
							cy - width / 2 * Math.cos(_offset + angle + 2 * Math.PI / 8));
			sprite.graphics.curveTo(cx + RCOS_HALF * width / 2 * Math.sin(_offset + angle +  Math.PI / 8),
							cy - RCOS_HALF * width / 2 * Math.cos(_offset + angle + Math.PI / 8),
							cx + width / 2 * Math.sin(_offset + angle),
							cy - width / 2 * Math.cos(_offset + angle));
		}


		protected function drawArcOut(sprite:Sprite, angle:Number, radius:Number):void {
			var segments:int = Math.floor(angle / (Math.PI / 4));
			var remainder:Number = angle - segments * Math.PI / 4;
			for (var i:int = 1; i <= segments; i++) {
				sprite.graphics.curveTo(_maximumRadius + RCOS_HALF * radius * Math.sin(_offset + i * Math.PI / 4 - Math.PI / 8),
							_maximumRadius - RCOS_HALF * radius * Math.cos(_offset + i * Math.PI / 4 - Math.PI / 8),
							_maximumRadius + radius * Math.sin(_offset + i * Math.PI / 4),
							_maximumRadius - radius * Math.cos(_offset + i * Math.PI / 4));				
			}
			if (remainder > 0) {
				var rCosHalf:Number = 1 / Math.cos(remainder / 2);
				sprite.graphics.curveTo(_maximumRadius + rCosHalf * radius * Math.sin(_offset + angle - remainder / 2),
						_maximumRadius - rCosHalf * radius * Math.cos(_offset + angle - remainder / 2),
						_maximumRadius + radius * Math.sin(_offset + angle),
						_maximumRadius - radius * Math.cos(_offset + angle));
			}			
		}
		
		
		protected function drawArcBack(sprite:Sprite, angle:Number, radius:Number):void {
			var segments:int = Math.floor(angle / (Math.PI / 4));
			var remainder:Number = angle - segments * Math.PI / 4;
			if (remainder > 0) {
				var rCosHalf:Number = 1 / Math.cos(remainder / 2);
				sprite.graphics.curveTo(_maximumRadius + rCosHalf * radius * Math.sin(_offset + angle - remainder / 2),
						_maximumRadius - rCosHalf * radius * Math.cos(_offset + angle - remainder / 2),
						_maximumRadius + radius * Math.sin(_offset + angle - remainder),
						_maximumRadius - radius * Math.cos(_offset + angle - remainder));
			}	
			for (var i:int = segments - 1; i >= 0; i--) {
				sprite.graphics.curveTo(_maximumRadius + RCOS_HALF * radius * Math.sin(_offset + i * Math.PI / 4 + Math.PI / 8),
							_maximumRadius - RCOS_HALF * radius * Math.cos(_offset + i * Math.PI / 4 + Math.PI / 8),
							_maximumRadius + radius * Math.sin(_offset + i * Math.PI / 4),
							_maximumRadius - radius * Math.cos(_offset + i * Math.PI / 4));				
			}
		
		}
		
		
		protected function drawSquareButton(sprite:Sprite, angle:Number, radius:Number, width:Number, colour:uint):void {
			var delta:Number = Math.atan((width / 4)/radius);
			var rCosHalf:Number = 1 / Math.cos(delta / 2);
			sprite.graphics.beginFill(colour);
			sprite.graphics.moveTo(_maximumRadius + (radius - width / 2) * Math.sin(_offset + angle - delta / 2),
							_maximumRadius - (radius - width / 2) * Math.cos(_offset + angle - delta / 2));
			sprite.graphics.lineTo(_maximumRadius + (radius + width / 2) * Math.sin(_offset + angle - delta / 2),
							_maximumRadius - (radius + width / 2) * Math.cos(_offset + angle - delta / 2));
			sprite.graphics.curveTo(_maximumRadius + rCosHalf * (radius + width / 2) * Math.sin(_offset + angle),
							_maximumRadius - rCosHalf * (radius + width / 2) * Math.cos(_offset + angle),
							_maximumRadius + (radius + width / 2) * Math.sin(_offset + angle + delta / 2),
							_maximumRadius - (radius + width / 2) * Math.cos(_offset + angle + delta / 2));
			sprite.graphics.lineTo(_maximumRadius + (radius - width / 2) * Math.sin(_offset + angle + delta / 2),
							_maximumRadius - (radius - width / 2) * Math.cos(_offset + angle + delta / 2));
			sprite.graphics.curveTo(_maximumRadius + rCosHalf * (radius - width / 2) * Math.sin(_offset + angle),
							_maximumRadius - rCosHalf * (radius - width / 2) * Math.cos(_offset + angle),
							_maximumRadius + (radius - width / 2) * Math.sin(_offset + angle - delta / 2),
							_maximumRadius - (radius - width / 2) * Math.cos(_offset + angle - delta / 2));
			sprite.graphics.endFill();
		}
		
		
		override public function destructor():void {
			super.destructor();
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
	}
}