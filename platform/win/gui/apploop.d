/*
 * apploop.d
 *
 * This is the Windows GUI apploop.
 *
 * Author: Dave Wilkinson
 * Originated: July 20th, 2009
 *
 */

module gui.apploop;

pragma(lib, "comctl32.lib");

import binding.win32.windef;
import binding.win32.winnt;
import binding.win32.winbase;
import binding.win32.wingdi;
import binding.win32.winuser;
import binding.win32.winerror;

import Gdiplus = binding.win32.gdiplus;

import binding.win32.uxtheme;

import platform.win.widget;
import platform.win.main;

import scaffold.console;

import platform.application;

import platform.vars.window;
import platform.vars.font;
import platform.vars.view;

import gui.application;
import gui.window;

import resource.menu;

import opengl.window;

import graphics.view;
import graphics.font;

import core.application;
import core.definitions;

import io.console;

class GuiApplicationController {

	// The initial entry for the gui application
	this() {
		// Initialize GDI+
		Gdiplus.GdiplusStartupInput gdiplusStartupInput;
		Gdiplus.GdiplusStartup(&gdiplusToken, &gdiplusStartupInput, null);
	}

	void start() {

		// Register the class that a window will be created with
		registerWindowClass();

		// Recognize theme information
		loadThemingData();

		// Hooks

		ubyte* bleh; uint dontcare;

		//Hook("USER32.DLL\0"c.ptr, "BeginPaint\0"c.ptr, syscall_BeginPaint, bleh, cast(void*)&HookBeginPaint);
		//pBeginPaint = cast(BeginPaintFunc)bleh;
		//Hook("USER32.DLL\0"c.ptr, "EndPaint\0"c.ptr, syscall_EndPaint, bleh, cast(void*)&HookEndPaint);
		//pEndPaint = cast(EndPaintFunc)bleh;
		//Hook("USER32.DLL\0"c.ptr, "IsWindowVisible\0"c.ptr, syscall_IsWindowVisible, bleh, cast(void*)&HookIsWindowVisible);
		//pIsWindowVisible = cast(IsWindowVisibleFunc)bleh;

		//Hook("USER32.DLL\0"c.ptr, "WindowFromPoint\0"c.ptr, dontcare, bleh, cast(void*)&HookWindowFromPoint);
		//Hook("USER32.DLL\0"c.ptr, "GetWindowRect\0"c.ptr, dontcare, bleh, cast(void*)&HookGetWindowRect);
		//Hook("USER32.DLL\0"c.ptr, "GetClientRect\0"c.ptr, dontcare, bleh, cast(void*)&HookGetClientRect);

		Hook("UXTHEME.DLL\0"c.ptr, "BufferedPaintRenderAnimation\0"c.ptr, dontcare, bleh, cast(void*)&HookBufferedPaintRenderAnimation);
		pBufferedPaintRenderAnimation = cast(void*)bleh;
		/*Hook("UXTHEME.DLL\0"c.ptr, "BeginBufferedPaint\0"c.ptr, dontcare, bleh, cast(void*)&HookBeginBufferedPaint);
		pBeginBufferedPaint = cast(void*)bleh;
		Hook("UXTHEME.DLL\0"c.ptr, "EndBufferedAnimation\0"c.ptr, dontcare, bleh, cast(void*)&HookEndBufferedAnimation);
		pEndBufferedAnimation = cast(void*)bleh;
		Hook("UXTHEME.DLL\0"c.ptr, "BeginBufferedAnimation\0"c.ptr, dontcare, bleh, cast(void*)&HookBeginBufferedAnimation);
		pBeginBufferedAnimation = cast(void*)bleh;*/

		mainloop();
	}

	void end(uint code) {
		Gdiplus.GdiplusShutdown(gdiplusToken);

		_appEnd = true;

		ApplicationController.instance.exitCode = code;
	}

private:

	// GDI+ Instance
	ULONG_PTR gdiplusToken;

	bool _appEnd = false;

	const int WM_MOUSECAPTURE = 0xffff;

	const wchar[] djehutyClassName = "djehutyApp\0"w;

