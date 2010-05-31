module cui.application;

import cui.window;
import cui.canvas;

import core.application;
import core.string;
import core.event;
import core.main;
import core.definitions;

import scaffold.cui;

import platform.vars.cui;

import io.console;

import binding.c;

import data.list;

class CuiApplication : Application {
private:
    CuiPlatformVars _pfvars;

	CuiWindow _focused_window;
	List!(CuiWindow) _window_list;

	bool _running;

	void eventLoop() {
		_running = true;
		while(_running) {
			Event evt;
			if (_window_list.empty()) {
				continue;
			}

			CuiNextEvent(&evt, &_pfvars);

			switch(evt.type) {
				case Event.KeyDown:
					if (_focused_window !is null) {
						_focused_window.onKeyDown(evt.info.key);
						dchar chr;
						if (isPrintable(evt.info.key, chr)) {
							_focused_window.onKeyChar(chr);
						}
					}
					break;
				case Event.MouseDown:
					break;
				case Event.MouseUp:
					break;
				case Event.MouseMove:
					break;
				case Event.Close:
					this.exit(evt.info.exitCode);
					break;
				case Event.Size:
					break;
				default:
					break;
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
				chr = '}';
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
		auto canvas = new CuiCanvas();
		foreach(window; _window_list) {
			window.onDraw(canvas);
		}
	}

protected:

	override void shutdown() {
		CuiEnd(&_pfvars);
	}

	override void start() {
		eventLoop();
	}

	override void end(uint exitCode) {
		_running = false;
	}


public:
	this() {
		_window_list = new List!(CuiWindow);
		CuiStart(&_pfvars);
		super();
	}

	this(string appName) {
		_window_list = new List!(CuiWindow);
		CuiStart(&_pfvars);
		super(appName);
	}

	CuiWindow window() {
		return _focused_window;
	}

	override void push(Dispatcher dsp) {
		super.push(dsp);

		if (cast(CuiWindow)dsp !is null) {
			// Add to the window list
			auto window = cast(CuiWindow)dsp;
			_window_list.add(window);

			// Focus on this window (if it is visible)
			if (window.visible) {
				_focused_window = window;
			}

			_redraw();
		}
	}
}

/+
// Description: This class represents a Text User Interface application (TUI).
class CuiApplication : Application {
public:

	this() {
		CuiStart(&_pfvars);
		super();
	}

	this(string appName) {
		CuiStart(&_pfvars);
		super(appName);
	}

	override void push(Dispatcher dsp) {
		super.push(dsp);

		if (cast(CuiWindow)dsp !is null) {
			setWindow(cast(CuiWindow)dsp);
		}
	}

	CuiWindow window() {
		return _curConsoleWindow;
	}

	override bool isZombie() {
		return (_curConsoleWindow is null);
	}

protected:

	CuiWindow _curConsoleWindow;

    CuiPlatformVars _pfvars;

	override void shutdown() {
		CuiEnd(&_pfvars);
	}

	override void start() {
		eventLoop();
	}

	override void end(uint exitCode) {
		_running = false;
	}

private:

	void setWindow(CuiWindow window) {
		_curConsoleWindow = window;

		// Draw Window
		window.onInitialize();
	}

	bool _running = true;

	void eventLoop() {
		while(_running) {
			CuiEvent evt;
			if (_curConsoleWindow is null) {
				continue;
			}

			CuiNextEvent(&evt, &_pfvars);

			switch(evt.type) {
				case CuiEvent.Type.KeyDown:
					_curConsoleWindow.onKeyDown(evt.info.key);
					dchar chr;
					if (isPrintable(evt.info.key, chr)) {
						_curConsoleWindow.onKeyChar(chr);
					}
					break;
				case CuiEvent.Type.MouseDown:
					break;
				case CuiEvent.Type.MouseUp:
					break;
				case CuiEvent.Type.MouseMove:
					break;
				case CuiEvent.Type.Close:
					this.exit(evt.aux);
					break;
				case CuiEvent.Type.Size:
					_curConsoleWindow._onResize();
					break;
				default:
					break;
			}
		}
	}

	bool _inited;

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
				chr = '}';
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
}
+/
