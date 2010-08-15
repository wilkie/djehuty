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
public:
	this(double x, double y, double width, double height) {
		super(x,y,width,height);
	}
}
