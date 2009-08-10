/*
 * codebox.d
 *
 * This module implements a code aware text-editor TUI widget.
 *
 * Author: Dave Wilkinson
 * Originated: August 6th, 2009
 *
 */

module tui.codebox;

import tui.textbox;

import io.console;

import core.regex;
import core.string;
import core.definitions;

class TuiCodeBox : TuiTextBox {

	// Constructors

	this(uint x, uint y, uint width, uint height) {
		super(x,y,width,height);
	}

	// Events

	override void onLineChanged(uint lineNumber) {
		// When a line is changed, look for language syntax features
		String line = _lines[lineNumber].value;

		// Reset formatting
		_lines[lineNumber].format = null;

		String work;
		int pos;
		int findPos;

		// Keyword Parse
		do {
			work = Regex.eval(line, _keywords);

			// Add Formatting
			if (work !is null) {
				findPos = line.find(work);
				pos += findPos;
				addFormat(lineNumber, pos, work.length);
				pos += work.length;
				findPos += work.length;
				line = line.subString(findPos);
			}
		} while (work !is null)
	}

	// Properties

private:

	void addFormat(uint lineNumber, uint firstPos, uint length) {
		if (_lines[lineNumber].format is null) {
			// Simply add
			_lines[lineNumber].format =
				[cast(uint)_forecolor, cast(uint)_backcolor, firstPos,
				 cast(uint)fgColor.BrightBlue, cast(uint)bgColor.Black, length,
				 cast(uint)_forecolor, cast(uint)_backcolor, _lines[lineNumber].value.length - (firstPos + length)];
		}
		else {
			uint[] newFormat;

			uint last;
			uint pos;
			uint formatIdx;
			for (uint idx = 2; idx < _lines[lineNumber].format.length; idx += 3) {
				pos += _lines[lineNumber].format[idx];
				if (pos > firstPos) {
					formatIdx = idx-2;
					break;
				}
				last = pos;
			}

			// Split format at firstPos
			newFormat = _lines[lineNumber].format[0..formatIdx+3];
			newFormat[formatIdx+2] = firstPos - last;
			newFormat ~= [cast(uint)fgColor.BrightBlue, cast(uint)bgColor.Black, length];
			newFormat ~= _lines[lineNumber].format[formatIdx..formatIdx+3];
			newFormat[formatIdx+2+6] = pos - (firstPos + length);

			_lines[lineNumber].format = newFormat;
		}
	}

	char[] _keywords = `\b(?:if|else|import)\b`;
}