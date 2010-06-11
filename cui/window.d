module cui.window;

import cui.application;
import cui.canvas;

import djehuty;

import resource.menu;

import data.list;

import io.console;

import synch.semaphore;

class CuiWindow : Responder {
private:
	bool _visible; // whether this window is drawn and can be interacted with
	bool _focused; // whether this window is the foreground window

	CuiWindow _focusedWindow;
	CuiWindow _dragWindow;

	Rect _bounds;
	Color _bg;

	Semaphore _lock;

	// Window list
	CuiWindow _head;		// The head of the list
	CuiWindow _topMostEnd;	// The subsection where the top most end
	CuiWindow _bottomMostStart;	// The subsection where the bottom most start

	// Sibling list
	CuiWindow _next;
	CuiWindow _prev;

	bool _isTopMost;
	bool _isBottomMost;

public:
	this(int x, int y, int width, int height, Color bg = Color.Black) {
		_lock = new Semaphore(1);
		_bounds.left = x;
		_bounds.top = y;
		_bounds.right = x + width;
		_bounds.bottom = y + height;
		_bg = bg;
	}

	this(WindowPosition pos, int width, int height, Color bg = Color.Black) {
		int x, y;
		if (pos == WindowPosition.Center) {
			x = (Console.width - width) / 2;
			y = (Console.height - height) / 2;
		}

		this(x, y, width, height, bg);
	}

	CuiWindow parent() {
		return cast(CuiWindow)responder;
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
		return _focused;
	}

	void focused(bool value) {
		_focused = value;
	}

	int left() {
		return cast(int)_bounds.left;
	}

	int top() {
		return cast(int)_bounds.top;
	}

	int width() {
		return cast(int)(_bounds.right - _bounds.left);
	}

	void width(int value) {
	}

	int height() {
		return cast(int)(_bounds.bottom - _bounds.top);
	}

	void height(int value) {
	}

	// TODO: Fix bugs with bottommost and topmost
	void reorder(WindowOrder order) {
		// put on top
		CuiWindow parent = this.parent();
		if (order == WindowOrder.Top && !_isTopMost) {
			// Move this window to _topMostEnd
			if (parent !is null && parent._topMostEnd !is this && parent._topMostEnd._prev !is this) {
				this._prev._next = this._next;
				this._next._prev = this._prev;

				this._next = parent._topMostEnd;
				this._prev = parent._topMostEnd._prev;
				parent._topMostEnd._prev._next = this;
				parent._topMostEnd._prev = this;
			}

			if (parent._head is parent._topMostEnd) {
				parent._head = this;
			}
			parent._topMostEnd = this;
		}
		else if (order == WindowOrder.BottomMost) {
			// Move this window just before _head
			_isBottomMost = true;

			if (parent !is null && parent._head !is this && parent._head._prev !is this) {
				// re-add this window to the head of the list
				this._prev._next = this._next;
				this._next._prev = this._prev;

				this._next = parent._head;
				this._prev = parent._head._prev;
				parent._head._prev._next = this;
				parent._head._prev = this;
			}

			if (parent._bottomMostStart is parent._head) {
				parent._bottomMostStart = this;
			}

			if (parent._head is this) {
				parent._head = this._next;
			}

			if (parent._topMostEnd is this) {
				parent._topMostEnd = this._next;
			}
		}
		else if (order == WindowOrder.Bottom && !_isBottomMost) {
			// Move this window just before _bottomMostStart

			if (parent._head is this) {
				parent._head = this._next;
			}

			if (parent._topMostEnd is this) {
				parent._topMostEnd = this._next;
			}

			if (parent !is null && parent._bottomMostStart._prev !is this && parent._bottomMostStart !is this) {
				this._prev._next = this._next;
				this._next._prev = this._prev;

				this._next = parent._bottomMostStart;
				this._prev = parent._bottomMostStart._prev;
				parent._bottomMostStart._prev._next = this;
				parent._bottomMostStart._prev = this;
			}

			if (parent._bottomMostStart is this) {
				parent._bottomMostStart = this._next;
			}
		}
		else if (order == WindowOrder.TopMost) {
			// Move this window to _head
			_isTopMost = true;
			if (parent._topMostEnd is this) {
				parent._topMostEnd = parent._topMostEnd._next;
			}

			if (parent !is null && parent._head !is this && parent._head._prev !is this) {
				// re-add this window to the head of the list
				this._prev._next = this._next;
				this._next._prev = this._prev;

				this._next = parent._head;
				this._prev = parent._head._prev;
				parent._head._prev._next = this;
				parent._head._prev = this;
			}

			if (parent._head is parent._topMostEnd) {
				parent._topMostEnd = parent._topMostEnd._next;
			}

			parent._head = this;
		}

		redraw();
	}

	void reposition(int left, int top, int width = -1, int height = -1) {
		int w, h;
		int oldW, oldH;
		oldW = this.width();
		oldH = this.height();

		if (width == -1) {
			w = oldW;
		}
		else {
			w = width;
		}

		if (height == -1) {
			h = oldH;
		}
		else {
			h = height;
		}

		_bounds.left = left;
		_bounds.top = top;
		_bounds.right = left + w;
		_bounds.bottom = top + h;

		if (oldW != w || oldH != h) {
			onResize();
		}
		redraw();
	}

