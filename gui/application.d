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

class GuiApplication : Application {
private:
	GuiPlatformVars _pfvars;

	// Window Management
	Window _mainWindow;

	// Window counts
	int _windowCount;
	int _windowVisibleCount;

	bool _running = false;

public:

	this() {
		_mainWindow = new Window(0,0,0,0);
		attach(_mainWindow);
		super();
		GuiStart(&_pfvars);
	}

	this(string appName) {
		_mainWindow = new Window(0,0,0,0);
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
		return _mainWindow.visibleCount == 0;
	}

	override void run() {
		super.run();

		// Block this function until all top level windows close (or become
		// invisible)
		while(this.isZombie is false) { Thread.yield(); }
	}
}