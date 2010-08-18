module cui.window;

import cui.application;
import cui.canvas;

import djehuty;

import resource.menu;

import data.list;

import io.console;

import synch.semaphore;

import binding.c;

import system.keyboard;

class CuiWindow : Responder {
private:
	Mouse _mouse;

	bool _visible = true; // whether this window is drawn and can be interacted with
	bool _focused; // whether this window is the foreground window

	CuiWindow _focusedWindow;
	CuiWindow _dragWindow;

	Rect _bounds;
	Color _bg;

	// Window list
	CuiWindow _head;			// The head of the list
	CuiWindow _topMostHead;		// The subsection where the top most end
	CuiWindow _bottomMostHead;	// The subsection where the bottom most start

	// Sibling list
	CuiWindow _next;
	CuiWindow _prev;

	bool _isTopMost;
	bool _isBottomMost;

	bool _needsRedraw;
	bool _dirty;
	
	int _count;

	// Event dispatchers

	final void _dispatchKeyDown(Key key) {
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

	final void _dispatchPrimaryDown(ref Mouse mouse) {
		// Look at passing this message down
		foreach(window; this) {
			if (window.left <= mouse.x
					&& (window.left + window.width) > mouse.x
					&& window.top <= mouse.y
					&& (window.top + window.height) > mouse.y
					&& (window.visible)) {

				int xdiff = window.left;
				int ydiff = window.top;
				mouse.x -= xdiff;
				mouse.y -= ydiff;

				_dragWindow = window;

				if (_focusedWindow !is window) {
					if (_focusedWindow !is null) {
						_focusedWindow.onLostFocus();
					}
					_focusedWindow = window;
					_focusedWindow.onGotFocus();
				}

				window._dispatchPrimaryDown(mouse);

				mouse.x += xdiff;
				mouse.y += ydiff;
				return;
			}
		}

		// End up handling it in the main window
		onPrimaryDown(mouse);
	}

	final void _dispatchPrimaryUp(ref Mouse mouse) {
		// Look at passing this message down
		if (_dragWindow !is null) {

			int xdiff = _dragWindow.left;
			int ydiff = _dragWindow.top;
			mouse.x -= xdiff;
			mouse.y -= ydiff;

			_dragWindow._dispatchPrimaryUp(mouse);

			mouse.x += xdiff;
			mouse.y += ydiff;

			_dragWindow = null;
			return;
		}

		foreach(window; this) {
			if (window.left <= mouse.x
					&& (window.left + window.width) > mouse.x
					&& window.top <= mouse.y
					&& (window.top + window.height) > mouse.y
					&& (window.visible)) {

				int xdiff = window.left;
				int ydiff = window.top;
				mouse.x -= xdiff;
				mouse.y -= ydiff;

				window._dispatchPrimaryUp(mouse);

				mouse.x += xdiff;
				mouse.y += ydiff;
				return;
			}
		}

		// End up handling it in the main window
		onPrimaryUp(mouse);
	}

	final void _dispatchScrollX(ref Mouse mouse, int delta) {
		// Look at passing this message down
		foreach(window; this) {
			if (window.left <= mouse.x
					&& (window.left + window.width) > mouse.x
					&& window.top <= mouse.y
					&& (window.top + window.height) > mouse.y
					&& (window.visible)) {

				int xdiff = window.left;
				int ydiff = window.top;
				mouse.x -= xdiff;
				mouse.y -= ydiff;

				window._dispatchScrollX(mouse, delta);

				mouse.x += xdiff;
				mouse.y += ydiff;
				return;
			}
		}

		// End up handling it in the main window
		onScrollX(mouse, delta);
	}

	final void _dispatchScrollY(ref Mouse mouse, int delta) {
		// Look at passing this message down
		foreach(window; this) {
			if (window.left <= mouse.x
					&& (window.left + window.width) > mouse.x
					&& window.top <= mouse.y
					&& (window.top + window.height) > mouse.y
					&& (window.visible)) {

				int xdiff = window.left;
				int ydiff = window.top;
				mouse.x -= xdiff;
				mouse.y -= ydiff;

				window._dispatchScrollY(mouse, delta);

				mouse.x += xdiff;
				mouse.y += ydiff;
				return;
			}
		}

		// End up handling it in the main window
		onScrollY(mouse, delta);
	}

	final void _dispatchDrag(ref Mouse mouse) {
		// Look at passing this message down
		if (_dragWindow !is null) {
			int xdiff = _dragWindow.left;
			int ydiff = _dragWindow.top;

			mouse.x -= xdiff;
			mouse.y -= ydiff;

			_dragWindow._dispatchDrag(mouse);

			mouse.x += xdiff;
			mouse.y += ydiff;
			return;
		}

		// End up handling it in the main window
		onDrag(mouse);
	}

	final void _dispatchHover(ref Mouse mouse) {
		// Look at passing this message down
		foreach(window; this) {
			if (window.left <= mouse.x
					&& (window.left + window.width) > mouse.x
					&& window.top <= mouse.y
					&& (window.top + window.height) > mouse.y
					&& (window.visible)) {

				int xdiff = window.left;
				int ydiff = window.top;
				mouse.x -= xdiff;
				mouse.y -= ydiff;

				window._dispatchHover(mouse);

				mouse.x += xdiff;
				mouse.y += ydiff;
				return;
			}
		}

		// End up handling it in the main window
		onHover(mouse);
	}

	// master redraw function

	void _redraw() {
		if (!this.visible) {
			return;
		}
		_needsRedraw = true;

		if (this.parent !is null) {
			this.parent._redraw();
		}
		else {
			raiseSignal(Signal.NeedRedraw);
		}
	}

	bool isPrintable(Key key, out dchar chr) {
		if (key.control || key.alt) {
			return false;
		}

		if (key.code >= Key.A && key.code <= Key.Z) {
			if (key.shift) {
				chr = (key.code - Key.A) + 'A';
			}
			else {
				chr = (key.code - Key.A) + 'a';
			}
		}
		else if (key.code >= Key.Zero && key.code <= Key.Nine) {
			if (key.shift) {
				switch (key.code) {
					case Key.Zero:
						chr = ')';
						break;
					case Key.One:
						chr = '!';
						break;
					case Key.Two:
						chr = '@';
						break;
					case Key.Three:
						chr = '#';
						break;
					case Key.Four:
						chr = '$';
						break;
					case Key.Five:
						chr = '%';
						break;
					case Key.Six:
						chr = '^';
						break;
					case Key.Seven:
						chr = '&';
						break;
					case Key.Eight:
						chr = '*';
						break;
					case Key.Nine:
						chr = '(';
						break;
					default:
						return false;
				}
			}
			else {
				chr = (key.code - Key.Zero) + '0';
			}
		}
		else if (key.code == Key.SingleQuote) {
			if (key.shift) {
				chr = '~';
			}
			else {
				chr = '`';
			}
		}
		else if (key.code == Key.Minus) {
			if (key.shift) {
				chr = '_';
			}
			else {
				chr = '-';
			}
		}
		else if (key.code == Key.Equals) {
			if (key.shift) {
				chr = '+';
			}
			else {
				chr = '=';
			}
		}
		else if (key.code == Key.LeftBracket) {
			if (key.shift) {
				chr = '{';
			}
			else {
				chr = '[';
			}
		}
		else if (key.code == Key.RightBracket) {
			if (key.shift) {
				chr = '}';
			}
			else {
				chr = ']';
			}
		}
		else if (key.code == Key.Semicolon) {
			if (key.shift) {
				chr = ':';
			}
			else {
				chr = ';';
			}
		}
		else if (key.code == Key.Comma) {
			if (key.shift) {
				chr = '<';
			}
			else {
				chr = ',';
			}
		}
		else if (key.code == Key.Period) {
			if (key.shift) {
				chr = '>';
			}
			else {
				chr = '.';
			}
		}
		else if (key.code == Key.Foreslash) {
			if (key.shift) {
				chr = '?';
			}
			else {
				chr = '/';
			}
		}
		else if (key.code == Key.Backslash) {
			if (key.shift) {
				chr = '|';
			}
			else {
				chr = '\\';
			}
		}
		else if (key.code == Key.Quote) {
			if (key.shift) {
				chr = '"';
			}
			else {
				chr = '\'';
			}
		}
		else if (key.code == Key.Tab && !key.shift) {
			chr = '\t';
		}
		else if (key.code == Key.Space) {
			chr = ' ';
		}
		else if (key.code == Key.Return && !key.shift) {
			chr = '\r';
		}
		else {
			return false;
		}

		return true;
	}

public:

	enum Signal {
		NeedRedraw
	}

	this(int x, int y, int width, int height, Color bg = Color.Black) {
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

		this._prev = null;
		this._next = null;
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

		parent.redraw();
	}

	void reposition(int left, int top, int width = int.min, int height = int.min) {
		int w, h;
		int oldW, oldH;
		oldW = this.width();
		oldH = this.height();

		if (width == int.min) {
			w = oldW;
		}
		else {
			w = width;
		}

		if (height == int.min) {
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

		_dirty = true;
		_redraw();
	}

	// Events

	void onEvent(ref Event evt) {
		switch(evt.type) {
			case Event.KeyDown:
				auto key = Keyboard.translate(evt.info.key);
				_dispatchKeyDown(key);
				if (key.printable != '\0') {
					_dispatchKeyChar(key.printable);
				}
				break;
			case Event.MouseDown:
				_mouse.x = evt.info.mouse.x;
				_mouse.y = evt.info.mouse.y;
				_mouse.clicks[] = evt.info.mouse.clicks[];
				_dispatchPrimaryDown(_mouse);
				break;
			case Event.MouseUp:
				_mouse.x = evt.info.mouse.x;
				_mouse.y = evt.info.mouse.y;
				_dispatchPrimaryUp(_mouse);
				_mouse.clicks[evt.aux] = 0;
				break;
			case Event.MouseWheelX:
				_mouse.x = evt.info.mouse.x;
				_mouse.y = evt.info.mouse.y;
				_dispatchScrollX(_mouse, evt.aux);
				break;
			case Event.MouseWheelY:
				_mouse.x = evt.info.mouse.x;
				_mouse.y = evt.info.mouse.y;
				_dispatchScrollY(_mouse, evt.aux);
				break;
			case Event.MouseMove:
				_mouse.x = evt.info.mouse.x;
				_mouse.y = evt.info.mouse.y;
				if (_mouse.clicks[0] > 0 || _mouse.clicks[1] > 0 || _mouse.clicks[2] > 0) {
					_dispatchDrag(_mouse);
				}
				else {
					_dispatchHover(_mouse);
				}
				break;
/*			case Event.Close:
				this.exit(evt.info.exitCode);
				break;*/
			case Event.Size:
				break;
			default:
				break;
		}
	}

	void onResize() {
	}

	void onGotFocus() {
	}

	void onLostFocus() {
	}

	void onKeyDown(Key key) {
	}

	void onKeyChar(dchar keyChar) {
	}

	void onPrimaryDown(ref Mouse mouse) {
	}

	void onPrimaryUp(ref Mouse mouse) {
	}
	
	void onScrollX(ref Mouse mouse, int delta) {
	}

	void onScrollY(ref Mouse mouse, int delta) {
	}

	void onDrag(ref Mouse mouse) {
	}

	void onHover(ref Mouse mouse) {
	}

	void onDrawChildren(CuiCanvas canvas) {
		// Subwindows
		foreach(window; this) {
			if (!(window.visible)) {
				continue;
			}

			Rect rt;

			// If this window is dirty, then we must also redraw all child windows
			if (this._dirty) {
				window._needsRedraw = true;
				window._dirty = true;
			}

			if (window._needsRedraw) {
				window._needsRedraw = false;

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

				window.onDrawChildren(canvas);

				if (window._dirty) {
					canvas.position(0,0);
					window.onDraw(canvas);
					window._dirty = false;
				}

				canvas.clipRestore();

				// Reset context
				canvas.contextPop();
			}

			// Clip this window
			rt.left = window.left;
			rt.top = window.top;
			rt.right = window.width + window.left;
			rt.bottom = window.height + window.top;
			canvas.clipRect(rt);
		}
	}

	void onDraw(CuiCanvas canvas) {
		if (!_dirty) {
			return;
		}

		// Paint the background of the window
		canvas.backcolor = _bg;
		int amt = this.width;
		if (amt > Console.width) {
			amt = Console.width;
		}
		if (amt < 0) {
			return;
		}

		const string bgchr = " ";

		string line = times(bgchr, amt);
		for(uint i = 0; i < this.height; i++) {
			canvas.position(0,i);
			canvas.write(line);
		}

		_dirty = false;
	}

	// Methods

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

	// Signal Handler
	override void attach(Dispatcher dsp, SignalHandler handler = null) {
		super.attach(dsp, handler);

		auto window = cast(CuiWindow)dsp;
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
		auto window = cast(CuiWindow)dsp;

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

	// Properties

	// Description: This property will give you the number of windows attached
	//  to this window.
	int windowCount() {
		return _count;
	}
}
