/*
 * dialog.d
 *
 * This module implements a GUI dialog.
 *
 */

module gui.dialog;

import djehuty;

import gui.window;

class Dialog : Window {
private:
	WindowStyle _style = WindowStyle.Sizable;

public:
	this(double x, double y, double width, double height) {
		super(x,y,width,height);
	}

	void style(WindowStyle value) {
		_style = value;
	}

	WindowStyle style() {
		return _style;
	}
}
