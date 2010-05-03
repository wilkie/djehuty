/*
 * textfield.d
 *
 * This module implements a text field widget for TUI applications.
 *
 * Author: Dave Wilkinson, Lindsey Bieda
 *
 */

module cui.textfield;

import core.string;
import core.main;
import core.definitions;
import core.unicode;

import io.console;

import cui.widget;

// Section: Console

// Description: This console control abstracts a simple one line text field.
class CuiTextField : CuiWidget {

	// Constructors

	this( uint x, uint y, uint width, string value = "") {
		super(x,y,width,1);

		_max = width-2;

		_value = value.dup;
	}

	// Events

	override void onAdd() {
	}

	override void onInit() {
		onDraw();
	}


	override void onKeyDown(Key key) {

		Console.setColor(_forecolor, _backcolor);
		if (key.code == Key.Backspace) {
			if (_pos > 0) {
				if (_pos == _max) {
					Console.put(' ');
					_value = _value.substring(0,_value.length-1);
				}
				else {
					Console.put(cast(char)0x8);
					Console.put(' ');
					_value = _value.substring(0, _pos-1) ~ _value.substring(_pos);
				}

				Console.put(cast(char)0x8);

				_pos--;
			}
		}
		else if (key.code == Key.Return) {
			tabForward();
		}
	}

	override void onKeyChar(dchar keyChar) {

		Console.setColor(_forecolor, _backcolor);
		if (keyChar != 0x8 && keyChar != '\t' && keyChar != '\n' && keyChar != '\r') {
			if (_pos <= _max) {
				Console.put(keyChar);

				_pos++;

				if (_pos >= _max) {
					_pos = _max;
					_value = _value.substring(0, _value.length-1) ~ Unicode.toUtf8([keyChar]);
					Console.put(cast(char)(0x8));
				}
				else {
					_value = _value.substring(0, _pos-1) ~ Unicode.toUtf8([keyChar]) ~ _value.substring(_pos-1);
				}
			}
		}
	}

	override void onGotFocus() {
		Console.showCaret();

		positionCursor();

		Console.setColor(_forecolor, _backcolor);
	}

	// Properties

	// Description: This property returns the current text within the field.
	// Returns: The value of the field.
	string text() {
		return _value.dup;
	}

	// Description: This property sets the current text within the field.
	// text: The new value for the field.
	void text(string text) {
		_value = text.dup;
		onDraw();
	}
	
	// Description: This property returns the current forecolor of the text in the field
	// Returns: forecolor of text
	fgColor forecolor() {
		return _forecolor;
	}
	
	// Description: This property sets the current forecolor of the text in the field
	// value: The new forecolor
	void forecolor(fgColor value) {
		_forecolor = value;
		onDraw();
	}
	
	// Description: This property returns the current backcolor of the text in the field
	// Returns: backcolor of text
	bgColor backcolor() {
		return _backcolor;
	}
	
	// Description: This property sets the current backcolor of the text in the field
	// value: The new backcolor
	void backcolor(bgColor value) {
		_backcolor = value;
		onDraw();
	}
	
	// Description: This property returns the current forecolor of the borders of the field
	// Returns: forecolor of borders
	fgColor basecolor() {
		return _color;
	}
	
	// Description: This property sets the current forecolor of the borders of the field
	// value: The new forecolor of the borders
	void basecolor(fgColor value) {
		_color = value;
	}

	// Methods

	override bool isTabStop() {
		return true;
	}

	override void onDraw() {
		if (canDraw) {
			Console.position(this.left, this.top);
			Console.setColor(_color, bgColor.Black);
			Console.put("[");

			Console.setColor(_forecolor, _backcolor);

			foreach(chr; _value.substring(0,_max)) {
				Console.put(chr);
			}

			_pos = _value.length;
			if (_pos > _max) {
				_pos = _max;
			}

			for (int i=_value.length; i<_max; i++) {
				Console.put(' ');
			}

			Console.setColor(_color, bgColor.Black);

			Console.put("]");

			positionCursor();
		}
	}

protected:

	fgColor _color = fgColor.BrightBlue;
	fgColor _forecolor = fgColor.BrightWhite;
	bgColor _backcolor = bgColor.Black;

	uint _pos = 0;
	uint _max = 0;

	string _value;

	void positionCursor() {
		if (_pos == _max) {
			Console.position(this.left+_max, this.top);
		}
		else {
			Console.position(this.left+1+_pos, this.top);
		}
	}
}
