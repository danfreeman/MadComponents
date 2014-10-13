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
	import flash.text.TextFormat;
	
	
/**
 *  Datagrid component
 * <pre>
 * &lt;dataGrid
 *    id = "IDENTIFIER"
 *    colour = "#rrggbb"
 *    background = "#rrggbb, #rrggbb, ..."
 *    visible = "true|false"
 *    widths = "p,q,r..."
 *    alignH = "left|right|centre|fill"
 *    alignV = "top|bottom|centre|fill"
 *    editable = "true|false"
 * /&gt;
 * </pre>
 */
	public class UIDataGrid extends Sprite implements IContainerUI { 
		
		protected static const DEFAULT_HEADER_COLOUR:uint=0x9999AA; //0x4481c1; 
		protected static const DEFAULT_COLOURS:Array=[0xe8edf5,0xcfd8e9]; 
		protected static const TABLE_WIDTH:Number=300.0;
		protected static const TEXT_SIZE:Number=12.0;
		protected static const HEADER_STYLE:TextFormat = new TextFormat('Arial',TEXT_SIZE,0xFFFFFF);
		protected static const DATA_STYLE:TextFormat = new TextFormat('Arial',TEXT_SIZE,0x333333); 
		
		protected var _table:Array=new Array(); 
		protected var _last:Number=0; 
		protected var _lastWidth:Number; 
		protected var _cellWidths:Array = null; 
		protected var _leftMargin:Number;
		protected var _tableWidth:Number;
		protected var _data:Array = [];
		protected var _editable:Boolean = false;
		protected var _borderColour:uint;
		protected var _model:DGModel = null;
		protected var _colours:Array = DEFAULT_COLOURS;
		protected var _xml:XML;
		protected var _attributes:Attributes;
		
		
		public function UIDataGrid(screen:Sprite, xml:XML, attributes:Attributes) {							   

			screen.addChild(this); 
			x=attributes.x;
			y=attributes.y;
			_xml = xml;
			
			_tableWidth=attributes.width;
			_leftMargin=4.0;
			
			_borderColour=attributes.colour;
			
			if (xml.widths.length()>0) {
				_cellWidths = xml.widths.split(",");
			}
			if (xml.model.length()>0) {
				_model = new DGModel(this,xml.model[0]);
			}
			
			if (xml.@editable.length()>0 && xml.@editable[0]=="true")
				_editable = true;
			
			var headerText:Array = extractHeader(xml);
			var headerColour:uint = (attributes.backgroundColours.length>0) ? attributes.backgroundColours[0] : DEFAULT_HEADER_COLOUR;
			
			if (headerText) {
				makeTable([headerText], [headerColour], HEADER_STYLE);
			}
			
			if (attributes.backgroundColours.length>1) {
				_colours = [];
				for (var i:int = 1; i < attributes.backgroundColours.length; i++) {
					_colours.push(attributes.backgroundColours[i]);
				}
			}
			
			if (xml.data.length()>0)
				extractData(xml.data[0]);
			makeTable(_data, _colours, null, _editable); 
		} 
		
		
		protected function makeTable(data:Array,colours:Array,format:TextFormat=null,editable:Boolean=false):void { 
			var txt:UIBlueText; 
			if (!format) format=DATA_STYLE;
			format.leftMargin=_leftMargin; 
			for (var i:int=0;i<data.length;i++) { 
				var dataRow:Array=data[i]; 
				var row:Array=_table[_table.length]=new Array(); 
				var wdth0:Number=_tableWidth/dataRow.length; 
				var lastX:Number=0; 
				for (var j:int=0;j<dataRow.length;j++) { 
					var wdth:Number=(_cellWidths) ? _tableWidth*_cellWidths[Math.min(_cellWidths.length-1,j)]/100 : wdth0;
					row.push(txt=new UIBlueText(this,lastX,_last,dataRow[j],wdth,format)); 
					txt.fixwidth = wdth;
					txt.border = true;
					txt.borderColor = _borderColour;
					lastX=txt.x+txt.width;
					
					if (colours!=null)
						txt.defaultColour=colours[i%colours.length];
						
					txt.mouseEnabled=editable; 
				} 
				if (txt) _last=txt.y+txt.height; 
			} 
		}
		
		
		public function get pages():Array {
			return [];
		}
		
		
		protected function extractData(xml:XML):void {
			var rows:XMLList = xml.row;
			_data=new Array();
			for each (var row:XML in rows) {
				var dataRow:Array = row.toString().split(",");
				_data.push(dataRow);
			}
		}
		
		
		public function layout(attributes:Attributes):void {
			x=attributes.x;
			y=attributes.y;
			_attributes = attributes;
			_tableWidth=attributes.width;
			for (var i:int = 0; i<_table.length;i++) {
				var row:Array = _table[i];
				var wdth0:Number=_tableWidth/row.length;
				var position:Number = 0;
				for (var j:int=0;j<row.length;j++) {
					var wdth:Number=Math.round((_cellWidths) ? _tableWidth*_cellWidths[Math.min(_cellWidths.length-1,j)]/100 : wdth0);
					row[j].x = position;
					row[j].fixwidth = wdth;
					position+=wdth;
				}
			}
		}
		
		
		public function drawComponent():void {	
		}
		
/**
 * Clear the data grid
 */
		public function clear():void {
			for (var i:int = 1; i<_table.length;i++) {
				var row:Array = _table[i];
				for (var j:int=0;j<row.length;j++) {
					removeChild(row[j]);
				}
			}
			_table = [_table[0]];
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
		//	else if (xml.data.length()>0 && xml.data[0].header.length()>0) {
		//		return xml.data[0].header[0].toString().split(",");
		//	}
			else {
				return null;
			}
		}
		
/**
 * Set datagrid data
 */
		public function set data(value:Array):void {
			clear();
			_data = value;
			makeTable(_data, _colours, null, _editable);
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
		public function invalidate(readGrid:Boolean = false):void {
			for (var i:int = 1; i<_table.length;i++) {
				var row:Array = _table[i];
				for (var j:int=0;j<row.length;j++) {
					if (readGrid) {
						_data[i-1][j] = row[j].text;
					}
					else {
						row[j].text = _data[i-1][j];
					}
				}
			}
		}
		
		
		public function get xml():XML {
			return _xml;
		}
		
		
		public function get attributes():Attributes {
			return _attributes;
		}
		
		
		public function destructor():void {
			for (var i:int = 0; i<_table.length;i++) {
				var row:Array = _table[i];
				for (var j:int=0;j<row.length;j++) {
					UIBlueText(row[j]).destructor();
				}
			}
		}
		
	} 
}
