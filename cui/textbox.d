/*
 * textbox.d
 *
 * This module implements a large editable text area for TUI apps.
 *
 * Author: Dave Wilkinson
 * Originated: August 6th 2009
 *
 */

module cui.textbox;

import djehuty;

import data.list;

import cui.widget;

import io.console;

class CuiTextBox : CuiWidget {
	this(uint x, uint y, uint width, uint height) {
		super(x,y,width,height);

		_lines = new List!(LineInfo);
		LineInfo newItem = new LineInfo();
		newItem.value = "if (something) { /* in comment block */ init(); }";

		_lines.add(newItem);
		onLineChanged(_lines.length - 1);
		for (int o; o < 500; o++) {
			LineInfo subItem = new LineInfo();
			subItem.value = new string(o);
			_lines.add(subItem);
			onLineChanged(_lines.length - 1);
		}

		_tabWidth = 4;
		_lineCont = '$';
		_scrollH = ScrollType.Skip;
		_scrollV = ScrollType.Skip;
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

					_lines[_row] ~= _lines[_row+1].dup();

					LineInfo oldLine;
					oldLine = _lines.removeAt(_row+1);

					_lineColumn = _column;

					onLineChanged(_row);

					refresh();
					break;
				}
				else if (_column == 1) {
					_lines[_row].value = _lines[_row].value.substring(1);
					if (_lines[_row].format !is null) {
						// The first section has one less length
						if (_lines[_row].format[0].len <= 1) {
							// The section has been destroyed
							if (_lines[_row].format.length == 1) {
								_lines[_row].format = null;
							}
							else {
								_lines[_row].format = _lines[_row].format[1..$];
							}
						}
						else {
							// Just subtract one
							_lines[_row].format[0].len--;
						}
					}
				}
				else if (_column == _lines[_row].value.length) {
					_lines[_row].value = _lines[_row].value.substring(0, _lines[_row].value.length - 1);
					// The last section has one less length
					if (_lines[_row].format !is null) {
						if (_lines[_row].format[$-1].len <= 1) {
							// The last section has been destroyed
							if (_lines[_row].format.length == 1) {
								// All sections have been destroyed
								_lines[_row].format = null;
							}
							else {
								_lines[_row].format = _lines[_row].format[0..$-1];
							}
						}
						else {
							// Just subtract one
							_lines[_row].format[$-1].len--;
						}
					}
				}
				else {
					_lines[_row].value = _lines[_row].value.substring(0, _column-1) ~ _lines[_row].value.substring(_column);
					// Reduce the count of the current format index
					if (_lines[_row].format !is null) {
						if (_lines[_row].format[_formatIndex].len <= 1) {
							// This format section has been depleted
							_lines[_row].format = _lines[_row].format[0.._formatIndex] ~ _lines[_row].format[_formatIndex+1..$];
						}
						else {
							// Just subtract
							_lines[_row].format[_formatIndex].len--;
						}
					}
				}

				_column--;
				_lineColumn = _column;

				onLineChanged(_row);

				drawLine(_row);
				positionCaret();
				break;
			case Key.Delete:
				if (_column == _lines[_row].value.length) {
					if (_row + 1 >= _lines.length) {
						// Last column of last row. Do nothing.
					} else {
						// Last column with more rows beneath, so suck next row up.
						_lines[_row] ~= _lines[_row+1].dup();

						LineInfo oldLine;
						oldLine = _lines.removeAt(_row+1);

						onLineChanged(_row);

						refresh();
					}
				} else {
					// Not the last column, so delete the character to the right.
					_lines[_row].value = _lines[_row].value.substring(0, _column) ~ _lines[_row].value.substring(_column + 1);

					if (_lines[_row].format !is null) {
						_formatIndex = calculateFormatIndex(_lines[_row], _column + 1);
						if (_lines[_row].format[_formatIndex].len < 2) {
							// This format section has been depleted
							_lines[_row].format = _lines[_row].format[0.._formatIndex] ~ _lines[_row].format[_formatIndex+1..$];
						}
						else {
							// One fewer character with this format
							_lines[_row].format[_formatIndex].len--;
						}
						_formatIndex = calculateFormatIndex(_lines[_row], _column);
					}

					refresh();
				}
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
				refresh();
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
				refresh();
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

			LineInfo newLine = new LineInfo();
			newLine.value = _lines[_row].value.substring(_column);

			// Splitting format field

