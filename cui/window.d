module cui.window;

import cui.application;
import cui.widget;
import cui.canvas;

import djehuty;

import resource.menu;

import io.console;

import data.list;

class CuiWindow : Responder {
private:
	bool _visible; // whether this window is drawn and can be interacted with
	bool _focused; // whether this window is the foreground window

	List!(CuiWindow) _window_list;

	string _title;

	Rect _bounds;

public:
	this() {
		this(null, WindowStyle.Fixed, Color.Black, WindowPosition.Center, Console.width, Console.height);
	}

	this(string windowTitle, WindowStyle windowStyle, Color color, WindowPosition pos, int width, int height) {
		if (windowTitle !is null) {
			_title = windowTitle.dup;
		}
		_window_list = new List!(CuiWindow);
		_bounds.right = width;
		_bounds.bottom = height;
	}

	bool visible() {
		return _visible;
	}

	void visible(bool value) {
		_visible = value;
	}

	bool focused() {
		return _focused;
	}

	void focused(bool value) {
		_focused = value;
	}

	long left() {
		return _bounds.left;
	}

	long top() {
		return _bounds.top;
	}

	long width() {
		return _bounds.right - _bounds.left;
	}

	long height() {
		return _bounds.bottom - _bounds.top;
	}

	// Events
	void onKeyDown(Key key) {
	}

	void onKeyChar(dchar keyChar) {
	}

	void onDraw(CuiCanvas canvas) {
		if (_title !is null) {
			// Draw some title bar
		}

		// Menu bar

		// Subwindows
		foreach(window; _window_list) {
			// Tell the canvas where the top-left corner is
			canvas.contextPush(window.left, window.top);

			// Draw
			window.onDraw(canvas);

			// Clip this window and reset the context
			canvas.clipRect(window.left, window.top, window.left + window.width, window.top + window.height);
			canvas.contextPop();
		}
	}
}
