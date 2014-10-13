package com.danielfreeman.madcomponents {

	import flash.display.Sprite;

	/**
	 * @author danielfreeman
	 */
	public class UISliderX extends UISlider implements IComponentUI {

		public function UISliderX(screen : Sprite, xml:XML, attributes:Attributes) {
				super(screen, attributes.x, attributes.y, attributes.backgroundColours, xml.@alt == "true", attributes.style7);
				_attributes = attributes;
				
				if (attributes.fillH) {
					fixwidth = attributes.widthH;
				}
				if (xml.@value.length()>0) {
					value = Number(xml.@value);
				}
		}
		
		
		override public function layout(attributes:Attributes):void {
			super.layout(attributes);
			if (attributes.fillH) {
				fixwidth = attributes.widthH;
			}
		}

	}
}
