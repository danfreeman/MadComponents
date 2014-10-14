package
{
	import asfiles.MyEvent;
	
	import com.danielfreeman.extendedMadness.*;
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	
	public class ExtendedMadnessInWindow extends Sprite
	{
		
		protected static const MATRIX:XML = <data>
			<row>1,2,3,4</row>
			<row>3,8,4,1</row>
			<row>4,1,5,12</row>
			<row>7,14,0,4</row>
			<row>6,8,3,1</row>
			<row>5,7,9,2</row>
		</data>;
		
		protected static const NUMBERS:XML = <data>3,5,4,2,1</data>;
		
		
		protected static const COLOURS:XML = <colours>#99FF99,#CC9999,#9999CC,#CCCC66,#CC9966</colours>;


		protected static const DATAGRID:XML = <dataGrid>
												<widths>20,15,30,35</widths>
												<header>name,age,aaa,bbb</header>
													{MATRIX}
											</dataGrid>;


		protected static const DATA:XML = <data>
											<Apple/>
											<Orange/>
											<Banana/>
											<Pineapple/>
											<Lemon/>
										</data>;


		protected static const LAYOUT:XML = <scrollBarVertical height="600">
												<columns widths="500,100%">
													<vertical>
														<menu id="menu" value="Apple" width="200">
														<font size="20"/>
															{DATA}
														</menu>
														<menu value="Apple" alt="true">
															{DATA}
														</menu>
														<segmentedControl id="segmentedControl" width="500">
															{DATA}
														</segmentedControl>
														<segmentedControl alt="true" background="#EEDDCC,#AA9933">
															{DATA}
														</segmentedControl>
														<checkBox id="checkBox"/>
														<checkBox alt="true"/>
														<columns widths="50,50,50" id="radioButtons">
															<radioButton id="first"/>
															<radioButton id="second"/>
															<radioButton id="third"/>
														</columns>
														<columns widths="30,30,30">
															<radioButton alt="true"/>
															<radioButton alt="true"/>
															<radioButton alt="true"/>
														</columns>
													</vertical>
													<rows gapV="0">
														<columns>
															{DATAGRID}
															<horizontalChart id="hChart" render="2D" palette="subtle" paletteStart="2"/>
														</columns>
														<columns>
															<pieChart>{COLOURS}{NUMBERS}</pieChart>
															<barChart stack="true" order="rows">{MATRIX}</barChart>
														</columns>
														<columns>
															<lineChart>{MATRIX}</lineChart>
															<scatterChart palette="greyscale0">{NUMBERS}</scatterChart>
														</columns>
													</rows>
												</columns>
											</scrollBarVertical>;


		protected var _segmentedControl:UISegmentedControl;
		protected var _checkBox:UICheckBox;
		protected var _radioButtons:UIPanel;
		
		
		public function ExtendedMadnessInWindow(screen:Sprite = null)
		{
			if (screen)
				screen.addChild(this);
			
			stage.align = StageAlign.TOP_LEFT;  
			stage.scaleMode = StageScaleMode.NO_SCALE;

			UIe.createInWindow(this, LAYOUT);
			
			new UICutCopyPaste(this, 300, 10, 50);

			new AlertMessage(this, "Extended Madness Demo", "ok");

			var menu:UIMenu = UIMenu(UI.findViewById("menu"));
			menu.addEventListener(UIMenu.SELECTED, menuSelected);

			_segmentedControl = UISegmentedControl(UI.findViewById("segmentedControl"));
			_segmentedControl.addEventListener(Event.CHANGE, segmentedControlChanged);
			
			_checkBox = UICheckBox(UI.findViewById("checkBox"));
			_checkBox.addEventListener(Event.CHANGE, checkBoxChanged);

			_radioButtons = UIPanel(UI.findViewById("radioButtons"));
			_radioButtons.addEventListener(UIRadioButton.TOGGLE, radioButtonsChanged);
			
			
			var hGraph:UIHorizontalChart = UIHorizontalChart(UI.findViewById("hChart"));
		//	hGraph.data = [[4,3,2,5,6]];
			hGraph.xmlData = <data>4,3,2,5,6</data>;
		}
		
		
		protected function menuSelected(event:MyEvent):void {
			trace("menu: "+event.parameters[0]+" "+event.parameters[1]);
		}
		
		
		protected function segmentedControlChanged(event:Event):void {
			trace("segmented control: "+_segmentedControl.index);
		}
		
		
		protected function checkBoxChanged(event:Event):void {
			trace("check box:"+_checkBox.state);
		}
		
		
		protected function radioButtonsChanged(event:MyEvent):void {
			trace("radio button: "+UIRadioButton(event.parameters[0]).name);
		}
	}
}