/*
 * window.d
 *
 * This file implements the Scaffold for platform specific Window
 * operations in Windows.
 *
 * Author: Dave Wilkinson
 *
 */

module scaffold.window;

import scaffold.system;

import binding.win32.windef;
import binding.win32.winnt;
import binding.win32.winbase;
import binding.win32.wingdi;
import binding.win32.winuser;

import Gdiplus = binding.win32.gdiplus;

import platform.win.main;

import platform.vars.window;
import platform.vars.view;

import graphics.view;

import core.color;
import core.string;
import core.main;
import core.definitions;
import core.unicode;

import gui.window;

import synch.thread;

import io.console;

void GuiNextEvent(Event* evt, WindowPlatformVars* vars) {
	MSG msg;

	vars.event = evt;

	auto ret = GetMessageW(&msg, vars.hWnd, 0, 0);
	TranslateMessage(&msg);
	DispatchMessageW(&msg);
}

extern(Windows)
static int WindowProc(HWND hWnd, uint uMsg, WPARAM wParam, LPARAM lParam) {

	static const int WM_MOUSECAPTURE = 0xffff;

	// resolve the window class reference:
	void* wind_in = cast(void*)GetWindowLongW(hWnd, GWLP_USERDATA);
	WindowPlatformVars* windowVars = cast(WindowPlatformVars*)(wind_in);

	int ret = IsWindowUnicode(windowVars.hWnd);

	switch (uMsg) {
		case WM_ERASEBKGND:
			break;

		case WM_PAINT:
			break;

	    case WM_DESTROY:
			break;

	/* FOCUS */

		case WM_ACTIVATE:
			int x, y;
			//activation type
			x = wParam & 0xffff;
			//minimization status
			y = (wParam >> 16) & 0xffff;

			if (x == WA_INACTIVE) {
				//losing focus
			}
			else if (x == WA_ACTIVE || x == WA_CLICKACTIVE) {
				//gaining focus
			}

			if (y != 0) {
				//minimized
			}
			break;

		case WM_INPUT:
			break;

		case WM_CAPTURECHANGED:
			break;

		case WM_LBUTTONDOWN:

			SetFocus(hWnd);
			SetCapture(hWnd);

			//uint lp = GetMessageExtraInfo();
			//if ((lp & SIGNATURE_MASK) == MI_WP_SIGNATURE) {
				//writefln("pen");
			//}

			//writefln("down : ", lp, " ... ", lp & SIGNATURE_MASK, " == ", MI_WP_SIGNATURE);

			// FILL THE MOUSEPROPERTIES STRUCTURE FOR THE WINDOW

			//w.mouseProps.rightDown = 1;

			//check bounds for the controls

			int x, y;
			x = lParam & 0xffff;
//			w.mouseProps.x = x;
			y = (lParam >> 16) & 0xffff;
//			w.mouseProps.y = y;

//			w.mouseProps.leftDown = true;
//			w.mouseProps.rightDown = ((wParam & MK_RBUTTON) > 0);
//			w.mouseProps.middleDown = ((wParam & MK_MBUTTON) > 0);

//			_TestNumberOfClicks(w,windowVars,x,y,1);

//			w.onPrimaryMouseDown();
			break;

		case WM_LBUTTONUP:

			ReleaseCapture();

			//window.mouseProps.rightDown = 0;

			//check for double click first
//			_TestNumberOfClicksUp(w,windowVars,1);

			//fill _mouseProps
			int x, y;
			x = lParam & 0xffff;
//			w.mouseProps.x = x;
			y = (lParam >> 16) & 0xffff;
//			w.mouseProps.y = y;

//			w.mouseProps.leftDown = false;
//			w.mouseProps.rightDown = ((wParam & MK_RBUTTON) > 0);
//			w.mouseProps.middleDown = ((wParam & MK_MBUTTON) > 0);

//			w.onPrimaryMouseUp();
			break;

		case WM_RBUTTONDOWN:

			SetFocus(hWnd);
			SetCapture(hWnd);

			// FILL THE MOUSEPROPERTIES STRUCTURE FOR THE WINDOW

			//w.mouseProps.rightDown = 1;

			//check bounds for the controls

			int x, y;
			x = lParam & 0xffff;
//			w.mouseProps.x = x;
			y = (lParam >> 16) & 0xffff;
//			w.mouseProps.y = y;

//			w.mouseProps.leftDown = ((wParam & MK_LBUTTON) > 0);
//			w.mouseProps.rightDown = true;
//			w.mouseProps.middleDown = ((wParam & MK_MBUTTON) > 0);

//			_TestNumberOfClicks(w,windowVars,x,y,2);

//			w.onSecondaryMouseDown();
			break;

		case WM_RBUTTONUP:

			ReleaseCapture();
			//window.mouseProps.rightDown = 0;

			//check for double click first
//			_TestNumberOfClicksUp(w,windowVars,2);

			//fill _mouseProps
			int x, y;
			x = lParam & 0xffff;
//			w.mouseProps.x = x;
			y = (lParam >> 16) & 0xffff;
//			w.mouseProps.y = y;

//			w.mouseProps.leftDown = ((wParam & MK_LBUTTON) > 0);
//			w.mouseProps.rightDown = false;
//			w.mouseProps.middleDown = ((wParam & MK_MBUTTON) > 0);

//			w.onSecondaryMouseUp();
			break;

		case WM_MBUTTONDOWN:

			SetFocus(hWnd);
			SetCapture(hWnd);

			// FILL THE MOUSEPROPERTIES STRUCTURE FOR THE WINDOW

			//w.mouseProps.rightDown = 1;

			//check bounds for the controls

			int x, y;
			x = lParam & 0xffff;
//			w.mouseProps.x = x;
			y = (lParam >> 16) & 0xffff;
//			w.mouseProps.y = y;

//			w.mouseProps.leftDown = ((wParam & MK_LBUTTON) > 0);
//			w.mouseProps.rightDown = ((wParam & MK_RBUTTON) > 0);
//			w.mouseProps.middleDown = true;

//			_TestNumberOfClicks(w,windowVars,x,y,3);

//			w.onTertiaryMouseDown();
			break;

		case WM_MBUTTONUP:

			ReleaseCapture();
			//window.mouseProps.rightDown = 0;

			//check for double click first

//			_TestNumberOfClicksUp(w,windowVars,3);

			//fill _mouseProps
			int x, y;
			x = lParam & 0xffff;
//			w.mouseProps.x = x;
			y = (lParam >> 16) & 0xffff;
//			w.mouseProps.y = y;

//			w.mouseProps.leftDown = ((wParam & MK_LBUTTON) > 0);
//			w.mouseProps.rightDown = ((wParam & MK_RBUTTON) > 0);
//			w.mouseProps.middleDown = false;

//			w.onTertiaryMouseUp();
			break;

		case WM_XBUTTONDOWN:

			SetFocus(hWnd);
			SetCapture(hWnd);

			// FILL THE MOUSEPROPERTIES STRUCTURE FOR THE WINDOW

			//w.mouseProps.rightDown = 1;

			//check bounds for the controls

			int x, y;
			x = lParam & 0xffff;
//			w.mouseProps.x = x;
			y = (lParam >> 16) & 0xffff;
//			w.mouseProps.y = y;

			wParam >>= 16;
			if (wParam) {
				wParam--;

//				_TestNumberOfClicks(w,windowVars,x,y,4 + cast(uint)wParam);

//				w.onOtherMouseDown(cast(uint)wParam);
			}
			break;

		case WM_XBUTTONUP:

			ReleaseCapture();
			//window.mouseProps.rightDown = 0;

			//fill _mouseProps
			int x, y;
			x = lParam & 0xffff;
//			w.mouseProps.x = x;
			y = (lParam >> 16) & 0xffff;
//			w.mouseProps.y = y;

			wParam >>= 16;
			if (wParam) {
				wParam--;

				//check for double click
//				_TestNumberOfClicksUp(w,windowVars,4 + cast(uint)wParam);

//				w.onOtherMouseUp(cast(uint)wParam);
			}
			break;

		case WM_MOUSEHWHEEL:

//			w.onMouseWheelX(0);
			break;

		case WM_MOUSEWHEEL:

//			w.onMouseWheelY(0);
			break;

		case WM_MOUSEMOVE:

			int x, y;
			x = lParam & 0xffff;
//			w.mouseProps.x = x;
			y = (lParam >> 16) & 0xffff;
//			w.mouseProps.y = y;
		//	Console.putln("mouse move window! x:", x, "y:", y);

//			w.mouseProps.leftDown = ((wParam & MK_LBUTTON) > 0);
//			w.mouseProps.rightDown = ((wParam & MK_RBUTTON) > 0);
//			w.mouseProps.middleDown = ((wParam & MK_MBUTTON) > 0);

			if (windowVars.hoverTimerSet==0) {
				SetTimer(hWnd, 0, 55, null);
				windowVars.hoverTimerSet = 1;
			}

//			w.onMouseMove();
			break;

			// Internal Timing Functions
		case WM_MOUSELEAVE:
//			w.onMouseLeave();
			break;

		case WM_MOUSECAPTURE: //made up event
			if (windowVars.hoverTimerSet == 1) {
				KillTimer(hWnd, 0);
//				windowVars.hoverTimerSet = 0;
			}

			SetCapture(hWnd);
			break;

		case WM_MOVE:

			RECT rt;
			GetWindowRect(hWnd, &rt);

			if (!windowVars.supress_WM_MOVE) {
//				w._x = rt.left;
//				w._y = rt.top;

//				w.onMove();
				windowVars.supress_WM_MOVE = false;
			}
			break;

		case WM_KEYDOWN:

			Key key;
			key.code = cast(uint)wParam;
//			w.onKeyDown(key);

			break;

			//might have to translate these keys

		case WM_CHAR:

			if ((wParam == Key.Backspace)
				|| (wParam == Key.Return)
				|| (wParam == Key.Tab)) {
				break;
			}

			ushort stuff[2] = (cast(ushort*)&wParam)[0 .. 2];

			//printf("%x %x", stuff[0], stuff[1]);

//			w.onKeyChar(cast(dchar)wParam);

			break;

		case WM_DEADCHAR:

			ushort stuff[2] = (cast(ushort*)&wParam)[0 .. 2];

			//printf("%x %x", stuff[0], stuff[1]);

			break;

		case WM_UNICHAR:

			if (wParam == 0xFFFF) {
				return 1;
			}

			ushort stuff[2] = (cast(ushort*)&wParam)[0 .. 2];

			//printf("%x %x", stuff[0], stuff[1]);

//			w.onKeyChar(cast(dchar)wParam);

			break;

		case WM_KEYUP:

			Key key;
			key.code = cast(uint)wParam;
//			w.onKeyUp(key);

			break;

		case WM_SIZE:

			RECT rt;
			GetClientRect(hWnd, &rt);

			if (!windowVars.supress_WM_SIZE) {
//				w._width = rt.right;
//				w._height = rt.bottom;

//				w.onResize();

//				if (cast(GLWindow)w !is null) {
//					windowVars.gameLoopCallResize();
//				}

				windowVars.supress_WM_SIZE = false;
			}

			// was it minimized? maximized?

//			if (w.state != WindowState.Fullscreen) {
//				if (wParam == SIZE_MAXIMIZED && w.state != WindowState.Minimized) {
//					if (!windowVars.supress_WM_SIZE_state) {
//						w.state = WindowState.Maximized;
//						w.onStateChange();
//						windowVars.supress_WM_SIZE_state = false;
//					}
//				}
//				else if (wParam == SIZE_MINIMIZED && w.state != WindowState.Maximized) {
//					if (!windowVars.supress_WM_SIZE_state) {
//						w.state = WindowState.Minimized;
//						w.onStateChange();
//						windowVars.supress_WM_SIZE_state = false;
//					}
//				}
//				else if (wParam == SIZE_RESTORED && w.state != WindowState.Normal) {
//					if (!windowVars.supress_WM_SIZE_state) {
//						w.state = WindowState.Normal;
//						w.onStateChange();
//						windowVars.supress_WM_SIZE_state = false;
//					}
//				}
//			}

			break;

		case WM_TIMER:

			if (wParam == 0) {
				//Internal Timer (mouse hover)

				POINT pt;

				GetCursorPos(&pt);

				if (WindowFromPoint(pt) != hWnd) {
					KillTimer(hWnd, 0);
					windowVars.hoverTimerSet = 0;

					SendMessageW(hWnd, WM_MOUSELEAVE, 0,0);
				}
				else {
					POINT pnt[2];

					pnt[0].x = 0;
					pnt[0].y = 0;
//					pnt[1].x = w.width-1;
//					pnt[1].y = w.height-1;

					ClientToScreen(hWnd, &pnt[0]);
					ClientToScreen(hWnd, &pnt[1]);

					if (pt.x < pnt[0].x || pt.y < pnt[0].y || pt.x > pnt[1].x || pt.y > pnt[1].y) {
						KillTimer(hWnd,0);

						windowVars.hoverTimerSet = 0;

						SendMessageW(hWnd, WM_MOUSELEAVE, 0, 0);
					}
				}
				//KillTimer(hWnd, 0);
			}
			else if (wParam == 1) {
				//Internal Timer (double click test)
				//kill the timer
				windowVars.doubleClickTimerSet = -windowVars.doubleClickTimerSet;
				KillTimer(hWnd, 1);
			}

			break;

		default:

			return DefWindowProcW(hWnd, uMsg, wParam, lParam);
	}

	return 0;
}

