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

package com.danielfreeman.madcomponents {
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;

/**
 * A list row was initiated - although we don't yet know whether this is a click or a scroll.
 */
	[Event( name="clickStart", type="flash.events.Event" )]
	
/**
 * A list row was clicked.  This is a bubbling event.
 */
	[Event( name="clicked", type="flash.events.Event" )]

/**
 * A list row was clicked.
 */
	[Event( name="listClickedEnd", type="flash.events.Event" )]

/**
 * A list click was cancelled.  This was a scroll, not a click.  
 */
	[Event( name="listClickCancel", type="flash.events.Event" )]
	
/**
 * A list row was long-clicked.
 */
	[Event( name="longClick", type="flash.events.Event" )]

/**
 * The Pull-Down-To-Refresh header was activated
 */
	[Event( name="pullRefresh", type="flash.events.Event" )]

/**
 * A heading (or an area outside a list row) was clicked
 */
	[Event( name="headingClicked", type="flash.events.Event" )]
	

/**
 *  MadComponents Grouped List
 * <pre>
 * &lt;groupedList
 *    id = "IDENTIFIER"
 *    colour = "#rrggbb"
 *    background = "#rrggbb, #rrggbb, ..."
 *    visible = "true|false"
 *    gapV = "NUMBER"
 *    gapH = "NUMBER"
 *    border = "true|false"
 *    lines = "true|false"
 *    pullDownRefresh = "true|false"
 *    pullDownColour = "#rrggbb"
 *    sortBy = "IDENTIFIER"
 *    mask = "true|false"
 *    alignV = "scroll|no scroll"
 *    highlightPressed = "true|false"
 *    autoLayout = "true|false"
 *    headingTextColour = "#rrggbb"
 *    headingShadowColour = "#rrggbb"
 *    arrows = "true|false"
 *    labelField = "STRING"
 *    lineGap = "NUMBER"
 *    style7 = "true|false"
 * /&gt;
 * </pre>
 */
	public class UIGroupedList extends UIList {
		
		public static const HEADING_CLICKED:String="headingClicked";
		protected static const STRIPE_WIDTH:Number = 8.0;
		protected static const PADDING:Number = 10.0;
		protected static const CELL_COLOUR:uint = 0xFFFFFF;
		protected static var CURVE:Number = 8.0;
		protected static var CURVE7:Number = 4.0;
		protected const BLACK:TextFormat = new TextFormat("Tahoma",17,0x555566);
		protected const WHITE:TextFormat = new TextFormat("Tahoma",17,0xFCFCFC);
		protected static const GROUP_SPACING:Number = 45;
		
		public static var HEADING:Class = null;
		
		protected var _cellWidth:Number;
		protected var _length:Number;
		protected var _groupPositions:Array;
		protected var _group:int = -1;
		protected var _heading:* = null;
		protected var _hasHeadings:Boolean = false;
		protected var _groupDetails:Object;
		protected var _headingFormat:TextFormat = BLACK;
		protected var _shadowFormat:TextFormat = WHITE;
		protected var _autoLayoutGroup:Boolean;
		protected var _gapBetweenGroups:Number = 0;
		protected var _alwaysAutoLayout:Boolean = false;
		protected var _cellLeft:Number = 0;
		protected var _saveGroup:int = -1;
		protected var _headingClicked:Boolean = false;
		protected var _topGroupSpacing:Number = 0;
		protected var _groupSpacing:int = 0;
		
		
		public function UIGroupedList(screen:Sprite, xml:XML, attributes:Attributes) {
			_autoLayoutGroup = xml.@autoLayout == "true";
			if (xml.@headingTextColour.length() > 0) {
				_headingFormat.color = UI.toColourValue(xml.@headingTextColour);
			}
			if (xml.@headingShadowColour.length() > 0) {
				_shadowFormat.color = UI.toColourValue(xml.@headingShadowColour);
			}
			_groupSpacing = ((xml.@groupSpacing.length() > 0) ? parseFloat(xml.@groupSpacing) : defaultGroupSpacing);// - (_autoLayoutGroup ? GROUP_SPACING : 0);
			_topGroupSpacing = ((xml.@topGroupSpacing.length() > 0) ? parseFloat(xml.@topGroupSpacing) : _groupSpacing);
			super(screen, xml, attributes);
			_autoLayout = false;
		}
		
		
		protected function get defaultGroupSpacing():Number {
			return GROUP_SPACING;
		}


/**
 *  Dynamically set the list renderer
 */
 		override public function set rendererXML(value:XML):void {
			_renderer = value;
			_simple = value == null;
			_autoLayoutGroup = !_simple && _xml.@autoLayout == "true";
		}


		override protected function mouseUp(event:MouseEvent):void {
			super.mouseUp(event);
			if (_headingClicked) {
				headingClicked();
			}
		}
		
		
		override protected function mouseDown(event:MouseEvent):void {
			_saveGroup = _group;
			_headingClicked = false;
			super.mouseDown(event);
		}
		
		
		override protected function doCancel():void {
			_pressedCell = _saveIndex;
			_group = _saveGroup;
			_headingClicked = false;
			dispatchEvent(new Event(CLICK_CANCEL, true));
			if (_showPressed && _pressedCell >= _header && _group < _groupPositions.length) {
				drawHighlight();
			}
		}
		
		
		override public function touchCancel():void {
			super.touchCancel();
			_headingClicked = false;
		}
		
/**
 *  Draw background
 */
		override public function drawComponent():void {
			var hasBackground:Boolean = _colours && _colours.length>0;
			graphics.clear();
			if (_attributes.style7) {
				graphics.beginFill(hasBackground ? _colours[0] : _attributes.colour);
			}
			else if (hasBackground) {
				var matr:Matrix=new Matrix();
				matr.createGradientBox(STRIPE_WIDTH,_attributes.height, 0, 0, 0);
				var colour:uint = _colours[0];
				graphics.beginGradientFill(GradientType.LINEAR,[colour,Colour.lighten(colour),Colour.lighten(colour,40)], [1.0,1.0,1.0], [0x00,0x33,0xff], matr,SpreadMethod.REPEAT);
			}
			else {
				graphics.beginFill(0,0);
			}
			graphics.drawRect(0, 0, _attributes.width, _attributes.height);
		}
		
		
		protected function setCellSize():void {
			_cellLeft = _attributes.x + _attributes.paddingH - PADDING;
			_cellWidth = _attributes.width - 2 * _attributes.paddingH + 2 * PADDING;
		}
		
		
		protected function setGroupedData(value:Array):void {

			_saveGroup = _group;
			_saveIndex = -1;
			_filteredData = noHeadings(value);
			initDrawGroups();
			clearCellGroups();
			setCellSize();
			_cellTop =  _top + _topGroupSpacing;
			_groupPositions = [];
			_group = 0;
			for each(var group:* in value) {
				if (!(group is Array)) {
					_heading = group;
				}
				else {
					_suffix = "_"+_group.toString();
					_length = group.length;
					_groupDetails = {top:_cellTop, length:_length, bottom:0, cellHeight:0, visible:true};
					if (!_heading) {
						_heading = "";
					}
				//	var cellTop:Number = _cellTop;
					super.data0 = group;
					_groupDetails.cellHeight = (_simple && _autoLayoutGroup) ? _cellHeight : (_cellTop - _groupDetails.top) / group.length;
					_groupDetails.bottom = _cellTop;
					_groupPositions.push(_groupDetails);
					_cellTop += _groupSpacing; //4 * _attributes.paddingV;
					_group++;
				}
		//		doLayout();
			}
	//		if (_autoLayoutGroup) {
				doLayout();
	//		}
			_group = _saveGroup;
		}
		
/**
 *  Assign to list by passing an array of objects
 */
		override public function set data(value:Object):void {
			setGroupedData(_data = value as Array);
		}
		
		
		public function refresh():void {
			data = _data;
		}
		
		
		override public function doClickRow(dispatch:Boolean = true):Boolean {
			clearPressed();
			_showPressed = true;
			if (dispatch) {
				pressButton();
			}
			else {
				if (isPressButton()) {
					drawHighlight();
				}
			}
			return dispatch && _pressedCell >= _header && _pressedCell < _count;
		}
		
/**
 *  Returns the data array of ojects without the headings
 */
		protected function noHeadings(value:Array):Array {
			var result:Array = [];
			for each (var group:* in value) {
				if (group is Array)
					result.push(group);
			}
			return result;
		}
		
/**
 *  Returns the data object for the last row clicked
 */
		override public function get row():Object {
			return (_group>=0 && _pressedCell>=0 && _filteredData && _filteredData[_group]) ? _filteredData[_group][_pressedCell] : null;
		}
		
		
		protected function simpleAutoLayoutFix(oldGroupDetails:Object):void {
			if (oldGroupDetails) {
				oldGroupDetails.bottom = oldGroupDetails.top + _cellHeight * oldGroupDetails.length; //groupDetails.top - _groupSpacing - _gapBetweenGroups - _attributes.paddingV;
			}
		}
		
		
		override protected function dealWithArrows(count:int, position:Number):void {
			if (_arrows && (_header > 0 ? count >= _header : count < _length + _header)) {
				drawArrow(_width - _attributes.paddingH, (_lastPosition + position) / 2);
			}
		}
		
/**
 *  Redraw cell chrome
 */
		
		override protected function redrawCells():void {
			var autoLayout:Boolean = _alwaysAutoLayout || !_simple && _autoLayoutGroup;
			setCellSize();
			var saveGroup:int = _group;
			var oldGroupDetails:Object = null;
			var groupHeight:Number;
			_group = 0;
			var last:Number = _topGroupSpacing+ _top;
			for each(var groupDetails:Object in _groupPositions) {
				_length = groupDetails.length;
				if (autoLayout) {
					groupDetails.top = last;
					var heading:DisplayObject = _slider.getChildByName("heading_"+_group.toString());
					if (heading) {
						heading.y = last + _attributes.paddingV + 2;
						last = groupDetails.top = Math.max(heading.y + heading.height, last + 3*_attributes.paddingV) + _attributes.paddingV;
						var shadow:DisplayObject = _slider.getChildByName("shadow_"+_group.toString());
						if (shadow) {
							shadow.y = heading.y + 1;
						}
					}
				}
				_cellTop = groupDetails.top;
				headingChrome();
				if (groupDetails.visible) {
					var cellHeight:int;
					for (var i:int=0; i<_length; i++) {
						cellHeight = groupDetails.cellHeight;
						if (autoLayout) {
							var renderer:DisplayObject = byGroupAndRow(_group,i);
							if (!_simple) {
								cellHeight = Math.ceil(renderer.height + 2 * _attributes.paddingV);
							}
							renderer.y = last + _attributes.paddingV * (_simple ? 2.0 : 1.0);
							last += cellHeight;
	
						}
						if (cellHeight > 0) {
							var record:Object = _filteredData[_group][i];
							drawCell(_cellTop + cellHeight, i, record);
						}
					}

				}
				else {
					last += _groupSpacing;
				}
				_group++;
				last += _groupSpacing;
				
				if (!_simple && autoLayout && groupDetails.visible) {
					groupDetails.bottom = last;
				}
				if (_alwaysAutoLayout) {
					last = last - 15;
					groupDetails.bottom = last + 5;
				}
				else if (_simple && _autoLayout) {
					groupDetails.bottom = _cellTop = _slider.getBounds(_slider).bottom + _attributes.paddingH;
					simpleAutoLayoutFix(oldGroupDetails);
				}
				oldGroupDetails = groupDetails;
			}
			_group = saveGroup;
		}
		
		
		protected function headingChrome():void {
		}
		
		
		override public function clear():void {
			data = [[]];
		}
		
		
		override protected function calculateMaximumSlide():void {
			super.calculateMaximumSlide();
			if (_maximumSlide > 0) {
				_maximumSlide += (!_simple && _autoLayoutGroup) ? _attributes.paddingH : 3 * _attributes.paddingH;
			}
		}
		
		
		protected function superCalculateMaximumSlide():void {
			super.calculateMaximumSlide();
		}
		
		
		protected function positionHeading(top:Number, heading:DisplayObject):void {
			heading.y = top - Math.min(_groupSpacing / 3, 10); // + heading.height; //(_groupSpacing + (_autoLayoutGroup ? GROUP_SPACING : 0) - heading.height) / 2;
		}
		
/**
 *  Draw group heading
 */
		override protected function initDraw():void {
			if (_heading) {
				var heading:DisplayObject;
				var shadow:DisplayObject = null;
				var top:Number = _cellTop - 4 * _attributes.paddingV;
				if (_heading is String) {
					shadow = new UILabel(_slider, _attributes.paddingH+1, top+_attributes.paddingV / 2+1, _heading, _shadowFormat);
					shadow.name = "shadow_" + _group.toString();
					heading = new UILabel(_slider, _attributes.paddingH, top+_attributes.paddingV / 2, _heading, _headingFormat);
					heading.visible = shadow.visible = _heading != "";
				}
				else if (_heading is Class) {
					_slider.addChild(heading = new _heading());
				}
				else {
					_slider.addChild(heading = _heading);
				}
				heading.x = _attributes.paddingH;
				positionHeading(_cellTop, heading);
				if (shadow) {
					shadow.y = heading.y + 1;
				}
				_heading = null;
				_cellTop += heading.height;
				_groupDetails.top = _cellTop;
				heading.name = "heading_"+_group.toString();
				_gapBetweenGroups = 2*_attributes.paddingV;
			}
			_lastPosition = _cellTop;
		}
		
		
		override protected function clearCells():void {
		}
		
		
		protected function clearCellGroups():void {
			super.clearCells();
			_lastPosition = _cellTop = 0;
		}
		
		
		protected function initDrawGroups():void {
			_slider.graphics.clear();
		//	resizeRefresh();
			_slider.graphics.beginFill(0,0);
			_slider.graphics.drawRect(0,-4*_attributes.paddingV-(_refresh ? TOP : 0),1,1);
			_lastPosition = _cellTop;
		}
		
/**
 *  Rearrange the layout to new screen dimensions
 */	
		override public function layout(attributes:Attributes):void {
			initDrawGroups();
			super.layout(attributes);
		}
		
		
		protected function setColour(colour:uint, top:Number, width:Number, height:Number):void {
			var colours:Vector.<uint> = (_cell is UIForm) ? UIForm(_cell).attributes.backgroundColours : null;
			if (colours && colours.length>1) {
				var matr:Matrix=new Matrix();
				matr.createGradientBox(colours.length>2 ? colours[2] : width, colours.length>2 ? colours[2] : height+2*UI.PADDING, colours.length>3 ? colours[3]*Math.PI/180 : Math.PI/2, 0, top-UI.PADDING);
				_slider.graphics.beginGradientFill(GradientType.LINEAR, [colours[0],colours[1]], [1.0,1.0], [0x00,0xff], matr, SpreadMethod.REPEAT);
			}
			else if (colours && colours.length>0) {
				_slider.graphics.beginFill(colours[0]);
			}
			else {
				_slider.graphics.beginFill(colour);
			}
		}
		
/**
 *  Draw the background for a cell somewhere in the middle of a group
 */	
		override protected function drawCell(position:Number, count:int, record:*):void {
			var colour:uint = (record.hasOwnProperty("$colour")) ? record.$colour : CELL_COLOUR;
			if (_colours.length > 1 && !record.hasOwnProperty("$colour")) {
				colour = _colours[Math.min(_colours.length - 1, count + 1)];
			}
			_slider.graphics.beginFill(_attributes.style7 ? colour : _colour);
			if (_length==1) {	
				_slider.graphics.drawRoundRect(_cellLeft, _cellTop, _cellWidth + 1, position - _cellTop, 1.5 * CURVE);
				setColour(colour, _cellTop + 1, _cellWidth - 1, position - _cellTop - 2);
				_slider.graphics.drawRoundRect(_cellLeft + 1, _cellTop + 1, _cellWidth - 1, position - _cellTop - 2, 1.5 * CURVE);
			}
			else if (count==0) {
				curvedTop(_slider.graphics, _cellLeft, _cellTop, _cellLeft + _cellWidth + 1, position, _attributes.style7);
				setColour(colour, _cellTop + 1, _cellWidth - 1, position - _cellTop - 2);
				curvedTop(_slider.graphics, _cellLeft + 1, _cellTop + 1, _cellLeft + _cellWidth, position, _attributes.style7);
			}
			else if (count==_length-1) {
				curvedBottom(_slider.graphics, _cellLeft, _cellTop, _cellLeft + _cellWidth + 1, position, _attributes.style7);
				setColour(colour, _cellTop + 1, _cellWidth - 1, position - _cellTop - 2);
				curvedBottom(_slider.graphics, _cellLeft + 1, _cellTop + 1, _cellLeft + _cellWidth, position - 1, _attributes.style7);
			}
			else {
				_slider.graphics.drawRect(_cellLeft, _cellTop, _cellWidth + 1, position - _cellTop);
				setColour(colour, _cellTop + 1, _cellWidth - 1, position - _cellTop - 2);
				_slider.graphics.drawRect(_cellLeft + 1, _cellTop + 1, _cellWidth - 1, position - _cellTop);
			}
			if (!(record is String) && hasLines(record)) {
				drawLines(position);
			}
			if (_arrows && (_header > 0 ? count >= _header : count < _length + _header)) {
				drawArrow(_cellLeft + _cellWidth - PADDING, (_cellTop + position) / 2);
			}
			if (_attributes.style7 && count < _length - 1) {
				_slider.graphics.beginFill(_colour);
				_slider.graphics.drawRect(_lineGap, position - 1, _cellWidth - _lineGap + _cellLeft + 1, 1);
			}
			_cellTop = position;
		}
		
/**
 *  Draw the background of the top cell of a group
 */	
		public static function curvedTop(shape:Graphics, left:Number, top:Number, right:Number, bottom:Number, style7:Boolean = true):void {
			var curve:Number = style7 ? CURVE7 : CURVE;
			shape.moveTo(left + curve, top);
			shape.lineTo(right - curve, top);
			shape.curveTo(right, top, right, top + curve);
			shape.lineTo(right, bottom);
			shape.lineTo(left, bottom);
			shape.lineTo(left, top + curve);
			shape.curveTo(left, top, left + curve, top);
		}
		
/**
 *  Draw the background of the bottom cell of a group
 */
		public static function curvedBottom(shape:Graphics, left:Number, top:Number, right:Number, bottom:Number, style7:Boolean = true):void {
			var curve:Number = style7 ? CURVE7 : CURVE;
			shape.moveTo(left, top);
			shape.lineTo(right, top);
			shape.lineTo(right, bottom - curve);
			shape.curveTo(right, bottom, right - curve, bottom);
			shape.lineTo(left + curve, bottom);
			shape.curveTo(left, bottom, left, bottom - curve);
			shape.lineTo(left, top);		
		}
		
		
		override protected function pressedCellLimits(groupDetail:Object = null):void {
			if (_pressedCell < _header || _pressedCell >= groupDetail.length) {
				_pressedCell = _saveIndex;
			}
		}
		
/**
 *  Is a group row clicked?
 */
		protected function isPressButton():Boolean {
			var sliderMouseY:Number = _slider.visible ? _slider.mouseY : mouseY - _sliderPosition;
			_group = 0;
			for each(var detail:Object in _groupPositions) {
				if (sliderMouseY >= detail.top && sliderMouseY <= detail.bottom && detail.visible) {
					
					if (_autoLayoutGroup && !_simple) {
						_row = null;
						for (var i:int=Math.max(_header,0); i<detail.length && !_row; i++) {
							var renderer:DisplayObject = byGroupAndRow(group,i);
							if ( sliderMouseY > 
							renderer.y-_attributes.paddingV && sliderMouseY<renderer.y+renderer.height+_attributes.paddingV) {
								_pressedCell = i;
								_row = DisplayObject(renderer);
								return _row != null;
							}
						}
					}
					else {
						_pressedCell = Math.floor((sliderMouseY - detail.top) / detail.cellHeight);
						pressedCellLimits(detail);
						return _pressedCell >= _header;
					}
				}
				else if (sliderMouseY <= detail.bottom) {
					return false;
				}
				_group++;
			}
			return false;
		}
		
/**
 *  The last group clicked
 */
		public function get group():int {
			return _group;
		}
		
/**
 *  Group heading text colour
 */
		public function set headingTextColour(value:uint):void {
			_headingFormat.color = value;
		}
		
		
		public function set headingShadowColour(value:uint):void {
			_shadowFormat.color = value;
		}
		

	//	The following overrides enable the setIndex method to work correctly
	
		override protected function indexToScrollPosition(value:int):Number {
			return (_groupPositions.length > _group) ? _groupPositions[_group].cellHeight * value + _groupPositions[_group].top : 0;
		}
		
		
		override protected function illuminate(pressedCell:int = -1, dispatch:Boolean = true, show:Boolean = true):void {
			if (show) {
				drawHighlight();
			}
		}
		
/**
 *  Assign to group before assigning to index
 */
		public function set group(value:int):void {
			_group = value;
		}
		
		
		protected function headingClicked():void {
			dispatchEvent(new Event(HEADING_CLICKED));
		}
		
/**
 *  Return DisplyObject of button pressed
 */
		override protected function pressButton(show:Boolean = true):DisplayObject {
			var sliderMouseY:Number = _slider.visible ? _slider.mouseY : mouseY - _sliderPosition;
			_scrollBarLayer.graphics.clear();
			clearPressed();
			if (!_simple  || sliderMouseY<_top) {
				doSearchHit();
			}
			if (!_pressButton && _clickRow) {
				if (isPressButton()) {
					if (show) {
						drawHighlight();
					}
					activate(show);
				}
				else if (sliderMouseY > _top) {
					_headingClicked = true;
				//	headingClicked();
				}
			}
			return _pressButton;
		}
		
/**
 *  Return row matching group and row indexes
 */
		protected function byGroupAndRow(group:uint,row:uint):DisplayObject {
			return _slider.getChildByName("label_"+row.toString()+"_"+group.toString());
		}
		
/**
 *  Return component matching id within row matching group and row indexes
 */
		override public function findViewById(id:String, row:int = -1, group:int = -1):DisplayObject {
			if (_search && _search.name == id) {
				return _search;
			}
			else {
				var container:DisplayObject = byGroupAndRow(group,row);
				return (container && container is IContainerUI) ? IContainerUI(container).findViewById(id, row, group) : container;
			}
		}

/**
 *  Set XML data
 */
		override public function set xmlData(value:XML):void {
			var result:Array = [];
			var children:XMLList = value.group;
			for each (var group:XML in children) {
				var row:Array = [];
				
				if (group.@icon.length()>0)
					result.push(getDefinitionByName(group.@icon.toString()) as Class);
				else if (group.@label.length()>0) {
					result.push(group.@label.toString());
				}
				
				for each (var child:XML in group.children()) {
					row.push(attributesToObject(child));
				}
				result.push(row);
			}
			data = result;
		}
		
		
		override public function setData(value:Array, index:int = 0):Boolean {
			var result:Boolean = false;
		//	var savePosition:Number = sliderY;
			_group = index;
			for each(var row:* in value) {
				if (row is String) {
					var heading:DisplayObject = _slider.getChildByName("heading_"+_group.toString());
					if (heading && heading is UILabel) {
						UILabel(heading).xmlText = row;
					}
					var shadow:DisplayObject = _slider.getChildByName("shadow_"+_group.toString());
					if (shadow && shadow is UILabel) {
						UILabel(shadow).xmlText = row;
					}
				}
				else if (row is Array) {
					_suffix = "_"+_group.toString();
					super.setData(row);
					_group++;
				}
			}
		//	sliderY = savePosition;
			if (_autoLayoutGroup) {
				doLayout();
				calculateMaximumSlide();
			}
			
			return result;
		}
		
		
		override protected function highlightForIndex(rowIndex:int):Boolean {
			if (_filteredData.length <= _group || !(_filteredData[_group] is Array)) {
				return false;
			}
			var rowData:* = _filteredData[_group][rowIndex];
			if (!(rowData is String) && rowData.hasOwnProperty("$highlight") && rowData.$highlight is Boolean) {
				return rowData.$highlight;
			}
			else {
				return _highlightPressed;
			}
		}
		
/**
 *  Draw highlight when a row is clicked
 */
		protected function drawHighlight():void {
			if (highlightForIndex(_pressedCell)) {
				_highlightIsOn = true;
				var autoLayout:Boolean = _autoLayoutGroup && !_simple;
				var groupDetails:Object = _groupPositions[_group];
				if (!groupDetails) {
					return;
				}
				var length:int = groupDetails.length;
				var top:Number = autoLayout ? _row.y - _attributes.paddingV +1 : groupDetails.top + _pressedCell * groupDetails.cellHeight;
				var bottom:Number = top + (autoLayout ? _row.height + 2*_attributes.paddingV -1 : groupDetails.cellHeight);
				_highlight.graphics.clear();
				_highlight.graphics.beginFill(_highlightColour);
				if (length==1) {
					_highlight.graphics.drawRoundRect(_cellLeft, top, _cellWidth, bottom - top, 1.5 * CURVE);
				}
				else if (_pressedCell==0) {
					curvedTop(_highlight.graphics, _cellLeft, top, _cellLeft + _cellWidth, bottom);
				}
				else if (_pressedCell==length-1) {
					curvedBottom(_highlight.graphics, _cellLeft, top, _cellLeft + _cellWidth, bottom);
				}
				else {
					_highlight.graphics.drawRect(_cellLeft, top, _cellWidth + 1, bottom - top);
				}
			}
		}
		
	
		override public function set filteredData(value:Array):void {
			setGroupedData(value);
		}

	
		override public function filter(searchFor:String, field:String = "", caseSensitive:Boolean = false, begins:Boolean = false):void {
			if (searchFor == "") {
				filteredData = _data;
			}
			else {
				if (field == "") {
					field = _field;
				}
				var result:Array = [];
				var heading:* = null;
				for each(var group:* in _data) {
					if (group is Array) {
						var filteredGroup:Array = filterArray(group, searchFor, field, caseSensitive, begins);
						if (heading && filteredGroup.length > 0) {
							result.push(heading);
							result.push(filteredGroup);
						}
						heading = null;
					}
					else {
						heading = group;
					}
				}
				filteredData = result; 
			}
		}
		
	}
}