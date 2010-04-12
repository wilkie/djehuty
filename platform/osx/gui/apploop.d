/*
 * apploop.d
 *
 * This is the Gui Application entry point for Linux.
 *
 * Author: Dave Wilkinson
 * Originated: July 25th, 2009
 *
 */

module gui.apploop;

import platform.vars.window;
import platform.vars.view;

import platform.osx.common;

import gui.window;
import gui.application;

import graphics.view;

import core.main;
import core.definitions;

import io.console;

extern (C) void _OSXLoop();
class GuiApplicationController {

	// The initial entry for the gui application
	this() {
	}

	void start() {
		mainloop();
	}

	void end(uint code) {
	}

private:

	void mainloop() {
		_OSXLoop();
	}
}
