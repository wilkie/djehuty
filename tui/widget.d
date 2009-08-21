module tui.widget;

import tui.window;
import tui.application;
import tui.container;

import core.event;
import core.main;
import core.definitions;
import core.format;
import core.string;
import core.unicode;

import io.console;

// Description: This class abstracts part of the console's screen.  When attached to a window, this class will receive input through the events.  Keyboard events will be passed only when the control is activated.  A control can decide not to be activatable by setting it's _isTabStop to false.
class TuiWidget : Responder {

	this() {
	}

	this(int x, int y, int width, int height) {
		_x = x;
		_y = y;
		_base_x = x;
		_base_y = y;
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

	override void push(Dispatcher dsp) {
		if (cast(TuiWidget)dsp) {
			// Adding a child widget to this widget
			//_owner.push(dsp);
		}
		else {
			super.push(dsp);
		}
	}

	void resize(uint width, uint height) {
		_width = width;
		_height = height;
		onDraw();
	}

	void move(uint left, uint top) {
		_x = left;
		_y = top;
		onDraw();
	}

	bool isTabStop() {
		return false;
	}
	
	bool isTabUseful() {
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

	// Description: This will move the terminal caret to the relative position indicated by the parameters.
	// x: The x position within the widget bounds to move the caret.
	// y: The y position within the widget bounds to move the caret.
	final void moveCaret(uint x, uint y) {
		if (x >= _width) {
			x = _width - 1;
		}

		if (y >= _height) {
			y = _height - 1;
		}

		Console.position = [_base_x + _x + x, _base_y + _y + y];
	}

	// Description: This function will hide the caret.
	final void hideCaret() {
		Console.hideCaret();
	}

	// Description: This function will show the caret.
	final void showCaret() {
		Console.showCaret();
	}

	final void changeColor(fgColor forecolor) {
		Console.setColor(forecolor);
	}

	final void changeColor(bgColor backcolor) {
		Console.setColor(backcolor);
	}

	final void changeColor(fgColor forecolor, bgColor backcolor) {
		Console.setColor(forecolor, backcolor);
	}

	// Description: This function will print to the widget.
	final void put(...) {
		mixin(formatToString!());

		putString(toParse);
	}

	// Description: This function will print to the widget and then go to the next line.
	final void putln(...) {
		mixin(formatToString!());

		putString(toParse);

		Console.putChar('\n');
	}

	// Description: This function is for printing strings within widget bounds.
	// str: The String to print.string idget bounds
	final void putString(String str) {
		// Clip to the bounds of the control and the owner container
		Coord pos = Console.position;

		int x;
		int y;
		int r;
		int b;

		uint leftPos = 0;
		uint rightPos = 0;

		x = pos.x;
		y = pos.y;
		r = pos.x + str.length;
		b = pos.y + 1;
		
		uint _r = _x + _width;
		uint _b = _y + _height;
		
		if (_r > _base_x + _owner.width) {
			_r = _base_x + _owner.width;
		}
		
		if (_b > _base_y + _owner.height) {
			_b = _base_y + _owner.height;
		}

		if ((r < _x) || (b < _y) || (x > _r) || (y > _b)) {
			// Outside bounds of widget completely
			return;
		}

		// Clip string (left edge)
		if (x < _x) {
			leftPos = _x - x;
			pos.x = 0;
			Console.position = pos;
		}

		// Clip string (right edge)
		if (r > _r) {
			rightPos = r - _r;
		}

		str = str.subString(leftPos, str.length - rightPos - leftPos);

		Console.putString(str);
	}

	// Description: This function is for printing strings within widget bounds.
	// str: The String to print.
	final void putString(string str) {
		putString(new String(str));
	}

	final void tabForward() {
		_owner._tabForward();
	}

	final void tabBackward() {
		_owner._tabBackward();
	}

private:

	// For internal linked list of parent container
	package TuiWidget _nextControl;
	package TuiWidget _prevControl;

	// Widget ultimate parent
	package TuiWindow _window;
	package TuiContainer _owner;

	// Widget relative coordinates
	uint _x = 0;
	uint _y = 0;

	 // Coordinates of global left-top
	package uint _base_x = 0;
	package uint _base_y = 0;

	// Widget size
	uint _width = 0;
	uint _height = 0;
}
