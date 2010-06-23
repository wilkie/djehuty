module cui.window;

import cui.application;
import cui.canvas;

import djehuty;

import resource.menu;

import data.list;

import io.console;

import synch.semaphore;

import binding.c;

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
	CuiWindow _head;			// The head of the list
	CuiWindow _topMostHead;		// The subsection where the top most end
	CuiWindow _bottomMostHead;	// The subsection where the bottom most start

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
		reposition(this.left(), this.top(), value, this.height());
	}

	int height() {
		return cast(int)(_bounds.bottom - _bounds.top);
	}

	void height(int value) {
		reposition(this.left(), this.top(), this.width(), value);
	}

	int clientWidth() {
		return width();
	}

	void clientWidth(int value) {
		width(value);
	}

	int clientHeight() {
		return height();
	}

	void clientHeight(int value) {
		height(value);
	}

	// Description: This function returns the currently
	//  focused window.
	CuiWindow active() {
		return _focusedWindow;
	}

	// Description: This function returns the next sibling window.
	CuiWindow next() {
		CuiWindow ret = _next;

		if (_isTopMost) {
			if (ret is parent._topMostHead) {
				ret = parent._head;
			}
		}
		else if (_isBottomMost) {
			if (ret is parent._bottomMostHead) {
				ret = parent._topMostHead;
			}
		}
		else {
			if (ret is parent._head) {
				ret = parent._bottomMostHead;
			}
		}

		return ret;
	}

	// Description: This function returns the previous sibling window.
	CuiWindow previous() {
		CuiWindow ret = _prev;

		if (_isTopMost) {
			if (this is parent._topMostHead) {
				ret = parent._bottomMostHead;
			}
		}
		else if (_isBottomMost) {
			if (this is parent._bottomMostHead) {
				ret = parent._head;
			}
		}
		else {
			if (this is parent._head) {
				ret = parent._topMostHead;
			}
		}

		return ret;
	}

	private void _remove() {
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
	}

	void reorder(WindowOrder order) {
		// put on top
		CuiWindow parent = this.parent();
		if (parent is null) {
			return;
		}

		// Function to remove from list
		if (order == WindowOrder.Top) {
			if (_isTopMost) {
				return;
			}

			if (_isBottomMost) {
				return;
			}

			if (parent._head is this) {
				return;
			}

			// Remove from the list it is already in
			_remove();

			if (parent._head is null) {
				this._next = this;
				this._prev = this;
			}
			else {
				this._next = parent._head;
				this._prev = parent._head._prev;

				parent._head._prev._next = this;
				parent._head._prev = this;
			}

			parent._head = this;
		}
		else if (order == WindowOrder.BottomMost) {
			if (_isBottomMost) {
				return;
			}

			_isBottomMost = true;

			if (parent._bottomMostHead is this) {
				return;
			}

			// Remove from the list it is already in
			_remove();

			if (parent._bottomMostHead is null) {
				this._next = this;
				this._prev = this;
			}
			else {
				this._prev = parent._bottomMostHead._prev;
				this._next = parent._bottomMostHead;

				parent._bottomMostHead._prev._next = this;
				parent._bottomMostHead._prev = this;
			}

			parent._bottomMostHead = this;
		}
		else if (order == WindowOrder.TopMost) {
			if (_isTopMost) {
				return;
			}

			_isTopMost = true;

			if (parent._topMostHead is this) {
				return;
			}

			// Remove from the list it is already in
			_remove();

			if (parent._topMostHead is null) {
				this._next = this;
				this._prev = this;
			}
			else {
				this._prev = parent._topMostHead._prev;
				this._next = parent._topMostHead;

				parent._topMostHead._prev._next = this;
				parent._topMostHead._prev = this;
			}

			parent._topMostHead = this;
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
			_lock.down();
			auto canvas = new CuiCanvas();
			canvas.position(0,0);
			onDraw(canvas);
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
		foreach(window; this) {
			if (window.left <= mouse.x
					&& (window.left + window.width) > mouse.x
					&& window.top <= mouse.y
					&& (window.top + window.height) > mouse.y) {

				int xdiff = window.left;
				int ydiff = window.top;
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

		foreach(window; this) {
			if (window.left <= mouse.x
					&& (window.left + window.width) > mouse.x
					&& window.top <= mouse.y
					&& (window.top + window.height) > mouse.y) {

				int xdiff = window.left;
				int ydiff = window.top;
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
		foreach(window; this) {
			if (window.left <= mouse.x
					&& (window.left + window.width) > mouse.x
					&& window.top <= mouse.y
					&& (window.top + window.height) > mouse.y) {

				int xdiff = window.left;
				int ydiff = window.top;
				mouse.x -= xdiff;
				mouse.y -= ydiff;

				window.onHover(mouse);

				mouse.x += xdiff;
				mouse.y += ydiff;
				break;
			}
		}
	}

	int opApply(int delegate(ref CuiWindow window) loopBody) {
		int ret;

		CuiWindow current;
		CuiWindow end;

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

	void onDrawChildren(CuiCanvas canvas) {
		// Subwindows
		foreach(window; this) {
			if (!(window.visible)) {
				continue;
			}

			Rect rt;

			// Draw
			canvas.clipSave();

			// Clip the regions around the subwindow temporarily
			rt.left = 0;
			rt.top = 0;
			rt.right = window.left;
			rt.bottom = this.height;
			canvas.clipRect(rt);

			rt.left = window.left;
			rt.top = 0;
			rt.right = window.left + window.width;
			rt.bottom = window.top;
			canvas.clipRect(rt);

			rt.left = window.left;
			rt.top = window.top + window.height;
			rt.right = window.left + window.width;
			rt.bottom = this.height;
			canvas.clipRect(rt);

			rt.left = window.left + window.width;
			rt.top = 0;
			rt.right = this.width;
			rt.bottom = this.height;
			canvas.clipRect(rt);

			// Tell the canvas where the top-left corner is
			canvas.contextPush(window.left, window.top);

			canvas.position(0,0);
			window.onDraw(canvas);
			canvas.clipRestore();

			// Reset context
			canvas.contextPop();

			// Clip this window
			rt.left = window.left;
			rt.top = window.top;
			rt.right = window.width + window.left;
			rt.bottom = window.height + window.top;
			canvas.clipRect(rt);
		}
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

			redraw();
		}
	}
}
