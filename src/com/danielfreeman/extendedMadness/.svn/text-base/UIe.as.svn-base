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

package com.danielfreeman.extendedMadness {

	import asfiles.Cursor;
	import asfiles.HintText;
	
	import com.danielfreeman.madcomponents.*;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;


	public class UIe extends UI {

		protected static const DESKTOP_TOKENS:Array = ["tickList","tickOneList","tabPagesTop","scrollXY","scrollBarVertical","scrollBarHorizontal","scrollBarPanel","dataGrid","menu","segmentedControl","checkBox","radioButton","treeNavigation","pieChart","barChart","lineChart","scatterChart","horizontalChart","splitView","starRating","field","scrollHorizontal","listHorizontal","detailList","image9","imageX","skin","progressBar","line","icons","touch","popUpButton","slideOutNavigation","wheelMenu","pageTurn"];
		protected static const DESKTOP_CLASSES:Array = [UITickList,UITickOneList,UITabPagesTop,UIScrollXY,UIScrollBarVertical,UIScrollBarHorizontal,UIScrollBarPanel,UIDataGrid,UIMenu,UISegmentedControl,UICheckBox,UIRadioButton,UITreeNavigation,UIPieChart,UIBarChart,UILineChart,UIScatterChart,UIHorizontalChart,UISplitView,UIStarRating,UIField,UIScrollHorizontal,UIListHorizontal,UIDetailList,UIImage9,UIImageX,UISkin,UIProgressBar,UILine,UIIcons,UITouch,UIPopUpButton,UISlideOutNavigation,UIWheelMenu,UIPageTurn];
		protected static const COLOUR:uint = 0x666666;
		
		protected static var _cursor:Cursor = null;
		protected static var _skin:UISkin = null;
		protected static var _clickTimer:Timer = new Timer(90,1);
		
		public static function activate(screen:Sprite):void {
			FormClass = UIPanel;
			extend(DESKTOP_TOKENS,DESKTOP_CLASSES);
			HintText.SIZE = 30;
			Cursor.HINT_Y = 64;
			_cursor = new Cursor(screen);
			_clickTimer.addEventListener(TimerEvent.TIMER, makeVisible);
		}

/**
 * Create a UI layout in a resizable window
 */
		public static function createInWindow(screen:Sprite, xml:XML):Sprite {
			if (!_cursor)
				activate(screen);
			var result:Sprite = create(screen, xml, screen.stage.stageWidth, screen.stage.stageHeight);
			if (xml.@autoResize!="false")
				screen.stage.addEventListener(Event.RESIZE,resize);
			if (_root.mask) {
				_root.removeChild(_root.mask);
				_root.mask = null;
			}
			ready(screen);
			return result;
		}

/**
 * Create a UI layout with extended components
 */
		public static function create(screen:Sprite, xml:XML, width:Number = -1, height:Number = -1):Sprite {
			if (!_cursor)
				activate(screen);
			var result:Sprite = UI.create(screen, xml, width, height);
			listListener(result, xml);
			ready(screen);
			return result;
		}

/**
 * Create a pop-up dialogue window
 */	
		public static function ready(screen:Sprite):void {
			screen.setChildIndex(_cursor,screen.numChildren-1);
		}

/**
 * Create a pop-up dialogue window
 */	
		public static function showCallOut(xml:XML, x:Number, y:Number):DisplayObject {
			var result:DisplayObject;
			var arrowPosition:Number = xml.@arrowPosition.length()>0 ? parseFloat(xml.@arrowPosition) : 0;
			if (xml.localName() == "data") {
				var words:Vector.<String> = new <String>[];
				for each (var word:XML in xml.children()) {
					words.push(word.@value.length() > 0 ? word.@value : word.localName());
				}
				var colour:uint = xml.backgroundColours.length>0 ? parseFloat(xml.backgroundColours[0]) : COLOUR;
				result = new UICutCopyPaste(_windowLayer, x-Math.abs(arrowPosition), y + (arrowPosition==0 ? 0 : UICutCopyPaste.ARROW), arrowPosition, colour, xml.@alt=="true", words);
				if (arrowPosition>0)
					result.y -= result.height + UICutCopyPaste.ARROW;
			}
			else {
				var attributes:Attributes = new Attributes();
				attributes.parse(xml);
				result = new UIDropWindow(_windowLayer, xml, attributes);
				result.x = x-arrowPosition - (arrowPosition==0 ? UIDropWindow.ARROW : 0) + UIDropWindow.CURVE;
				result.y = y + UIDropWindow.ARROW + UIDropWindow.CURVE;
				
			}
			return result;
		}
		
		
		public static function listListener(screen:DisplayObject, xml:XML):void {
			if (screen is UIList && UIList(screen).rendererXML && UIList(screen).rendererXML.skin.length()>0) {
				screen.addEventListener(UIList.CLICKED, listChanged, false, 0, true);
			}
		}
		
		
		protected static function listChanged(event:Event):void {
			if (_skin) {
				_skin.visible = true;
				_clickTimer.stop();
				_skin = null;
			}
			var panel:UIPanel = UIPanel(UIList(event.target).rowContainer);
			var skin:DisplayObject = panel.getChildAt(1);
			if (skin is UISkin) {
				_skin = UISkin(skin);
			}
			else {
				skin = panel.getChildAt(0);
				if (skin is UISkin) {
					_skin = UISkin(skin);
				}
			}
			if (_skin) {
				_skin.visible = false;
				_clickTimer.reset();
				_clickTimer.start();
			}
		}
		
		
		protected static function makeVisible(event:TimerEvent):void {
			_skin.visible = true;
			_skin = null;
		}

	}
}
