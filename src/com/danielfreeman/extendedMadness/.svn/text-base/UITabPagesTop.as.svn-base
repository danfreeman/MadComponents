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
 * AUTHORS' OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.</p>
 *
 * <p>Licensed under The MIT License</p>
 * <p>Redistributions of files must retain the above copyright notice.</p>
 */

package com.danielfreeman.extendedMadness
{
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextFormat;

/**
 *  MadComponents tabbed pages container
 * <pre>
 * &lt;tabPages
 *    id = "IDENTIFIER"
 *    colour = "#rrggbb"
 *    background = "#rrggbb, #rrggbb, ..."
 *    tabButtonColours = "#rrggbb, #rrggbb, ..."
 *    visible = "true|false"
 *    gapV = "NUMBER"
 *    gapH = "NUMBER"
 *    alignH = "left|right|centre"
 *    alignV = "top|bottom|centre"
 *    border = "true|false"
 *    mask = "true|false"
 *    alt = "true|false"
 * /&gt;
 * </pre>
 */
	public class UITabPagesTop extends UITabPages
	{
		protected static const LABEL_Y:Number = 40.0;
		protected static const ICON_Y:Number = 8.0;

		protected var _onFormat:TextFormat = new TextFormat("_sans",14);
		protected var _offFormat:TextFormat = new TextFormat("_sans",14);
		protected var _labels:Array = [];
		protected var _icons:Array = [];
		
		
		public function UITabPagesTop(screen:Sprite, xml:XML, attributes:Attributes) {
			_alt = xml.@alt == "true";
			xml.@alt = "";
			super(screen, xml, attributes);
			for each(var page:DisplayObject in _pages) {
				page.y = _buttonBar.height;
			}
			_attributes.y = _buttonBar.height;
			if (!_alt) {
				_onFormat.color = UITabButtonRow(_buttonBar).offColour;
				_offFormat.color = UITabButtonRow(_buttonBar).onColour;
			}
		}
		
		
		override protected function initialiseButtonBar(xml:XML, attributes:Attributes):void {
			if (_alt) {
				super.initialiseButtonBar(xml, attributes);
				_buttonBar.y = 0;
			}
			else {
				addChild(_buttonBar = new UITabButtonRow(this, xml, attributes));
				attributes.height -= _buttonBar.height;
			}
		}
		
		
		override protected function mouseDown(event:MouseEvent):void {
			if (_alt)
				super.mouseDown(event);
			else
				UITabButtonRow(_buttonBar).mouseDown();
		}
		
		
		override protected function mouseUp(event:MouseEvent):void {
			if (_alt) {
				super.mouseUp(event);
			}
			else {
				var oldPage:int = _page;
				goToPage(UITabButtonRow(_buttonBar).mouseUp());
				changeColours(oldPage, _page);
			}
		}


		/**
		 *  Rearrange the layout to new screen dimensions
		 */	
		override public function layout(attributes:Attributes):void {
			if (_alt) {
				super.layout(attributes);
				_buttonBar.y = 0;
			}
			else {
				_pagesAttributes = attributes.copy();
				_pagesAttributes.height -= _buttonBar.height;
				_pagesAttributes.y = _buttonBar.height+1;
				superLayout(_pagesAttributes);
			}
			for each(var page:DisplayObject in _pages) {
				page.y = _buttonBar.height;
			}
			if (!_alt) {
				UITabButtonRow(_buttonBar).layout(attributes);
			}
			spacing();
			_attributes = attributes.copy();
			_attributes.y = _buttonBar.height;
		}
		
		
		override public function set pageNumber(value:int):void {
			UITabButtonRow(_buttonBar).index = value;
			super.goToPage(value);
		}
		
		
		/**
		 *  Set the label and icon of a particular tab button
		 */
		override public function setTab(index:int, label:String, imageClass:Class = null):void {
			if (_alt) {
				super.setTab(index, label, imageClass);
			}
			else {
				var buttonWidth:Number = _attributes.width/_pages.length;
				if (!_labels[index])
					_labels[index] = new UILabel(_buttonBar, 0, 0);
				var uiLabel:UILabel = _labels[index];
				uiLabel.defaultTextFormat = index==_page ? _onFormat : _offFormat;
				uiLabel.text = label;
				uiLabel.x = index*buttonWidth+(buttonWidth-uiLabel.width)/2;
				uiLabel.y = LABEL_Y;
					
				if (_icons[index])
					_buttonBar.removeChild(_icons[index]);
				if (imageClass) {
					var icon:Sprite = new Sprite();
					_buttonBar.addChild(icon);
					icon.addChild(new imageClass());
					_icons[index] = icon;
					icon.y = ICON_Y;
					icon.x = index*buttonWidth+(buttonWidth-icon.width)/2;
				}
				
				if (index == _page)
					changeColours(-1, index);
			}
		}
		
		
		protected function spacing():void {
			var buttonWidth:Number = _attributes.width/_pages.length;
			for(var i:int=0; i<_labels.length; i++) {
				var uiLabel:UILabel = _labels[i];
				if (uiLabel)
					uiLabel.x = i*buttonWidth+(buttonWidth-uiLabel.width)/2;
			}
			for(var j:int=0; j<_icons.length; j++) {
				var icon:Sprite = _icons[j];
				if (icon)
					icon.x = j*buttonWidth+(buttonWidth-icon.width)/2;
			}
		}
		
		
		protected function changeColours(oldIndex:int, newIndex:int):void {
			if (oldIndex>=0 && _labels[oldIndex])
				UILabel(_labels[oldIndex]).setTextFormat(_offFormat);
			
			if (oldIndex>=0 && _icons[oldIndex])
				Sprite(_icons[oldIndex]).transform.colorTransform = new ColorTransform();
			
			if (_labels[newIndex])
				UILabel(_labels[newIndex]).setTextFormat(_onFormat);
			
			if (_icons[newIndex]) {
				var colourTransform:ColorTransform = new ColorTransform();
				colourTransform.color = UITabButtonRow(_buttonBar).offColour;
				Sprite(_icons[newIndex]).transform.colorTransform = colourTransform;
			}
		}
	}
}