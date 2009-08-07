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
		for (int o; o < 500; o++) {
			_lines.addItem(new String(o));
		}
	}

	override void onInit() {
		draw();
		positionCaret();
	}

	override void onKeyDown(uint keyCode) {
		switch (keyCode) {
			case KeyBackspace:
				if (_column == 0) {
					_row--;
					if (_row < 0) {
						break;
					}

					_column = _lines[_row].length;
					_lines[_row] = _lines[_row] ~ _lines[_row+1];
					String oldLine;
					_lines.remove(oldLine, _row+1);
					draw();
					positionCaret();
					break;
				}
				else if (_column == 1) {
					_lines[_row] = _lines[_row].subString(1);
				}
				else if (_column == _lines[_row].length) {
					_lines[_row] = _lines[_row].subString(0, _lines[_row].length - 1);
				}
				else {
					_lines[_row] = _lines[_row].subString(0, _column-1) ~ _lines[_row].subString(_column);
				}
				
				_column--;

				drawLine(_row);
				positionCaret();
				break;
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

	override void onKeyChar(dchar chr) {
		_lines[_row] = _lines[_row].subString(0, _column) ~ [chr] ~ _lines[_row].subString(_column);
		drawLine(_row);
		_column++;
		positionCaret();
	}

	void positionCaret() {
		bool shouldDraw;

		if (_column < _firstColumn) {
			// scroll horizontally
			_firstColumn = _column;
			if (_firstColumn < 0) {
				_firstColumn = 0;
			}
			shouldDraw = true;
		}

		if (this.left + (_column - _firstColumn) >= this.right) {
			// scroll horizontally
			_firstColumn = _column - this.width + 1;
			shouldDraw = true;
		}

		if (_row < _firstVisible) {
			// scroll vertically
			_firstVisible = _row;
			if (_firstVisible < 0) {
				_firstVisible = 0;
			}
			shouldDraw = true;
		}

		if (this.top + (_row - _firstVisible) >= this.bottom) {
			// scroll vertically
			_firstVisible = _row - this.height + 1;
			if (_firstVisible >= _lines.length) {
				_firstVisible = _lines.length - 1;
			}
			shouldDraw = true;
		}

		if (shouldDraw) {
			draw();
		}

		// Is the caret on the screen?
		if ((this.left + (_column - _firstColumn) >= this.right) || (this.top + (_row - _firstVisible) >= this.bottom)) {
			// The caret is outside of the bounds of the widget
			Console.hideCaret();
		}
		else {
			// The caret is within the bounds of the widget
			Console.showCaret();

			// Move cursor to where the edit caret is
			Console.setPosition(this.left + (_column - _firstColumn), this.top + (_row - _firstVisible));
		}
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

		uint i;

		for (i = _firstVisible; i < _lines.length && i < _firstVisible + this.height; i++) {
			// Draw line
			drawLine(i);
		}
	}

	void drawLine(uint lineNumber) {
		Console.setPosition(this.left, this.top + (lineNumber - _firstVisible));
		Console.put(_lines[lineNumber]);

		// Pad with spaces
		for (uint k = _lines[lineNumber].length; k < this.right; k++) {
			Console.put(" ");
		}
	}

	ArrayList!(String) _lines;

	int _firstVisible;
	int _firstColumn;

	int _row;
	int _column;

	// The column that the caret is in while pressing up and down or scrolling.
	int _lineColumn;
>>>>>>> ed1759f0335872433d8d3463ce523f35271e6d67:tui/textbox.d
}