			if (_lines[_row].format !is null) {
				if (_column == 0) {
					// At the beginning of the line; shift the format to the new line
					newLine.format = _lines[_row].format;
					_lines[_row].format = null;
				} else if (_column == _lines[_row].value.length) {
					// At the end of the line; formats remain unchanged
					newLine.format = null;
				} else {
					// In the middle of the line; current format may need cutting
					uint pos = 0;
					uint last;
					for (uint i = 0; i <= _formatIndex; i++) {
						last = pos;
						pos += _lines[_row].format[i].len;
					}

					if (_column == pos) {
						// Clean break
						newLine.format = _lines[_row].format[_formatIndex+1..$];
					} else {
						// Unclean break
						newLine.format = [_lines[_row].format[_formatIndex].dup];
						newLine.format ~= _lines[_row].format[_formatIndex+1..$];

						// Determine lengths for the format being cut
						newLine.format[0].len = pos - _column;
						_lines[_row].format[_formatIndex].len = _column - last;
					}

					_lines[_row].format = _lines[_row].format[0.._formatIndex+1];
				}

				_formatIndex = 0;
			}

			_lines.addAt(newLine, _row+1);
			_lines[_row].value = _lines[_row].value.substring(0, _column);

			_column = 0;
			_row++;
			_lineColumn = _column;

			onLineChanged(_row);

