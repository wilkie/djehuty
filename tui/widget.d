module tui.widget;

import tui.window;
import tui.application;

import core.event;
import core.main;

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

	package TuiWidget _nextControl;
	package TuiWidget _prevControl;

	TuiWindow _window;

	uint _x = 0;
	uint _y = 0;

	uint _width = 0;
	uint _height = 0;
}
