/*
 * window.d
 *
 * This Scaffold holds the Window implementations for the Linux platform
 *
 * Author: Dave Wilkinson
 *
 */

module scaffold.window;

import platform.vars.window;
import platform.vars.view;

import platform.unix.common;
import platform.unix.main;

import graphics.view;
import graphics.graphics;

import core.color;
import core.string;
import core.main;
import core.definitions;

import io.file;

import gui.application;
import gui.window;

import io.console;

struct MWMHints {
	Clong flags;
	Clong functions;
	Clong decorations;
	Clong input_mode;
	Clong status;
}

const int PROP_MWM_HINTS_ELEMENTS = 5;

const int MWM_HINTS_FUNCTIONS   = 1;
const int MWM_HINTS_DECORATIONS = 2;
const int MWM_HINTS_INPUT_MODE  = 4;
const int MWM_HINTS_STATUS      = 8;

	/* functions */
const int MWM_FUNC_ALL          = 1;
const int MWM_FUNC_RESIZE       = 2;
const int MWM_FUNC_MOVE         = 4;
const int MWM_FUNC_MINIMIZE     = 8;
const int MWM_FUNC_MAXIMIZE     = 16;
const int MWM_FUNC_CLOSE        = 32;

	/* decorations */
const int MWM_DECOR_ALL         = 1;
const int MWM_DECOR_BORDER      = 2;
const int MWM_DECOR_RESIZEH     = 4;
const int MWM_DECOR_TITLE       = 8;
const int MWM_DECOR_MENU        = 16;
const int MWM_DECOR_MINIMIZE    = 32;
const int MWM_DECOR_MAXIMIZE    = 64;



const int USPosition    = 1;          /* user specified x, y */
const int USSize        = 2;          /* user specified width, height
                                           */
const int PPosition     = 4;          /* program specified position
                                           */
const int PSize         = 8;          /* program specified size */
const int PMinSize      = 16;          /* program specified minimum
                                           size */

const int PMaxSize      = 32;          /* program specified maximum
                                           size */
const int PResizeInc    = 64;          /* program specified Size
                                           increments */
const int PAspect       = 128;          /* program specified min and
                                           max aspect ratios */
const int PBaseSize     = 256;
const int PWinGravity   = 512;

const int PAllHints     = (PPosition|PSize|
                        PMinSize|PMaxSize|
                        PResizeInc|PAspect);




// all windows
void WindowCreate(ref Window window, WindowPlatformVars* windowVars) {
	// code to create the window
	windowVars.destroy_called = false;

	X.XSetWindowAttributes attributes;

	if (window.style == WindowStyle.Popup) {
		attributes.override_redirect = X.Bool.True;
	}

	attributes.event_mask =	X.EventMask.ExposureMask | X.EventMask.ButtonPressMask | X.EventMask.KeyPressMask |
		X.EventMask.ButtonReleaseMask | X.EventMask.PointerMotionMask | X.EventMask.KeyReleaseMask | X.EventMask.StructureNotifyMask |
		X.EventMask.EnterWindowMask | X.EventMask.LeaveWindowMask | X.EventMask.FocusChangeMask;
	attributes.win_gravity = X.BitGravity.StaticGravity;

	X.Window parent = X.XRootWindow(_pfvars.display, _pfvars.screen);

	uint w_x = window.x;
	uint w_y = window.y;

	if (window.position == WindowPosition.Center) {
		// Get the display width and height and center the window
		uint d_width = X.XDisplayWidth(_pfvars.display, _pfvars.screen);
		uint d_height = X.XDisplayHeight(_pfvars.display, _pfvars.screen);

		w_x = d_width - window.width;
		w_x >>= 1;

		w_y = d_height - window.height;
		w_y >>= 1;

	}

	windowVars.window = X.XCreateWindow(_pfvars.display,
		parent, w_x,w_y,window.width,window.height,0,
		X.CopyFromParent,
		X.WindowClass.InputOutput,
		cast(X.Visual*)X.CopyFromParent,
		X.WindowAttribute.CWOverrideRedirect | X.WindowAttribute.CWEventMask | X.WindowAttribute.CWWinGravity,
		&attributes);

	X.Window root;
	X.Window* children;
	uint childrenCount;
	X.Window last = windowVars.window;

	X.Status r = X.XSetWMProtocols(_pfvars.display, windowVars.window, &_pfvars.wm_destroy_window, 1);

	WindowRebound(window, windowVars);

	WindowSetTitle(window, windowVars);

	if (window.visible) {
		WindowSetVisible(window, windowVars, true);
	}

//	int x_return, y_return, width_return, height_return, grav_return;
//	X.XSizeHints hints;
//	X.XWMGeometry(_pfvars.display, _pfvars.screen, null, null, &hints, &x_return, &y_return, &width_return, &height_return, &grav_return);
	if (window.position != WindowPosition.Default) {
		X.XMoveWindow(_pfvars.display, windowVars.window, w_x, w_y);
	}
//	X.XMoveWindow(_pfvars.display, windowVars.wm_parent, window.x, window.y);

	X.XQueryTree(_pfvars.display, windowVars.window, &root, &windowVars.wm_parent, &children, &childrenCount);
	X.XFree(children);
	printf("ROOT: %d, PARENT: %d\n", root, windowVars.wm_parent);

	// Create View
	window.onInitialize();

	// Run Add
	window.onAdd();
}

