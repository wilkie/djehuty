/*
 * scrollbar.d
 *
 * This module implements a scroll bar widget for gui applications.
 *
 */

module gui.scrollbar;

import djehuty;

import gui.window;
import gui.button;

import graphics.canvas;
import graphics.brush;
import graphics.pen;
import graphics.gradient;
import graphics.path;

import synch.timer;

import io.console;

class ScrollBar : Window {
private:

	// The time inbetween updates when the buttons are held down.
	static const int _timerInterval = 150;

	// The timer foo
	bool _timerIsLarge;		// if using _largeChange
	bool _timerIncreasing;	// if scrolling in a positive direction
	double _timerLastPos;		// the last pos

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

	double _thumbSize;
	double _thumbPos;
	bool _thumbDragged;
	double _diff;
	double _dragThumbPos;

	Button _minusButton;
	Button _plusButton;

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
		double barSize;

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

		double thumbArea = barSize - _thumbSize;

		// Thumb position
		_thumbPos = thumbArea * percent;
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
			case Button.Signal.Released:
				// Kill the timer
				_timer.stop();
				break;
			case Button.Signal.Pressed:
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
	int componentAtPosition(double mousePos) {
		// get thumb bounds
		computeThumbBounds();

		if (_orientation == Orientation.Vertical) {
			mousePos -= this.width;
		}
		else {
			mousePos -= this.height;
		}

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

	this(double x, double y, double width, double height, Orientation orientation = Orientation.Vertical) {
		super(x, y, width, height);

		_timer = new Timer();
		_timer.interval = _timerInterval;

		attach(_timer, &timerProc);

		_orientation = orientation;

		if (_orientation == Orientation.Horizontal) {
			_minusButton = new Button(0, 0, this.height, this.height, "-");
			_plusButton = new Button(this.width - this.height, 0, this.height, this.height, "+");
		}
		else {
			_minusButton = new Button(0, 0, this.width, this.width, "-");
			_plusButton = new Button(0, this.height - this.width, this.width, this.width, "+");
		}

		this.attach(_plusButton, &buttonHandler);
		this.attach(_minusButton, &buttonHandler);
	}

	override void onMouseUp(Mouse mouse, uint button) {
		_thumbDragged = false;
		_timer.stop();
	}

	override void onMouseDown(Mouse mouse, uint button) {
		double mousePos;
		double buttonSize;
		double barExtent;

		if (_orientation == Orientation.Horizontal) {
			mousePos = mouse.x;
			_diff = mouse.x;
			buttonSize = _plusButton.width;
			barExtent = this.width - buttonSize;
		}
		else {
			mousePos = mouse.y;
			_diff = mouse.y;
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

		_dragThumbPos = _thumbPos;
	}

	override void onMouseDrag(Mouse mouse) {
		if (_thumbDragged) {
			// get thumb bounds
			computeThumbBounds();

			// need the difference since the last movement
			double diff;
			double buttonSize;
			double barSize;
			double mousePos;

			if (_orientation == Orientation.Horizontal) {
				mousePos = mouse.x;
				buttonSize = _plusButton.width;
				barSize = this.width - (buttonSize*2);
			}
			else {
				mousePos = mouse.y;
				buttonSize = _plusButton.height;
				barSize = this.height - (buttonSize*2);
			}

			diff = mousePos - _diff;
			if (diff == 0) {
				return;
			}

			// Now move the thumb bar to that position

			// |....|xxx|....| - visual representation, x = thumb bar

			// |-------------| - width (barSize)
			// |---------|     - width of the area (thumbArea)
			// ^--- minimum thumb position (0)
			//           ^--- maximum thumb position (thumbArea)

			double thumbArea = barSize - _thumbSize;
			if (thumbArea <= 0) {
				return;
			}

			double newThumbPos = _dragThumbPos + diff;
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

			double percent = newThumbPos / thumbArea;

			long newValue = cast(long)((newThumbPos * cast(double)(this.max - this.min)) / thumbArea);
			newValue += this.min;
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

	void onDraw(Canvas canvas) {
		computeThumbBounds();

		canvas.brush = new Brush(this.backcolor);
		canvas.fillRectangle(0, 0, this.width, this.height);

		canvas.brush = new Brush(Color.fromRGBA(0, 0, 0.6, 0.5));
		canvas.pen = new Pen(Color.fromRGBA(0, 0, 0.6, 0.7));

		canvas.fillRectangle(0, this.width, this.width, this.height - (this.width*2));

		canvas.drawRectangle(0, _thumbPos + this.width, this.width, _thumbSize);
	}

	// Properties

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
		raiseSignal(ScrollBar.Signal.Changed);
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