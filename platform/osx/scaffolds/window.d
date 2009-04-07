module platform.osx.scaffolds.window;




import platform.osx.vars;
import platform.osx.common;

import core.view;
import core.graphics;
import core.color;

import bases.window;
import core.window;
import platform.osx.main;
import core.string;
import core.file;

import core.main;

import core.definitions;


// this is an intermediate step
extern(C) void _D_OSXInitView(void* windPtr, _OSXViewPlatformVars* viewVars, _OSXWindowPlatformVars* windowVars)
{
	BaseWindow window = cast(BaseWindow)windPtr;

	WindowPlatformVars* windVars = WindowGetPlatformVars(window);
	windVars.viewVars = viewVars;

	// create the window's view object
	if (WindowHasView(window))
	{
		Window windref = cast(Window)window;

		WindowInitView(windref);
	}
}


// all windows

extern (C) _OSXViewPlatformVars* _OSXWindowCreate(void* windowRef, _OSXWindowPlatformVars*, _OSXWindowPlatformVars**, char* initTitle, int initX, int initY, int initW, int initH);
extern (C) void _OSXWindowShow(_OSXWindowPlatformVars*, int);
extern (C) void _OSXWindowSetTitle(_OSXWindowPlatformVars*, char*);

extern (C) void _OSXWindowStartDraw(_OSXWindowPlatformVars* windVars, _OSXViewPlatformVars* viewVars, int isSysColorWindow, char r, char g, char b);

void WindowCreate(ref BaseWindow window, WindowPlatformVars* windowVars)
{
		//	printf("WPV VARS: %p\n", windowVars.vars);
	String s = new String(window.getText());
	s.appendChar('\0');
	windowVars.viewVars = _OSXWindowCreate(cast(void*)window, null, &windowVars.vars, s.ptr, window.getX(), window.getY(), window.getWidth(), window.getHeight());

		//	printf("WPV VARS: %p\n", windowVars.vars);
	// show or hide the window
	//_OSXWindowShow(windowVars.vars, cast(int)window.getVisibility());
}

void WindowCreate(ref BaseWindow parent, WindowPlatformVars* parentVars, ref BaseWindow window, WindowPlatformVars* windowVars)
{
	_OSXWindowCreate(cast(void*)window, parentVars.vars, &windowVars.vars, window.getText().ptr, window.getX(), window.getY(), window.getWidth(), window.getHeight());

	// show or hide the window
	//_OSXWindowShow(windowVars.vars, cast(int)window.getVisibility());
}

void WindowSetStyle(ref BaseWindow window, WindowPlatformVars* windowVars)
{
}

void WindowReposition(ref BaseWindow window, WindowPlatformVars* windowVars)
{
}

void WindowSetState(ref BaseWindow window, WindowPlatformVars* windowVars)
{
}

void _GatherStyleInformation(ref BaseWindow window, WindowPlatformVars* windowVars, ref uint istyle, ref uint iexstyle)
{
}

void _ClientSizeToWindowSize(ref BaseWindow window, WindowPlatformVars* windowVars, ref int width, ref int height)
{
}

void WindowRebound(ref BaseWindow window, WindowPlatformVars* windowVars)
{
}

void WindowDestroy(ref BaseWindow window, WindowPlatformVars* windowVars)
{
}

void WindowSetVisible(ref BaseWindow window, WindowPlatformVars* windowVars, bool bShow)
{
			//printf("WPV VARS: %p\n", windowVars.vars);
	_OSXWindowShow(windowVars.vars, 1);
}

void WindowSetTitle(ref BaseWindow window, WindowPlatformVars* windowVars)
{
	String s = new String(window.getText());
	s.appendChar('\0');
	_OSXWindowSetTitle(windowVars.vars, s.ptr);
}

// CLIENT TO SCREEN

// Takes a point on the window's client area and returns the actual screen
// coordinates for that point.

void WindowClientToScreen(ref BaseWindow window, WindowPlatformVars* windowVars, ref uint x, ref uint y)
{
}

void WindowClientToScreen(ref BaseWindow window, WindowPlatformVars* windowVars, ref Coord pt)
{
}

void WindowClientToScreen(ref BaseWindow window, WindowPlatformVars* windowVars, ref Rect rt)
{
}

import std.stdio;
// Viewable windows
void WindowStartDraw(ref Window window, WindowPlatformVars* windowVars, ref View view, ref ViewPlatformVars viewVars)
{
			//printf("WPV VARS: %p\n", windowVars.vars);
	//printf("start draw (D)\n");

	Color clr = window.getColor();

	_OSXWindowStartDraw(windowVars.vars, windowVars.viewVars, 1, ColorGetR(clr), ColorGetG(clr), ColorGetB(clr));

	//printf("start draw done(D)\n");
}

void WindowEndDraw(ref Window window, WindowPlatformVars* windowVars, ref View view, ref ViewPlatformVars viewVars)
{
}

void WindowCaptureMouse(ref Window window, WindowPlatformVars* windowVars)
{
}

void WindowReleaseMouse(ref Window window, WindowPlatformVars* windowVars)
{
}
