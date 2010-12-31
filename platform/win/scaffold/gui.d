/*
 * gui.d
 *
 * This implements the platform specific code to interop with the window
 * manager.
 *
 */

module scaffold.gui;

import gui.window;
import gui.dialog;

import graphics.canvas;

import binding.opengl.gl;
import binding.opengl.glu;
import binding.opengl.glext;

import platform.vars.gui;
import platform.vars.window;
import platform.vars.canvas;

import djehuty;

pragma(lib, "comctl32.lib");
pragma(lib, "msimg32.lib");
pragma(lib, "dwmapi.lib");

import binding.c;

import binding.win32.windef;
import binding.win32.winnt;
import binding.win32.winbase;
import binding.win32.wingdi;
import binding.win32.winuser;
import binding.win32.winerror;

import binding.win32.dwmapi;
import binding.win32.uxtheme;

import data.queue;

import io.console;

import synch.thread;
import synch.semaphore;

import Gdiplus = binding.win32.gdiplus;

void GuiCreateWindow(Window window, WindowPlatformVars* windowVars) {
	// These variables are for detecting redundant mouse move messages
	windowVars.lastX = -1;
	windowVars.lastY = -1;

	// Need a reference to the window for knowing its size for WM_MOUSELEAVE
	windowVars.window = window;
	windowVars.pixelData = new ubyte[](cast(int)window.width * cast(int)window.height * 4);

	windowVars.eventQueue = new Queue!(Event);
	windowVars.wait = new Semaphore(0);
	windowVars.messageThread = new MessageThread(windowVars);

	auto windhDC = GetDC(null);
	windowVars.backbuffer = CreateCompatibleDC(windhDC);
	ReleaseDC(null, windhDC);

	// Start the message loop

	windowVars.messageThread.start();

	windowVars.wait.down();
	windowVars.wait.up();
}

static const uint WM_USER_REDRAW = WM_USER + 1;

void GuiRedrawRequest(Window window, WindowPlatformVars* windowVars) {
	Event evt;
	evt.type = Event.Redraw;

	windowVars.eventQueue.add(evt);
//	PostMessage(windowVars.hWnd, WM_USER_REDRAW, 0, 0);
}

void GuiDestroyWindow(Window window, WindowPlatformVars* windowVars) {
}

void GuiUpdateWindow(Window window, WindowPlatformVars* windowVars, CanvasPlatformVars* viewVars) {
	// Capture (only when presenting it to the window manager)
	glReadPixels(0, 0, cast(int)window.width, cast(int)window.height, GL_BGRA, GL_UNSIGNED_BYTE,
			windowVars.pixelData.ptr);

	auto windhDC = GetDC(null);
	auto hBMP = CreateCompatibleBitmap(windhDC, cast(int)window.width, cast(int)window.height);
	windowVars.backbuffer = CreateCompatibleDC(windhDC);

	BITMAPINFO bmpInfo;
	bmpInfo.bmiHeader.biSize = BITMAPINFOHEADER.sizeof;
	bmpInfo.bmiHeader.biWidth = cast(int)window.width;
	bmpInfo.bmiHeader.biHeight = cast(int)window.height;
	bmpInfo.bmiHeader.biPlanes = 1;
	bmpInfo.bmiHeader.biBitCount = 32;
	bmpInfo.bmiHeader.biCompression = BI_RGB;
	SetDIBits(windowVars.backbuffer, hBMP, 0, cast(int)window.height, windowVars.pixelData.ptr, &bmpInfo, DIB_RGB_COLORS);

	SelectObject(windowVars.backbuffer, hBMP);
	DeleteObject(hBMP);
	ReleaseDC(null, windhDC);

	viewVars.testDC = windowVars.backbuffer;

	BLENDFUNCTION bf;
	bf.BlendOp = AC_SRC_OVER;
	bf.BlendFlags = 0;
	bf.SourceConstantAlpha = 255;
	bf.AlphaFormat = AC_SRC_ALPHA;

	if (cast(Dialog)window is null) {
		POINT pt;
		pt.x = cast(int)window.left;
		pt.y = cast(int)window.top;

		POINT ptz;
		ptz.x = 0;
		ptz.y = 0;

		SIZE sz;
		sz.cx = cast(int)window.width;
		sz.cy = cast(int)window.height;

		UpdateLayeredWindow(windowVars.hWnd, null, &pt, &sz, viewVars.testDC, &ptz, 0, &bf, ULW_ALPHA);
	}
	else {
		//RedrawWindow(windowVars.hWnd, null, null, RDW_INVALIDATE | RDW_INTERNALPAINT);
		
		auto hdc = GetDC(windowVars.hWnd);
/*		HBRUSH brsh = CreateSolidBrush(0);
		RECT rt;
		GetClientRect(windowVars.hWnd, &rt);
		FillRect(hdc, &rt, brsh);
		AlphaBlend(hdc, 
				0, 0, cast(int)window.width(), cast(int)window.height(),
				windowVars.backbuffer, 
				0, 0, cast(int)window.width(), cast(int)window.height(), 
				bf);//*/

		BitBlt(hdc, 0, 0, cast(int)window.width(), cast(int)window.height(), windowVars.backbuffer, 0, 0, SRCCOPY);
		ReleaseDC(windowVars.hWnd, hdc);
	}
}

