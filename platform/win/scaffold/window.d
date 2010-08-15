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

import opengl.window;

import synch.thread;

import io.console;

// all windows
void WindowCreate(ref Window window, WindowPlatformVars* windowVars) {
	windowVars.oldWidth = window.width;
	windowVars.oldHeight = window.height;

	windowVars.oldX = window.x;
	windowVars.oldY = window.y;

	windowVars.oldTitle = window.text;

	windowVars.userData = cast(void*)window;

	_ClientSizeToWindowSize(window, windowVars.oldWidth, windowVars.oldHeight);

	_GatherStyleInformation(window, windowVars.istyle, windowVars.iexstyle);

	windowVars.windowClass = window;

	if (cast(GLWindow)window !is null) {
		windowVars.msgThread = new Thread(&windowVars.gameLoop);
	}
	else {
		windowVars.msgThread = new Thread(&windowVars.msgLoop);
	}

	ThreadSetWindow(windowVars.msgThread, window);

	windowVars.msgThread.start();

	RAWINPUTDEVICE Rid;

	Rid.usUsagePage = 0x01;
	Rid.usUsage = 0x02;
	Rid.dwFlags = RIDEV_INPUTSINK;
	Rid.hwndTarget = windowVars.hWnd;

	RegisterRawInputDevices(&Rid, 1, Rid.sizeof);
}

void WindowCreate(ref Window parent, WindowPlatformVars* windowVars, ref Window window, WindowPlatformVars* parentVars) {
	/*
	int width, height, x, y;

	width = window.width();
	height = window.height();

	x = window.getX();
	y = window.getY();

	width = window.width();
	height = window.height();

	_ClientSizeToWindowSize(window, width, height);

	uint istyle;
	uint iexstyle;

	_GatherStyleInformation(window, istyle, iexstyle);

	windowVars.hWnd = CreateWindowExW(iexstyle, djehutyClassName.ptr,window.getText().ptr, istyle | WS_VISIBLE | WS_CLIPCHILDREN | WS_CLIPSIBLINGS,
		x, y, width, height, parentVars.hWnd,
		cast(HMENU) null, null, cast(void*)window);

	assert(windowVars.hWnd);

	RAWINPUTDEVICE Rid;

	Rid.usUsagePage = 0x01;
	Rid.usUsage = 0x02;
	Rid.dwFlags = RIDEV_INPUTSINK;
	Rid.hwndTarget = windowVars.hWnd;

	RegisterRawInputDevices(&Rid, 1, Rid.sizeof);
	*/
}

void WindowSetStyle(ref Window window, WindowPlatformVars* windowVars) {
	bool wasMaximized = false;

	if (window.state == WindowState.Maximized) {
		ShowWindow(windowVars.hWnd, SW_HIDE);
		wasMaximized = true;
		window.state = WindowState.Normal;
	}

	int width, height;

	width = window.width;
	height = window.height;

	_ClientSizeToWindowSize(window, width, height);

	uint istyle;
	uint iexstyle;

	_GatherStyleInformation(window, istyle, iexstyle);

	SetWindowLongW(windowVars.hWnd, GWL_STYLE, istyle);
	SetWindowLongW(windowVars.hWnd, GWL_EXSTYLE, iexstyle);

	windowVars.supress_WM_MOVE = true;
	SetWindowPos(windowVars.hWnd, null, 0,0, width, height, SWP_NOMOVE | SWP_NOOWNERZORDER | SWP_NOZORDER);
	windowVars.supress_WM_MOVE = false;

	if (wasMaximized) {
		window.state = WindowState.Maximized;

		if (window.visible) {
			ShowWindow(windowVars.hWnd, SW_SHOW);
		}
	}
}

void WindowReposition(ref Window window, WindowPlatformVars* windowVars) {
	SetWindowPos(windowVars.hWnd, null, window.x,window.y, 0, 0, SWP_NOSIZE | SWP_NOOWNERZORDER | SWP_NOZORDER);
}

