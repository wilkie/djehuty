/*
 * application.d
 *
 * This module implements the GUI application class that will be the starting
 * point for a GUI application. From this, Window classes can be
 * created and attached.
 *
 */

module gui.application;

import djehuty;

import gui.window;
import gui.dialog;

import graphics.canvas;
import graphics.brush;
import graphics.pen;

import scaffold.gui;
import scaffold.canvas;

import platform.vars.gui;
import platform.vars.window;
import platform.vars.canvas;

import synch.thread;
import synch.semaphore;

import io.console;

import GraphicsScaffold = scaffold.graphics;

import binding.c;

// We want to have the window class manage the windows
// and not the Application, so we subclass a Window
// class here to be the 'root' Window.
private class WindowPlatformContainer {
private:
	WindowPlatformVars _pfvars;
	Thread _eventThread;
	Window _window;
	Semaphore _lock;
	Canvas _canvas;

	void eventLoop(bool ps) {
		Event evt;

		GuiCreateWindow(_window, &_pfvars);

		_lock.up();

		_canvas = new Canvas(cast(int)_window.width, cast(int)_window.height);

		_window.redraw();

		while(true) {
			GuiNextEvent(_window, &_pfvars, &evt);

			if(evt.type == Event.Close) {
				_window.parent.detach(_window);
				break;
			}
		}

		GuiDestroyWindow(_window, &_pfvars);
	}

public:

	this(Window window) {
		_window = window;
		_lock = new Semaphore(1);
		_eventThread = new Thread(&eventLoop);
	}

	void run() {
		_lock.down();
		_eventThread.start();
		_lock.down();
	}

	void update(Canvas canvas) {
		GuiUpdateWindow(_window, &_pfvars, canvas.platformVariables);
	}
}

private class RootWindow : Window {
private:
	WindowPlatformContainer[Window] _vars;
	int _numVisible = 0;

public:
	this() {
		super(0,0,0,0);
	}

	override void attach(Dispatcher dsp, SignalHandler handler = null) {

		auto window = cast(Window)dsp;
		auto dialog = cast(Dialog)dsp;

		Responder.attach(dsp, handler);

		if (window !is null) {
			// Need to create a platform window
			if (window.visible) {
				_numVisible++;
			}
			auto vars = new WindowPlatformContainer(window);
			_vars[window] = vars;
			vars.run();
		}
	}

	override void detach(Dispatcher dsp) {
		auto window = cast(Window)dsp;
		if (window !is null) {
			if (window.parent is this) {
				// Need to destroy a platform window
				if (window.visible) {
					_numVisible--;
				}
				auto vars = _vars[window];
			}
		}

		super.detach(dsp);
	}

	override bool onSignal(Dispatcher dsp, uint signal) {
		auto window = cast(Window)dsp;
		if (window !is null) {
			if (signal == Window.Signal.NeedRedraw) {
				Canvas canvas = new Canvas(cast(int)window.width, cast(int)window.height);

				window.onDraw(canvas);
				window.onDrawChildren(canvas);

				_vars[window].update(canvas);
			}
		}
		return true;
	}

	int numberVisible() {
		return _numVisible;
	}
}

class GuiApplication : Application {
private:
	GuiPlatformVars _pfvars;

	// Window Management
	RootWindow _mainWindow;

	// Window counts
	int _windowCount;
	int _windowVisibleCount;

	bool _running = false;

public:

	this() {
		_mainWindow = new RootWindow();
		attach(_mainWindow);
		super();
		GuiStart(&_pfvars);
	}

	this(string appName) {
		_mainWindow = new RootWindow();
		attach(_mainWindow);
		super(appName);
		GuiStart(&_pfvars);
	}

	// Responder methods

	override void attach(Dispatcher dsp, SignalHandler handler = null) {
		// special cases for Dialog

		auto window = cast(Window)dsp;
		if (window !is null && window !is _mainWindow) {
			// Add it to the dialog list
			_mainWindow.attach(dsp, handler);
		}
		else {
			super.attach(dsp, handler);
		}
	}

	Window root() {
		return _mainWindow;
	}

	override bool isZombie() {
		return _mainWindow.numberVisible == 0;
	}

	override void run() {
		super.run();
		while(this.isZombie is false) {}
	}
}
