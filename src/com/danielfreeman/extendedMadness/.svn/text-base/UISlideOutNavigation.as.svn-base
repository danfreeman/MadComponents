package com.danielfreeman.extendedMadness {
	
	import flash.events.MouseEvent;
	import com.danielfreeman.extendedMadness.*;
	import com.danielfreeman.madcomponents.*;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.utils.Timer;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.display.GradientType;
	import flash.geom.Matrix;

	public class UISlideOutNavigation extends UIContainerBaseClass {
		
		public static const CLICKED:String = "slideOutClicked";
		
		protected static const MAXIMUM_LIST_WIDTH:Number = 512.0;
		protected static const LEFT_OVER:Number = 50.0;
		protected static const COLOUR:uint = 0xCCCCFF;
		protected static const SHADOW_WIDTH:Number = 8.0;
		
		public static var SLIDE_INTERVAL:int = 40;
		public static var STEPS:int = 6;
		
		protected var _listXML:XML = null;
		protected var _detailXML:XML = null;
		protected var _navigationBar:UINavigationBar;
		protected var _list:UIList;
		protected var _form:UIForm;
		protected var _slideTimer:Timer = new Timer(SLIDE_INTERVAL, STEPS);
		protected var _listWidth:Number;
		protected var _startX:Number;
		protected var _buttonEnabled:Boolean = true;
		
		
		public function UISlideOutNavigation(screen : Sprite, xml : XML, attributes : Attributes) {
			super(screen, xml, attributes);
			
			_listWidth = Math.min(MAXIMUM_LIST_WIDTH, attributes.width - LEFT_OVER);

			for each(var child:XML in xml.children()) {
				if (child.localName()=="data") {
					_listXML = XML('<list background="#FFFFFF">'+child.toXMLString()+"</list>");
				}
				else if (child.localName() == "list" || child.localName().indexOf("List")>=0) {
					_listXML = child;
				}
				else {
					_detailXML = child;
				}
			}
			
			var listAttributes:Attributes = new Attributes(0, 0, _listWidth - SHADOW_WIDTH / 2, attributes.height - UINavigationBar.HEIGHT);
			var formAttributes:Attributes = attributes.copy(_detailXML);
			if (_detailXML.@border!="false") {
				addPadding(_detailXML.localName(), formAttributes);
			}

			_list = UIList(UI.containers(this, _listXML, listAttributes));
			_form = new UI.FormClass(this, _detailXML, formAttributes);
			
			_navigationBar = new UINavigationBar(this, attributes);
			if (xml.@title.length()>0) {
				_navigationBar.text = xml.@title[0].toString();
			}
			this.setChildIndex(_navigationBar, numChildren-1);
			_navigationBar.backButton.visible = false;
			_navigationBar.leftButton.visible = true;
			_navigationBar.leftButton.text = " ";
			_navigationBar.leftButton.fixwidth = 40;
			_list.y = _form.y = _navigationBar.height;
			
			makeMenuButton();
			drawShadow(attributes.height - _navigationBar.height);
			_navigationBar.leftButton.addEventListener(UIButton.CLICKED, slideButtonHandler);
			_slideTimer.addEventListener(TimerEvent.TIMER, doSlide);
			_slideTimer.addEventListener(TimerEvent.TIMER_COMPLETE, slideComplete);
		}
		
		
		public function get list():UIList {
			return _list;
		}
		
		
		public function get detail():UIForm {
			return _form;
		}
		
		
		public function get navigationBar():UINavigationBar {
			return _navigationBar;
		}
		
		
		public function set enabled(value:Boolean):void {
			_buttonEnabled = value;
			
		}
		
		
		public function get listWidth():Number {
			return _listWidth;
		}
		
		
		public function open(animated:Boolean = true):void {
			_form.clickable = _form.mouseEnabled = _form.mouseChildren = false;
			if (animated) {
				_slideTimer.repeatCount = Math.max(Math.floor(STEPS * (1 - _form.x / _listWidth)), 1);
				_slideTimer.reset();
				_slideTimer.start();
			}
			else {
				_form.x = _listWidth;
			}
		}
		
		
		public function close(animated:Boolean = true):void {
			_form.clickable = _form.mouseEnabled = _form.mouseChildren = true;
			if (animated) {
				_slideTimer.repeatCount = Math.max(Math.floor(STEPS * _form.x / _listWidth), 1);
				_slideTimer.reset();
				_slideTimer.start();
			}
			else {
				_form.x = 0;
			}
		}
		
		
		protected function drawShadow(height:Number):void {
			var matr:Matrix = new Matrix();
			matr.createGradientBox(SHADOW_WIDTH, height, 0, -SHADOW_WIDTH, 0);
			_form.graphics.beginGradientFill(GradientType.LINEAR, [0x333333,0x333333], [0.0,1.0], [0x00,0xff], matr);
			_form.graphics.drawRect(-SHADOW_WIDTH, 0, SHADOW_WIDTH, height);
		}
		
		
		protected function makeMenuButton():void {
			var icon:Sprite = new Sprite();
			icon.mouseEnabled = false;
			_navigationBar.leftButton.addChild(icon);
			icon.graphics.beginFill(COLOUR);
			icon.graphics.drawRoundRect(8, 7, 24, 3, 2);
			icon.graphics.drawRoundRect(8, 14, 24, 3, 2);
			icon.graphics.drawRoundRect(8, 21, 24, 3, 2);
		}
			

		override public function layout(attributes:Attributes):void {
			_navigationBar.fixwidth = attributes.width;
			_listWidth = Math.min(MAXIMUM_LIST_WIDTH, attributes.width - LEFT_OVER);
			var listAttributes:Attributes = new Attributes(0, 0, _listWidth - SHADOW_WIDTH/2, attributes.height - _navigationBar.height);
			var formAttributes:Attributes = attributes.copy(_detailXML);
			if (_detailXML.@border!="false") {
				addPadding(_detailXML.localName(), formAttributes);
			}
			_list.layout(listAttributes);
			_form.layout(formAttributes);
			drawShadow(attributes.height - _navigationBar.height);
		}
		
		
		protected function slideButtonHandler(event:Event):void {
			dispatchEvent(new Event(CLICKED));
			_form.clickable = _form.mouseEnabled = _form.mouseChildren = !_form.mouseEnabled;
			if (_buttonEnabled) {
				_slideTimer.repeatCount = STEPS;
				_slideTimer.reset();
				_slideTimer.start();
			}
		}
		
		
		protected function doSlide(event:TimerEvent):void {
			var slideTimer:Timer = Timer(event.currentTarget);
			var t:Number = slideTimer.currentCount/slideTimer.repeatCount;
			_form.x = (_form.mouseEnabled ? (1-t) : t) * _listWidth;
		}
		
		
		protected function slideComplete(event:TimerEvent):void {
			if (!_form.mouseEnabled) {
				addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			}
		}
		
		
		protected function mouseDown(event:MouseEvent):void {
			if (!_form.mouseEnabled && mouseX > _listWidth && mouseY > _navigationBar.height) {
				_startX = mouseX;
				stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			}
		}
		
		
		protected function mouseUp(event:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			_form.clickable = _form.mouseEnabled = _form.mouseChildren = mouseX < _listWidth / 2;
			_slideTimer.repeatCount = Math.max(_form.mouseEnabled ? Math.floor(STEPS * _form.x / _listWidth) : Math.floor(STEPS * (1 - _form.x / _listWidth)), 1);
			_slideTimer.reset();
			_slideTimer.start();
		}
				
		
		protected function mouseMove(event:MouseEvent):void {
			_form.x = Math.max(Math.min(mouseX - _startX + _listWidth, _listWidth), 0);
		}
		
		
		protected function addPadding(localName:String,newAttributes:Attributes):void {
			if (localName.toLowerCase().indexOf("pages")<0 && localName.toLowerCase().indexOf("list")<0 && localName.toLowerCase().indexOf("navigation")<0 && localName.toLowerCase().indexOf("scroll")<0 && localName!="viewFlipper" && localName!="frame") {
				newAttributes.x+=UI.PADDING;
				newAttributes.y+=UI.PADDING;
				newAttributes.width-=2*UI.PADDING;
				newAttributes.height-=2*UI.PADDING;
				newAttributes.hasBorder=true;
			}
		}
		
	}
}
