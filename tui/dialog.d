/*
 * dialog.d
 *
 * This module implements a subwindow for Tui applications.
 *
 */

module tui.dialog;

import tui.widget;
import tui.container;

private import io.console;

import core.unicode;
import core.event;
import core.definitions;

class TuiDialog : TuiContainer {
	this(string title, uint x, uint y, uint width, uint height) {
		_title = Unicode.toUtf32(title);
		super(x,y,width,height);
	}

	override void onAdd() {
		_old_base_y = _base_y;
		_base_y++;
	}

	override void onDraw() {
		io.console.Console.position(_base_x + this.left, _base_y + this.top - 1);

		io.console.Console.setColor(_forecolor, _backcolor);

		uint x;
		if (_title.length + 2 > this.width) {
			x = 1;
		}
		else {
			x = (this.width - _title.length) / 2;
		}

		io.console.Console.put(" ");
		for (uint i = 1; i < x-1; i++) {
			io.console.Console.put("-");
		}
		if (x > 1) {
			io.console.Console.put(" ");
		}

		io.console.Console.put(_title);

		if (x > 1) {
			io.console.Console.put(" ");
		}
		for (uint i = x + _title.length + 2; i < this.width; i++) {
			io.console.Console.put("-");
		}
		io.console.Console.put(" ");

		super.onDraw();
	}

protected:

	override void _reportMove(uint x, uint y) {
		_base_y++;
		super._reportMove(x,y);
	}

	dstring _title;

	fgColor _forecolor = fgColor.Black;
	bgColor _backcolor = bgColor.White;

	uint _old_base_y;
}

import tui.filebox;
import tui.listbox;

class TuiOpenDialog : TuiDialog {
	this(uint x, uint y) {
		super("Open", x, y, 60, 20);
	}

	override void onAdd() {
		super.onAdd();
		push(files = new TuiFileBox(0,0,60,19));
	}
protected:
	TuiFileBox files;
}