// all windows
void WindowCreate(ref Window window, WindowPlatformVars* windowVars) {
	int width = cast(int)window.width;
	int height = cast(int)window.height;

	int x = cast(int)window.left;
	int y = cast(int)window.top;

	void* userData = cast(void*)windowVars;

	while(windowVars.hWnd is null) {
		windowVars.hWnd = CreateWindowExW(0, "djehutyApp\0"w.ptr, "\0"w.ptr, cast(DWORD)(WS_POPUP | WS_CLIPSIBLINGS),
			x, y, width, height, null,
			cast(HMENU) null, null, userData);
	}
}

void WindowCreate(ref Window parent, WindowPlatformVars* windowVars, ref Window window, WindowPlatformVars* parentVars) {
}

void WindowSetStyle(ref Window window, WindowPlatformVars* windowVars) {
}

void WindowReposition(ref Window window, WindowPlatformVars* windowVars) {
	SetWindowPos(windowVars.hWnd, null, cast(int)window.left, cast(int)window.top, 0, 0, SWP_NOSIZE | SWP_NOOWNERZORDER | SWP_NOZORDER);
}

void WindowSetState(ref Window window, WindowPlatformVars* windowVars) {

}

void WindowRebound(ref Window window, WindowPlatformVars* windowVars) {
	int width, height;

	width = cast(int)window.width;
	height = cast(int)window.height;

	windowVars.supress_WM_SIZE = true;
	SetWindowPos(windowVars.hWnd, null, 0,0, width, height, SWP_NOMOVE | SWP_NOOWNERZORDER);
}

