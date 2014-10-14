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
package
{
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;

	
	public class MadComponentsFullPageTab extends Sprite {

		
		protected static const TAB_PAGES:XML = <pages id="pages">
													<tabPages id="tabPages">
														<label alignH="centre">page 0</label>
														<label alignH="centre">page 1</label>
														<label/>
													</tabPages>
													<navigation id ="navigation" title="page 2">
														<label>Content Goes Here</label>
													</navigation>
												</pages>;
		
		
		protected var _pages:UIPages;
		protected var _tabPages:UITabPages;
		protected var _navigation:UINavigation;
		
		
		public function MadComponentsFullPageTab(screen:Sprite = null) {
			if (screen)
				screen.addChild(this);

			stage.align = StageAlign.TOP_LEFT;  
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			UI.create(this, TAB_PAGES);
			
			_pages = UIPages(UI.findViewById("pages"));
			
			_tabPages = UITabPages(UI.findViewById("tabPages"));
			_tabPages.addEventListener(UIPages.COMPLETE, pageChanged);
	
			_navigation = UINavigation(UI.findViewById("navigation"));
			_navigation.navigationBar.backButton.visible = true;
			_navigation.navigationBar.backButton.addEventListener(MouseEvent.MOUSE_UP, pageBack);
		}
		
		
		protected function pageChanged(event:Event):void {
			if (_tabPages.pageNumber == 2) {
				_pages.goToPage(1);
				_navigation.navigationBar.backButton.visible = true;
			}
		}
		
		
		protected function pageBack(event:MouseEvent):void {
			_pages.goToPage(0);
			_tabPages.pageNumber = 0;
		}
	}
}