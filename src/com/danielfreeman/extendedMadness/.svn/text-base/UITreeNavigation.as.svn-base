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
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.danielfreeman.madcomponents.Attributes;
	import com.danielfreeman.madcomponents.UIList;
	import com.danielfreeman.madcomponents.UINavigation;
	
	
/**
 *  Tree navigation controller
 * <pre>
 * &lt;treeNavigation
 *    id = "IDENTIFIER"
 *    colour = "#rrggbb"
 *    background = "#rrggbb, #rrggbb, ..."
 *    visible = "true|false"
 *    gapV = "NUMBER"
 *    gapH = "NUMBER"
 *    alignH = "left|right|centre|fill"
 *    alignV = "top|bottom|centre|fill"
 *    rightButton = "TEXT"
 *    rightArrow = "TEXT"
 *    leftArrow = "TEXT"
 *    title = "TEXT"
 *    autoFill = "true|false"
 *    autoTitle = "TEXT"
 *    border = "true|false"
 *    mask = "true|false"
 *    backToExit = "true|false"
 * /&gt;
 * </pre>
 */	
	public class UITreeNavigation extends UINavigation {
		
		protected var _data:XML;
		protected var _treePointer:XML = null;
		protected var _treeLists:Vector.<UIList> = new Vector.<UIList>;
		protected var _erase:UIList = null;
		protected var _label:String;
		protected var _level:int = 0;
		
		
		public function UITreeNavigation(screen:Sprite, xml:XML, attributes:Attributes) {
			super(screen, xml, attributes);
			if (xml.data.length()>0 && _thisPage) {
				_thisPage.visible = false;
				_thisPage = null;
			}
			if (xml.data.length() > 0) {
				_treePointer = _data = xml.data[0];
				forwardTree(_data);
				if (_thisPage)
					_thisPage.y = _navigationBar.height;
			}
			setChildIndex(_navigationBar, numChildren-1);
		}
		
		
		override public function layout(attributes:Attributes):void {
			super.layout(attributes);
			var copyAttributes:Attributes = attributes.copy();
			copyAttributes.height-= 2*_navigationBar.height; //Why ?
			copyAttributes.y+=_navigationBar.height;
			copyAttributes.parse(_xml);
			for each (var list:UIList in _treeLists) {
				list.layout(copyAttributes);
			}
		}
		
		
		protected function forwardTree(_newPage:XML):void {
			_lastPage = _thisPage;
			_thisPage = new UIList(this, <null/>, _attributes.copy());
			UIList(_thisPage).xmlData = _newPage;
			_treeLists.push(_thisPage);
			_treePointer = _newPage;
			if (_lastPage) {
				doTransition(SLIDE_LEFT);
			}
		}
		
		
		protected function backTree(transition:String = SLIDE_RIGHT):void {
			_lastPage = _thisPage;

			if (_lastPage is UIList) {
				_erase = UIList(_lastPage);
				_treeLists.pop();
				_treePointer = _treePointer.parent();
			}
			_label = _treePointer.localName();
			_pressedCell = -1;
			
			_thisPage = _treeLists[_treeLists.length - ((_treeLists.length>0) ? 1 : 0)];
			_thisPage.visible=true;
			doTransition(transition);
		}
		
		
		override protected function removeLastPage():void {
			if (_lastPage == _erase) {
				UIList(_lastPage).destructor();
				removeChild(_lastPage);
				_erase = null;
			}
			else {
				_lastPage.visible = false;
				_lastPage = null;
			}
		}
		
		
		override protected function goForward(event:Event):void {
			if (!_slideTimer.running) {
				var children:XMLList = _treePointer.children();
				update(event);
				var newPage:XML = children[_pressedCell];
				_level++;
				if (newPage.children().length() > 0) {
					forwardTree(newPage);
					_navigationBar.backButton.visible = _treeLists.length>1;
				}
				else {
					showDetailPage();
					dispatchEvent(new Event(Event.COMPLETE));
					_navigationBar.backButton.visible = true;
				}
			}
		}


		override protected function goBack(event:MouseEvent = null):void {
			if (!_slideTimer.running) {
				_level--;
				backTree();
				_navigationBar.backButton.visible = _treeLists.length>1;
			}
		}
		
		
		protected function showDetailPage():void {
			if (_pages.length > 0) {
				_lastPage = _thisPage;
				_thisPage = _pages[0];
				_thisPage.visible=true;
				doTransition(SLIDE_LEFT);
			}
		}
			
		
		public function set xmlData(value:XML):void {
			clearTree();
			_data = value;
			forwardTree(_data);
		}
		
	
		override public function get pageNumber():int {
			return _level;
		}
		
		
		public function get treeSegment():XML {
			return _treePointer;
		}
		
		
		protected function update(event:Event):void {
			_pressedCell = UIList(event.target).index;
			var node:XML = (_treePointer.children()[_pressedCell]);
			if (node.@label.length() > 0) {
				_label = (node.@label)[0];
			}
			else {
				_label = node.localName();
			}
		}
		
		
		override public function get label():String {
			return _label;
		}
		
		
		protected function clearTree():void {
			for each (var list:UIList in _treeLists) {
				list.destructor();
				removeChild(list);
			}
		}
		
		
		public function reset():void {
			while (_treeLists.length>1)
				backTree("");
			_navigationBar.backButton.visible = false;
		}
		
		
		override public function destructor():void {
			super.destructor();
			clearTree();
		}
	}
}