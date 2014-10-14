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
package
{
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	
	public class MadComponentsDividedList extends Sprite {
		
		
		protected static const DIVIDED_LIST:XML = <dividedList id="list" autoLayout="true">
													<horizontal>
														<image id="image">48</image>
														<vertical>
															<label id="label"/>
															<label id="label2"/>
														</vertical>
														<label alignH="right" alignV="bottom" id="price"/>
													</horizontal>
												</dividedList>;
		
		protected static const DETAIL_PAGE:XML = <vertical> 
													<image id="image" alignH="centre" alignV="centre"/>
												</vertical>;
		
		protected static const NAVIGATION:XML = <navigation autoFill="true">
													{DIVIDED_LIST}
													{DETAIL_PAGE}
												</navigation>;
		
		protected static const BIG_FONT:String = '<font size="18">';
		protected static const SMALL_FONT:String = '<font size="11">';
		protected static const END_FONT:String = '</font>';
		
		protected var _dividedList:UIDividedList;
			
			
		[Embed(source="images/mp3_48.png")]
		protected static const MP3:Class;
			
		[Embed(source="images/MP4_48.png")]
		protected static const MP4:Class;
		
		
		public function MadComponentsDividedList(screen:Sprite = null) {
			if (screen)
				screen.addChild(this);
			
			stage.align = StageAlign.TOP_LEFT;  
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			UI.create(this, NAVIGATION);
			
			var data0:Array = [{label:BIG_FONT+"mp3 player"+END_FONT, image:getQualifiedClassName(MP3), label2:SMALL_FONT+"some small text"+END_FONT, price:"$19.99"},{label:BIG_FONT+"mp4 player"+END_FONT, image:getQualifiedClassName(MP4), label2:SMALL_FONT+"more small text"+END_FONT, price:"$79.99"}];
			// to do: make data1 and data2
			var list:UIDividedList = UIDividedList(UI.findViewById("list"));
			list.data = ["processor",data0,"storage",data0,"memory",data0];
			
		}
		
	}
}