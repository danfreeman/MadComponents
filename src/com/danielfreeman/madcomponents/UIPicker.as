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
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.text.TextFormat;
	
/**
 *  MadComponents picker component
 * <pre>
 * &lt;picker
 *    id = "IDENTIFIER"
 *    colour = "#rrggbb"
 *    background = "#rrggbb, #rrggbb, ..."
 *    visible = "true|false"
 *    gapV = "NUMBER"
 *    gapH = "NUMBER"
 *    border = "true|false"
 *    lines = "i,j,k..."
 *    sortBy = "IDENTIFIER"
 *    index = "INTEGER"
 *    height = "NUMBER"
 *    cursorheight = "NUMBER"
 *    jogable = "true|false"
 * /&gt;
 * </pre>
 */
	public class UIPicker extends UIList
	{	
		protected static const HEIGHT:Number = 160.0;
		protected static const SPINNER_ALPHA:Number = 1.0;
		protected static const SPINNER_SHADE:Number = 0x30;
		protected static const SPINNER_CURSOR_HEIGHT:Number = 60.0;
		protected static const SPINNER_CURSOR_COLOUR:uint = 0x666699;
		protected static const SPINNER_CURSOR_COLOUR_DARK:uint = 0x333399;
		protected static const SPINNER_CURSOR_COLOUR_HIGHLIGHT:uint = 0xCCCCFF;
		protected static const SPINNER_CURSOR_ALPHA:Number = 0.3;
		protected static const CURVE:Number = 10.0;
		protected static const WARP:Number = 3.0;
		protected static const SHADOW:Number = 10.0;
		protected static const GREYED_OUT_LIGHT:uint = 0xCCCCCC;
		protected static const GREYED_OUT_DARK:uint = 0x999999;
		
		public static var PICKER_DECAY:Number = 0.96;
		
		protected var _spinner:Shape=null;
		protected var _spinnerColour:uint = 0x333333;
		protected var _left:Boolean;
		protected var _right:Boolean;
		protected var _pickerHeight:Number = HEIGHT;
		protected var _cursorHeight:Number = SPINNER_CURSOR_HEIGHT;
		protected var _defaultStyle:TextFormat;
		protected var _jogable:Boolean = false;
		
		
		public function UIPicker(screen:Sprite, xml:XML, attributes:Attributes, left:Boolean =false, right:Boolean = false, pickerHeight:Number = -1, cursorHeight:Number = -1) {
			if (pickerHeight>0) {
				_pickerHeight = pickerHeight;
			}
			if (cursorHeight>0) {
				_cursorHeight = cursorHeight;
			}
			if (xml.@height.length()>0) {
				_pickerHeight = parseFloat(xml.@height[0]);
			}
			if (xml.@cursorHeight.length()>0) {
				_cursorHeight = parseFloat(xml.@cursorHeight[0]);
			}
			if (xml.@jogable.length() > 0) {
				_jogable = xml.@clickable == "true";
			}
			super(screen, xml, attributes);
		//	_decay = PICKER_DECAY;
			_deltaThreshold = 4.0;
			_mask = new Shape();
			_spinner = new Shape();
			_left = left;
			_right = right;
			drawSpinner();
			addChild(_spinner);
			addChild(this.mask = _mask);
		}
		
		
		override protected function deltaToDecay(delta:Number):Number {
			return PICKER_DECAY;
		}

/**
 *  Draw picker chrome
 */
		protected function drawSpinner():void {
			var matr:Matrix=new Matrix();
			
			_mask.graphics.clear();
			_mask.graphics.beginFill(0);
			drawShape(_mask.graphics);
			
			_mask.visible = false;
			
			_spinner.graphics.clear();
			
			matr.createGradientBox(_attributes.width, _pickerHeight, Math.PI/2, 0, 0);
			_spinner.graphics.beginGradientFill(GradientType.LINEAR, [_spinnerColour,_spinnerColour,_spinnerColour, _spinnerColour, _spinnerColour,_spinnerColour], [SPINNER_ALPHA,0.2,0.0,0.0,0.2,SPINNER_ALPHA], [0x00,SPINNER_SHADE/2,SPINNER_SHADE,0xff-SPINNER_SHADE,0xff-SPINNER_SHADE/2,0xff], matr);
			_spinner.graphics.lineStyle(1.5,0x333333,1.0,true);
			drawShape(_spinner.graphics);
			_spinner.graphics.lineStyle(0,0,0);
			
			_spinner.graphics.beginGradientFill(GradientType.LINEAR, [0x000000,0xDDDDDD,0xDDDDDD,0x000000], [1.0,1.0,1.0,1.0], [0x00,SPINNER_SHADE,0xff-SPINNER_SHADE,0xff], matr);
			_spinner.graphics.drawRect(1, 0, 3, _pickerHeight);
			_spinner.graphics.drawRect(_attributes.width-3, 0, 3, _pickerHeight);
			
			if (_noScroll) {
				_spinner.graphics.beginFill( GREYED_OUT_LIGHT, SPINNER_CURSOR_ALPHA );
				_spinner.graphics.drawRect(0, (_pickerHeight - _cursorHeight)/2, _attributes.width, _cursorHeight / 2);
				_spinner.graphics.beginFill( GREYED_OUT_DARK, SPINNER_CURSOR_ALPHA );
				_spinner.graphics.drawRect(0, _pickerHeight / 2, _attributes.width, _cursorHeight / 2);
			}
			else {
				matr.createGradientBox(_attributes.width, _cursorHeight / 2, Math.PI/2, 0, (_pickerHeight - _cursorHeight)/2);
				_spinner.graphics.beginGradientFill(GradientType.LINEAR, [SPINNER_CURSOR_COLOUR_HIGHLIGHT, SPINNER_CURSOR_COLOUR], [SPINNER_CURSOR_ALPHA, SPINNER_CURSOR_ALPHA], [0x00,0xff], matr);
				_spinner.graphics.drawRect(0, (_pickerHeight - _cursorHeight)/2, _attributes.width, _cursorHeight / 2);
				
				_spinner.graphics.beginFill( SPINNER_CURSOR_COLOUR_DARK, SPINNER_CURSOR_ALPHA );
				_spinner.graphics.drawRect(0, _pickerHeight / 2, _attributes.width, _cursorHeight / 2);
				
				_spinner.graphics.beginFill(SPINNER_CURSOR_COLOUR);
				_spinner.graphics.drawRect(0, (_pickerHeight - _cursorHeight)/2, _attributes.width, 1.5);
				_spinner.graphics.drawRect(0, (_pickerHeight + _cursorHeight)/2-1, _attributes.width, 1.5);
			}
							
			matr.createGradientBox(_attributes.width, SHADOW, Math.PI/2, 0, (_pickerHeight + _cursorHeight)/2);
			_spinner.graphics.beginGradientFill(GradientType.LINEAR, [_spinnerColour,_spinnerColour], [SPINNER_ALPHA/3,0.0], [0x00,0xff], matr);
			_spinner.graphics.drawRect(0, (_pickerHeight + _cursorHeight)/2, _attributes.width, _cursorHeight / 2);
		}
		
/**
 *  Basic picker shape
 */
		public function drawShape(graphics:Graphics, x:Number = 0, y:Number = 0, partial:int = 0):void {
			var height:Number = (partial >= 0) ? y+_pickerHeight-1 : y+_pickerHeight/2;
			var heightCurve:Number = (partial >= 0) ? y+_pickerHeight-1-CURVE : y+_pickerHeight/2;
			if (partial > 0) {
				graphics.moveTo(x+_attributes.width, y+_pickerHeight/2-1);
				if (_right) {
					graphics.curveTo(x+_attributes.width, y+_pickerHeight/2-1, x+_attributes.width-WARP, heightCurve);
				}
			}
			else {
				graphics.moveTo(x+(_left ? (CURVE + 2*WARP): 0), y);
				graphics.lineTo(x+_attributes.width-(_right ? (CURVE + 2 * WARP) : 0), y);
				if (_right) {
					graphics.curveTo(x+_attributes.width - 2*WARP, y, x+_attributes.width-WARP, y+CURVE);
					graphics.curveTo(x+_attributes.width + WARP, y+_pickerHeight/2, x+_attributes.width-WARP, heightCurve);
				}
			}

			if (_right) {
				graphics.curveTo(x+_attributes.width-2*WARP, height, x+_attributes.width-CURVE-2*WARP, height);
			}
			else {
				graphics.lineTo(x+_attributes.width, height);
			}
			
			graphics.lineTo(x+(_left ? CURVE+2*WARP : 0), height);
			
			if (partial > 0) {
			
				if (_left) {
					graphics.curveTo(x+WARP,y+_pickerHeight-1,x+WARP,y+_pickerHeight-1-CURVE);
					graphics.curveTo(x-WARP,y+_pickerHeight/2,x+WARP,y+_pickerHeight/2-1);
				}
				else {
					graphics.lineTo(x,y+_pickerHeight/2-1);
				}
			
			}
			else {
				
				if (_left) {
					graphics.curveTo(x+WARP,height,x+WARP,heightCurve);
					graphics.curveTo(x-WARP,y+_pickerHeight/2,x+WARP,y+CURVE);
					graphics.curveTo(x+WARP,y,x+CURVE+2*WARP,y);
				}
				else {
					graphics.lineTo(x,y);
				}
				
			}
		}
		
		
/**
 *  If false, scrolling is locked.
 */
		override public function set scrollEnabled(value:Boolean):void {
			if (_slider.numChildren > 1) {
				if (value) {
					if (_defaultStyle) {
						for (var i:int = 1; i < _slider.numChildren; i++) {
							UILabel(_slider.getChildAt(i)).setTextFormat(_defaultStyle);
						}
					}
				}
				else {
					if (!_noScroll) {
						_defaultStyle = UILabel(_slider.getChildAt(1)).getTextFormat();
					}
					var greyedOutStyle:TextFormat = new TextFormat(_defaultStyle.font, _defaultStyle.size, GREYED_OUT_LIGHT);
					for (var j:int = 1; j < _slider.numChildren; j++) {
						UILabel(_slider.getChildAt(j)).setTextFormat(greyedOutStyle);
					}
				}
			}
			super.scrollEnabled = value;
			drawSpinner();
		}
		

		override public function get height():Number {
			return _pickerHeight;
		}

/**
 *  Rearrange the layout to new screen dimensions
 */	
		override public function layout(attributes:Attributes):void {
			super.layout(attributes);
			if (_spinner) {
				drawSpinner();
			}
		}
		
		
		override protected function calculateMaximumSlide():void {
			_scrollerHeight = _slider.height - (_refresh ? TOP : 0);
			if (_count>0 && (_cellHeight<0 || _autoLayout)) {
				_cellHeight = (_slider.height - _top - (_refresh ? TOP : 0)) / _count;
			}
			_maximumSlide = (_cellHeight * (_count - 3) - _offset);
			if (_maximumSlide < 0) {
				_maximumSlide = 0;
			}
		}
		
		
		override protected function startMovement0():Boolean {
			if (sliderY > _offset) {
				_endSlider = -_offset;
				return true;
			}
			else if (sliderY < -(_cellHeight * (_count - 3) - _offset)) {
				_endSlider = _cellHeight * (_count - 3) - _offset;
				return true;
			}

			return false;
		}
		
		
/**
 *  Data object for last row clicked
 */
		override public function get row():Object {
			return (_pressedCell>=0) ? _filteredData[_pressedCell+1] : null;
		}
		
		
		override protected function illuminate(pressedCell:int = -1, dispatch:Boolean = true, show:Boolean = true):void {
			if (_pressedCell >= 0 && _pressedCell < _count) {
				if (show && _highlightPressed) {
					_highlight.graphics.beginFill(_highlightColour);
					_highlight.graphics.drawRect(0, _top + (_pressedCell+1) * _cellHeight +1, _width, _cellHeight -1); //_attributes.x + 
				}
				activate(dispatch);
			}
		}
		
		
		protected function jogPicker():void {
			var oldPressedCell:int = _pressedCell;
				_pressedCell=Math.floor(_slider.mouseY/_cellHeight) -1;
				if (_pressedCell >= 0 && _pressedCell != oldPressedCell) {
						if (_pressedCell > _count-3) {
							_pressedCell = _count - 3;
						}
						setIndex(_pressedCell, true);
				}
				else {
					_pressedCell = oldPressedCell;
				}
		}


		override protected function mouseUp(event:MouseEvent):void {
			super.mouseUp(event);
			if (_jogable && !_classic && _distance < THRESHOLD) {
				jogPicker();
			}
		}
		
		
		override protected function pressButton(show:Boolean = true):DisplayObject {
			if (_jogable && _classic) {
				jogPicker();
			}
			return null;
		}
		
		
		override protected function drawScrollBar():void {
		}
		
		
		public function get snapToCellCondition():Boolean {
			return sliderY < _offset && sliderY > -(_cellHeight * (_count - 3) - _offset);
		}
		
		
		public function get snapToCellPosition():Number {
			if (snapToCellCondition) {
				return - _cellHeight * Math.round((sliderY-_offset)/_cellHeight) - _offset;
			}
			else if (sliderY > _offset) {
				return -_offset;
			}
			else if (sliderY < -(_cellHeight * (_count - 3) - _offset)) {
				return _cellHeight * (_count - 3) - _offset;
			}
			else {
				return sliderY;
			}
		}
		
		
		override protected function stopMovement():void {
			if (snapToCellCondition) {
				_endSlider = snapToCellPosition;
				_delta = (-_endSlider - sliderY) * BOUNCE;
				if (Math.abs(sliderY+_endSlider) < 1.0) {
					stopMovement0();
				}
			}
			else {
				stopMovement0();
			}
		}
		
		
		protected function stopMovement0():void {
			_moveTimer.stop();
			hideScrollBar();
			_pressedCell = -Math.round((sliderY-_offset)/_cellHeight);
			dispatchEvent(new Event(Event.CHANGE));
		}
		
/**
 *  Draw picker background
 */	
		override public function drawComponent():void {
			if (_colours && _colours.length>0) {
				graphics.beginFill(_colours[0]);
			}
			else {
				graphics.beginFill(0xFFFFFF);
			}
			graphics.drawRect(0, 0, _attributes.width, _attributes.height);
		}
		
/**
 *  Set array of objects data
 */	
		override public function set data(value:Object):void {
			var datas:Array = (value as Array).concat();
			datas.splice(0,0,{label:" "});
			datas.push({label:" "});
			super.data = datas;
			_offset = (_pickerHeight - _cellHeight * (Math.floor(_pickerHeight/_cellHeight) + 1)) / 2;
			_offset += _cellHeight * (Math.floor(_pickerHeight/(2*_cellHeight))-1);
			if (Math.floor(_pickerHeight/_cellHeight) % 2 ==1)
				_offset +=_cellHeight/2;
			sliderY = _offset;
			if (_spinner) {
				setChildIndex(_spinner, numChildren-1);
			}
		}

	}
}