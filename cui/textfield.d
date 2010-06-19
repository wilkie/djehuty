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

import cui.window;
import cui.canvas;

// Section: Console

// Description: This console control abstracts a simple one line text field.
class CuiTextField : CuiWindow {

	// Constructors

	this( uint x, uint y, uint width, string value = "") {
		super(x,y,width,1,Color.Black);

		_max = width-2;

		_value = value.dup;
	}

	// Events

/*	override void onAdd() {
	}

	override void onInit() {
		onDraw();
	}
*/
	override void onKeyDown(Key key) {
		forecolor = Color.Green;
		if (key.code == Key.Backspace) {
			if (_pos > 0) {
				if (_pos == _max) {
					_value = _value.substring(0,_value.length-1);
				}
				else {
					_value = _value.substring(0, _pos-1) ~ _value.substring(_pos);
				}

				_pos--;
				redraw();
			}
		}
		else if (key.code == Key.Return) {
			//tabForward();
		}
	}

	override void onKeyChar(dchar keyChar) {
		if (keyChar != 0x8 && keyChar != '\t' && keyChar != '\n' && keyChar != '\r') {
			if (_pos <= _max) {

				_pos++;

				if (_pos > _max) {
					_pos = _max;
					_value = _value.substring(0, _value.utflen()-1) ~ Unicode.toUtf8([keyChar]);
				}
				else {
					_value = _value.substring(0, _pos-1) ~ Unicode.toUtf8([keyChar]) ~ _value.substring(_pos-1);
				}
				redraw();
			}
		}
	}

/*	override void onGotFocus() {
		Console.showCaret();

		//positionCursor();

		Console.forecolor = _forecolor;
		Console.backcolor = _backcolor;
	}
*/

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
		redraw();
		//onDraw();
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
		redraw();
		//onDraw();
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
		redraw();
		//onDraw();
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

/*	override bool isTabStop() {
		return true;
	}
	*/

	override void onPrimaryDown(ref Mouse mouse) {
		forecolor = Color.Red;
	}

	override void onDraw(CuiCanvas canvas) {
		canvas.position(0,0);
		canvas.forecolor = _color;
		canvas.backcolor = Color.Black;
		canvas.write("[");

		canvas.forecolor = _forecolor;
		canvas.backcolor = _backcolor;

		foreach(chr; _value.substring(0,_max)) {
			canvas.write(chr);
		}

		_pos = _value.length;
		if (_pos > _max) {
			_pos = _max;
		}

		for (int i=_value.utflen(); i<_max; i++) {
			canvas.write(" ");
		}

		canvas.forecolor = _color;
		canvas.backcolor = Color.Black;

		canvas.write("]");

		//positionCursor();
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