void GuiUpdateCursor(Canvas view, CanvasPlatformVars* viewVars) {
}

void GuiRepositionWindow(Window window, WindowPlatformVars* windowVars) {
}

void GuiNextEvent(Window window, WindowPlatformVars* windowVars, Event* evt) {
	MSG msg;
	BOOL ret = TRUE;
	while (ret != 0) {
		if (!windowVars.eventQueue.empty) {
			*evt = windowVars.eventQueue.remove();
			return;
		}
	}
}

void GuiStart(GuiPlatformVars* guiVars) {
	registerClass();
}

void GuiEnd(GuiPlatformVars* guiVars) {
}

private:

void createWindow(WindowPlatformVars* windowVars) {
	auto window = windowVars.window;
	void* userData = cast(void*)windowVars;

	DWORD style = WS_POPUP;
	DWORD istyle = 0;

	int w = cast(int)windowVars.window.width;
	int h = cast(int)windowVars.window.height;
	if (cast(Dialog)window !is null) {
		_clientSizeToWindowSize(cast(Dialog)windowVars.window, w, h);
		_gatherStyleInformation(cast(Dialog)windowVars.window, style, istyle);
	}

	if (window.visible) {
		style |= WS_VISIBLE;
	}

	wstring className = Unicode.toUtf16(Djehuty.application.name ~ "\0");

	// Create the window as a normal app window to add it to the taskbar
	windowVars.hWnd = CreateWindowExW(
		istyle | WS_EX_APPWINDOW,
		className.ptr, "\0"w.ptr,
		style,
		cast(int)window.left, cast(int)window.top, w, h,
		null, null, null, userData);


	if (cast(Dialog)window is null) {
		SetWindowLong(windowVars.hWnd, GWL_EXSTYLE, WS_EX_LAYERED);
	}

	DWM_BLURBEHIND bb;

	bb.dwFlags = DWM_BB_ENABLE | DWM_BB_BLURREGION | DWM_BB_TRANSITIONONMAXIMIZED;
	bb.fEnable = TRUE;
	HRGN rgn = CreateRectRgn(0,0,1,1);
	bb.hRgnBlur = rgn;
	bb.fTransitionOnMaximized = TRUE;

	DwmEnableBlurBehindWindow(windowVars.hWnd, &bb);
	//DeleteObject(rgn);
}

class MessageThread : Thread {
private:
	WindowPlatformVars* windowVars;

public:
	this(WindowPlatformVars* windowVars) {
		this.windowVars = windowVars;
		super();
	}