			refresh();
			return;
		}

		// Normal character append

		_lines[_row].value = _lines[_row].value.substring(0, _column) ~ Unicode.toUtf8([chr]) ~ _lines[_row].value.substring(_column);

		// Increase the length of the current format index
		if (_lines[_row].format !is null) {
			// Just add
			_lines[_row].format[_formatIndex].len++;
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
	Color backcolor() {
		return _backcolor;
	}

	// Description: This property sets the backcolor of the text
	// value: the color to set backcolor to
	void backcolor(Color value) {
		_backcolor = value;
	}

	// Description: This property returns the forecolor color of the text
	Color forecolor() {
		return _forecolor;
	}

	// Description: This property sets the forecolor of the text
	// value: the color to set forecolor to
	void forecolor(Color value) {
		_forecolor = value;
	}

	// Description: This property returns the backcolor color of the line numbers
	Color backcolorNum() {
		return _backcolorNum;
	}

	// Description: This property sets the backcolor of the line numbers
	// value: the color to set backcolor to
	void backcolorNum(Color value) {
		_backcolorNum = value;
	}

	// Description: returns the forecolor color of the line numbers
	Color forecolorNum() {
		return _forecolorNum;
	}

	// Description: This property sets the forecolor of the line numbers
	// value: the color to set forecolor to
	void forecolorNum(Color value) {
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
		calculateLineNumbersWidth();
	}

	void refresh() {
		onDraw();
		positionCaret();
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
		Console.hideCaret();
		Console.position(0, lineNumber - _firstVisible);

		if (_lineNumbers) {
			if (_lineNumbersWidth == 0) {
				calculateLineNumbersWidth();
			}
			string strLineNumber = new string(lineNumber);
			Console.forecolor = _forecolorNum;
			Console.backcolor = _backcolorNum;
			Console.putSpaces(_lineNumbersWidth - 2 - strLineNumber.length);
			Console.put(strLineNumber);
			Console.put(": ");
		}

		uint[] formatTabExtension;
		uint curFormat, untilNextFormat;

		if (_lines[lineNumber].format !is null) {
			formatTabExtension.length = _lines[lineNumber].format.length;
			untilNextFormat = _lines[lineNumber].format[0].len;
		}

		string actualLine = _lines[lineNumber].value;
		string visibleLine = "";

		if (_tabWidth > 0) {
			for (uint i = 0; i < actualLine.length; i++) {
				while (curFormat + 1 < formatTabExtension.length && untilNextFormat == 0) {
					++curFormat;
					untilNextFormat = _lines[lineNumber].format[curFormat].len;
				}
				if (curFormat < formatTabExtension.length)
					untilNextFormat--;
				string c = actualLine.charAt(i);
				if ("\t" == c) {
					uint tabSpaces = _tabWidth - visibleLine.length % _tabWidth;
					if (curFormat < formatTabExtension.length)
						formatTabExtension[curFormat] += tabSpaces - 1;
					visibleLine ~= " ".times(tabSpaces);
				} else {
					visibleLine ~= c;
				}
			}
		} else {
			visibleLine = actualLine;
		}

		uint pos = 0;
		// Make space for the line continuation symbol
		if (visibleLine.length > _firstColumn && _firstColumn > 0) {
			visibleLine = visibleLine.insertAt(" ", _firstColumn);
			pos++;
		}

		if (_lines[lineNumber].format is null) {
			// No formatting, this line is just a simple regular line
			Console.forecolor = _forecolor;
			Console.backcolor = _backcolor;
			if (_firstColumn >= _lines[lineNumber].value.length) {
			}
			else {
				Console.put(visibleLine.substring(_firstColumn));
			}
		}
		else {
			// Splitting up the line due to formatting
			for (uint i = 0; i < _lines[lineNumber].format.length; i++) {
				Console.forecolor = _lines[lineNumber].format[i].fgCol;
				Console.backcolor = _lines[lineNumber].format[i].bgCol;
				//Console.Console.put("[", _lines[lineNumber].format[i].length, "]");
				uint formatLength = _lines[lineNumber].format[i].len + formatTabExtension[i];

				if (formatLength + pos < _firstColumn) {
					// draw nothing
				}
				else if (pos >= _firstColumn) {
					Console.put(visibleLine[pos..pos + formatLength]);
				}
				else {
					Console.put(visibleLine[_firstColumn..pos + formatLength]);
				}

				pos += formatLength;
			}
		}

		Console.forecolor = _forecolor;
		Console.backcolor = _backcolor;
		// Pad with spaces
		uint num = (visibleLine.length - _firstColumn);
		//uint num = (_lines[lineNumber].value.length - _firstColumn);
		if (_firstColumn >= _lines[lineNumber].value.length) {
			num = this.width - _lineNumbersWidth;
		}
		else if (num > this.width - _lineNumbersWidth) {
			num = 0;
		}
		else {
			num = (this.width - _lineNumbersWidth) - num;
		}
		
		if (num != 0) {
			Console.putSpaces(num);
		}

		// Output the necessary line continuation symbols.
		Console.forecolor = Color.White;
		Console.backcolor = Color.Black;
		if (visibleLine.length > _firstColumn && _firstColumn > 0) {
			Console.position(_lineNumbersWidth, lineNumber - _firstVisible);
			Console.put(_lineCont);
		}
		if (visibleLine.length > _firstColumn && visibleLine.length - _firstColumn > this.width - _lineNumbersWidth) {
			Console.position(this.width - 1, lineNumber - _firstVisible);
			Console.put(_lineCont);
		}
	}

	void drawEmptyLine(uint lineNumber) {
		Console.hideCaret();
		Console.position(0, lineNumber - _firstVisible);

		// Pad with spaces
		Console.putSpaces(this.width);
	}

	void positionCaret() {
		bool shouldDraw;

		// Count the tabs to the left of the caret.
		uint leftTabSpaces = 0;
		if (_tabWidth > 0) {
			for (uint i = 0; i < _column; i++) {
				if ("\t" == _lines[_row].value.charAt(i)) {
					leftTabSpaces += _tabWidth - (i + leftTabSpaces) % _tabWidth - 1;
				}
			}
		}

		if (_column < _firstColumn) {
			// scroll horizontally
			if (_scrollH == ScrollType.Skip) {
				// If scrolling left, go to the start of the line and let the next section do the work.
				if (_column + leftTabSpaces < _firstColumn)
					_firstColumn = 0;
			} else { // ScrollType.Step
				_firstColumn = _column + leftTabSpaces;
				if (_firstColumn <= 1)
					_firstColumn = 0;
			}
			shouldDraw = true;
		}

		// _firstColumn > 0 means the characters are shifted 1 to the right thanks to the line continuation symbol
		if (_column + leftTabSpaces - _firstColumn + (_firstColumn > 0 ? 1 : 0) >= this.width - _lineNumbersWidth - 1) {
			// scroll horizontally
			if (_scrollH == ScrollType.Skip) {
				_firstColumn = _column + leftTabSpaces - (this.width - _lineNumbersWidth) / 2;
			} else { // ScrollType.Step
				_firstColumn = _column + leftTabSpaces - (this.width - _lineNumbersWidth) + 3;
			}
			shouldDraw = true;
		}

		if (_row < _firstVisible) {
			// scroll vertically
			if (_scrollV == ScrollType.Skip) {
				// If scrolling up, go to the first row and let the next section do the work.
				_firstVisible = 0;
			} else { // ScrollType.Step
				_firstVisible = _row;
				if (_firstVisible < 0)
					_firstVisible = 0;
			}
			shouldDraw = true;
		}

		if (this.top + (_row - _firstVisible) >= this.bottom) {
			// scroll vertically
			if (_scrollV == ScrollType.Skip) {
				_firstVisible = _row - this.height / 2;
			} else { // ScrollType.Step
				_firstVisible = _row - this.height + 1;
			}
			if (_firstVisible >= _lines.length) {
				_firstVisible = _lines.length - 1;
			}
			shouldDraw = true;
		}

		if (shouldDraw) {
			onDraw();
		}

		_formatIndex = calculateFormatIndex(_lines[_row], _column);

		// Is the caret on the screen?
		if ((this.left + _lineNumbersWidth + (_column - _firstColumn) >= this.right) || (this.top + (_row - _firstVisible) >= this.bottom)) {
			// The caret is outside of the bounds of the widget
			Console.hideCaret();
		}
		else {
			// Move cursor to where the edit caret is
			Console.position(_lineNumbersWidth + (_column - _firstColumn) + leftTabSpaces + (_firstColumn > 0 ? 1 : 0), _row - _firstVisible);

			// The caret is within the bounds of the widget
			Console.showCaret();
		}
	}


	// Description: Calculates the formatIndex given a LineInfo and column.
	// Returns: The calculated formatIndex.
	int calculateFormatIndex(LineInfo line, int column) {
		int formatIndex = 0;
		if (line.format !is null) {
			uint pos;
			for (uint i = 0; i < line.format.length; i++) {
				pos += line.format[i].len;
				if (pos >= column) {
					formatIndex = i;
					break;
				}
			}
		}
		return formatIndex;
	}

	void calculateLineNumbersWidth() {
		if (_lineNumbers) {
			// The width of the maximum line (in decimal as a string)
			// summed with two for the ': '
			_lineNumbersWidth = (new string(_lines.length)).length + 2;
		}
		else {
			_lineNumbers = 0;
		}
	}

	// The behavior when a line is scrolled via the keyboard.
	enum ScrollType {
		Step,
		Skip,
	}

	// The formatting of a line segment
	static class LineFormat {
		this () {}
		this (Color f, Color b, uint l) {
			fgCol = f;
			bgCol = b;
			len = l;
		}

		LineFormat dup() {
			return new LineFormat(fgCol, bgCol, len);
		}

		int opEquals(LineFormat lf) {
			return cast(int)(this.fgCol == lf.fgCol && this.bgCol == lf.bgCol);
		}

		Color fgCol;
		Color bgCol;
		uint len;
	}

	// The information about each line
	class LineInfo {
		this() {
		}

		this(string v, LineFormat[] f) {
			value = v;
			format = f;
			this();
		}

		LineInfo dup() {
			return new LineInfo(this.value, this.format.dup);
		}

		void opCatAssign(LineInfo li) {
			if (this.format !is null && li.format !is null) {
				// Merge format lines
				if (this.format[$-1] == li.format[0]) {
					this.format[$-1].len += li.format[0].len;
					this.format ~= li.format[1..$];
				} else {
					this.format ~= li.format;
				}
			} else if (this.format !is null) {
				// Make a format for the 2nd line
				this.format ~= [new LineFormat(_forecolor, _backcolor, li.value.length)];
			} else if (li.format !is null) {
				// Make a format for the 1st line
				this.format = [new LineFormat(_forecolor, _backcolor, this.value.length)] ~ li.format;
			} else {
				// Ignore formats if none exist
			}

			this.value ~= li.value;
		}

		LineInfo opCat(LineInfo li) {
			LineInfo li_new = this.dup();
			li_new ~= li;
			return li_new;
		}

		string value;
		LineFormat[] format;
	}

	// Stores the buffer of lines
	List!(LineInfo) _lines;

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

	// The width of a single tab character expressed in spaces
	uint _tabWidth;

	// The default text colors
 	Color _forecolor = Color.Gray;
	Color _backcolor = Color.Black;
	Color _forecolorNum = Color.DarkYellow;
	Color _backcolorNum = Color.Black;

	// The symbol to use to show a line continuation
	dchar _lineCont;

	// How to scroll horizontally and vertically
	ScrollType _scrollH, _scrollV;
}
