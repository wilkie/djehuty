
module platform.osx.main;

import platform.application;

import core.arguments;
import core.main;
import core.definitions;
import gui.window;
import graphics.view;
import resource.menu;

import analyzing.debugger;

import scaffold.console;

import binding.c;

import cui.window;

import core.string;

extern (C) void hi();

extern (C) void call(void* stuff) {
}

// These functions are within the objective-c code
// These start the OS X event loop.
extern (C) void _OSXStart();
extern (C) void _OSXEnd();

int main(char[][] args) {
	try	{
		_OSXStart();

		ConsoleInit();
		Arguments argList = Arguments.instance();
		foreach(arg; args) {
			argList.add(arg);
		}

		Djehuty.application.run();
		ConsoleUninit();
	}
	catch(Object o)	{
		Debugger.raiseException(cast(Exception)o);
	}

	_OSXEnd();
	return ApplicationController.instance.exitCode;
}
