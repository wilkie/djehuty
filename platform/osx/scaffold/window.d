module scaffold.window;




import platform.vars.window;
import platform.vars.view;
import platform.osx.common;

import graphics.view;
import graphics.graphics;
import core.color;

import gui.window;
import platform.osx.main;
import core.string;
import io.file;

import core.main;

import core.definitions;
// this is an intermediate step
extern(C) void _D_OSXInitView(void* windPtr, _OSXViewPlatformVars* viewVars, _OSXWindowPlatformVars* windowVars)
{
	/*Window window = cast(Window)windPtr;

	WindowPlatformVars* windVars = WindowGetPlatformVars(window);
	windVars.viewVars = viewVars;

	// create the window's view object
	if (WindowHasView(window))
	{
		Window windref = cast(Window)window;

		WindowInitView(windref);
	}*/
}


// all windows

extern (C) _OSXViewPlatformVars* _OSXWindowCreate(void* windowRef, _OSXWindowPlatformVars*, _OSXWindowPlatformVars**, char* initTitle, int initX, int initY, int initW, int initH);
extern (C) void _OSXWindowShow(_OSXWindowPlatformVars*, int);
extern (C) void _OSXWindowSetTitle(_OSXWindowPlatformVars*, char*);

extern (C) void _OSXWindowStartDraw(_OSXWindowPlatformVars* windVars, _OSXViewPlatformVars* viewVars, int isSysColorWindow, double r, double g, double b);
import binding.c;
void WindowCreate(ref Window window, WindowPlatformVars* windowVars)
{
//	String s = new String(window.getText());
//	s.appendChar('\0');
//	windowVars.viewVars = _OSXWindowCreate(cast(void*)window, null, &windowVars.vars, s.ptr, window.getX(), window.getY(), window.getWidth(), window.getHeight());

string s = window.text;
s ~= '\0';
windowVars.viewVars = _OSXWindowCreate(cast(void*)window, null, &windowVars.vars, s.ptr, window.x, window.y, window.width, window.height);  
	// show or hide the window
	//_OSXWindowShow(windowVars.vars, cast(int)window.getVisibility());
	window.onInitialize();
	window.onAdd();
}

void WindowCreate(ref Window parent, WindowPlatformVars* parentVars, ref Window window, WindowPlatformVars* windowVars)
{
//	_OSXWindowCreate(cast(void*)window, parentVars.vars, &windowVars.vars, window.getText().ptr, window.getX(), window.getY(), window.getWidth(), window.getHeight());

printf("FOO!\n");
string s = window.text;
s ~= '\0';
windowVars.viewVars = _OSXWindowCreate(cast(void*)window, null, &windowVars.vars, s.ptr, window.x, window.y, window.width, window.height);  
	// show or hide the window
	//_OSXWindowShow(windowVars.vars, cast(int)window.getVisibility());
}

void WindowSetStyle(ref Window window, WindowPlatformVars* windowVars)
{
}

void WindowReposition(ref Window window, WindowPlatformVars* windowVars)
{
}

void WindowSetState(ref Window window, WindowPlatformVars* windowVars)
{
}

void _GatherStyleInformation(ref Window window, WindowPlatformVars* windowVars, ref uint istyle, ref uint iexstyle)
{
}

void _ClientSizeToWindowSize(ref Window window, WindowPlatformVars* windowVars, ref int width, ref int height)
{
}

void WindowRebound(ref Window window, WindowPlatformVars* windowVars)
{
}

void WindowDestroy(ref Window window, WindowPlatformVars* windowVars)
{
}

void WindowSetVisible(ref Window window, WindowPlatformVars* windowVars, bool bShow) {
	_OSXWindowShow(windowVars.vars, 1);
}

void WindowSetTitle(ref Window window, WindowPlatformVars* windowVars)
{
//	String s = new String(window.getText());
//	s.appendChar('\0');
	string s = window.text;
	s ~= '\0';
	_OSXWindowSetTitle(windowVars.vars, s.ptr);
}

// CLIENT TO SCREEN

// Takes a point on the window's client area and returns the actual screen
// coordinates for that point.

void WindowClientToScreen(ref Window window, WindowPlatformVars* windowVars, ref int x, ref int y)
{
}

void WindowClientToScreen(ref Window window, WindowPlatformVars* windowVars, ref Coord pt)
{
}

void WindowClientToScreen(ref Window window, WindowPlatformVars* windowVars, ref Rect rt)
{
}

// Viewable windows
void WindowStartDraw(ref Window window, WindowPlatformVars* windowVars, ref WindowView view, ref ViewPlatformVars viewVars) {
	_OSXWindowStartDraw(windowVars.vars, windowVars.viewVars, 1, window.color.red, window.color.green, window.color.blue);
}

void WindowEndDraw(ref Window window, WindowPlatformVars* windowVars, ref WindowView view, ref ViewPlatformVars viewVars)
{
}

void WindowCaptureMouse(ref Window window, WindowPlatformVars* windowVars)
{
}

void WindowReleaseMouse(ref Window window, WindowPlatformVars* windowVars)
{
}
