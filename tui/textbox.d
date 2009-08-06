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

import io.console;

import utils.arraylist;

class TuiTextBox : TuiWidget {
	this(uint x, uint y, uint width, uint height) {
		super(x,y,width,height);

		_lines = new ArrayList!(String);
		_lines.addItem(new String("Hello"));
	}

	void onInit() {
		draw();
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
			Console.setPosition(this.left, this.top + (i - _row));
			Console.put(_lines[i]);

			// Pad with spaces
			for (k = _lines[i].length; k < this.right; k++) {
				Console.put(" ");
			}
		}
	}

	ArrayList!(String) _lines;

	uint _firstVisible;

	uint _row;
	uint _column;
}