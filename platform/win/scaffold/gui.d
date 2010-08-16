/*
 * gui.d
 *
 * This implements the platform specific code to interop with the window
 * manager.
 *
 */

module scaffold.gui;

import gui.window;

import graphics.canvas;

import platform.vars.gui;
import platform.vars.window;
import platform.vars.canvas;

import djehuty;

pragma(lib, "comctl32.lib");

import binding.c;

import binding.win32.windef;
import binding.win32.winnt;
import binding.win32.winbase;
import binding.win32.wingdi;
import binding.win32.winuser;
import binding.win32.winerror;

import Gdiplus = binding.win32.gdiplus;

void GuiCreateWindow(Window window, WindowPlatformVars* windowVars) {
	void* userData = cast(void*)windowVars;

	DWORD style = WS_POPUP;

	if (window.visible) {
		style |= WS_VISIBLE;
	}

	wstring className = Unicode.toUtf16(Djehuty.application.name ~ "\0");

	windowVars.doubleClickTimerSet = -1;
	windowVars.window = window;
	windowVars.hWnd = CreateWindowExW(
		WS_EX_LAYERED, // | WS_EX_TOOLWINDOW,
		className.ptr, "\0"w.ptr,
		style,
		cast(int)window.left, cast(int)window.top, cast(int)window.width, cast(int)window.height,
		null, null, null, userData);

//	printf("window: %p\n", windowVars.hWnd);
}

void GuiDestroyWindow(Window window, WindowPlatformVars* windowVars) {
}

void GuiUpdateWindow(Window window, WindowPlatformVars* windowVars, CanvasPlatformVars* viewVars) {
	POINT pt;
	pt.x = cast(int)window.left;
	pt.y = cast(int)window.top;

	POINT ptz;
	ptz.x = 0;
	ptz.y = 0;

	SIZE sz;
	sz.cx = cast(int)window.width;
	sz.cy = cast(int)window.height;

	BLENDFUNCTION bf;
	bf.BlendOp = AC_SRC_OVER;
	bf.BlendFlags = 0;
	bf.SourceConstantAlpha = 255;
	bf.AlphaFormat = AC_SRC_ALPHA;

	HBITMAP hbm;
	Gdiplus.GdipCreateHBITMAPFromBitmap(viewVars.image, &hbm, 0);
	HDC windowDC = GetDC(windowVars.hWnd);
	HDC dc = CreateCompatibleDC(windowDC);
	SelectObject(dc, hbm);
	DeleteObject(hbm);

	UpdateLayeredWindow(windowVars.hWnd, null, &pt, &sz, dc, &ptz, 0, &bf, ULW_ALPHA);
	
	ReleaseDC(windowVars.hWnd, windowDC);
	DeleteDC(dc);
}

void GuiUpdateCursor(Canvas view, CanvasPlatformVars* viewVars) {
}

void GuiRepositionWindow(Window window, WindowPlatformVars* windowVars) {
}

void GuiNextEvent(Window window, WindowPlatformVars* windowVars, Event* evt) {
	MSG msg;
	BOOL ret = TRUE;
	while (ret != 0) {
		windowVars.event = evt;
		windowVars.haveEvent = false;
		ret = GetMessage(&msg, null, 0, 0);
		if (ret != -1) {
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}
		if (windowVars.haveEvent) {
			return;
		}
	}
}

void GuiStart(GuiPlatformVars* guiVars) {
	registerClass();
	Gdiplus.GdiplusStartup(&guiVars.gdiplusToken, &guiVars.gdiplusStartupInput, null);
}

void GuiEnd(GuiPlatformVars* guiVars) {
	Gdiplus.GdiplusShutdown(guiVars.gdiplusToken);
}

private:

void registerClass() {
	WNDCLASSW wc;
	wstring className = Unicode.toUtf16(Djehuty.application.name ~ "\0");
	wc.lpszClassName = className.ptr;

	wc.style = 0;//CS_PARENTDC;

	wc.lpfnWndProc = &DefaultProc;

	wc.hInstance = null;

	wc.hIcon = LoadIconA(cast(HINSTANCE) null, IDI_APPLICATION);
	wc.hCursor = LoadCursorA(cast(HINSTANCE) null, IDC_ARROW);

	wc.hbrBackground = cast(HBRUSH) (COLOR_WINDOW + 1);
	wc.lpszMenuName = null;
	wc.cbClsExtra = wc.cbWndExtra = 0;

	assert(RegisterClassW(&wc));
}

