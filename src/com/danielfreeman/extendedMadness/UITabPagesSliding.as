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
 * AUTHORS' OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.</p>
 *
 * <p>Licensed under The MIT License</p>
 * <p>Redistributions of files must retain the above copyright notice.</p>
 */

package com.danielfreeman.extendedMadness
{
	import flash.events.Event;
	import com.danielfreeman.madcomponents.*;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextFormat;

/**
 *  MadComponents tabbed pages container
 * <pre>
 * &lt;tabPagesSliding
 *    id = "IDENTIFIER"
 *    colour = "#rrggbb"
 *    background = "#rrggbb, #rrggbb, ..."
 *    tabButtonColours = "#rrggbb, #rrggbb, ..."
 *    visible = "true|false"
 *    gapV = "NUMBER"
 *    gapH = "NUMBER"
 *    alignH = "left|right|centre"
 *    alignV = "top|bottom|centre"
 *    border = "true|false"
 *    mask = "true|false"
 *    alt = "true|false"
 *    highlightColour = "#rrggbb"
 *    iconColour = "#rrggbb"
 *    activeColour = "#rrggbb"
 *    background = "#rrggbb, #rrggbb"
 *    leftMargin = "NUMBER"
 *    pixelSnapping = "true|false"
 *    scaleHeight = "NUMBER"
 *    &lt;data&gt;LABELS&lt;/data&gt;
 *    &lt;font&gt;FORMAT&lt;/font&gt;
 *    &lt;activeFont&gt;FORMAT&lt;/activeFont&gt;
 *    &lt;disableFont&gt;FORMAT&lt;/disableFont&gt;
 * /&gt;
 * </pre>
 */
	public class UITabPagesSliding extends UIPanel {	
		
		protected static const ICONS:XML =
		
					<icons id="_icons"
						border="false"
						background="#001133,#000022"
						gapH="30"
						leftMargin="20"
						height="38"
						pixelSnapping = "true"
						iconColour="#FFCC33"
						activeColour="#CCCCFF">
						<font color="#FFEE99"/>
					</icons>;

					
		protected static const SLIDING_ICONS:XML =					
					
				<scrollHorizontal border="false" id="_scrollHorizontal" scrollBarColour="#EEEEEE" background="#001133">
					{ICONS}
				</scrollHorizontal>

		
		protected static const LAYOUT:XML =
		
			<rows heights="100%,38" border="false" gapV="0">
				<pages id="_pages"/>
				{SLIDING_ICONS}
			</rows>;
			
			
		protected var _pages:UIPages;
		protected var _icons:UIIcons;
		
		
		public function UITabPagesSliding(screen:Sprite, xml:XML, attributes:Attributes) {
			super(screen, modify(xml), attributes);
			_pages = UIPages(findViewById("_pages"));
			_icons = UIIcons(findViewById("_icons"));
			_icons.index = 0;
			_icons.addEventListener(Event.CHANGE, tabClicked);
		}
		
		
		public function get tabPages():UIPages {            
			return _pages;
		}
		
		
		public function get icons():UIIcons {
			return _icons;
		}
		
		
		protected function tabClicked(event:Event):void {
			_pages.goToPage(_icons.index);
		}
		
		
		protected function modify(xml:XML):XML {
			var rows:XML = LAYOUT.copy();
			var pages:XML = rows.pages[0];
			var scrollHorizontal:XML = rows.scrollHorizontal[0];
			var icons:XML = scrollHorizontal.icons[0];
			if (xml.@scrollBarColour.length() > 0) {
				scrollHorizontal.@scrollBarColour = xml.@scrollBarColour;
			}
			if (xml.@iconBackground.length() > 0) {
				icons.@background = xml.@iconBackground;
				scrollHorizontal.@background = String(xml.@iconBackground).split(",")[0];
			}
			if (xml.@iconColour.length() > 0) {
				icons.@iconColour = xml.@iconColour;
			}
			if (xml.@activeColour.length() > 0) {
				icons.@activeColour = xml.@activeColour;
			}
			if (xml.@disableColour.length() > 0) {
				icons.@disableColour = xml.@disableColour;
			}
			if (xml.@highlightColour.length() > 0) {
				icons.@highlightColour = xml.@highlightColour;
			}
			if (xml.font.length() > 0) {
				icons.font = xml.font;
			}
			if (xml.activeFont.length() > 0) {
				icons.activeFont = xml.activeFont;
			}
			if (xml.disableFont.length() > 0) {
				icons.disableFont = xml.disableFont;
			}
			var numberOfPages:int = 0;
			for each (var pageXml:XML in xml.children()) {
				if (pageXml.localName() != "data" && pageXml.localName() != "font" && pageXml.localName() != "activeFont" && pageXml.localName() != "disableFont") {
					pages.appendChild(pageXml);
					numberOfPages++;
				}
			}
			if (xml.data.length() > 0) {
				icons.data = xml.data;
			}
			else {
				var xmlData:XML = <data/>;
				for (var i:int = 0; i < numberOfPages; i++) {
					xmlData.appendChild(<item label={i}/>);
				}
				icons.data = xmlData;
			}
			return rows;
		}
	}
}