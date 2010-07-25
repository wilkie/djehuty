/*
 * scrollbar.d
 *
 * This module implements a console widget for a simple scroll bar,
 * both horizontal and vertical.
 *
 */

module cui.scrollbar;

import djehuty;

import cui.window;
import cui.canvas;
import cui.button;

import synch.timer;

class CuiScrollBar : CuiWindow {
private:

	// The time inbetween updates when the buttons are held down.
	static const int _timerInterval = 150;

	// The orientation
	Orientation _orientation;

	// Various colors
	Color _buttonBackcolor = Color.Blue;
	Color _buttonForecolor = Color.Gray;

	Color _thumbBackcolor = Color.Blue;
	Color _thumbForecolor = Color.Gray;

	Color _areaBackcolor = Color.White;

	// The timer foo
	long _timerDifference;	// the amount to add to _value
	Timer _timer;			// the timer for holding down the buttons

	// These store the value
	long _max = 100;
	long _min = 0;
	long _value = 50;

	long _smallChange = 1;
	long _largeChange = 50;

	int _thumbSize;
	int _thumbPos;

	CuiButton _minusButton;
	CuiButton _plusButton;

	// This function computes where the thumb bar is and how large it is.
	void computeThumbBounds() {
		// Thumb area size is the area that represents a large change
		long area = _max - _min;
		long pos = _value - _min;

		double filled = cast(double)pos / cast(double)area;

		double largeChangeArea = cast(double)_largeChange / cast(double)area;

		// The thumb size is the width of the bar area (the width of the
		// widget minus the width of both buttons) times the percentage
		// of the large change area.
		int barLength;

		if (_orientation == Orientation.Horizontal) {
			barLength = this.width - (this.height * 2);
		}
		else {
			barLength = this.height - (this.width * 2);
		}

		_thumbSize = cast(int)(barLength * largeChangeArea);

		if (_thumbSize < 1) {
			_thumbSize = 1;
		}

		// Thumb position
		_thumbPos = cast(int)((barLength - _thumbSize) * filled);
		if (_thumbPos < 0) {
			_thumbPos = 0;
		}
	}

	bool timerProc(Dispatcher dsp, uint signal) {
		this.value = this.value + _timerDifference;
		return false;
	}

	bool buttonHandler(Dispatcher dsp, uint signal) {
		long direction = 1;

		if (dsp is _minusButton) {
			direction = -1;
		}

		switch(signal) {
			case CuiButton.Signal.Released:
				// Kill the timer
				_timer.stop();
				break;
			case CuiButton.Signal.Pressed:
				this.value = this.value + direction * _smallChange;

				// Set a timer
				_timerDifference = direction * _smallChange;
				_timer.start();
				break;
			default:
				break;
		}
		return true;
	}

public:

	enum Signal {
		Changed
	}

	// Description: This function will create a scrollbar widget that will
	//  go in the direction indicated by orientation.
	// x: The x coordinate of the widget.
	// y: The y coordinate of the widget.
	// width: The width of the widget.
	// height: The height of the widget.
	// orientation: Whether the bar is horizontal or vertical.
	this(int x, int y, int width, int height, Orientation orientation) {
		super(x, y, width, height);

		_timer = new Timer();
		_timerDifference = 0;

		_timer.interval = _timerInterval;

		push(_timer, &timerProc);

		_orientation = orientation;

		if (_orientation == Orientation.Horizontal) {
			_minusButton = new CuiButton(0, 0, this.height, this.height, "\u2190");
			_minusButton.forecolor = _buttonForecolor;
			_minusButton.backcolor = _buttonBackcolor;

			_plusButton = new CuiButton(this.width - this.height, 0, this.height, this.height, "\u2192");
			_plusButton.forecolor = _buttonForecolor;
			_plusButton.backcolor = _buttonBackcolor;
		}
		else {
			_minusButton = new CuiButton(0, 0, this.width, this.width, "\u2191");
			_minusButton.forecolor = _buttonForecolor;
			_minusButton.backcolor = _buttonBackcolor;

			_plusButton = new CuiButton(0, this.height - this.width, this.width, this.width, "\u2193");
			_plusButton.forecolor = _buttonForecolor;
			_plusButton.backcolor = _buttonBackcolor;
		}

		push(_minusButton, &buttonHandler);
		push(_plusButton, &buttonHandler);
	}
	
