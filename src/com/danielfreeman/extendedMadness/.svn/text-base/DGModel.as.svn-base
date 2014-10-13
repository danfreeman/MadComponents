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
	import flash.display.Sprite;
	
	public class DGModel extends Model {

/**
 * Model tag for datagrid
 */
		public function DGModel(parent:Sprite,xml:XML,sendXml:XML = null) {
			super(parent, xml, sendXml);
		}
		
		
	//	override public function set xmlData(xml:XML):void {
	//		var arrayCollectionGrid:Array = listData(xml,_schema);
	//		UIDataGrid(_parent).data = to2dArray(arrayCollectionGrid,_schema);
	//	}
		
		
		protected function to2dArray(arrayCollection:Array, schema:XML):Array {
			var descendents:XMLList = schema.descendants();
			var max:int = -1;
			for each (var part:XML in descendents) {
				if (part.nodeKind() == "text") {
					if (String(part).substr(0,6) == "column") {
						var columnNumber:int = parseInt(String(part).substr(6));
						if (columnNumber > max) {
							max = columnNumber;
						}
					}
				}
			}
			var result:Array = [];
			for each(var record:Object in arrayCollection) {
				var row:Array = [];
				for (var column:int=0; column<=max; column++) {
					var value:* = record["column"+column.toString()];
					if (value == undefined) {
						row.push("");
					}
					else {
						row.push(value);
					}
				}
				result.push(row);
			}
			return result;
		}

	}
}