package
{
	import com.danielfreeman.extendedMadness.*;
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	public class ExtendedMadnessTabPagesTop extends Sprite
	{
		[Embed(source="images/thailand.png")]
		protected static const THAILAND:Class;
		
		[Embed(source="images/options.png")]
		protected static const OPTIONS:Class;
		
		[Embed(source="images/zoomin.png")]
		protected static const ZOOMIN:Class;
		
		[Embed(source="images/arrow.png")]
		protected static const ARROW:Class;
		
		protected static const WHITE_TEXT:XML = <font color="#EEEEEE"/>;
		
		
		protected static const FRUIT_DATA:XML =
			
			<data>
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

								
		protected static const PAGE:XML =
			
			<vertical alignH="fill" colour="#999999">
				<input prompt="input:"/>
				<columns>
					<button>button</button>
					<button>button</button>
				</columns>
				<image/>
				<checkBox>{WHITE_TEXT}Checkbox 1</checkBox>
				<checkBox>{WHITE_TEXT}Checkbox 2</checkBox>
				<image/>
				<vertical>
					<radioButton>{WHITE_TEXT}Radio Button 1</radioButton>
					<radioButton>{WHITE_TEXT}Radio Button 2</radioButton>
					<radioButton>{WHITE_TEXT}Radio Button 3</radioButton>
				</vertical>
				<starRating value="3"/>
				<segmentedControl alignV="bottom" background="#CCCCCC,#333333">
					<data>
						<one/>
						<two/>
						<three/>
					</data>
				</segmentedControl>
			</vertical>;
		
		
		protected static const SCROLLXY:XML =
			
			<scrollXY mask="true" tapToScale="2.0" stageColour="#666666" scrollBarColour="#FFFFFF" width="480" height="640" border="false" id="scroller">
				<image>
					{getQualifiedClassName(THAILAND)}
				</image>
			</scrollXY>;
		
		
		protected static const LIST:XML =
			
			<list mask="true" scrollBarColour="#FFFFFF">
				{WHITE_TEXT}
				{FRUIT_DATA}
			</list>;
		
		
		protected static const TAB_LAYOUT:XML = 
			
			<tabPagesTop id="tabs" stageColour="#333333">
				{PAGE}
				{SCROLLXY}
				{LIST}
			</tabPagesTop>;
				
				
		
		public function ExtendedMadnessTabPagesTop(screen:Sprite = null)
		{
			if (screen)
				screen.addChild(this);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			UIList.HIGHLIGHT = 0xFF9933;
			UIe.create(this, TAB_LAYOUT);
			
			var tabPages:UITabPagesTop = UITabPagesTop(UI.findViewById("tabs"));
			tabPages.setTab(0, "U.I.", OPTIONS);
			tabPages.setTab(1, "scrollXY", ZOOMIN);
			tabPages.setTab(2, "List", ARROW);
		}
	}
}