void WindowCreate(ref Window parent, WindowPlatformVars* parentHelper, ref Window window, WindowPlatformVars* windowVars) {
	// code to create a child window
	//int screen;

	WindowCreate(window, windowVars);
	return;
}

void WindowSetStyle(ref Window window, WindowPlatformVars* windowVars) {
	// code to change the style of a window
}

void WindowReposition(ref Window window, WindowPlatformVars* windowVars) {
	// code to move a window
	X.Window wind = windowVars.window;
	if (windowVars.wm_parent != 0) {
		wind = windowVars.wm_parent;
	}
	X.XMoveWindow(_pfvars.display, wind, window.x, window.y);
}

void WindowSetState(ref Window window, WindowPlatformVars* windowVars) {
	// code to change the state of a window
}

void WindowRebound(ref Window window, WindowPlatformVars* windowVars) {
	// code to Size a window
	int width, height;
	width = window.width;
	height = window.height;

	MWMHints mwmhints;

	X.XSizeHints* xhints;

	X.Atom wm_normal_hints = X.XInternAtom(_pfvars.display, "WM_NORMAL_HINTS\0"c.ptr, X.Bool.True);
	if (window.style == WindowStyle.Popup) {

		X.Atom prop = X.XInternAtom(_pfvars.display, "_MOTIF_WM_HINTS\0"c.ptr, X.Bool.True);
		if (prop != X.None) {
			//set with MWM
			mwmhints.flags = MWM_HINTS_DECORATIONS;
			mwmhints.functions = MWM_FUNC_MOVE;
			mwmhints.decorations = 0;

			X.XChangeProperty(_pfvars.display, windowVars.window, prop, prop, 32, X.PropertyMode.PropModeReplace,
                    cast(ubyte*)&mwmhints, PROP_MWM_HINTS_ELEMENTS);
		}

		//set with WM_NORMAL_HINTS (disable Size function)
		xhints = X.XAllocSizeHints();

		xhints.flags = PMinSize | PMaxSize | PResizeInc;
		xhints.width_inc = 0;
		xhints.height_inc = 0;
		xhints.max_width = xhints.min_width = width;
		xhints.max_height = xhints.min_height = height;

		X.XSetWMNormalHints(_pfvars.display, windowVars.window, xhints);

		X.XFree(xhints);

	}
	else if (window.style == WindowStyle.Fixed) {
		X.Atom prop = X.XInternAtom(_pfvars.display, "_MOTIF_WM_HINTS\0"c.ptr, X.Bool.True);

		if (prop != X.None) {
			//set with MWM
			mwmhints.flags = MWM_HINTS_FUNCTIONS | MWM_HINTS_DECORATIONS;
			mwmhints.functions = MWM_FUNC_MINIMIZE | MWM_FUNC_CLOSE | MWM_FUNC_MOVE;
			mwmhints.decorations = MWM_DECOR_BORDER | MWM_DECOR_TITLE | MWM_DECOR_MENU | MWM_DECOR_MAXIMIZE;

			X.XChangeProperty(_pfvars.display, windowVars.window, prop, prop, 32, X.PropertyMode.PropModeReplace,
                    cast(ubyte*)&mwmhints, PROP_MWM_HINTS_ELEMENTS);
		}

		//set with WM_NORMAL_HINTS (disable Size function)
		xhints = X.XAllocSizeHints();

		xhints.flags = PMinSize | PMaxSize | PResizeInc;
		xhints.width_inc = 0;
		xhints.height_inc = 0;
		xhints.max_width = xhints.min_width = width;
		xhints.max_height = xhints.min_height = height;

		X.XSetWMNormalHints(_pfvars.display, windowVars.window, xhints);

		X.XFree(xhints);

	}
}

