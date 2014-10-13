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