	void redraw() {
		if (this.parent !is null) {
			this.parent.redraw();
		}
		else {
			static int i = 0;
			_lock.down();
			auto canvas = new CuiCanvas();
			if (i == 1) {
				for(;;) { canvas.position(0,0); canvas.write("a");}
			}
			i++;
			canvas.position(0,0);
			onDraw(canvas);
			i--;
			_lock.up();
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
		CuiWindow current = _head;

		if (current is null) {
			return;
		}

		do {
			if (current.left <= mouse.x
			  && (current.left + current.width) > mouse.x
			  && current.top <= mouse.y
			  && (current.top + current.height) > mouse.y) {

				int xdiff = current.left;
				int ydiff = current.top;
				mouse.x -= xdiff;
				mouse.y -= ydiff;

				_dragWindow = current;

				if (_focusedWindow !is current) {
					_focusedWindow = current;
				}

				current.onPrimaryDown(mouse);

				mouse.x += xdiff;
				mouse.y += ydiff;
				break;
			}
			current = current._next;
		} while(current !is _head);
	}

	void onPrimaryUp(ref Mouse mouse) {
		// Look at passing this message down
		if (_dragWindow !is null) {

			int xdiff = _dragWindow.left;
			int ydiff = _dragWindow.top;
			mouse.x -= xdiff;
			mouse.y -= ydiff;

			_dragWindow.onPrimaryUp(mouse);

			mouse.x += xdiff;
			mouse.y += ydiff;

			_dragWindow = null;
			return;
		}

		CuiWindow current = _head;

		if (current is null) {
			return;
		}

		do {
			if (current.left <= mouse.x
			  && (current.left + current.width) > mouse.x
			  && current.top <= mouse.y
			  && (current.top + current.height) > mouse.y) {

				int xdiff = current.left;
				int ydiff = current.top;
				mouse.x -= xdiff;
				mouse.y -= ydiff;

				current.onPrimaryUp(mouse);

				mouse.x += xdiff;
				mouse.y += ydiff;
				break;
			}
			current = current._next;
		} while(current !is _head);
	}

	void onDrag(ref Mouse mouse) {
		// Look at passing this message down
		if (_dragWindow !is null) { 
			int xdiff = _dragWindow.left;
			int ydiff = _dragWindow.top;

			mouse.x -= xdiff;
			mouse.y -= ydiff;

			_dragWindow.onDrag(mouse);

			mouse.x += xdiff;
			mouse.y += ydiff;
		}
	}

	void onHover(ref Mouse mouse) {
		// Look at passing this message down
		CuiWindow current = _head;

		if (current is null) {
			return;
		}

		do {
			if (current.left <= mouse.x
			  && (current.left + current.width) > mouse.x
			  && current.top <= mouse.y
			  && (current.top + current.height) > mouse.y) {

				int xdiff = current.left;
				int ydiff = current.top;
				mouse.x -= xdiff;
				mouse.y -= ydiff;

				current.onHover(mouse);

				mouse.x += xdiff;
				mouse.y += ydiff;
				break;
			}
			current = current._next;
		} while(current !is _head);
	}

	void onDrawChildren(CuiCanvas canvas) {
		// Subwindows
		CuiWindow current = _head;

		if (current is null) {
			return;
		}

		do {
			if (!(current.visible)) {
				continue;
			}

			Rect rt;

			// Draw
			canvas.clipSave();

			// Clip the regions around the subcurrent temporarily
			rt.left = 0;
			rt.top = 0;
			rt.right = current.left;
			rt.bottom = this.height;
			canvas.clipRect(rt);

			rt.left = current.left;
			rt.top = 0;
			rt.right = current.left + current.width;
			rt.bottom = current.top;
			canvas.clipRect(rt);

			rt.left = current.left;
			rt.top = current.top + current.height;
			rt.right = current.left + current.width;
			rt.bottom = this.height;
			canvas.clipRect(rt);

			rt.left = current.left + current.width;
			rt.top = 0;
			rt.right = this.width;
			rt.bottom = this.height;
			canvas.clipRect(rt);

			// Tell the canvas where the top-left corner is
			canvas.contextPush(current.left, current.top);

			canvas.position(0,0);
			current.onDraw(canvas);
			canvas.clipRestore();

			// Reset context
			canvas.contextPop();

			// Clip this current
			rt.left = current.left;
			rt.top = current.top;
			rt.right = current.width + current.left;
			rt.bottom = current.height + current.top;
			canvas.clipRect(rt);

			current = current._next;
		} while(current !is _head);
	}

	void onDraw(CuiCanvas canvas) {
		// Draw subwindows
		onDrawChildren(canvas);

		// Paint the background of the window
		canvas.backcolor = _bg;
		int amt = this.width;
		if (amt > Console.width) {
			amt = Console.width;
		}
		if (amt < 0) {
			return;
		}
		string line = times(" ", amt);
		for(uint i = 0; i < this.height; i++) {
			canvas.position(0,i);
			canvas.write(line);
		}
	}

	// Signal Handler
	override void push(Dispatcher dsp) {
		super.push(dsp);

		auto window = cast(CuiWindow)dsp;
		if (window !is null) {
			if (_head is null) {
				_topMostEnd = window;
				_bottomMostStart = window;
				_head = window;

				window._next = window;
				window._prev = window;
			}
			else {
				_topMostEnd._prev._next = window;
				window._prev = _head._prev;
				_topMostEnd._prev = window;
				window._next = _head;
				if (_bottomMostStart is _head) {
					_bottomMostStart = window;
				}
				if (_topMostEnd is _head) {
					_head = window;
				}
				_topMostEnd = window;
			}

			// Focus on this window (if it is visible)
			if (window.visible) {
				_focusedWindow = window;
			}

			redraw();
		}
	}
}
