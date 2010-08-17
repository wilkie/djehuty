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

	// These variables are for detecting redundant mouse move messages
	windowVars.lastX = -1;
	windowVars.lastY = -1;

	// Need a reference to the window for knowing its size for WM_MOUSELEAVE
	windowVars.window = window;

	// Create the window
	windowVars.hWnd = CreateWindowExW(
		WS_EX_LAYERED, // | WS_EX_TOOLWINDOW,
		className.ptr, "\0"w.ptr,
		style,
		cast(int)window.left, cast(int)window.top, cast(int)window.width, cast(int)window.height,
		null, null, null, userData);
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


	static int _translateScancode[] = [
		Key.Pause,
		Key.Escape,
		Key.One,
		Key.Two,
		Key.Three,
		Key.Four,
		Key.Five,
		Key.Six,
		Key.Seven,
		Key.Eight,
		Key.Nine,
		Key.Zero,
		Key.Minus,
		Key.Equals,
		Key.Backspace,
		Key.Tab,
		Key.Q,
		Key.W,
		Key.E,
		Key.R,
		Key.T,
		Key.Y,
		Key.U,
		Key.I,
		Key.O,
		Key.P,
		Key.LeftBracket,
		Key.RightBracket,
		Key.Return,
		Key.LeftControl,
		Key.A,
		Key.S,
		Key.D,
		Key.F,
		Key.G,
		Key.H,
		Key.J,
		Key.K,
		Key.L,
		Key.Semicolon,
		Key.Quote,
		Key.SingleQuote,
		Key.LeftShift,
		Key.Backslash,
		Key.Z,
		Key.X,
		Key.C,
		Key.V,
		Key.B,
		Key.N,
		Key.M,
		Key.Comma,
		Key.Period,
		Key.Foreslash,
		Key.RightShift,
		Key.PrintScreen,
		Key.LeftAlt,
		Key.Space,
		Key.CapsLock,
		Key.F1,
		Key.F2,
		Key.F3,
		Key.F4,
		Key.F5,
		Key.F6,
		Key.F7,
		Key.F8,
		Key.F9,
		Key.F10,
		Key.NumLock,
		Key.ScrollLock,
		Key.Home,
		Key.Up,
		Key.PageUp,
		Key.Invalid,
		Key.Left,
		Key.Invalid,
		Key.Right,
		Key.Invalid,
		Key.End,
		Key.Down,
		Key.PageDown,
		Key.Insert,
		Key.Delete,
		Key.SysRq,
		87: Key.F11,
		88: Key.F12
	];

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
			return 1;

		case WM_MOUSEMOVE:
			windowVars.event.type = Event.MouseMove;
			int x, y;
			x = lParam & 0xffff;
			windowVars.event.info.mouse.x = x;
			y = (lParam >> 16) & 0xffff;
			windowVars.event.info.mouse.y = y;

			if (x == windowVars.lastX && y == windowVars.lastY) {
				// Redundant mouse move
				return 1;
			}
			windowVars.lastX = x;
			windowVars.lastY = y;

			if (windowVars.hoverTimerSet == 0) {
				SetTimer(hWnd, 0, 55, null);
				windowVars.hoverTimerSet = 1;
			}

			windowVars.haveEvent = true;
			return 1;

		case WM_TIMER:
			if (wParam == 0) {
				//Internal Timer (mouse hover)
				POINT pt;
				GetCursorPos(&pt);

				if (WindowFromPoint(pt) == hWnd) {
					POINT pnt[2];

					pnt[0].x = 0;
					pnt[0].y = 0;
					pnt[1].x = cast(int)windowVars.window.width-1;
					pnt[1].y = cast(int)windowVars.window.height-1;

					ClientToScreen(hWnd, &pnt[0]);
					ClientToScreen(hWnd, &pnt[1]);

					if (!(pt.x < pnt[0].x || pt.y < pnt[0].y || pt.x > pnt[1].x || pt.y > pnt[1].y)) {
						// Within the window...
						return 1;
					}
				}

				KillTimer(hWnd,0);
				windowVars.hoverTimerSet = 0;

				// To make sure it is enqueued and thus retrieved
				// upon GetMessage...
				SendMessageW(hWnd, WM_MOUSELEAVE, 0,0);
			}
			return 1;

		// Custom event that is triggered when the cursor leaves the window
		case WM_MOUSELEAVE:
			windowVars.event.type = Event.MouseLeave;
			windowVars.haveEvent = true;
			return 1;

		case WM_SYSKEYDOWN:
		case WM_SYSKEYUP:
			// Detect a system command.
			auto scan = ((lParam >> 16) & 0xff);
			scan = _translateScancode[scan];

			if ((lParam & (1 << 29)) > 0) {
				// ALT is pressed with another key
				if (scan == Key.F4) {
					// ALT+F4
					break;
				}
			}

			// Follow through to catch the key press / release

		case WM_KEYDOWN:
		case WM_KEYUP:
			if (uMsg == WM_KEYDOWN || uMsg == WM_SYSKEYDOWN) {
				windowVars.event.type = Event.KeyDown;
			}
			else {
				windowVars.event.type = Event.KeyUp;
			}

			// Get the scancode from the OEM section in LPARAM
			auto scan = ((lParam >> 16) & 0xff);
			if (wParam == VK_RMENU || (wParam == VK_MENU && (lParam & (1 << 24)))) {
				scan = Key.RightAlt;
			}
			else if (wParam == VK_RCONTROL || (wParam == VK_CONTROL && (lParam & (1 << 24)))) {
				scan = Key.RightControl;
			}
			else {
				scan = _translateScancode[scan];
			}

			windowVars.event.info.key.ctrl = GetKeyState(VK_CONTROL) < 0;
			windowVars.event.info.key.alt = GetKeyState(VK_MENU) < 0;
			windowVars.event.info.key.shift = GetKeyState(VK_SHIFT) < 0;

			if (scan == Key.Invalid) {
				printf("invalid key: %d\n", MapVirtualKey(wParam, MAPVK_VK_TO_VSC));
			}

			windowVars.event.info.key.scan = scan;
			windowVars.haveEvent = true;
			return 1;

		default:
			break;
	}

	return DefWindowProcW(hWnd, uMsg, wParam, lParam);
}