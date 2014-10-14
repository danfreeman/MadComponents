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

	public class DataGridExample4 extends Sprite {
	
			
		protected static const LAYOUT:XML =
		
			<scrollTouchGrids editButton="true" id="scrollGrids" fixedColumns="0" gapV="0">
				<fastDataGrid id="dataGrid0" titleBarColour="#333333" background="#333333,#FFFFFF,#CCCCCC"/>
				<fastDataGrid id="dataGrid1" titleBarColour="#333333" background="#333333,#FFFFFF,#CCCCFF"/>
				<fastDataGrid id="dataGrid2" titleBarColour="#333333" background="#333333,#FFFFFF,#CCFFCC"/>
			</scrollTouchGrids>;


		public function DataGridExample4(screen:Sprite = null) {
			if (screen)
				screen.addChild(this);

			stage.align = StageAlign.TOP_LEFT;  
			stage.scaleMode = StageScaleMode.NO_SCALE;

			UIe.create(this, LAYOUT);
			UIFastDataGrid(UI.findViewById("dataGrid0")).title="grid0";
			UIFastDataGrid(UI.findViewById("dataGrid0")).headerAndData = [["sam","fred","joe","bert","harry"],[1,5,4,3,2],[9,4,2,5,4],[3,1,4,3,2],[8,4,2,3,8],[6,9,1,2,3],[6,4,2,1,3],[3,2,4,3,8],[9,5,3,2,4]];
			UIFastDataGrid(UI.findViewById("dataGrid1")).title="grid1";
			UIFastDataGrid(UI.findViewById("dataGrid1")).headerAndData = [["sam","fred","joe","bert","harry"],[1,5,4,3,2],[9,4,2,5,4],[3,1,4,3,2],[8,4,2,3,8],[6,9,1,2,3],[6,4,2,1,3],[3,2,4,3,8],[9,5,3,2,4]];
			UIFastDataGrid(UI.findViewById("dataGrid2")).title="grid2";
			UIFastDataGrid(UI.findViewById("dataGrid2")).headerAndData = [["sam","fred","joe","bert","harry"],[1,5,4,3,2],[9,4,2,5,4],[3,1,4,3,2],[8,4,2,3,8],[6,9,1,2,3],[6,4,2,1,3],[3,2,4,3,8],[9,5,3,2,4]];
			UIScrollTouchGrids(UI.findViewById("scrollGrids")).doLayout();
		}
	}
}
