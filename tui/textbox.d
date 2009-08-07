/*
 * textbox.d
 *
 * This module implements a large editable text area for TUI apps.
 *
 * Author: Dave Wilkinson
 * Originated: August 6th 2009
 *
 */

module tui.textbox;

import tui.widget;

import core.string;
import core.definitions;

import io.console;

import utils.arraylist;

class TuiTextBox : TuiWidget {
	this(uint x, uint y, uint width, uint height) {
		super(x,y,width,height);

		_lines = new ArrayList!(String);
		_lines.addItem(new String("Hello"));
		_lines.addItem(new String("Bugger"));
	}

	void onInit() {
		draw();
	}

	void onKeyDown(uint keyCode) {
		switch (keyCode) {
			case KeyArrowLeft:
				_column--;
				if (_column < 0) {
					_row--;
					if (_row < 0) {
						_row = 0;
						_column = 0;
					}
					else {
						_column = _lines[_row].length;
					}
				}
				_lineColumn = _column;
				positionCaret();
				break;
			case KeyArrowRight:
				_column++;
				if (_column > _lines[_row].length) {
					_row++;
					if (_row >= _lines.length) {
						_row = _lines.length - 1;
						_column = _lines[_row].length;
						_lineColumn = _column;
					}
					else {
						_column = 0;
					}
				}
				_lineColumn = _column;
				positionCaret();
				break;
			case KeyArrowUp:
				_row--;
				_column = _lineColumn;

				if (_row < 0) {
					_row = 0;
					_column = 0;
					_lineColumn = _column;
				}

				if (_column > _lines[_row].length) {
					_column = _lines[_row].length;
				}
				positionCaret();
				break;
			case KeyArrowDown:
				_row++;
				_column = _lineColumn;

				if (_row >= _lines.length) {
					_row = _lines.length - 1;
					_column = _lines[_row].length;
				}

				if (_column > _lines[_row].length) {
					_column = _lines[_row].length;
				}
				positionCaret();
				break;
			default:
				break;
		}
	}

	void positionCaret() {
		Console.setPosition(this.left + (_column - _firstColumn), this.top + (_row - _firstVisible));
	}

	uint row() {
		return _row;
	}

	uint column() {
		return _column;
	}

protected:

	void draw() {
		// Draw each line and pad any remaining spaces

		uint i, k;

		for (i = _firstVisible; i < _lines.length && i < _firstVisible + this.height; i++) {
			// Draw line
			Console.setPosition(this.left, this.top + (i - _firstVisible));
			Console.put(_lines[i]);

			// Pad with spaces
			for (k = _lines[i].length; k < this.right; k++) {
				Console.put(" ");
			}
		}

		// Is the caret on the screen?
		if ((this.left + _column >= this.right) || (this.top + _row >= this.bottom)) {
			// The caret is outside of the bounds of the widget
			Console.hideCaret();
		}
		else {
			// The caret is within the bounds of the widget
			Console.showCaret();

			// Move cursor to where the edit caret is
			Console.setPosition(this.left + _column, this.top + _row);
		}
	}

	ArrayList!(String) _lines;

	uint _firstVisible;
	uint _firstColumn;

	int _row;
	int _column;

	// The column that the caret is in while pressing up and down or scrolling.
	int _lineColumn;
}