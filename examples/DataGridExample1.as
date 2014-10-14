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

	public class DataGridExample1 extends Sprite {

		public static const DATA:XML =

			<data>
				<header>number,a,b,c,d,e,f,g,h</header>
				<row>one,4,3,3,4,2,1,3,6</row>
				<row>two,6,2,8,5,3,5,7,9</row>
				<row>three,1,0,7,3,2,5,6,7</row>
				<row>four,4,2,5,7,4,2,8,9</row>
				<row>five,8,5,9,3,1,3,6,8</row>
			</data>;
			
			
		protected static const DATAGRID:XML =
		
			<fastDataGrid id="dataGrid" titleBarColour="#333333" background="#333333,#FFFFFF,#CCCCFF">
				<title><font color="#FFFFFF" size="18"/>Datagrid example</title>
				<headerFont face="Arial" size="16" color="#EEEEFF"/>
				<font face="Arial" size="13" color="#333333"/>
				{DATA}
			</fastDataGrid>;
			
			
		protected static const SCROLLGRID:XML =
		
			<scrollDataGrid id="scrollGrid" fixedColumns="1" titleBarColour="#333333" background="#333333,#FFFFFF,#CCCCCC">
				<title><font color="#FFFFFF" size="18"/>Scrolling datagrid example</title>
				<headerFont face="Arial" size="16" color="#EEEEFF"/>
				<font face="Arial" size="13" color="#333333"/>
				{DATA}
			</scrollDataGrid>;
			
			
		protected static const SCROLLING_DATAGRIDS:XML =
		
			<scrollDataGrids fixedColumns="1" >
				{DATAGRID}
				{DATAGRID}
			</scrollDataGrids>;	
			
		
		public static const LAYOUT:XML =

			<vertical border="false" gapV="0">
				{DATAGRID}
				{SCROLLGRID}
			</vertical>;


		public function DataGridExample1(screen:Sprite = null) {
			if (screen)
				screen.addChild(this);

			stage.align = StageAlign.TOP_LEFT;  
			stage.scaleMode = StageScaleMode.NO_SCALE;

			UIe.create(this, LAYOUT);
		//	UIFastDataGrid(UI.findViewById("dataGrid")).headerAndData = [["one","two","three"],[1,2,3],[4,5,6],[7,8,9]];
		}
	}
}
