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
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class UITouch extends UIContainerBaseClass {
		
		protected var _up:UIForm;
		protected var _down:UIForm;
		
		public function UITouch(screen:Sprite, xml:XML, attributes:Attributes) {
			super(screen, xml, attributes);
			var childAttributes:Attributes = attributes.copy(xml);
			_up = new UI.FormClass(this, <up>{xml.children()[0]}</up>, childAttributes);
			_down = new UI.FormClass(this, <down>{xml.children()[1]}</down>, childAttributes);
			_down.visible = false;
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		}
		
		
		override public function touchCancel():void {
			mouseUp();
		}
		
		
		override public function layout(attributes:Attributes):void {
			var childAttributes:Attributes = attributes.copy(_xml);
			_up.layout(childAttributes);
			_down.layout(childAttributes);
		}
		
		
		protected function mouseDown(event:MouseEvent):void {
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			_up.visible = false;
			_down.visible = true;
		}
		
		
		protected function mouseUp(event:MouseEvent = null):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			_up.visible = true;
			_down.visible = false;
		}
		
		
		override public function destructor():void {
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
	}
}