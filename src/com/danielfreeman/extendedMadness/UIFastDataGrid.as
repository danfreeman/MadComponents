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

	import com.danielfreeman.madcomponents.*;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;


/**
 *  Datagrid component
 * <pre>
 * &lt;fastDataGrid
 *    id = "IDENTIFIER"
 *    colour = "#rrggbb"
 *    background = "#rrggbb, #rrggbb, ..."
 *    visible = "true|false"
 *    alignH = "left|right|centre|fill"
 *    alignV = "top|bottom|centre|fill"
 *    widths = "i(%),j(%),k(%)…"
 *    multiline = "true|false"
 *    wordWrap = "true|false"
 *    titleBarColour = "#rrggbb"
 *    recycle = "true|false|shared"
 *    headerLines = "true|false"
 *    colSpan = "true|false"
 *    colSpanWrap = "true|false"
 *    <title/>
 *    <font/>
 *    <headerFont/>
 *    <titleFont/>
 *    <header/>
 *    <data>
 *    	<header/>
 *    </data>
 *    <widths/> (depreciated)
 * /&gt;
 * </pre>
 */
	public class UIFastDataGrid extends UISimpleDataGrid { 

		
		protected var _colSpan:Boolean;
		protected var _colSpanWrap:Boolean;
		protected var _colSpanWidths:Vector.<Number> = null;

		public function UIFastDataGrid(screen:Sprite, xml:XML, attributes:Attributes) {							   
			if (xml.@multiLine.length() > 0) {
				_multiLine = xml.@multiLine == "true";
			}
			if (xml.@wordWrap.length() > 0) {
				_wordWrap = xml.@wordWrap == "true";
			}
			_colSpan = xml.@colSpan != "false";
			_colSpanWrap = xml.@colSpanWrap != "false";
			super(screen, xml, attributes);
		}
		
		
		override protected function calculateCustomWidths():void {
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
 *  Render row colours
 */
		override public function drawBackground():void {
			graphics.clear();
			if (_table.length == 0) {
				return;
			}
			var lastRow:Vector.<UICell> = _table[_table.length - 1];
			if (lastRow.length == 0) {
				return;
			}
			
			var cornerCell:UICell = lastRow[lastRow.length - 1];
		//	var theWidth:Number = Math.max(cornerCell.x + cornerCell.width + 1, _attributes.height, _attributes.width);
			var theWidth:Number = Math.max(cornerCell.x + cornerCell.width + 1, _attributes.width);
			var colour:uint = _hasHeader ? _headerColour : _colours[0];
			var index:int = _hasHeader ? 0 : 1;
			if (_title) {
				_title.fixwidth = theWidth;
			}
			
			for each(var row:Vector.<UICell> in _table) {
				graphics.beginFill(colour);
				graphics.drawRect(0, row[0].y, theWidth, row[0].height);
				graphics.endFill();
				colour = _colours[index++ % _colours.length];
			}
		}
		
/**
 *  Render table cells
 */
		override protected function makeTable(data:Array, format:TextFormat=null):void {
			if (!format) format=_dataStyle;
			format.leftMargin=_leftMargin; 
			for (var i:int=0;i<data.length;i++) { 
				var dataRow:Array=data[i]; 
				var row:Vector.<UICell>=_table[_table.length]=new Vector.<UICell>(); 
				var wdth0:Number=_tableWidth/dataRow.length; 
				var lastX:Number=0;
				var theWidth:Number = Math.max(getBounds(this).right, _tableWidth);
				for (var j:int=0;j<dataRow.length;j++) {
				//	var wdth:Number = (_cellWidths) ? _tableWidth*_cellWidths[Math.min(_cellWidths.length-1,j)]/100 : wdth0;
				//	var txt:UICell = new UICell(this, lastX, _last, dataRow[j], wdth, format, _border);
					var wdth:Number;
					if (j == dataRow.length - 1) {
						wdth = Math.ceil(theWidth - lastX);
					}
					else {
						wdth = Math.ceil(_columnWidths ? _columnWidths[j] : (_cellWidths ? _tableWidth*_cellWidths[Math.min(_cellWidths.length-1,j)]/100 : wdth0));
					}
					var cell:UICell = newCell(format);
					cell.x = lastX;
					cell.y = _last;
					cell.xmlText = dataRow[j];
					cell.fixwidth = wdth;
					row.push(cell);
					cell.border = _border;
					cell.borderColor = _borderColour;
					cell.multiline = _multiLine;
					cell.wordWrap = _wordWrap;
				//	txt.setTextFormat(format);
					cell.fixwidth = wdth;
					lastX=cell.x+cell.width;
				} 
				if (cell) {
					_last=cell.y+cell.height; 
				}
			} 
		}
		
/**
 *  Grid row colours
 */
		public function swapRows(rowIndexA:int, rowIndexB:int):void {
			var rowA:Vector.<UICell> = _table[rowIndexA];
			var rowB:Vector.<UICell> = _table[rowIndexB];
			_table[rowIndexA] = rowB;
			_table[rowIndexB] = rowA;
		//	var yA:Number = rowA[0].y;
		//	var yB:Number = rowB[0].y;
		//	for each (var cellA:UICell in rowA) {
		//		cellA.y = yB;
		//	}
		//	for each (var cellB:UICell in rowB) {
		//		cellB.y = yA;
		//	}
			var dataA:Array = _data[rowIndexA];
			_data[rowIndexA] = _data[rowIndexB];
			_data[rowIndexB] = dataA;
		//	if (_multiLine) {
				rejig();
				drawBackground();
		//	}
		}
		
/**
 *  Shift rows up or down - utilised when inserting or deleting rows
 */
		protected function shiftRows(index:int, deltaHeight:Number):void {
			for (var i:int = index; i < _table.length; i++) {
				var row:Vector.<UICell> = _table[i];
				for each (var cell:UICell in row) {
					cell.y += deltaHeight;
				}
			}
		}
		
/**
 *  Insert a row within the datagrid
 */
		public function insertRow(rowIndex:int, rowData:Array):void {
			var cell:UICell = rowIndex >= _table.length ? null : _table[rowIndex][0];
			var row:Vector.<UICell> = _table[_table.length - 1];
			var rowY:Number = cell ? cell.y : row[0].y;
			if (cell) {
				shiftRows(rowIndex, cell.height);
			}
			var index:int = 0;
			var newRow:Vector.<UICell> = new Vector.<UICell>();
			for each (var topCell:UICell in row) {
				newRow.push(cell = newCell(_dataStyle));
				cell.x = topCell.x;
				cell.y = rowY;
				cell.xmlText = rowData[index];
				cell.fixwidth = topCell.width;
				index++;
			}
			_table.splice(rowIndex, 0, newRow);
			_data.splice(rowIndex, 0, rowData);
			drawBackground();
		}
		
/**
 *  Delete a specific row from the datagrid
 */
		public function deleteRow(rowIndex:int):void {
			var row:Vector.<UICell> = _table[rowIndex];
			shiftRows(rowIndex, -row[0].height);
			_data.splice(rowIndex, 1);
			_table.splice(rowIndex, 1);
			for each (var cell:UICell in row) {
				removeCell(cell);
			}
			drawBackground();
		}
		
		
		protected function get calculateWidth():Number {
			var result:Number = 0;
			var row:Vector.<UICell> = _table[0];
			var wdth:Number=_tableWidth/row.length;
			for (var i:int = 0; i < row.length; i++) {
				result += Math.ceil(_columnWidths ? _columnWidths[i] : (_cellWidths ? _tableWidth*_cellWidths[Math.min(_cellWidths.length-1,i)]/100 : wdth));
			}
			return result;
		}

/**
 *  Realign and adjust the datagrid cell positions
 */
		override protected function rejig():void {
			if (_table.length == 0) {
				return;
			}
			var lastY:Number = 0;
			var columns:int = _table[0].length;
			graphics.clear();
			var wdth0:Number=_tableWidth/columns;
			if (_title) {
				_title.autoSize = TextFieldAutoSize.LEFT;
				lastY = _title.height;
				_title.fixwidth = _tableWidth;
			}
			var theWidth:Number = _fits ? _tableWidth : Math.max(calculateWidth, _tableWidth);
			for (var i:int = 0; i<_table.length; i++) {
				var row:Vector.<UICell> = _table[i];
			//	var wdth0:Number=_tableWidth/row.length;
				
				var position:Number = 0;
				var maxHeight:Number = initialHeight(i);
				
				for (var j:int = 0; j < row.length; j++) {
					var wdth:Number;
					var colSpan:Boolean = false;
					if (j == row.length - 1) {
						wdth = Math.ceil(theWidth - position);
						colSpan = _colSpanWrap && j < columns - 1;
					}
					else {
						wdth = Math.ceil(_columnWidths ? _columnWidths[j] : (_cellWidths) ? _tableWidth*_cellWidths[Math.min(_cellWidths.length-1,j)]/100 : wdth0);
					}
					var cell:UICell = row[j];
					cell.x = position;
					cell.y = lastY;
					cell.fixwidth = wdth;
					cell.multiline = _multiLine || colSpan;
					cell.wordWrap = _wordWrap || colSpan;
					position += wdth;
					if (_wordWrap || colSpan) {//_multiLine
						cell.autoSize = TextFieldAutoSize.LEFT;
					}
					if (cell.height > maxHeight) {
						maxHeight = cell.height;
					}
				}
				for each (var cell0:UICell in row) {
					cell0.fixheight = maxHeight;
				}
				lastY += maxHeight;
			}
		}
		
		
		override public function layout(attributes:Attributes):void {
			super.layout(attributes);
			_attributes = attributes;
			x=attributes.x;
			y=attributes.y;
			if (!_fastLayout) {
				doLayout();
			//	_fastLayout = _xml.@fastLayout == "true";
			}
		}
		
			
		override public function get numberOfRows():int {
			return _table.length;
		}
	
		
/**
 *  Convert y coordinate to row index
 */
		override public function yToRow(y:Number):int {
			var result:int = -1;
			if (_table.length > 0 && y > 0 && y <= theHeight) {
				result = Math.min(Math.round(_table.length * y / theHeight), _table.length - 1);
				var cell:UICell = _table[result][0];
				if (y < cell.y) {
					result--;
					while (result >= 0 && y < _table[result][0].y) {
						result--;
					}
				}
				else if (y > cell.y + cell.height) {
					result++;
					while (result < _table.length && y > (cell = _table[result][0]).y + cell.height) {
						result++;
					}
				}
			}
			return result;
		//	return (hasHeader && result == 0) ? -1 : result;
		}
		
/**
 *  Reset datagrid text size
 */
		public function set textSize(value:Number):void {
			_dataStyle.size = value;
			_headerStyle.size = value;
			var sizeFormat:TextFormat = new TextFormat(null, value);
			for each (var row:Vector.<UICell> in _table) {
				for each (var cell:UICell in row) {
					cell.setTextFormat(sizeFormat);
				}
			}
			rejig();
		}		
				
/**
 * Set datagrid data
 */
		override protected function setData(value:Array, includeHeader:Boolean = false):void {
			if (_newData) {
				super.setData(value, includeHeader);
			}
			else {
				_data = value;
				if (includeHeader) {
					if (!_hasHeader) {
						addHeaderToTable();
					}
				}
				else if (_hasHeader) {
					removeHeaderFromTable();
				}
				newDimensions(value.length + (!includeHeader && _hasHeader ? 1 : 0), value.length > 0 ? value[0].length : 0);
				invalidate(false, includeHeader);
				doLayout();
			}
		}
		
/**
 * Refresh datagrid with new data
 */
		public function set dataProvider(value:Array):void {
			_data = value;
			invalidate();
		}
		 
/**
 * Refresh datagrid
 */
		public function invalidate(readGrid:Boolean = false, includeHeader:Boolean = false):void {
			var start:int = !includeHeader && _hasHeader ? 1 : 0;
			var header:Boolean = includeHeader && _hasHeader;
			var format:TextFormat = header ? _headerStyle : _dataStyle;
			for (var i:int = start; i<_table.length; i++) {
				var row:Vector.<UICell> = _table[i];
				for (var j:int=0; j<row.length; j++) {
					if (readGrid) {
						_data[i-start][j] = row[j].text;
					}
					else {
						var item:String = _data[i-start][j];
						var cell:UICell = row[j];
						cell.setTextFormat(format);
						cell.defaultTextFormat = format;
						cell.xmlText = (item != null) ? item : "";
						cell.border = !header || _headerLines;
					}
				}
				format = _dataStyle;
				header = false;
			}
		}
		
		
		protected function addColSpanPadding():void {
			if (!_colSpan || !_columnWidths || !_colSpanWidths) {
				return;
			}
			var sum:Number = 0;
			var maxWidth:Number = 0;
			for (var i:int = 0; i < _columnWidths.length; i++) {
				var rowWidth:Number = sum + _colSpanWidths[i];
				if (rowWidth > maxWidth) {
					maxWidth = rowWidth;
				}
				sum += _columnWidths[i];
			}
			if (maxWidth > sum) {
				if (!_colSpanWrap) {
					_columnWidths[_columnWidths.length - 1] += (maxWidth - sum);
					_fits = false;
				}
			}
		}
		
		
		override protected function initialiseColumnWidths():void {
			var columns:int = _table[0].length;
			_colSpanWidths = new Vector.<Number>(columns);
			_columnWidths = new Vector.<Number>(columns);
			var hasColSpans:Boolean = false;
			for (var i:int = 0; i<_table.length; i++) {
				var row:Vector.<UICell> = _table[i];
				if (!_colSpan || row.length == columns || i < row.length - 1) {
					for (var j:int = 0; j < row.length; j++) {
						var cell:UICell = row[j];
						cell.multiline = cell.wordWrap = false;
						cell.autoSize = TextFieldAutoSize.LEFT;
						if (cell.width > _columnWidths[j]) {
							_columnWidths[j] = cell.width + 1.0;
						}
					}
				}
				else {
					var index:int = row.length - 1;
					var lastCell:UICell = row[index];
					lastCell.multiline = lastCell.wordWrap = false;
					lastCell.autoSize = TextFieldAutoSize.LEFT;
					var colSpanWidth:Number = lastCell.width;
					if (colSpanWidth > _colSpanWidths[index]) {
						_colSpanWidths[index] = colSpanWidth;
						hasColSpans = true;
					}
				}
			}
			if (!hasColSpans) {
				_colSpanWidths = null;
			}
		}
		
/**
 *  Attempt to make the datagrid width fits exactly the width of the screen
 */
		override public function compact(padding:Boolean = false):void {
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
					else if (_wordWrap) {//_wordWrap
						var maxColumn:int = -1;
						var maxValue:Number = 0;
						for (var l:int = 0; l < _columnWidths.length; l++) {
							if (_columnWidths[l] > maxValue) {
								maxColumn = l;
								maxValue = _columnWidths[l];
							}
						}
						var indexes:Array = [];
						var minValue:Number = maxValue;
						for (var m:int = 0; m < _columnWidths.length; m++) {
							var value:Number = _columnWidths[m];
							if (value/maxValue > 0.7) {
								indexes.push(m);
								if (value < minValue) {
									minValue = value;
								}
							}
						}
						var reduction:Number = (sum - _tableWidth) / indexes.length;
						if (minValue - reduction > THRESHOLD) {
							for each (var index:int in indexes) {
								_columnWidths[index] -= reduction;
							}
						}
					}
				}
				addColSpanPadding();
				rejig();
			}
		}
		
		
		override public function rowPosition(value:int):Number {
			return _table[value][0].y;
		}
		
		
		override public function rowHeight(value:int):Number {
			return _table[value][0].height;
		}
		
