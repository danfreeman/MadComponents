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

package com.danielfreeman.madcomponents {

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
		
/**
 * A page has changed
 */
	[Event( name="change", type="flash.events.Event" )]

	
/**
 * A page transition has completed
 */
	[Event( name="changeComplete", type="flash.events.Event" )]

	
/**
 *  MadComponents pages container
 * <pre>
 * &lt;pages
 *    id = "IDENTIFIER"
 *    colour = "#rrggbb"
 *    background = "#rrggbb, #rrggbb, ..."
 *    visible = "true|false"
 *    gapV = "NUMBER"
 *    gapH = "NUMBER"
 *    width = "NUMBER"
 *    height = "NUMBER"
 *    alignH = "left|right|centre|fill"
 *    alignV = "top|bottom|centre|fill"
 *    border = "true|false"
 *    mask = "true|false"
 *    lazyRender = "true|false"
 *    recycle = "true|false"
 *    easeIn = "NUMBER"
 *    easeOut = "NUMBER"
 *    slideOver = "true|false"
 * /&gt;
 * </pre>
 */
	public class UIPages extends MadMasking implements IContainerUI {
	
		public static const STARTING:String = "changeStarting";  
		public static const COMPLETE:String = "changeComplete";
		
		public static const SLIDE_LEFT:String = "left";
		public static const SLIDE_RIGHT:String = "right";
		public static const SLIDE_UP:String = "up";
		public static const SLIDE_DOWN:String = "down";
		public static const DRAWER_UP:String = "drawerUp";
		public static const DRAWER_DOWN:String = "drawerDown";
		public static const SLIDE_LEFT_OVER:String = "leftOver";
		public static const SLIDE_RIGHT_OVER:String = "rightOver";
		
		public static var DRAWER_HEIGHT:Number = 220;
		public static var SLIDE_INTERVAL:int = 40;
		public static var STEPS:int = 4;
		
		protected static const PADDING:Number = 10.0;
		protected static const DIM_ALPHA:Number = 0.4;
		protected static const UNDER:Number = 0.2;

		protected var _pages:Array = [];
		protected var _page:int = 0;
		protected var _thisPage:DisplayObject = null;
		protected var _lastPage:DisplayObject;
		protected var _slideX:Number = 0;
		protected var _slideY:Number = 0;
		protected var _slideTimer:Timer = new Timer(SLIDE_INTERVAL, STEPS);
		
	//	protected var _xml:XML;
	//	protected var _attributes:Attributes;
		protected var _drawer:UIForm;
		protected var _transition:String;
		protected var _lastPageIndex:int;
		protected var _border:Boolean = true;
		protected var _layoutAfterSlide:Attributes = null;
		protected var _easing:Boolean = false;
		protected var _easeIn:Number = 0.5;
		protected var _easeOut:Number = 0.5;
		protected var _shade:Shape = new Shape();
		protected var _savePageIndex:int;
		protected var _drawerHeight:Number = DRAWER_HEIGHT;
		protected var _over:Boolean;
		protected var _slideOver:Boolean = false;
		
		
		public function UIPages(screen:Sprite, xml:XML, attributes:Attributes) {
			
		//	_xml = xml;
			super(null, xml, attributes);
			_attributes = attributes.copy(xml);
			
			UI.drawBackgroundColour(_attributes.backgroundColours, _attributes.width, _attributes.y + _attributes.height, this);
			_attributes.x=0;_attributes.y=0;

			_easing = xml.@easing == "true";
			if (xml.@easeIn.length()>0) {
				_easeIn = parseFloat(xml.@easeIn);
			}
			if (xml.@easeOut.length()>0) {
				_easeOut = parseFloat(xml.@easeOut);
			}
			_slideOver = xml.@slideOver == "true";
			
			screen.addChildAt(this,0);
			var children:XMLList = xml.children();
			var index:int = 0;
			for each (var child0:XML in children) if (child0.nodeKind() != "text" && child0.localName()!="data") {
				var childstr:String = child0.toXMLString();
				var child:XML = XML('<page lazyRender="'+(xml.@lazyRender)+'" recycle="'+(xml.@recycle)+'">'+childstr+'</page>');
				var newAttributes:Attributes = childAttributes(index++);
				newAttributes.parse(child0);
				if (child0.@border!="false") {
					addPadding(child0.localName(), newAttributes);
				}
				var page:* = new UI.FormClass(this, child, newAttributes);
				_attributes.position(page);
				page.name = "+";
			//	page.visible = false;
				setVisible(page, false);
				_pages.push(page);
			}
			setInitialPage();
			_slideTimer.addEventListener(TimerEvent.TIMER, slide);
			
		//	if (xml.@mask.length()>0 && xml.@mask[0]!="false")
		//		scrollRect = new Rectangle(0,0,_attributes.width, _attributes.height);	
			
			startMasking();
			drawShade();
		}
		
		
		protected function childAttributes(index:int):Attributes {
			return _attributes.copy();
		}
		
		
		public function setVisible(page:DisplayObject, value:Boolean):void {
			if (page is MadSprite) {
				MadSprite(page).isVisible = value;
			}
			else {
				page.visible = value;
			}
		}
		
/**
 *  Set the height of the sliding drawer
 */
		public function set drawerHeight(value:Number):void {
			if (_shade.parent) {
				_thisPage.y = _attributes.height  + _attributes.y - value;
			}
			_drawerHeight = value;
			drawShade();
		}
		
		
		protected function setInitialPage():void {
			if (_pages.length>0) {
				_thisPage = _pages[0];
				_page = 0;
			//	_thisPage.visible = true;
				setVisible(_thisPage, true);
			}
		}
		
/**
 *  An array of pages inside this container
 */
		public function get pages():Array {
			return _pages;
		}
		
		
		public function get xml():XML {
			return _xml;
		}
		
/**
 *  Rearrange the layout to new screen dimensions
 */	
		override public function layout(attributes:Attributes):void {
			if (_slideTimer.running) {
				_layoutAfterSlide = attributes;
				return;
			}
			var children:XMLList = _xml.children();
			super.layout(attributes.copy(_xml));
			UI.drawBackgroundColour(_attributes.backgroundColours, _attributes.width, _attributes.y + _attributes.height, this);
			_attributes.x=0;_attributes.y=0;
			for (var i:int = 0; i < children.length(); i++) {
				var childXML:XML = children[i];
				if (childXML.localName()!="data" && childXML.nodeKind() != "text") {
				//	var child:XML = XML("<page>"+childXML.toXMLString()+"</page>");
					var newAttributes:Attributes = childAttributes(i);
					newAttributes.parse(childXML);
					if (childXML.@border!="false") {
						addPadding(childXML.localName(), newAttributes);
					}
					var page:IContainerUI = _pages[i];
					page.layout(newAttributes);
					
					if (page == _drawer) {
						_drawer.y = _attributes.height  + _attributes.y - _drawerHeight;
					}
					else {
						_attributes.position(DisplayObject(page));
					}
				}
			}
		//	if (scrollRect)
		//		scrollRect = new Rectangle(0,0,attributes.width,attributes.height);
		
			refreshMasking();
			drawShade();
		}
		
/**
 *  Add border padding around a page
 */	
		protected function addPadding(localName:String,newAttributes:Attributes):void {
			if (localName.toLowerCase().indexOf("pages")<0 && localName.toLowerCase().indexOf("list")<0 && localName.toLowerCase().indexOf("navigation")<0 && localName.toLowerCase().indexOf("scroll")<0 && localName!="viewFlipper" && localName!="frame") {
				newAttributes.x+=PADDING;
				newAttributes.y+=PADDING;
				newAttributes.width-=2*PADDING;
				newAttributes.height-=2*PADDING;
				newAttributes.hasBorder=true;
			}
		}
		
/**
 *  Go to next page
 */	
		public function nextPage(transition:String=""):void {
			if (!_slideTimer.running && !_lastPage && _page < _pages.length-1) {
				_lastPageIndex = _page;
				_lastPage = _pages[_page];
				_page++;
				_thisPage = _pages[_page];
			//	_thisPage.visible = true;
				setVisible(_thisPage, true);
				doTransition(transition);
			}
		}
		
/**
 *  Go to previous page
 */	
		public function previousPage(transition:String=""):void {
			if (!_slideTimer.running && !_lastPage && _page > 0) {
				_lastPageIndex = _page;
				_lastPage = _pages[_page];
				_page--;
				_thisPage = _pages[_page];
			//	_thisPage.visible = true;
				setVisible(_thisPage, true);
				doTransition(transition);
			}
		}
		
/**
 *  Attach new pages to this container
 */	
		public function attachPages(pages:Array, alt:Boolean = false):void {
			_pages = pages;
			for (var i:int = 1; i<pages.length; i++) {
				setVisible(pages[i], false);
			}
		}
		
/**
 *  Page transition
 */	
		protected function doTransition(transition:String):void {
			stage.dispatchEvent(new Event(STARTING));
			_transition = transition;
			_thisPage.x = _attributes.x;
			_thisPage.y = _attributes.y;
			_over = _slideOver;
			switch (transition) {
				case SLIDE_LEFT_OVER:	_over = true;
				case SLIDE_LEFT:	_thisPage.x = _attributes.width + _attributes.x;
									startSlide();
									break;
				case SLIDE_RIGHT_OVER:	_over = true;
				case SLIDE_RIGHT:	_thisPage.x = - (_over ? UNDER : 1.0) * _attributes.width + _attributes.x;
									startSlide();
									break;
				case SLIDE_UP:		_thisPage.y = _attributes.height + _attributes.y;
									startSlide();
									break;
				case SLIDE_DOWN:	startSlide((_attributes.height + _attributes.y)/STEPS);
									break;
				case DRAWER_UP:		_drawer = UIForm(_thisPage);
									_thisPage.y = _attributes.height  + _attributes.y;
									startSlide(-_drawerHeight/STEPS);
									break;
				case DRAWER_DOWN:	_thisPage.y = _attributes.height  + _attributes.y - _drawerHeight;
									if (_shade.parent) {
										_shade.parent.removeChild(_shade);
									}
									startSlide((_attributes.height + _attributes.y)/STEPS);
									_drawer = null;
									break;
				default:		//	_lastPage.visible = false;
									setVisible(_lastPage, false);
									_lastPage = null;
									dispatchEvent(new Event(Event.CHANGE));
									dispatchEvent(new Event(COMPLETE));
			}
		}
		
/**
 *  Create a translucent shade for sliding drawer
 */	
		protected function drawShade():void {
			_shade.graphics.clear();
			_shade.graphics.beginFill(0x000000,DIM_ALPHA);
			var height:Number = _attributes.height - _drawerHeight;
			_shade.graphics.drawRect(0, -height, _attributes.width, height);
			_shade.graphics.beginFill(0x000000);
			_shade.graphics.drawRect(0, -4, _attributes.width, 4);
		}
		
/**
 *  Start slide transition
 */	
		protected function startSlide(slideY:Number = 0):void {
		//	_thisPage.cacheAsBitmap=true;
		//	_lastPage.cacheAsBitmap=true;
			_slideX = (_attributes.x - _thisPage.x)/STEPS;
			_slideY = (slideY==0) ? (_attributes.y - _thisPage.y)/STEPS : slideY;
			
			_slideTimer.reset();
			_slideTimer.start();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
/**
 *  Is this a simple transition, left right, or change
 */	
		protected function isSimpleTransition(transition:String):Boolean {
			return transition=="" || transition==SLIDE_LEFT || transition==SLIDE_RIGHT || transition==SLIDE_LEFT_OVER || transition==SLIDE_RIGHT_OVER;
		}
		
		
		protected function upTransition(transition:String):Boolean {
			return transition==SLIDE_UP || transition==DRAWER_UP;
		}
		
		
		protected function downTransition(transition:String):Boolean {
			return transition==SLIDE_DOWN || transition==DRAWER_DOWN;
		}
		
		
		protected function bezier(p0:Number,p1:Number,p2:Number,t:Number):Number {
			return t*t*p0+2*t*(1-t)*p1+(1-t)*(1-t)*p2;
		}
		
		
		protected function easing(t:Number):Number {
			if (t<0.5)
				return bezier(0.0, -_easeIn/2+0.25, 0.5, (1-t*2));
			else
				return bezier(0.5, _easeOut/2+0.75, 1.0, (1-t)*2);
		}
		
		
		protected function delta(t:Number, increment:Number):Number {
			if (_easing) {
				return t==0 ? 0 : increment*STEPS*(easing(t) - easing(t-1/STEPS));
			}
			else {
				return increment;
			}
		}
		
		
		protected function slideComplete():void {
			_slideTimer.stop();
		//	_thisPage.cacheAsBitmap=false;
			if (_transition == SLIDE_DOWN || _transition == DRAWER_DOWN) {
			//	_thisPage.visible = false;
				setVisible(_thisPage, false);
			}
			else if (_transition != SLIDE_UP && _transition != DRAWER_UP) {
				removeLastPage();
				_thisPage.x = 0;
			}
			
			if (upTransition(_transition)) {
				_savePageIndex = _lastPageIndex;
			}
			else if (downTransition(_transition)) {
				_page = _savePageIndex;
			}
			else if (!isSimpleTransition(_transition)) {
				_page = _lastPageIndex;
			}
			
			if (_layoutAfterSlide) {
				layout(_layoutAfterSlide);
				_layoutAfterSlide = null;
			}
			if (_transition == DRAWER_UP) {
				Sprite(_thisPage).addChild(_shade);
			}
			dispatchEvent(new Event(COMPLETE));
		}
		
/**
 *  Animate slide transition
 */	
		protected function slide(event:TimerEvent):void {
			var t:Number = Timer(event.currentTarget).currentCount/STEPS;
			_lastPage.x += ((_over && _slideX < 0) ? UNDER : ((_over && _slideX > 0) ? 1/UNDER : 1.0)) * delta(t, _slideX);
			_thisPage.x += delta(t, _slideX);
			_thisPage.y += delta(t, _slideY);
			if (Timer(event.currentTarget).currentCount == STEPS) {
				slideComplete();
			}
		}
		
		
		public function doLayout():void {
			layout(attributes);
		}
		
/**
 *  Make the previous page invisible
 */	
		protected function removeLastPage():void {
		//	_lastPage.visible = false;
			setVisible(_lastPage, false);
			_lastPage = null;
		}
		
/**
 *  Change page
 */	
		public function goToPage(page:int, transition:String = ""):void {
			if (_slideTimer.running) return;
			_lastPageIndex = _page;
			if (page == _page && isSimpleTransition(transition)) return;
			_lastPage = _pages[_page];
			_page = page;
			_thisPage = _pages[_page];
		//	_thisPage.visible = true;
			setVisible(_thisPage, true);
			doTransition(transition);
		}
		
/**
 *  Change page.  (Specify page with id name).
 */	
		public function goToPageId(id:String, transition:String = ""):Boolean {
			for (var i:int = 0; i < _pages.length; i++) {
				if (Sprite(_pages[i]).getChildAt(0).name == id) {
					goToPage(i, transition);
					return true;
				}
			}
			return false;
		}
		
		
		public function pageId(id:String):DisplayObject {
			for (var i:int = 0; i < _pages.length; i++) {
				if (Sprite(_pages[i]).getChildAt(0).name == id) {
					return Sprite(_pages[i]).getChildAt(0);
				}
			}
			return null;
		}
		
/**
 *  Page number
 */	
		public function get pageNumber():int {
			return _page;
		}
		
		
		public function set pageNumber(value:int):void {
			goToPage(value);
		}
		
		
		public function get pageUnder():int {
			return _savePageIndex;
		}
		
/**
 *  Clear pages
 */	
		public function clear():void {
			for each (var view:IContainerUI in _pages)
				view.clear();
		}
		
/**
 *  Search for component by id
 */
		public function findViewById(id:String, row:int = -1, group:int = -1):DisplayObject {
			for each (var view:DisplayObject in _pages) {
				if (view.name == id) {
					return view;
				}
				else {
					if (view is IContainerUI) {
						var result:DisplayObject = IContainerUI(view).findViewById(id, row, group);
						if (result)
							return result;
					}
				}
			}
			return null;
		}
		
		
		public function drawComponent():void {	
		//	graphics.clear(); ?
		}
		
		
		override public function destructor():void {
			super.destructor();
			_slideTimer.removeEventListener(TimerEvent.TIMER,slide);
			for each (var view:IContainerUI in _pages)
				view.destructor();
		}
		
	}
}
