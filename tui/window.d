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

	void OnInitialize()
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

				c.OnInit();
			} while (c !is _firstControl)

			_focused_control = c;

			do
			{
				_focused_control = _focused_control._prevControl;
				if (_focused_control.isTabStop())
				{
					_focused_control.OnGotFocus();
					break;
				}
			} while (_focused_control !is c);
		}
	}

	void OnUninitialize()
	{
	}

	void OnResize()
	{
		_width = Console.getWidth();
		_height = Console.getHeight();
	}

	void OnKeyDown(uint keyCode)
	{
		if (_focused_control !is null)
		{
			_focused_control.OnKeyDown(keyCode);
		}
	}

	void OnKeyChar(dchar keyChar)
	{
		if (_focused_control !is null)
		{
			_focused_control.OnKeyChar(keyChar);
		}
	}

	void OnKeyUp(uint keyCode)
	{
		if (_focused_control !is null)
		{
			_focused_control.OnKeyUp(keyCode);
		}
	}

	void OnPrimaryMouseDown()
	{
		if (_focused_control !is null)
		{
			_focused_control.OnPrimaryMouseDown();
		}
	}

	void OnPrimaryMouseUp()
	{
		if (_focused_control !is null)
		{
			_focused_control.OnPrimaryMouseUp();
		}
	}

	void OnSecondaryMouseDown()
	{
		if (_focused_control !is null)
		{
			_focused_control.OnSecondaryMouseDown();
		}
	}

	void OnSecondaryMouseUp()
	{
		if (_focused_control !is null)
		{
			_focused_control.OnSecondaryMouseUp();
		}
	}

	void OnTertiaryMouseDown()
	{
		if (_focused_control !is null)
		{
			_focused_control.OnTertiaryMouseDown();
		}
	}

	void OnTertiaryMouseUp()
	{
		if (_focused_control !is null)
		{
			_focused_control.OnTertiaryMouseUp();
		}
	}

	void OnMouseWheelY(uint amount)
	{
		if (_focused_control !is null)
		{
			_focused_control.OnMouseWheelY(amount);
		}
	}

	void OnMouseWheelX(uint amount)
	{
		if (_focused_control !is null)
		{
			_focused_control.OnMouseWheelX(amount);
		}
	}

	void OnMouseMove()
	{
		if (_focused_control !is null)
		{
			_focused_control.OnMouseMove();
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
	bool OnEvent(TuiWidget source, uint event)
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

		_focused_control.OnLostFocus();

		do
		{
			_focused_control = _focused_control._prevControl;
			if (_focused_control.isTabStop())
			{
				_focused_control.OnGotFocus();
				break;
			}
		} while (_focused_control !is curFocus);
	}

	void tabBackward()
	{
		// activate the previous control
		TuiWidget curFocus = _focused_control;

		_focused_control.OnLostFocus();

		do
		{
			_focused_control = _focused_control._nextControl;
			if (_focused_control.isTabStop())
			{
				_focused_control.OnGotFocus();
				break;
			}
		} while (_focused_control !is curFocus);
	}
	
	TuiApplication getApplication() {
		return cast(TuiApplication)responder;
	}
	
	bool isActive() {
		return (getApplication() !is null && getApplication.getWindow() is this);
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