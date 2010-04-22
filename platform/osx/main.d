
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

extern (C) void call(void* stuff) {
}

// These functions are within the objective-c code
// These start the OS X event loop.
extern (C) void _OSXStart();
extern (C) void _OSXEnd();

int main() {
	_OSXStart();

	Djehuty.application.run();

	_OSXEnd();

    return 0;
}
