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
	
	public class MadLists extends Sprite
	{		
		protected static const DATA:XML = <data>
											<Sneezy/>
											<Sleepy/>
											<Dopey/>
											<Doc/>
											<Happy/>
											<Bashful/>
											<Grumpy/>
										</data>;
		
		protected static const GROUPED_DATA:XML =
		
			<data>
				<group label="dwarfs">
					<Sneezy/>
					<Sleepy/>
					<Dopey/>
					<Doc/>
					<Happy/>
					<Bashful/>
					<Grumpy/>
				</group>
				<group label="reindeer">
					<Dasher/>
					<Dancer/>
					<Prancer/>
					<Vixen/>
					<Comet/>
					<Cupid/>
					<Donder/>
					<Blitzen/>
				</group>
			</data>
		
		protected static const LIST:XML = <list>
											{DATA}
										</list>;
		
		protected static const DIVIDED_LIST:XML = <dividedList>
			{GROUPED_DATA}
		</dividedList>;
		
		public function MadLists(screen:Sprite = null)
		{
			if (screen)
				screen.addChild(this);
			
			stage.align = StageAlign.TOP_LEFT;  
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			UI.create(this, DIVIDED_LIST);
		}
	}
}