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

package com.danielfreeman.extendedMadness
{
	import asfiles.GraphPalette;
	import asfiles.GraphSettings;
	import asfiles.MyEvent;
	import asfiles.Packet;
	import asfiles.PieGraph;
	
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * Pie chart component
	 * <pre>
	 * &lt;pieChart
	 *    id = "IDENTIFIER"
	 *    colours = "#rrggbb, #rrggbb, ..."
	 *    render = "2d|2D|3d|3D"
	 *    palette = "#rrggbb, #rrggbb, ..."
	 *    paletteStart = "n"
	 *    order = "rows|columns"
	 *    increment = "NUMBER"
	 *    minimum = "NUMBER"
	 *    maximum = "NUMBER"
	 * /&gt;
	 * </pre>
	 * */	
	public class UIPieChart extends MadSprite implements IComponentUI
	{
		protected static const OFFSET:Number = 38.0;
		
	//	protected var _attributes:Attributes;
	//	protected var _xml:XML;
		protected var _graph:GraphPalette;
		protected var _packet:Packet;
		
		public function UIPieChart(screen:Sprite, xml:XML, attributes:Attributes)
		{
			
			if (xml.data.length()>0) {
				_packet = setPacket(xml.data[0]);
			}
			else {
				_packet = new Packet();
				_packet.localdata = [[]];
			}
			
		//	_attributes = attributes;
		//	_xml = xml;
			
		//	screen.addChild(this);
			super(screen, attributes);
			createGraph(_packet);
			if (xml.colours.length()>0) {
				var colourString:String = xml.colours[0].toString();
				colourString = colourString.replace(/ /gi, "");
				var stValues:Array = colourString.split(",");
				var i:int = 0;
				for each(var value:String in stValues) {
					_graph.colours[i++] = UI.toColourValue(value);
				}
			}
			
			if (xml.@increment.length()>0) {
				_graph.increment = parseFloat(xml.@increment);
			}
			if (xml.@maximum.length()>0) {
				_graph.maximum = parseFloat(xml.@maximum);
			}
			if (xml.@minimum.length()>0) {
				_graph.minimum = parseFloat(xml.@minimum);
			}
			
			_graph.resize2(attributes.width,attributes.height);
			_graph.contained();
			_graph.controls.visible = false;
			_graph.y = -OFFSET;
			if (xml.@render.length()>0 && (xml.@render[0]=="2D" || xml.@render[0]=="2d")) {
				_graph.controls.dispatchEvent(new MyEvent(GraphSettings.SELECTED,GraphSettings.THREED));
			}
			if (xml.@stack.length()>0 && xml.@stack[0]!="false") {
				_graph.controls.dispatchEvent(new MyEvent(GraphSettings.SELECTED,GraphSettings.STACK));
			}
			if (xml.@paletteStart.length()>0) {
				_graph.controls.dispatchEvent(new MyEvent(GraphSettings.START,int(xml.@paletteStart[0])));
			}
			if (xml.@palette.length()>0) {
				_graph.controls.dispatchEvent(new MyEvent(GraphSettings.NEWMODE,"GraphSettings."+xml.@palette.toString()));
			}
			if (xml.@order.length()>0 && xml.@order[0]=="rows") {
				_graph.controls.dispatchEvent(new MyEvent(GraphSettings.SELECTED,GraphSettings.SWAP));
			}
		}
		
/**
 * Set chart colours
 */
		public function set colours(value:Array):void {
			_graph.colours = value;
		}
		
/**
 * Set chart data
 */
		public function set data(values:Array):void {
			_packet.ito = values.length-1;
			_packet.jto = values[0].length-1;
			_packet.localdata = values;
			_graph.darefresh();
		}
		
/**
 * Set chart xml data
 */
		public function set xmlData(value:XML):void {
			_packet = setPacket(value,_packet);
			_graph.darefresh();
		}
		

		protected function setPacket(data:XML,packet:Packet = null):Packet {
			if (!packet)
				packet = new Packet();
			var values:Array = [];
			if (data.row.length()>0) {
				var rows:XMLList = data.row;
				for each(var row:XML in rows) {
					var rowString:String = row.toString();
					rowString.replace(/ /gi, "");
					values.push(rowString.split(","));
				}
			}
			else {
				var dataString:String = data.toString();
				dataString.replace(/ /gi, "");
				values.push(dataString.split(","));
			}
			packet.ifrom = packet.jfrom = 0;
			packet.ito = values.length-1;
			packet.jto = values[0].length-1;
			packet.localdata = values;
			return packet;
		}
		
		
	//	public function drawComponent():void {	
	//	}
		
		
		override public function get theHeight():Number {
			return _graph.height - OFFSET;
		}
		
		
		protected function createGraph(packet:Packet):void {
			_graph = new PieGraph(this, 0, 0, packet);
		}
		
		
		override public function layout(attributes:Attributes):void {
			super.layout(attributes);
			_graph.resize2(attributes.width,attributes.height);
			_graph.contained();
			_graph.controls.visible = false;
		}
		
		
	//	public function get attributes():Attributes {
	//		return _attributes;
	//	}
		
		
	//	public function get xml():XML {
	//		return _xml;
	//	}
		
		
	//	public function findViewById(id:String, row:int = -1, group:int = -1):DisplayObject {
	//		return null;
	//	}
		
		
	//	public function clear():void {
	//	}
		
		
	//	public function get pages():Array {
	//		return [];
	//	}
		
		
		public function set increment(value:Number):void {
			_graph.increment = value;
			_graph.refresh();
		}
		
		
		public function set minimum(value:Number):void {
			_graph.minimum = value;
			_graph.refresh();
		}
		
		
		public function set maximum(value:Number):void {
			_graph.maximum = value;
			_graph.refresh();
		}
		
		
		public function get increment():Number {
			return _graph.increment;
		}
		
		
		public function get minimum():Number {
			return _graph.minimum;
		}
		
		
		public function get maximum():Number {
			return _graph.maximum;
		}
		
		
		override public function destructor():void {
			super.destructor();
			_graph.destructor();
		}
	}
}