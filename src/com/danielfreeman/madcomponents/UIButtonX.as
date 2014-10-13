package com.danielfreeman.madcomponents {
	import com.danielfreeman.madcomponents.UIButton;

	import flash.display.Sprite;

	/**
	 * @author danielfreeman
	 */
	public class UIButtonX extends UIButton implements IComponentUI {

		public function UIButtonX(screen : Sprite, xml:XML, attributes:Attributes) {
				super(screen, attributes.x, attributes.y, xml.toString(), attributes.colour, attributes.backgroundColours, xml.@alt == "true", attributes.style7);
				_attributes = attributes;

				if (xml.@skin.length()>0) {
					skin = xml.@skin[0];
				}
				
				if (attributes.fillH) {
					fixwidth = attributes.widthH;
				}
				if (attributes.fillV) {
					skinHeight = attributes.heightV;
				}
				
				if (xml.@curve.length()>0) {
					curve = parseFloat(xml.@curve);
				}
				
				setGoTo(xml.@goTo, xml.@transition);
		}
		
		
		override public function layout(attributes:Attributes):void {
			super.layout(attributes);
			if (attributes.fillV) {
				skinHeight = attributes.heightV;
			}
			if (attributes.fillH) {
				fixwidth = attributes.widthH;
			}
		}

	}
}
