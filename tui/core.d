/*
 * core.d
 *
 * This module implements a console application class.
 *
 * Author: Dave Wilkinson
 * Originated: June 9th 2009
 *
 */

module tui.core;

import platform.imports;
mixin(PlatformGenericImport!("console"));

import core.application;
import core.string;
import core.main;
import core.definitions;
import core.event;
import core.literals;

import console.main;

import interfaces.list;

// Section: Console

// Description: This class represents a Text User Interface application (TUI).
class TuiApplication : Application {
public:

	this() {
		super();
	}

	this(String appName) {
		super(appName);
	}

	this(StringLiteral appName) {
		super(appName);
	}

	override void push(Dispatcher dsp) {
		if (cast(TuiWindow)dsp !is null) {
			setWindow(cast(TuiWindow)dsp);
		}

		super.push(dsp);
	}

	TuiWindow getWindow() {
		return _curConsoleWindow;
	}

protected:

	TuiWindow _curConsoleWindow;

private:

	void setWindow(TuiWindow window) {
		if (!Djehuty._console_inited) {
			//ConsoleInit();

			Djehuty._console_inited = true;
		}

		_curConsoleWindow = window;

		// Draw Window
		window.OnInitialize();
	}
}

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
}

// Description: This class abstracts part of the console's screen.  When attached to a window, this class will receive input through the events.  Keyboard events will be passed only when the control is activated.  A control can decide not to be activatable by setting it's _isTabStop to false.
class TuiWidget : Responder
{
	this() {
	}

	this(int x, int y, int width, int height) {
		_x = x;
		_y = y;
		_width = width;
		_height = height;
	}

	// Events


	void OnInit()
	{
	}

	void OnAdd()
	{
	}

	void OnRemove()
	{
	}

	void OnGotFocus()
	{
	}

	void OnLostFocus()
	{
	}

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

	void OnMouseWheelY(int amount)
	{
	}

	void OnMouseWheelX(int amount)
	{
	}

	void OnMouseMove()
	{
	}

	override void OnPush(Responder rsp) {
		// Did we get pushed to a TuiWindow?
		if (cast(TuiWindow)rsp !is null) {
			// Set the window we are attached
			_window = cast(TuiWindow)rsp;

			// Call event
			OnAdd();

			// If we are pushed to the current window, also call init event
			if ((cast(TuiApplication)Djehuty.app).getWindow() is _window)
			{
				OnInit();
			}
		}
	}

	bool isTabStop() {
		return false;
	}

protected:

	TuiWidget _nextControl;
	TuiWidget _prevControl;

	TuiWindow _window;

	uint _x = 0;
	uint _y = 0;

	uint _width = 0;
	uint _height = 0;
}
