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

	
	public class MadComponentsNavigationT0 extends Sprite
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
		
		protected static const DETAIL_PAGE:XML = <vertical id="detail"> 
													<label id="label" width="200" alignH="centre" alignV="centre"/>
												</vertical>;
		
		protected static const NAVIGATION:XML = <navigation id="nav">
													{LIST}
													{DETAIL_PAGE}
												</navigation>;
													
		protected static const DETAIL_ARRAY:Array = [{label:"I am an Apple"},
													{label:"I am an Orange"},
													{label:"I am a Banana"},
													{label:"I am something else"}];
													
		protected var _uiNavigation:UINavigation;
		protected var _detailPage:UIForm;
		
		
		public function MadComponentsNavigationT0(screen:Sprite = null) {
			if (screen)
				screen.addChild(this);
			
			stage.align = StageAlign.TOP_LEFT;  
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			UI.create(this, NAVIGATION);
			_detailPage = UIForm(UI.findViewById("detail"));
			_uiNavigation = UINavigation(UI.findViewById("nav"));
			_uiNavigation.addEventListener(UIList.CLICKED, navigationChange);
		}
		
		
		protected function navigationChange(event:Event):void {
			var index:int = _uiNavigation.index;
			if (index >= DETAIL_ARRAY.length) {
				index = DETAIL_ARRAY.length - 1;
			}
			_detailPage.data = DETAIL_ARRAY[index];
		}
	}
}