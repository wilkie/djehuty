module console.window;

import platform.imports;
mixin(PlatformGenericImport!("console"));

import core.string;
import core.main;
import core.definitions;

import core.literals;

import console.main;
import console.control;
import console.application;

// Section: Console

// Description: This class abstacts the console window and allows for high level console operations which are abstracted away as controls.  It is the Window class for the console world.
class ConsoleWindow
{

	// Constructor

	this() {
	}

	this(bgColor bgClr)
	{
		_bgClr = bgClr;
	}




	// Events

	void OnResize()
	{
	}

	void OnKeyDown(uint keyCode)
	{
	}

	void OnKeyChar(dchar keyChar)
	{
	}

	void OnKeyUp(uint keyCode)
	{
	}

	void OnPrimaryMouseDown()
	{
	}

	void OnPrimaryMouseUp()
	{
	}

	void OnSecondaryMouseDown()
	{
	}

	void OnSecondaryMouseUp()
	{
	}

	void OnTertiaryMouseDown()
	{
	}

	void OnTertiaryMouseUp()
	{
	}

	void OnMouseWheelY(uint amount)
	{
	}

	void OnMouseWheelX(uint amount)
	{
	}

	void OnMouseMove()
	{
	}



	// Methods

	void addControl( ConsoleControl control )
	{
		// do not add a control that is already part of another window
		if (ControlGetNext(control) !is null) { return; }

		// add to the control linked list
		if (_firstControl is null && _lastControl is null)
		{
			// first control

			_firstControl = control;
			_lastControl = control;

			ControlUpdateList(control, control, control);
		}
		else
		{
			// next control

			ControlUpdateList(control, _firstControl, _lastControl);

			ControlSetPrevious(_firstControl, control);
			ControlSetNext(_lastControl, control);

			_firstControl = control;
		}

		//ControlPrintList(_firstControl);

		// increase the number of controls
		_numControls++;

		ControlAdd(control, this);

		control.OnAdd();

		if ((cast(ConsoleApplication)Djehuty.app).getConsoleWindow() is this)
		{
			control.OnInit();
		}
	}

	bgColor getBackgroundColor()
	{
		return _bgClr;
	}

	void tabForward()
	{
		// activate the next control
		ConsoleControl _curFocus = _focused_control;

		_focused_control.OnLostFocus();

		do
		{
			_focused_control = ControlGetPrevious(_focused_control);
			if (ControlIsTabStop(_focused_control))
			{
				_focused_control.OnGotFocus();
				break;
			}
		} while (_focused_control !is _curFocus);
	}

	void tabBackward()
	{
		// activate the previous control
		_focused_control = ControlGetNext(_focused_control);
		_focused_control.OnGotFocus();
	}


	Mouse mouseProps;

protected:
	bgColor _bgClr = bgColor.Black;

	// head and tail of the control linked list
	ConsoleControl _firstControl = null;	//head
	ConsoleControl _lastControl = null;	//tail
	int _numControls = 0;

	ConsoleControl _captured_control = null;
	ConsoleControl _last_control = null;
	ConsoleControl _focused_control = null;
}

void ConsoleWindowOnSet(ref ConsoleWindow cwindow)
{
	// go through control list, init

	Console.setColor(cwindow.getBackgroundColor());
	Console.clear();

	ConsoleControl c = cwindow._firstControl;

	if (c !is null)
	{
		do
		{
			c =	ControlGetPrevious(c);

			c.OnInit();
		} while (c !is cwindow._firstControl)

		cwindow._focused_control = c;

		do
		{
			cwindow._focused_control = ControlGetPrevious(cwindow._focused_control);
			if (ControlIsTabStop(cwindow._focused_control))
			{
				cwindow._focused_control.OnGotFocus();
				break;
			}
		} while (cwindow._focused_control !is c);
	}
}

template ConsoleWindowGenericNoParam(StringLiteral8 eventName)
{
	const char[] ConsoleWindowGenericNoParam = `

	void ConsoleWindow` ~ eventName ~ `()
	{

		if ((cast(ConsoleApplication)Djehuty.app).getConsoleWindow._focused_control !is null)
		{
			(cast(ConsoleApplication)Djehuty.app).getConsoleWindow._focused_control.` ~ eventName ~ `();
		}
		(cast(ConsoleApplication)Djehuty.app).getConsoleWindow.` ~ eventName ~ `();

	}

	`;
}

mixin(ConsoleWindowGenericNoParam!("OnPrimaryMouseUp"));
mixin(ConsoleWindowGenericNoParam!("OnPrimaryMouseDown"));
mixin(ConsoleWindowGenericNoParam!("OnSecondaryMouseUp"));
mixin(ConsoleWindowGenericNoParam!("OnSecondaryMouseDown"));
mixin(ConsoleWindowGenericNoParam!("OnTertiaryMouseUp"));
mixin(ConsoleWindowGenericNoParam!("OnTertiaryMouseDown"));
mixin(ConsoleWindowGenericNoParam!("OnMouseMove"));

void ConsoleWindowOnKeyDown(uint keyCode)
{

	if ((cast(ConsoleApplication)Djehuty.app).getConsoleWindow._focused_control !is null)
	{
		(cast(ConsoleApplication)Djehuty.app).getConsoleWindow._focused_control.OnKeyDown(keyCode);
	}
	(cast(ConsoleApplication)Djehuty.app).getConsoleWindow.OnKeyDown(keyCode);

}

void ConsoleWindowOnKeyUp(uint keyCode)
{

	if ((cast(ConsoleApplication)Djehuty.app).getConsoleWindow._focused_control !is null)
	{
		(cast(ConsoleApplication)Djehuty.app).getConsoleWindow._focused_control.OnKeyUp(keyCode);
	}
	(cast(ConsoleApplication)Djehuty.app).getConsoleWindow.OnKeyUp(keyCode);

}

void ConsoleWindowOnKeyChar(dchar keyChar)
{

	if ((cast(ConsoleApplication)Djehuty.app).getConsoleWindow._focused_control !is null)
	{
		(cast(ConsoleApplication)Djehuty.app).getConsoleWindow._focused_control.OnKeyChar(keyChar);
	}
	(cast(ConsoleApplication)Djehuty.app).getConsoleWindow.OnKeyChar(keyChar);

}

void ConsoleWindowOnMouseWheelY(uint amount)
{

	if ((cast(ConsoleApplication)Djehuty.app).getConsoleWindow._focused_control !is null)
	{
		(cast(ConsoleApplication)Djehuty.app).getConsoleWindow._focused_control.OnMouseWheelY(amount);
	}
	(cast(ConsoleApplication)Djehuty.app).getConsoleWindow.OnMouseWheelY(amount);

}

void ConsoleWindowOnMouseWheelX(uint amount)
{

	if ((cast(ConsoleApplication)Djehuty.app).getConsoleWindow._focused_control !is null)
	{
		(cast(ConsoleApplication)Djehuty.app).getConsoleWindow._focused_control.OnMouseWheelX(amount);
	}
	(cast(ConsoleApplication)Djehuty.app).getConsoleWindow.OnMouseWheelX(amount);

}