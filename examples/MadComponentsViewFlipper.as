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
	import flash.utils.getQualifiedClassName;
	
	
	public class MadComponentsViewFlipper extends Sprite {
		
		[Embed(source="images/buddha.jpg")]
		protected static const BUDDHA:Class;
		
		[Embed(source="images/dragon.jpg")]
		protected static const DRAGON:Class;
		
		[Embed(source="images/faces.jpg")]
		protected static const FACES:Class;
		
		[Embed(source="images/monks.jpg")]
		protected static const MONKS:Class;
		
		[Embed(source="images/temple.jpg")]
		protected static const TEMPLE:Class;

		//Notice three parameters for <image>.  width,height,image
		
		protected static const VIEWFLIPPER:XML =
		
			<rows heights="50%,220,50%" stageColour="#223322,#112211,6,0">
				<group background="#112211">													
					<label alignH="centre"><font color="#99CC99" size="20">View Flipper Gallery</font></label>
				</group>
				<columns widths="50%,256,50%">
					<image/>															
					<viewFlipper scrollBarColour={Attributes.TRANSPARENT}>
						<image>256,192,{getQualifiedClassName(BUDDHA)}</image>
						<image>256,192,{getQualifiedClassName(DRAGON)}</image>
						<image>256,192,{getQualifiedClassName(FACES)}</image>
						<image>256,192,{getQualifiedClassName(MONKS)}</image>
						<image>256,192,{getQualifiedClassName(TEMPLE)}</image>
					</viewFlipper>
					<image/>
				</columns>
			<image/>
		</rows>;
		
		
		public function MadComponentsViewFlipper(screen:Sprite = null) {

			if (screen) {
				screen.addChild(this);
			}
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			UI.create(this, VIEWFLIPPER);
	
		}
		
	}
}