	override void run() {

		createWindow(windowVars);

		windowVars.wait.up();

		MSG msg;
		BOOL ret = TRUE;
		while(ret != 0) {
			ret = GetMessageW(&msg, windowVars.hWnd, 0, 0);
			if (ret != 0) {
				//TranslateMessage(&msg);
				DispatchMessage(&msg);
			}
		}
	}
}

void _clientSizeToWindowSize(Dialog window, ref int width, ref int height) {
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
		else { // Sizable
			int border_width, border_height;
			border_width = GetSystemMetrics(SM_CXFRAME) * 2;
			border_height = GetSystemMetrics(SM_CYFRAME) + GetSystemMetrics(SM_CYDLGFRAME) + GetSystemMetrics(SM_CYBORDER) + GetSystemMetrics(SM_CYCAPTION);

			width += border_width;
			height += border_height;
		}

		// account for menubar
	}
}

void _gatherStyleInformation(Dialog window, ref uint istyle, ref uint iexstyle) {
	if (window.style == WindowStyle.Fixed) {
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
	else if (window.style == WindowStyle.Popup) {
		istyle = WS_POPUP;
	}
	else { // Sizable
		istyle = WS_OVERLAPPEDWINDOW;
	}
}

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

	Dialog dialog = cast(Dialog)windowVars.window;

	static int _set1ToSet2[] = [
		// 0x00
		0x00, 0x76, 0x16, 0x1e, 0x26, 0x25, 0x2e, 0x36, 0x3d, 0x3e, 0x46, 0x45, 0x4e, 0x55, 0x66, 0x0d,
		// 0x10
		0x15, 0x1d, 0x24, 0x2d, 0x2c, 0x35, 0x3c, 0x43, 0x44, 0x4d, 0x54, 0x5b, 0x5a, 0x14, 0x1c, 0x1b,
		// 0x20
		0x23, 0x2b, 0x34, 0x33, 0x3b, 0x42, 0x4b, 0x4c, 0x52, 0x0e, 0x12, 0x5d, 0x1a, 0x22, 0x21, 0x2a,
		// 0x30
		0x32, 0x31, 0x3a, 0x41, 0x49, 0x4a, 0x59, 0x7c, 0x11, 0x29, 0x58, 0x05, 0x06, 0x04, 0x0c, 0x03,
		// 0x40
		0x0b, 0x83, 0x0a, 0x01, 0x09, 0x77, 0x7e, 0x6c, 0x75, 0x7d, 0x7b, 0x6b, 0x73, 0x74, 0x79, 0x69,
		// 0x50
		0x72, 0x7a, 0x70, 0x71, 0x84, 0x00, 0x61, 0x78, 0x07, 0x00, 0x00, 0x1f, 0x27, 0x2f, 0x00, 0x00,
		// 0x60
		0x00, 0x00, 0x00, 0x5e, 0x08, 0x10, 0x18, 0x20, 0x28, 0x30, 0x38, 0x40, 0x00, 0x00, 0x00, 0x00,
	];

	static int _set1ExToSet2[] = [
		0x5b: 0xe01f,
		0x1d: 0xe014,
		0x5c: 0xe027,
		0x38: 0xe011,
		0x5d: 0xe02f,
		0x52: 0xe070,
		0x47: 0xe06c,
		0x49: 0xe07d,
		0x53: 0xe071,
		0x4f: 0xe069,
		0x51: 0xe07a,
		0x48: 0xe075,
		0x4b: 0xe06b,
		0x50: 0xe072,
		0x4d: 0xe074,
		0x35: 0xe04a,
		0x1c: 0xe05a,
		0x37: 0xe07c,
		
		0x5e: 0xe037,
		0x5f: 0xe03f,
		0x63: 0xe05e,

		0x19: 0xe04d,
		0x10: 0xe015,
		0x24: 0xe03b,
		0x22: 0xe034,
		0x20: 0xe023,
		0x30: 0xe032,
		0x2e: 0xe021,
		0x6d: 0xe050,
		0x6c: 0xe048,
		0x21: 0xe02b,
		0x6b: 0xe040,
		0x65: 0xe010,
		0x32: 0xe03a,
		0x6a: 0xe038,
		0x69: 0xe030,
		0x68: 0xe028,
		0x67: 0xe020,
		0x66: 0xe018,
	];

	// This array will translate the scan code (set 2) to the base key
	static int _translateScancode[] = [
		// 0x00
		Key.Invalid,
		Key.F9,
		Key.Invalid,
		Key.F5,
		Key.F3,
		Key.F1,
		Key.F2,
		Key.F12,
		Key.F17,
		Key.F10,
		Key.F8,
		Key.F6,
		Key.F4,
		Key.Tab,
		Key.SingleQuote,
		Key.Invalid,
		// 0x10
		Key.F18,
		Key.LeftAlt,
		Key.LeftShift,
		Key.Invalid,
		Key.LeftControl,
		Key.Q,
		Key.One,
		Key.Invalid,
		Key.F19,
		Key.Invalid,
		Key.Z,
		Key.S,
		Key.A,
		Key.W,
		Key.Two,
		Key.F13,
		// 0x20
		Key.F20,
		Key.C,
		Key.X,
		Key.D,
		Key.E,
		Key.Four,
		Key.Three,
		Key.F14,
		Key.F21,
		Key.Space,
		Key.V,
		Key.F,
		Key.T,
		Key.R,
		Key.Five,
		Key.F15,
		// 0x30
		Key.F22,
		Key.N,
		Key.B,
		Key.H,
		Key.G,
		Key.Y,
		Key.Six,
		Key.Invalid,
		Key.F23,
		Key.Invalid,
		Key.M,
		Key.J,
		Key.U,
		Key.Seven,
		Key.Eight,
		Key.Invalid,
		// 0x40
		Key.F24,
		Key.Comma,
		Key.K,
		Key.I,
		Key.O,
		Key.Zero,
		Key.Nine,
		Key.Invalid,
		Key.Invalid,
		Key.Period,
		Key.Foreslash,
		Key.L,
		Key.Semicolon,
		Key.P,
		Key.Minus,
		Key.Invalid,
		// 0x50
		Key.Invalid,
		Key.Invalid,
		Key.Apostrophe,
		Key.Invalid,
		Key.LeftBracket,
		Key.Equals,
		Key.Invalid,
		Key.Invalid,
		Key.CapsLock,
		Key.RightShift,
		Key.Return,
		Key.RightBracket,
		Key.Invalid,
		Key.Backslash,
		Key.F16,
		Key.Invalid,
		// 0x60
		Key.Invalid,
		Key.Invalid,
		Key.Invalid,
		Key.Invalid,
		Key.Invalid,
		Key.Invalid,
		Key.Backspace,
		Key.Invalid,
		Key.Invalid,
		Key.KeypadOne,
		Key.Invalid,
		Key.Left,
		Key.KeypadSeven,
		Key.Invalid,
		Key.Invalid,
		Key.Invalid,
		// 0x70
		Key.KeypadZero,
		Key.KeypadPeriod,
		Key.KeypadTwo,
		Key.KeypadFive,
		Key.KeypadSix,
		Key.KeypadEight,
		Key.Escape,
		Key.NumLock,
		Key.F11,
		Key.KeypadPlus,
		Key.KeypadThree,
		Key.KeypadMinus,
		Key.KeypadAsterisk,
		Key.KeypadNine,
		Key.ScrollLock,
		Key.Invalid,
		// 0x80
		Key.Invalid,
		Key.Invalid,
		Key.Invalid,
		Key.Invalid,
		Key.SysRq,
	];

	static int _translateScancodeEx[] = [
		0x1f: Key.LeftGui,
		0x14: Key.RightControl,
		0x27: Key.RightGui,
		0x11: Key.RightAlt,
		0x2f: Key.Application,
		0x7c: Key.PrintScreen,
		0x70: Key.Insert,
		0x6c: Key.Home,
		0x7d: Key.PageUp,
		0x71: Key.Delete,
		0x69: Key.End,
		0x7a: Key.PageDown,
		0x75: Key.Up,
		0x6b: Key.Left,
		0x72: Key.Down,
		0x74: Key.Right,
		0x4a: Key.KeypadForeslash,
		0x5a: Key.KeypadReturn
	];

	Event event;

	switch(uMsg) {
		case WM_ERASEBKGND:
		case WM_UNICHAR:
			return 1;

		case WM_MOVE:
			return 1;

		case WM_PAINT:
			if (dialog !is null) {
				PAINTSTRUCT ps;
				HDC dc = BeginPaint(hWnd, &ps);
				MARGINS margins;

				RECT rt;
				GetClientRect(windowVars.hWnd, &rt);

				margins.cxLeftWidth = rt.left;
				margins.cxRightWidth = rt.right;
				margins.cyBottomHeight = rt.bottom;
				margins.cyTopHeight = rt.top;

				BLENDFUNCTION bf;
				bf.BlendOp = AC_SRC_OVER;
				bf.BlendFlags = 0;
				bf.SourceConstantAlpha = 255;
				bf.AlphaFormat = AC_SRC_ALPHA;

//				DwmExtendFrameIntoClientArea(windowVars.hWnd, &margins);
				HBRUSH brsh = CreateSolidBrush(0);
				FillRect(ps.hdc, &rt, brsh);
				AlphaBlend(ps.hdc, 
						0, 0, cast(int)windowVars.window.width(), cast(int)windowVars.window.height(),
						windowVars.backbuffer, 
						0, 0, cast(int)windowVars.window.width(), cast(int)windowVars.window.height(), 
						bf);


//				BitBlt(ps.hdc, 0, 0, cast(int)dialog.width, cast(int)dialog.height, windowVars.backbuffer, 0, 0, SRCCOPY);
				EndPaint(hWnd, &ps);
			}
			return 1;

		case WM_SYSCOMMAND:
			if (wParam == SC_CLOSE) {
				event.type = Event.Close;
				windowVars.eventQueue.add(event);
				return 1;
			}
			break;

		case WM_LBUTTONDOWN:
		case WM_RBUTTONDOWN:
		case WM_MBUTTONDOWN:
			event.type = Event.MouseDown;
			if (uMsg == WM_LBUTTONDOWN) {
				event.aux = 0;
			}
			else if (uMsg == WM_RBUTTONDOWN) {
				event.aux = 1;
			}
			else {
				event.aux = 2;
			}

			SetFocus(hWnd);
			SetCapture(hWnd);

			int x, y;
			x = lParam & 0xffff;
			y = (lParam >> 16)& 0xffff;

			event.info.mouse.x = x;
			event.info.mouse.y = y;

			windowVars.eventQueue.add(event);
			return 1;

		case WM_LBUTTONUP:
		case WM_RBUTTONUP:
		case WM_MBUTTONUP:
			event.type = Event.MouseUp;
			if (uMsg == WM_LBUTTONUP) {
				event.aux = 0;
			}
			else if (uMsg == WM_RBUTTONUP) {
				event.aux = 1;
			}
			else {
				event.aux = 2;
			}

			ReleaseCapture();

			int x, y;
			x = lParam & 0xffff;
			event.info.mouse.x = x;
			y = (lParam >> 16) & 0xffff;
			event.info.mouse.y = y;

			windowVars.eventQueue.add(event);
			return 1;

		case WM_MOUSEWHEEL:
		case WM_MOUSEHWHEEL:
			if (uMsg == WM_MOUSEWHEEL) {
				event.type = Event.MouseWheelY;
			}
			else {
				event.type = Event.MouseWheelX;
			}

			short count = cast(short)((wParam >> 16) & 0xffff);
			auto counts_per_tick = cast(double)WHEEL_DELTA;
			event.resolution = cast(double)count / counts_per_tick;

			int x, y;
			x = lParam & 0xffff;
			event.info.mouse.x = x;
			y = (lParam >> 16) & 0xffff;
			event.info.mouse.y = y;

			windowVars.eventQueue.add(event);
			return 1;

		case WM_MOUSEMOVE:
			event.type = Event.MouseMove;
			int x, y;
			x = lParam & 0xffff;
			event.info.mouse.x = x;
			y = (lParam >> 16) & 0xffff;
			event.info.mouse.y = y;

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

			windowVars.eventQueue.add(event);
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
				//SendMessageW(hWnd, WM_MOUSELEAVE, 0,0);
			}
			return 1;

		// Custom event that is triggered when the cursor leaves the window
		case WM_MOUSELEAVE:
			event.type = Event.MouseLeave;
			windowVars.eventQueue.add(event);
			return 1;

		case WM_SYSKEYDOWN:
		case WM_SYSKEYUP:
			// Detect a system command.
			if ((lParam & (1 << 29)) > 0) {
				// ALT is pressed with another key
				if (wParam == VK_F4) {
					// ALT+F4
					break;
				}
			}

			// Follow through to catch the key press / release

		case WM_KEYDOWN:
		case WM_KEYUP:
			if (uMsg == WM_KEYDOWN || uMsg == WM_SYSKEYDOWN) {
				event.type = Event.KeyDown;
			}
			else {
				event.type = Event.KeyUp;
			}

			// Get the scancode from the OEM section in LPARAM
			// This should be something from scan code set 1
			event.info.key.scan = ((lParam >> 16) & 0xff);

			event.info.key.scan += ((lParam & (1 << 24)) * 0xe000);

		//	printf("invalid key: %x\n", event.info.key.scan);
			if (event.info.key.scan == 0x45) {
				// PAUSE (Incorrect on windows)
				event.info.key.scan = 0xe11477;
			}
			else if (event.info.key.scan == 0xe045) {
				// NUMLOCK (Incorrect on windows)
				event.info.key.scan = 0x77;
			}
			else {
				// Translate to scan code set 2
				if (lParam & (1 << 24)) {
					// Extended key (scan code is prefixed by 0xe0)
					event.info.key.scan = _set1ExToSet2[(event.info.key.scan & 0xff)];
				}
				else {
					event.info.key.scan = _set1ToSet2[event.info.key.scan];
				}
			}

			if (event.info.key.scan == 0xe11477) {
				event.info.key.code = Key.Pause;
			}
			else if (event.info.key.scan < _translateScancode.length) {
				event.info.key.code = _translateScancode[event.info.key.scan];
			}
			else if (event.info.key.scan > 0xe000) {
				event.info.key.code = _translateScancodeEx[event.info.key.scan & 0xff];
			}

			event.info.key.leftControl = GetKeyState(VK_LCONTROL) < 0;
			event.info.key.rightControl = GetKeyState(VK_RCONTROL) < 0;
			event.info.key.shift = GetKeyState(VK_SHIFT) < 0;
			event.info.key.rightAlt = GetKeyState(VK_RMENU) < 0;
			event.info.key.leftAlt = GetKeyState(VK_LMENU) < 0;
			event.info.key.capsLock = (GetKeyState(VK_CAPITAL) & 1) == 1;

			windowVars.eventQueue.add(event);
			return 1;

		case WM_USER_REDRAW:
			return 1;

		default:
			break;
	}

	return DefWindowProcW(hWnd, uMsg, wParam, lParam);
}
