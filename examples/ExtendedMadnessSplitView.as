package
{
	import com.danielfreeman.extendedMadness.*;
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	
	public class ExtendedMadnessSplitView extends Sprite
	{
		
		protected static const DATA:XML =
			
			<data>
				<Red/>
				<Orange/>
				<Yellow/>
				<Green/>
				<Blue/>
				<Indigo/>
				<Violet/>
			 </data>;
		
		
		protected static const DETAIL:XML =
			
			<vertical alignV="centre">
				<label id="label" alignH="centre" width="200"/>
			</vertical>;
		

		protected static const LAYOUT:XML =
			
			<splitView id="splitView" topColour="#666666">
				{DATA}
				{DETAIL}
			</splitView>;
				
		
		protected var _splitView:UISplitView;
		
		public function ExtendedMadnessSplitView(screen:Sprite = null) {
			
			if (screen)
				screen.addChild(this);
			
			stage.align = StageAlign.TOP_LEFT;  
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			UIe.createInWindow(this, LAYOUT);
			
			_splitView = UISplitView(UI.findViewById("splitView"));
			_splitView.list.addEventListener(UIList.CLICKED, listClicked);
			_splitView.navigationBar.text = "Split View";
		}
		
		
		protected function listClicked(event:Event):void {
			UIForm(_splitView.pages[0]).data = {label:_splitView.list.row.label};
		}
	}
}