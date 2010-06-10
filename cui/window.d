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

	List!(CuiWindow) _window_list;
	CuiWindow _focusedWindow;
	CuiWindow _dragWindow;

	Rect _bounds;
	Color _bg;

	Semaphore _lock;

public:
	this(int x, int y, int width, int height, Color bg = Color.Black) {
		_lock = new Semaphore(1);
		_window_list = new List!(CuiWindow);
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

	void reposition(int left, int top, int width = -1, int height = -1) {
		int w, h;

		if (width == -1) {
			w = this.width();
		}
		else {
			w = width;
		}

		if (height == -1) {
			h = this.height();
		}
		else {
			h = height;
		}

		_bounds.left = left;
		_bounds.top = top;
		_bounds.right = left + w;
		_bounds.bottom = top + h;

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
		foreach(window; _window_list) {
			if (window.left <= mouse.x
			  && (window.left + window.width) > mouse.x
			  && window.top <= mouse.y
			  && (window.top + window.height) > mouse.y) {

				int xdiff = window.left;
				int ydiff = window.top;
				mouse.x -= xdiff;
				mouse.y -= ydiff;

				_dragWindow = window;
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

		foreach(window; _window_list) {
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
		foreach(window; _window_list) {
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

	void onDrawChildren(CuiCanvas canvas) {
		// Subwindows
		foreach(window; _window_list) {

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
			_window_list.add(window);

			// Focus on this window (if it is visible)
			if (window.visible) {
				_focusedWindow = window;
			}

			redraw();
		}
	}
}
