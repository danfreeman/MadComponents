package com.danielfreeman.extendedMadness
{
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class UILine extends UIContainerBaseClass {
		
		protected static const DARK:uint = 0x333333;
		protected static const LIGHT:uint = 0xFFFFFF;

		protected var _border:Boolean;


		public function UILine(screen:Sprite, xml:XML, attributes:Attributes) {
			_border = xml.@border != "false";
			super(screen, xml, attributes);
		}
		
		
		override public function drawComponent():void {
			graphics.clear();
			graphics.beginFill(_attributes.backgroundColours.length>0 ? _attributes.backgroundColours[0] : DARK);
			graphics.drawRect(_border ? 0 : -UI.PADDING, 0, _attributes.widthH + (_border ? 0 : 2 * UI.PADDING), 1);
			graphics.beginFill(_attributes.backgroundColours.length>1 ? _attributes.backgroundColours[1] : LIGHT);
			graphics.drawRect(_border ? 0 : -UI.PADDING, 1, _attributes.widthH + (_border ? 0 : 2 * UI.PADDING), 1);
			
		}
	}
}