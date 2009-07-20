/*
 * window.d
 *
 * This file implements the Scaffold for platform specific Window
 * operations in Windows.
 *
 * Author: Dave Wilkinson
 *
 */

module platform.win.scaffolds.window;

import platform.win.scaffolds.system;

import platform.win.vars;
import platform.win.common;
import platform.win.main;

import graphics.view;

import core.color;
import core.string;
import core.main;
import core.definitions;

import gui.window;

import opengl.window;

import synch.thread;

// all windows
void WindowCreate(ref Window window, WindowHelper windowHelper)
{
	auto windowVars = windowHelper.getPlatformVars();

	windowVars.oldWidth = window.width;
	windowVars.oldHeight = window.height;

	windowVars.oldX = window.x;
	windowVars.oldY = window.y;

	windowVars.oldTitle = window.text;

	windowVars.userData = cast(void*)windowHelper;

	_ClientSizeToWindowSize(window, windowVars.oldWidth, windowVars.oldHeight);

	_GatherStyleInformation(window, windowVars.istyle, windowVars.iexstyle);

	windowVars.windowClass = window;

	if (cast(GLWindow)window !is null)
	{
		windowVars.msgThread = new Thread(&windowVars.gameLoop);
	}
	else
	{
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

void WindowCreate(ref Window parent, WindowHelper parentHelper, ref Window window, WindowHelper windowHelper)
{
	/*
	int width, height, x, y;

	width = window.getWidth();
	height = window.getHeight();

	x = window.getX();
	y = window.getY();

	width = window.getWidth();
	height = window.getHeight();

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

void WindowSetStyle(ref Window window, WindowHelper windowHelper)
{
	auto windowVars = windowHelper.getPlatformVars;

	bool wasMaximized = false;

	if (window.state == WindowState.Maximized)
	{
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

	if (wasMaximized)
	{
		window.state = WindowState.Maximized;

		if (window.visible)
		{
			ShowWindow(windowVars.hWnd, SW_SHOW);
		}
	}
}

void WindowReposition(ref Window window, WindowHelper windowHelper)
{
	auto windowVars = windowHelper.getPlatformVars;

	SetWindowPos(windowVars.hWnd, null, window.x,window.y, 0, 0, SWP_NOSIZE | SWP_NOOWNERZORDER | SWP_NOZORDER);
}

void WindowSetState(ref Window window, WindowHelper windowHelper)
{
	auto windowVars = windowHelper.getPlatformVars;

	if (window.state == WindowState.Fullscreen)
	{
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

		windowHelper.setWindowX(0);
		windowHelper.setWindowY(0);
		windowHelper.setWindowWidth(1280);
		windowHelper.setWindowHeight(1024);

		SetWindowRgn(windowVars.hWnd, null, true);

		if (window.visible)
		{
			ShowWindow(windowVars.hWnd, SW_SHOW);
		}

		windowVars.infullscreen = true;
	}
	else if (window.visible)
	{
		if (windowVars.infullscreen)
		{
			SetWindowLongW(windowVars.hWnd, GWL_STYLE, windowVars.oldStyle);
			SetWindowLongW(windowVars.hWnd, GWL_EXSTYLE, windowVars.oldExStyle);

			windowHelper.setWindowX(windowVars.oldX);
			windowHelper.setWindowY(windowVars.oldY);
			windowHelper.setWindowWidth(windowVars.oldWidth);
			windowHelper.setWindowHeight(windowVars.oldHeight);

			int width, height;
			width = window.width;
			height = window.height;

			_ClientSizeToWindowSize(window, width, height);

			SetWindowPos(windowVars.hWnd, null, window.x,window.y, width, height, SWP_NOOWNERZORDER | SWP_NOZORDER);
			InvalidateRect(null, null, 0);

			windowVars.infullscreen = false;
		}

		switch(window.state)
		{
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

void _GatherStyleInformation(ref Window window, ref uint istyle, ref uint iexstyle)
{
	if (window.style == WindowStyle.Fixed)
	{
		istyle = WS_BORDER | WS_CAPTION | WS_MINIMIZEBOX | WS_SYSMENU;

                /+
                istyle &= ~(WS_BORDER | WS_THICKFRAME);
                iexstyle &= ~(WS_EX_TOOLWINDOW | WS_EX_CLIENTEDGE | WS_EX_STATICEDGE);
                istyle |= WS_CAPTION | WS_DLGFRAME;
                iexstyle |= WS_EX_DLGMODALFRAME | WS_EX_WINDOWEDGE;
                +/

		istyle &= ~(WS_THICKFRAME | WS_DLGFRAME);
		iexstyle &= ~(WS_EX_TOOLWINDOW | WS_EX_CLIENTEDGE | WS_EX_WINDOWEDGE | WS_EX_STATICEDGE);

		istyle |= WS_BORDER | WS_CAPTION;
		iexstyle |= WS_EX_DLGMODALFRAME;
	}
	else if (window.style == WindowStyle.Popup)
	{
		istyle = WS_POPUP;
	}
	else //Sizable
	{
		istyle = WS_OVERLAPPEDWINDOW;
	}

	if (window.visible)
	{
		istyle |= WS_VISIBLE;
	}
}

void _ClientSizeToWindowSize(ref Window window, ref int width, ref int height)
{
	if (width == Default) { width = CW_USEDEFAULT; }
	else
	{
		//normalize sizes

		//account for borders and title bar...
		//because windows is retarded in this
		//respect

		if (window.style == WindowStyle.Fixed)
		{
			int border_width, border_height;
			border_width = ( GetSystemMetrics(SM_CXBORDER) + GetSystemMetrics(SM_CXDLGFRAME) ) * 2;
			border_height = (GetSystemMetrics(SM_CYDLGFRAME) * 2) + GetSystemMetrics(SM_CYBORDER) + GetSystemMetrics(SM_CYCAPTION);

			width += border_width;
			height += border_height;
		}
		else if (window.style == WindowStyle.Popup)
		{
			//do nothing
		}
		else //Sizable
		{
			int border_width, border_height;
			border_width = GetSystemMetrics(SM_CXFRAME) * 2;
			border_height = GetSystemMetrics(SM_CYFRAME) + GetSystemMetrics(SM_CYDLGFRAME) + GetSystemMetrics(SM_CYBORDER) + GetSystemMetrics(SM_CYCAPTION);

			width += border_width;
			height += border_height;
		}

		// account for menubar
	}
}

void WindowRebound(ref Window window, WindowHelper windowHelper)
{
	auto windowVars = windowHelper.getPlatformVars;

	int width, height;

	width = window.width;
	height = window.height;

	_ClientSizeToWindowSize(window, width, height);

	windowVars.supress_WM_SIZE = true;
	SetWindowPos(windowVars.hWnd, null, 0,0, width, height, SWP_NOMOVE | SWP_NOOWNERZORDER);
}

void WindowDestroy(ref Window window, WindowHelper windowHelper)
{
	auto windowVars = windowHelper.getPlatformVars;

	PostMessageW(windowVars.hWnd, WM_CLOSE, 0,0);
}

void WindowSetVisible(ref Window window, WindowHelper windowHelper, bool bShow)
{
	auto windowVars = windowHelper.getPlatformVars;

	if (bShow)
	{
		ShowWindow(windowVars.hWnd, SW_SHOW);
	}
	else
	{
		ShowWindow(windowVars.hWnd, SW_HIDE);
	}
}

void WindowSetTitle(ref Window window, WindowHelper windowHelper)
{
	auto windowVars = windowHelper.getPlatformVars;

	String s = new String(window.text);
	s.appendChar('\0');
	SetWindowTextW(windowVars.hWnd, cast(wchar*)s.ptr);
}

// CLIENT TO SCREEN

// Takes a point on the window's client area and returns the actual screen
// coordinates for that point.

void WindowClientToScreen(ref Window window, WindowHelper windowHelper, ref int x, ref int y)
{
	auto windowVars = windowHelper.getPlatformVars;

	Coord pt = {x,y};
	ClientToScreen(windowVars.hWnd, cast(POINT*)&pt);
	x = pt.x;
	y = pt.y;
}

void WindowClientToScreen(ref Window window, WindowHelper windowHelper, ref Coord pt)
{
	auto windowVars = windowHelper.getPlatformVars;

	ClientToScreen(windowVars.hWnd, cast(POINT*)&pt);
}

void WindowClientToScreen(ref Window window, WindowHelper windowHelper, ref Rect rt)
{
	auto windowVars = windowHelper.getPlatformVars;

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
void WindowStartDraw(ref Window window, WindowHelper windowHelper, ref WindowView view, ref ViewPlatformVars viewVars)
{
	auto windowVars = windowHelper.getPlatformVars;

	RECT rt;

	rt.left = 0;
	rt.top = 0;
	rt.right = view.getWidth();
	rt.bottom = view.getHeight();

	//draw background
	windowVars.brsh = CreateSolidBrush(ColorGetValue(window.color));
	FillRect(viewVars.dc, &rt, windowVars.brsh);
	DeleteObject(windowVars.brsh);

	//the starting pen and brush is black and white respectively

	//window->_view._graphics.CreatePen(windowVars.pen, 0);

	windowVars.pen = CreatePen(0,1, 0x00ff00);
	SelectObject(viewVars.dc, windowVars.pen);

	windowVars.brsh = CreateSolidBrush(0xffffff);
	SelectObject(viewVars.dc, windowVars.brsh);

	//window->_view._graphics.CreateFont(window->_pfvars.fnt, S("Times New Roman"), 10, 400, false, false, false);

	//window->_view._graphics.UseFont(window->_pfvars.fnt);

	//window->_view._graphics.SetTextModeTransparent();
}

void WindowEndDraw(ref Window window, WindowHelper windowHelper, ref WindowView view, ref ViewPlatformVars viewVars)
{
	auto windowVars = windowHelper.getPlatformVars;

	//window->_view._graphics.DestroyFont(window->_pfvars.fnt);

	DeleteObject(windowVars.pen);
	DeleteObject(windowVars.brsh);

	HDC hdc;
	hdc = GetDC(windowVars.hWnd);

	BitBlt(hdc, 0, 0, view.getWidth(), view.getHeight(), viewVars.dc, 0, 0, SRCCOPY);

	ReleaseDC(windowVars.hWnd, hdc);
}

void WindowCaptureMouse(ref Window window, WindowHelper windowHelper)
{
	auto windowVars = windowHelper.getPlatformVars;

	SendMessageW(windowVars.hWnd, WM_MOUSECAPTURE, 0, 0);
}

void WindowReleaseMouse(ref Window window, WindowHelper windowHelper)
{
	auto windowVars = windowHelper.getPlatformVars;

	ReleaseCapture();
}