module console.window;

import platform.imports;
mixin(PlatformGenericImport!("console"));

import core.string;
import core.main;
import core.definitions;

import core.literals;

import console.main;
import console.control;

// Section: Console

// Description: This class abstacts the console window and allows for high level console operations which are abstracted away as controls.  It is the Window class for the console world.
class ConsoleWindow
{


	// Constructor

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

		if (Djehuty._curConsoleWindow is this)
		{
			control.OnInit();
		}
	}

	bgColor GetBackgroundColor()
	{
		return _bgClr;
	}

	void TabForward()
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

	void TabBackward()
	{
		// activate the previous control
		_focused_control = ControlGetNext(_focused_control);
		_focused_control.OnGotFocus();
	}


	Mouse mouseProps;

protected:
	bgColor _bgClr;

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

	Console.setColor(cwindow.GetBackgroundColor());
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

		if (Djehuty._curConsoleWindow._focused_control !is null)
		{
			Djehuty._curConsoleWindow._focused_control.` ~ eventName ~ `();
		}
		Djehuty._curConsoleWindow.` ~ eventName ~ `();

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

	if (Djehuty._curConsoleWindow._focused_control !is null)
	{
		Djehuty._curConsoleWindow._focused_control.OnKeyDown(keyCode);
	}
	Djehuty._curConsoleWindow.OnKeyDown(keyCode);

}

void ConsoleWindowOnKeyUp(uint keyCode)
{

	if (Djehuty._curConsoleWindow._focused_control !is null)
	{
		Djehuty._curConsoleWindow._focused_control.OnKeyUp(keyCode);
	}
	Djehuty._curConsoleWindow.OnKeyUp(keyCode);

}

void ConsoleWindowOnKeyChar(dchar keyChar)
{

	if (Djehuty._curConsoleWindow._focused_control !is null)
	{
		Djehuty._curConsoleWindow._focused_control.OnKeyChar(keyChar);
	}
	Djehuty._curConsoleWindow.OnKeyChar(keyChar);

}

void ConsoleWindowOnMouseWheelY(uint amount)
{

	if (Djehuty._curConsoleWindow._focused_control !is null)
	{
		Djehuty._curConsoleWindow._focused_control.OnMouseWheelY(amount);
	}
	Djehuty._curConsoleWindow.OnMouseWheelY(amount);

}

void ConsoleWindowOnMouseWheelX(uint amount)
{

	if (Djehuty._curConsoleWindow._focused_control !is null)
	{
		Djehuty._curConsoleWindow._focused_control.OnMouseWheelX(amount);
	}
	Djehuty._curConsoleWindow.OnMouseWheelX(amount);

}


//DJEHUTYDOC

//CONSOLE:ConsoleWindow
//EXTENDS:Object
//DESC:This class abstracts the console's screen.  The window will clear the screen and draw many console controls.  Any input is passed to the controls in a way similar to normal applications.

//EVENTS

//NAME:OnKeyDown(uint keyCode)
//DESC:This event is called when a key is pressed over the window, when focused.  LATER I WILL NOTE THE KEYS
//PARAM:keyCode
//DESC:the key identifier

//NAME:OnKeyUp(uint keyCode)
//DESC:This event is called when a key is released over the window, when focused.  LATER I WILL NOTE THE KEYS
//PARAM:keyCode
//DESC:the key identifier

//NAME:OnKeyChar(dchar keyChar)
//DESC:This event is called when a character is processed by keyboard input over the focused window.
//PARAM:keyChar
//DESC:the character in UTF-32 format.



//NAME:OnPrimaryMouseDown()
//DESC:called when the primary mouse button (often times the left button) is pressed down over the window

//NAME:OnPrimaryMouseUp()
//DESC:called when the primary mouse button (often times the left button) is released over the window

//NAME:OnSecondaryMouseDown()
//DESC:called when the secondary mouse button (often times the right button) is pressed down over the window

//NAME:OnSecondaryMouseUp()
//DESC:called when the secondary mouse button (often times the right button) is released over the window

//NAME:OnTertiaryMouseDown()
//DESC:called when the tertiary mouse button (usually the middle button) is pressed down over the window

//NAME:OnTertiaryMouseUp()
//DESC:called when the tertiary mouse button (usually the middle button) is released over the window

//NAME:OnMouseWheelY(uint amount)
//DESC:called when the mouse wheel is scrolled vertically (the common scroll method)
//PARAM:amount
//DESC:the number of standard 'ticks' that the scroll wheel makes

//NAME:OnMouseWheelX(uint amount)
//DESC:called when the mouse wheel is scrolled horizontally (a less common scroll method)
//PARAM:amount
//DESC:the number of standard 'ticks' that the scroll wheel makes


//METHODS

//NAME:addControl(ConsoleControl control)
//DESC:This method will add the control passed to it to the window if the control has not been added previously.
//PARAM:control
//DESC:The control to add.

//ENDDJEHUTYDOC
