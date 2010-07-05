module cui.application;

import cui.window;
import cui.canvas;

import djehuty;

import scaffold.cui;
import scaffold.console;

import platform.vars.cui;

import data.list;

import io.console;

import synch.semaphore;

class CuiApplication : Application {
private:
    CuiPlatformVars _pfvars;

	Semaphore _lock;

	CuiWindow _mainWindow;

	bool _running = false;
	bool _allowRedraw = false;
	bool _needRedraw = false;
	Mouse _mouse;

	void eventLoop() {
		_running = true;
		while(_running) {
			Event evt;

			CuiNextEvent(&evt, &_pfvars);

			_allowRedraw = false;
			switch(evt.type) {
				case Event.KeyDown:
					_mainWindow.onKeyDown(evt.info.key);
					dchar chr;
					if (isPrintable(evt.info.key, chr)) {
						_mainWindow.onKeyChar(chr);
					}
					break;
				case Event.MouseDown:
					_mouse.x = evt.info.mouse.x;
					_mouse.y = evt.info.mouse.y;
					_mouse.clicks[evt.aux] = 1;
					_mainWindow.onPrimaryDown(_mouse);
					break;
				case Event.MouseUp:
					_mouse.x = evt.info.mouse.x;
					_mouse.y = evt.info.mouse.y;
					_mainWindow.onPrimaryUp(_mouse);
					_mouse.clicks[evt.aux] = 0;
					break;
				case Event.MouseMove:
					_mouse.x = evt.info.mouse.x;
					_mouse.y = evt.info.mouse.y;
					if (_mouse.clicks[0] > 0 || _mouse.clicks[1] > 0 || _mouse.clicks[2] > 0) {
						_mainWindow.onDrag(_mouse);
					}
					else {
						_mainWindow.onHover(_mouse);
					}
					break;
				case Event.Close:
					this.exit(evt.info.exitCode);
					break;
				case Event.Size:
					break;
				default:
					break;
			}
			_allowRedraw = true;
			if (_needRedraw) {
				_needRedraw = false;
				_redraw();
			}
		}
	}

	bool isPrintable(Key key, out dchar chr) {
		if (key.ctrl || key.alt) {
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

	void _redraw() {
		_lock.down();
		auto canvas = new CuiCanvas();
		canvas.position(0,0);
		_mainWindow.onDrawChildren(canvas);
		_mainWindow.onDraw(canvas);

		CuiSwapBuffers(&_pfvars);
		_lock.up();
	}

protected:

	override void shutdown() {
		CuiEnd(&_pfvars);
	}

	override void start() {
		_allowRedraw = true;
		_redraw();
		eventLoop();
	}

	override void end(uint exitCode) {
		_running = false;
	}


public:
	override bool onSignal(Dispatcher dsp, uint signal) {
		auto window = cast(CuiWindow)dsp;
		if (window !is null) {
			if (signal == CuiWindow.Signal.NeedRedraw) {
				if (!_allowRedraw) {
					_needRedraw = true;
				}
				else {
					_redraw();
				}
				return true;
			}
		}
		return false;
	}

	this() {
		_lock = new Semaphore(1);
		CuiStart(&_pfvars);
		_mainWindow = new CuiWindow(0, 0, Console.width, Console.height);
		_mainWindow.visible = true;
		push(_mainWindow);
		super();
	}

	this(string appName) {
		_lock = new Semaphore(1);
		CuiStart(&_pfvars);
		_mainWindow = new CuiWindow(0, 0, Console.width, Console.height);
		_mainWindow.visible = true;
		push(_mainWindow);
		super(appName);
	}

	override void push(Dispatcher dsp, SignalHandler handler = null) {
		auto window = cast(CuiWindow)dsp;
		if (window !is null && window !is _mainWindow) {
			// Add to the window list
			_mainWindow.push(window, handler);
			_mainWindow.redraw();
		}
		else {
			super.push(dsp, handler);
		}
	}
}
