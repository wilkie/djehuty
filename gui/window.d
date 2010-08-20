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

import scaffold.gui;
import scaffold.canvas;

import platform.vars.gui;
import platform.vars.window;
import platform.vars.canvas;

import synch.semaphore;
import synch.thread;

import system.keyboard;

import binding.c;

class Window : Responder {
private:

	// Mouse and Keyboard event management
	Mouse _mouse;
	Key _key;

	// repeated clicking counter
	Time _lastTime;
	uint _lastButton = uint.max;
	uint _lastCount;
	double _lastX;
	double _lastY;

	// Properties
	Rect _bounds;
	Color _bg;
	bool _visible;

	Semaphore _lock;

	// Window management
	Window _focusedWindow;
	Window _dragWindow;
	Window _hoverWindow;

	// Sibling list
	Window _next;
	Window _prev;

	int _numVisible;

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
	bool _allowRedraw;

	WindowPlatformVars _pfvars;

	void _update(Canvas canvas) {
		GuiUpdateWindow(this, &_pfvars, canvas.platformVariables);
	}

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

	void eventLoop(bool ps) {
		Event evt;

		GuiCreateWindow(this, &_pfvars);

		_lock.up();

		auto canvas = new Canvas(cast(int)this.width, cast(int)this.height);

		_allowRedraw = true;
		this.redraw();

		while(true) {
			GuiNextEvent(this, &_pfvars, &evt);

			this.onEvent(evt);

			if (evt.type == Event.Close) {
				break;
			}
		}

		GuiDestroyWindow(this, &_pfvars);
	}

	final void _dispatchMouseDown(uint button, ref Mouse mouse) {
		// Look at passing this message down
		foreach(window; this) {
			double xdiff = window.left;
			double ydiff = window.top;

			mouse.x -= xdiff;
			mouse.y -= ydiff;

			if (window.visible && window.containsPoint(mouse.x, mouse.y)) {
				_dragWindow = window;
				_hoverWindow = null;

				if (_focusedWindow !is window) {
					if (_focusedWindow !is null) {
						_focusedWindow.onLostFocus();
					}
					_focusedWindow = window;
					_focusedWindow.onGotFocus();
				}

				window._dispatchMouseDown(button, mouse);

				mouse.x += xdiff;
				mouse.y += ydiff;
				return;
			}

			mouse.x += xdiff;
			mouse.y += ydiff;
		}

		// End up handling it in the main window
		onMouseDown(mouse, button);
	}

	final void _dispatchMouseUp(uint button, ref Mouse mouse) {
		// Look at passing this message down
		if (_dragWindow !is null) {

			double xdiff = _dragWindow.left;
			double ydiff = _dragWindow.top;
			mouse.x -= xdiff;
			mouse.y -= ydiff;

			_dragWindow._dispatchMouseUp(button, mouse);

			mouse.x += xdiff;
			mouse.y += ydiff;

			_dragWindow = null;
			return;
		}

		foreach(window; this) {
			double xdiff = window.left;
			double ydiff = window.top;

			mouse.x -= xdiff;
			mouse.y -= ydiff;

			if (window.visible && window.containsPoint(mouse.x, mouse.y)) {
				window._dispatchMouseUp(button, mouse);

				mouse.x += xdiff;
				mouse.y += ydiff;
				return;
			}
			mouse.x += xdiff;
			mouse.y += ydiff;
		}

		onMouseUp(mouse, button);
	}


	final void _dispatchMouseDrag(ref Mouse mouse) {
		// Look at passing this message down
		if (_dragWindow !is null) {
			double xdiff = _dragWindow.left;
			double ydiff = _dragWindow.top;

			mouse.x -= xdiff;
			mouse.y -= ydiff;

			_dragWindow._dispatchMouseDrag(mouse);

			mouse.x += xdiff;
			mouse.y += ydiff;
			return;
		}

		// End up handling it in the main window
		onMouseDrag(mouse);
	}

	final void _dispatchMouseLeave() {
		if (_hoverWindow !is null) {
			_hoverWindow._dispatchMouseLeave();
		}

		_hoverWindow = null;

		this.onMouseLeave();
	}

	final void _dispatchMouseHover(ref Mouse mouse) {
		// Look at passing this message down
		foreach(window; this) {
			double xdiff = window.left;
			double ydiff = window.top;

			mouse.x -= xdiff;
			mouse.y -= ydiff;

			if (window.visible && window.containsPoint(mouse.x, mouse.y)) {
				if (_hoverWindow !is window && _hoverWindow !is null) {
					_hoverWindow._dispatchMouseLeave();
				}
				_hoverWindow = window;
				window._dispatchMouseHover(mouse);

				mouse.x += xdiff;
				mouse.y += ydiff;
				return;
			}
			mouse.x += xdiff;
			mouse.y += ydiff;
		}

		// End up handling it in the main window
		if (_hoverWindow !is null) {
			// This window receives a mouse leave message
			_hoverWindow._dispatchMouseLeave();
			_hoverWindow = null;
		}

		// This window handles the hover
		onMouseHover(mouse);
	}

	final void _dispatchKeyDown(ref Key key) {
		onKeyDown(key);
		// Pass this down to the focused window
		if (_focusedWindow !is null) {
			_focusedWindow._dispatchKeyDown(key);
		}
	}