void WindowDestroy(ref Window window, WindowPlatformVars* windowVars) {
	// code to destroy a window
	windowVars.destroy_called = true;

	//destroy window
	X.XDestroyWindow(_pfvars.display, windowVars.window);
}

void WindowSetVisible(ref Window window, WindowPlatformVars* windowVars, bool bShow) {
	// code to show or hide a window
	if (bShow) {
		X.XMapWindow(_pfvars.display, windowVars.window);
	}
	else {
		X.XUnmapWindow(_pfvars.display, windowVars.window);
	}
}

void WindowSetTitle(ref Window window, WindowPlatformVars* windowVars) {
	// code to change a window's title

	//Set the window's text

	//Fill in a text property

	String str = new String(window.text);
	str.appendChar('\0');

	// Alternative Syntax:

	/*

	X.XTextProperty tprop;

	tprop.value = str.ptr;
	tprop.encoding = _pfvars.utf8string;
	tprop.format = 8;
	tprop.nitems = str.array.length-1;

	X.XSetTextProperty(_pfvars.display, windowVars.window, &tprop, _pfvars.wm_name);

	*/

	// Update the Property:

	X.XChangeProperty(_pfvars.display, windowVars.window,
			X.XInternAtom(_pfvars.display, "_NET_WM_NAME", X.Bool.False),
			X.XInternAtom(_pfvars.display, "UTF8_STRING", X.Bool.False),
			8, X.PropertyMode.PropModeReplace, cast(ubyte*)str.ptr, str.array.length-1);

	X.XChangeProperty(_pfvars.display, windowVars.window,
			X.XInternAtom(_pfvars.display, "_NET_WM_ICON_NAME", X.Bool.False),
			X.XInternAtom(_pfvars.display, "UTF8_STRING", X.Bool.False),
			8, X.PropertyMode.PropModeReplace, cast(ubyte*)str.ptr, str.array.length-1);

}

// CLIENT TO SCREEN

// Takes a point on the window's client area and returns the actual screen
// coordinates for that point.

void WindowClientToScreen(ref Window window, WindowPlatformVars* windowVars, ref int x, ref int y) {
	//Coord pt = {x,y};
	//ClientToScreen(windowVars.hWnd, &pt);
	Window wret;

	X.XTranslateCoordinates(_pfvars.display, windowVars.window,
		X.RootWindow(_pfvars.display, _pfvars.screen), x,y, &x, &y,cast(Culong*)&wret);
}

void WindowClientToScreen(ref Window window, WindowPlatformVars* windowVars, ref Coord pt) {
	//ClientToScreen(windowVars.hWnd, &pt);
	Window wret;

	X.XTranslateCoordinates(_pfvars.display, windowVars.window,
		X.RootWindow(_pfvars.display, _pfvars.screen), pt.x, pt.y, &pt.x, &pt.y, cast(Culong*)&wret);
}

void WindowClientToScreen(ref Window window, WindowPlatformVars* windowVars, ref Rect rt) {
}


// Viewable windows
void WindowStartDraw(ref Window window, WindowPlatformVars* windowVars, ref WindowView view, ref ViewPlatformVars viewVars) {
	// code executed at the start of a redraw for a window

	// should establish a white brush and a black pen

	//Set initial Pen and Brush
	//window->_initial_color = 0xFF;

	X.XSetForeground(_pfvars.display, viewVars.gc, ColorGetValue(window.color));
	X.XSetBackground(_pfvars.display, viewVars.gc, ColorGetValue(window.color));

	//Fill background

	X.XFillRectangle(_pfvars.display, viewVars.pixmap,
		viewVars.gc,
		0,0,window.width, window.height);

	viewVars.textclr_red = 0.0;
	viewVars.textclr_green = 0.0;
	viewVars.textclr_blue = 0.0;

	viewVars.isOpaqueRendering = 0;
}

void WindowEndDraw(ref Window window, WindowPlatformVars* windowVars, ref WindowView view, ref ViewPlatformVars viewVars) {
	// code to reclaim resources, and executed after all components have drawn to the window

	//copy over area
	X.XFlush(_pfvars.display);

	X.XCopyArea(_pfvars.display, viewVars.pixmap,
		windowVars.window, viewVars.gc,
		0, 0, window.width, window.height, 0, 0);
}

void WindowCaptureMouse(ref Window window, WindowPlatformVars* windowVars) {
	// capture the mouse
}

void WindowReleaseMouse(ref Window window, WindowPlatformVars* windowVars) {
	// release the mouse
}
