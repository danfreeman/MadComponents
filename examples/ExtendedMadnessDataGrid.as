package
{
	import asfiles.MyEvent;
	
	import com.danielfreeman.extendedMadness.*;
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	
	public class ExtendedMadnessDataGrid extends Sprite
	{
		        protected static const DATA_GRID:XML = <vertical>
														<dataGrid colour="#999999" background="#888899,#EEEEFF,#DDDDEE">
		                                                <widths>30,30,40</widths>
		                                                <header>one,two,three</header>
		                                                <data>
		                                                    <row>1,2,3</row>
		                                                    <row>4,5,6</row>
		                                                    <row>7,8,9</row>
		                                                    <row>2,7,5</row>
		                                                    <row>1,2,3</row>
		                                                    <row>4,5,6</row>
		                                                    <row>7,8,9</row>
		                                                    <row>2,7,5</row>
		                                                </data>
		                                            </dataGrid>
													</vertical>;
		
		
		public function ExtendedMadnessDataGrid(screen:Sprite = null)
		{
			if (screen)
				screen.addChild(this);
			
			stage.align = StageAlign.TOP_LEFT;  
			stage.scaleMode = StageScaleMode.NO_SCALE;

			UIe.create(this, DATA_GRID);
		}
	}
}