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
	
	public class MadGroups extends Sprite
	{
		[Embed(source="images/palm_48.png")]
		protected static const PALM:Class;

		protected static const CONTACTS:XML = <vertical background="#E9E9EF,#EFEFEF,8" colour="#CCCCCC">
												<horizontal>
													<image>{getQualifiedClassName(PALM)}</image>
													<group>
														<input alignH="fill" prompt="First" alt="true" background="#FFFFFF,#FFFFFF,#FFFFFF"/>
														<input alignH="fill" prompt="Last" alt="true" background="#FFFFFF,#FFFFFF,#FFFFFF"/>
													</group>
												</horizontal>
													<clickableGroup gapV="30" id="clickableGroup">
														<horizontal lines="true">
															<label alignV="centre"><font size="14" color="#6666CC">phone:</font></label>
															<input alignH="fill" prompt="number" alt="true" background="#FFFFFF,#FFFFFF,#FFFFFF"/>
														</horizontal>
														<horizontal>
															<label alignV="centre">Freelance Developer</label>
															<arrow alignV="centre" alignH="right"/>
														</horizontal>
													</clickableGroup>
													<group gapV="30">
														<label>doc.android@gmail.com</label>
														<label>Mobile app developer</label>
													</group>
													<columns alignH="fill" colour="#666666">
														<button/>
														<button/>
														<button/>
													</columns>
											</vertical>;
		
		protected var _clickableGroup:UIForm;
		
		public function MadGroups(screen:Sprite = null)
		{
			if (screen)
				screen.addChild(this);
			
			stage.align = StageAlign.TOP_LEFT;  
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			UI.create(this, CONTACTS);
			
			_clickableGroup = UIForm(UI.findViewById("clickableGroup"));
			_clickableGroup.disableClickableGroupRows([0]);
			_clickableGroup.addEventListener(UIForm.CLICKED, clickHandler);
		}
		
		
		protected function clickHandler(event:Event):void {
			trace("row clicked="+_clickableGroup.index);
		}
	}
}