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

//
//  NOTE THAT TWITTER HAVE CHANGED THEIR API.  THIS EXAMPLE DOESN'T WORK - BUT THE APPROACH IS STILL VALID FOR JSON DATA.
//

package
{
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class MadComponentsJSON extends Sprite {
		
		protected static const SMALL_TEXT:XML = <font size="12"/>;
		
		protected static const TRENDS_VIEW:XML =
			
			<list id="trendsView" pullDownRefresh="true" pullDownColour="#666666">
				<model url="http://api.twitter.com/1/trends.json" parse="trends.." action="loadJSON">
					<name>label</name>
					<query/>
				</model>
			</list>;
		
		
		protected static const TWEETS_VIEW:XML =
			
			<list autoLayout="true" id="tweetsView" pullDownRefresh="true" pullDownColour="#666666">
				<model parse="results."/>
			
				<search field="text"/>
			
				<horizontal>
					<imageLoader id="profile_image_url"/>
					<vertical gapV="0">
						<label id="from_user" alignH="fill"></label>
						<label id="text" alignH="fill">{SMALL_TEXT}</label>
					</vertical>
				</horizontal>
			</list>;
		
		
		protected static const USER_DETAIL:XML =
			
			<columns id="detail" widths="50,100%" autoLayout="true">
				<model parse="user"/>
			
				<imageLoader id="profile_image_url"/>
				<vertical>			
					<label id="name" alignH="fill"/>
					<label id="screen_name">{SMALL_TEXT}</label>
					<label id="location" alignH="fill">{SMALL_TEXT}</label>
					<label/>
					<label id="description" alignH="fill">{SMALL_TEXT}</label>
				</vertical>
			</columns>;
		
		
		protected static const NAVIGATOR:XML =
			
			<navigation id="navigation" rightButton="" title="Twitter Trends">
				{TRENDS_VIEW}
				{TWEETS_VIEW}
				{USER_DETAIL}
			</navigation>;
				
				
		[Embed(source="images/refresh.png")]
		protected static const REFRESH:Class;
		
		protected var _navigation:UINavigation;
		protected var _trendsView:UIList;
		protected var _tweetsView:UIList;
		protected var _detail:UIForm;
		
		public function MadComponentsJSON(screen:Sprite = null) {
			
			if (screen)
				screen.addChild(this);
			
			stage.align = StageAlign.TOP_LEFT;  
			stage.scaleMode = StageScaleMode.NO_SCALE;

			UI.create(this, NAVIGATOR);
			
			_trendsView = UIList(UI.findViewById("trendsView"));
			_trendsView.addEventListener(UIList.CLICKED, trendsViewClicked);
			
			_tweetsView = UIList(UI.findViewById("tweetsView"));
			_tweetsView.addEventListener(UIList.CLICKED, tweetsViewClicked);
			
			_detail = UIForm(UI.findViewById("detail"));
			
			_navigation = UINavigation(UI.findViewById("navigation"));
			_navigation.navigationBar.rightButton.skinClass = REFRESH;
			_navigation.navigationBar.rightButtonText = "";
			_navigation.navigationBar.rightButton.addEventListener(UIButton.CLICKED, refresh);
			_navigation.navigationBar.backButton.addEventListener(MouseEvent.MOUSE_UP, goBack);
		}
		
		
		protected function refresh(event:Event):void {
			if (_navigation.pageNumber==0)
				_trendsView.model.loadJSON();
			else if (_navigation.pageNumber==1)
				_tweetsView.model.loadJSON();
		}
		
		
		protected function goBack(event:MouseEvent):void {
			_navigation.navigationBar.rightButton.visible = true;
		}
		
		
		protected function trendsViewClicked(event:Event):void {
			var query:String = Model.queryString(_trendsView.row.query);
			_tweetsView.model.loadJSON("http://search.twitter.com/search.json?q="+query);
			_tweetsView.scrollPositionY = 0;
		}
		
		
		protected function tweetsViewClicked(event:Event):void {
			var user:String = _tweetsView.row.from_user;
			_detail.data = {profile_image_url:null};
			_detail.model.loadXML("http://api.twitter.com/1/users/show.xml?screen_name="+user);
			_navigation.navigationBar.rightButton.visible = false;
		}
	}
}