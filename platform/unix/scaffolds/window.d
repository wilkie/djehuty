module platform.unix.scaffolds.window;

import platform.unix.vars;
import platform.unix.common;

import core.view;
import core.graphics;
import core.color;

import core.basewindow;
import core.window;
import platform.unix.main;
import core.string;
import core.file;

import core.main;

import core.definitions;

import console.main;




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
void WindowCreate(ref BaseWindow window, WindowPlatformVars* windowVars)
{
	// code to create the window
	windowVars.destroy_called = false;

	X.XSetWindowAttributes attributes;

	if (window.getStyle() == WindowStyle.Popup)
	{
		attributes.override_redirect = X.Bool.True;
	}

	X.Window parent = X.XRootWindow(_pfvars.display, _pfvars.screen);

	windowVars.window = X.XCreateWindow(_pfvars.display,
		parent, window.getX(),window.getY(),window.getWidth(),window.getHeight(),0,
		X.CopyFromParent,
		X.WindowClass.InputOutput,
		cast(X.Visual*)X.CopyFromParent,
		X.WindowAttribute.CWOverrideRedirect,
		&attributes);

	X.Window last = windowVars.window;

	X.XSelectInput(_pfvars.display, windowVars.window, X.EventMask.ExposureMask | X.EventMask.ButtonPressMask | X.EventMask.KeyPressMask |
		X.EventMask.ButtonReleaseMask | X.EventMask.PointerMotionMask | X.EventMask.KeyReleaseMask | X.EventMask.StructureNotifyMask |
		X.EventMask.EnterWindowMask | X.EventMask.LeaveWindowMask | X.EventMask.FocusChangeMask );

	X.Status r = X.XSetWMProtocols(_pfvars.display, windowVars.window, &_pfvars.wm_destroy_window, 1);

	WindowRebound(window, windowVars);

	WindowSetTitle(window, windowVars);

	X.XChangeWindowAttributes(_pfvars.display, windowVars.window, X.WindowAttribute.CWOverrideRedirect, &attributes);

	X.XMoveWindow(_pfvars.display, windowVars.window, window.getX(), window.getY());

	if (window.getVisibility())
	{
		WindowSetVisible(window, windowVars, true);
	}

	X.XMoveWindow(_pfvars.display, windowVars.window, window.getX(), window.getY());

	// Create View
	window.OnInitialize();

	// Run Add
	window.OnAdd();
}

void WindowCreate(ref BaseWindow parent, WindowPlatformVars* parentVars, ref BaseWindow window, ref WindowPlatformVars windowVars)
{
	// code to create a child window
	//int screen;

	WindowCreate(window, &windowVars);
	return;
}

void WindowSetStyle(ref BaseWindow window, WindowPlatformVars* windowVars)
{
	// code to change the style of a window
}

void WindowReposition(ref BaseWindow window, WindowPlatformVars* windowVars)
{
	// code to move a window
}

void WindowSetState(ref BaseWindow window, WindowPlatformVars* windowVars)
{
	// code to change the state of a window
}

void WindowRebound(ref BaseWindow window, WindowPlatformVars* windowVars)
{
	// code to Size a window
	int width, height;
	width = window.getWidth();
	height = window.getHeight();

	MWMHints mwmhints;

	X.XSizeHints* xhints;

	X.Atom wm_normal_hints = X.XInternAtom(_pfvars.display, "WM_NORMAL_HINTS\0"c.ptr, X.Bool.True);
	if (window.getStyle() == WindowStyle.Popup)
	{

		X.Atom prop = X.XInternAtom(_pfvars.display, "_MOTIF_WM_HINTS\0"c.ptr, X.Bool.True);
		if (prop != X.None)
		{
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
	else if (window.getStyle() == WindowStyle.Fixed)
	{
		X.Atom prop = X.XInternAtom(_pfvars.display, "_MOTIF_WM_HINTS\0"c.ptr, X.Bool.True);

		if (prop != X.None)
		{
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

void WindowDestroy(ref BaseWindow window, WindowPlatformVars* windowVars)
{
	// code to destroy a window
	windowVars.destroy_called = true;

	//destroy window
	X.XDestroyWindow(_pfvars.display, windowVars.window);
}

void WindowSetVisible(ref BaseWindow window, WindowPlatformVars* windowVars, bool bShow)
{
	// code to show or hide a window
	if (bShow)
	{
		X.XMapWindow(_pfvars.display, windowVars.window);
	}
	else
	{
		X.XUnmapWindow(_pfvars.display, windowVars.window);
	}
}

void WindowSetTitle(ref BaseWindow window, WindowPlatformVars* windowVars)
{
	// code to change a window's title

	//Set the window's text

	//Fill in a text property

	String str = new String(window.getText());
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

void WindowClientToScreen(ref BaseWindow window, WindowPlatformVars* windowVars, ref int x, ref int y)
{
	//Coord pt = {x,y};
	//ClientToScreen(windowVars.hWnd, &pt);
	Window wret;
	X.XTranslateCoordinates(_pfvars.display, windowVars.window,
		X.RootWindow(_pfvars.display, _pfvars.screen), x,y, &x, &y,cast(Culong*)&wret);
}

void WindowClientToScreen(ref BaseWindow window, WindowPlatformVars* windowVars, ref Coord pt)
{
	//ClientToScreen(windowVars.hWnd, &pt);
	Window wret;
	X.XTranslateCoordinates(_pfvars.display, windowVars.window,
		X.RootWindow(_pfvars.display, _pfvars.screen), pt.x, pt.y, &pt.x, &pt.y, cast(Culong*)&wret);
}

void WindowClientToScreen(ref BaseWindow window, WindowPlatformVars* windowVars, ref Rect rt)
{
}





// Viewable windows
void WindowStartDraw(ref Window window, WindowPlatformVars* windowVars, ref View view, ref ViewPlatformVars viewVars)
{
	// code executed at the start of a redraw for a window

	// should establish a white brush and a black pen

	//Set initial Pen and Brush
	//window->_initial_color = 0xFF;

	X.XSetForeground(_pfvars.display, viewVars.gc, ColorGetValue(window.getColor()));
	X.XSetBackground(_pfvars.display, viewVars.gc, ColorGetValue(window.getColor()));

	//Fill background

	X.XFillRectangle(_pfvars.display, viewVars.pixmap,
		viewVars.gc,
		0,0,window.getWidth(), window.getHeight());

	viewVars.textclr_red = 0.0;
	viewVars.textclr_green = 0.0;
	viewVars.textclr_blue = 0.0;

	viewVars.isOpaqueRendering = 0;
}

void WindowEndDraw(ref Window window, WindowPlatformVars* windowVars, ref View view, ref ViewPlatformVars viewVars)
{
	// code to reclaim resources, and executed after all components have drawn to the window

	//copy over area
	X.XFlush(_pfvars.display);

	X.XCopyArea(_pfvars.display, viewVars.pixmap,
		windowVars.window, viewVars.gc,
		0, 0, window.getWidth(), window.getHeight(), 0, 0);
}

void WindowCaptureMouse(ref Window window, WindowPlatformVars* windowVars)
{
	// capture the mouse
}

void WindowReleaseMouse(ref Window window, WindowPlatformVars* windowVars)
{
	// release the mouse
}


