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

	// The timer foo
	bool _timerIsLarge;		// if using _largeChange
	bool _timerIncreasing;	// if scrolling in a positive direction
	int _timerLastPos;		// the last pos

	Timer _timer;			// the timer for holding down the buttons

	// The orientation
	Orientation _orientation;

	// Various colors
	Color _buttonBackcolor = Color.Blue;
	Color _buttonForecolor = Color.Gray;

	Color _thumbBackcolor = Color.Blue;
	Color _thumbForecolor = Color.Gray;

	Color _areaBackcolor = Color.White;

	// These store the value
	long _max = 100;
	long _min = 0;
	long _value = 0;

	long _smallChange = 1;
	long _largeChange = 5;

	// Thumb foo

	int _thumbSize;
	int _thumbPos;
	bool _thumbDragged;

	CuiButton _minusButton;
	CuiButton _plusButton;

	// This function computes where the thumb bar is and how large it is.
	void computeThumbBounds() {
		computeThumbBounds(_value);
	}

	void computeThumbBounds(long withValue) {
		// Thumb area size is the area that represents a large change
		long area = _max - _min;
		if (withValue > _max) {
			withValue = _max;
		}
		else if (withValue < _min) {
			withValue = _min;
		}
		long pos = withValue - _min;

		double percent = cast(double)pos / cast(double)area;

		// The thumb size is the width of the bar area (the width of the
		// widget minus the width of both buttons) times the percentage
		// of the large change area.
		int barSize;

		if (_orientation == Orientation.Horizontal) {
			barSize = this.width - (this.height * 2);
		}
		else {
			barSize = this.height - (this.width * 2);
		}

		double largeChangeArea = 1.0;
		if (area != 0) {
			largeChangeArea = cast(double)_largeChange / (cast(double)area + cast(double)_largeChange);
		}
		if (largeChangeArea > 1.0) {
			largeChangeArea = 1.0;
		}

		_thumbSize = cast(int)(cast(double)barSize * largeChangeArea);

		if (_thumbSize < 1) {
			_thumbSize = 1;
		}

		int thumbArea = barSize - _thumbSize;

		// Thumb position
		_thumbPos = cast(int)(thumbArea * percent);
		if (_thumbPos < 0) {
			_thumbPos = 0;
		}
	}

	// This will be called when the timer signals.
	bool timerProc(Dispatcher dsp, uint signal) {
		if (_timerIsLarge) {
			// if the cursor is now over the thumb bar, stop!
			int comp = componentAtPosition(_timerLastPos);
			if (comp == 0) {
				return true;
			}
			this.value = this.value + (comp * _largeChange);
		}
		else if (_timerIncreasing) {
			this.value = this.value + _smallChange;
		}
		else {
			this.value = this.value - _smallChange;
		}
		return false;
	}

	// This will be called when the button signals an action.
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
				_timerIsLarge = false;
				_timerIncreasing = direction == 1;
				_timer.start();
				break;
			default:
				break;
		}
		return true;
	}

	// This helper function will take a position and report which section of the bar
	// is at that position. 0 will be the thumb (no movement), -1 is to the left of the
	// thumb (negative movement) and 1 is to the right (positive movement)
	int componentAtPosition(int mousePos) {
		// get thumb bounds
		computeThumbBounds();

		if (mousePos > _thumbPos && mousePos <= _thumbPos + _thumbSize) {
			// Mouse is clicked inside of the thumb bar
			return 0;
		}
		else if (mousePos <= _thumbPos) {
			return -1;
		}
		else {
			return 1;
		}
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
		_timer.interval = _timerInterval;

		attach(_timer, &timerProc);

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

		attach(_minusButton, &buttonHandler);
		attach(_plusButton, &buttonHandler);
	}

	override void onDrag(ref Mouse mouse) {
		if (_thumbDragged) {
			// get thumb bounds
			computeThumbBounds();

			// need the difference since the last movement
			int diff;
			int buttonSize;
			int barSize;
			int mousePos;

			if (_orientation == Orientation.Horizontal) {
				mousePos = cast(int)mouse.x;
				buttonSize = _plusButton.width;
				barSize = this.width - (buttonSize*2);
			}
			else {
				mousePos = cast(int)mouse.y;
				buttonSize = _plusButton.height;
				barSize = this.height - (buttonSize*2);
			}

			diff = mousePos - _timerLastPos;
			if (diff == 0) {
				return;
			}

			// Now move the thumb bar to that position

			// |....|xxx|....| - visual representation, x = thumb bar

			// |-------------| - width (barSize)
			// |---------|     - width of the area (thumbArea)
			// ^--- minimum thumb position (0)
			//           ^--- maximum thumb position (thumbArea)

			int thumbArea = barSize - _thumbSize;
			if (thumbArea <= 0) {
				return;
			}

			int newThumbPos = _thumbPos + diff;

			if (newThumbPos < 0) {
				newThumbPos = 0;
			}
			else if (newThumbPos > thumbArea) {
				newThumbPos = thumbArea;
			}

			// Ensure that we are moving the thumb bar to the mouse position
			if (mousePos < buttonSize && _thumbPos == newThumbPos) {
				return;
			}
			else if (mousePos >= buttonSize + barSize && _thumbPos == newThumbPos) {
				return;
			}

			double percent = cast(double)newThumbPos / cast(double)thumbArea;

			long newValue = this.value;

			double change = 0.25 * (1.0 / cast(double)thumbArea);

			// Keep adjusting the value until it lines up correctly
			// We adjust using the percentage of the scrolling space that makes up
			// a quarter of a character cell.
			while(_thumbPos != newThumbPos) {
				newValue = cast(long)(percent * cast(double)(_max - _min) + cast(double)_min);
				computeThumbBounds(newValue);
				if (_max == _min) {
					break;
				}
				if (_thumbPos < newThumbPos) {
					percent += change;
				}
				else if (_thumbPos > newThumbPos) {
					percent -= change;
				}
			}

			this.value = newValue;
		}

		// update to the current position
		if (_orientation == Orientation.Horizontal) {
			_timerLastPos = cast(int)mouse.x;
		}
		else {
			_timerLastPos = cast(int)mouse.y;
		}
	}

	override void onPrimaryUp(ref Mouse mouse) {
		_thumbDragged = false;
		_timer.stop();
	}

	override void onPrimaryDown(ref Mouse mouse) {
		int mousePos;
		int buttonSize;
		int barExtent;

		if (_orientation == Orientation.Horizontal) {
			mousePos = cast(int)mouse.x;
			buttonSize = _plusButton.width;
			barExtent = this.width - buttonSize;
		}
		else {
			mousePos = cast(int)mouse.y;
			buttonSize = _plusButton.height;
			barExtent = this.height - buttonSize;
		}

		if (mousePos >= buttonSize && mousePos < barExtent) {
			// inside the bar
			int comp = componentAtPosition(mousePos);

			if (comp == 0) {
				// thumb bar
				_thumbDragged = true;
				_timerLastPos = mousePos;
			}
			else {
				// Mouse is clicked to the left or right of the thumb bar
				this.value = this.value + (comp * _largeChange);
				_timerLastPos = mousePos;

				// Set a timer
				_timerIsLarge = true;
				_timer.start();
			}
		}
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