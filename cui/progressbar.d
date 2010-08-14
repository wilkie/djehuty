/*
 * progressbar.d
 *
 * This module implements a progress bar console widget.
 *
 */

module cui.progressbar;

import djehuty;

import cui.window;
import cui.canvas;

class CuiProgressBar : CuiWindow {
private:

	// Stores the colors used to draw the widget
	Color _fg = Color.Blue;
	Color _bg = Color.White;

	// Stores the value that indicates the progress
	double _value = 0.0;

public:

	// Description: This constructor will create a new progress bar widget.
	// x: The x coordinate of the widget.
	// y: The y coordinate of the widget.
	// width: The width of the widget.
	// height: The height of the widget.
	this(int x, int y, int width, int height) {
		super(x, y, width, height);
	}

	override void onDraw(CuiCanvas canvas) {
		canvas.forecolor = _fg;
		canvas.backcolor = _bg;

		int filledArea = cast(int)(cast(double)this.width * _value);
		if (filledArea < 0) {
			return;
		}

		string clientArea = times("\u2588", filledArea) ~ times(" ", this.width - filledArea);
		for(int i = 0; i < this.height; i++) {
			canvas.position(0, i);
			canvas.write(clientArea);
		}
	}

	// Properties

	// Description: This function will set the value of the progress bar and redraw.
	// newValue: The new value for the progress bar given as a percentage where 0.0 is empty and 1.0 is full.
	void value(double newValue) {
		// if it is nan, set to 0.0
		if (newValue !<>= newValue) {
			newValue = 0.0;
		}
		_value = newValue;
		redraw();
	}

	// Description: This function will get the value of the progress bar.
	// Returns: The current value as a percentage where 0.0 is empty and 1.0 is full.
	double value() {
		return _value;
	}
}