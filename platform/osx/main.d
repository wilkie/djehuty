
module platform.osx.main;

import core.main;
import core.definitions;
import gui.window;
import graphics.view;
import resource.menu;

import binding.c;

import tui.window;

import core.string;

extern (C) void hi();

extern (C) void call(void* stuff)
{
}

// This event routine is a common event handler for all OS X Cocoa events.

enum OSXEvents
{
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
};

extern (C) void OSXEventRoutine(void* windowRef, int event, int p1, int p2)
{

//	writefln("OSXEventRoutine (D)");
/*
	Window window = cast(Window)windowRef;
	switch (event)
	{
		case OSXEvents.EventResize:
			SetWindowWidth(window, p1);
			SetWindowHeight(window, p2);

			CallRedraw(window);
			break;

		case OSXEvents.EventPrimaryDown:

			short x = p1 & 0xFFFF;
			short y = p1 >> 16;

			window.mouseProps.x = x;
			window.mouseProps.y = y;

			window.mouseProps.clicks = p2;

			window.mouseProps.leftDown = 1;

			writefln(x, " , ", y, " - left");

			CallPrimaryMouseDown(window);

			break;

		case OSXEvents.EventSecondaryDown:

			short x = p1 & 0xFFFF;
			short y = p1 >> 16;

			window.mouseProps.x = x;
			window.mouseProps.y = y;

			window.mouseProps.clicks = p2;

			window.mouseProps.rightDown = 1;

			writefln(x, " , ", y, " - right");

			CallSecondaryMouseDown(window);

			break;

		case OSXEvents.EventTertiaryDown:

			short x = p1 & 0xFFFF;
			short y = p1 >> 16;

			window.mouseProps.x = x;
			window.mouseProps.y = y;

			window.mouseProps.clicks = p2;

			window.mouseProps.middleDown = 1;

			writefln(x, " , ", y, " - middle");

			CallTertiaryMouseDown(window);

			break;

		case OSXEvents.EventPrimaryUp:

			short x = p1 & 0xFFFF;
			short y = p1 >> 16;

			window.mouseProps.x = x;
			window.mouseProps.y = y;

			window.mouseProps.clicks = p2;

			window.mouseProps.leftDown = 0;

			writefln(x, " , ", y, " - left up");

			CallPrimaryMouseUp(window);

			break;

		case OSXEvents.EventSecondaryUp:

			short x = p1 & 0xFFFF;
			short y = p1 >> 16;

			window.mouseProps.x = x;
			window.mouseProps.y = y;

			window.mouseProps.clicks = p2;

			window.mouseProps.rightDown = 0;

			writefln(x, " , ", y, " - right up");

			CallSecondaryMouseUp(window);

			break;

		case OSXEvents.EventTertiaryUp:

			short x = p1 & 0xFFFF;
			short y = p1 >> 16;

			window.mouseProps.x = x;
			window.mouseProps.y = y;

			window.mouseProps.clicks = p2;

			window.mouseProps.middleDown = 0;

			writefln(x, " , ", y, " - middle up");

			CallTertiaryMouseUp(window);

			break;

		case OSXEvents.EventMouseMove:

			short x = p1 & 0xFFFF;
			short y = p1 >> 16;

			window.mouseProps.x = x;
			window.mouseProps.y = y;

			window.mouseProps.clicks = p2;

			writefln(x, " , ", y, " - move");

			CallMouseMove(window);

			break;



		default:

			// check for mouse event: Other Up
			if (event >= OSXEvents.EventOtherUp)
			{

				short x = p1 & 0xFFFF;
				short y = p1 >> 16;

				window.mouseProps.x = x;
				window.mouseProps.y = y;

				window.mouseProps.clicks = p2;

				//window.mouseProps.middleDown = 0;

				writefln(x, " , ", y, " - other up");

				CallOtherMouseUp(window, event -= OSXEvents.EventOtherUp);

			}
			// look for mouse event: Other Down
			else if (event >= OSXEvents.EventOtherDown)
			{

				short x = p1 & 0xFFFF;
				short y = p1 >> 16;

				window.mouseProps.x = x;
				window.mouseProps.y = y;

				window.mouseProps.clicks = p2;

				//window.mouseProps.middleDown = 0;

				writefln(x, " , ", y, " - other down");

				CallOtherMouseDown(window, event -= OSXEvents.EventOtherDown);

			}

			break;
	}
*/
//	writefln("OSXEventRoutine (D) done");
}

// These functions are within the objective-c code
// These start the OS X event loop.
extern (C) void _OSXStart();
extern (C) void _OSXEnd();

int main() {
	printf("Main\n");
	_OSXStart();
	printf("Running\n");

	Djehuty.application.run();

	_OSXEnd();

    return 0;
}
