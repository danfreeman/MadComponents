package com.danielfreeman.madcomponents {
	import flash.text.TextFieldAutoSize;
	import com.danielfreeman.madcomponents.UILabel;

	import flash.display.Sprite;
	import flash.text.TextFormat;

	/**
	 * @author danielfreeman
	 */
	public class UILabelX extends UILabel implements IComponentUI {
		
		protected var _autoSize:Boolean;
		protected var _attributes:Attributes;
		protected var _xml:XML;
		protected var _clickable:Boolean = true;
		protected var _includeInLayout:Boolean = true;

		
		public function UILabelX(screen:Sprite, xml:XML, attributes:Attributes) {
				super(screen, attributes.x, attributes.y, xml.toString());
				embedFonts = xml.@embedFonts == true;
				if (xml.@antiAliasType.length() > 0) {
					antiAliasType = xml.@antiAliasType;
				}
				assignToLabel(xml);
				if (xml.@height.length()>0) {
					fixheight = Number(xml.@height[0]);
				}
				if (attributes.fillH || xml.@height.length()>0) {
					fixwidth = attributes.widthH;
					var textAlign:String = attributes.textAlign;
					if (textAlign != "") {
						var format:TextFormat = new TextFormat();
						format.align = textAlign;
						defaultTextFormat = format;
					}
				}
				_autoSize = xml.@autosize.length() > 0 && xml.@autosize != "false";
				if (_autoSize) {
					autoSize = TextFieldAutoSize.LEFT;
				}
			//	border = true;
		}
		
		
		protected function assignToLabel(xml:XML):void {
			if (xml.hasComplexContent()) {
				var xmlString:String = xml.toXMLString();
				var htmlText:String = xmlString.substring(xmlString.indexOf(">")+1,xmlString.lastIndexOf("<"));
				xmlText = htmlText;
			}
		}
		
		
		public function layout(attributes:Attributes):void {
			_attributes = attributes;
			if (attributes.fillV) {
				fixheight = attributes.heightV;
			}
			if (attributes.fillH) {
				fixwidth = attributes.widthH;
			}
			if (_autoSize) {
				autoSize = TextFieldAutoSize.LEFT;
			}
		}
		
		
		public function set clickable(value:Boolean):void {
			_clickable = value;
		}
		
		public function get clickable():Boolean {
			return _clickable;
		}
		
		public function set includeInLayout(value:Boolean):void {
			_includeInLayout = value;
		}
		
		public function get includeInLayout():Boolean {
			return _includeInLayout;
		}
		
		public function touchCancel():void {
			//override to implement scroll cancel
		}
		
		public function get attributes():Attributes {
			return _attributes;
		}
		
		
		public function destructor():void {
		}
		
	}
}
