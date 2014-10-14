package {

	import flash.utils.getQualifiedClassName;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import com.danielfreeman.madcomponents.*;
	import com.danielfreeman.extendedMadness.*;
	import flash.utils.getQualifiedClassName;
	import flash.events.Event;

	public class ExtendedMadnessScreens extends Sprite {


		protected static const LANDSCAPE_SMALL:XML =
			
			<vertical size="L320x220">
				<label>320 x 220 landscape layout</label>
				<button id="button">button</button>
			</vertical>;

	
		protected static const PORTRAIT_SMALL:XML =
		
			<vertical size="P240x295">
				<label>240 x 295 portrait layout</label>
				<button id="button">button</button>
			</vertical>;
			
			
		protected static const LANDSCAPE_MEDIUM:XML =
		
			<vertical size="L420x295">
				<label>420 x 295 landscape layout</label>
				<button id="button">button</button>
			</vertical>;
			
			
		protected static const PORTRAIT_MEDIUM:XML =
		
			<vertical size="P290x330">
				<label>290 x 330 portrait layout</label>
				<button id="button">button</button>
			</vertical>;
			
			
		protected static const LAYOUT:XML =
		
				<screens id="screens" lazyRender="true" recycle="true">
					{LANDSCAPE_SMALL}
					{PORTRAIT_SMALL}
					{LANDSCAPE_MEDIUM}
					{PORTRAIT_MEDIUM}
				</screens>;
				
				
		protected var _screens:UIScreens;
		protected var _button:UIButton = null;
				
		
		public function ExtendedMadnessScreens(screen:Sprite = null) {
			
			if (screen)
				screen.addChild(this);

			stage.align = StageAlign.TOP_LEFT;  
			stage.scaleMode = StageScaleMode.NO_SCALE;

			UIe.create(this, LAYOUT);
			
			_screens = UIScreens(UI.findViewById("screens"));
			_screens.addEventListener(UIScreens.SCREEN_CHANGED, addListeners);
		}
		
		
		protected function addListeners(event:Event):void {
			if (_button) {
				_button.removeEventListener(UIButton.CLICKED, buttonClicked);
			}
			_button = UIButton(_screens.findViewById("button"));
			_button.addEventListener(UIButton.CLICKED, buttonClicked);
		}
		
		
		protected function buttonClicked(event:Event):void {
			trace("button clicked");
		}
	}
}