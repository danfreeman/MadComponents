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

/**
 * A very lightweight JSON parser
 */	
	public class TinyJSON {
		public function TinyJSON(){}
		
		protected static var _pos:int;
		protected static var _json:String;
		
		public static function parse(json:String):Object {
			_json = json;
			_pos = 0;
			skipSpaces();
			switch (_json.charAt(_pos)) {
				case "{": return parseKeyValueList();
				case "[": return parseArray();
			}
			return null;
		}
	
	
		protected static function parseArray():Array {
			var result:Array = [];
			do {
				_pos++;
				skipSpaces();
				if (_json.charAt(_pos)=="]")
					return result;
				result.push(parseValue());
			}
			while (_json.charAt(_pos)==',')
			_pos++;
			return result;	
		}
		
		
		protected static function parseKeyValueList():Object {
			var result:Object = {};
			do {
				_pos++;
				skipSpaces();
				if (_json.charAt(_pos)=="}")
					return result;
				parsePair(result);
			}
			while (_json.charAt(_pos)==',')
			_pos++;
			return result;
		}
		
			
		protected static function parsePair(result:Object):void {
			var posK0:int = _pos; // Assumed quotation mark
			endQuotePosition();
			var key:String = _json.substring(posK0+1,_pos);
			_pos = _json.indexOf(':',_pos+1) + 1;
			skipSpaces();
			result[key] = parseValue();
			skipSpaces();
		}


		protected static function parseValue():* {
			var result:*;
			var nextToken:String = _json.charAt(_pos);
			if (isNumber(nextToken)) {
				result = parseNumber();
			}
			else switch (nextToken) {
				case 'n': // handles JSON null, the form  ...,"description":null,...
					_pos += 4;
					result = '';
					break;
				case '"': 
					var posV0:int = _pos;
					endQuotePosition();
					result = stripSlashes(_json.substring(posV0+1,_pos));
					_pos++;
					break;
				case '{':
					result = parseKeyValueList();
					break;
				case '[':
					result = parseArray();
					break;
				default:
					result = parseToken();
			}
			return result;
		}
		

		protected static function stripSlashes(value:String):String {
			value = value.replace(/\\\//g,"/");
			value = Model.htmlDecode(value);
			var position:int = -1;
			while ((position = value.indexOf("\\u",position+1)) >=0) {
				value=value.substring(0,position)+String.fromCharCode(parseInt(value.substr(position+2,4),16))+value.substring(position+6);
				position-=5;
			}
			return value;
		}
		
		
		protected static function endQuotePosition():void {
			do {
				_pos = _json.indexOf('"',_pos+1);
			}
			while (_json.charAt(_pos-1)=="\\");
		}
		
		
		protected static function parseToken():String {
			var startPosition:int = _pos;
			var nextToken:String;
			do {
				nextToken = _json.charAt(++_pos);
			}
			while (nextToken>="a" && nextToken<="z");
			return _json.substring(startPosition,_pos);
		}
			
			
		protected static function parseNumber():Number {
			var startPosition:int = _pos;
			var nextToken:String;
			do {
				nextToken = _json.charAt(++_pos);
			}
			while (isNumber(nextToken) || nextToken=="." || nextToken=="e" || nextToken=="E" || nextToken=="+");
			return parseFloat(_json.substring(startPosition,_pos));
		}
			
			
		protected static function isNumber(token:String):Boolean {
			return (token>="0" && token<="9") || token=="-";
		}
			
		
		protected static function skipSpaces():void {
			var nextToken:String = _json.charAt(_pos);
			while (nextToken<=" " || nextToken=="\n" || nextToken=="\r" || nextToken=="\t") {
				nextToken = _json.charAt(++_pos);
			}
		}
	}
}