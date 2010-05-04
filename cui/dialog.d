/*
 * dialog.d
 *
 * This module implements a subwindow for Cui applications.
 *
 */

module cui.dialog;

import cui.widget;
import cui.container;

private import io.console;

import djehuty;

class CuiDialog : CuiContainer {
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

		io.console.Console.forecolor = _forecolor;
		io.console.Console.backcolor = _backcolor;

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

	Color _forecolor = Color.Black;
	Color _backcolor = Color.White;

	uint _old_base_y;
}

import cui.filebox;
import cui.listbox;

class CuiOpenDialog : CuiDialog {
	this(uint x, uint y) {
		super("Open", x, y, 60, 20);
	}

	override void onAdd() {
		super.onAdd();
		push(files = new CuiFileBox(0,0,60,19));
	}
protected:
	CuiFileBox files;
}
