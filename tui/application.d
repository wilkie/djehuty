module tui.application;

import tui.window;

import core.application;
import core.string;
import core.event;
import core.main;

import platform.imports;
mixin(PlatformGenericImport!("console"));

// Description: This class represents a Text User Interface application (TUI).
class TuiApplication : Application {
public:

	this() {
		super();
	}

	this(String appName) {
		super(appName);
	}

	this(StringLiteral appName) {
		super(appName);
	}

	override void push(Dispatcher dsp) {
		super.push(dsp);

		if (cast(TuiWindow)dsp !is null) {
			setWindow(cast(TuiWindow)dsp);
		}
	}

	TuiWindow getWindow() {
		return _curConsoleWindow;
	}

protected:

	package TuiWindow _curConsoleWindow;

private:

	void setWindow(TuiWindow window) {
		if (!_inited) {
			ConsoleInit();

			Djehuty._console_inited = true;
			_inited = true;
		}

		_curConsoleWindow = window;

		// Draw Window
		window.OnInitialize();
	}

	bool _inited;
}
