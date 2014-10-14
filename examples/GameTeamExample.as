package {
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import com.danielfreeman.madcomponents.*;
	
	/**
	 * @author danielfreeman
	 */
	public class GameTeamExample extends Sprite {
			
			
		protected static const LAYOUT:XML =
		
			<navigation id="@pages" autoFill="true" title="Gaming Team" autoTitle="name">
			
				<list id="@listLoad" gapV="16" background="#CCCCCC">
					<model url="http://127.0.0.1/team.json" parse="people." action="loadJSON"/>
					<horizontal>
						<label id="name"/>
						<arrow alignH="right"/>
					</horizontal>
				</list>
				
				<vertical background="#999999">
					<label id="blog"/>
				</vertical>

			</navigation>;


		public function GameTeamExample(screen:Sprite = null) {
			if (screen)
				screen.addChild(this);

			stage.align = StageAlign.TOP_LEFT;  
			stage.scaleMode = StageScaleMode.NO_SCALE;

			UI.create(this, LAYOUT);
		}

	}
}
