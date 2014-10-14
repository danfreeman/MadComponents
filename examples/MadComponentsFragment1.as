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


package {
	
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	public class MadComponentsFragment1 extends Sprite {
		
		protected static const FRUIT_DATA:XML = <data>
											<Apple/>
											<Orange/>
											<Banana/>
											<Pineapple/>
											<Lemon/>
											<Mango/>
											<Plum/>
											<Cherry/>
											<Lime/>
											<Peach/>
											<Pomegranate/>
											<Grapefruit/>
											<Strawberry/>
											<Melon/>
										</data>;
		
		
		protected static const LIST1:XML =
			
			<list gapV="16" background="#EEFFEE,#778877" colour="#000000">	
				{FRUIT_DATA}												
				<horizontal>
					<label id="label"><font color="#FFDDCC"/></label>
					<arrow colour="#FFDDCC" alignH="right"/>
				</horizontal>								
			</list>;
		
		
		protected static const LIST2:XML =
			
			<list background="#AAAACC,#AAAACC,#9999CC" colour="#AAAACC">
				{FRUIT_DATA}
				<font color="#FFFFFF"/>											
			</list>;
		
		
		protected static const NAVIGATOR:XML =

			<pages mask="true">
				<navigation id="nav" autoResize="false" title="lists" background="#FFFFFF" colour="#666677" autoTitle="label">
					{LIST1}
					{LIST2}
				</navigation>
			</pages>;


		public function MadComponentsFragment1(screen:Sprite = null) {
			if (screen)
				screen.addChild(this);
			
			stage.align = StageAlign.TOP_LEFT;  
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var fragment:Sprite = UI.create(this, NAVIGATOR, 320, 480);
			fragment.x = 200;
			fragment.y = 100;
		}
	}
}