void WindowDestroy(ref Window window, WindowPlatformVars* windowVars) {
	PostMessageW(windowVars.hWnd, WM_CLOSE, 0, 0);
}

void WindowSetVisible(ref Window window, WindowPlatformVars* windowVars, bool bShow) {
	if (bShow) {
		ShowWindow(windowVars.hWnd, SW_SHOW);
	}
	else {
		ShowWindow(windowVars.hWnd, SW_HIDE);
	}
}

void WindowSetTitle(ref Window window, WindowPlatformVars* windowVars) {
}

// CLIENT TO SCREEN

// Takes a point on the window's client area and returns the actual screen
// coordinates for that point.

void WindowClientToScreen(ref Window window, WindowPlatformVars* windowVars, ref double x, ref double y) {
	Coord pt = {x,y};
	POINT ptx;
	ptx.x = 0;
	ptx.y = 0;
	ClientToScreen(windowVars.hWnd, &ptx);
	x += cast(double)ptx.x;
	y += cast(double)ptx.y;
}

void WindowClientToScreen(ref Window window, WindowPlatformVars* windowVars, ref Coord pt) {
	WindowClientToScreen(window, windowVars, pt.x, pt.y);
}

void WindowClientToScreen(ref Window window, WindowPlatformVars* windowVars, ref Rect rt) {
	WindowClientToScreen(window, windowVars, rt.left, rt.top);
	WindowClientToScreen(window, windowVars, rt.right, rt.bottom);
}


