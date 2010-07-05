/*
 * application.d
 *
 * This module implements the GUI application class that will be the starting
 * point for a GUI application. From this, Window classes with Widgets can be
 * created and pushed.
 *
 * Author: Dave Wilkinson
 * Originated: June 24th, 2009
 *
 */

module gui.application;

import core.application;
import core.event;

import gui.widget;
import gui.window;

// Platform Specific application entry
import gui.apploop;

import platform.vars.window;

import scaffold.window;

class GuiApplication : Application {
protected:
	override void start() {
		_appController.start();
	}

	override void end(uint exitCode) {
		_appController.end(exitCode);
	}

private:

	Window _mainWindow;

public:

	// Constructors

	this() {
		_lock = new Semaphore(1);
		//CuiStart(&_pfvars);
		_mainWindow = new Window(0, 0, 0, 0);
		_mainWindow.visible = true;
		push(_mainWindow);
		super();
	}

	this(string appName) {
		//CuiStart(&_pfvars);
		_mainWindow = new Window(0, 0, 0, 0);
		_mainWindow.visible = true;
		super(appName);
	}

	override void push(Dispatcher dsp) {
		auto window = cast(Window)dsp;
		if (window !is null) {
			_mainWindow.push(dsp);
		}

		super.push(dsp);
	}

	// Properties

	// Methods

	override bool isZombie() {
		return 1 == 0;
	}
}