	void registerWindowClass() {
		WNDCLASSW wc;
		wc.lpszClassName = djehutyClassName.ptr;
		wc.style = CS_PARENTDC;//CS_OWNDC;//| CS_HREDRAW | CS_VREDRAW;
		wc.lpfnWndProc = &DefaultProc;
		wc.hInstance = null;
		wc.hIcon = LoadIconA(cast(HINSTANCE) null, IDI_APPLICATION);
		wc.hCursor = LoadCursorA(cast(HINSTANCE) null, IDC_CROSS);
		wc.hbrBackground = cast(HBRUSH) (COLOR_WINDOW + 1);
		wc.lpszMenuName = null;
		wc.cbClsExtra = wc.cbWndExtra = 0;
		auto a = RegisterClassW(&wc);
		assert(a);
	}

	void mainloop() {

		// HOW AWFUL IS THIS: ?!

		while(!_appEnd) {
			Sleep(1);
		}

		// THIS CODE PRINTS TO THE CONSOLE WINDOW USING GDI

		/*HWND hwndConsole = GetConsoleWindow();
		HDC dc = GetDC(hwndConsole);

		CONSOLE_FONT_INFO cfi ;
		COORD fsize ;
		HANDLE hConsoleOut = GetStdHandle(STD_OUTPUT_HANDLE);

		GetCurrentConsoleFont(hConsoleOut, FALSE, &cfi);

		Font fnt = new Font("Terminal", 10, 400, false, false, false);
		FontPlatformVars* fvars = FontGetPlatformVars(fnt);

		SetBkMode(dc, OPAQUE);
		SetBkColor(dc, 0x339933);
		SetTextColor(dc, 0xf800f8);

		SelectObject(dc, fvars.fontHandle);
*/
		ConsoleUninit();

		ApplicationController.instance.end;
	}

static:

	int win_osVersion = -1;

	alias extern(C) HDC function(HWND, LPPAINTSTRUCT) BeginPaintFunc;
	BeginPaintFunc pBeginPaint;
	uint syscall_BeginPaint;
	
	alias extern(C) BOOL function(HWND, LPPAINTSTRUCT) EndPaintFunc;
	EndPaintFunc pEndPaint;
	uint syscall_EndPaint;
	
	alias extern(C) BOOL function(HWND) IsWindowVisibleFunc;
	IsWindowVisibleFunc pIsWindowVisible;
	uint syscall_IsWindowVisible;

	void* pBufferedPaintRenderAnimation;
	void* pBeginBufferedPaint;
	void* pEndBufferedAnimation;
	void* pBeginBufferedAnimation;

	bool Hook(char* mod, char* proc, ref uint syscall_id, ref ubyte* pProc, void* pNewProc) {
	    HINSTANCE hMod = GetModuleHandleA(mod);

	    if (hMod is null) {
			hMod = LoadLibraryA(mod);
			Console.putln("not loaded");
		    if (hMod is null) {
				Console.putln("bad");
				return false;
			}
		}

	    pProc = cast(ubyte*)GetProcAddress(hMod, proc);

	    if (pProc is null) {
			Console.putln("procnotfound");
			return false;
	    }

	    ubyte[5] oldCode;
	    oldCode[0..5] = pProc[0..5];

	    if ( true || pProc[0] == 0xB8 ) {
	        syscall_id = *cast(uint*)(pProc + 1);

	        DWORD flOldProtect;

	        VirtualProtect(pProc, 5, PAGE_EXECUTE_READWRITE, & flOldProtect);

	        pProc[0] = 0xE9;
	        *cast(uint*)(pProc+1) = cast(uint)pNewProc - cast(uint)(pProc+5);

	        pProc += 5;

	        VirtualProtect(pProc, 5, flOldProtect, & flOldProtect);

	        return true;
	    }
	    else {
	        return false;
		}
	}

	extern(C) HDC HookBeginPaint(HWND hWnd, LPPAINTSTRUCT lpPaint) {

		HDC ret;

		// normal operations:

		// abnormal operations:
/*		if (hWnd != button_hWnd) {
			asm {
		        mov     EAX, syscall_BeginPaint;
		        push    lpPaint;
		        push    hWnd;
				call    pBeginPaint;
		        mov		ret, EAX;
			}
			return ret;
		}*/

		lpPaint.fErase = 0;
		
		lpPaint.rcPaint.left = 0;
//		lpPaint.rcPaint.right = button_width;
		lpPaint.rcPaint.top = 0;
	//	lpPaint.rcPaint.bottom = button_height;

		lpPaint.fIncUpdate = 0;
		lpPaint.fRestore = 0;

//		lpPaint.hdc = button_hdc;

		return null; //button_hdc;
	}
	
