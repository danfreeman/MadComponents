package com.danielfreeman.extendedMadness {

	import flash.system.Capabilities;
	import com.danielfreeman.madcomponents.*;

	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.Event;

/**
 * Screen has changed
 */
		[Event( name="screenChanged", type="flash.events.Event" )]
		
		
	public class UIScreens extends UIPages {
		
		public static const SCREEN_CHANGED:String = "screenChanged";
		
		public function UIScreens(screen : Sprite, xml : XML, attributes : Attributes) {
		//	attributes.parse(xml);
			super(screen, xml, attributes);
		}
	
	
		protected function useThisOne(size:String):Boolean {
			var result:Boolean = true;
			if (size.substr(-3,3).toUpperCase() == "DPI") {
				return parseFloat(size.substr(0,-3)) >= Capabilities.screenDPI;
			}
			if (size.substr(-1,1).toUpperCase() == "C") {
				size = size.substr(0,-1);
			}
			if (size.substr(0,1).toUpperCase() == "L") {
				result = UI.attributes.width >= UI.attributes.height;
				size = size.substr(1);
			}
			else if (size.substr(0,1).toUpperCase() == "P") {
				result = UI.attributes.width <= UI.attributes.height;
				size = size.substr(1);
			}
			if (size.length > 0) {
				var xPosition:int = Math.max(size.indexOf("X"), size.indexOf("x"));
				if (xPosition > 0) {
					result = result && (UI.attributes.width >= parseInt(size.substring(0, xPosition))) && (UI.attributes.height >= parseInt(size.substring(xPosition + 1)));
				}
				else {
					result = result && (UI.attributes.width >= parseInt(size));
				}
			}
			return result;
		}
		
		
		protected function whichScreenIndex():int {
			var result:int = 0;
			var index:int = 0;
			for each(var child:XML in _xml.children()) {
				if (useThisOne(String(child.@size).toUpperCase())) {
					result = index;
				}
				index++;
			}
			return result;
		}
		
		
		override protected function setInitialPage():void {
			if (_pages.length>0) {
				var index:int = whichScreenIndex();
				_thisPage = _pages[index];
				_page = index;
				_thisPage.visible = true;
			}
		}
		
/**
 *  Search for component by id
 */
		override public function findViewById(id:String, row:int = -1, group:int = -1):DisplayObject {
			for each (var view:DisplayObject in _pages) {
				if (view.name == id) {
					return view;
				}
			}
			return IContainerUI(_thisPage).findViewById(id, row, group);
		}
		
		
		override public function touchCancel():void {
			if (_thisPage is Sprite && Sprite(_thisPage).getChildAt(0) is MadSprite) {
				MadSprite(Sprite(_thisPage).getChildAt(0)).touchCancel();
			}
		}
				
/**
 *  Rearrange the layout to new screen dimensions
 */	
		override public function layout(attributes:Attributes):void {
			var newPageIndex:int = whichScreenIndex();
			if (_page != newPageIndex) {
				_thisPage.visible = false;
				_thisPage = _pages[newPageIndex];
				_thisPage.visible = true;
				_page = newPageIndex;
				dispatchEvent(new Event(SCREEN_CHANGED));
			}
			super.layout(attributes);
		}
	}
}
