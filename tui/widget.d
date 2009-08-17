module tui.widget;

import tui.window;
import tui.application;

import core.event;
import core.main;
import core.definitions;

// Description: This class abstracts part of the console's screen.  When attached to a window, this class will receive input through the events.  Keyboard events will be passed only when the control is activated.  A control can decide not to be activatable by setting it's _isTabStop to false.
class TuiWidget : Responder {

	this() {
	}

	this(int x, int y, int width, int height) {
		_x = x;
		_y = y;
		_width = width;
		_height = height;
	}

	// Events

	void onInit() {
	}

	void onAdd() {
	}

	void onRemove() {
	}

	void onGotFocus() {
	}

	void onDraw() {
	}

	void onLostFocus() {
	}

	void onResize() {
	}

	void onKeyDown(Key key) {
	}

	void onKeyChar(dchar keyChar) {
	}

	void onKeyUp(Key key) {
	}

	void onPrimaryMouseDown() {
	}

	void onPrimaryMouseUp() {
	}

	void onSecondaryMouseDown() {
	}

	void onSecondaryMouseUp() {
	}

	void onTertiaryMouseDown() {
	}

	void onTertiaryMouseUp() {
	}

	void onMouseWheelY(int amount) {
	}

	void onMouseWheelX(int amount) {
	}

	void onMouseMove() {
	}

	override void onPush(Responder rsp) {
		// Did we get pushed to a TuiWindow?
		if (cast(TuiWindow)rsp !is null) {
			// Set the window we are attached
			_window = cast(TuiWindow)rsp;

			// Call event
			onAdd();

			// If we are pushed to the current window, also call init event
			if (_window.isActive())
			{
				onInit();
			}
		}
	}

	void resize(uint width, uint height) {
		_width = width;
		_height = height;
		onDraw();
	}

	bool isTabStop() {
		return false;
	}

	uint left() {
		return _x;
	}

	uint top() {
		return _y;
	}

	uint right() {
		return _x + _width;
	}

	uint bottom() {
		return _y + _height;
	}

	uint width() {
		return _width;
	}

	uint height() {
		return _height;
	}

	TuiWindow window() {
		return _window;
	}

protected:

	bool canDraw() {
		return _window !is null && _window.isActive;
	}

private:

	package TuiWidget _nextControl;
	package TuiWidget _prevControl;

	TuiWindow _window;

	uint _x = 0;
	uint _y = 0;

	uint _width = 0;
	uint _height = 0;
}
