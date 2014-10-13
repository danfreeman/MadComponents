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
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.system.Capabilities;
	import flash.text.TextField;


/**
 * MadComponents UI root class
 * <pre>
 * &lt;
 *    clickColour = "#rrggbb"
 *    dpi = "INTEGER"
 *    stageColour = "#rrggbb,#rrggbb,..."
 *    autoScale = "true|false"
 *    autoResize = "true|false"
 *    activityIndicatorColour = "#rrggbb"
 * /&gt;
 * </pre>
 */	
	public class UI {
		
		public static const RESIZED:String = "resized";
		
		public static var PADDING:Number = 10.0;
		public static var ModelClass:Class = Model;
		public static var FormClass:Class = UIForm;
		public static var SIMULATION_RESIZE:Boolean = true;
		
		protected static const DPI:uint = 160;
		protected static const DIM_ALPHA:Number = 0.4;
		protected static const WIDTH:Number = 300;
		protected static const HEIGHT:Number = 454;
		protected static const COLOUR:uint = 0x9999AA;
		
		protected static const TOKENS:Array = ["scrollVertical","viewFlipper","list","groupedList","dividedList","pages","tabPages","navigation","navigationPages","longList", "imageLoader", "image", "switch", "search", "button", "label", "slider", "input", "renderer"];
		protected static const CLASSES:Array = [UIScrollVertical,UIViewFlipper,UIList,UIGroupedList,UIDividedList,UIPages,UITabPages,UINavigation,UINavigationPages,UILongList, UIImageLoader, UIImage, UISwitch, UISearch, UIButtonX, UILabelX, UISliderX, UIInputX, UIRenderer];

		protected static const DEBUG_SCALE:Number = -1.0;

		protected static var _tokens:Array = TOKENS;
		protected static var _classes:Array = CLASSES;
		protected static var _screen:Sprite;
		protected static var _root:Sprite;
		protected static var _windowLayer:Sprite;
		protected static var _xml:XML;
		protected static var _autoScale:Boolean = true;
		protected static var _autoResize:Boolean = true;
		protected static var _scale:Number = 1.0;
		protected static var _popUps:int = 0;
		protected static var _attributes:Attributes;
		protected static var _simulated:Boolean = true;
		protected static var _activityIndicator:UIActivity;
		protected static var _maskIt:Boolean = true;
		protected static var _stageColours:Vector.<uint> = null;
		protected static var _dpi:uint = DPI;
		protected static var _width:Number;		
		protected static var _height:Number;	
		

/**
 * Create the user interface
 */	
		public static function create(screen:Sprite, xml:XML, width:Number = -1, height:Number = -1):Sprite {
			if (_root) {
				clear();
			}
			
			screen.stage.stageFocusRect = false;
			_simulated = width<0 && (Capabilities.playerType == "StandAlone" || Capabilities.playerType == "PlugIn" || Capabilities.playerType == "ActiveX" || Capabilities.playerType == "External");
			if (xml.@clickColour.length()>0)
				UIList.HIGHLIGHT = toColourValue(xml.@clickColour[0].toString());
			
			if (xml.@dpi.length()>0)
				_dpi = parseInt(xml.@dpi[0]);
			
			if (xml.@autoScale=="false")
				_autoScale = false;
			
			if (width > 0) {
				_attributes = newAttributes(width, height);
				_maskIt = false;
			}
			else if (_simulated) {
				_attributes = newAttributes(width=WIDTH, height=HEIGHT);
			}
			else {
				_attributes = newAttributes(width=Capabilities.screenResolutionX, height=Capabilities.screenResolutionY);
			}
			
			XML.prettyPrinting = false;
			_xml = xml;
			_screen = screen;
			
			if (SIMULATION_RESIZE || xml.@autoResize!="false" && !_simulated) {
				screen.stage.addEventListener(Event.RESIZE, resize, false, 0, true);
			}
				
			_root = Sprite(containers(screen,xml,_attributes));
			if (!_root && (xml.@border.length()==0 || xml.@border[0]=="true")) {
				_attributes.x=PADDING;
				_attributes.y=PADDING;
				_attributes.width-=2*PADDING;
				_attributes.height-=2*PADDING;
				_attributes.hasBorder = true;
			}
			if (!_root) {
				_root = new FormClass(screen, XML("<vertical>"+xml.toXMLString()+"</vertical>"), _attributes);
				_root.name = "+";
			}
			_root.scaleX = _root.scaleY = _scale;
			
			var colours:String = xml.@stageColour;
			if (colours) {
				_stageColours = toColourVector(colours);
				drawBackgroundColour(_stageColours, width, height);
			}
			
			if (!SIMULATION_RESIZE && _maskIt && _simulated) {
				var mask:Sprite = new Sprite();
				mask.graphics.beginFill(0);
				mask.graphics.drawRect(0, 0, WIDTH, HEIGHT);
				_root.mask = mask;
				_root.addChild(mask);
			}

			screen.addChild(_windowLayer = new Sprite());
			_windowLayer.scaleX = _windowLayer.scaleY = _scale;
			
			_activityIndicator = new UIActivity(screen, width/2, height/2, false, (xml.@activityIndicatorColour.length() > 0) ? UI.toColourValue(xml.@activityIndicatorColour) : 0xFFFFFF);
			_activityIndicator.scaleX = _activityIndicator.scaleY = UI.scale / 2;
			if (_simulated) {
				resize(new Event("dummy"));
			}

			return _root;
		}
		
/**
 * Extend the XML layout language.  You specify two arrays.  One array of XML tag names, and a corresponding array of classes that they correspond to.
 */	
		public static function extend(tokens:Array,classes:Array):void {
			_tokens = _tokens.concat(tokens);
			_classes = _classes.concat(classes);
		}
		
/**
 * Filter an XML String, removing odd unprintable characters.  (Unprintable characters often result from copy and paste of XML data)
 */
		public static function clean(xml:XML):XML {
			return XML(xml.replace(/[^\x{20}-\x{7E}]/g,""));
		}
		
/**
 * Convert #rrggbb string to uint
 */
		public static function toColourValue(value:String):uint {
			value = value.replace(/ /gi,"");
			if (value.substr(0,1)=="#")
				return parseInt(value.substr(1,6),16);
			else if (value.substr(0,1)>="0" && value.substr(0,1)<="9")
				return parseInt(value);
			else
				return COLOUR;
		}
		
/**
 * Convert a comma seperated list of #rrggbb string colour values to a uint vector
 */
		public static function toColourVector(value:String):Vector.<uint> {
			value = value.replace(/ /gi,"");
			var splitValues:Array = value.split(",");
			var result:Vector.<uint> = new Vector.<uint>;
			for each (var colour:String in splitValues) {
				result.push(toColourValue(colour));
			}
			return result;
		}
		
/**
 * Convert a comma seperated list of #rrggbb string colour values to a uint vector
 */
		public static function drawBackgroundColour(colours:Vector.<uint>, width:Number, height:Number, screen:Sprite = null, padding:Number = 0):void {
			if (!screen) {
				screen = _root;
			}
			if (screen==_root && _stageColours && _stageColours.length>0) {
				colours = _stageColours;
			}
			screen.graphics.clear();
			if (colours.length == 1) {
				screen.graphics.beginFill(colours[0]);
			}
			else if (colours.length>1) {
				var matr:Matrix=new Matrix();
				matr.createGradientBox(colours.length>2 ? colours[2] : width, colours.length>2 ? colours[2] : height+2*padding, colours.length>3 ? colours[3]*Math.PI/180 : Math.PI/2, 0, -padding);
				screen.graphics.beginGradientFill(GradientType.LINEAR, [colours[0],colours[1]], [1.0,1.0], [0x00,0xff], matr, SpreadMethod.REPEAT);
			}
			else {
				screen.graphics.beginFill(0,0);
			}
			screen.graphics.drawRect(-padding, -padding, width+2*padding, height+2*padding);
		}
		
		
		
		public static function get scale():Number {
			return _scale;
		}

	
/**
 * Converts an XML tag name to a container object.
 */	
		public static function containers(screen:Sprite, xml:XML, attributes:Attributes):DisplayObject {
			var idx:int = _tokens.indexOf(xml.localName());
			if (idx>=0) {
				attributes.parse(xml);
				var result:DisplayObject = new _classes[idx](screen, xml, attributes);
				result.x=attributes.x;
				result.y=attributes.y;
				if (xml.@id.length()>0) {
					result.name = xml.@id[0];
				}
				return result;
			}
			else {
				return null;
			}
		}
		
/**
 * Is this the XML tag name of a container?
 */	
		public static function isContainer(name:String):Boolean {
			return _tokens.indexOf(name) >= 0;
		}
		
/**
 * Is this the XML tag name of a UIForm container?
 */	
		public static function isForm(name:String):Boolean {
			return name=="frame" || name=="horizontal" || name=="vertical" || name=="columns" || name=="rows" || name=="group" || name=="clickableGroup" || name=="table";
		}
		
/**
 * Redraw the user interface
 */	
		public static function redraw():Sprite {
			return create(_screen, FormClass(_root).xml);
		}
		
		
		public static function get attributes():Attributes {
			return _attributes;
		}

/**
 * Handler for orientation change
 */	
		public static function resize(event:Event = null):void {
			layout(_screen.stage.stageWidth, _screen.stage.stageHeight);
			_screen.dispatchEvent(new Event(RESIZED));
		}
		
/**
 * Rearrange the UI for a new screen size
 */	
		public static function layout(width:Number = -1, height:Number = -1):void {
		//	if (_root) {
				if (width < 0) {
					width = _screen.stage.stageWidth;
					height = _screen.stage.stageHeight;
				}
				_width = width; _height = height;
				_attributes = newAttributes(width, height);
				_attributes.parse(_xml);
				var container:Boolean = isContainer(_xml.localName());
				if (_root && container) {
					IComponentUI(_root).layout(_attributes);
				}
				if (!container && (_xml.@border.length()==0 || _xml.@border[0]=="true")) {
					_attributes.x=PADDING;
					_attributes.y=PADDING;
					_attributes.width-=2*PADDING;
					_attributes.height-=2*PADDING;
					_attributes.hasBorder = true;
				}
				if (!container && _root) {
					FormClass(_root).layout(_attributes);
				}
				if (_root && !_root.mouseEnabled) {
					dimUI();
				}
				drawStageBackground();
				centrePopUps();
		//	}
		}
		
		
		public static function drawStageBackground():void {
			if (!isForm(_xml.localName())) {
				drawBackgroundColour(_attributes.backgroundColours, _width, _height);
			}
		}
		

		protected static function newAttributes(width:Number, height:Number):Attributes {
			if (DEBUG_SCALE > 1.0) {
				_scale = DEBUG_SCALE;
				width/=_scale;
				height/=_scale;
			}
			else if (_autoScale && Capabilities.screenDPI > _dpi) {
				_scale = Math.round(4 *Capabilities.screenDPI / _dpi) / 4;
				width/=_scale;
				height/=_scale;
			}
			return new Attributes(0, 0, width, height);
		}
		
/**
 * Find the component that matches the id parameter.  Note optional row and group parameters to find a component within a specific list row.
 */	
		public static function findViewById(id:String, row:int = -1, group:int = -1):DisplayObject {
			if (id == _root.name)
				return _root;
			else
				return IContainerUI(_root).findViewById(id, row, group);
		}
		
/**
 * Create a pop-up dialogue window
 */	
		public static function createPopUp(xml:XML, width:Number = -1, height:Number = -1, curve:Number = 10.0, centre:Boolean = true):UIWindow {
			if (width<0) {
				width = 0.8 * _attributes.width;
			}
			if (height<0) {
				height = 0.8 * _attributes.height;
			}
			var attributes:Attributes = new Attributes(0, 0, width, height);
			attributes.parse(xml);
			var window:UIWindow = new UIWindow(_windowLayer, xml, attributes, curve, centre);
			window.x = _root.x + _attributes.x + (_attributes.width - width) / 2;
			window.y = _root.y + _attributes.y + (_attributes.height - height) / 2;
			_popUps++;
			dimUI();
			return window;
		}
		
/**
 * Remove and dispose of the pop-up dialogue window
 */	
		public static function removePopUp(window:UIWindow):void {
			if (_windowLayer.contains(window)) {
				hidePopUp(window);
				window.destructor();
				_windowLayer.removeChild(window);
			}
		}
		
/**
 * Show the pop-up dialogue window
 */	
		public static function showPopUp(window:UIWindow):void {
			if (window.visible) return;
			window.visible = true;
			_popUps++;
			dimUI();
		}
		
/**
 * Hide the pop-up dialogue window
 */	
		public static function hidePopUp(window:UIWindow):void {
			if (!window.visible) return;
			window.visible = false;
			_popUps--;
			if (_popUps <= 0) {
				unDimUI();
			}
		}
		
/**
 * Show activity indicator
 */	
		public static function showActivityIndicator():void {
			_activityIndicator.visible = true;
		//	_screen.setChildIndex(_activityIndicator, _screen.numChildren-1);
		}
		
/**
 * Hide the activity indicator
 */	
		public static function hideActivityIndicator():void {
			_activityIndicator.visible = false;
		}
		
/**
 * This is the layer in which all pop-ups and dialogues are created
 */	
		public static function get windowLayer():Sprite {
			return _windowLayer;
		}
	
/**
 * This is the layer in which the UI is created
 */	
		public static function get uiLayer():Sprite {
			return _root;
		}
			
/**
 * Reposition all pop-ups to the centre of the screen
 */	
		public static function centrePopUps():void {
			for (var i:int = 0; i<_windowLayer.numChildren;i++) {
				var window:DisplayObject = _windowLayer.getChildAt(i);
				if (window is UIWindow && UIWindow(window).centred) {
					window.x = _attributes.x + (_attributes.width - UIWindow(window).attributes.width) / 2;
					window.y = _attributes.y + (_attributes.height - UIWindow(window).attributes.height) / 2;
				}
			}
			_activityIndicator.x = _scale*(_attributes.x + _attributes.width/2);
			_activityIndicator.y = _scale*(_attributes.y + _attributes.height/2);
		}
			
/**
 * Dim the user interface beneath the pop-ups, ensuring that all dialogues are modal
 */	
		public static function dimUI():void {
			_root.mouseEnabled = _root.mouseChildren = false;
			_windowLayer.graphics.clear();
			_windowLayer.graphics.beginFill(0x000000, DIM_ALPHA);
			_windowLayer.graphics.drawRect(0, 0, _screen.stage.stageWidth, _screen.stage.stageHeight);
		}
		
/**
 * Un-dim the user interface beneath the pop-ups
 */	
		public static function unDimUI():void {
			_root.mouseEnabled = _root.mouseChildren = true;
			_windowLayer.graphics.clear();
		}
		
/**
 * Remove all components, clearing the user interface
 */	
		public static function clear(item:Sprite = null):void {
			if (!item) item = _root;
			for (var i:int = item.numChildren-1; i>=0; i--) {
				var child:DisplayObject = DisplayObject(item.getChildAt(i));
				if (child.hasOwnProperty("destructor")) {
					Object(child).destructor();
				}
				item.removeChildAt(i);
			}
			if (item==_root && _root) {
				_screen.removeChild(_root);
				_root = null;
			}
		}
	}
}
