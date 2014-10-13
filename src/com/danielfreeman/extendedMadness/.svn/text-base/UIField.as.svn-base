package com.danielfreeman.extendedMadness
{
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.Sprite;
	import flash.text.TextFormat;
	
	public class UIField extends UIBlueText
	{
		protected static const FORMAT:TextFormat=new TextFormat('Arial',11,0x333333);
		protected static const BORDER_COLOUR:uint = 0x999999;
		
		public function UIField(screen:Sprite, xml:XML, attributes:Attributes)
		{
			border = true;
			borderColor = BORDER_COLOUR;
			attributes.parse(xml);
			super(screen, 0, 0, xml.@prompt, -1, FORMAT, xml.@prompt!="", UIBlueText.GREY);
			fixwidth = attributes.widthH;
			text = xml.toString();
		}
	}
}