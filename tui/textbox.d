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

		_lines = new ArrayList!(LineInfo);
		LineInfo newItem;
		newItem.value = new String("if (something) { /* in comment block */ init(); }");

		_lines.addItem(newItem);
		onLineChanged(_lines.length - 1);
		for (int o; o < 500; o++) {
			LineInfo subItem;
			subItem.value = new String(o);
			_lines.addItem(subItem);
			onLineChanged(_lines.length - 1);
		}
	}

	override void onKeyDown(Key key) {
		switch (key.code) {
			case Key.Backspace:
				if (_column == 0) {
					_row--;
					if (_row < 0) {
						_row = 0;
						break;
					}

					_column = _lines[_row].value.length;

					_lines[_row].value ~= _lines[_row+1].value;
					_lines[_row].format ~= _lines[_row+1].format;

					LineInfo oldLine;
					_lines.remove(oldLine, _row+1);

					_lineColumn = _column;

					onLineChanged(_row);

					onDraw();
					positionCaret();
					break;
				}
				else if (_column == 1) {
					_lines[_row].value = _lines[_row].value.subString(1);
					if (_lines[_row].format !is null) {
						// The first section has one less length
						if (_lines[_row].format[0+2] < 2) {
							// The section has been destroyed
							if (_lines[_row].format.length == 3) {
								_lines[_row].format = null;
							}
							else {
								_lines[_row].format = _lines[_row].format[3..$];
							}
						}
						else {
							// Just subtract one
							_lines[_row].format[0+2]--;
						}
					}
				}
				else if (_column == _lines[_row].value.length) {
					_lines[_row].value = _lines[_row].value.subString(0, _lines[_row].value.length - 1);
					// The last section has one less length
					if (_lines[_row].format !is null) {
						if (_lines[_row].format[$-1] < 2) {
							// The last section has been destroyed
							if (_lines[_row].format.length == 3) {
								// All sections have been destroyed
								_lines[_row].format = null;
							}
							else {
								_lines[_row].format = _lines[_row].format[0..$-3];
							}
						}
						else {
							// Just subtract one
							_lines[_row].format[$-1]--;
						}
					}
				}
				else {
					_lines[_row].value = _lines[_row].value.subString(0, _column-1) ~ _lines[_row].value.subString(_column);
					// Reduce the count of the current format index
					if (_lines[_row].format !is null) {
						if (_lines[_row].format[_formatIndex] < 2) {
							// This format section has been depleted
							_lines[_row].format = _lines[_row].format[0.._formatIndex-2] ~ _lines[_row].format[_formatIndex+1..$];
						}
						else {
							// Just subtract
							_lines[_row].format[_formatIndex]--;
						}
					}
				}

				_column--;
				_lineColumn = _column;

				onLineChanged(_row);

				drawLine(_row);
				positionCaret();
				break;
			case Key.Left:
				_column--;
				if (_column < 0) {
					_row--;
					if (_row < 0) {
						_row = 0;
						_column = 0;
					}
					else {
						_column = _lines[_row].value.length;
					}
				}
				_lineColumn = _column;
				positionCaret();
				break;
			case Key.Right:
				_column++;
				if (_column > _lines[_row].value.length) {
					_row++;
					if (_row >= _lines.length) {
						_row = _lines.length - 1;
						_column = _lines[_row].value.length;
						_lineColumn = _column;
					}
					else {
						_column = 0;
					}
				}
				_lineColumn = _column;
				positionCaret();
				break;
			case Key.Up:
				_row--;
				_column = _lineColumn;

				if (_row < 0) {
					_row = 0;
					_column = 0;
					_lineColumn = _column;
				}

				if (_column > _lines[_row].value.length) {
					_column = _lines[_row].value.length;
				}
				positionCaret();
				break;
			case Key.Down:
				_row++;
				_column = _lineColumn;

				if (_row >= _lines.length) {
					_row = _lines.length - 1;
					_column = _lines[_row].value.length;
				}

				if (_column > _lines[_row].value.length) {
					_column = _lines[_row].value.length;
				}
				positionCaret();
				break;
			case Key.PageUp:
				_row -= this.height;
				_firstVisible -= this.height;

				if (_firstVisible < 0) {
					_firstVisible = 0;
				}

				if (_row < 0) {
					_row = 0;
					_column = 0;
					_lineColumn = _column;
				}

				if (_column > _lines[_row].value.length) {
					_column = _lines[_row].value.length;
				}
				onDraw();
				positionCaret();
				break;
			case Key.PageDown:
				_row += this.height;
				_firstVisible += this.height;

				if (_firstVisible >= _lines.length) {
					_firstVisible = _lines.length - 1;
				}

				if (_row >= _lines.length) {
					_row = _lines.length - 1;
					_column = _lines[_row].value.length;
				}

				if (_column > _lines[_row].value.length) {
					_column = _lines[_row].value.length;
				}
				onDraw();
				positionCaret();
				break;
			case Key.End:
				_column = _lines[_row].value.length;
				_lineColumn = _column;
				positionCaret();
				break;
			case Key.Home:
				_column = 0;
				_lineColumn = 0;
				positionCaret();
				break;
			default:
				break;
		}
	}

	override void onKeyChar(dchar chr) {
		if (chr == 0x8) {

			// Ignore character generation for backspace

			return;
		}
		else if (chr == 0xa) {

			// Ignore

			return;
		}
		else if (chr == 0xd) {

			// Pressing enter

			LineInfo newLine;
			newLine.value = _lines[_row].value.subString(_column);

			// Splitting format field

			if (_lines[_row].format !is null) {
				uint pos;
				uint last;
				for (uint i = 2; i < _lines[_row].format.length; i += 3) {
					pos += _lines[_row].format[i];
					if (pos >= _column) { break; }
					last = pos;
				}

				// Variable 'last' contains the first applied position for the
				// format specifier.

				if (last == _column) {
					// Format specifier starts with the caret... it is a clean break
					if (_formatIndex == 2) {
						newLine.format = _lines[_row].format;
						_lines[_row].format = null;
					}
					else {
						newLine.format = _lines[_row].format[_formatIndex+1..$];
						_lines[_row].format = _lines[_row].format[0.._formatIndex-2];
					}
				}
				else if (pos == _column) {
					// Format specifer ends with the caret... another clean break
					if (_lines[_row].format.length == 3) {
						newLine.format = null;
						// old format for the old line does not change
					}
					else {
						newLine.format = _lines[_row].format[_formatIndex-2..$].dup;
						_lines[_row].format = _lines[_row].format[0.._formatIndex+1];
						newLine.format[2] = 0;
					}
				}
				else {
					// No clean break
					newLine.format = _lines[_row].format[_formatIndex-2..$].dup;
					_lines[_row].format = _lines[_row].format[0.._formatIndex+1];

					_lines[_row].format[_formatIndex] = _column - last;
					newLine.format[2] = pos - _column;
				}
				_formatIndex = 2;
			}

			_lines.addItem(newLine, _row+1);
			_lines[_row].value = _lines[_row].value.subString(0, _column);

			_column = 0;
			_row++;
			_lineColumn = _column;

			onLineChanged(_row);

			onDraw();
			positionCaret();
			return;
		}

		// Normal character append

		_lines[_row].value = _lines[_row].value.subString(0, _column) ~ [chr] ~ _lines[_row].value.subString(_column);

		// Increase the count of the current format index
		if (_lines[_row].format !is null) {
			// Just add
			_lines[_row].format[_formatIndex]++;
		}

		_column++;
		_lineColumn = _column;

		onLineChanged(_row);

		drawLine(_row);

		positionCaret();
	}

	override void onGotFocus() {
		positionCaret();
	}

	// Events

	void onLineChanged(uint lineNumber) {
	}

	// Properties

	uint row() {
		return _row;
	}

	uint column() {
		return _column;
	}

	// Description: This property returns the backcolor color of the text
	bgColor backcolor() {
		return _backcolor;
	}

	// Description: This property sets the backcolor of the text
	// value: the color to set backcolor to
	void backcolor(bgColor value) {
		_backcolor = value;
	}

	// Description: This property returns the forecolor color of the text
	fgColor forecolor() {
		return _forecolor;
	}

	// Description: This property sets the forecolor of the text
	// value: the color to set forecolor to
	void forecolor(fgColor value) {
		_forecolor = value;
	}

	// Description: This property returns the backcolor color of the line numbers
	bgColor backcolorNum() {
		return _backcolorNum;
	}

	// Description: This property sets the backcolor of the line numbers
	// value: the color to set backcolor to
	void backcolorNum(bgColor value) {
		_backcolorNum = value;
	}

	// Description: returns the forecolor color of the line numbers
	fgColor forecolorNum() {
		return _forecolorNum;
	}

	// Description: This property sets the forecolor of the line numbers
	// value: the color to set forecolor to
	void forecolorNum(fgColor value) {
		_forecolorNum = value;
	}

	// Description: This property returns the true if linenumbers are enabled, false if disabled
	bool lineNumbers() {
		return _lineNumbers;
	}

	// Description: This property enables or disables line numbers
	// value: true to enable the line numbers, false to disable
	void lineNumbers(bool value) {
		_lineNumbers = value;
	}

	override void onDraw() {
		// Draw each line and pad any remaining spaces
		Console.hideCaret();

		uint i;

		for (i = _firstVisible; i < _lines.length && i < _firstVisible + this.height; i++) {
			// Draw line
			drawLine(i);
		}

		for (; i < _firstVisible + this.height; i++) {
			drawEmptyLine(i);
		}
	}

	override bool isTabStop() {
		return true;
	}

