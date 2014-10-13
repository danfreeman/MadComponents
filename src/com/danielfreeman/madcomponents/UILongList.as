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
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
/**
 * List with rows lazy rendered when in view
 * <pre>
 * &lt;longList
 *    id = "IDENTIFIER"
 *    colour = "#rrggbb"
 *    background = "#rrggbb, #rrggbb, ..."
 *    visible = "true|false"
 *    gapV = "NUMBER"
 *    gapH = "NUMBER"
 *    border = "true|false"
 *    lines = "true|false"
 *    pullDownRefresh = "true|false"
 *    pullDownColour = "#rrggbb"
 *    sortBy = "IDENTIFIER"
 *    index = "INTEGER"
 *    showPressed = "true|false"
 *    highlightPressed = "true|false"
 *    mask = "true|false"
 *    alignV = "scroll|no scroll"
 *    recycle = "true|false"
 * /&gt;
 * </pre>
 * 
 * Note that autoLayout="true" is not supported by UILongList
 */
	public class UILongList extends UIList {

		protected var _recycle:Boolean = false;
		protected var _lazy:Boolean = false;
		protected var _lastStartIndex:int = -1;
		protected var _recycleList:Vector.<UIForm> = new Vector.<UIForm>();
		protected var _recycleLabel:Vector.<UILabel> = new Vector.<UILabel>();


		public function UILongList(screen:Sprite, xml:XML, attributes:Attributes) {
			if (xml.@recycle.length()>0) {
				_recycle = xml.@recycle[0] == "true";
			}
			super(screen, xml, attributes);
		}

/**
 *  Start a list with custom renderers
 */
		override protected function customRenderers(value:Array, position:Number = -1):void {
			if (position < 0)
				position = _attributes.paddingV;
			_count = 0;
			for each (var record:Object in value) {
				customCell(record, position);
				position += _cell.height + _attributes.paddingV;
				drawCell(position, _count, record);
				position += _attributes.paddingV;
				_count++;
				
				if (_recycle)
					_recycleList.push(_cell);
				
				if (position > _attributes.height) {
					if (_cellHeight<0)
						_cellHeight = (_slider.height - _top - (_refresh ? TOP : 0)) / _count;
					for (var i:uint = _count; i<value.length; i++) {
						drawCell((i+1) * _cellHeight + _top, i, record);
					}
					_lazy = true;
					return;
				}
			}
			if (_cellHeight<0)
				_cellHeight = (_slider.height - _top - (_refresh ? TOP : 0)) / _count;
			_lazy = true;
		}	
		
/**
 *  Start a list with simple default label rows
 */	
		override protected function simpleRenderers(value:Array, position:Number = -1):void {
			if (position < 0)
				position = 2 * _attributes.paddingV;
			_count = 0;
			_textAlign = _attributes.textAlign;
			for each (var record:* in value) {
				var label:UILabel = labelCell(record, position);
				position += label.height + 2 * _attributes.paddingV;
				drawCell(position, _count, record);
				position += 2 * _attributes.paddingV;
			//	_cellHeight = 4 * _attributes.paddingV + label.height;
				_count++;
				
				if (_recycle)
					_recycleLabel.push(label);
				
				if (position > _attributes.height) {
					if (_cellHeight<0)
						_cellHeight = (_slider.height - _top - (_refresh ? TOP : 0)) / _count;
					for (var i:uint = _count; i<value.length; i++) {
						drawCell((i+1) * _cellHeight + _top, i, record.hasOwnProperty("$colour") ? record.$colour : uint.MAX_VALUE);
					}
					_lazy = true;
					return;
				}
			}
			if (_cellHeight<0)
				_cellHeight = (_slider.height - _top - (_refresh ? TOP : 0)) / _count;
			_lazy = true;
		}

/**
 *  Generate list rows between a specified start and end index
 */
		protected function lazyCustomRenderers(value:Array, startIndex:uint, endIndex:uint):void {
			if (_lastStartIndex != startIndex) {
				for (_count = startIndex; _count<endIndex; _count++) {
					if (!_slider.getChildByName("label_"+_count.toString()+_suffix)) {
						customCell(value[_count], _count * _cellHeight + _attributes.paddingV + _top);
					}
				}
				_lastStartIndex = startIndex;
			}
		}
		
/**
 *  Generate simple list labels between a specified start and end index
 */
		protected function lazySimpleRenderers(value:Array, startIndex:uint, endIndex:uint):void {
			if (_lastStartIndex != startIndex) {
				for (_count = startIndex; _count<endIndex; _count++) {
					if (!_slider.getChildByName("label_"+_count.toString()+_suffix)) {
						labelCell(value[_count], _count * _cellHeight + 2 * _attributes.paddingV + _top);
					}
				}
				_lastStartIndex = startIndex;
			}
		}

/**
 *  Is this row off screen?
 */
		protected function offScreen(cell:DisplayObject):Boolean {
			return cell.y + cell.height < -_slider.y || cell.y + _slider.y > _attributes.height;
		}
		
/**
 *  All off-screen rows are marked recyclable
 */
		protected function setRecycleList():void {
			if (_simple) {
				_recycleLabel.length = 0;
				for (var i:int = 0; i<_slider.numChildren;i++) {
					var label:UILabel = _slider.getChildAt(i) as UILabel;
					if (label && offScreen(label)) {
						_recycleLabel.push(label);
					}
				}
			}
			else {
				_recycleList.length = 0;
				for (var j:int = 0; j<_slider.numChildren;j++) {
					var row:UIForm = _slider.getChildAt(j) as UIForm;
					if (row && offScreen(row)) {
						_recycleList.push(row);
					}
				}
			}
		}

/**
 *  Re-use a recyclable row, otherwise instanciate a new one
 */
		override protected function newRow(rendererXML:XML):DisplayObject {
			if (_lazy && _recycle && _recycleList.length > 0) {
				return _recycleList.pop();
			}
			else {
				return super.newRow(rendererXML);
			}
		}

/**
 *  Re-use a recyclable label, otherwise instanciate a new one
 */
		override protected function newLabel():UILabel {
			if (_lazy && _recycle && _recycleLabel.length > 0) {
				return _recycleLabel.pop();
			}
			else {
				return new UILabel(_slider, _attributes.paddingH, 0, "", FORMAT);
			}
		}

/**
 *  When the list is scrolled, generate missing rows
 */
		override protected function sliderMoved():void {
			if (!_lazy)
				return;
			if (_recycle)
				setRecycleList();
			var startIndex:int = Math.floor(-_slider.y/_cellHeight);
			if (startIndex < 0)
				startIndex = 0;
			var endIndex:int = startIndex + Math.ceil(_attributes.height/_cellHeight + 0.5);
			if (endIndex > _filteredData.length)
				endIndex = _filteredData.length;
			
			if (_simple)
				lazySimpleRenderers(_filteredData, startIndex, endIndex);
			else
				lazyCustomRenderers(_filteredData, startIndex, endIndex);
		}

/**
 *  Rearrange the layout to new screen dimensions
 */	
		override public function layout(attributes:Attributes):void {
			_lastStartIndex = -1;
			super.layout(attributes);
			sliderMoved();
		}
		
/**
 *  Set filtered data
 */	
		override public function set filteredData(value:Array):void {
			_lazy = false;
			super.filteredData = value;
			_lazy = true;
		}
	}
}