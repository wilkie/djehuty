/*
 * container.d
 *
 * This module implements a widget container for TuiWidget.
 *
 * Author: Dave Wilkinson
 * Originated: August 20th 2009
 *
 */

module tui.container;

import tui.widget;

import core.event;
import core.definitions;

import io.console;

class TuiContainer : TuiWidget {
	this(uint x, uint y, uint width, uint height) {
		super(x,y,width,height);
	}
	
	override void onInit() {
		_inited = true;
		TuiWidget c = _firstControl;

		if (c is null) { return; }
		do {
			c =	c._prevControl;

			c.onInit();
			c.onDraw();
		} while (c !is _firstControl)
	}

	override void onGotFocus() {
		if (_focused_control is null) {
			TuiWidget c = _firstControl;

			if (c is null) { return; }

			do {
				c = c._prevControl;
				if (c.isTabStop()) {
					_focused_control = c;
					_focused_control.onGotFocus();
					break;
				}
			} while (c !is _firstControl);
		}
		else {
			_focused_control.onGotFocus();
		}
	}

	override void onLostFocus() {
		if (_focused_control !is null) {
			_focused_control.onLostFocus();
		}
	}

	override void onDraw() {
		// Go through child widget list and draw each one
		moveCaret(0,0);

		TuiWidget c = _firstControl;

		if (c is null) { return; }

		do {
			c =	c._prevControl;

			c.onDraw();
		} while(c !is _firstControl);

		// Should clear the rest of the space not used by a widget

	}

	override void onKeyDown(Key key) {
		if (_focused_control !is null) {
			_focused_control.onKeyDown(key);
		}
	}

	override void onKeyChar(dchar chr) {
		if (_focused_control !is null) {
			_focused_control.onKeyChar(chr);
		}
	}
	
	override void onPrimaryMouseDown() {
		if (_focused_control !is null) {
			_focused_control.onPrimaryMouseDown();
		}
	}
	
	override void onSecondaryMouseDown() {
		if (_focused_control !is null) {
			_focused_control.onSecondaryMouseDown();
		}
	}
	
	override void onTertiaryMouseDown() {
		if (_focused_control !is null) {
			_focused_control.onTertiaryMouseDown();
		}
	}
	
	override void onPrimaryMouseUp() {
		if (_focused_control !is null) {
			_focused_control.onPrimaryMouseUp();
		}
	}

	override void onSecondaryMouseUp() {
		if (_focused_control !is null) {
			_focused_control.onSecondaryMouseUp();
		}
	}

	override void onTertiaryMouseUp() {
		if (_focused_control !is null) {
			_focused_control.onTertiaryMouseUp();
		}
	}
	
	override void onMouseWheelY(int amount) {
		if (_focused_control !is null) {
			_focused_control.onMouseWheelY(amount);
		}
	}
	
	override void onMouseWheelX(int amount) {
		if (_focused_control !is null) {
			_focused_control.onMouseWheelX(amount);
		}
	}

	override void onMouseMove() {
		if (_focused_control !is null) {
			_focused_control.onMouseMove();
		}
	}

	override void push(Dispatcher dsp) {
		if (cast(TuiWidget)dsp) {
			// do not add a control that is already part of another window
			TuiWidget control = cast(TuiWidget)dsp;

			if (control._nextControl !is null) {
				return;
			}

			// add to the control linked list
			if (_firstControl is null && _lastControl is null) {
				// first control

				_firstControl = control;
				_lastControl = control;

				control._nextControl = control;
				control._prevControl = control;
			}
			else {
				// next control

				control._nextControl = _firstControl;
				control._prevControl = _lastControl;

				_firstControl._prevControl = control;
				_lastControl._nextControl = control;

				_firstControl = control;
			}

			// increase the number of controls
			_numControls++;

			Responder.push(dsp);

			control._owner = this;
			control._window = _window;
			control._base_x = _base_x + this.left;
			control._base_y = _base_y + this.top;

			_isTabStop |= control.isTabStop();

			// Call event
			control.onAdd();

			if (_inited) {
				control.onInit();
			}
			return;
		}
		super.push(dsp);
	}
	
	override bool isTabStop() {
		return _isTabStop;
	}

protected:

	// head and tail of the control linked list
	TuiWidget _firstControl;	//head
	TuiWidget _lastControl;		//tail

	// currently focused control
	TuiWidget _focused_control;

	uint _numControls;

	bool _inited;
	bool _isTabStop;

	package void _tabForward() {
		// activate the next control
		TuiWidget curFocus = _focused_control;

		_focused_control.onLostFocus();

		do {
			_focused_control = _focused_control._prevControl;
			if (_focused_control is _firstControl && _owner !is null) {
				_owner._tabForward();
			}
			if (_focused_control.isTabStop()) {
				_focused_control.onGotFocus();
				break;
			}
		} while (_focused_control !is curFocus);
	}

	package void _tabBackward() {
		// activate the previous control
		TuiWidget curFocus = _focused_control;

		_focused_control.onLostFocus();

		do {
			_focused_control = _focused_control._nextControl;
			if (_focused_control is _firstControl && _owner !is null) {
				_owner._tabBackward();
			}
			if (_focused_control.isTabStop()) {
				_focused_control.onGotFocus();
				break;
			}
		} while (_focused_control !is curFocus);
	}
}