/**
 *  Add and remove rows and columns to resize the datagrid efficiently
 */
		protected function newDimensions(rows:int, columns:int):void {
			var oldRows:int = _table.length;
			var oldColumns:int = _table.length > 0 ? _table[0].length : 0;
			var header:Boolean = _hasHeader;
			if (rows < oldRows) {
				for (var r0:int = rows; r0 < oldRows; r0++) {
					var row0:Vector.<UICell> = _table[r0];
					for each (var cell:UICell in row0) {
						removeCell(cell);
					}
				}
				_table.splice(rows, oldRows - rows);
			}
			if (columns < oldColumns) {
				for each (var row1:Vector.<UICell> in _table) {
					if (header) {
						for (var c0:int = columns; c0 < oldColumns; c0++) {
							removeCell(row1[c0]);
						}
						header = false;
					}
					else {
						for (var c1:int = columns; c1 < oldColumns; c1++) {
							removeCell(row1[c1]);
						}
					}
					row1.splice(columns, oldColumns - columns);
				}
			}
			if (rows > oldRows) {
				for (var r1:int = oldRows; r1 < rows; r1++) {
					var newRow:Vector.<UICell> = new Vector.<UICell>();
					for (var c2:int = 0; c2 < Math.min(columns, oldColumns); c2++) {
						newRow.push(newCell(_dataStyle));
					}
					_table.push(newRow);
				}
			}
			if (columns > oldColumns) {
				for each (var row:Vector.<UICell> in _table) {
					if (header) {
						for (var c3:int = oldColumns; c3 < columns; c3++) {
							row.push(newCell(_headerStyle));
						}
						header = false;
					}
					else {
						for (var c4:int = oldColumns; c4 < columns; c4++) {
							row.push(newCell(_dataStyle));
						}
					}
				}
			}
		}
		
	} 
}
