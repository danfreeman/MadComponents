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

		
/**
 *  MadComponents navigation controller
 * <pre>
 * &lt;navigationPages
 *    id = "IDENTIFIER"
 *    colour = "#rrggbb"
 *    background = "#rrggbb, #rrggbb, ..."
 *    visible = "true|false"
 *    gapV = "NUMBER"
 *    gapH = "NUMBER"
 *    alignH = "left|right|centre|fill"
 *    alignV = "top|bottom|centre|fill"
 *    leftButton = "TEXT"
 *    rightButton = "TEXT"
 *    rightArrow = "TEXT"
 *    leftArrow = "TEXT"
 *    title = "TEXT"
 *    autoFill = "true|false"
 *    autoTitle = "TEXT"
 *    border = "true|false"
 *    mask = "true|false"
 *    backToExit = "true|false"
 *    leftButtonColour = "#rrggbb"
 *    rightButtonColour = "#rrggbb"
 *    arrowColour = "#rrggbb"
 *    autoForward = "true|false"
 *    backKey = "true|false"
 *    style7 = "true|false"
 *    lazyRender = "true|false"
 *    recycle = "true|false"
 *    easeIn = "NUMBER"
 *    easeOut = "NUMBER"
 *    slideOver = "true|false"
 * /&gt;
 * </pre>
 */	
package com.danielfreeman.madcomponents
{
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;	

	public class UINavigationPages extends UINavigation
	{
		protected var _inside:Boolean = false;
		
		public function UINavigationPages(screen:Sprite, xml:XML, attributes:Attributes)
		{
			super(screen, xml, attributes, !(screen.parent is UINavigationPages));
		}
		
		
		public function backChain():Boolean {
			var pageContents:DisplayObject = (_thisPage is Sprite) ? Sprite(_thisPage).getChildAt(0) : null;
			if (!(pageContents is UINavigationPages && UINavigationPages(pageContents).backChain())) {
				if (!_slideTimer.running && _autoBack && _page>0) {
					if (_autoTitle!="") {
						title = _titles[0];
					}
					goToPage(0,UIPages.SLIDE_RIGHT);
					return true;
				}
			}
			return false;
		}


/**
 *  Go forward handler
 */	
		override protected function goForward(event:Event):void {
			if (!_slideTimer.running) {
				_pressedCell = UIList(event.target).index;
				_row = UIList(event.target).row;
				if (_autoForward) {
					if (_autoTitle!="" && _row[_autoTitle]) {
						title = _titles[_pressedCell+1] = _row[_autoTitle];
					}
					var newPage:int = Math.min(_pressedCell+1, _pages.length-1);
					goToPage(newPage, UIPages.SLIDE_LEFT);
				}
			}
			event.stopImmediatePropagation();
		}

/**
 *  Go back handler
 */	
		override protected function goBack(event:MouseEvent = null):void {
			backChain();
		}
	}
}