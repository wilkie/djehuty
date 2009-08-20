/*
 * dialog.d
 *
 * This module implements a subwindow for Tui applications.
 *
 */

module tui.dialog;

import tui.widget;

import io.console;

class TuiDialog : TuiWidget {
	this(string title, uint x, uint y, uint width, uint height) {
		_title = cast(dchar[])title;
		super(x,y,width,height);
	}

	override void onDraw() {
		Console.clipSave();
		Console.clipRestore();
	}

protected:
	dstring _title;
}