module tui.window;

import tui.application;
import tui.widget;

import core.event;
import core.definitions;

import console.main;

// Description: This class abstacts the console window and allows for high level console operations which are abstracted away as controls.  It is the Window class for the console world.
class TuiWindow : Responder
{
	// Constructor

	this() {
	}

	this(bgColor bgClr)
	{
		_bgClr = bgClr;
	}

	// Events

	void onInitialize()
	{
		// go through control list, init

		_width = Console.getWidth();
		_height = Console.getHeight();

		Console.setColor(getBackgroundColor());
		Console.clear();

		TuiWidget c = _firstControl;

		if (c !is null)
		{
			do
			{
				c =	c._prevControl;

				c.onInit();
			} while (c !is _firstControl)

			_focused_control = c;

			do
			{
				_focused_control = _focused_control._prevControl;
				if (_focused_control.isTabStop())
				{
					_focused_control.onGotFocus();
					break;
				}
			} while (_focused_control !is c);
		}
	}

	void onUninitialize()
	{
	}

	void onResize()
	{
		_width = Console.getWidth();
		_height = Console.getHeight();
	}

	void onKeyDown(uint keyCode)
	{
		if (_focused_control !is null)
		{
			_focused_control.onKeyDown(keyCode);
		}
	}

	void onKeyChar(dchar keyChar)
	{
		if (_focused_control !is null)
		{
			_focused_control.onKeyChar(keyChar);
		}
	}

	void onKeyUp(uint keyCode)
	{
		if (_focused_control !is null)
		{
			_focused_control.onKeyUp(keyCode);
		}
	}

	void onPrimaryMouseDown()
	{
		if (_focused_control !is null)
		{
			_focused_control.onPrimaryMouseDown();
		}
	}

	void onPrimaryMouseUp()
	{
		if (_focused_control !is null)
		{
			_focused_control.onPrimaryMouseUp();
		}
	}

	void onSecondaryMouseDown()
	{
		if (_focused_control !is null)
		{
			_focused_control.onSecondaryMouseDown();
		}
	}

	void onSecondaryMouseUp()
	{
		if (_focused_control !is null)
		{
			_focused_control.onSecondaryMouseUp();
		}
	}

	void onTertiaryMouseDown()
	{
		if (_focused_control !is null)
		{
			_focused_control.onTertiaryMouseDown();
		}
	}

	void onTertiaryMouseUp()
	{
		if (_focused_control !is null)
		{
			_focused_control.onTertiaryMouseUp();
		}
	}

	void onMouseWheelY(uint amount)
	{
		if (_focused_control !is null)
		{
			_focused_control.onMouseWheelY(amount);
		}
	}

	void onMouseWheelX(uint amount)
	{
		if (_focused_control !is null)
		{
			_focused_control.onMouseWheelX(amount);
		}
	}

	void onMouseMove()
	{
		if (_focused_control !is null)
		{
			_focused_control.onMouseMove();
		}
	}

	uint getWidth()
	{
		return _width;
	}

	uint getHeight()
	{
		return _height;
	}

	// Description: This event will be called by any Control tied to this window that raises an event.
	// source: The Control that raised the event.
	// event: The event that was issued.
	bool onEvent(TuiWidget source, uint event)
	{
		return false;
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

	bgColor getBackgroundColor()
	{
		return _bgClr;
	}

	void tabForward()
	{
		// activate the next control
		TuiWidget curFocus = _focused_control;

		_focused_control.onLostFocus();

		do
		{
			_focused_control = _focused_control._prevControl;
			if (_focused_control.isTabStop())
			{
				_focused_control.onGotFocus();
				break;
			}
		} while (_focused_control !is curFocus);
	}

	void tabBackward()
	{
		// activate the previous control
		TuiWidget curFocus = _focused_control;

		_focused_control.onLostFocus();

		do
		{
			_focused_control = _focused_control._nextControl;
			if (_focused_control.isTabStop())
			{
				_focused_control.onGotFocus();
				break;
			}
		} while (_focused_control !is curFocus);
	}
	
	TuiApplication application() {
		return cast(TuiApplication)responder;
	}

	bool isActive() {
		return (application() !is null && application.window is this);
	}

	Mouse mouseProps;

protected:
	bgColor _bgClr = bgColor.Black;

	// head and tail of the control linked list
	TuiWidget _firstControl;	//head
	TuiWidget _lastControl;	//tail

	int _numControls = 0;

	TuiWidget _captured_control;
	TuiWidget _last_control;
	TuiWidget _focused_control;

	uint _width;
	uint _height;
}