// Viewable windows
void WindowStartDraw(ref Window window, WindowPlatformVars* windowVars, ref View view, ref ViewPlatformVars viewVars) {
	//the starting pen and brush is black and white respectively
	if (viewVars.aa) {
		Gdiplus.GdipSetSmoothingMode(viewVars.g, Gdiplus.SmoothingMode.SmoothingModeAntiAlias);
	}
	else {
		Gdiplus.GdipSetSmoothingMode(viewVars.g, Gdiplus.SmoothingMode.SmoothingModeDefault);
	}
}

void WindowEndDraw(ref Window window, WindowPlatformVars* windowVars, ref View view, ref ViewPlatformVars viewVars) {
	HDC hdc;
	hdc = GetDC(windowVars.hWnd);
//	Gdiplus.GpGraphics* g;
//	Gdiplus.GdipCreateFromHDC(hdc, &g);
//	Gdiplus.GdipDrawImageI(g, viewVars.image, 0, 0);

	BitBlt(hdc, 0, 0, cast(int)window.width, cast(int)window.height, viewVars.dc, 0, 0, SRCCOPY);

	ReleaseDC(windowVars.hWnd, hdc);
}

void WindowCaptureMouse(ref Window window, WindowPlatformVars* windowVars) {
	const int WM_MOUSECAPTURE = 0xffff;

	SendMessageW(windowVars.hWnd, WM_MOUSECAPTURE, 0, 0);
}

void WindowReleaseMouse(ref Window window, WindowPlatformVars* windowVars) {
	ReleaseCapture();
}