module tui.window;

import tui.application;
import tui.widget;

import core.event;
import core.definitions;

import io.console;

// Description: This class abstacts the console window and allows for high level console operations which are abstracted away as controls.  It is the Window class for the console world.
class TuiWindow : Responder {
	// Constructor

	this() {
	}

	this(bgColor bgClr) {
		_bgClr = bgClr;
	}

	// Events

	void onInitialize() {
		// go through control list, init

		Console.setColor(_bgClr);
		Console.clear();

		TuiWidget c = _firstControl;

		if (c !is null) {
			do {
				c =	c._prevControl;

				c.onInit();
				c.onDraw();
			} while (c !is _firstControl)

			_focused_control = c;

			do {
				_focused_control = _focused_control._prevControl;
				if (_focused_control.isTabStop()) {
					_focused_control.onGotFocus();
					break;
				}
			} while (_focused_control !is c);
		}
	}

	void onUninitialize() {
	}

	void onResize() {
	}

	void redraw() {

		TuiWidget c = _firstControl;

		if (c !is null) {
			do {
				c =	c._prevControl;

				c.onDraw();
			} while (c !is _firstControl)
		}
	}

	void onKeyDown(Key key) {
		if (_focused_control !is null) {
			_focused_control.onKeyDown(key);
		}
	}

	void onKeyChar(dchar keyChar) {
		if (_focused_control !is null) {
			_focused_control.onKeyChar(keyChar);
		}
	}

	void onKeyUp(Key key) {
		if (_focused_control !is null) {
			_focused_control.onKeyUp(key);
		}
	}

	void onPrimaryMouseDown() {
		if (_focused_control !is null) {
			_focused_control.onPrimaryMouseDown();
		}
	}

	void onPrimaryMouseUp() {
		if (_focused_control !is null) {
			_focused_control.onPrimaryMouseUp();
		}
	}

	void onSecondaryMouseDown() {
		if (_focused_control !is null) {
			_focused_control.onSecondaryMouseDown();
		}
	}

	void onSecondaryMouseUp() {
		if (_focused_control !is null) {
			_focused_control.onSecondaryMouseUp();
		}
	}

	void onTertiaryMouseDown() {
		if (_focused_control !is null) {
			_focused_control.onTertiaryMouseDown();
		}
	}

	void onTertiaryMouseUp() {
		if (_focused_control !is null) {
			_focused_control.onTertiaryMouseUp();
		}
	}

	void onMouseWheelY(uint amount) {
		if (_focused_control !is null) {
			_focused_control.onMouseWheelY(amount);
		}
	}

	void onMouseWheelX(uint amount) {
		if (_focused_control !is null) {
			_focused_control.onMouseWheelX(amount);
		}
	}

	void onMouseMove() {
		if (_focused_control !is null) {
			_focused_control.onMouseMove();
		}
	}

	uint width() {
		return Console.width();
	}

	uint height() {
		return Console.height();
	}

	// Methods

	override void push(Dispatcher dsp) {
		if (cast(TuiWidget)dsp !is null) {
			// do not add a control that is already part of another window
			TuiWidget control = cast(TuiWidget)dsp;

			if (control._nextControl !is null) { return; }

			// add to the control linked list
			if (_firstControl is null && _lastControl is null)
			{
				// first control

				_firstControl = control;
				_lastControl = control;

				control._nextControl = control;
				control._prevControl = control;
			}
			else
			{
				// next control

				control._nextControl = _firstControl;
				control._prevControl = _lastControl;

				_firstControl._prevControl = control;
				_lastControl._nextControl = control;

				_firstControl = control;
			}

			// increase the number of controls
			_numControls++;

			super.push(control);
		}
		else {
			super.push(dsp);
		}
	}

	bgColor backcolor() {
		return _bgClr;
	}

	void tabForward() {
		// activate the next control
		TuiWidget curFocus = _focused_control;

		_focused_control.onLostFocus();

		do {
			_focused_control = _focused_control._prevControl;
			if (_focused_control.isTabStop()) {
				_focused_control.onGotFocus();
				break;
			}
		} while (_focused_control !is curFocus);
	}

	void tabBackward() {
		// activate the previous control
		TuiWidget curFocus = _focused_control;

		_focused_control.onLostFocus();

		do {
			_focused_control = _focused_control._nextControl;
			if (_focused_control.isTabStop()) {
				_focused_control.onGotFocus();
				break;
			}
		} while (_focused_control !is curFocus);
	}

	TuiApplication application() {
		return cast(TuiApplication)this.responder;
	}

	bool isActive() {
		return (application() !is null && application.window is this);
	}

	Mouse mouseProps;

private:

	bgColor _bgClr = bgColor.Black;

	// head and tail of the control linked list
	TuiWidget _firstControl;	//head
	TuiWidget _lastControl;	//tail

	int _numControls = 0;

	TuiWidget _captured_control;
	TuiWidget _last_control;
	TuiWidget _focused_control;
}
