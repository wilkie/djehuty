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
	string _title;

public:
	this(double x, double y, double width, double height, string title, WindowStyle style = WindowStyle.Sizable) {
		super(x,y,width,height);

		this.text = title;
		this.style = style;
	}

	// Properties

	void text(string value) {
		_title = value.dup;
	}

	string text() {
		return _title.dup;
	}

	void style(WindowStyle value) {
		_style = value;
	}

	WindowStyle style() {
		return _style;
	}
}
