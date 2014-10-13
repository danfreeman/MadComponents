package com.danielfreeman.madcomponents {

	import flash.events.FocusEvent;
	import flash.display.Sprite;

	/**
	 * @author danielfreeman
	 */
	public class UIInputX extends UIInput implements IComponentUI {
		
	//	protected var _altFocus:Boolean = false;
	//	protected var _height:Number;

		public function UIInputX(screen : Sprite, xml:XML, attributes:Attributes) {
			super(screen, attributes.x, attributes.y, xml.toString(), attributes.backgroundColours, attributes.style7 != (xml.@alt == "true"), xml.@prompt.length()>0 ? xml.@prompt[0].toString() : "", xml.@promptColour.length()>0 ? UI.toColourValue(xml.@promptColour[0].toString()) : UIBlueText.GREY, attributes.style7);
			if (attributes.fillH) {
				fixwidth = attributes.widthH;
			}
			UIBlueText(inputField).password = xml.@password.length()>0 && xml.@password == "true";
		}
		
		
		override public function layout(attributes:Attributes):void {
			super.layout(attributes);
			if (attributes.fillH) {
				fixwidth = attributes.widthH;
			}
		}
		
		
	/*	public function altFocus():void {
			_altFocus = true;
			_height = _label.height;
			fullInput();
			_label.addEventListener(FocusEvent.FOCUS_IN, focusIn);
		}
		
		
		protected function focusIn(event:FocusEvent):void {
			_label.x = _alt ? SIZE_ALT : SIZE_X;
			_label.y = (_alt ? SIZE_ALT : SIZE_Y) + 1;
			_label.fixwidth = width - 2 * (_alt ? SIZE_ALT : SIZE_X);
			_label.height = _height;
		}
		
		
		protected function fullInput():void {
			_label.x = 0;
			_label.y = 0;
			_label.width = width;
			_label.height = height - (_alt ? SIZE_ALT : SIZE_Y) - 1;
		}
		
		
		override protected function focusOut(event:FocusEvent):void {
			if (_altFocus) {
				fullInput()
			}
			super.focusOut(event);
		}
		
		
		override public function destructor():void {
			_label.removeEventListener(FocusEvent.FOCUS_IN, focusIn);
			super.destructor();
		}*/

	}
}
