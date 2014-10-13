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
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextFormat;

/**
 *  MadComponents Navigation Bar
 */
	public class UINavigationBar extends Sprite {
	
		public static const HEIGHT:Number = 46.0;
		protected static const COLOUR:uint = 0x9999BB;
		protected static const COLOUR7:uint = 0xF6F6F6;
		protected static const LEFTCOLOUR:uint = 0x7777AA;
		protected static const DONECOLOUR:uint = 0xAA7777;
		protected static const SIDES:Number = 100.0;
		protected static const Y:Number = 6;
		
		protected const FORMAT:TextFormat = new TextFormat("Tahoma",20,0xFFFFFF);
		protected const FORMAT7:TextFormat = new TextFormat("Tahoma",18,0x000000);
		protected const DARK_FORMAT:TextFormat = new TextFormat("Tahoma", 20, 0x333366);
		protected const DARK_FORMAT7:TextFormat = new TextFormat("Tahoma", 18, 0xFFFFFF );
		
		protected var _label:UILabel;
		protected var _shadowLabel:UILabel;
		protected var _leftButton:UIButton;
		protected var _backButton:UIBackButton;
		protected var _attributes:Attributes;
		protected var _rightButton:UIButton;
		protected var _rightArrow:UIBackButton;
		protected var _colour:uint;
		protected var _centrePanel:Sprite;
		protected var _centreItem:Sprite = null;
		protected var _xml:XML;
		
	
		public function UINavigationBar(screen:Sprite, xml:XML, attributes:Attributes) {
			screen.addChildAt(this,0);
			_xml = xml;
			_attributes = attributes;
			
			_colour = (xml.@barColour.length() > 0) ? UI.toColourValue(xml.@barColour) : attributes.colour;

			drawBar();
			var default7:Boolean = _attributes.style7 && _colour == Attributes.COLOUR7;
			var format:TextFormat = default7 ? FORMAT7 : FORMAT;
			var shadowFormat:TextFormat = default7 ? DARK_FORMAT7 : DARK_FORMAT;
			_shadowLabel = new UILabel(this, 0, Y+1, "", shadowFormat);
			_label = new UILabel(this, 0, Y+2, "", format);
			_leftButton = new UIButton(this, 8, Y - 1, '<font size="14">left</font>', _attributes.style7 ? _colour : LEFTCOLOUR, new <uint>[], true, attributes.style7);		// JSS
			_backButton = new UIBackButton(this, 4, 0, "Back", COLOUR, false, !_attributes.style7, xml.@leftLink.length() == 0);
			_rightArrow = new UIBackButton(this, 200, 0, "Next", COLOUR, true, !_attributes.style7, xml.@rightArrow.length() > 0);
			_rightButton = new UIButton(this, 200, Y - 1, '<font size="14">done</font>', _attributes.style7 ? _colour : DONECOLOUR, new <uint>[], true, attributes.style7);
			_backButton.visible = _leftButton.visible = _rightButton.visible = _rightArrow.visible = false;
			addChild(_centrePanel = new Sprite());
			initialiseClassicButtons();
		//	if (_attributes.style7) {
		//		initialiseIos7Buttons();
			//	_colour = (_attributes.style7 && xml.@colour.length == 0) ? COLOUR7 : _colour;
		//	}
		//	else {
		//		
		//	}
			
			adjustButtons();
		}
		
		
		protected function initialiseClassicButtons():void {
			if (_xml.@leftButton.length()>0) {
				leftButtonText = _xml.@leftButton;
				leftButton.visible = true;
			}
			if (_xml.@rightButton.length()>0) {
				rightButtonText = _xml.@rightButton;
				rightButton.visible = true;
			}
			if (_xml.@rightArrow.length()>0) {
				rightButtonText = _xml.@rightArrow;
				rightButton.visible = false;
				rightArrow.visible = true;
			}
			if (_xml.@leftArrow.length()>0) {
				backButton.text = _xml.@leftArrow;
			}
		}
		
		
	/*	protected function initialiseIos7Buttons():void {
			if (_xml.@leftLink.length()>0) {
				leftButtonText = _xml.@leftLink;	
			}
		//	if (_xml.@leftArrow.length()>0) {
		//		leftButtonText = _xml.@leftArrow;
		//	}
			if (_xml.@rightLink.length()>0) {
				rightButtonText = _xml.@rightLink;
			}
		//	if (_xml.@rightArrow.length()>0) {
		//		rightButtonText = _xml.@rightArrow;
		//	}
		//	leftButton.visible = rightButton.visible = false;
			_backButton.visible = _xml.@leftLink.length() > 0 || _xml.@leftArrow.length() > 0;
			_rightArrow.visible = _xml.@rightLink.length() > 0 || _xml.@rightArrow.length() > 0;
		}*/
		
		
		protected function adjustButtons():void {
			_rightArrow.x = _attributes.width - _rightArrow.width  - (_attributes.style7 ? 6 : 0);
			_rightButton.x = _attributes.width - _rightButton.width - 8;
			_centrePanel.x = _attributes.width / 2;
		}
		
/**
 *  Text of navigation bar
 */
		public function set text(value:String):void {
			_label.text = value;
			_shadowLabel.text = value;
			_label.x = (_attributes.width - _label.width) / 2;
			_shadowLabel.x=_label.x-1;
		}
		
		
/**
 *  Left button
 */
		public function get leftButton():UIButton {
			return _leftButton;
		}

/**
 *  Left button/arrow text
 */
		public function set leftButtonText(value:String):void {
			_leftButton.text = '<font size="14">'+value+'</font>';
			_backButton.text = value;
		}

/**
 *  Right button/arrow text
 */
		public function set rightButtonText(value:String):void {
			_rightButton.text = '<font size="14">'+value+'</font>';
			_rightArrow.text = value;
			adjustButtons();
		}

		
/**
 *  Back button
 */
		public function get backButton():UIBackButton {
			return _backButton;
		}
		
/**
 *  Right button
 */
		public function get rightButton():UIButton {
			return _rightButton;
		}
		
/**
 *  Right arrow button
 */
		public function get rightArrow():UIBackButton {
			return _rightArrow;
		}
		
/**
 *  Colour of navigation bar
 */
		public function set colour(value:uint):void {
			_colour = value;
			drawBar();
		}

/**
 *  Colour of navigation bar
 */
		public function get colour():uint {
			return _colour;
		}
		
		
/**
 *  Width of navigation bar
 */
		public function set fixwidth(value:Number):void {
			_attributes.width = value;
			_label.x = (_attributes.width - _label.width) / 2;
			_shadowLabel.x=_label.x-1;
			adjustButtons();
			drawBar();
		}
		
		
		public function get centrePanel():Sprite {
			return _centrePanel;
		}
		
		
		public function set centrePanel(value:Sprite):void {
			if (_centreItem) {
				_centrePanel.removeChild(_centreItem);
				_centreItem = null;
			}
			if (value) {
				_centrePanel.addChild(_centreItem = value);
				value.x = -value.width / 2;
				value.y = (HEIGHT - value.height) / 2;
			}
		}
		
/**
 *  Draw navigation bar
 */
		protected function drawBar():void {
			var matr:Matrix=new Matrix();
			matr.createGradientBox(_attributes.width, HEIGHT, Math.PI/2, 0, 0);
			graphics.clear();
			if (_attributes.style7) {
				graphics.beginFill(_colour);
			}
			else {
				graphics.beginGradientFill(GradientType.LINEAR, [Colour.lighten(_colour,64),Colour.darken(_colour)], [1.0,1.0], [0x00,0xff], matr);
			}
			graphics.drawRect(0, 0, _attributes.width, HEIGHT);
			graphics.endFill();
			if (_attributes.style7) {
				graphics.beginFill(Colour.darken(_colour));
				graphics.drawRect(0, HEIGHT - 1, _attributes.width, 1);
				graphics.endFill();
			}
		}
		
		
		override public function get height():Number {
			return HEIGHT;
		}
		
		
		public function destructor():void {
			_leftButton.destructor();
			_rightButton.destructor();
			_backButton.destructor();
			_rightArrow.destructor();
		}
	}
}
