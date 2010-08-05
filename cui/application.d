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
			_mainWindow.onEvent(evt);
			_allowRedraw = true;

			if (_needRedraw) {
				_needRedraw = false;
				_redraw();
			}
		}
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
		attach(_mainWindow);
		super();
	}

	this(string appName) {
		_lock = new Semaphore(1);
		CuiStart(&_pfvars);
		_mainWindow = new CuiWindow(0, 0, Console.width, Console.height);
		_mainWindow.visible = true;
		attach(_mainWindow);
		super(appName);
	}

	override void attach(Dispatcher dsp, SignalHandler handler = null) {
		auto window = cast(CuiWindow)dsp;
		if (window !is null && window !is _mainWindow) {
			// Add to the window list
			_mainWindow.attach(window, handler);
			_mainWindow.redraw();
		}
		else {
			super.attach(dsp, handler);
		}
	}
}
