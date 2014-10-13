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
 
 
package com.danielfreeman.extendedMadness
{
	import flash.events.Event;
	import flash.display.GradientType;
	import com.danielfreeman.madcomponents.UIPages;
	import com.danielfreeman.madcomponents.Attributes;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.utils.Timer;
		
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;

 /**
  * Page curl started
  */
	[Event( name="pageTurnCurl", type="flash.events.Event" )]
	
	
 /**
  * Animated page turn started
  */
	[Event( name="pageTurnStart", type="flash.events.Event" )]	
	
	
 /**
  * Animated page turn complete
  */
	[Event( name="pageTurnComplete", type="flash.events.Event" )]
	
	
	public class UIPageTurn extends UIPages
	{
		public static const PAGE_TURN:String="pageTurn";
		
		public static const PAGE_TURN_CURL:String="pageTurnCurl";
		public static const PAGE_TURN_START:String="pageTurnStart";
		public static const PAGE_TURN_COMPLETE:String="pageTurnComplete";
					
		public static const TOP_LEFT:String="topLeft";
		public static const TOP_RIGHT:String="topRight";
		public static const BOTTOM_LEFT:String="bottomLeft";
		public static const BOTTOM_RIGHT:String="bottomRight";
		
		protected static const RADIANS_TO_DEGREES:Number = 180/Math.PI;
		
		protected static const CURL_K:Number = 32.0;
		protected static const CURL_Y:Number = 1.0;
		
		protected static const METHOD_0:Number = 160.0;
		protected static const METHOD_0A:Number = 180.0;
		protected static const METHOD_1:Number = 200.0;
		protected static const METHOD_1A:Number = 230;
		protected static const METHOD_2:Number = 400.0;
		protected static const METHOD_2A:Number = 440.0;
		protected static const METHOD_3:Number = 480.0;
		protected static const MAX:Number = 640;
		protected static const ADJUST:Number = 16.0;
		protected static const CURL:Number = 0.1;
		
		protected static const SHADOW:Number = 16.0;
		protected static const SHADOW_ALPHA:Number = 0.6;
		protected static const TURN_ZONE:Number = 32;
		
		protected static const INITIAL_DIST:Number = 32;
		protected static const CHANGE_DIST:Number = 8;
		protected static const HOTSPOT_SIZE:Number=200.0;
		
		protected static const STEP_SIZE:Number=20;
		protected static const INITIAL_SIZE:Number=20;
		protected static const STEPS:int=30;
		
		protected static const SPREAD:Number = 80.0;
		

		protected var _method:Vector.<Number> = new <Number>[METHOD_0, METHOD_0A, METHOD_1, METHOD_1A, METHOD_2, METHOD_2A, METHOD_3];
		protected var _mode:String=TOP_RIGHT;
		protected var _size:Number=INITIAL_DIST;
		
		protected var _pageIndex:int = 0;
		protected var _mask0:Sprite = new Sprite();
		protected var _mask1:Sprite = new Sprite();
		protected var _mask2:Sprite = new Sprite();
		protected var _pageSprites0:Vector.<Bitmap>;
		protected var _pageSprites1:Vector.<Sprite>;
		protected var _thisTurnPage:Bitmap;
		protected var _nextTurnPage:Bitmap;
		protected var _curl:Sprite;
		protected var _nextIndex:int = 1;
		protected var _flipPage:Sprite = null;
		protected var _shadow:Sprite;
		protected var _lastDist:Number=99999;
		protected var _cRatio:Number = 0.0;
		protected var _swish:Sound = null;
		protected var _timer:Timer=new Timer(10);
		protected var _sensor:Sprite;
		protected var _corner:Point;
		protected var _enableForward:Boolean=true;
		protected var _enableBack:Boolean=true;
		protected var _forward:Boolean;
		
		protected var _pageTurnLayer0:Sprite;
		protected var _pageTurnLayer1:Sprite;
		protected var _factor:Number = 0;
		protected var _alwaysUpdate:Boolean = true;
		
		
		public function UIPageTurn(screen:Sprite, xml:XML, attributes:Attributes)
		{
			super(screen, xml, attributes);
			_timer.addEventListener(TimerEvent.TIMER,animate);

			addChild(_pageTurnLayer0 = new Sprite());
			_pageTurnLayer0.visible = false;
			
			addChild(_shadow = new Sprite());
			_shadow.mouseEnabled = false;
			
			addChild(_pageTurnLayer1 = new Sprite());
			_pageTurnLayer1.visible = false;

			_mask0.mouseEnabled = _mask1.mouseEnabled = _mask2.mouseEnabled = false;
			_mask0.visible = _mask1.visible = _mask2.visible = false;
			initialiseMasks();
			
			addChild(_curl = new Sprite());
			_curl.mouseEnabled = false;
			
			addChild(_sensor=new Sprite());
			makeHotSpots();
			
			if (xml.@rollOver != "false") {
				_sensor.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
				_sensor.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			}
			
			_sensor.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			_sensor.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			
			if (xml.@sound.length() > 0) {
				_swish = new Sound();
				_swish.load(new URLRequest(xml.@sound));
			}
			layout(attributes);
		}
		
/**
 *  Go to next page.  nextPage(UIPageTurn.PAGE_TURN);  employs the page turn transition
 */
		override public function nextPage(transition:String=""):void {
			if (transition == PAGE_TURN) {
				_mode = TOP_RIGHT;
				_corner = new Point(_attributes.widthH, 0);
				setPages(true);
				_sensor.mouseEnabled = false;
				pageTurn(0);
			}
			else {
				super.nextPage(transition);
			}
		}
		
/**
 *  Go to previous page.  previousPage(UIPageTurn.PAGE_TURN);  employs the page turn transition
 */
		override public function previousPage(transition:String=""):void {
			if (transition == PAGE_TURN) {
				_mode = TOP_LEFT;
				_corner = new Point(0, 0);
				setPages(false);
				_sensor.mouseEnabled = false;
				pageTurn(0);
			}
			else {
				super.nextPage(transition);
			}
		}
		
		
		public function set alwaysUpdate(value:Boolean):void {
			_alwaysUpdate = value;
		}
		
		
		public function get alwaysUpdate():Boolean {
			return _alwaysUpdate;
		}
		
		
		protected function removePageSprites():void {
			
			for each (var page0:Bitmap in _pageSprites0) {
				_pageTurnLayer0.removeChild(page0);
			}
			for each (var page1:Sprite in _pageSprites1) {
				_pageTurnLayer1.removeChild(page1);
			}
			_pageSprites0 = new Vector.<Bitmap>();
			_pageSprites1 = new Vector.<Sprite>();
		}


		override public function layout(attributes:Attributes):void {
			removePageSprites();
			_factor = Math.min(1.0, attributes.widthH / 1024);
			_method = new <Number>[_factor*METHOD_0, _factor*METHOD_0A, _factor*METHOD_1, _factor*METHOD_1A, _factor*METHOD_2, _factor*METHOD_2A, _factor*METHOD_3];
			super.layout(attributes);
			initialise();
			makeHotSpots();
		}


		protected function drawEdge(sizeX:Number):void
		{
			var midPoint:Number = ((_attributes.widthH > _attributes.heightV) ? 0.5 : 1.0) * _attributes.widthH;
			var mat:Matrix=new Matrix();
			var sizeY:Number = sizeX;
			if (sizeY < 0 || !_flipPage) return;
			_curl.graphics.clear();
			var extra:Number = 0;
			var angle:Number = Math.atan2(3/4, 1);
			var gradientX:Number;
			if (_mode==BOTTOM_LEFT || _mode==TOP_RIGHT) angle=-angle;
			
			if (_mode==TOP_LEFT) gradientX=sizeX/8;
			else if (_mode==TOP_RIGHT) gradientX=_attributes.widthH-sizeX-sizeX/8;
			else if (_mode==BOTTOM_LEFT) gradientX=sizeX-sizeX/8;
			else gradientX=_attributes.widthH-15/8*sizeX;
			
			var bbA:Point;
			var bbB:Point;
			var bbC:Point;
			var bbD:Point;
			var bbE:Point;
			var bbF:Point;
			var bbG:Point;
			
			var aRatio:Number = 1.0;
			var bRatio:Number = 0.0;
			_cRatio = 0.0;
			var gradient:Number;
			
			_flipPage.rotation = 0;
			
			var alphas:Array = [0.0, 1.0, 1.0, 1.0, 0.0];
			var colours:Array = [0x000000, 0xcccccc, 0xffffff, 0xeeeeee, 0x000000];
			if (sizeX < _method[0]) {
				aRatio = 1.0;
				bRatio = 0.0;
				_cRatio = 0.0;
				gradient = 1.0;
				_flipPage.scaleY = 1.0;
				alphas = [0.0, 1.0, 1.0, 1.0, 0.0];
			}
			else if (sizeX > _method[4]) {
				aRatio = 0;
				_cRatio = Math.min(1.0,(sizeX-_method[4])/(midPoint-_method[4]));
				bRatio = 1 - _cRatio;
				gradient = 2+8*(sizeX-_method[2])/(midPoint-_method[2]);
				if (sizeX > _method[5]) {
					_flipPage.scaleY = 1.05-0.05*Math.min(1.0,(sizeX-_method[5])/(midPoint-_method[5]));
				}
				else {
					_flipPage.scaleY = _flipPage.scaleY = 1.06-0.01*Math.min(1.0,(sizeX-_method[4])/(_method[5]-_method[4]));
				}
				colours = [0x000000, 0xFFFFFF, 0x999999, 0xFFFFFF, 0x000000];
				var fac:Number = (sizeX < _method[6]) ? 1.0 : Math.max(1.0 - (sizeX-_method[6])/100, 0.0);
				alphas = [0.0, fac*0.8, fac*1.0, fac*0.8, 0.0];
			}
			else if (sizeX > _method[2]) {
				aRatio = 0.0;
				bRatio = 1.0;
				_cRatio = 0.0;
				gradient = 2+8*(sizeX-_method[2])/(midPoint-_method[2]);
				if (sizeX > _method[3]) {
					_flipPage.scaleY = 1.10-0.04*Math.min(1.0,(sizeX-_method[3])/(_method[4]-_method[3]));
				}
				else {
					_flipPage.scaleY = _flipPage.scaleY = 1.0+0.10*Math.min(1.0,(sizeX-_method[2])/(_method[3]-_method[2]));
				}
				alphas = [0.0, 0.5, 1.0, 0.5, 0.0];
			}
			else {
				bRatio = Math.min(1.0,(sizeX - _method[0])/(_method[2]-_method[0]));
				aRatio = 1.0 - bRatio;
				_cRatio = 0.0;
				gradient = 2.0;
				_flipPage.scaleY = 1.0;
				alphas = [0.0, 1.0, 1.0, 1.0, 0.0];
			}
			
			var theta:Number = Math.atan2(sizeX,sizeX/gradient);
			bbA = new Point(fnX(sizeX),fnY(0));
			bbB = new Point(fnX(sizeX),fnY(CURL_Y*sizeX*Math.cos(theta)));
			bbC = new Point(fnX(sizeX+sizeX*Math.sin(theta)-ADJUST),fnY(sizeX*Math.cos(theta)+ADJUST));
			
			if (sizeX*gradient > _attributes.heightV) {
				var l:Number = sizeX -  _attributes.heightV/gradient;
				bbD=new Point(fnX((l+l*Math.sin(theta)+sizeX+sizeX*Math.sin(theta))/2-CURL_K),fnY((_attributes.heightV+l*Math.cos(theta)+sizeX*Math.cos(theta))/2-CURL_K));
				bbE=new Point(fnX(l+l*Math.sin(theta)),fnY(_attributes.heightV+l*Math.cos(theta)));
				
				bbF = new Point(fnX(l),fnY(_attributes.heightV+CURL_Y*l*Math.cos(theta)));
				bbG = new Point(fnX(l),fnY(_attributes.heightV));
			}
			else {
				bbD=new Point(fnX((sizeX+sizeX*Math.sin(theta))/2-CURL_K),fnY((sizeX*gradient+sizeX*Math.cos(theta))/2-CURL_K));
				bbE=new Point(fnX(0),fnY(sizeX*gradient));
				bbF = new Point(0,0);
				bbG = new Point(0,0);
			}
			
			mat.createGradientBox(sizeX,sizeY*aRatio+sizeX*gradient*bRatio,angle,gradientX,fnY(0));//size/2,size/2);
			_curl.graphics.beginGradientFill(GradientType.LINEAR, colours, alphas, [0x00,0x70,0x80,0x88,0xff], mat);
			var aaA:Point = new Point(fnX(sizeX), fnY(0));
			var aaB:Point = new Point(fnX(sizeX-1.5*CURL*sizeX), fnY(sizeY/3));
			var aaC:Point = new Point(fnX(sizeX-0.5*CURL*sizeX), fnY(sizeY-0.5*CURL*sizeY));
			var aaD:Point = new Point(fnX(sizeX/4), fnY(sizeY-2*CURL*sizeY));
			var aaE:Point = new Point(fnX(0), fnY(sizeY));
			
			var ccA:Point = new Point(fnX(midPoint), fnY(0));
			var ccB:Point = new Point(fnX(6*midPoint/4), fnY(0));
			var ccC:Point = new Point(fnX(_attributes.widthH), fnY(0));
			var ccD:Point = new Point(fnX(_attributes.widthH), fnY(_attributes.heightV/2));
			var ccE:Point = new Point(fnX(_attributes.widthH), fnY(_attributes.heightV));
			var adjust:Number = ((sizeX<midPoint) ? midPoint - sizeX : 0);
			var ccF:Point = new Point(fnX(midPoint-adjust), fnY(_attributes.heightV+adjust));
			var ccG:Point = new Point(fnX(midPoint), fnY(_attributes.heightV));
			
			var cornerA:Point = new Point(aRatio*aaA.x+bRatio*bbA.x+_cRatio*ccA.x,aRatio*aaA.y+bRatio*bbA.y+_cRatio*ccA.y);
			var cornerB:Point = new Point(aRatio*aaB.x+bRatio*bbB.x+_cRatio*ccB.x,aRatio*aaB.y+bRatio*bbB.y+_cRatio*ccB.y);
			var cornerC:Point = new Point(aRatio*aaC.x+bRatio*bbC.x+_cRatio*ccC.x,aRatio*aaC.y+bRatio*bbC.y+_cRatio*ccC.y);
			var cornerD:Point = new Point(aRatio*aaD.x+bRatio*bbD.x+_cRatio*ccD.x,aRatio*aaD.y+bRatio*bbD.y+_cRatio*ccD.y);
			var cornerE:Point = new Point(aRatio*aaE.x+bRatio*bbE.x+_cRatio*ccE.x,aRatio*aaE.y+bRatio*bbE.y+_cRatio*ccE.y);
			var cornerF:Point = new Point(bRatio*bbF.x+_cRatio*ccF.x,bRatio*bbF.y+_cRatio*ccF.y);
			var cornerG:Point = new Point(bRatio*bbG.x+_cRatio*ccG.x,bRatio*bbG.y+_cRatio*ccG.y);

			_curl.graphics.moveTo(cornerA.x,cornerA.y);
			_curl.graphics.curveTo(cornerB.x,cornerB.y,cornerC.x,cornerC.y);
			_curl.graphics.curveTo(cornerD.x,cornerD.y,cornerE.x,cornerE.y);
			if (cornerE.y > _attributes.heightV || cornerE.y < 0 || sizeX > _method[4]) {
				_curl.graphics.curveTo(cornerF.x, cornerF.y, cornerG.x, cornerG.y);
			}
			_curl.graphics.lineTo(cornerA.x, cornerA.y);
			_curl.graphics.endFill();
			
			_mask2.graphics.clear();
			_mask2.graphics.beginFill(0xffff00);
			_mask2.graphics.moveTo(cornerA.x,cornerA.y);
			_mask2.graphics.curveTo(cornerB.x,cornerB.y,cornerC.x,cornerC.y);
			_mask2.graphics.curveTo(cornerD.x,cornerD.y,cornerE.x,cornerE.y);
			var fAndG:Boolean = cornerE.y > _attributes.heightV || cornerE.y < 0 || sizeX > _method[4];
			if (fAndG) {
				_mask2.graphics.curveTo(cornerF.x, cornerF.y, cornerG.x, cornerG.y);
			}
			_mask2.graphics.lineTo(cornerA.x, cornerA.y);
			_mask2.graphics.endFill();

			var offset:Number = _forward ? SPREAD : -SPREAD;
			var endPoint:Point = fAndG ? cornerG : cornerE;
			angle = Math.PI/2 - Math.atan2(endPoint.y - cornerA.y, endPoint.x - cornerA.x);
			if (_mode==BOTTOM_LEFT || _mode==TOP_RIGHT) angle=-angle;
			if (sizeX > _method[1]) {
				angle -= Math.PI/6;
			}

			mat.createGradientBox(endPoint.x - cornerA.x, endPoint.y - cornerA.y, angle, cornerA.x, cornerA.y);
			_shadow.graphics.clear();
			_shadow.graphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0x000000], [sizeX > _method[6] ? 0.2 : 1.0, 0.0], [0x00, sizeX > _method[6] ? 0xCC : 0x90], mat);

			_shadow.graphics.moveTo(cornerA.x, cornerA.y);
			_shadow.graphics.lineTo(cornerA.x + offset, cornerA.y);
			_shadow.graphics.lineTo(endPoint.x + offset, endPoint.y);
			_shadow.graphics.lineTo(endPoint.x, endPoint.y);				
			_shadow.graphics.lineTo(cornerA.x, cornerA.y);
			_shadow.graphics.endFill();
			
			var shadowOffset:Number = (1-_cRatio)*((_mode == TOP_RIGHT) ? 1 : -1)*((sizeX<_method[0]) ? sizeX/_method[0] : 1)*SHADOW;
			
			_shadow.graphics.beginFill(0x000000, SHADOW_ALPHA);
			_shadow.graphics.moveTo(cornerA.x, cornerA.y);
			_shadow.graphics.curveTo(cornerB.x-shadowOffset,cornerB.y,cornerC.x-bRatio*shadowOffset-shadowOffset,cornerC.y+(0.5+bRatio/2)*Math.abs(shadowOffset));
			_shadow.graphics.curveTo(cornerD.x-shadowOffset,cornerD.y,cornerE.x,cornerE.y);
			if (fAndG) {
				_shadow.graphics.curveTo(cornerF.x,cornerF.y,cornerG.x,cornerG.y);
			}
			_shadow.graphics.lineTo(cornerA.x, cornerA.y);
			
			_shadow.graphics.endFill();

			_mask0.graphics.clear();
			_mask0.graphics.beginFill(0xCCCCCC);
			_mask0.graphics.moveTo(fnX(0), fnY(0));
			_mask0.graphics.lineTo(cornerA.x, cornerA.y);
			
			if (cornerE.y > _attributes.heightV || cornerE.y < 0 || sizeX>_method[4]) {
				_mask0.graphics.lineTo(cornerG.x, cornerG.y);
				_mask0.graphics.lineTo(fnX(0), fnY(_attributes.heightV));
			}
			else {
				_mask0.graphics.lineTo(cornerE.x, cornerE.y);
			}
			
			_mask0.graphics.lineTo(fnX(0), fnY(0));
			_mask0.graphics.endFill();
			
			_mask1.graphics.clear();
			_mask1.graphics.beginFill(0xccffcc);
			_mask1.graphics.moveTo(cornerA.x, cornerA.y);
			_mask1.graphics.curveTo(cornerB.x, cornerB.y, cornerC.x, cornerC.y);
			_mask1.graphics.curveTo(cornerD.x, cornerD.y, cornerE.x, cornerE.y);
			_mask1.graphics.lineTo(fnX(0), fnY(_attributes.heightV));
			_mask1.graphics.lineTo(fnX(_attributes.widthH), fnY(_attributes.heightV));
			_mask1.graphics.lineTo(fnX(_attributes.widthH), fnY(0));
			_mask1.graphics.lineTo(cornerA.x, cornerA.y);
			_mask1.graphics.endFill();
			
			var flipAngle:Number = Math.atan2(cornerE.y-cornerC.y, cornerE.x-cornerC.x);
			_flipPage.x = cornerC.x;
			_flipPage.y = cornerC.y;
			_flipPage.rotation = flipAngle*RADIANS_TO_DEGREES-90;
		}
		
		
		protected function setPages(forward:Boolean):void {
			_forward = forward;
			if (_pageIndex==0 && !forward || _pageIndex==_pages.length && forward) return;

			if (_nextTurnPage) {
				_nextTurnPage.visible=false;
				_nextTurnPage.mask = null;
			}
			if (_flipPage) {
				_flipPage.visible=false;
				_flipPage.mask = null;
			}
			_thisTurnPage = _pageSprites0[_pageIndex];
			
			_nextIndex =  _pageIndex + (forward ? 1 : -1);
			_thisTurnPage.visible = true;
			_thisTurnPage.mask = _mask1;
			
			if (_nextIndex>=0 && _nextIndex<_pages.length) {			
				_nextTurnPage = _pageSprites0[_nextIndex];
				_nextTurnPage.visible = true;
				_nextTurnPage.mask = _mask0;
				_flipPage = _pageSprites1[_nextIndex];
				_flipPage.visible = true;
				_flipPage.mask = _mask2;
			}
			
			if (forward) {
				_flipPage.getChildAt(0).x=0;
			}
			else {
				_flipPage.getChildAt(0).x=-_attributes.widthH;
			}
		}
	
		
