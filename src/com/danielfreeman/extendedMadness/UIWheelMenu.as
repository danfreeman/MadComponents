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
 
 
 package com.danielfreeman.extendedMadness {
	import flash.system.Capabilities;
	import flash.display.PixelSnapping;
	import flash.geom.ColorTransform;
	/**
	 * @author danielfreeman
	 */
	
	import com.danielfreeman.madcomponents.*;
	import flash.display.Sprite;
	import flash.text.engine.*;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
import flash.geom.Point;

/**
 * Wheel Menu
 * <pre>
 * &lt;wheelMenu
 *    id = "IDENTIFIER"
 *    background = "#rrggbb, #rrggbb, ..."
 *    alignH = "left|right|centre|fill"
 *    alignV = "top|bottom|centre|fill"
 *    visible = "true|false"
 *    highlight = "#rrggbb"
 *    textColour = "#rrggbb"
 *    textSize = "NUMBER"
 *    radius = "NUMBER"
 *    rim = "NUMBER"
 *    labelPosition = "NUMBER"
 *    imagePosition = "NUMBER"
 *    orientation = "left|right"
 *    skin = {getQualifiedClassName(IMAGE)}
 *    segments = "NUMBER"
 * /&gt;
 * </pre>
 * */	
	public class UIWheelMenu extends UIContainerBaseClass {	


		public static const SELECTED:String = "selected";
		
		protected static const TEXT_SIZE:Number = 16.0;
		protected static const INNER_RADIUS:Number = 32.0;
		protected static const OUTER_RADIUS:Number = 256.0;
		protected static const RIM:Number = 10.0;
		protected static const SHADOW:Number = 3.0;
		protected static const WHEEL_COLOUR:uint = 0x666677;
		protected static const LINE_COLOUR:uint = 0xCCCCCC;
		protected static const TEXT_COLOUR:uint = 0xCCCCCC;
		protected static const OUTER_COLOUR:uint = 0x9999AA;
		protected static const SHADOW_COLOUR:uint = 0x333344;
		protected static const ARROW_ANGLE:Number = 0.02 * Math.PI;
		protected static const ARROW_HEIGHT:Number = 8.0;
		protected static const DECAY:Number = 0.95;
		protected static const THRESHOLD:Number = 0.1;
		protected static const SLOW:Number = 0.2;
		protected static const SENSITIVITY:Number = 1.0;
		protected static const BLUR_THRESHOLD:Number = 0.4;
		protected static const LIMIT:Number = 0.6;
		protected static const CLICK_THRESHOLD:Number = 0.05;
		protected static const INCREMENT:Number = Math.PI / 10;
		
		
		protected var _data:XMLList = null;
		protected var _segments:Vector.<Sprite> = new Vector.<Sprite>();
		protected var _segmentLayer:Sprite;
		protected var _outerLayer:Sprite;
		protected var _nSegments:int = 0;
		protected var _segmentAngle:Number;
		protected var _wheelColour:uint = WHEEL_COLOUR;
		protected var _lineColour:uint = LINE_COLOUR;
		protected var _textColour:uint = TEXT_COLOUR;
		protected var _outerColour:uint = OUTER_COLOUR;
		protected var _shadowColour:uint = SHADOW_COLOUR;
		protected var _highlight:Boolean = false;
		protected var _highlightColour:uint;
		protected var _textSize:Number = TEXT_SIZE;
		protected var _radius:Number;
		protected var _radialText:Boolean = false;
		protected var _imagePosition:Number = 0.7;
		protected var _labelPosition:Number = 0;
		protected var _timer:Timer = new Timer(50);
		protected var _animateTimer:Timer = new Timer(50);
		protected var _mouseDown:Boolean = false;
		protected var _angle:Number;
		protected var _deltaAngle:Number = 0;
		protected var _forwardBlur:Bitmap;
		protected var _backwardBlur:Bitmap;
		protected var _index:int = 0;
		protected var _images:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		protected var _labels:Vector.<TextLine> = new Vector.<TextLine>();
		protected var _skinBitmapData:BitmapData = null;
		protected var _rim:Number = RIM;
		protected var _orientation:String = "";
		protected var _distance:Number;
		protected var _destination:Number;
		protected var _rotation:Number = 0;
		protected var _forwardBitmapData:BitmapData = null;
		protected var _backwardBitmapData:BitmapData = null;
		protected var _pixelSnapping:Boolean;
		
		
		public function UIWheelMenu(screen:Sprite, xml:XML, attributes:Attributes) {

			var colours:Vector.<uint> = attributes.backgroundColours;
			if (colours.length > 0) {
				_wheelColour = colours[0];
			}
			if (colours.length > 1) {
				_lineColour = colours[1];
			}
			if (colours.length > 2) {
				_outerColour = colours[2];
			}
			if (colours.length > 3) {
				_shadowColour = colours[3];
			}
			
			if (xml.data) {
				_data = XML(xml.data[0]).children();
				_nSegments = _data.length();
			}
			else if (xml.@segments.length() > 0) {
				_nSegments = parseInt(xml.@segments);
			}
			_radialText = xml.@radialText=="true";
			if (xml.@textSize.length() > 0) {
				_textSize = parseInt(xml.@textSize);
			}
			if (xml.@textColour.length() > 0) {
				_textColour = UI.toColourValue(xml.@textColour);
			}
			if (xml.@highlight.length() > 0) {
				_highlight = true;
				_highlightColour = UI.toColourValue(xml.@highlight);
			}
			if (xml.@skin.length() > 0) {
				skin = getDefinitionByName(xml.@skin) as Class;
			}
			if (xml.@labelPosition.length() > 0) {
				_labelPosition = parseFloat(xml.@labelPosition);
			}
			if (xml.@imagePosition.length() > 0) {
				_imagePosition = parseFloat(xml.@imagePosition);
			}
			if (xml.@rim.length() > 0) {
				_rim = parseFloat(xml.@rim);
			}
			_pixelSnapping = xml.@pixelSnapping == "true";
			
			addChild(_segmentLayer = new Sprite());
			addChild(_outerLayer = new Sprite());
			_radius = Math.min(attributes.width, attributes.height) / 3 - 2 * _rim;
			if (xml.@radius.length() > 0) {
				_radius = parseFloat(xml.@radius);	
			}
			if (xml.@orientation == "right" || xml.@alignH == "left") {
				_outerLayer.x = _segmentLayer.x = (xml.@alignH == "left") ? -INNER_RADIUS : _radius + _rim;
				_outerLayer.rotation = 90;
				wheelRotation = 90;
				_imagePosition = 0.5;
				_orientation = "right";
			}
			else {
				_outerLayer.x = _segmentLayer.x = _radius + _rim;
				if (xml.@orientation == "left" || xml.@alignH == "right") {
					_outerLayer.rotation = 270;
					wheelRotation = 270;
					_orientation = "left";
				}
			}
			_outerLayer.y = _segmentLayer.y = _radius + 2 * _rim;
			if (_nSegments > 0){
				_xml = xml;
				initialiseSegments();
			}
			super(screen, xml, attributes);
			
			if (xml.@motionBlur == "true") {
				enableMotionBlur();
			}
			if (_skinBitmapData) {
				drawBackgroundSkin();
			}
			if (_highlight) {
				drawSegment(0, true);
			}
			
			_timer.addEventListener(TimerEvent.TIMER, timerEvent);
			_animateTimer.addEventListener(TimerEvent.TIMER, animateEvent);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		}
		
/**
 * enable rotational motion blur
 */
		public function enableMotionBlur():void {
			_forwardBitmapData = motionBlur(true);
			_backwardBitmapData = motionBlur(false);
			_forwardBlur = new Bitmap(_forwardBitmapData);
			_backwardBlur = new Bitmap(_backwardBitmapData);
			_segmentLayer.addChild(_forwardBlur);
			_segmentLayer.addChild(_backwardBlur);
			_forwardBlur.x = _forwardBlur.y = -_radius;
			_backwardBlur.x = _backwardBlur.y = -_radius;
			_forwardBlur.visible = false;
			_backwardBlur.visible = false;
		}
		
		
		public function get forwardBitmap():Bitmap {
			return _forwardBlur;
		}
		
		
		public function get backwardBitmap():Bitmap {
			return _backwardBlur;
		}
		
/**
 * Set position of text images.  0 < value < 2
 */
		public function set imagePosition(value:Number):void {
			_imagePosition = value;
		}
		
/**
 * Set position of text labels.  0 < value < 2
 */
		public function set labelPosition(value:Number):void {
			_labelPosition = value;
		}
		
/**
 * Menu selection index
 */
		public function get index():int {
			return _index;
		}
		

		public function set index(value:int):void {
			_index = value;
			if (_highlight) {
				drawSegment(_index);
			}
			finalRotation(value == 0 ? 0 : 2 * Math.PI - value * _segmentAngle, false);
			_timer.stop();
			_animateTimer.stop();
		}
		
/**
 * Wheel menu radius
 */
		public function set radius(value:Number):void {
			_radius = value;
		}
		
		
		public function get radius():Number {
			return _radius;
		}
		
/**
 * Set menu selection index - with animation
 */
		public function animateTo(value:int):void {
			_destination = value == 0 ? 0 : 2 * Math.PI - value * _segmentAngle;
			var angle:Number = rotationInRadians();
			var destination:Number = _destination;
			if (destination > angle + Math.PI) {
				destination -= 2 * Math.PI;
			}
			else if (destination < angle - Math.PI) {
				destination += 2 * Math.PI;
			}
			if (destination < angle) {
				_deltaAngle = -INCREMENT;
			}
			else {
				_deltaAngle = INCREMENT;
			}
			_timer.stop();
			_animateTimer.start();
		}
		
/**
 * Accessor for segmentLayer
 */
		public function get segmentLayer():Sprite {
			return _segmentLayer;
		}
		
		
		protected function mouseDown(event:MouseEvent):void {
			_mouseDown = true;
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			_angle = 2 * Math.PI + Math.atan2(mouseY - _segmentLayer.y, mouseX - _segmentLayer.x);
			_distance = 0;
			_animateTimer.stop();
			_timer.start();
			if (_highlight) {
				drawSegment(_index);
			}
		}
		
		
		protected function mouseUp(event:MouseEvent):void {
			_mouseDown = false;
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			if (_distance < CLICK_THRESHOLD) {
				clicked();
			}
		}
		
/**
 * A menu segment has been clicked
 */
		protected function clicked():void {
			var angle:Number = Math.PI / 2 + Math.atan2(mouseY - _segmentLayer.y, mouseX - _segmentLayer.x) - Math.PI * _outerLayer.rotation / 180;
			var clickIndex:int = _index + Math.round(angle / _segmentAngle);
			if (clickIndex < 0) {
				clickIndex += _nSegments;
			}
			else if (clickIndex >= _nSegments) {
				clickIndex -= _nSegments;
			}
			animateTo(clickIndex);
		}
		
/**
 * Current rotation in radians
 */
		protected function rotationInRadians():Number {
			var result:Number = (wheelRotation - _outerLayer.rotation) * Math.PI / 180;
			if (result < 0) {
				result += 2 * Math.PI;
			}
			else if (result >= 2 * Math.PI) {
				result -= 2 * Math.PI;
			}
			return result;
		}
		
/**
 * Set final rotation value
 */
		protected function finalRotation(value:Number, dispatch:Boolean = true):void {
			wheelRotation = ( 180 / Math.PI ) * value + _outerLayer.rotation;
			radiansToIndex(value);
			if (_highlight) {
				drawSegment(_index, true);
			}
			if (dispatch) {
				dispatchEvent(new Event(SELECTED));
			}
		}
		
/**
 * Timer handler to amimate menu position
 */
		protected function animateEvent(event:TimerEvent):void {
			var segmentRotation:Number = rotationInRadians();
			radiansToIndex(segmentRotation);
			if (Math.abs(_destination - segmentRotation) < INCREMENT) {
				finalRotation(_destination);
				_animateTimer.stop();
			}
			else {
				wheelRotation += ( 180 / Math.PI ) * _deltaAngle;
			}
		}
		
/**
 * Convert segment rotation to index
 */
		protected function radiansToIndex(segmentRotation:Number):void {
			_index = - Math.round(segmentRotation / _segmentAngle);
			if (_index < 0) {
				_index += _nSegments;
			}
			else if (_index >= _nSegments) {
				_index -= _nSegments;
			}
		}
		
/**
 * Drag or inertia movement timer event handler
 */
		protected function timerEvent(event:TimerEvent):void {
			if (_mouseDown) {
				var newAngle:Number = 2 * Math.PI + Math.atan2(mouseY - _segmentLayer.y, mouseX - _segmentLayer.x);
				if (newAngle > _angle + Math.PI) {
					newAngle -= 2 * Math.PI;
				}
				else if (newAngle < _angle - Math.PI) {
					newAngle += 2 * Math.PI;
				}
				_deltaAngle = SENSITIVITY * (newAngle - _angle);
				_distance += Math.abs(_deltaAngle);
				_angle = newAngle;
			}
			else {
				if (Math.abs(_deltaAngle) <= THRESHOLD) {
					_deltaAngle = THRESHOLD * (_deltaAngle < 0 ? -1.0 : 1.0);
				}
				else {
					_deltaAngle *= DECAY;
				}
				if (Math.abs(_deltaAngle) < SLOW) {
					var segmentRotation:Number = rotationInRadians();
					radiansToIndex(segmentRotation);
					var snapPosition:Number = _index == 0 ? 0 : 2 * Math.PI - _index * _segmentAngle;
					if ( Math.abs(snapPosition - segmentRotation) < 0.1) {
						finalRotation(snapPosition);
						_timer.stop();
						return;
					}
				}
			}
			
			if (_deltaAngle > LIMIT) {
				_deltaAngle = LIMIT;
			}
			else if (_deltaAngle < -LIMIT) {
				_deltaAngle = -LIMIT;
			}
			
			if (_forwardBlur) {
				_forwardBlur.visible = _deltaAngle > BLUR_THRESHOLD;
			}
			if (_backwardBlur) {
				_backwardBlur.visible = _deltaAngle < -BLUR_THRESHOLD;	
			}		
			wheelRotation += ( 180 / Math.PI ) * _deltaAngle;
		}
		
/**
 * No blur -> 0, Forward blur -> 1, Backward blur -> 2
 */
		public function get forwardBlur():Boolean {
			return _forwardBlur.visible;
		}
		
		
		public function get backwardBlur():Boolean {
			return _backwardBlur.visible;
		}
		
/**
 * Draw segment
 */
		protected function drawSegment0(segment:Sprite, index:int, innerRadius:Number, outerRadius:Number, colour:uint, line:Boolean = true, arrow:Boolean = false):void {
			var midAngle:Number = index * _segmentAngle;
			var startAngle:Number = midAngle - _segmentAngle / 2;
			var endAngle:Number = startAngle + _segmentAngle;
			var cosineHalf:Number = 1 / Math.cos(_segmentAngle / 4);
			if (!_skinBitmapData || segment == _outerLayer) {
				segment.graphics.beginFill(colour);
			}
			if (line) {
				segment.graphics.lineStyle(1.0, _lineColour);
			}
			segment.graphics.moveTo(innerRadius * Math.sin(startAngle), -innerRadius * Math.cos(startAngle));
			segment.graphics.lineTo(outerRadius * Math.sin(startAngle), -outerRadius * Math.cos(startAngle));
			segment.graphics.curveTo(cosineHalf*outerRadius*Math.sin(startAngle + _segmentAngle / 4), -cosineHalf*outerRadius*Math.cos(startAngle + _segmentAngle / 4),
							outerRadius*Math.sin(midAngle), -outerRadius*Math.cos(midAngle));
			segment.graphics.curveTo(cosineHalf*outerRadius*Math.sin(midAngle + _segmentAngle / 4), -cosineHalf*outerRadius*Math.cos(midAngle + _segmentAngle / 4),
							outerRadius*Math.sin(endAngle), -outerRadius*Math.cos(endAngle));
			segment.graphics.lineTo(innerRadius * Math.sin(endAngle), -innerRadius * Math.cos(endAngle));
			segment.graphics.curveTo(cosineHalf*innerRadius*Math.sin(midAngle + _segmentAngle / 4), -cosineHalf*innerRadius*Math.cos(midAngle + _segmentAngle / 4),
							innerRadius*Math.sin(midAngle + (arrow ? ARROW_ANGLE : 0)), -innerRadius*Math.cos(midAngle + (arrow ? ARROW_ANGLE : 0)));
			if (arrow) {
				segment.graphics.lineTo((innerRadius - ARROW_HEIGHT) * Math.sin(midAngle), -(innerRadius - ARROW_HEIGHT) * Math.cos(midAngle));
				segment.graphics.lineTo(innerRadius*Math.sin(midAngle - ARROW_ANGLE), -innerRadius*Math.cos(midAngle - ARROW_ANGLE));
			}
			segment.graphics.curveTo(cosineHalf*innerRadius*Math.sin(midAngle - _segmentAngle / 4), -cosineHalf*innerRadius*Math.cos(midAngle - _segmentAngle / 4),
							innerRadius*Math.sin(startAngle), -innerRadius*Math.cos(startAngle));
			segment.graphics.endFill();
		}
		
/**
 * Draw segment
 */
		protected function drawSegment(index:int, highlight:Boolean = false):void {
			var segment:Sprite = _segments[index];
			segment.graphics.clear();
			var item:XML = _data[index];
			var colour:uint = item.@colour.length() > 0 ? UI.toColourValue(item.@colour) : _wheelColour;
			drawSegment0(segment, index, INNER_RADIUS, _radius, highlight ? _highlightColour : colour, true);
		}
		
/**
 * Draw background skin
 */
		protected function drawBackgroundSkin():void {
			if (_segmentLayer) {
				_segmentLayer.graphics.clear();
				_segmentLayer.graphics.beginBitmapFill(_skinBitmapData);
				_segmentLayer.graphics.drawCircle(0, 0, _radius);
			}
		}
		
/**
 * Set wheel skin
 */
		public function set skin(value:*):void {
			_skinBitmapData = (value is BitmapData) ? value : ((value is Class) ? new value().bitmapData : value.bitmapData);
			drawBackgroundSkin();
		}
		
/**
 * Set a segment image
 */
		public function setImage(index:int, value:*):void {
			if (_images.length > index && _images[index]) {
				removeChild(_images[index]);
			}
			var image:Bitmap = new ((value is BitmapData) ? Bitmap(value) : value);
			if (_pixelSnapping && value is Class) {
				image.scaleX = image.scaleY = 1 / UI.scale;
				image.pixelSnapping = PixelSnapping.ALWAYS;
			}
			
			_segments[index].addChild(image);
			_images[index] = image;
			var midAngle:Number = index * _segmentAngle;
			var imageAngle:Number = index * _segmentAngle - ((_orientation=="right") ? Math.PI/2 : 0) + ((_orientation=="left") ? Math.PI/2 : 0);
			
			var imageWidth:Number = image.width / 2;
			var imageHeight:Number = image.height / 2;
			var radius:Number = _imagePosition * _radius;
			image.x = - imageWidth;
			image.y = - imageHeight;
			image.rotation = (180 / Math.PI) * imageAngle;
			if (_orientation=="left") {
				image.x = radius * Math.sin(midAngle) + imageHeight * Math.cos(midAngle);
				image.y = - radius * Math.cos(midAngle) + imageWidth * Math.sin(midAngle);
			}
			else {
				image.x = radius * Math.sin(midAngle) - imageWidth * Math.cos(midAngle);
				image.y = - radius * Math.cos(midAngle) - imageHeight * Math.sin(midAngle);					
			}
		}
		
/**
 * Initialise the menu
 */
		protected function initialiseSegments():void {
			_segmentAngle = 2 * Math.PI / _nSegments;
			_outerLayer.graphics.clear();
			_outerLayer.graphics.beginFill(_wheelColour);
			_outerLayer.graphics.drawCircle(0, 0, INNER_RADIUS);
			for (var i:int = 0; i < _nSegments; i++) {
				var segment:Sprite = new Sprite();
				_segmentLayer.addChild(segment);
				_segments.push(segment);
			
				var elementFormat:ElementFormat = new ElementFormat();
				elementFormat.fontSize = _textSize;
				elementFormat.color = _textColour;
				elementFormat.fontDescription = new FontDescription("Arial");
				elementFormat.alignmentBaseline = flash.text.engine.TextBaseline.IDEOGRAPHIC_CENTER;
				elementFormat.baselineShift = _textSize / 2;
				var itemXML:XML = _data ? _data[i] : null;
				var label:String = itemXML ? itemXML.@label.length() > 0 ? itemXML.@label : itemXML.localName() : "";
				var textElement:TextElement = new TextElement(label, elementFormat);
				var textBlock:TextBlock = new TextBlock();
				textBlock.content = textElement;
				var textLine:TextLine = textBlock.createTextLine();
				var midAngle:Number = i * _segmentAngle;
				if (_radialText) {
					var radius:Number = INNER_RADIUS + (_radius - INNER_RADIUS + ((_orientation == "left") ? 1.0 : -1.0) * textLine.width) / 2;
					textLine.x = radius * Math.sin(midAngle);
					textLine.y = -radius * Math.cos(midAngle);
					textLine.rotation = -90 + (180 / Math.PI) * midAngle + ((_orientation == "left") ? 180 : 0);
				}
				else {
					var textRadius:Number = (_labelPosition > 0 ? _labelPosition : 1.0) * _radius;
					var angle:Number = midAngle - _segmentAngle / 2;
					var offset:Number = (2.0 * textRadius * Math.sin(_segmentAngle / 2) - textLine.width) / 2;
					textLine.x = textRadius * Math.sin(angle) + offset * Math.cos(midAngle);
					textLine.y = -textRadius * Math.cos(angle) + offset * Math.sin(midAngle);
					textLine.rotation = (180 / Math.PI) * midAngle;
				}
				segment.addChild(textLine);
				_labels.push(textLine);
				if (itemXML) {
					if (itemXML.@ldpi.length() > 0 && Capabilities.screenDPI < 160 ) {
						_pixelSnapping = true;
						setImage(i, getDefinitionByName(itemXML.@ldpi) as Class);
					}
					else if (itemXML.@mdpi.length() > 0 && Capabilities.screenDPI < 240) {
						_pixelSnapping = true;
						setImage(i, getDefinitionByName(itemXML.@mdpi) as Class);
					}
					else if (itemXML.@hdpi.length() > 0 && Capabilities.screenDPI < 320) {
						_pixelSnapping = true;
						setImage(i, getDefinitionByName(itemXML.@hdpi) as Class);
					}
					else if (itemXML.@xhdpi.length() > 0 && Capabilities.screenDPI < 400) {
						_pixelSnapping = true;
						setImage(i, getDefinitionByName(itemXML.@xhdpi) as Class);
					}
					else if (itemXML.@xxhdpi.length() > 0 && Capabilities.screenDPI >= 400) {
						_pixelSnapping = true;
						setImage(i, getDefinitionByName(itemXML.@xxhdpi) as Class);
					}
					else if (itemXML.@image.length() > 0) {
						setImage(i, getDefinitionByName(itemXML.@image) as Class);
					}
				}
				drawSegment(i);
				drawSegment0(_outerLayer, i, _radius - SHADOW, _radius + _rim, _shadowColour, false, i == 0);
				drawSegment0(_outerLayer, i, _radius, _radius + _rim, _outerColour, false, i == 0);
			}
			graphics.beginFill(0, 0);
			graphics.drawCircle(_segmentLayer.x, _segmentLayer.y, _radius);
			graphics.endFill();
		}
		
/**
 * Clear the menu
 */
		override public function clear():void {
			for (var i:int = 0; i < _nSegments; i++) {
				var segment:Sprite = _segments[i];
				UI.clear(segment);
				_segmentLayer.removeChild(segment);
			}
			_images = new Vector.<DisplayObject>();
			_labels = new Vector.<TextLine>();
			_segments = new Vector.<Sprite>();
			_segmentLayer.graphics.clear();
			_outerLayer.graphics.clear();
		}
		
/**
 * Redraw the menu
 */
		public function redraw():void {
			clear();
		//	_nSegments = _data.length();
			initialiseSegments();
			if (_skinBitmapData) {
				drawBackgroundSkin();
			}
		}
		
/**
 * Set data with an array of objects
 */
		public function set data(value:Array):void {
			const fields:Vector.<String> = new <String>["label", "image", "colour", "ldpi", "mdpi", "hdpi", "xhdpi", "xxhdpi"];
			_data = new XMLList();
			var i:int = 0;
			for each (var object:Object in value) {
				if (object is String) {
					_data[i++] = XML('<item label="'+object+'"/>');
				}
				else {
					var item:XML = <item/>;
					for each (var field:String in fields) {
						if (object[field]) {
							item.@[field] = object[field];
						}
					}
				/*	if (object.label) {
						item.@label = object.label;
					}
					if (object.image) {
						item.@image = object.image;
					}
					if (object.colour) {
						item.@colour = object.colour;
					}*/
					_data[i++] = item;
				}
			}
			redraw();
		}
		
/**
 * Set data with xml data
 */
 		public function set xmlData(value:XML):void {
			_data = value.children();
			redraw();
		}
		
/**
 * Do motion blur
 */
		public function motionBlur(direction:Boolean):BitmapData {
			var result:BitmapData = new BitmapData(2 * _radius, 2 * _radius, true, 0x00000000);
			var colourTransform:ColorTransform = new ColorTransform();
			colourTransform.alphaMultiplier = 0.22;
			var matrix:Matrix = new Matrix();
			matrix.identity();
			matrix.translate(_radius, _radius);
			result.draw(_segmentLayer, matrix, null, null);
			for (var i:int = 0; i < 16; i++) {
				matrix.translate(-_radius, -_radius);
				matrix.rotate((direction ? 1.0 : -1.0) * 0.0005 * (i + 1) * Math.PI);
				matrix.translate(_radius, _radius);
				result.draw(_segmentLayer, matrix, colourTransform, null);
			}
			return result;
		}
		
		
		public function set wheelRotation(value:Number):void {
			if (value < 0) {
				value += 360;
			}
			else if (value > 360) {
				value -= 360;
			}
			if (_segmentLayer.visible) {
				_segmentLayer.rotation = value;
			}
			_rotation = value;
		}
		
		
		public function get wheelRotation():Number {
			return _rotation;
		}
		
		
		override public function get height():Number {
			if (_xml.@alignV == "bottom") {
				return super.height / 2 - INNER_RADIUS;
			}
			else {
				return super.height;
			}
		}
	
		
		override public function get width():Number {
			if (_xml.@alignH == "left" || _xml.@alignH == "right") {
				return super.width / 2 - INNER_RADIUS;
			}
			else {
				return super.width;
			}
		}
		
		
		override public function drawComponent():void {	
		}
		
		
		override public function destructor():void {
			_timer.removeEventListener(TimerEvent.TIMER, timerEvent);
			_animateTimer.removeEventListener(TimerEvent.TIMER, animateEvent);
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
	}
}