	extern(C) BOOL HookIsWindowVisible() {	
		asm {
			naked;
			mov EAX, 1;
			ret 4;
		}	
	}
	
	extern(C) BOOL HookWindowFromPoint(POINT pnt) {
		asm {
			naked;
//			mov EAX, button_hWnd;
			ret 8;
		}
	}
	
	extern(C) BOOL HookGetWindowRect(HWND hWnd, RECT* rt) {
		Console.putln("GetWindowRect ", hWnd);
		if (rt !is null) {
//			rt.left = button_x;
//			rt.right = button_x + button_width;
			rt.top = 299;
	//		rt.bottom = 299 + button_height;
		}
		
		asm {
			mov EAX, 1;
		}
		
		return 1;
	}
	
	extern(C) BOOL HookGetClientRect(HWND hWnd, RECT* rt) {
		asm {
			naked;
			mov EAX, 1;
			ret 8;
		}
	}

	void HookBeginPaintImpl() {
		asm {
			mov EAX, syscall_BeginPaint;
			call pBeginPaint;
			ret;
		}
	}

	template UXThemePrologue() {
		const char[] UXThemePrologue =
		`
			asm {
				naked;

				mov		EDI,EDI;
				push	EBP;
				mov		EBP,ESP;
			}
			`;
	}

	extern(C) void HookBeginBufferedPaint() {

		mixin(UXThemePrologue!());
		//Console.putln("BeginBufferedPaint");

		asm {
	        jmp		pBeginBufferedPaint;
		}

		return;
	}

	extern(C) void HookBeginBufferedAnimation() {

		mixin(UXThemePrologue!());

		//Console.putln("BeginBufferedAnimation");
		asm {
			//mov EAX, button_hdc;
			//mov [EBP+12], EAX;
		}

		asm {
	        jmp		pBeginBufferedAnimation;
		}

		return;
	}

	extern(C) void HookEndBufferedAnimation() {

		mixin(UXThemePrologue!());

		//Console.putln("EndBufferedAnimation");

		asm {
	        jmp		pEndBufferedAnimation;
		}

		return;
	}

	extern(C) void HookBufferedPaintRenderAnimation(HWND hWnd, HDC hdcTarget) {

		mixin(UXThemePrologue!());

		void* ctrl_in = cast(void*)GetWindowLongW(hWnd, GWLP_USERDATA);

		if (ctrl_in !is null) {
			WinWidget _ctrlvars = cast(WinWidget)ctrl_in;
			hdcTarget = GetBaseDC(_ctrlvars);
		}

	//	asm {
	//			mov EAX, button_hdc;
	//			mov [EBP+12], EAX;
	//	}

		asm {
	        jmp		pBufferedPaintRenderAnimation;
		}

		return;
	}

	extern(C) BOOL HookEndPaint(HWND hWnd, LPPAINTSTRUCT lpPaint) {
		// abnormal operations:
//		if (hWnd == button_hWnd) {
			//Console.putln("End Paint");
	//		return true;
	//	}

		// normal operations:
		asm {
	        mov     EAX, syscall_EndPaint;
	        push    lpPaint;
	        push    hWnd;
	        call    pEndPaint;
		}
	}

	extern(Windows)
	int DefaultProc(HWND hWnd, uint uMsg, WPARAM wParam, LPARAM lParam) {
	//			Console.putln("def proc");
		CREATESTRUCTW* cs = cast(CREATESTRUCTW*)lParam;

		if (uMsg == WM_CREATE) {
			Window w = cast(Window)cs.lpCreateParams;

			SetWindowLongW(hWnd, GWLP_WNDPROC, cast(LONG)&WindowProc);
			SetWindowLongW(hWnd, GWLP_USERDATA, cast(LONG)cs.lpCreateParams);

			return 0;
		}
		else if (uMsg == WM_UNICHAR) {
			return 1;
		}

		return DefWindowProcW(hWnd, uMsg, wParam, lParam);
	}

	extern(Windows)
	int CtrlProc(HWND hWnd, uint uMsg, WPARAM wParam, LPARAM lParam) {
	//			Console.putln("ctrl proc");
		void* ctrl_in = cast(void*)GetWindowLongW(hWnd, GWLP_USERDATA);

		if (ctrl_in !is null) {
			WinWidget _ctrlvars = cast(WinWidget)ctrl_in;

			return CallAppLoopMessage(_ctrlvars, uMsg, wParam, lParam);
		}

		return 0;
	}

