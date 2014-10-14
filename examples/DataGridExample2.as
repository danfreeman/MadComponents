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

package {
	
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;	
	import com.danielfreeman.madcomponents.*;
	import com.danielfreeman.extendedMadness.*;
	import flash.utils.getQualifiedClassName;

	public class DataGridExample2 extends Sprite {

		public static const DATA0:XML =

			<data>
				<header>aaa,bbb,ccc,ddd</header>
				<row>876,283,456,745</row>
				<row>106,374,584,982</row>
			</data>;
			
			
		public static const DATA2:XML =

			<data>
				<header>number,colour,shape</header>
				<row>six,red,triangle</row>
				<row>seven,orange,square</row>
				<row>eight,yellow,pentagon</row>
				<row>nine,green,hexagon</row>
				<row>ten,blue,septagon</row>
				<row>eleven,indigo,octagon</row>
				<row>twelve,violet,nonagon</row>
			</data>;
			
			
		protected static const DATAGRID0:XML =
		
			<fastDataGrid titleBarColour="#333333" background="#333333,#FFFFFF,#CCCCCC">
				<title><font color="#FFFFFF" size="18"/>Datagrid 0</title>
				<headerFont face="Arial" size="16" color="#EEEEFF"/>
				<font face="Arial" size="13" color="#333333"/>
				{DATA0}
			</fastDataGrid>;
			
			
		protected static const DATAGRID1:XML =
		
			<fastDataGrid id="dataGrid1" titleBarColour="#333333" background="#333333,#FFFFFF,#CCCCFF">
				<title><font color="#FFFFFF" size="18"/>Datagrid 1</title>
				<headerFont face="Arial" size="16" color="#EEFFEE"/>
				<font face="Arial" size="13" color="#333333"/>
			</fastDataGrid>;
			
			
		protected static const DATAGRID2:XML =
		
			<fastDataGrid titleBarColour="#333333" background="#333333,#FFFFFF,#CCFFCC">
				<title><font color="#FFFFFF" size="18"/>Datagrid 2</title>
				<headerFont face="Arial" size="16" color="#FFEEEE"/>
				<font face="Arial" size="13" color="#333333"/>
				{DATA2}
			</fastDataGrid>;
			
			
		protected static const LAYOUT:XML =
		
			<scrollDataGrids id="scrollGrids" fixedColumns="0" gapV="0">
				{DATAGRID0}
				{DATAGRID1}
				{DATAGRID2}
			</scrollDataGrids>;


		public function DataGridExample2(screen:Sprite = null) {
			if (screen)
				screen.addChild(this);

			stage.align = StageAlign.TOP_LEFT;  
			stage.scaleMode = StageScaleMode.NO_SCALE;

			UIe.create(this, LAYOUT);
			UIFastDataGrid(UI.findViewById("dataGrid1")).headerAndData = [["sam","fred","joe","bert","harry"],[1,5,4,3,2],[9,4,2,5,4],[3,1,4,3,2],[8,4,2,3,8],[6,9,1,2,3],[6,4,2,1,3],[3,2,4,3,8],[9,5,3,2,4]]
			UIScrollDataGrids(UI.findViewById("scrollGrids")).doLayout();
		}
	}
}