void WindowSetState(ref Window window, WindowPlatformVars* windowVars) {
	if (window.state == WindowState.Fullscreen) {
		windowVars.oldX = window.x;
		windowVars.oldY = window.y;

		windowVars.oldWidth = window.width;
		windowVars.oldHeight = window.height;

		windowVars.supress_WM_MOVE = true;
		windowVars.supress_WM_SIZE = true;

		windowVars.oldStyle = SetWindowLongW(windowVars.hWnd, GWL_STYLE, WS_POPUP);

		windowVars.supress_WM_SIZE = false;
		windowVars.supress_WM_MOVE = false;

		windowVars.supress_WM_MOVE = true;
		windowVars.supress_WM_SIZE = true;
		windowVars.oldExStyle = SetWindowLongW(windowVars.hWnd, GWL_EXSTYLE, 0);
		windowVars.supress_WM_SIZE = false;
		windowVars.supress_WM_MOVE = false;

		SetWindowPos(windowVars.hWnd, null, 0,0, SystemGetDisplayWidth(SystemGetPrimaryDisplay()), SystemGetDisplayHeight(SystemGetPrimaryDisplay()), SWP_NOOWNERZORDER | SWP_NOZORDER);

		SetWindowRgn(windowVars.hWnd, null, true);

		if (window.visible) {
			ShowWindow(windowVars.hWnd, SW_SHOW);
		}

		windowVars.infullscreen = true;
	}
	else if (window.visible) {
		if (windowVars.infullscreen) {
			SetWindowLongW(windowVars.hWnd, GWL_STYLE, cast(DWORD)windowVars.oldStyle);
			SetWindowLongW(windowVars.hWnd, GWL_EXSTYLE, cast(DWORD)windowVars.oldExStyle);

			int width, height;
			width = window.width;
			height = window.height;

			_ClientSizeToWindowSize(window, width, height);

			SetWindowPos(windowVars.hWnd, null, window.x,window.y, width, height, SWP_NOOWNERZORDER | SWP_NOZORDER);
			InvalidateRect(null, null, 0);

			windowVars.infullscreen = false;
		}

		switch(window.state) {
			case WindowState.Normal:

				windowVars.supress_WM_SIZE_state = true;
				ShowWindow(windowVars.hWnd, SW_RESTORE);
				break;

			case WindowState.Minimized:

				windowVars.supress_WM_SIZE_state = true;
				ShowWindow(windowVars.hWnd, SW_MINIMIZE);
				break;

			case WindowState.Maximized:

				windowVars.supress_WM_SIZE_state = true;
				ShowWindow(windowVars.hWnd, SW_MAXIMIZE);
				break;

			default: break;
		}
	}
}

void _GatherStyleInformation(ref Window window, ref uint istyle, ref uint iexstyle) {
	if (window.style == WindowStyle.Fixed) {
		istyle = WS_BORDER | WS_CAPTION | WS_MINIMIZEBOX | WS_SYSMENU;

		istyle &= ~(WS_THICKFRAME | WS_DLGFRAME);
		iexstyle &= ~(WS_EX_TOOLWINDOW | WS_EX_CLIENTEDGE | WS_EX_WINDOWEDGE | WS_EX_STATICEDGE);

		istyle |= WS_BORDER | WS_CAPTION;
		iexstyle |= WS_EX_DLGMODALFRAME;
	}
	else if (window.style == WindowStyle.Popup) {
		istyle = WS_POPUP;
	}
	else { //Sizable
		istyle = WS_OVERLAPPEDWINDOW;
	}
	//iexstyle |= 0x02000000;

	if (window.visible) {
		istyle |= WS_VISIBLE;
	}
}

