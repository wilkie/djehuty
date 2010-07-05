/*
 * window.d
 *
 * This module implements a GUI Window class. Widgets can be pushed to this window.
 *
 * Author: Dave Wilkinson
 * Originated: June 24th, 2009
 *
 */

module gui.window;

import djehuty;

class Window : Responder {
private:
	bool _visible;

	Color _bg;

	Rect _bounds;

	Window _focusedWindow;
	Window _dragWindow;

public:
	Window parent() {
		return cast(Window)this.responder();
	}

	Color backcolor() {
		return _bg;
	}

	void backcolor(Color value) {
		_bg = value;
	}

	bool visible() {
		return _visible;
	}

	void visible(bool value) {
		_visible = value;
	}

	bool focused() {
		return false;
	}

	void focused(bool value) {
	}

	double left() {
		return _bounds.left;
	}

	double top() {
		return _bounds.top;
	}

	double width() {
		return _bounds.right - _bounds.left;
	}

	void width(double value) {
		reposition(this.left(), this.top(), value, this.height());
	}

	double height() {
		return _bounds.bottom - _bounds.top;
	}

	void height(double value) {
		reposition(this.left(), this.top(), this.width(), value);
	}

	double clientWidth() {
		return width();
	}

	void clientWidth(double value) {
		width(value);
	}

	double clientHeight() {
		return height();
	}

	void clientHeight(double value) {
		height(value);
	}

	// Description: This function returns the currently
	//  focused window.
	Window active() {
		return _focusedWindow;
	}

	// Description: This function returns the next sibling window.
	Window next() {
		return null;
	}

	// Description: This function returns the previous sibling window.
	Window previous() {
		return null;
	}

	void reorder(WindowOrder order) {
	}

	void reposition(double left, double top, double width = float.nan, double height = float.nan) {
		double w, h;
		double oldW, oldH;
		oldW = this.width();
		oldH = this.height();

		if (width !<>= width) {
			w = oldW;
		}
		else {
			w = width;
		}

		if (height !<>= height) {
			h = oldH;
		}
		else {
			h = height;
		}

		if (w < 0) {
			w = 0;
		}
		if (h < 0) {
			h = 0;
		}

		_bounds.left = left;
		_bounds.top = top;
		_bounds.right = left + w;
		_bounds.bottom = top + h;

		if (oldW != w || oldH != h) {
			onResize();
		}
		parent.redraw();
	}

	void redraw() {
		if (!this.visible) {
			return;
		}
	}

	// Events

	void onResize() {
	}

	void onKeyDown(Key key) {
		// Pass this down to the focused window
		if (_focusedWindow !is null) {
			_focusedWindow.onKeyDown(key);
		}
	}

	void onKeyChar(dchar keyChar) {
		// Pass this down to the focused window
		if (_focusedWindow !is null) {
			_focusedWindow.onKeyChar(keyChar);
		}
	}

	void onPrimaryDown(ref Mouse mouse) {
		// Look at passing this message down
		foreach(window; this) {
			if (window.left <= mouse.x
					&& (window.left + window.width) > mouse.x
					&& window.top <= mouse.y
					&& (window.top + window.height) > mouse.y) {

				double xdiff = window.left;
				double ydiff = window.top;
				mouse.x -= xdiff;
				mouse.y -= ydiff;

				_dragWindow = window;

				if (_focusedWindow !is window) {
					_focusedWindow = window;
				}

				window.onPrimaryDown(mouse);

				mouse.x += xdiff;
				mouse.y += ydiff;
				break;
			}
		}
	}

	void onPrimaryUp(ref Mouse mouse) {
		// Look at passing this message down
		if (_dragWindow !is null) {

			double xdiff = _dragWindow.left;
			double ydiff = _dragWindow.top;
			mouse.x -= xdiff;
			mouse.y -= ydiff;

			_dragWindow.onPrimaryUp(mouse);

			mouse.x += xdiff;
			mouse.y += ydiff;

			_dragWindow = null;
			return;
		}

		foreach(window; this) {
			if (window.left <= mouse.x
					&& (window.left + window.width) > mouse.x
					&& window.top <= mouse.y
					&& (window.top + window.height) > mouse.y) {

				double xdiff = window.left;
				double ydiff = window.top;
				mouse.x -= xdiff;
				mouse.y -= ydiff;

				window.onPrimaryUp(mouse);

				mouse.x += xdiff;
				mouse.y += ydiff;
				break;
			}
		}
	}

	void onDrag(ref Mouse mouse) {
		// Look at passing this message down
		if (_dragWindow !is null) {
			double xdiff = _dragWindow.left;
			double ydiff = _dragWindow.top;

			mouse.x -= xdiff;
			mouse.y -= ydiff;

			_dragWindow.onDrag(mouse);

			mouse.x += xdiff;
			mouse.y += ydiff;
		}
	}

	void onHover(ref Mouse mouse) {
		// Look at passing this message down
		foreach(window; this) {
			if (window.left <= mouse.x
					&& (window.left + window.width) > mouse.x
					&& window.top <= mouse.y
					&& (window.top + window.height) > mouse.y) {

				double xdiff = window.left;
				double ydiff = window.top;
				mouse.x -= xdiff;
				mouse.y -= ydiff;

				window.onHover(mouse);

				mouse.x += xdiff;
				mouse.y += ydiff;
				break;
			}
		}
	}

	int opApply(int delegate(ref Window window) loopBody) {
		return 0;
	}

	void onDrawChildren() {
	}

	void onDraw() {
	}

	// Signal Handler
	override void push(Dispatcher dsp, SignalHandler handler = null) {
		super.push(dsp, handler);

		auto window = cast(Window)dsp;
		if (window !is null) {
			// Focus on this window (if it is visible)
			if (window.visible) {
				_focusedWindow = window;
			}

			redraw();
		}
	}
}

class WindowView {
}
