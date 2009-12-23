/*
 * main.d
 *
 * This is the main entry point for windows applications.
 *
 * Author: Dave Wilkinson
 * Originated: July 20th, 2009
 *
 */

module platform.win.main;

import platform.win.common;

import core.arguments;
import core.string;
import core.unicode;
import core.main;

import io.console;

import binding.c;

import analyzing.debugger;

import platform.application;

extern (C) void gc_init();
extern (C) void gc_term();
extern (C) void _minit();
extern (C) void _moduleCtor();
extern (C) void _moduleUnitTests();

// The windows entry point
extern (Windows)
int WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {

	int result;

	gc_init();			// initialize garbage collector
	_minit();			// initialize module constructor table

	int windowsVersion;

	try {

		ApplicationController app = ApplicationController.instance;

		windowsVersion = app.windowsVersion;

		_moduleCtor();		// call module constructors
		_moduleUnitTests();	// run unit tests (optional)

		Djehuty.application.run();

		app = null;
	}
	catch (Object o) {
		// Catch any unhandled exceptions
		Debugger.raiseException(cast(Exception)o);

		result = 0;		// failed
	}

	// This is a bug in the GC with windows 7... I just don't call it
	// XXX: Fix when GC is fixed
	if (windowsVersion != OsVersionWindows7) {
		gc_term();			// run finalizers; terminate garbage collector
	}

    return result;
}
