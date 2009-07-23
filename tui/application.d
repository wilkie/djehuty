module tui.application;

import tui.window;
import tui.apploop; // Platform Specific Entry

import core.application;
import core.string;
import core.event;
import core.main;
import core.definitions;

import io.console;

// Description: This class represents a Text User Interface application (TUI).
class TuiApplication : Application {
public:

	this() {
		super();
		_appController = new TuiApplicationController();
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

	package TuiWindow _curConsoleWindow;

	override void start() {
		_appController.start();
	}

	override void end(uint exitCode) {
		if (_appController !is null) {
			_appController.end(exitCode);
		}
	}

private:

	TuiApplicationController _appController;

	void setWindow(TuiWindow window) {
		_curConsoleWindow = window;

		// Draw Window
		window.onInitialize();
	}

	bool _inited;
}
