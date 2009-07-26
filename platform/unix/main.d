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

import scaffold.console;
import scaffold.directory;

import platform.vars.window;

import gui.application;
import gui.window;

import core.definitions;
import core.main;
import core.string;

import graphics.view;

import synch.thread;

import analyzing.debugger;

import io.console;

import tui.application;
import tui.window;

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
	static const X.KeySym[6] sysKey = [KeyBackspace, KeyDelete, KeyArrowLeft, KeyArrowRight, KeyArrowDown, KeyArrowUp];

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

extern(C) void mousetimerproc(sigval val)
{
	Mouse* p_mouseProps;

	p_mouseProps = cast(Mouse*)val.sival_ptr;

	p_mouseProps.clicks = 1;
}

// segfault handler
extern(C) void segfault_handler(int signum)
{
	throw new Exception("Access Violation");
}
void AppInit()
{
	// ------------- */

	// this code is executed at initialization of the application
	X.XInitThreads();

	_pfvars.running = true;

	//create the window

	//start the app

	//ATTEMPT TO USE GTK
	//int argc = 0;
	//char* argv[] = ("", null);

	//char** argv_ptr = &argv;

	//use X11
	_pfvars.display = X.XOpenDisplay(null);

	_pfvars.screen = X.XDefaultScreen(_pfvars.display);
	_pfvars.visual = X.XDefaultVisual(_pfvars.display, _pfvars.screen);

	//set up click timer
	_pfvars.clickTimerevp.sigev_notify = SIGEV_THREAD;
	_pfvars.clickTimerevp._sigev_un._sigev_thread._function = &mousetimerproc;

	//get Atoms
	_pfvars.wm_destroy_window = X.XInternAtom(_pfvars.display, "WM_DELETE_WINDOW\0"c.ptr, X.Bool.True);
	_pfvars.private_data = X.XInternAtom(_pfvars.display, "DJEHUTY_PRIVATE_DATA\0"c.ptr, X.Bool.True);
	_pfvars.x_settings = X.XInternAtom(_pfvars.display, "_XSETTINGS_SETTINGS\0"c.ptr, X.Bool.False);

//	_pfvars.utf8string = X.XInternAtom(_pfvars.display, "UTF8_STRING\0"c.ptr, X.Bool.True);

	// UTF-8 SUPPORT
//	_pfvars.wm_name = X.XInternAtom(_pfvars.display, "_NET_WM_NAME\0"c.ptr, X.Bool.True);
	setlocale(LC_CTYPE, "");

	// segfault handler
	signal(SIGSEGV, &segfault_handler);
}

int main(char[][] args)
{
	try
	{

		AppInit();

		ConsoleInit();
		Djehuty.start();

		ConsoleUninit();
	}
	catch(Object o)
	{
		Debugger.raiseException(cast(Exception)o);
	}

		X.XCloseDisplay(_pfvars.display);

	return 0;
}
