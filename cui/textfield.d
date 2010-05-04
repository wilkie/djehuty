/*
 * textfield.d
 *
 * This module implements a text field widget for TUI applications.
 *
 * Author: Dave Wilkinson, Lindsey Bieda
 *
 */

module cui.textfield;

import djehuty;

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

		Console.forecolor = _forecolor;
		Console.backcolor = _backcolor;
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

		Console.forecolor = _forecolor;
		Console.backcolor = _backcolor;
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

		Console.forecolor = _forecolor;
		Console.backcolor = _backcolor;
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
	Color forecolor() {
		return _forecolor;
	}
	
	// Description: This property sets the current forecolor of the text in the field
	// value: The new forecolor
	void forecolor(Color value) {
		_forecolor = value;
		onDraw();
	}
	
	// Description: This property returns the current backcolor of the text in the field
	// Returns: backcolor of text
	Color backcolor() {
		return _backcolor;
	}
	
	// Description: This property sets the current backcolor of the text in the field
	// value: The new backcolor
	void backcolor(Color value) {
		_backcolor = value;
		onDraw();
	}
	
	// Description: This property returns the current forecolor of the borders of the field
	// Returns: forecolor of borders
	Color basecolor() {
		return _color;
	}
	
	// Description: This property sets the current forecolor of the borders of the field
	// value: The new forecolor of the borders
	void basecolor(Color value) {
		_color = value;
	}

	// Methods

	override bool isTabStop() {
		return true;
	}

	override void onDraw() {
		if (canDraw) {
			Console.position(this.left, this.top);
			Console.forecolor = _color;
			Console.backcolor = Color.Black;
			Console.put("[");

			Console.forecolor = _forecolor;
			Console.backcolor = _backcolor;

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

			Console.forecolor = _color;
			Console.backcolor = Color.Black;

			Console.put("]");

			positionCursor();
		}
	}

protected:

	Color _color = Color.Blue;
	Color _forecolor = Color.White;
	Color _backcolor = Color.Black;

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
