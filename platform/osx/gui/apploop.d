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

// This event routine is a common event handler for all OS X Cocoa events.

enum OSXEvents {
	// Window Events

	EventResize, // parameters: (width, height) of window

	// Mouse Events, params are (x, y) coordinates

	EventPrimaryDown,
	EventSecondaryDown,
	EventTertiaryDown,
	EventPrimaryUp,
	EventSecondaryUp,
	EventTertiaryUp,
	EventMouseMove,

	EventOtherDown = 0xff,
	EventOtherUp = 0xffff,
}

extern (C) void OSXEventRoutine(void* windowRef, int event, int p1, int p2) {

	//	writefln("OSXEventRoutine (D)");

	Window window = cast(Window)windowRef;
	switch (event) {
		case OSXEvents.EventResize:
			window._width = p1;
			window._height = p2;

			window.onResize();
			break;

		case OSXEvents.EventPrimaryDown:

			short x = p1 & 0xFFFF;
			short y = p1 >> 16;

			window.mouseProps.x = x;
			window.mouseProps.y = y;

			window.mouseProps.clicks = p2;

			window.mouseProps.leftDown = 1;

			window.onPrimaryMouseDown();

			break;

		case OSXEvents.EventSecondaryDown:

			short x = p1 & 0xFFFF;
			short y = p1 >> 16;

			window.mouseProps.x = x;
			window.mouseProps.y = y;

			window.mouseProps.clicks = p2;

			window.mouseProps.rightDown = 1;

			window.onSecondaryMouseDown();

			break;

		case OSXEvents.EventTertiaryDown:

			short x = p1 & 0xFFFF;
			short y = p1 >> 16;

			window.mouseProps.x = x;
			window.mouseProps.y = y;

			window.mouseProps.clicks = p2;

			window.mouseProps.middleDown = 1;

			window.onTertiaryMouseDown();

			break;

		case OSXEvents.EventPrimaryUp:

			short x = p1 & 0xFFFF;
			short y = p1 >> 16;

			window.mouseProps.x = x;
			window.mouseProps.y = y;

			window.mouseProps.clicks = p2;

			window.mouseProps.leftDown = 0;

			window.onPrimaryMouseUp();

			break;

		case OSXEvents.EventSecondaryUp:

			short x = p1 & 0xFFFF;
			short y = p1 >> 16;

			window.mouseProps.x = x;
			window.mouseProps.y = y;

			window.mouseProps.clicks = p2;

			window.mouseProps.rightDown = 0;

			window.onSecondaryMouseUp();
			break;

		case OSXEvents.EventTertiaryUp:

			short x = p1 & 0xFFFF;
			short y = p1 >> 16;

			window.mouseProps.x = x;
			window.mouseProps.y = y;

			window.mouseProps.clicks = p2;

			window.mouseProps.middleDown = 0;

			window.onTertiaryMouseUp();
			break;

		case OSXEvents.EventMouseMove:

			short x = p1 & 0xFFFF;
			short y = p1 >> 16;

			window.mouseProps.x = x;
			window.mouseProps.y = y;

			window.mouseProps.clicks = p2;

			window.onMouseMove();
			break;

		default:

			// check for mouse event: Other Up
			if (event >= OSXEvents.EventOtherUp) {

				short x = p1 & 0xFFFF;
				short y = p1 >> 16;

				window.mouseProps.x = x;
				window.mouseProps.y = y;

				window.mouseProps.clicks = p2;

				window.onOtherMouseUp(event -= OSXEvents.EventOtherUp);
			}
			// look for mouse event: Other Down
			else if (event >= OSXEvents.EventOtherDown) {

				short x = p1 & 0xFFFF;
				short y = p1 >> 16;

				window.mouseProps.x = x;
				window.mouseProps.y = y;

				window.mouseProps.clicks = p2;

				//window.mouseProps.middleDown = 0;

				window.onOtherMouseDown(event -= OSXEvents.EventOtherDown);

			}

			break;
	}

	//	writefln("OSXEventRoutine (D) done");
}



