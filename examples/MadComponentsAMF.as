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

// ******* README FIRST ******
// In order to run this app - you need to set up a zend server for AMF
// Follow the instructions at http://www.adobe.com/devnet/flex/testdrivemobile/articles/mtd_1_1.html

package
{
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	public class MadComponentsAMF extends Sprite {

		protected static const AMF_LIST:XML = 	<list id="list" sortBy="lastname">
				
													<model url="http://localhost/MobileTestDrive/gateway.php" service="EmployeeService.getEmployeesSummary" action="loadAMF">
														<firstname>label</firstname>													
														<lastname>label</lastname>
														<photofile>image</photofile>
														<title/>
														<id/>
													</model>
													
													<search field="label"/>
				
													<horizontal>
														<imageLoader alignV="centre" id="image" base="http://localhost/TestDrive/photos/">40</imageLoader>
														<vertical>													
															<label id="label"/>
															<label id="title"><font size="10" color="#999999"/></label>
														</vertical>
													</horizontal>
	
												</list>;
		
		
		protected static const FONT:XML =		<font size="14"/>;
		
		
		protected static const DETAIL:XML = 	<columns id="detail" widths="80,100%">
			
													<model url="http://localhost/MobileTestDrive/gateway.php" service="EmployeeService.getEmployeesByID"/>
			
													<imageLoader id="photofile" base="http://localhost/TestDrive/photos/">80</imageLoader>
													<vertical gapV="0">
														<label><b>Title</b></label>
														<label id="title">{FONT}</label>
														<label/>
														<label><b>Cell Phone</b></label>
														<label id="cellphone">{FONT}</label>
														<label/>
														<label><b>Office Phone</b></label>
														<label id="officephone">{FONT}</label>
														<label/>
														<label><b>Email</b></label>
														<label id="email">{FONT}</label>
														<label/>
														<label><b>Office</b></label>
														<label id="office">{FONT}</label>
														<label/>
													</vertical>
												</columns>;
			

		protected static const NAVIGATION:XML = <navigation id="navigator" autoTitle="label">
													{AMF_LIST}
													{DETAIL}
												</navigation>;

													
		protected var _detail:UIForm;
		protected var _navigator:UINavigation;

		public function MadComponentsAMF(screen:Sprite = null) {
			if (screen)
				screen.addChild(this);
			
			stage.align = StageAlign.TOP_LEFT;  
			stage.scaleMode = StageScaleMode.NO_SCALE;

			UI.create(this, NAVIGATION);
			
			_detail = UIForm(UI.findViewById("detail"));
			_navigator = UINavigation(UI.findViewById("navigator"));
			_navigator.addEventListener(Event.CHANGE, pageChange);
		}
		
		
		protected function pageChange(event:Event):void {
			if (_navigator.pageNumber == 1) {
				_detail.data = {image:null};
				_detail.model.loadAMF("","",[_navigator.row.id]);
			}
			else {
				_navigator.title = "";
			}
		}
		
	}
}