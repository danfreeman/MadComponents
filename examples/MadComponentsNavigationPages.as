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
	
	
	public class MadComponentsNavigationPages extends Sprite {
		
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
		
		
		protected static const PAGE0:XML = <image alignV="centre" alignH="centre">{getQualifiedClassName(BUDDHA)}</image>
		
		protected static const PAGE1:XML = <image alignV="centre" alignH="centre">{getQualifiedClassName(DRAGON)}</image>
		
		protected static const PAGE2:XML = <image alignV="centre" alignH="centre">{getQualifiedClassName(FACES)}</image>
		
		protected static const PAGE3:XML = <image alignV="centre" alignH="centre">{getQualifiedClassName(MONKS)}</image>
		
		protected static const PAGE4:XML = <image alignV="centre" alignH="centre">{getQualifiedClassName(TEMPLE)}</image>
		
		
		protected static const MENU0:XML =
			
			<data>
				<buddha/>
				<dragon/>
				<item label="more..."/>
			</data>;
		
		
		protected static const MENU1:XML =
			
			<data>
				<faces/>
				<monks/>
				<temple/>
			</data>;
		
		
		protected static const NESTED_NAVIGATION_PAGES:XML =
		
			<navigationPages title="Nested Nav">
				<list>													
					{MENU0}
				</list>
				{PAGE0}
				{PAGE1}
				<navigationPages>
					<list>													
						{MENU1}
					</list>
					{PAGE2}
					{PAGE3}
					{PAGE4}
				</navigationPages>
			</navigationPages>;
		
		
		public function MadComponentsNavigationPages(screen:Sprite = null) {
			
			if (screen) {
				screen.addChild(this);
			}
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			UI.create(this, NESTED_NAVIGATION_PAGES);
			
		}
		
	}
}