void _ClientSizeToWindowSize(ref Window window, ref int width, ref int height) {
	if (width == Default) {
		width = CW_USEDEFAULT;
	}
	else {
		//normalize sizes

		//account for borders and title bar...
		//because windows is retarded in this
		//respect

		if (window.style == WindowStyle.Fixed) {
			int border_width, border_height;
			border_width = ( GetSystemMetrics(SM_CXBORDER) + GetSystemMetrics(SM_CXDLGFRAME) ) * 2;
			border_height = (GetSystemMetrics(SM_CYDLGFRAME) * 2) + GetSystemMetrics(SM_CYBORDER) + GetSystemMetrics(SM_CYCAPTION);

			width += border_width;
			height += border_height;
		}
		else if (window.style == WindowStyle.Popup) {
			//do nothing
		}
		else { 
			//Sizable
			int border_width, border_height;
			border_width = GetSystemMetrics(SM_CXFRAME) * 2;
			border_height = GetSystemMetrics(SM_CYFRAME) + GetSystemMetrics(SM_CYDLGFRAME) + GetSystemMetrics(SM_CYBORDER) + GetSystemMetrics(SM_CYCAPTION);

			width += border_width;
			height += border_height;
		}

		// account for menubar
	}
}

void WindowRebound(ref Window window, WindowPlatformVars* windowVars) {
	int width, height;

	width = window.width;
	height = window.height;

	_ClientSizeToWindowSize(window, width, height);

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
	wstring s = Unicode.toUtf16(window.text);
	s ~= '\0';
	SetWindowTextW(windowVars.hWnd, cast(wchar*)s.ptr);
}

// CLIENT TO SCREEN

// Takes a point on the window's client area and returns the actual screen
// coordinates for that point.

void WindowClientToScreen(ref Window window, WindowPlatformVars* windowVars, ref int x, ref int y) {
	Coord pt = {x,y};
	ClientToScreen(windowVars.hWnd, cast(POINT*)&pt);
	x = pt.x;
	y = pt.y;
}

void WindowClientToScreen(ref Window window, WindowPlatformVars* windowVars, ref Coord pt) {
	ClientToScreen(windowVars.hWnd, cast(POINT*)&pt);
}

void WindowClientToScreen(ref Window window, WindowPlatformVars* windowVars, ref Rect rt) {
// could optimize by directly accessing a point worth from the rect
	Coord pt = {rt.left,rt.top};
	ClientToScreen(windowVars.hWnd, cast(POINT*)&pt);
	rt.left = pt.x;
	rt.top = pt.y;
	Coord pt2 = {rt.right,rt.bottom};
	ClientToScreen(windowVars.hWnd, cast(POINT*)&pt2);
	rt.right = pt2.x;
	rt.bottom = pt2.y;
}


// Viewable windows
void WindowStartDraw(ref Window window, WindowPlatformVars* windowVars, ref WindowView view, ref ViewPlatformVars viewVars) {
	//the starting pen and brush is black and white respectively
	if (viewVars.aa) {
		Gdiplus.GdipSetSmoothingMode(viewVars.g, Gdiplus.SmoothingMode.SmoothingModeAntiAlias);
	}
	else {
		Gdiplus.GdipSetSmoothingMode(viewVars.g, Gdiplus.SmoothingMode.SmoothingModeDefault);
	}
}

void WindowEndDraw(ref Window window, WindowPlatformVars* windowVars, ref WindowView view, ref ViewPlatformVars viewVars) {
	HDC hdc;
	hdc = GetDC(windowVars.hWnd);
//	Gdiplus.GpGraphics* g;
//	Gdiplus.GdipCreateFromHDC(hdc, &g);
//	Gdiplus.GdipDrawImageI(g, viewVars.image, 0, 0);

	BitBlt(hdc, 0, 0, window.width(), window.height(), viewVars.dc, 0, 0, SRCCOPY);

	ReleaseDC(windowVars.hWnd, hdc);
}

void WindowCaptureMouse(ref Window window, WindowPlatformVars* windowVars) {
	const int WM_MOUSECAPTURE = 0xffff;

	SendMessageW(windowVars.hWnd, WM_MOUSECAPTURE, 0, 0);
}

void WindowReleaseMouse(ref Window window, WindowPlatformVars* windowVars) {
	ReleaseCapture();
}