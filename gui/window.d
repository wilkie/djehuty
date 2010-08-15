/*
 * window.d
 *
 * This module implements a Gui window class.
 *
 */

module gui.window;

import djehuty;

import graphics.canvas;
import graphics.brush;
import graphics.pen;

import scaffold.window;

class Window : Responder {
private:

	// Properties
	Rect _bounds;
	Color _bg;
	bool _visible;

	// Window management
	Window _focusedWindow;
	Window _dragWindow;

	// Sibling list
	Window _next;
	Window _prev;

	// Order management
	bool _isTopMost;
	bool _isBottomMost;

	int _count;

	// Window list
	Window _head;			// The head of the list
	Window _topMostHead;	// The subsection where the top most end
	Window _bottomMostHead;	// The subsection where the bottom most start

	// Drawing optimization management
	bool _needsRedraw;
	bool _dirty;

	void _remove() {
		if (this._prev is this) {
			if (this is parent._topMostHead) {
				parent._topMostHead = null;
			}
			else if (this is parent._bottomMostHead) {
				parent._bottomMostHead = null;
			}
			else {
				parent._head = null;
			}
		}
		else {
			if (this is parent._topMostHead) {
				parent._topMostHead = parent._topMostHead._next;
			}
			else if (this is parent._bottomMostHead) {
				parent._bottomMostHead = parent._bottomMostHead._next;
			}
			else if (this is parent._head) {
				parent._head = parent._head._next;
			}

			this._prev._next = this._next;
			this._next._prev = this._prev;
		}

		this._prev = null;
		this._next = null;
	}

public:

	enum Signal {
		NeedRedraw
	}

	this(double x, double y, double width, double height, Color bg = Color.Black) {
		_bounds.left = x;
		_bounds.top = y;
		_bounds.right = width + x;
		_bounds.bottom = height + y;
		_bg = bg;
		_visible = true;
	}

	this(WindowPosition pos, double width, double height, Color bg = Color.Black) {
		double x = 0.0;
		double y = 0.0;

		if (pos == WindowPosition.Center) {
			x = (cast(double)System.Display.width - width) / 2.0;
			y = (cast(double)System.Display.height - height) / 2.0;
		}

		_bounds.left = x;
		_bounds.top = y;
		_bounds.right = width + x;
		_bounds.bottom = height + y;
		_bg = bg;
		_visible = true;
	}

	// Properties

	Window parent() {
		return cast(Window)responder;
	}

	Color backcolor() {
		return _bg;
	}

	void backcolor(Color value) {
		_bg = value;
		redraw();
	}

	bool visible() {
		return _visible;
	}

	void visible(bool value) {
		_visible = value;
		if (parent !is null) {
			parent.redraw();
		}
	}

	bool focused() {
		if (parent is null) {
			return false;
		}

		return parent._focusedWindow is this;
	}

	void focused(bool value) {
		if (parent is null) {
			return;
		}

		if (value == true) {
			parent._focusedWindow = this;
		}
		// TODO: value = false?
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
		reposition(this.left, this.top, value, this.height);
	}

	double height() {
		return _bounds.bottom - _bounds.top;
	}

	void height(double value) {
		reposition(this.left, this.top, this.width, value);
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

	// Methods

	int opApply(int delegate(ref Window window) loopBody) {
		int ret;

		Window current;
		Window end;

		for (int i = 0; i < 3; i++) {
			if (i == 0) {
				current = _topMostHead;
			}
			else if (i == 1) {
				current = _head;
			}
			else {
				current = _bottomMostHead;
			}

			end = current;

			if (current is null) {
				continue;
			}

			do {
				ret = loopBody(current);
				if (ret != 0) {
					return ret;
				}
				current = current._next;
			} while(current !is end);
		}
		return ret;
	}

	override void attach(Dispatcher dsp, SignalHandler handler = null) {
		super.attach(dsp, handler);

		auto window = cast(Window)dsp;
		if (window !is null && window.parent is this && window._next is null) {
			if (_head is null) {
				window._next = window;
				window._prev = window;
			}
			else {
				window._prev = _head._prev;
				window._next = _head;

				_head._prev._next = window;
				_head._prev = window;
			}

			// Set as new head
			_head = window;

			// Focus on this window (if it is visible)
			if (window.visible) {
				_focusedWindow = window;
			}

			_count++;

			redraw();
		}
	}

	override void detach(Dispatcher dsp) {
		auto window = cast(Window)dsp;

		if (window !is null && window.parent is this) {
			// remove this window from the list
			_count--;

			// Focus on this window (if it is visible)
			if (_focusedWindow is window) {
				_focusedWindow = _focusedWindow._next;
			}

			window._remove();

			redraw();
		}

		// perform default behavior
		super.detach(dsp);
	}

	void redraw() {
		if (!this.visible) {
			return;
		}
		if (this.parent is null) {
			return;
		}

		if (this.parent.parent !is null) {
			this.parent.redraw();
		}
		else {
			raiseSignal(Signal.NeedRedraw);
		}
	}

	void reposition(double left, double top, double width, double height) {
	}

	// Events

	void onDraw(Canvas canvas) {
		Color clr = Color.White;
		clr.alpha = 0.8;
		Brush brush = new Brush(clr);
		canvas.brush = brush;

		clr = Color.Black;
		clr.alpha = 0.8;
		Pen pen = new Pen(clr);
		canvas.pen = pen;

		canvas.drawRectangle(0,0,this.width,this.height);
	}

	void onDrawChildren(Canvas canvas) {
		foreach(Window window; this) {
			// Clip to the window
			canvas.clipSave();
			canvas.clipRectangle(window.left, window.top, window.width, window.height);

			// Set origin to be window's top-left coordinate
			canvas.transformSave();
			canvas.transformTranslate(window.left, window.top);

			// Draw the area owned by the window
			window.onDraw(canvas);

			// Draw this window's children
			window.onDrawChildren(canvas);

			// Restore the transform matrix
			canvas.transformRestore();

			// Restore the clipping
			canvas.clipRestore();
		}
	}
}
