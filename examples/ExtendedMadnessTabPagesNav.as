package
{
	import com.danielfreeman.extendedMadness.*;
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	
	public class ExtendedMadnessTabPagesNav extends Sprite
	{
		protected static const PAGE1:XML =
			
			<label>This is page one</label>;
		

		protected static const PAGE2:XML =
			
			<label>This is page two</label>;
		
		
		protected static const PAGE3:XML =
			
			<label>This is page three</label>;
		
		
		protected static const NAVIGATION:XML =
			
			<navigation id="nav" leftArrow="" stageColour="#CCCCCC,#999999">
				{PAGE1}
				{PAGE2}
				{PAGE3}
			</navigation>;
				
		
		protected static const MENU:XML =
			
			<data>
				<one/>
				<two/>
				<three/>
			</data>;
		
		
		protected static const SEGMENTED:XML =
			
			<segmentedControl alt="true" width="180" background="#555566,#333366,4">
				<font color="#FFFFF" size="12"/>
				{MENU}
			</segmentedControl>;

		
		protected var _segmentedControl:UISegmentedControl;
		protected var _navigation:UINavigation;
		
		public function ExtendedMadnessTabPagesNav(screen:Sprite = null) {
			if (screen)
				screen.addChild(this);
			
			stage.align = StageAlign.TOP_LEFT;  
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			UIe.create(this, NAVIGATION);
			
			_navigation = UINavigation(UI.findViewById("nav"));
			var attributes:Attributes = new Attributes();
			attributes.parse(SEGMENTED);
			_segmentedControl = new UISegmentedControl(_navigation.navigationBar, SEGMENTED, attributes);
			_segmentedControl.addEventListener(Event.CHANGE, tabClicked);
			addEventListener(UI.RESIZED, resizedHandler);
			resizedHandler();
		}
		
		
		protected function tabClicked(event:Event):void {
			_navigation.goToPage(_segmentedControl.index);
		}
		
		
		protected function resizedHandler(event:Event = null):void {
			_segmentedControl.x = (_navigation.navigationBar.width - _segmentedControl.width) / 2;
			_segmentedControl.y = (_navigation.navigationBar.height - _segmentedControl.height) / 2;
		}
	}
}