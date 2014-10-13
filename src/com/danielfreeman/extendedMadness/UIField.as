package com.danielfreeman.extendedMadness
{
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.Sprite;
	import flash.text.TextFormat;
	
	public class UIField extends UIBlueText
	{
		protected static const FORMAT:TextFormat=new TextFormat('Arial',14,0x333333);
		protected static const BORDER_COLOUR:uint = 0x999999;
		
		protected var _xml:XML;
		
		public function UIField(screen:Sprite, xml:XML, attributes:Attributes)
		{
			_xml = xml;
			border = true;
			borderColor = BORDER_COLOUR;
			attributes.parse(xml);
			super(screen, 0, 0, xml.@prompt, -1, FORMAT, xml.@prompt!="", UIBlueText.GREY);
			fixwidth = attributes.widthH;
			text = xml.toString();
			if (xml.@alignV == "fill") {
				fixheight = attributes.height;
			}
		}
		
		
		public function layout(attributes:Attributes):void {
			fixwidth = attributes.widthH;
			if (_xml.@alignV == "fill") {
				fixheight = attributes.height;
			}
		}
	}
}