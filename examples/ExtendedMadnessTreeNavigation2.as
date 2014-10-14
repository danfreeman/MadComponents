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
	import com.danielfreeman.extendedMadness.*;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	
	public class ExtendedMadnessTreeNavigation2 extends Sprite {
		
		protected static const DATA:XML = <data>
											<Animals>
												<Felines>
													<Tiger/>
													<Leopard/>
													<Lion/>
													<Panther/>
												</Felines>
												<Canines>
													<Dog/>
													<Wolf/>
													<Hyena/>
												</Canines>
												<Monkeys>
													<Baboon/>
													<Macaques/>
													<Chimpanzee/>
												</Monkeys>
											</Animals>
											<Household>
												<Kitchen>
													<Cooker/>
													<Fridge/>
													<Table/>
													<Cupboard/>
												</Kitchen>
												<Lounge>
													<Television/>
													<Sofa/>
													<Rug/>
													<Fireplace/>
												</Lounge>
											</Household>
											<Colours>
												<Red/>
												<Orange/>
												<Yellow/>
												<Green/>
												<Blue/>
												<Indigo/>
											</Colours>
										</data>;
		
		protected static const DETAIL:XML = <vertical>
												<label id="title" width="100" alignH="centre"/>
												<image id="image" alignH="centre">200</image>
												<label id="detail" alignH="fill"><font size="14"/></label>
											</vertical>;
		
		
		protected static const TREE_NAVIGATOR:XML = <treeNavigation id="tree" title="categories">
														{DATA}
														{DETAIL}
													</treeNavigation>;
														
		[Embed(source="images/dragon.jpg")]
		protected static const DRAGON:Class;
														
		[Embed(source="images/temple.jpg")]
		protected static const TEMPLE:Class;
		
		
		protected var _title:UILabel;
		protected var _detail:UILabel;
		protected var _image:UIImage;
		protected var _uiTreeNavigation:UITreeNavigation;
		
		protected var _path:Array = [];
		protected var _information:Dictionary = new Dictionary();
		
		
		public function ExtendedMadnessTreeNavigation2(screen:Sprite = null) {
			if (screen)
				screen.addChild(this);
			
			stage.align = StageAlign.TOP_LEFT;  
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			UIe.activate(this); // Gives us access to extended components
			UI.create(this, TREE_NAVIGATOR);
			
			_uiTreeNavigation = UITreeNavigation(UI.findViewById("tree"));
			_uiTreeNavigation.addEventListener(Event.CHANGE,treeChange);
			_uiTreeNavigation.addEventListener(Event.COMPLETE,treeComplete);
			
			_title = UILabel(UI.findViewById("title"));
			_detail = UILabel(UI.findViewById("detail"));
			_image = UIImage(UI.findViewById("image"));
			
			initialiseInformation();
		}
		
		
		protected function initialiseInformation():void {
			//I've only set up two detail pages as an example.  Red, and Tiger.
			
			_information["0,0,0"] = {image:DRAGON, detail:"This is an dragon.  Blah blah blah.  I didn't have a picture of a tiger - so I used this instead."}; //0,0,0 = Animals,Felines,Tiger
			_information["2,0"] = {image:TEMPLE, detail:"This is a temple."}; //2,0 = Colours,red
		}
		
		
		protected function treeChange(event:Event):void {
			if (_uiTreeNavigation.pageNumber == 0) {
				_uiTreeNavigation.title = "categories";
			}
			else {
				_uiTreeNavigation.title = _uiTreeNavigation.label;
			}
			
			// We maintain _path, an array of the list items pressed.
			// For example: Click "Colours", the third item, and _path[0]=2.  (Index starts at 0).
			// Then click "Red" the first item (index 0) and _path[1]=0.  So now _path = 0,2.
			if (_uiTreeNavigation.index>=0) {
				_path[_uiTreeNavigation.pageNumber-1] = _uiTreeNavigation.index;
				_path.splice(_uiTreeNavigation.pageNumber,_path.length);
			}
		}
		
		
		protected function treeComplete(event:Event):void {
			_title.text = UITreeNavigation(event.target).label;
			var info:Object = _information[_path.toString()]
			if (info) {
				// Fill in details page.
				_image.visible = true;
				_image.imageClass = info.image;
				_detail.text = info.detail;
			}
			else {
				// Clear details page.
				_image.visible = false;
				_detail.text = "";
			}
		}
		
	}
}