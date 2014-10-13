package com.danielfreeman.extendedMadness {
	import flash.text.TextFormat;
	import flash.display.DisplayObject;
	import com.danielfreeman.extendedMadness.UIFastDataGrid;

	import flash.display.Sprite;

	import com.danielfreeman.madcomponents.Attributes;

	/**
	 * @author danielfreeman
	 */
	public class UISpecialDataGrid extends UIFastDataGrid {
		
		protected var _dataAndExtras:Array;
		protected var _imageMarginH:Number = 0;
		protected var _imageMarginV:Number = 0;


		public function UISpecialDataGrid(screen : Sprite, xml : XML, attributes : Attributes) {
			if (xml.@imageMarginH.length() > 0) {
				_imageMarginH = parseFloat(xml.@imageMarginH);
			}
			if (xml.@imageMarginV.length() > 0) {
				_imageMarginV = parseFloat(xml.@imageMarginV);
			}
			super(screen, xml, attributes);
		}
		
		
		override protected function initialHeight(rowIndex:int):Number {
			if (!_dataAndExtras || _dataAndExtras.length == 0) {
				return 0;
			}
			var result:Number = 0;
			var extrasRow:Array = _dataAndExtras[rowIndex];
			for each (var item:Object in extrasRow) {
				if (item is Array) {
					for each (var node:DisplayObject in item) {
						if (node) {
							result = Math.max(2 * _imageMarginV + node.height, result);
						}
					}
				}
				else if (item && item is DisplayObject) {
					result = Math.max(2 * _imageMarginV + DisplayObject(item).height, result);
				}
			}
			return result;
		}
		
		
		override protected function rejig():void {
			super.rejig();
			if (_dataAndExtras && _dataAndExtras.length == _table.length) {
				for (var i:int = 0; i < _table.length; i++) {
					var row:Vector.<UICell> = _table[i];
					var extrasRow:Array = _dataAndExtras[i];
					for (var j:int = 0; j < row.length; j++) {
						 var item:Object = extrasRow[j];
						 if (item) {
							var cell:UICell = row[j];
							if (item is Array) {
								var position:Number = cell.x + _imageMarginH;
								var rightPosition:Number = cell.x + cell.width - Number(cell.getTextFormat().rightMargin) + _imageMarginH;
								for each (var node:Object in item) {
									if (!node) {
										position = rightPosition;
									}
									else if (node is DisplayObject) {
										DisplayObject(node).x = position;
										DisplayObject(node).y = cell.y + _imageMarginV;
										position += DisplayObject(node).width + _imageMarginH;
									}
								}
							}
							else if (item is DisplayObject) {
								DisplayObject(item).x = cell.x + _imageMarginH;
								DisplayObject(item).y = cell.y + _imageMarginV;
							}
						 }
					}
				}
			}
		}
		
		
		protected function extractSpecialRow(row:Array):Array {
			var resultRow:Array = [];
			for (var i:int = 0; i < row.length; i++) {
				var item:Object = row[i];
				if (item is Array) {
					var textPart:String = "";
					var right:Boolean = false;
					var leftMargin:Number = _imageMarginH;
					var rightMargin:Number = _imageMarginH;
					for (var j:int = 0; j < item.length; j++) {
						var node:Object = item[j];
						if (node is String) {
							textPart = String(node);
							item[j] = null;
							right = true;
						}
						else {
							if (node is Class) {
								item[j] = node = new node();
							}
							addChild(DisplayObject(node));
							if (right) {
								rightMargin += DisplayObject(node).width + _imageMarginH;
							}
							else {
								leftMargin += DisplayObject(node).width + _imageMarginH;
							}
						}
					}
					resultRow.push('<textformat leftmargin="' + leftMargin.toString() + '" rightmargin="' + rightMargin.toString() + '">'+ textPart +'</textformat>');
				}
				else if (item is String || item is Number) {
					resultRow.push(String(item));
					row[i] = null;
				}
				else if (item is Class) {
					resultRow.push(null);
					addChild(row[i] = DisplayObject(new item()));
				}
				else if (item) {
					resultRow.push(null);
					addChild(DisplayObject(item));
				}
			}
			return resultRow;
		}
		
		
		protected function extractSpecialData(value:Array):Array {
			var result:Array = [];
			for each (var row:Array in value) {
				result.push(extractSpecialRow(row));
			}
			return result;
		}
		
		
		override public function set data(value:Array):void {
			clearExtras();
			_dataAndExtras = value;
			setData(extractSpecialData(value));
		}
		
		
		override public function set headerAndData(value:Array):void {
			clearExtras();
			_dataAndExtras = value;
			setData(extractSpecialData(value), true);
		}
		
		
		protected function clearExtrasRow(row:Array):void {
			for each (var item:Object in row) {
				if (item is Array) {
					for each(var node:Object in item) {
						if (node && node is DisplayObject) {
							DisplayObject(node).parent.removeChild(DisplayObject(node));
						}
					}
				}
				else if (item && item is DisplayObject) {
					DisplayObject(item).parent.removeChild(DisplayObject(item));
				}
			}
		}
		
		
		protected function clearExtras():void {
			for each (var row:Array in _dataAndExtras) {
				clearExtrasRow(row);
			}
			_dataAndExtras = null;
		}
		
		
		override public function clear():void {
			super.clear();
			clearExtras();
		}
		
		
		public function copyColumns(destination:Sprite, n:int):void {
			for each (var row:Array in _dataAndExtras) {
				for (var i:int = 0; i < n; i++) {
					var item:Object = row[i];
					if (item is Array) {
						for each(var node:Object in item) {
							if (node && node is DisplayObject) {
								destination.addChild(DisplayObject(node));
							}
						}
					}
					else if (item && item is DisplayObject) {
						destination.addChild(DisplayObject(item));
					}
				}
			}
		}
		
		
/**
 *  Grid row colours
 */
		override public function swapRows(rowIndexA:int, rowIndexB:int):void {
			var rowA:Array = _dataAndExtras[rowIndexA];
			var rowB:Array = _dataAndExtras[rowIndexB];
			_dataAndExtras[rowIndexA] = rowB;
			_dataAndExtras[rowIndexB] = rowA;
			super.swapRows(rowIndexA, rowIndexB);
		}
		
/**
 *  Shift rows up or down - utilised when inserting or deleting rows
 */
		override protected function shiftRows(index:int, deltaHeight:Number):void {
			super.shiftRows(index, deltaHeight);
			for (var i:int = index; i < _dataAndExtras.length; i++) {
				var row:Array = _dataAndExtras[i];
				for each (var item:Object in row) {
					if (item is Array) {
						for each(var node:Object in item) {
							if (node && node is DisplayObject) {
								node.y += deltaHeight;
							}
						}
					}
					else if (item && item is DisplayObject) {
						item.y += deltaHeight;
					}
				}
			}
		}
		
/**
 *  Insert a row within the datagrid
 */
		override public function insertRow(rowIndex:int, rowData:Array):void {
			_dataAndExtras.splice(rowIndex, 0, rowData);
			super.insertRow(rowIndex, extractSpecialRow(rowData));
		}
		
/**
 *  Delete a specific row from the datagrid
 */
		override public function deleteRow(rowIndex:int):void {
			clearExtrasRow(_dataAndExtras[rowIndex]);
			_dataAndExtras.splice(rowIndex, 1);
			super.deleteRow(rowIndex);
		}
		
	}
}
