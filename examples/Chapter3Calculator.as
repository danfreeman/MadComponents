package 
{
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	
	public class Chapter3Calculator extends Sprite {
		
		protected static const CALCULATOR:XML =
				
			<vertical>
				<columns alignH="fill">
					<input id="numberA"/>
					<input id="numberB"/>
				</columns>
				<columns alignH="fill">
					<button id="plus">+</button>
					<button id="minus">-</button>
				</columns>	
				<columns alignH="fill">
					<button id="multiply">*</button>
					<button id="divide">/</button>
				</columns>	
				<group>
					<label id="result"/>
				</group>
			</vertical>;	
		
		protected var _numberA:UIInput;
		protected var _numberB:UIInput;
		protected var _plus:UIButton;
		protected var _minus:UIButton;
		protected var _multiply:UIButton;
		protected var _divide:UIButton;
		protected var _result:UILabel;
		
		
		public function Chapter3Calculator(screen:Sprite = null) {
			if (screen)
				screen.addChild(this);
			
			stage.align = StageAlign.TOP_LEFT;  
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			UI.create(this, CALCULATOR);
			
			initialise();
			addEventListeners();
		}
		
		
		protected function initialise():void {
			_numberA = UIInput( UI.findViewById("numberA") );
			_numberB = UIInput( UI.findViewById("numberB") );
			_plus = UIButton( UI.findViewById("plus") );
			_minus = UIButton( UI.findViewById("minus") );
			_multiply = UIButton( UI.findViewById("multiply") );
			_divide = UIButton( UI.findViewById("divide") );
			_result = UILabel( UI.findViewById("result") );
		}
		
		
		protected function addEventListeners():void {
			_plus.addEventListener(UIButton.CLICKED, plusHandler);
			_minus.addEventListener(UIButton.CLICKED, minusHandler);
			_multiply.addEventListener(UIButton.CLICKED, multiplyHandler);
			_divide.addEventListener(UIButton.CLICKED, divideHandler);
		}
		
		
		protected function plusHandler(event:Event):void {
			_result.text = _numberA.text + " + " + _numberB.text + " = " + (parseFloat(_numberA.text) + parseFloat(_numberB.text)).toString();
		}
		
		
		protected function minusHandler(event:Event):void {
			_result.text = _numberA.text + " - " + _numberB.text + " = " + (parseFloat(_numberA.text) - parseFloat(_numberB.text)).toString();
		}
		
		
		protected function multiplyHandler(event:Event):void {
			_result.text = _numberA.text + " * " + _numberB.text + " = " + (parseFloat(_numberA.text) * parseFloat(_numberB.text)).toString();
		}
		
		
		protected function divideHandler(event:Event):void {
			_result.text = _numberA.text + " / " + _numberB.text + " = " + (parseFloat(_numberA.text) / parseFloat(_numberB.text)).toString();
		}
	}
}