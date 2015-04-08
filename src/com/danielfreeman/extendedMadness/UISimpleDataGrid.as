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

	import flash.geom.Rectangle;
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;


/**
 *  Datagrid component
 * <pre>
 * &lt;simpleDataGrid
 *    id = "IDENTIFIER"
 *    colour = "#rrggbb"
 *    background = "#rrggbb, #rrggbb, ..."
 *    visible = "true|false"
 *    alignH = "left|right|centre|fill"
 *    alignV = "top|bottom|centre|fill"
 *    widths = "i(%),j(%),k(%)…"
 *    titleBarColour = "#rrggbb"
 *    recycle = "true|false|shared"
 *    headerLines = "true|false"
 *    &lt;title/&gt;
 *    &lt;font/&gt;
 *    &lt;headerFont/&gt;
 *    &lt;titleFont/&gt;
 *    &lt;header/&gt;
 *    &lt;data&gt;
 *    	&lt;header/&gt;
 *    &lt;/data&gt;
 *    &lt;widths/&gt; (depreciated)
 * /&gt;
 * </pre>
 */
	public class UISimpleDataGrid extends MadSprite implements IComponentUI { 

		protected static const DEFAULT_HEADER_COLOUR:uint=0x9999AA; //0x4481c1; 
		protected static const DEFAULT_COLOURS:Vector.<uint>=new <uint>[0xe8edf5,0xcfd8e9]; 
		protected static const TABLE_WIDTH:Number=300.0;
		protected static const TEXT_SIZE:Number=13.0;
		protected static const THRESHOLD:Number = 36.0;
		protected static const LINE_THICKNESS:Number = 0.5;

		protected const HEADER_STYLE:TextFormat = new TextFormat('Arial', TEXT_SIZE, 0xFFFFFF, false);
		protected const TITLE_STYLE:TextFormat = new TextFormat('Arial', 14, 0xFFFFFF, true);
		protected const DATA_STYLE:TextFormat = new TextFormat('Arial', TEXT_SIZE, 0x333333, false);


		protected var _table:Vector.<Vector.<UICell>>=new Vector.<Vector.<UICell>>(); 
		protected var _last:Number=0; 
		protected var _lastWidth:Number; 
		protected var _cellWidths:Array = null;
		protected var _theWidths:Array = null;
		protected var _leftMargin:Number;
		protected var _tableWidth:Number;
		protected var _data:Array = [];
		protected var _borderColour:uint;
		protected var _colours:Vector.<uint> = DEFAULT_COLOURS;
		
		protected var _compactTable:Boolean = false;
		protected var _columnWidths:Vector.<Number> = null;
		protected var _multiLine:Boolean = false;
		protected var _wordWrap:Boolean = false;
		protected var _hasHeader:Boolean = false;
		protected var _dataStyle:TextFormat = DATA_STYLE;
		protected var _headerStyle:TextFormat = HEADER_STYLE;
		protected var _titleStyle:TextFormat = TITLE_STYLE;
		protected var _titleBarColour:uint = DEFAULT_HEADER_COLOUR;
		protected var _title:UICell = null;
		protected var _headerText:Array;
		protected var _headerColour:uint;
		protected var _recycle:Vector.<UICell> = null;
		protected static var _sharedRecycle:Vector.<UICell> = new <UICell>[];
		protected var _fastLayout:Boolean = false;
		protected var _border:Boolean;
		protected var _fits:Boolean = false;
		protected var _newData:Boolean = false;
		
		protected var _rowPositions:Vector.<Number>;
		protected var _headerLines:Boolean = false;


		public function UISimpleDataGrid(screen:Sprite, xml:XML, attributes:Attributes) {							   
			super(screen, attributes); 
			x=attributes.x;
			y=attributes.y;

			var saveBorder:Boolean = _border = xml.@lines.length() == 0 || xml.@lines == "true";
			_headerLines = xml.@headerLines == "true";
			_tableWidth = attributes.width;
			_leftMargin = 4.0;
			
			_borderColour = attributes.colour;
			
			if (xml.widths.length() > 0) { // Depreciated
				_cellWidths = xml.widths.split(",");
			}
			if (xml.@widths.length() > 0) {
				_theWidths = xml.@widths.split(",");
			}
			if (xml.font.length() > 0) {
				_dataStyle = UIe.toTextFormat(xml.font[0], DATA_STYLE);
			}
			if (xml.headerFont.length() > 0) {
				_headerStyle = UIe.toTextFormat(xml.headerFont[0], HEADER_STYLE);
			}
			if (xml.titleFont.length() > 0) {
				_titleStyle = UIe.toTextFormat(xml.titleFont[0], TITLE_STYLE);
			}
			if (xml.@recycle=="shared" && !_recycle) {
				_recycle = _sharedRecycle;
			}
			if (xml.@recycle=="true" && !_recycle) {
				_recycle = new Vector.<UICell>();
			}

			customWidths();
			_compactTable = xml.@widths.length() == 0;		
	//		if (xml.@multiLine.length() > 0) {  // **** Put back into subclass
	//			_multiLine = xml.@multiLine == "true";
	//		}
	//		if (xml.@wordWrap.length() > 0) {
	//			_wordWrap = xml.@wordWrap == "true";
	//		}
			
			_headerText = extractHeader(xml);
			_headerColour = (attributes.backgroundColours.length>0) ? attributes.backgroundColours[0] : DEFAULT_HEADER_COLOUR;
			_titleBarColour = _headerColour;
			if (xml.@titleBarColour.length() > 0) {
				_titleBarColour = UI.toColourValue(xml.@titleBarColour);
			}
			if (xml.title.length() > 0) {
				_title = new UICell(this, 0, 0, " ", 0, _titleStyle, false, false, _titleBarColour);
				_title.xmlText = xml.title[0];
				_title.fixwidth = attributes.width;
				_title.defaultColour = _titleBarColour;
				_last = _title.height;
				_title.border = false;
				_title.borderColor = _borderColour;
			}
			if (_headerText) {
				_hasHeader = true;
				_border = _headerLines;
				makeTable([_headerText], _headerStyle);
			}
			if (attributes.backgroundColours.length>1) {
				_colours = new <uint>[];
				for (var i:int = 1; i < attributes.backgroundColours.length; i++) {
					_colours.push(attributes.backgroundColours[i]);
				}
			}
			
			if (xml.data.length()>0) {
				extractData(xml.data[0]);
			}
			_dataStyle.leftMargin = _leftMargin;
			_headerStyle.leftMargin = 0;
			_border = saveBorder;
			makeTable(_data, _dataStyle);
			doLayout();
		//	drawBackground();
		}
		
		
		public function set newData(value:Array):void {
			_data = value;
			_newData = true;
			var saveBorder:Boolean = _border;
			clear();
			if (_hasHeader) {
				_border = _headerLines;
				makeTable([value[0]], _headerStyle);
				_border = saveBorder;
				makeTable(value.slice(1), _dataStyle);
			}
			else {
				makeTable(value, _dataStyle);
			}
			doLayout();
		//	drawBackground();
		}
		
		
		public function get fits():Boolean {
			return _fits;
		}
		
		
		public function set widths(value:String):void {
			if (value == "") {
				_theWidths = null;
				_compactTable = true;
				_columnWidths = null;
			}
			else {
				_theWidths = value.split(",");
				calculateCustomWidths();
				_compactTable = false;
			}
		}

/**
 *  Grid row colours
 */
		public function set colours(value:Vector.<uint>):void {
			_colours = value && value.length > 0 ? value : DEFAULT_COLOURS;
			drawBackground();
		}
		
		
		public function get colours():Vector.<uint> {
			return _colours;
		}
		
/**
 *  Datagrid title field
 */
		public function set title(value:String):void {
			if (!_title) {
				_title = new UICell(this, 0, 0, "", 0, _titleStyle, false, false, _titleBarColour);
				_title.fixwidth = _attributes.width;
				_title.defaultColour = _titleBarColour;
			}
			if (XML("<a>"+value+"</a>").hasComplexContent()) {
				_title.htmlText = value;
			}
			else {
				_title.xmlText = value;
				_title.setTextFormat(_titleStyle);
				_title.border = false;
			//	_title.borderColor = _borderColour;
			}
		}
		
		
		public function get titleCell():UICell {
			return _title;
		}
		
		
		public function set fixwidth(value:Number):void {
			for (var i:int = 0; i<_table.length;i++) {
				var row:Vector.<UICell> = _table[i];
				var lastCell:UICell = row[row.length - 1];
				lastCell.width = value - lastCell.x;
			}
		}

		
/**
 *  Column headings background colour
 */
		public function set headerColour(value:uint):void {
			_headerColour = value;
			drawBackground();
		}
		
		
		public function get headerColour():uint {
			return _headerColour;
		}
		
		
		protected function calculateCustomWidths():void {
			var total:Number = 0;
			for each (var item : String in _theWidths) {
				if (item.lastIndexOf("%") < 0) {
					total += parseInt(item);
				}
			}
			_columnWidths = new Vector.<Number>();
			for each (var width:String in _theWidths) {
				_columnWidths.push((width.lastIndexOf("%") > 0) ? parseFloat(width)/100 * (_attributes.width - total) : parseFloat(width));			
			}
		}
		
/**
 *  Adjust column widths
 */
		protected function customWidths():void {
			if (_theWidths && _table.length > 0) {
				calculateCustomWidths();
			}
			rejig();
		}
		
		
		protected function verticalGridLines():void {
			var sum:Number = 0;
			var offset:Number = 0;
			if (!_headerLines) {
				var lastRow:Vector.<UICell> = _table[_table.length - 1];
				var dataCell:UICell = lastRow[lastRow.length - 1];
				offset = Math.round(dataCell.y);
			}
			for each (var width:Number in _columnWidths) {
				sum += width;
				graphics.beginFill(_borderColour);
				graphics.drawRect(Math.round(sum), offset, LINE_THICKNESS, getBounds(this).bottom - offset);
				graphics.endFill();
			}
		}
		
		
		protected function horizontalGridLines():void {
			var lastRow:Vector.<UICell> = _table[_table.length - 1];
			var dataCell:UICell = lastRow[lastRow.length - 1];
			var dataText:String = dataCell.text;
			var position:int = 0;
			_rowPositions = _title ? new <Number>[_title.y, dataCell.y] : new <Number>[dataCell.y];
			while((position = dataText.indexOf('\r', position)) > 0) {
				position++;
				var firstChar:Rectangle = dataCell.getCharBoundaries(position);
				if (firstChar) {
					var lineTop:Number = Math.round(dataCell.y + firstChar.y - 2);
					_rowPositions.push(lineTop);
					graphics.beginFill(_borderColour);
					graphics.drawRect(0, lineTop, width, LINE_THICKNESS);
					graphics.endFill();
				}
			}
			_rowPositions.push(height);
		}
		
				
/**
 *  Render row colours
 */
		public function drawBackground():void {
			if (_table.length == 0 || _table[0].length == 0) {
				return;
			}
			var lastRow:Vector.<UICell> = _table[_table.length - 1];
			var cornerCell:UICell = lastRow[lastRow.length - 1];
			var theWidth:Number = Math.max(cornerCell.x + cornerCell.width + 1, _attributes.width);
			var colour:uint = _hasHeader ? _headerColour : _colours[0];
			var index:int = _hasHeader ? 0 : 1;
			if (_title) {
				_title.fixwidth = theWidth;
			}
			graphics.clear();
			for each(var row:Vector.<UICell> in _table) {
				var cell:UICell = row[0];
				graphics.beginFill(colour);
				graphics.drawRect(0, cell.y, theWidth, cell.height);
				graphics.endFill();
				colour = _colours[index++ % _colours.length];
			}
			verticalGridLines();
			horizontalGridLines();
		}
		
/**
 *  Render table cells
 */
		protected function makeTable(data:Array, format:TextFormat=null):void {
			if (!format) format = _dataStyle;
			format.leftMargin = _leftMargin;
			var cellString:String = "";
			
			for each (var row:Array in data) { 		
				for each (var item:String in row) { 
					cellString += item + '\t';
				}
				cellString += '\n';
			}
			if (data.length > 0) {
				var cell:UICell = newCell(format);
				cell.x = 0;
				cell.y = _last;
				cell.xmlText = cellString;
				cell.autoSize = TextFieldAutoSize.LEFT;
				var tableRow:Vector.<UICell> = new <UICell>[];
				tableRow.push(cell);
				_table.push(tableRow);
				_last = cell.y + cell.height; 
			}
		}
		
		
		public function get pages():Array {
			return [];
		}
		
/**
 *  Extract an array of object from XML data
 */
		protected function extractData(xml:XML):void {
			var rows:XMLList = xml.row;
			_data=new Array();
			for each (var row:XML in rows) {
				var dataRow:Array = row.toString().split(",");
				_data.push(dataRow);
			}
		}
		
		
		protected function initialHeight(rowIndex:int):Number {
			return 0;
		}

/**
 *  Realign and adjust the datagrid cell positions
 */
		protected function rejig():void {
			if (_table.length == 0) {
				return;
			}
			var lastY:Number = 0;
			graphics.clear();
			if (_title) {
				_title.autoSize = TextFieldAutoSize.LEFT;
				lastY = _title.height;
				_title.fixwidth = _tableWidth;
			}
			var tabsTextFormat:TextFormat = new TextFormat();
			var tabStops:Array = [];
			var sum:Number = 0;
			for each(var tabWidth:Number in _columnWidths) {
				sum += tabWidth;
				tabStops.push(sum);
			}
			tabsTextFormat.tabStops = tabStops;
			if (!_hasHeader) {
				tabsTextFormat.leading = 4;
			}
			for each (var tableRow:Vector.<UICell> in _table) {
				var cell:UICell = tableRow[0];
				cell.x = 0;
				cell.y = lastY;
				cell.setTextFormat(tabsTextFormat);
				lastY += cell.height;
				tabsTextFormat.leading = 4;
			}
		}
		
/**
 *  Refresh datagrid layout
 */
		public function doLayout():void {
			_tableWidth=_attributes.width;
			if (_cellWidths) {
				rejig();
			}
			else if (_theWidths) {
				customWidths();
			}
			else if (_compactTable) {
				compact(true);
			} 
			else {
				rejig();
			}
			drawBackground();
		}
		
		
		override public function layout(attributes:Attributes):void {
			super.layout(attributes);
			_attributes = attributes;
			x=attributes.x;
			y=attributes.y;
			if (!_fastLayout) {
				doLayout();
			}
		}
		
		
		public function drawComponent():void {	
		}
		
/**
 * Clear the data grid
 */
		public function clear():void {
			for each (var row:Vector.<UICell> in _table) {
				for each (var cell:UICell in row) {
					removeCell(cell);
				}
			}
			_table = new Vector.<Vector.<UICell>>();
		}
		
/**
 * Find a particular row,column (group) inside the grid
 */
		public function findViewById(id:String, row:int = -1, group:int = -1):DisplayObject {
			return (id=="") ? _table[row][group] : null;
		}
		
		
		protected function extractHeader(xml:XML):Array {
			if (xml.header.length()>0) {
				return xml.header[0].toString().split(",");
			}
			else if (xml.data.length()>0 && xml.data[0].header.length()>0) {
				return xml.data[0].header[0].toString().split(",");
			}
			else {
				return null;
			}
		}
	
	
		public function get numberOfRows():int {
			return _rowPositions.length + (hasHeader ? 1 : 0) - 2;
		}
		
/**
 *  Convert y coordinate to row index
 */
		public function yToRow(y:Number):int {// Need to override
			var result:int = -1;
			if (numberOfRows > 0 && y > 0 && y <= theHeight) {
				result = Math.min(Math.floor(numberOfRows * (y - _title.height) / (theHeight - _title.height)), numberOfRows - 1);
				var top:Number = rowPosition(result);
				if (y < top) {
					result--;
					top = rowPosition(result);
					while (result >= 0 && y < top) {
						result--;
						top = rowPosition(result);
					}
				}
				else {
					var bottom:Number = top + rowHeight(result);
					if (y > bottom) {
						result++;
						top = rowPosition(result);
						bottom = top + rowHeight(result);
						while (result < numberOfRows && y > bottom) {
							result++;
							top = rowPosition(result);
							bottom = top + rowHeight(result);
						}
					}
				}
			}
			return result;
		//	return (hasHeader && result == 0) ? -1 : result;
		}
		
		
		protected function reformatTopRow(format:TextFormat):void {
			if (_table.length > 0) {
				for each (var cell:UICell in _table[0]) {
					cell.setTextFormat(format);
					cell.defaultTextFormat = format;
				}
			}
		}
		
		
		protected function addHeaderToTable():void {
			_hasHeader = true;
			reformatTopRow(_headerStyle);
		}
		
		
		protected function removeHeaderFromTable():void {
			_hasHeader = false;
			reformatTopRow(_dataStyle);
		}
		
				
/**
 * Set datagrid data
 */
		protected function setData(value:Array, includeHeader:Boolean = false):void {
			_hasHeader = includeHeader;
			newData = value;
			_newData = false;
		}
		
		
		public function set data(value:Array):void {
			setData(value);
		}
		
		
		public function get data():Array {
			return _data;
		}
		
		
		public function set headerAndData(value:Array):void {
			setData(value, true);
		}
		
/**
 *  Access datagrid cells
 */
		public function get tableCells():Vector.<Vector.<UICell>> {
			return _table;
		}
		
		
		public function rowPosition(value:int):Number {
			return _rowPositions[value];
		}
		
		
		public function rowHeight(value:int):Number {
			return _rowPositions[value + 1] - _rowPositions[value];
		}
		
		
		public function set hasHeader(value:Boolean):void {
			_hasHeader = value;
		}
		
		
		public function get hasHeader():Boolean {
			return _hasHeader;
		}
		
		
		protected function estimateWidth(size:Number, text:String):Number {
			text = text.replace(/<[^<]+?>/gi,"");
			var extraWide:int = text.replace(/[^@W]/g, "").length;
			var lowerCaseAndSpaces:int = text.replace(/[^a-l n-v xyzI\s.,!|]/g, "").length;
			var numbers:int = text.replace(/[^0-9]/g, "").length;
			var everythingElse:int = text.length - lowerCaseAndSpaces - numbers - extraWide;
			return size * ( 1.05 * extraWide + 0.75 * everythingElse + 0.52 * lowerCaseAndSpaces + 0.6 * numbers) + 2 * _leftMargin;
		}
		
		
		protected function initialiseColumnWidths():void {// Need to override in subclass
			const dataSize:Number = Number(_dataStyle.size);
			_columnWidths = new Vector.<Number>(_headerText ? _headerText.length : _data[0].length);
			var estimate:Number;
			var index:int = 0;
			if (_headerText) {
				const headerSize:Number = Number(_headerStyle.size);
				for each (var headerItem:String in _headerText) {
					estimate = estimateWidth(headerSize, headerItem);
					if (estimate > _columnWidths[index]) {
						_columnWidths[index] = estimate;
					}
					index++;
				}
			}
			for each (var dataRow:Array in _data) {
				index = 0;
				for each (var dataItem:String in dataRow) {
					estimate = estimateWidth(dataSize, dataItem);
					if (index < _columnWidths.length && estimate > _columnWidths[index]) {
						_columnWidths[index] = estimate;
					}
					index++;
				}
			}
		}
		
/**
 *  Attempt to make the datagrid width fits exactly the width of the screen
 */
		public function compact(padding:Boolean = false):void {// Don't forget to override
			_fits = false;
			if (_table.length > 0) {
				initialiseColumnWidths();
				if (padding) {
					var sum:Number = 0;
					for each (var width:Number in _columnWidths) {
						sum += width;
					}
					if (sum < _tableWidth) {
						_fits = true;
						var padEachCellBy:Number = (_tableWidth - sum) / _columnWidths.length;
						for (var k:int = 0; k < _columnWidths.length; k++) {
							_columnWidths[k] += padEachCellBy;
						}
					}
				}
				rejig();
			}
		}
		
		
		protected function removeCell(cell:UICell):void {
			if (_recycle) {
				_recycle.push(cell);
			}
			cell.parent.removeChild(cell);
		}
		
		
		protected function newCell(format:TextFormat):UICell {
			_dataStyle.leftMargin=_leftMargin; 
			var result:UICell;
			if (_recycle && _recycle.length > 0) {
				addChild(result = _recycle.pop());
				result.setTextFormat(format);
				result.defaultTextFormat = format;
				result.multiline = _multiLine;
				result.wordWrap = _wordWrap;
				result.border = _border;
			}
			else {
				result = new UICell(this, 0, 0, "", 0, format, _multiLine, _wordWrap, _borderColour, _border);
			}
			return result;
		}
		
		
		override public function get theHeight():Number {
			return getBounds(this).bottom;
		}
		
	} 
}
