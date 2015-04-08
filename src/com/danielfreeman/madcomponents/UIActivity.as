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
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.</p>
 *
 * <p>Licensed under The MIT License</p>
 * <p>Redistributions of files must retain the above copyright notice.</p>
 */

package com.danielfreeman.madcomponents {
	
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

/**
 * A rotating activity indicator component
 */	
	public class UIActivity extends Sprite {
		
		public static var SPOKES:int = 12;
		public static var INTERVAL:int = 100;
		
		protected static const INNER:Number = 16.0;
		protected static const OUTER:Number = 40.0;
		protected static const THICKNESS:Number = 4.0;
		protected static const INCREMENT:int = 8;
		protected static const DEGTORAD:Number = 2*Math.PI;
		
		protected var timer:Timer = new Timer(INTERVAL);

		public function UIActivity(screen:Sprite, xx:Number, yy:Number, visible:Boolean = false, colour:uint = 0xFFFFFF) {
			screen.addChild(this);
			x=xx;y=yy;
			drawActivityIndicator(colour);
			timer.addEventListener(TimerEvent.TIMER,rotateHandler);
			mouseEnabled = false;
			super.visible = visible;
		}
		
		
		protected function rotateHandler(event:TimerEvent):void {
			rotation+=360/SPOKES;
		}
		
		
		protected function drawActivityIndicator(colour:uint):void {
			for (var i:int = 1; i<=SPOKES; i++) {
				graphics.lineStyle(THICKNESS,Colour.darken(colour,-i*INCREMENT));
				graphics.moveTo(-INNER*Math.sin(DEGTORAD*i/SPOKES),-INNER*Math.cos(DEGTORAD*i/SPOKES));
				graphics.lineTo(-OUTER*Math.sin(DEGTORAD*i/SPOKES),-OUTER*Math.cos(DEGTORAD*i/SPOKES));
			}
		}
		
/**
 * Enable or disable rotation
 */	
		public function set rotate(value:Boolean):void {
			if (value) {
				timer.reset();
				timer.start();
			}
			else {
				timer.stop();
			}
			super.visible = true;
		}
		
/**
 * Rotation is started if the component is made visible, and halted when visible = false
 */	
		public function set isVisible(value:Boolean):void {
			rotate = value;
			visible = value;
		}
		
		
		public function destructor():void {
			timer.removeEventListener(TimerEvent.TIMER,rotateHandler);
		}
	}
}