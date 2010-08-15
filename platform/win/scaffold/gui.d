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
	printf("chbmp = %d\n", Gdiplus.GdipCreateHBITMAPFromBitmap(viewVars.image, &hbm, 0));
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
		ret = GetMessage(&msg, null, 0, 0);
		if (ret != -1) {
			TranslateMessage(&msg);
			DispatchMessage(&msg);
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

			//SetWindowLongW(hWnd, GWLP_WNDPROC, cast(LONG)&WindowProc);
			SetWindowLongW(hWnd, GWLP_USERDATA, cast(LONG)cs.lpCreateParams);

			break;

		case WM_ERASEBKGND:
		case WM_UNICHAR:
			return 1;

		default:
			return DefWindowProcW(hWnd, uMsg, wParam, lParam);
	}

	return 0;
}

//extern(Windows) int WindowProc(HWND hWnd, uint uMsg, WPARAM wParam, LPARAM lParam);