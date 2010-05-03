/*
 * container.d
 *
 * This module implements a widget container for CuiWidget.
 *
 * Author: Dave Wilkinson
 * Originated: August 20th 2009
 *
 */

module cui.container;

import cui.widget;

import core.event;
import core.definitions;
import core.string;

private import io.console;

class CuiContainer : CuiWidget {
	this(uint x, uint y, uint width, uint height) {
		_name = "";
		super(x,y,width,height);
	}

	override void onInit() {
		_inited = true;
		CuiWidget c = _firstControl;

		if (c is null) { return; }

		do {
			c =	c._prevControl;

			c.onInit();
			//if ()
			//c.onDraw();
		} while (c !is _firstControl)
	}

	override void onGotFocus() {
		if (_focusedControl is null) {
			CuiWidget c = _firstControl;

			if (c is null) { return; }

			do {
				c = c._prevControl;
				if (c.isTabStop()) {
					_focusedControl = c;
					_focusedControl.onGotFocus();
					break;
				}
			} while (c !is _firstControl);
		}
		else {
			_focusedControl.onGotFocus();
		}
	}

	override void onLostFocus() {
		if (_focusedControl !is null) {
			_focusedControl.onLostFocus();
		}
	}

	override void onDraw() {
		// Go through child widget list and draw each one
		Console.position(0,0);

		CuiWidget c = _firstControl;

		io.console.Console.clipSave();

		if (c !is null) {
			do {
				c =	c._prevControl;

				io.console.Console.clipSave();
				this.widgetClippingContext = c;
				c.onDraw();
				io.console.Console.clipRestore();
				io.console.Console.clipRect(_base_x + this.left + c.left, _base_y + this.top + c.top, _base_x + this.left + c.left + c.width, _base_y + this.top + c.top + c.height);
			} while(c !is _firstControl);
		}

		// Should clear the rest of the space not used by a widget
		static string spaces = "                                                                                                                  ";

		Console.setColor(bgColor.White);
		for (uint i; i < this.height; i++) {
			Console.position(0,i);
			io.console.Console.setColor(bgColor.Black);
			uint numSpaces = this.width;

			do {
				uint pad = spaces.length;
				if (numSpaces < pad) {
					pad = numSpaces;
				}
				io.console.Console.put(spaces[0..pad]);
				numSpaces -= pad;
			} while (numSpaces > 0)
		}
		io.console.Console.clipRestore();
	}

	override void onKeyDown(Key key) {
		if (_focusedControl !is null) {
			_focusedControl.onKeyDown(key);
		}
	}

	override void onKeyChar(dchar chr) {
		if (_focusedControl !is null) {
			_focusedControl.onKeyChar(chr);
		}
	}

	override void onPrimaryMouseDown() {
		if (_focusedControl !is null) {
			_focusedControl.onPrimaryMouseDown();
		}
	}

	override void onSecondaryMouseDown() {
		if (_focusedControl !is null) {
			_focusedControl.onSecondaryMouseDown();
		}
	}
	
	override void onTertiaryMouseDown() {
		if (_focusedControl !is null) {
			_focusedControl.onTertiaryMouseDown();
		}
	}
	
	override void onPrimaryMouseUp() {
		if (_focusedControl !is null) {
			_focusedControl.onPrimaryMouseUp();
		}
	}

	override void onSecondaryMouseUp() {
		if (_focusedControl !is null) {
			_focusedControl.onSecondaryMouseUp();
		}
	}

	override void onTertiaryMouseUp() {
		if (_focusedControl !is null) {
			_focusedControl.onTertiaryMouseUp();
		}
	}
	
	override void onMouseWheelY(int amount) {
		if (_focusedControl !is null) {
			_focusedControl.onMouseWheelY(amount);
		}
	}
	
	override void onMouseWheelX(int amount) {
		if (_focusedControl !is null) {
			_focusedControl.onMouseWheelX(amount);
		}
	}

	override void onMouseMove() {
		if (_focusedControl !is null) {
			_focusedControl.onMouseMove();
		}
	}

	override void push(Dispatcher dsp) {
		if (cast(CuiWidget)dsp) {
			// do not add a control that is already part of another window
			CuiWidget control = cast(CuiWidget)dsp;

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
	
	override void move(uint x, uint y) {
		// Must report to each control
		_reportMove(x, y);

		super.move(x,y);
	}
	
	void text(string name) {
		_name = name.dup;
	}

	string text() {
		return _name.dup;
	}

protected:

	// head and tail of the control linked list
	CuiWidget _firstControl;	//head
	CuiWidget _lastControl;		//tail

	// currently focused control
	CuiWidget _focusedControl;

	uint _numControls;

	bool _inited;
	bool _isTabStop;
	
	string _name;

	void _reportMove(uint x, uint y) {
		CuiWidget c = _firstControl;

		if (c is null) {
			super.move(x,y);
			return;
		}

		do {
			c = c._prevControl;
			c._base_x = _base_x + x;
			c._base_y = _base_y + y;
			if (cast(CuiContainer)c) {
				CuiContainer container = cast(CuiContainer)c;
				container._reportMove(c.left, c.top);
			}
		} while (c !is _firstControl);
	}

	package void _tabForward() {
		// activate the next control
		CuiWidget curFocus = _focusedControl;

		if (curFocus is null) { return; }

		_focusedControl.onLostFocus();

		do {
			_focusedControl = _focusedControl._prevControl;
			if (_focusedControl is _firstControl && _owner !is null) {
				_owner._tabForward();
			}
			if (_focusedControl.isTabStop()) {
				_focusedControl.onGotFocus();
				break;
			}
		} while (_focusedControl !is curFocus);
	}

	package void _tabBackward() {
		// activate the previous control
		CuiWidget curFocus = _focusedControl;

		if (curFocus is null) { return; }

		_focusedControl.onLostFocus();

		do {
			_focusedControl = _focusedControl._nextControl;
			if (_focusedControl is _firstControl && _owner !is null) {
				_owner._tabBackward();
			}
			if (_focusedControl.isTabStop()) {
				_focusedControl.onGotFocus();
				break;
			}
		} while (_focusedControl !is curFocus);
	}
}