	final void _dispatchKeyChar(dchar chr) {
		onKeyChar(chr);
		// Pass this down to the focused window
		if (_focusedWindow !is null) {
			_focusedWindow._dispatchKeyChar(chr);
		}
	}

	final void _dispatchKeyUp(ref Key key) {
		onKeyUp(key);
		// Pass this down to the focused window
		if (_focusedWindow !is null) {
			_focusedWindow._dispatchKeyUp(key);
		}
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
		if (_visible != value) {
			if (value == true) {
				if (this.parent !is null) {
					this.parent._numVisible++;
				}
			}
			else {
				if (this.parent !is null) {
					this.parent._numVisible--;
				}
			}
		}
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

	int visibleCount() {
		return _numVisible;
	}

	int count() {
		return _count;
	}

	// Methods

	// Description: This method will return true when the given point is within
	//  the active region of the Window.
	// x: The x coordinate relative to the client area of the Window.
	// y: The y coordinate relative to the client area of the Window.
	// Returns: true when the point is within the active region and false
	//  otherwise.
	bool containsPoint(double x, double y) {
		if (x >= 0.0 && x < this.width && y >= 0.0 && y < this.height) {
			return true;
		}
		return false;
	}

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

			if (window.visible) {
				_numVisible++;
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
			if (window.visible) {
				_numVisible--;
			}

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
		if (!_allowRedraw) {
			_needsRedraw = true;
			return;
		}

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
			// Need to update with a new canvas.
			Canvas canvas = new Canvas(cast(int)this.width, cast(int)this.height);

			onDraw(canvas);
			onDrawChildren(canvas);

			_update(canvas);
		}
	}

	void reposition(double left, double top, double width, double height) {
	}

	// Events

	override void onAttach(Responder rsp) {
		bool isTopLevel = false;
		if (this.parent !is null && this.parent.parent is null) {
			// Ok, the grandparent is not a Window class. It there
			// is a grandparent (and not null as a responder) then
			// we can assume it is the Application class.
			if (this.parent.responder !is null) {
				isTopLevel = true;
			}
		}

		if (isTopLevel) {
			// Top level window
			_lock = new Semaphore(0);
			Thread thread = new Thread(&eventLoop);
			thread.start();
			_lock.down();
		}
	}

	void onEvent(Event event) {
		_allowRedraw = false;
		switch(event.type) {
			case Event.Close:
				this.parent.detach(this);
				break;

			case Event.MouseDown:
				_mouse.x = event.info.mouse.x;
				_mouse.y = event.info.mouse.y;

				// Double+ click check
				Time curTime = Time.now();
				if (_lastButton != event.aux) {
					// Different button
					_lastCount = 1;
				}
				else {
					// Same button as last time,
					// first, check to see if the mouse has not moved
					// significantly.
					if (_mouse.x > _lastX-1 && _mouse.x < _lastX+1
					 && _mouse.y > _lastY-1 && _mouse.y < _lastY+1) {
						// The mouse has not moved

						// then, check how much time has elapsed
						Time check = new Time(300000);
						Time elapsed = curTime - _lastTime;
						if (elapsed < check) {
							_lastCount++;
						}
						else {
							_lastCount = 1;
						}
					}
					else {
						_lastCount = 1;
					}
				}

				_lastTime = curTime;
				_lastX = _mouse.x;
				_lastY = _mouse.y;
				_lastButton = event.aux;

				_mouse.clicks[event.aux] = _lastCount;

				this._dispatchMouseDown(event.aux, _mouse);
				break;

			case Event.MouseUp:
				_mouse.x = event.info.mouse.x;
				_mouse.y = event.info.mouse.y;
				this._dispatchMouseUp(event.aux, _mouse);
				_mouse.clicks[event.aux] = 0;
				break;

			case Event.MouseMove:
				_mouse.x = event.info.mouse.x;
				_mouse.y = event.info.mouse.y;
				if (_mouse.clicks[0] > 0 || _mouse.clicks[1] > 0 || _mouse.clicks[2] > 0) {
					_dispatchMouseDrag(_mouse);
				}
				else {
					_dispatchMouseHover(_mouse);
				}
				break;

			case Event.MouseLeave:
				_dispatchMouseLeave();
				break;

			case Event.KeyDown:
				event.info.key.deadChar = _key.deadChar;
				_key = Keyboard.translate(event.info.key);
				this._dispatchKeyDown(_key);

				if (_key.printable != '\0') {
					this._dispatchKeyChar(_key.printable);
				}
				break;

			case Event.KeyUp:
				this._dispatchKeyUp(event.info.key);
				break;

			default:
				break;
		}
		_allowRedraw = true;
		if (_needsRedraw) {
			redraw();
		}
	}

	void onGotFocus() {
	}

	void onLostFocus() {
	}

	void onMouseDown(Mouse mouse, uint button) {
	}

	void onMouseUp(Mouse mouse, uint button) {
	}

	void onMouseLeave() {
	}

	void onMouseDrag(Mouse mouse) {
	}

	void onMouseHover(Mouse mouse) {
	}

	void onKeyDown(Key key) {
	}

	void onKeyChar(dchar chr) {
	}

	void onKeyUp(Key key) {
	}

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
