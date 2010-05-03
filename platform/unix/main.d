/*
 * main.d
 *
 * This file implements the main routines for the Linux system.
 * This file is the entry point for a Linux application.
 *
 * Author: Dave Wilkinson
 *
 */

module platform.unix.main;

import platform.unix.common;
import platform.application;

import scaffold.console;
import scaffold.directory;

import platform.vars.window;

import gui.application;
import gui.window;

import core.definitions;
import core.main;
import core.string;
import core.arguments;

import graphics.view;

import synch.thread;

import analyzing.debugger;

import io.console;

import cui.application;
import cui.window;

struct DjehutyPlatformVars {
	X.Display* display;
	X.Visual* visual;
	int screen;

	X.Atom wm_destroy_window;
	X.Atom wm_name;
	X.Atom wm_hints;
	X.Atom utf8string;
	X.Atom private_data;

	//for mouse double click timer
	static sigevent clickTimerevp = {{0}};
	static timer_t clickTimerId = null;
	static const itimerspec clickTimertime = {{0, 0}, {0, 250000000}};

	//for keys
	static const int numSysKeys = 6;
	static const X.KeySym[6] sysKey = [Key.Backspace, Key.Delete, Key.Left, Key.Right, Key.Down, Key.Up];

	//GTK IMPLEMENTATION:

	//for xsettings - GTK
	X.Atom x_settings;

	X.Window x_manager;

	bool running = false;

	int argc;
	char** argv;
}

DjehutyPlatformVars* _pfvars() {
	static DjehutyPlatformVars pfvars;

	return &pfvars;
}

extern(C) void mousetimerproc(sigval val) {
	Mouse* p_mouseProps;

	p_mouseProps = cast(Mouse*)val.sival_ptr;

	p_mouseProps.clicks = 1;
}

// segfault handler
extern(C) void segfault_handler(int signum) {
	throw new Exception("Access Violation");
}

void AppInit()
{
	// ------------- */

	// UTF-8 SUPPORT
//	_pfvars.wm_name = X.XInternAtom(_pfvars.display, "_NET_WM_NAME\0"c.ptr, X.Bool.True);
	setlocale(LC_CTYPE, "");

	// segfault handler
	signal(SIGSEGV, &segfault_handler);
}

int main(char[][] args){
	try	{
		AppInit();

		Arguments argList = Arguments.instance();
		foreach(arg; args) {
			argList.add(arg);
		}

		ConsoleInit();
		Djehuty.application.run();
		ConsoleUninit();
	}
	catch(Object o)	{
		Debugger.raiseException(cast(Exception)o);
	}

	return ApplicationController.instance.exitCode;
}
