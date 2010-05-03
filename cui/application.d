module cui.application;

import cui.window;

import core.application;
import core.string;
import core.event;
import core.main;
import core.definitions;

import scaffold.cui;

import platform.vars.cui;

import io.console;

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