extern(Windows)
int DefaultProc(HWND hWnd, uint uMsg, WPARAM wParam, LPARAM lParam) {
	CREATESTRUCTW* cs = cast(CREATESTRUCTW*)lParam;
	switch(uMsg) {
		case WM_CREATE:
			auto w = cast(WindowPlatformVars*)cs.lpCreateParams;

			SetWindowLongW(hWnd, GWLP_WNDPROC, cast(LONG)&MessageProc);
			SetWindowLongW(hWnd, GWLP_USERDATA, cast(LONG)cs.lpCreateParams);

			break;

		default:
			return DefWindowProcW(hWnd, uMsg, wParam, lParam);
	}

	return 0;
}

extern(Windows)
int MessageProc(HWND hWnd, uint uMsg, WPARAM wParam, LPARAM lParam) {
	void* wind_in = cast(void*)GetWindowLongW(hWnd, GWLP_USERDATA);
	WindowPlatformVars* windowVars = cast(WindowPlatformVars*)(wind_in);

	switch(uMsg) {
		case WM_ERASEBKGND:
		case WM_UNICHAR:
			return 1;

		case WM_SYSCOMMAND:
			if (wParam == SC_CLOSE) {
				windowVars.event.type = Event.Close;
				windowVars.haveEvent = true;
				return 1;
			}
			break;

		case WM_LBUTTONDOWN:
		case WM_RBUTTONDOWN:
		case WM_MBUTTONDOWN:
			windowVars.event.type = Event.MouseDown;
			if (uMsg == WM_LBUTTONDOWN) {
				windowVars.event.aux = 0;
			}
			else if (uMsg == WM_RBUTTONDOWN) {
				windowVars.event.aux = 1;
			}
			else {
				windowVars.event.aux = 2;
			}

			SetFocus(hWnd);
			SetCapture(hWnd);

			int x, y;
			x = lParam & 0xffff;
			y = (lParam >> 16)& 0xffff;

			windowVars.event.info.mouse.x = x;
			windowVars.event.info.mouse.y = y;

			windowVars.haveEvent = true;
			return 1;

		case WM_LBUTTONUP:
		case WM_RBUTTONUP:
		case WM_MBUTTONUP:
			windowVars.event.type = Event.MouseUp;
			if (uMsg == WM_LBUTTONUP) {
				windowVars.event.aux = 0;
			}
			else if (uMsg == WM_RBUTTONUP) {
				windowVars.event.aux = 1;
			}
			else {
				windowVars.event.aux = 2;
			}

			ReleaseCapture();

			int x, y;
			x = lParam & 0xffff;
			windowVars.event.info.mouse.x = x;
			y = (lParam >> 16) & 0xffff;
			windowVars.event.info.mouse.y = y;

			windowVars.haveEvent = true;
			break;

		case WM_MOUSEMOVE:
			windowVars.event.type = Event.MouseMove;
			int x, y;
			x = lParam & 0xffff;
			windowVars.event.info.mouse.x = x;
			y = (lParam >> 16) & 0xffff;
			windowVars.event.info.mouse.y = y;

			if (windowVars.hoverTimerSet == 0) {
				SetTimer(hWnd, 0, 55, null);
				windowVars.hoverTimerSet = 1;
			}

			windowVars.haveEvent = true;
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
					pnt[1].x = cast(int)windowVars.window.width-1;
					pnt[1].y = cast(int)windowVars.window.height-1;

					ClientToScreen(hWnd, &pnt[0]);
					ClientToScreen(hWnd, &pnt[1]);

					if (pt.x < pnt[0].x || pt.y < pnt[0].y || pt.x > pnt[1].x || pt.y > pnt[1].y) {
						KillTimer(hWnd,0);

						windowVars.hoverTimerSet = 0;

						// To make sure it is enqueued and thus retrieved
						// upon GetMessage...
						SendMessageW(hWnd, WM_MOUSELEAVE, 0, 0);
					}
				}
			}

			break;

		// Custom event that is triggered when the cursor leaves the window
		case WM_MOUSELEAVE:
			windowVars.event.type = Event.MouseLeave;
			windowVars.haveEvent = true;
			break;

		case WM_KEYDOWN:
			windowVars.event.type = Event.KeyDown;
			windowVars.event.info.key.code = cast(uint)wParam;
			windowVars.haveEvent = true;
			break;

		case WM_KEYUP:
			windowVars.event.type = Event.KeyUp;
			windowVars.event.info.key.code = cast(uint)wParam;
			windowVars.haveEvent = true;
			break;

		default:
			break;
	}

	return DefWindowProcW(hWnd, uMsg, wParam, lParam);
}