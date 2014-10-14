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

	
	public class MadComponentsPicker extends Sprite {
		
		protected static const DATA:XML = <data>
	    									<Red/>
	        								<Orange/>
	        								<Yellow/>
	        								<Green/>
	        								<Blue/>
											<Indigo/>
	    									<Red/>
	        								<Orange/>
	        								<Yellow/>
	        								<Green/>
	        								<Blue/>
											<Indigo/>
	    									<Red/>
	        								<Orange/>
	        								<Yellow/>
	        								<Green/>
	        								<Blue/>
											<Indigo/>
										 </data>;
		
		protected static const PICKER_EXAMPLE:XML = <columns gapH="0" widths="40,50%,50%" pickerHeight="180">
															<picker id="column0" alignH="centre" index="0">
																<data>
																	<item label="0"/>
																	<item label="11"/>
																	<item label="2"/>
																	<item label="3"/>
																	<item label="4"/>
																	<item label="5"/>
																	<item label="6"/>
																	<item label="7"/>
																	<item label="8"/>
																	<item label="9"/>
																</data>
															</picker>
															<picker id="column1" index="1">
																{DATA}
															</picker>
															<picker id="column2" index="4">
																{DATA}
															</picker>
														</columns>;
																
																
		protected var _column0:UIPicker;
		protected var _column1:UIPicker;
		protected var _column2:UIPicker;
		
		
		public function MadComponentsPicker(screen:Sprite = null) {
			if (screen)
				screen.addChild(this);

			stage.align = StageAlign.TOP_LEFT;  
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			UI.create(this, PICKER_EXAMPLE);
			
			_column0 = UIPicker(UI.findViewById("column0"));
			_column1 = UIPicker(UI.findViewById("column1"));
			_column2 = UIPicker(UI.findViewById("column2"));
			
			_column0.addEventListener(Event.CHANGE, pickersChanged);
			_column1.addEventListener(Event.CHANGE, pickersChanged);
			_column2.addEventListener(Event.CHANGE, pickersChanged);
		}
		
		
		protected function pickersChanged(event:Event):void {
			trace("Picker indexes = "+_column0.index+","+_column1.index+","+_column2.index);
			trace("Picker values = "+_column0.row.label+","+_column1.row.label+","+_column2.row.label);
		}
	}
}