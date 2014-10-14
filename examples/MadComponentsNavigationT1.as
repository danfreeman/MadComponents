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

	
	public class MadComponentsNavigationT1 extends Sprite
	{
		protected static const DATA:XML = <data>
											<Apple/>
											<Orange/>
											<Banana/>
											<Pineapple/>
											<Lemon/>
											<Mango/>
											<Plum/>
											<Cherry/>
											<Lime/>
											<Peach/>
											<Pomegranate/>
											<Grapefruit/>
											<Strawberry/>
											<Melon/>
										</data>;
		
		protected static const LIST:XML = <list>
												{DATA}
											</list>;
		
		protected static const APPLE_PAGE:XML = <label alignV="centre" alignH="centre">I am an Apple</label>;

		protected static const ORANGE_PAGE:XML = <label alignV="centre" alignH="centre">I am an Orange</label>;

		protected static const BANANA_PAGE:XML = <label alignV="centre" alignH="centre">I am a Banana</label>;
		
		protected static const ELSE_PAGE:XML = <label alignV="centre" alignH="centre">I am something else</label>;
		
		protected static const NAVIGATION:XML = <navigation id="nav">
													{LIST}
													{APPLE_PAGE}
													{ORANGE_PAGE}
													{BANANA_PAGE}
													{ELSE_PAGE}
												</navigation>;
													
		protected var _uiNavigation:UINavigation;
		
		
		public function MadComponentsNavigationT1(screen:Sprite = null) {
			if (screen)
				screen.addChild(this);
			
			stage.align = StageAlign.TOP_LEFT;  
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			UI.create(this, NAVIGATION);
			_uiNavigation = UINavigation(UI.findViewById("nav"));
			_uiNavigation.autoForward = false;
			_uiNavigation.autoBack = false;
			_uiNavigation.addEventListener(UIList.CLICKED, navigationChange);
			_uiNavigation.navigationBar.backButton.addEventListener(MouseEvent.MOUSE_UP, goBack);
		}
		
		
		protected function navigationChange(event:Event):void {
			if (_uiNavigation.index == 0) {
				_uiNavigation.goToPage(1, UIPages.SLIDE_LEFT);
			}
			else if (_uiNavigation.index == 1) {
				_uiNavigation.goToPage(2, UIPages.SLIDE_LEFT);
			}
			else if (_uiNavigation.index == 2) {
				_uiNavigation.goToPage(3, UIPages.SLIDE_LEFT);
			}
			else {
				_uiNavigation.goToPage(4, UIPages.SLIDE_LEFT);
			}
		}
		
		
		protected function goBack(event:Event):void {
			_uiNavigation.goToPage(0, UIPages.SLIDE_RIGHT);
		}
	}
}