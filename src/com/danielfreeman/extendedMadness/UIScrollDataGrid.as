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

	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import com.danielfreeman.madcomponents.*;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
		import flash.utils.Timer;
	import flash.events.TimerEvent;
	
/**
 * The datagrid was swiped left to right (Beyond the scrolling range).
 */
	[Event( name="swipeRight", type="flash.events.Event" )]

/**
 * ScrollDatagrid component
 * <pre>
 * &lt;scrollDataGrid
 *    id = "IDENTIFIER"
 *    colour = "#rrggbb"
 *    background = "#rrggbb, #rrggbb, ..."
 *    visible = "true|false"
 *    widths = "p,q,r..."
 *    scrollH = "true|false|auto"
 *    scrollV = "true|false|auto"
 *    editable = "true|false"
 *    widths = "i(%),j(%),k(%)…"
 *    multiline = "true|false"
 *    titleBarColour = "#rrggbb"
 *    recycle = "true|false|shared"
 *    gapV = "NUMBER"
 *    gapH = "NUMBER"
 *    border = "true|false"
 *    autoLayout = "true|false"
 *    tapToScale = "NUMBER"
 *    auto = "true|false"
 *    fixedColumns = "n"
 *    fixedColumnsColours = "#rrggbb, #rrggbb, ..."
 *    slideFixedColumns = "true|false"
 *    lockSides = "true|false"
 *    lockTopBottom = "true|false"
 *    datagrid = "simple|fast|special"
 * /&gt;
 * </pre>
 */
	public class UIScrollDataGrid extends UIScrollXY {
		
		
		public static const SWIPE_RIGHT:String = "swipeRight";
		protected static const STEPS:int = 4;
		protected static const SWIPE_THRESHOLD:Number = 32.0;
		protected static const DARKEN:int = -16;
		
		protected var _headerSlider:Sprite;
		protected var _fixedColumnSlider:Sprite = null;
		protected var _headerFixedColumnSlider:Sprite = null;
		protected var _dataGridXML:XML;
		protected var _fixedColumns:int = 0;
		protected var _fixedColumnColours:Vector.<uint> = null;
		protected var _dataGrid:UISimpleDataGrid;
		protected var _fixedColumnPosition:Number = 0;
		protected var _columnSlideTimer:Timer = new Timer(50, STEPS);
		protected var _slideFixedColumns:Boolean = false;
		protected var _fixedColumnDelta:Number = 0;
		protected var _trigger0:Boolean = false;
		protected var _trigger1:Boolean = true;
		protected var _fastLayout:Boolean = false;
		protected var _autoScrollEnabledX:Boolean = false;

		
		public function UIScrollDataGrid(screen : Sprite, xml : XML, attributes : Attributes) {
			xml.@border = "false";
			_dataGridXML = xml;
			_autoScrollEnabledX = xml.@scrollH != "scroll" || xml.@scrollH != "no scroll";
			if (xml.@fixedColumnColours.length() > 0) {
				_fixedColumnColours = UI.toColourVector(xml.@fixedColumnColours);
			}
	//		_fastLayout = xml.@fastLayout == "true";
			super(screen, noChildren(xml), attributes);
			super.layout(attributes);
			if (xml.@slideFixedColumns == "true") {
				_slideFixedColumns = true;
				_columnSlideTimer.addEventListener(TimerEvent.TIMER, columnSlideMovement);
			}
			autoScrollEnabled();
		}
		
/**
 *  Slide the fixed columns into position
 */
		protected function slideFixedColumnsIn():void {
			if (_fixedColumnSlider && _fixedColumnSlider.x < 0) {
				var startPosition:Number = (_fixedColumnSlider.x < -_fixedColumnSlider.width) ? -_fixedColumnSlider.width : _fixedColumnSlider.x;
				_fixedColumnSlider.x = startPosition;
				_headerFixedColumnSlider.x = startPosition;
				_fixedColumnPosition = startPosition;
				_fixedColumnDelta = (0 - startPosition) / STEPS;
				_columnSlideTimer.stop();
				_columnSlideTimer.reset();
				_columnSlideTimer.start();
			}
		}
		
/**
 *  Slide the fixed columns left off the screen
 */
		protected function slideFixedColumnsOut():void {
			_columnSlideTimer.stop();
			if (_fixedColumnSlider) {
				_fixedColumnPosition = 0;
				_fixedColumnDelta = -_fixedColumnSlider.width / STEPS;
			}
		}
		
/**
 *  Fixed column movement slide handler
 */
		protected function columnSlideMovement(event:Event):void {
			if (_fixedColumnDelta > 0) {
				_fixedColumnPosition += _fixedColumnDelta;
				_fixedColumnSlider.x = _fixedColumnPosition;
				_headerFixedColumnSlider.x = _fixedColumnPosition;
			}
		}


		protected function noChildren(xml:XML):XML {
			var result:String = xml.toXMLString();
			var position:int = result.indexOf(">");
			if (result.substr(position - 1, 1) == "/") {
				result = result.substring(0, position + 1);
			}
			else {
				result = result.substring(0, position) + "/>";
			}
			return XML(result);
		}
		
/**
 *  Render the row background colours for fixed columns
 */
		protected function colourFixedColumns(dataGrid:UISimpleDataGrid, flag:Boolean = false):void {
			if (_fixedColumns > 0 && dataGrid.tableCells.length > 0) {
				
			//	var rowIndex:int = 0;
			//	var start:int = dataGrid.hasHeader  ? 1 : 0;
				if (flag) {
					for (var i:int = 0; i < dataGrid.tableCells.length; i++) {
						var tableRow:Vector.<UICell> = dataGrid.tableCells[i];
						for (var j:int = 0; j < _fixedColumns; j++) {
							var cell:UICell = tableRow[j];
						//	if (i >= start) {
						//		cell.defaultColour = _fixedColumnColours ? _fixedColumnColours[(rowIndex - start) % _fixedColumnColours.length]
						//		: Colour.darken(dataGrid.colours[(rowIndex - start) % dataGrid.colours.length], -16);
						//	}
						//	if (flag) {
								_fixedColumnSlider.addChild(cell);
						//	}
						}
					//	rowIndex++;
					}
				}
				
			}
		}
		
/**
 *  Put headers, fixed columns, and grid cells all within their appropriate layers
 */
		protected function sliceTable(dataGrid:UISimpleDataGrid):void {
			if (!_headerSlider) {
				addChild(_headerSlider = new Sprite());
				_headerSlider.name ="_headerSlider";
			}
			if (xml.@fixedColumns.length() > 0 && !_fixedColumnSlider) {
				_fixedColumns = parseInt(xml.@fixedColumns);
				addChild(_fixedColumnSlider = new Sprite());
				_fixedColumnSlider.name = "_fixedColumnSlider";
			}
			if (!_headerFixedColumnSlider) {
				addChild(_headerFixedColumnSlider = new Sprite());
				_headerFixedColumnSlider.name = "_headerFixedColumnSlider";
			}

			colourFixedColumns(dataGrid, true);
			if (dataGrid.hasHeader) {
				var headerRow:Vector.<UICell> = dataGrid.tableCells[0];
				var cell:UICell;
				for (var k:int = _fixedColumns; k < headerRow.length; k++) {
					_headerSlider.addChild(cell = headerRow[k]);
				//	cell.defaultColour = _dataGrid.headerColour;
				}
				if (_fixedColumns > 0) {
					for (var l:int = 0; l < _fixedColumns; l++) {
						_headerFixedColumnSlider.addChild(cell = headerRow[l]);
					//	cell.defaultColour = _dataGrid.headerColour;
					}
				}
			}
			if (dataGrid.titleCell) {
				_headerFixedColumnSlider.addChild(dataGrid.titleCell);
			}
			_slider.cacheAsBitmap = true;
		}
		
/**
 *  Create sliding parts of container
 */	
		override protected function createSlider(xml:XML, attributes:Attributes):void {
			var gridAttributes:Attributes = attributes.copy(_dataGridXML);
			if (xml.@datagrid == "simple") {
				_slider = _dataGrid = new UISimpleDataGrid(this, _dataGridXML, gridAttributes);
			}
			else if (xml.@datagrid == "special") {
				_slider = _dataGrid = new UISpecialDataGrid(this, _dataGridXML, gridAttributes);
			}
			else {
				_slider = _dataGrid = new UIFastDataGrid(this, _dataGridXML, gridAttributes);
			}
			_slider.name = "-";
			sliceTable(_dataGrid);
			adjustMaximumSlide();
		}
		
		
		override protected function set sliderX(value:Number):void {
			if (Math.abs(value - _slider.x) < MAXIMUM_DY) {
				_slider.x = value;
				if (_headerSlider) {
					_headerSlider.x = value;
				}
				if (_fixedColumnDelta < 0) {
					_fixedColumnPosition += _fixedColumnDelta;
				}
				var threshold:Number = _fixedColumnDelta < 0 ? - _fixedColumnSlider.width : 0;
				if (_fixedColumnSlider) {
					_fixedColumnSlider.x = value > threshold ? value : _fixedColumnPosition;
				}
				if (_headerFixedColumnSlider) {
					_headerFixedColumnSlider.x = value > threshold ? value : _fixedColumnPosition;
				}
			}
		}
		
/**
 *  Respond to scroll gestures
 */
		override protected function mouseMove(event:TimerEvent):void {
			if (_trigger0 && _slider.x == 0 && mouseX - _lastMouse.x > SWIPE_THRESHOLD) {
				if (_trigger1) {
					dispatchEvent(new Event(SWIPE_RIGHT));
					_trigger1 = false;
					_trigger0 = false;
					_touchTimer.stop();
					_dragTimer.stop();
				}
			}
			else {
				_trigger1 = true;
			}
			super.mouseMove(event);
		}
		
		
		override protected function pressButton(show:Boolean = true):DisplayObject {
			return null;
		}
		
		
		override protected function doSearchHit():void {
		}
		
		
		override protected function mouseDrag(event:TimerEvent):void {
		}
		
		
		override protected function mouseDown(event:MouseEvent):void {
			_trigger0 = _slider.x == 0;
			super.mouseDown(event);
		}
		
		
		override protected function getSliderWidth():Number {
			return _scrollerWidth > 0 ? _scrollerWidth*_scale : _slider.width;
		}
		
		
		override protected function getSliderHeight():Number {
			return _scrollerHeight > 0 ? _scrollerHeight*_scale : _slider.height;
		}
		
		
		override public function set sliderY(value:Number):void {
			super.sliderY = value;
			if (_fixedColumnSlider) {
				_fixedColumnSlider.y = sliderY;
			}
			_headerFixedColumnSlider.y = value > 0 ? value : 0;
			if (_headerSlider) {
				_headerSlider.y = value > 0 ? value : 0;
			}
		}
		
/**
 * Set datagrid data
 */
		override public function set data(value:Object):void {
			_dataGrid.data = value as Array;
			sliceTable(_dataGrid);
			adjustMaximumSlide();
		}
		
/**
 * Set column headings and datagrid data
 */
		public function set headerAndData(value:Array):void {
			_dataGrid.headerAndData = value;
			sliceTable(_dataGrid);
			adjustMaximumSlide();
		}
		
///**
// * Refresh datagrid with new data
// */
//		public function set dataProvider(value:Array):void {
//			_dataGrid.dataProvider = value;
//		}
		
		
		override public function clear():void {
			_dataGrid.clear();
		}
		
/**
 * Set number of fixed columns
 */
		public function set fixedColumns(value:int):void {
			if (value != _fixedColumns) {
				clear();
			}
			_fixedColumns = value;
		}
		
///**
// * Refresh datagrid
// */
//		public function invalidate(readGrid:Boolean = false):void {
//			_dataGrid.invalidate(readGrid);
//		}

/**
 * Render datagrid with padding for every column
 */
		public function compact(padding:Boolean = false):void {
			_dataGrid.compact(padding);
		}
		
		
		public function get tableCells():Vector.<Vector.<UICell>> {
			return _dataGrid.tableCells;
		}
		

		public function get hasHeader():Boolean {
			return _dataGrid.hasHeader;
		}
		
		
		override public function get xml():XML {
			return _dataGridXML;
		}
		
		
		public function set textSize(value:Number):void {
			UIFastDataGrid(_dataGrid).textSize = value;
			adjustMaximumSlide();
			sliceTable(_dataGrid);
		}
		
		
		protected function fixedHeaderLine(dataGrid:UISimpleDataGrid):void {
			var colour:uint = dataGrid.hasHeader ? dataGrid.headerColour : Colour.darken(dataGrid.colours[0], DARKEN);
			var index:int = dataGrid.hasHeader ? 0 : 1;
			_headerSlider.graphics.clear();
			_headerSlider.graphics.beginFill(colour);
			_headerSlider.graphics.drawRect(_headerSlider.getBounds(this).left, _headerSlider.getBounds(this).top, _headerSlider.width, _headerSlider.height);
			_headerSlider.graphics.endFill();
			if (_headerFixedColumnSlider && _fixedColumnSlider) {
				_headerFixedColumnSlider.graphics.clear();
				_headerFixedColumnSlider.graphics.beginFill(colour);
				_headerFixedColumnSlider.graphics.drawRect(0, _headerFixedColumnSlider.getBounds(this).top, _fixedColumnSlider.width, _headerFixedColumnSlider.height);
				_headerFixedColumnSlider.graphics.endFill();
				_headerFixedColumnSlider.graphics.beginFill(_dataGrid.attributes.colour);
				_headerFixedColumnSlider.graphics.drawRect(_fixedColumnSlider.width, _headerFixedColumnSlider.getBounds(this).top, 2.0, _headerFixedColumnSlider.height);
				_headerFixedColumnSlider.graphics.endFill();
			}
			if (_fixedColumnSlider) {
				_fixedColumnSlider.graphics.clear();
				for each(var row:Vector.<UICell> in dataGrid.tableCells) {
					_fixedColumnSlider.graphics.beginFill(colour);
					_fixedColumnSlider.graphics.drawRect(0, row[0].y, _fixedColumnSlider.width, row[0].height);
					_fixedColumnSlider.graphics.endFill();
					colour = Colour.darken(dataGrid.colours[index++ % dataGrid.colours.length], DARKEN);
				}
				_fixedColumnSlider.graphics.beginFill(_dataGrid.attributes.colour);
				_fixedColumnSlider.graphics.drawRect(_fixedColumnSlider.width, _fixedColumnSlider.getBounds(this).top, 2.0, _fixedColumnSlider.height);
				_fixedColumnSlider.graphics.endFill();
			}

			
		}
		
		
		protected function autoScrollEnabled():void {
			if (_autoScrollEnabledX) {
				_scrollEnabledX = !_dataGrid.fits;
			}
		}
		
/**
 *  Rearrange the layout to new screen dimensions
 */	
		override public function layout(attributes:Attributes):void {
			_attributes = attributes;
			if (_fastLayout) {  //fastLayout is not yet implemented in this release
				adjustMaximumSlide();
				refreshMasking();
			}
			else {
				_dataGrid.layout(attributes);
				super.layout(attributes);
				fixedHeaderLine(dataGrid);
			//	_fastLayout = _xml.@fastLayout == "true";
			}
			autoScrollEnabled();
		}
		
/**
 * Find a particular row,column (group) inside the grid
 */
		override public function findViewById(id:String, row:int = -1, group:int = -1):DisplayObject {
			return _dataGrid.findViewById(id, row, group);
		}
		
		
		override public function showScrollBar():void {
			if (!_scrollBarVisible && _slideFixedColumns && _fixedColumnSlider && Math.abs(_delta) < Math.abs(_deltaX)) {
				slideFixedColumnsOut();
			}
			super.showScrollBar();
		}
		
		
		override public function hideScrollBar():void {
			if (_scrollBarVisible && _slideFixedColumns && _fixedColumnSlider) {
				slideFixedColumnsIn();
			}
			super.hideScrollBar();
		}
		
		
		override protected function adjustMaximumSlide():void {
			sliderX = 0;
			sliderY = 0;
			super.adjustMaximumSlide();
		}
		
/**
 * If set to true, a right or left scroll gesture will temporarily slide the fixed
 * columns out of the way - so you can see more data columns.
 */
		public function set slideFixedColumns(value:Boolean):void {
			_slideFixedColumns = value;
		}
		
/**
 * Set datagrid title
 */
		public function set title(value:String):void {
			_dataGrid.title = value;
		}
		
/**
 * Set datagrid row colours
 */
		public function set colours(value:Vector.<uint>):void {
			_dataGrid.colours = value;
			colourFixedColumns(_dataGrid);
		}
		
		
		public function get colours():Vector.<uint> {
			return _dataGrid.colours;
		}
		
/**
 * Direct access to the UIFastDataGrid class
 */
		public function get dataGrid():UISimpleDataGrid {
			return _dataGrid;
		}
		
		
		override public function set scrollPositionY(value:Number):void {
			sliderY = -value;
		}
		
		
		override public function set scrollPositionX(value:Number):void {
			sliderX = -value;
		}
		
		
		override public function destructor():void {
			super.destructor();
			_dataGrid.destructor();
		}
		
	}
}