	void _TestNumberOfClicks(ref Window w, ref WindowPlatformVars* windowVars, int x, int y, int clickType) {
		//check for double click first and within close proximity
		//of the last click

		if (windowVars.doubleClickTimerSet != 0) {
			KillTimer(windowVars.hWnd, 1);
		}

		// checks whether within tolerance region
		if ( (windowVars.doubleClickTimerSet == clickType) &&
			(x <= windowVars.doubleClickX + 1) &&
			(x >= windowVars.doubleClickX - 1) &&
			(y <= windowVars.doubleClickY + 1) &&
			(y >= windowVars.doubleClickY - 1) ) {

			// disable timer, inside tolerance
			windowVars.doubleClickAmount++;

			KillTimer(windowVars.hWnd, 1);
		}
		else {
			//reset timer stats, start over with one click
			windowVars.doubleClickTimerSet = clickType;
			windowVars.doubleClickAmount = 1;
		}

		//set up double click tolerance region
		windowVars.doubleClickX = x;
		windowVars.doubleClickY = y;

		SetTimer(windowVars.hWnd, 1, GetDoubleClickTime(), null);

		w.mouseProps.clicks = windowVars.doubleClickAmount;
	}

	void _TestNumberOfClicksUp(ref Window w, ref WindowPlatformVars* windowVars, int clickType) {

		if (windowVars.doubleClickTimerSet == clickType) {
			//double click may have occured
			w.mouseProps.clicks = windowVars.doubleClickAmount;
		}
		else {
			w.mouseProps.clicks = 1;
		}
	}

	bool win_hasVisualStyles = false;
	HFONT win_button_font;

	HMODULE win_uxThemeMod;

	// Theming Libraries
	extern (Windows) alias HTHEME (*OpenThemeDataFunc)(HWND, LPCWSTR);
	extern (Windows) alias HRESULT (*GetThemeSysFontFunc)(HTHEME, int, LOGFONTW*);
	extern (Windows) alias HRESULT (*CloseThemeDataFunc)(HTHEME);

	OpenThemeDataFunc OpenThemeDataDLL;
	GetThemeSysFontFunc GetThemeSysFontDLL;
	CloseThemeDataFunc CloseThemeDataDLL;

	void loadThemingData() {
		const int TMT_MSGBOXFONT = 805;

		// Do we have visual styles?
		// Load the theming library: uxTheme, if applicable

		if (win_osVersion >= OsVersionWindowsXp) {
			//using visual styles
			//look up uxTheme.dll

			win_uxThemeMod = LoadLibraryW("UxTheme.DLL");

			if (win_uxThemeMod == null) {
				//does not exist...
				win_hasVisualStyles = false;
			}
			else {
				//get proc addresses of important functions
				OpenThemeDataDLL = cast(OpenThemeDataFunc)GetProcAddress(win_uxThemeMod, "OpenThemeData");
				CloseThemeDataDLL = cast(CloseThemeDataFunc)GetProcAddress(win_uxThemeMod, "CloseThemeData");
				GetThemeSysFontDLL = cast(GetThemeSysFontFunc)GetProcAddress(win_uxThemeMod, "GetThemeSysFont");

				//apply visual styles if the application is allowed
				win_hasVisualStyles = true;
			}
		}
		else {
			//no visual styles
			win_uxThemeMod = null;

			win_hasVisualStyles = false;
		}

		HDC dcz = GetDC(null);

		if (win_hasVisualStyles) {
			HTHEME hTheme;
			hTheme = OpenThemeDataDLL(null, "WINDOW");

			LOGFONTW lfnt = { 0 };

			HRESULT hr = GetThemeSysFontDLL(hTheme, TMT_MSGBOXFONT, &lfnt);

			if (hr != S_OK) {
				win_button_font = CreateFontW(-MulDiv(8, GetDeviceCaps(dcz, 90), 72), 0, 0, 0, 400, false, false, false, DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, PROOF_QUALITY, DEFAULT_PITCH, "Microsoft Sans Serif");
			}
			else {
				win_button_font = CreateFontIndirectW(&lfnt);
			}

			CloseThemeDataDLL(hTheme);
		}
		else {
			win_button_font = CreateFontW(-MulDiv(8, GetDeviceCaps(dcz, 90), 72),0,0,0, 400, false, false, false, DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, PROOF_QUALITY, DEFAULT_PITCH, "MS Sans Serif");
		}

		ReleaseDC(null, dcz);
	}

