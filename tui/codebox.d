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

		// Keyword Parse
		String work = Regex.eval(line, _keywords);

		// Add Formatting
		if (work !is null) {
			addFormat(lineNumber, line.find(work), work.length);
		}
	}

	// Properties

private:

	void addFormat(uint lineNumber, uint firstPos, uint length) {
		if (_lines[lineNumber].format is null) {
			// Simply add
			_lines[lineNumber].format = 
				[cast(uint)_forecolor, cast(uint)_backcolor, firstPos, 
				 cast(uint)fgColor.BrightBlue, cast(uint)bgColor.Black, length,
				cast(uint)_forecolor, cast(uint)_backcolor, _lines[lineNumber].value.length - firstPos + length];
		}
		else {
			uint last;
			uint pos;
			for (uint idx = 2; idx < _lines[lineNumber].format.length; idx += 3) {
				pos += _lines[lineNumber].format[idx];
				if (pos > firstPos) {
					break;
				}
				last = pos;
			}

			// Split format at firstPos and firstPos + length
			// Add format for this word
		}
	}

	char[] _keywords = `if|else|import`;
}