/**
 * Update the appearance of a component on a particular page.
 */
		public function updatePage(pageNumber:int, component:DisplayObject = null):void {
			var rectangle:Rectangle;
			var matrix:Matrix = new Matrix();
			matrix.identity();
			var page:Sprite = _pages[pageNumber];
			if (component) {
				var globalPoint:Point = component.localToGlobal(new Point(0,0));
				var localPoint:Point = page.globalToLocal(globalPoint);
				rectangle = new Rectangle(localPoint.x, localPoint.y, component.width, component.height);
				matrix.translate(rectangle.x, rectangle.y);
			}
			else {
				component = page;
				rectangle = new Rectangle(0, 0, _attributes.widthH, _attributes.heightV);
			}
			
			var bitmapData:BitmapData = _pageSprites0[pageNumber].bitmapData;
			bitmapData.draw(component, matrix, null, null, rectangle);
			_pageSprites0[pageNumber].bitmapData = bitmapData;
			Bitmap(_pageSprites1[pageNumber].getChildAt(0)).bitmapData = bitmapData;
		}
		
		
		protected function unSetPages():void {
			_thisTurnPage.visible = false;
			_nextTurnPage.visible = true;
			_thisTurnPage.mask = null;
			_nextTurnPage.mask = _mask1;
			_flipPage.mask = null;
			_flipPage.visible = false;
			_shadow.graphics.clear();
			_curl.graphics.clear();
			_mask2.graphics.clear();
			_lastDist = 99999.9;
		}
		
		
		protected function initialise():void {
			var matrix:Matrix = new Matrix();
			matrix.identity();
			for (var i:int = 0; i < _pages.length; i++) {
			
				super.goToPage(i);
				var bitmapData:BitmapData = new BitmapData(_attributes.widthH, _attributes.heightV, false, 0xffff00);
				bitmapData.draw(this, matrix, null, null, new Rectangle(0, 0, _attributes.widthH, _attributes.heightV));
				var bitmap0:Bitmap = new Bitmap(bitmapData);
				bitmap0.visible = false;
				_pageSprites0.push(bitmap0);
				_pageTurnLayer0.addChild(bitmap0);
				
				var wrapper:Sprite = new Sprite();
				wrapper.addChild(new Bitmap(bitmapData));
				wrapper.visible = false;
				_pageSprites1.push(wrapper);
				_pageTurnLayer1.addChild(wrapper);
			}
			super.goToPage(0);
		}


		protected function startPageCurl():void {
			if (!_pageTurnLayer0.visible) {
				dispatchEvent(new Event(PAGE_TURN_CURL));
				_pageTurnLayer0.visible = _pageTurnLayer1.visible = true;
				_corner=whichCorner();
				if (_alwaysUpdate) {
					updatePage(_pageIndex);
				}
			}
		}
		
		
		protected function pageTurnComplete():void
		{
			unSetPages();
			_pageIndex = _nextIndex;
			enableForward = _pageIndex < _pages.length-1;
			enableBack = _pageIndex > 0;
			_sensor.mouseEnabled = true;
			_flipPage.visible = false;
			_pageTurnLayer0.visible = _pageTurnLayer1.visible = false;
			dispatchEvent(new Event(PAGE_TURN_COMPLETE));
			super.goToPage(_pageIndex);
		}
		
		
		protected function mouseOver(event:MouseEvent=null):void
		{
			startPageCurl();
			setPages(_mode == TOP_RIGHT || _mode == BOTTOM_RIGHT);
			_lastDist = 0;
			mouseMove();
		}
		
		
		protected function mouseOut(event:MouseEvent):void
		{
			if (!_timer.running) {
				drawEdge(0);
				_shadow.graphics.clear();
				_pageTurnLayer0.visible = _pageTurnLayer1.visible = false;
			}
		}
		
		
		protected function mouseDown(event:MouseEvent):void
		{
			startPageCurl();
			setPages(_mode == TOP_RIGHT || _mode == BOTTOM_RIGHT);
			_sensor.mouseEnabled = false;
			pageTurn(0);
		}
		
		
		protected function mouseMove(event:MouseEvent=null):void
		{
			if (_corner) {
				var dist:Number=distance(_corner.x, _corner.y, mouseX, mouseY);
				if (_lastDist>_method[2]) dist = INITIAL_DIST;
				else if (dist>_lastDist+CHANGE_DIST) dist=_lastDist+CHANGE_DIST;
				else if (dist<_lastDist-CHANGE_DIST) dist=_lastDist-CHANGE_DIST;
				drawEdge(dist);
				if (dist > _method[2] - _factor * TURN_ZONE && dist > _lastDist) {
					_sensor.mouseEnabled = false;
					pageTurn(dist);
				}
				_lastDist = dist;
			}
		}
		
		
		public function pageTurn(size:Number):void
		{
			if (_swish) {
				_swish.play();
			}
			dispatchEvent(new Event(PAGE_TURN_START));
			_pageTurnLayer0.visible = _pageTurnLayer1.visible = true;
			_size=size;
			drawEdge(_size);
			_timer.reset();
			_timer.start();
		}
		
		
		protected function animate(event:TimerEvent):void
		{
			_size+=STEP_SIZE;
			drawEdge(_size);
			if (_cRatio>=1.0)
			{
				_timer.stop();
				initialiseMasks();
				pageTurnComplete();
				whichCorner();
				setPages(_mode == TOP_RIGHT || _mode == BOTTOM_RIGHT);
			}
		}
		
		
		protected function fnX(xx:Number):Number
		{
			if (_mode==TOP_LEFT || _mode==BOTTOM_LEFT) return xx;
			else return _attributes.widthH-xx;
		}
		
		
		protected function fnY(yy:Number):Number
		{
			if (_mode==TOP_LEFT || _mode==TOP_RIGHT) return yy;
			else return _attributes.heightV-yy;
		}
		
		
		protected function distance(x0:Number,y0:Number,x1:Number,y1:Number):Number
		{
			return Math.sqrt((x1-x0)*(x1-x0)+(y1-y0)*(y1-y0));
		}
		
		
		protected function whichCorner():Point
		{
			if (distance(0,0,mouseX,mouseY)<=HOTSPOT_SIZE)
			{
				_mode=TOP_LEFT;
				return new Point(0,0);
			}
			else if (distance(_attributes.widthH,0,mouseX,mouseY)<=HOTSPOT_SIZE)
			{
				_mode=TOP_RIGHT;
				return new Point(_attributes.widthH,0);
			}
			else if (distance(0,_attributes.heightV,mouseX,mouseY)<=HOTSPOT_SIZE)
			{
				_mode=BOTTOM_LEFT;
				return new Point(0,_attributes.heightV);
			}
			else if (distance(_attributes.widthH,_attributes.heightV,mouseX,mouseY)<=HOTSPOT_SIZE)
			{
				_mode=BOTTOM_RIGHT;
				return new Point(_attributes.widthH,_attributes.heightV);
			}
			else
			{
				return null;
			}
		}

		
		public function set enableForward(value:Boolean):void
		{
			_enableForward=value;
			makeHotSpots();
		}
		
		
		public function set enableBack(value:Boolean):void
		{
			_enableBack=value;
			makeHotSpots();
		}
		
		
		protected function makeHotSpots():void
		{
			_sensor.graphics.clear();
			_sensor.graphics.beginFill(0x0000ff, 0.0);
			if (_enableBack) {
				_sensor.graphics.drawCircle(0,0,_method[2]);
			}
			if (_enableForward) {
				_sensor.graphics.drawCircle(_attributes.widthH,0,_method[2]);
			}
			_sensor.name="sensor";
		}
		
		
		public function initialiseMasks():void
		{
			graphics.clear();
			_mask0.graphics.clear();
			_mask1.graphics.clear();
			_mask1.graphics.beginFill(0xccffcc);
			_mask1.graphics.drawRect(0,0,_attributes.widthH,_attributes.heightV);
		}
		
		
		override public function destructor():void {
			_sensor.removeEventListener(MouseEvent.MOUSE_OVER,mouseOver);
			_sensor.removeEventListener(MouseEvent.MOUSE_OUT,mouseOut);
			_sensor.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			_sensor.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
		}
	}
}