	override void onPrimaryDown(ref Mouse mouse) {
		// get thumb bounds
		computeThumbBounds();

		int mousePos = 0;
		int buttonSize = 0;
		int barExtent = 0;

		if (_orientation == Orientation.Horizontal) {
			buttonSize = _plusButton.width;
			mousePos = cast(int)mouse.x;
			barExtent = this.width - buttonSize;
		}
		else {
			buttonSize = _plusButton.height;
			mousePos = cast(int)mouse.y;
			barExtent = this.height - buttonSize;
		}

		if (mousePos >= buttonSize && mousePos < barExtent) {
			// Mouse is clicked inside the area of the bar
			if (mousePos > _thumbPos && mousePos <= _thumbPos + _thumbSize) {
				// Mouse is clicked inside of the thumb bar
			}
			else if (mousePos <= _thumbPos) {
				// Mouse is clicked to the left of the thumb bar
				this.value = this.value - _largeChange;
			}
			else {
				this.value = this.value + _largeChange;
			}
		}
		super.onPrimaryDown(mouse);
	}

	override void onDraw(CuiCanvas canvas) {
		// get thumb bounds
		computeThumbBounds();

		if (_orientation == Orientation.Horizontal) {
			// Buttons are square
			int buttonWidth = _plusButton.width;

			for(int i = 0; i < this.height; i++) {
				canvas.position(buttonWidth, i);

				// Draw the area up to the thumb
				canvas.backcolor = _areaBackcolor;

				canvas.write(times(" ", _thumbPos));

				// Draw the thumb
				canvas.forecolor = _thumbForecolor;
				canvas.backcolor = _thumbBackcolor;

				canvas.write(times(" ", _thumbSize));

				// Draw the rest of the area up to the second button
				canvas.backcolor = _areaBackcolor;

				canvas.write(times(" ", this.width - (buttonWidth*2) - _thumbPos - _thumbSize));
			}
		}
		else {
			// Buttons are square
			int buttonHeight = _plusButton.height;

			for(int i = buttonHeight; i < (this.height - buttonHeight); i++) {
				canvas.position(0,i);
				if (i == _thumbPos + buttonHeight) {
					canvas.forecolor = _thumbForecolor;
					canvas.backcolor = _thumbBackcolor;
				}
				else if (i == buttonHeight || (i == (buttonHeight + _thumbPos + _thumbSize))) {
					canvas.backcolor = _areaBackcolor;
				}

				canvas.write(times(" ", this.width));
			}
		}
	}

	// Properties

	// Description: This function will get the orientation.
	// Returns: The current orientation.
	Orientation orientation() {
		return _orientation;
	}

	// Description: This function will set the orientation.
	// value: The new orientation.
	void orientation(Orientation value) {
		_orientation = value;
		redraw();
	}

	// Description: This function will get the value.
	// Returns: The current value.
	long value() {
		return _value;
	}

	// Description: This function will set the value.
	// value: The new value.
	void value(long value) {
		_value = value;
		if (_value > _max) {
			_value = _max;
		}
		else if (_value < _min) {
			_value = _min;
		}
		raiseSignal(CuiScrollBar.Signal.Changed);
		redraw();
	}

	// Description: This function will get the maximum value.
	// Returns: The maximum value.
	long max() {
		return _max;
	}

	// Description: This function will set the maximum value.
	// value: The new maximum value.
	void max(long value) {
		_max = value;
		if (_max <= _min) {
			_max = _min;
		}
		if (_value >= _max) {
			_value = _max;
		}
		redraw();
	}

	// Description: This function will get the maximum value.
	// Returns: The maximum value.
	long min() {
		return _min;
	}

	// Description: This function will set the minimum value.
	// value: The new minimum value.
	void min(long value) {
		_min = value;
		if (_max <= _min) {
			_min = _max;
		}
		if (_value <= _min) {
			_value = _min;
		}
		redraw();
	}

	// Description: This function will get the amount that is scrolled when the buttons are pressed.
	// Returns: The amount that will be scrolled.
	long smallChange() {
		return _smallChange;
	}

	// Description: This function will set the amount that is scrolled when the buttons are pressed.
	// value: The new amount to scroll.
	void smallChange(long value) {
		_smallChange = value;
		redraw();
	}

	// Description: This function will get the amount that is scrolled when a page is scrolled. This
	//  is whenever the inner area is clicked or page up or page down is pressed.
	// Returns: The amount that will be scrolled.
	long largeChange() {
		return _largeChange;
	}

	// Description: This function will set the amount that is scrolled when a page is scrolled. This
	//  is whenever the inner area is clicked or page up or page down is pressed.
	// value: The new amount to scroll.
	void largeChange(long value) {
		_largeChange = value;
		redraw();
	}
}