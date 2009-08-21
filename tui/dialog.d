/*
 * dialog.d
 *
 * This module implements a subwindow for Tui applications.
 *
 */

module tui.dialog;

import tui.widget;
import tui.container;

import io.console;

import core.unicode;
import core.event;

class TuiDialog : TuiContainer {
	this(string title, uint x, uint y, uint width, uint height) {
		_title = Unicode.toUtf32(title);
		super(x,y,width,height);
	}
	
	override void onAdd() {
		_base_y++;
	}

	override void onDraw() {
		Console.setPosition(_base_x + this.left, _base_y + this.top - 1);

		changeColor(_forecolor, _backcolor);

		uint x;
		if (_title.length + 2 > this.width) {
			x = 1;
		}
		else {
			x = (this.width - _title.length) / 2;
		}

		put(" ");
		for (uint i = 1; i < x-1; i++) {
			put("-");
		}
		if (x > 1) {
			put(" ");
		}

		put(_title);

		if (x > 1) {
			put(" ");
		}
		for (uint i = x + _title.length + 2; i < this.width; i++) {
			put("-");
		}
		put(" ");

		super.onDraw();
	}

protected:
	dstring _title;

	fgColor _forecolor = fgColor.Black;
	bgColor _backcolor = bgColor.White;
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