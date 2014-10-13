package com.danielfreeman.madcomponents
{
	
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.display.Sprite;
	import flash.display.DisplayObject;

	public class UIRenderer extends UIContainerBaseClass {

		protected var _childAttributes:Vector.<Attributes>;
		protected var _children:Vector.<DisplayObject>;
		protected var _alignRight:Vector.<Boolean>;
		
		
		public function UIRenderer(screen:Sprite, xml:XML, attributes:Attributes) {
			super(screen, xml, attributes);
		}
		
		
		override protected function initialise(xml:XML, attributes:Attributes):void {
			_childAttributes = new <Attributes>[];
			_children = new <DisplayObject>[];
			_alignRight = new <Boolean>[];
			for each (var xmlChild:XML in xml.children()) {
				var childAttributes:Attributes = attributes.copy(xml, true);
				childAttributes.y = 0;
				var localName:String = xmlChild.localName();
				if (UI.isContainer(localName)) {
					_childAttributes.push(childAttributes);
					_children.push(UI.containers(this, xmlChild, childAttributes));
					_alignRight.push(xmlChild.@alignH == "right");
				}
				else {
					trace(localName," not supported by UIRenderer");
				}
			}
		}

		
		override public function drawComponent():void {
			var left:Number = 0;
			var right:Number = _attributes.widthH;
			var lastY:Number = 0;
			var image:UIImage = (_children.length > 0 && _children[0] is UIImage) ? UIImage(_children[0]) : null;
			if (image) {
				left = image.width + _attributes.paddingH;
			}
		//	var childAttributes:Attributes = _attributes.copy(_xml, true);
			for (var i:int = image ? 1 : 0; i < _children.length; i++) {
				var child:DisplayObject = _children[i];
				if (child is IComponentUI) {
					var childAttributes:Attributes = _childAttributes[i];
					childAttributes.x = left;
					childAttributes.width = right - left;
					IComponentUI(child).layout(childAttributes);
					child.y = lastY;
					if (_alignRight[i]) {
						right = right - child.width;
						child.x = right;
					}
					else {
						child.x = left;
						lastY += child.height + _attributes.paddingV;
					}
				}
			}
			if (image) {
				var offset:Number = (image.height - lastY + _attributes.paddingV) / 2;
				if (offset > 0) {
					for (var j:int = 1; j < _children.length; j++) {
						_children[j].y += offset;
					}
				}
			}
		}
		
		
		override public function destructor():void {
			super.destructor();
			for each (var child:DisplayObject in _children) {
				if (child is IComponentUI) {
					IComponentUI(child).destructor();
				}
			}
		}
	}
}