protected:

	void drawLine(uint lineNumber) {
		Console.position(0, lineNumber - _firstVisible);

		if (_lineNumbers) {
			if (_lineNumbersWidth == 0) {
				calculateLineNumbersWidth();
			}
			String strLineNumber = new String(lineNumber);
			Console.setColor(_forecolorNum, _backcolorNum);
			Console.put(spaces[0.._lineNumbersWidth - 2 - strLineNumber.length]);
			Console.put(strLineNumber);
			Console.put(": ");
		}

		if (_lines[lineNumber].format is null) {
			// No formatting, this line is just a simple regular line
			Console.setColor(_forecolor, _backcolor);
			if (_firstColumn >= _lines[lineNumber].value.length) {
			}
			else {
				Console.put(_lines[lineNumber].value.subString(_firstColumn));
			}
		}
		else {
			// Splitting up the line due to formatting
			uint pos = 0;
			for (uint i; i < _lines[lineNumber].format.length; i += 3) {
				Console.setColor(cast(fgColor)_lines[lineNumber].format[i], cast(bgColor)_lines[lineNumber].format[i+1]);
				//Console.Console.put("[", _lines[lineNumber].format[i+2], "]");
				uint formatLength = _lines[lineNumber].format[i+2];

				if (formatLength + pos < _firstColumn) {
					// draw nothing
				}
				else if (pos >= _firstColumn) {
					Console.put(_lines[lineNumber].value[pos..pos + formatLength]);
				}
				else {
					Console.put(_lines[lineNumber].value[_firstColumn..pos + formatLength]);
				}

				pos += _lines[lineNumber].format[i+2];
			}
		}

		// Pad with spaces
		uint num = (_lines[lineNumber].value.length - _firstColumn);
		if (_firstColumn >= _lines[lineNumber].value.length) {
			num = this.width - _lineNumbersWidth;
		}
		else if (num > this.width - _lineNumbersWidth) {
			num = 0;
		}
		else {
			num = (this.width - _lineNumbersWidth) - num;
		}

		uint pad;

		for (; num > 0;) {
			pad = num;

			if (pad > spaces.length) {
				Console.put(spaces);
				pad = spaces.length;
			}
			else {
				Console.put(spaces[0..pad]);
			}
			num -= pad;
		}
	}

	void drawEmptyLine(uint lineNumber) {
		Console.position(0, lineNumber - _firstVisible);

		// Pad with spaces
		uint num = this.width;
		uint pad;

		for (uint k; k < this.width; k += pad) {
			pad = num;

			if (pad > spaces.length) {
				Console.put(spaces);
			}
			else {
				Console.put(spaces[0..pad]);
			}
			num -= pad;
		}
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

		if (_lineNumbersWidth + (_column - _firstColumn) >= this.width) {
			// scroll horizontally
			_firstColumn = _column - this.width + _lineNumbersWidth + 1;
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
			onDraw();
		}

		// Calculate Format Index
		_formatIndex = 2;
		if (_lines[_row].format !is null) {
			uint pos;
			for (uint i = 2; i < _lines[_row].format.length; i += 3) {
				pos += _lines[_row].format[i];
				if (pos >= _column) {
					_formatIndex = i;
					break;
				}
			}
		}

		// Is the caret on the screen?
		if ((this.left + _lineNumbersWidth + (_column - _firstColumn) >= this.right) || (this.top + (_row - _firstVisible) >= this.bottom)) {
			// The caret is outside of the bounds of the widget
			Console.hideCaret();
		}
		else {
			// The caret is within the bounds of the widget
			Console.showCaret();

			// Move cursor to where the edit caret is
			Console.position(_lineNumbersWidth + (_column - _firstColumn), _row - _firstVisible);
		}
	}

	void calculateLineNumbersWidth() {
		if (_lineNumbers) {
			// The width of the maximum line (in decimal as a string)
			// summed with two for the ': '
			_lineNumbersWidth = (new String(_lines.length)).length + 2;
		}
		else {
			_lineNumbers = 0;
		}
	}

	// Just some spaces
	char[] spaces = "                                                           ";

	// The information about each line
	struct LineInfo {
		String value;
		uint[] format;
	}

	// Stores the buffer of lines
	ArrayList!(LineInfo) _lines;

	// The top left corner
	int _firstVisible;	// Row
	int _firstColumn;	// Column

	// The current caret position
	int _row;
	int _column;

	// The current caret position within the format array
	int _formatIndex;

	// The column that the caret is in while pressing up and down or scrolling.
	int _lineColumn;

	// Whether or not line numbers are rendered
	bool _lineNumbers;

	// The width of the line numbers column
	uint _lineNumbersWidth;

	// The default text colors
 	fgColor _forecolor = fgColor.White;
	bgColor _backcolor = bgColor.Black;
	fgColor _forecolorNum = fgColor.Yellow;
	bgColor _backcolorNum = bgColor.Black;
}
