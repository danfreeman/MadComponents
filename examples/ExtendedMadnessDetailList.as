package
{
	import asfiles.MyEvent;
	
	import com.danielfreeman.extendedMadness.*;
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.utils.getQualifiedClassName;
	
	
	public class ExtendedMadnessDetailList extends Sprite
	{
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
		
		
		protected static const DETAIL_LIST:XML =
			
			<detailList background="#FFFFFF,#F6F6F6">
				{FRUIT_DATA}
				<detail border="true" darkenColour="#F9F9F9" shadowColour="#D6D6D6" background="#D6D6D6">				
					<columns>
						<vertical>
							<checkBox id="option1">option 1</checkBox>
							<checkBox id="option2">option 2</checkBox>
							<checkBox id="option3">option 3</checkBox>
						</vertical>
						<vertical>
							<radioButton id="radio1">radio 1</radioButton>
							<radioButton id="radio2">radio 2</radioButton>
							<radioButton id="radio3">radio 3</radioButton>
						</vertical>
					</columns>
				</detail>
			</detailList>;
		
		
		public function ExtendedMadnessDetailList(screen:Sprite = null)
		{
			if (screen)
				screen.addChild(this);
			
			stage.align = StageAlign.TOP_LEFT;  
			stage.scaleMode = StageScaleMode.NO_SCALE;

			UIe.create(this, DETAIL_LIST);
		}
	}
}