	extern(Windows)
	static int WindowProc(HWND hWnd, uint uMsg, WPARAM wParam, LPARAM lParam) {

		// resolve the window class reference:
		void* wind_in = cast(void*)GetWindowLongW(hWnd, GWLP_USERDATA);
		Window w = cast(Window)(wind_in);

		WindowPlatformVars* windowVars = &w._pfvars;

		Window viewW;

		int ret = IsWindowUnicode(windowVars.hWnd);

		if (true) {
			viewW = cast(Window)w;
		}
		else {
			viewW = null;
		}

		switch (uMsg) {

			// FOR CONTROLS AND MENUS //

			case WM_VSCROLL:
			case WM_HSCROLL:
			case WM_COMMAND:

				if (lParam == 0) {
					// menu

					Menu mnuNow = cast(Menu)cast(void*)wParam;

					if (viewW !is null) {
						viewW.onMenu(mnuNow);
					}
				}
				else {
					// native control

					wind_in = cast(void*)GetWindowLongW(cast(HWND)lParam, GWLP_USERDATA);

					WinWidget ctrl = cast(WinWidget)wind_in;

					wParam &= 0xFFFF;

	//				ctrl._AppLoopMessage(uMsg, wParam, lParam);
					return CallAppLoopMessage(ctrl, uMsg, wParam, lParam);
				}

				break;

			case WM_CTLCOLORDLG:
			case WM_CTLCOLORBTN:
			case WM_CTLCOLORSTATIC:

			/*	Console.putln("ctrl back");

				wind_in = cast(void*)GetWindowLongW(cast(HWND)lParam, GWLP_USERDATA);

				WinWidget ctrl = cast(WinWidget)wind_in;

				// SET FOREGROUND AND BACKGROUND COLORS FOR CONTROLS HERE:
				// TO SUPPORT BACKGROUND AND FOREGROUND CHANGES

		        SetBkMode(cast(HDC)wParam, TRANSPARENT);

				// Lock Display

				int x, y, width, height;

				View ctrl_view = CallReturnView(ctrl,x,y,width,height); //ctrl._ReturnView(x, y, width, height);

				if (!indraw) {
					ctrl_view.lockDisplay();
				}

				ViewPlatformVars* viewVars = ViewGetPlatformVars(ctrl_view);

				BitBlt(
					cast(HDC)wParam,
					0, 0,
					width, height,
					viewVars.dc,
					x, y,
					SRCCOPY);

				if (!indraw) {
					ctrl_view.unlockDisplay();
				}*/

		        return cast(LRESULT)GetStockObject(NULL_BRUSH);

			case WM_DRAWITEM:
				DRAWITEMSTRUCT* pDIS = cast(DRAWITEMSTRUCT*)lParam;

				View view = w._view;
				ViewPlatformVars* viewVars = w._viewVars;
				
				RECT rt;
				GetClientRect(pDIS.hwndItem, &rt);
				BitBlt(pDIS.hDC, 0, 0, w.width, w.height, viewVars.dc, 0, 0, SRCCOPY);
				//Rectangle(pDIS.hDC, 0, 0, rt.right, rt.bottom);
				break;
				
			case WM_ERASEBKGND:

				break;

			case WM_PAINT:

				View view = w._view;
				ViewPlatformVars* viewVars = w._viewVars;

				viewW.onDraw();

				view.lockDisplay();
				PAINTSTRUCT ps;
				HDC dc = BeginPaint(hWnd, &ps);

				BitBlt(ps.hdc, 0, 0, w.width, w.height, viewVars.dc, 0, 0, SRCCOPY);

				EndPaint(hWnd, &ps);

				view.unlockDisplay();

				break;

		    case WM_DESTROY:

				w.uninitialize();
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
					w.onLostFocus();
				}
				else if (x == WA_ACTIVE || x == WA_CLICKACTIVE) {
					//gaining focus
					w.onGotFocus();
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
				w.mouseProps.x = x;
				y = (lParam >> 16) & 0xffff;
				w.mouseProps.y = y;

				w.mouseProps.leftDown = true;
				w.mouseProps.rightDown = ((wParam & MK_RBUTTON) > 0);
				w.mouseProps.middleDown = ((wParam & MK_MBUTTON) > 0);

				_TestNumberOfClicks(w,windowVars,x,y,1);

				w.onPrimaryMouseDown();
				break;

			case WM_LBUTTONUP:

				ReleaseCapture();

				//window.mouseProps.rightDown = 0;

				//check for double click first
				_TestNumberOfClicksUp(w,windowVars,1);

				//fill _mouseProps
				int x, y;
				x = lParam & 0xffff;
				w.mouseProps.x = x;
				y = (lParam >> 16) & 0xffff;
				w.mouseProps.y = y;

				w.mouseProps.leftDown = false;
				w.mouseProps.rightDown = ((wParam & MK_RBUTTON) > 0);
				w.mouseProps.middleDown = ((wParam & MK_MBUTTON) > 0);

				w.onPrimaryMouseUp();
				break;

			case WM_RBUTTONDOWN:

				SetFocus(hWnd);
				SetCapture(hWnd);

				// FILL THE MOUSEPROPERTIES STRUCTURE FOR THE WINDOW

				//w.mouseProps.rightDown = 1;

				//check bounds for the controls

				int x, y;
				x = lParam & 0xffff;
				w.mouseProps.x = x;
				y = (lParam >> 16) & 0xffff;
				w.mouseProps.y = y;

				w.mouseProps.leftDown = ((wParam & MK_LBUTTON) > 0);
				w.mouseProps.rightDown = true;
				w.mouseProps.middleDown = ((wParam & MK_MBUTTON) > 0);

				_TestNumberOfClicks(w,windowVars,x,y,2);

				w.onSecondaryMouseDown();
				break;

			case WM_RBUTTONUP:

				ReleaseCapture();
				//window.mouseProps.rightDown = 0;

				//check for double click first
				_TestNumberOfClicksUp(w,windowVars,2);

				//fill _mouseProps
				int x, y;
				x = lParam & 0xffff;
				w.mouseProps.x = x;
				y = (lParam >> 16) & 0xffff;
				w.mouseProps.y = y;

				w.mouseProps.leftDown = ((wParam & MK_LBUTTON) > 0);
				w.mouseProps.rightDown = false;
				w.mouseProps.middleDown = ((wParam & MK_MBUTTON) > 0);

				w.onSecondaryMouseUp();
				break;

			case WM_MBUTTONDOWN:

				SetFocus(hWnd);
				SetCapture(hWnd);

				// FILL THE MOUSEPROPERTIES STRUCTURE FOR THE WINDOW

				//w.mouseProps.rightDown = 1;

				//check bounds for the controls

				int x, y;
				x = lParam & 0xffff;
				w.mouseProps.x = x;
				y = (lParam >> 16) & 0xffff;
				w.mouseProps.y = y;

				w.mouseProps.leftDown = ((wParam & MK_LBUTTON) > 0);
				w.mouseProps.rightDown = ((wParam & MK_RBUTTON) > 0);
				w.mouseProps.middleDown = true;

				_TestNumberOfClicks(w,windowVars,x,y,3);

				w.onTertiaryMouseDown();
				break;

			case WM_MBUTTONUP:

				ReleaseCapture();
				//window.mouseProps.rightDown = 0;

				//check for double click first
				_TestNumberOfClicksUp(w,windowVars,3);

				//fill _mouseProps
				int x, y;
				x = lParam & 0xffff;
				w.mouseProps.x = x;
				y = (lParam >> 16) & 0xffff;
				w.mouseProps.y = y;

				w.mouseProps.leftDown = ((wParam & MK_LBUTTON) > 0);
				w.mouseProps.rightDown = ((wParam & MK_RBUTTON) > 0);
				w.mouseProps.middleDown = false;

				w.onTertiaryMouseUp();
				break;

			case WM_XBUTTONDOWN:

				SetFocus(hWnd);
				SetCapture(hWnd);

				// FILL THE MOUSEPROPERTIES STRUCTURE FOR THE WINDOW

				//w.mouseProps.rightDown = 1;

				//check bounds for the controls

				int x, y;
				x = lParam & 0xffff;
				w.mouseProps.x = x;
				y = (lParam >> 16) & 0xffff;
				w.mouseProps.y = y;

				wParam >>= 16;
				if (wParam) {
					wParam--;

					_TestNumberOfClicks(w,windowVars,x,y,4 + cast(uint)wParam);

					w.onOtherMouseDown(cast(uint)wParam);
				}
				break;

			case WM_XBUTTONUP:

				ReleaseCapture();
				//window.mouseProps.rightDown = 0;

				//fill _mouseProps
				int x, y;
				x = lParam & 0xffff;
				w.mouseProps.x = x;
				y = (lParam >> 16) & 0xffff;
				w.mouseProps.y = y;

				wParam >>= 16;
				if (wParam) {
					wParam--;

					//check for double click
					_TestNumberOfClicksUp(w,windowVars,4 + cast(uint)wParam);

					w.onOtherMouseUp(cast(uint)wParam);
				}
				break;

			case WM_MOUSEHWHEEL:

				w.onMouseWheelX(0);
				break;

			case WM_MOUSEWHEEL:
	
				w.onMouseWheelY(0);
				break;

			case WM_MOUSEMOVE:

				int x, y;
				x = lParam & 0xffff;
				w.mouseProps.x = x;
				y = (lParam >> 16) & 0xffff;
				w.mouseProps.y = y;
			//	Console.putln("mouse move window! x:", x, "y:", y);

				w.mouseProps.leftDown = ((wParam & MK_LBUTTON) > 0);
				w.mouseProps.rightDown = ((wParam & MK_RBUTTON) > 0);
				w.mouseProps.middleDown = ((wParam & MK_MBUTTON) > 0);

				if (windowVars.hoverTimerSet==0) {
					SetTimer(hWnd, 0, 55, null);
					windowVars.hoverTimerSet = 1;
				}

				w.onMouseMove();
				break;

				// Internal Timing Functions
			case WM_MOUSELEAVE:
				w.onMouseLeave();
				break;

			case WM_MOUSECAPTURE: //made up event
				if (windowVars.hoverTimerSet == 1) {
					KillTimer(hWnd, 0);
					windowVars.hoverTimerSet = 0;
				}

				SetCapture(hWnd);
				break;

			case WM_MOVE:

				RECT rt;
				GetWindowRect(hWnd, &rt);

				if (!windowVars.supress_WM_MOVE) {
					w._x = rt.left;
					w._y = rt.top;

					w.onMove();
					windowVars.supress_WM_MOVE = false;
				}
				break;

			case WM_KEYDOWN:

				Key key;
				key.code = cast(uint)wParam;
				w.onKeyDown(key);

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

				w.onKeyChar(cast(dchar)wParam);

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

				w.onKeyChar(cast(dchar)wParam);

				break;

			case WM_KEYUP:

				Key key;
				key.code = cast(uint)wParam;
				w.onKeyUp(key);

				break;

			case WM_SIZE:

				RECT rt;
				GetClientRect(hWnd, &rt);

				if (!windowVars.supress_WM_SIZE) {
					w._width = rt.right;
					w._height = rt.bottom;

					w.onResize();

					if (cast(GLWindow)w !is null) {
						windowVars.gameLoopCallResize();
					}

					windowVars.supress_WM_SIZE = false;
				}

				// was it minimized? maximized?

				if (w.state != WindowState.Fullscreen) {
					if (wParam == SIZE_MAXIMIZED && w.state != WindowState.Minimized) {
						if (!windowVars.supress_WM_SIZE_state) {
							w.state = WindowState.Maximized;
							w.onStateChange();
							windowVars.supress_WM_SIZE_state = false;
						}
					}
					else if (wParam == SIZE_MINIMIZED && w.state != WindowState.Maximized) {
						if (!windowVars.supress_WM_SIZE_state) {
							w.state = WindowState.Minimized;
							w.onStateChange();
							windowVars.supress_WM_SIZE_state = false;
						}
					}
					else if (wParam == SIZE_RESTORED && w.state != WindowState.Normal) {
						if (!windowVars.supress_WM_SIZE_state) {
							w.state = WindowState.Normal;
							w.onStateChange();
							windowVars.supress_WM_SIZE_state = false;
						}
					}
				}
	
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
						pnt[1].x = w.width-1;
						pnt[1].y = w.height-1;

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

				// These are Djehuty Protocol Requests
				// They do not belong in the final release

			case WM_USER + 0xff00:

				SendMessageW(cast(HWND)lParam, WM_USER+0xf000, 0,0);
				break;

			case WM_USER + 0xff01:

			// create window 1

			// p1 : width
			// p2 : height
				break;

			case WM_USER + 0xff02:

			// create window 2

			// p1: x
			// p2: y
				break;

			default:

				return DefWindowProcW(hWnd, uMsg, wParam, lParam);
		}

		return 0;
	}
}