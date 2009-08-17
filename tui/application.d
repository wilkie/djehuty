module tui.application;

import tui.window;
import tui.apploop; // Platform Specific Entry

import core.application;
import core.string;
import core.event;
import core.main;
import core.definitions;

import scaffold.tui;

import platform.vars.tui;

import io.console;

// Description: This class represents a Text User Interface application (TUI).
class TuiApplication : Application {
public:

	this() {
		super();
		TuiStart(&_pfvars);
	}

	this(String appName) {
		super(appName);
	}

	this(string appName) {
		super(appName);
	}

	override void push(Dispatcher dsp) {
		super.push(dsp);

		if (cast(TuiWindow)dsp !is null) {
			setWindow(cast(TuiWindow)dsp);
		}
	}

	TuiWindow window() {
		return _curConsoleWindow;
	}

	override bool isZombie() {
		return (_curConsoleWindow is null);
	}

protected:

	TuiWindow _curConsoleWindow;

    TuiPlatformVars _pfvars;

	override void start() {
		eventLoop();
	}

	override void end(uint exitCode) {
		_running = false;
		TuiEnd(&_pfvars);
	}

private:

	void setWindow(TuiWindow window) {
		_curConsoleWindow = window;

		// Draw Window
		window.onInitialize();
	}
	
	bool _running = true;

	void eventLoop() {
		while(_running) {
			TuiEvent evt;
			TuiNextEvent(&evt, &_pfvars);
	
			switch(evt.type) {
				case TuiEvent.Type.KeyDown:
					_curConsoleWindow.onKeyDown(evt.info.key);
					break;
				case TuiEvent.Type.KeyChar:
					_curConsoleWindow.onKeyChar(cast(dchar)evt.aux);
					break;
				case TuiEvent.Type.KeyUp:
					_curConsoleWindow.onKeyUp(evt.info.key);
					break;
				case TuiEvent.Type.MouseDown:
					break;
				case TuiEvent.Type.MouseUp:
					break;
				case TuiEvent.Type.MouseMove:
					break;
				case TuiEvent.Type.Close:
					Djehuty.end(evt.aux);
					break;
				default:
					break;
			}
		}
	}

	bool _inited;
}
