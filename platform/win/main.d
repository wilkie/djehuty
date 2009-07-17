/*
 * main.d
 *
 * This file has the main functionality to start an Application in Windows.
 * This file has the entry point for a Windows program.
 *
 * Author: Dave Wilkinson
 *
 */

module platform.win.main;

import platform.win.console;
import platform.win.common;
import platform.win.vars;
import platform.win.widget;

import graphics.view;
import graphics.font;

import core.main;
import core.definitions;
import core.string;
import core.unicode;

import io.console;

import gui.window;
import gui.menu;

import opengl.window;

import synch.thread;

import analyzing.debugger;

import tui.application;
import tui.window;

import std.stdio;
import std.thread;

const int WM_MOUSECAPTURE = 0xffff;

const wchar[] djehutyClassName = "djehutyApp\0"w;

bool win_hasVisualStyles = false;
HFONT win_button_font;

HMODULE win_uxThemeMod;

bool console_loop = true;
uint exitCode;

const uint MI_WP_SIGNATURE = 0xFF515700;
const uint SIGNATURE_MASK = 0xFFFFFF00;

// Theming Libraries
extern (Windows) alias HTHEME (*OpenThemeDataFunc)(HWND, LPCWSTR);
extern (Windows) alias HRESULT (*GetThemeSysFontFunc)(HTHEME, int, LOGFONTW*);
extern (Windows) alias HRESULT (*CloseThemeDataFunc)(HTHEME);

OpenThemeDataFunc OpenThemeDataDLL;
GetThemeSysFontFunc GetThemeSysFontDLL;
CloseThemeDataFunc CloseThemeDataDLL;

// Console Libraries (C runtime)
//
// HMODULE win_crt;
// extern (C) alias int function(HANDLE, int) _open_osfhandle_func;
// extern (C) alias FILE* function(int, char*) _fdopen_func;
// _open_osfhandle_func _open_osfhandleDLL;
// _fdopen_func _fdopenDLL;

bool _appEnd = false;

int win_osVersion = -1;

bool Hook(char* mod, char* proc, ref uint syscall_id, ref ubyte* pProc, void* pNewProc)
{
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
	asm {
        mov     EAX, syscall_BeginPaint;
        push    lpPaint;
        push    hWnd;
		call    pBeginPaint;
        mov		ret, EAX;
	}

	// abnormal operations:
	if (hWnd == button_hWnd) {

		//Console.putln("BeginPaint");

		//lpPaint.hdc = button_hdc;
		//ret = button_hdc;
	}

	return ret;
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

extern(C) void HookBufferedPaintRenderAnimation() {

	mixin(UXThemePrologue!());

	//Console.putln("BufferedPaintRenderAnimation");

	asm {
		mov EAX, button_hdc;
		mov [EBP+12], EAX;
	}

	asm {
        jmp		pBufferedPaintRenderAnimation;
	}

	return;
}

extern(C) BOOL HookEndPaint(HWND hWnd, LPPAINTSTRUCT lpPaint) {
	// abnormal operations:
	if (hWnd == button_hWnd) {
		//Console.putln("End Paint");
//		return true;
	}

	// normal operations:
	asm {
        mov     EAX, syscall_EndPaint;
        push    lpPaint;
        push    hWnd;
        call    pEndPaint;
	}
}

void GetWindowsVersion()
{
	//get windows version
	DWORD verRet = GetVersion();

	OSVERSIONINFOEXW osvi = { 0 };
	BOOL bOsVersionInfoEx;

	// Try calling GetVersionEx using the OSVERSIONINFOEX structure.
	// If that fails, try using the OSVERSIONINFO structure.

	osvi.dwOSVersionInfoSize = OSVERSIONINFOEXW.sizeof;

	win_osVersion = -1;

	bOsVersionInfoEx = GetVersionExW (cast(OSVERSIONINFOW*)&osvi);

	if( !bOsVersionInfoEx )
	{
		osvi.dwOSVersionInfoSize = OSVERSIONINFOW.sizeof;
		if (! GetVersionExW ( cast(OSVERSIONINFOW*)&osvi) )
		{
			//error
			//just try and assume an OS version
			//lets say Win95, just in case
			win_osVersion = OsVersionWindows95;
		}
	}

	if (win_osVersion == -1)
	{
		switch (osvi.dwPlatformId)
		{
			// Test for the Windows NT product family.

			case VER_PLATFORM_WIN32_NT:

			// Test for the specific product.

			if ( osvi.dwMajorVersion == 6 && osvi.dwMinorVersion == 0 )
			{
				if( osvi.wProductType == VER_NT_WORKSTATION )
				{
					win_osVersion = OsVersionWindowsVista;
				}
				else
				{
					//will be Longhorn Server
					win_osVersion = OsVersionWindowsLonghorn;
				}
			}
			else if ( osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 2 )
			{
				if( GetSystemMetrics(89) )
				{
					//Windows Server 2003
					win_osVersion = OsVersionWindowsServer2003;
				}
				else if( osvi.wProductType == VER_NT_WORKSTATION )
				{
					//Windows XP x64
					win_osVersion = OsVersionWindowsXp;
				}
				else
				{
					//Windows Server 2003
				}
			}
			else if (osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 1)
			{
				win_osVersion = OsVersionWindowsXp;
			}
			else if (osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 0 )
			{
				win_osVersion = OsVersionWindows2000;
			}
			else if ( osvi.dwMajorVersion <= 4 )
			{
				win_osVersion = OsVersionWindowsNT;
			}
			break;

		// Test for the Windows Me/98/95.
		case VER_PLATFORM_WIN32_WINDOWS:

		if (osvi.dwMajorVersion == 4 && osvi.dwMinorVersion == 0)
		{
			win_osVersion = OsVersionWindows95;
		}

		if (osvi.dwMajorVersion == 4 && osvi.dwMinorVersion == 10)
		{
			if ( osvi.szCSDVersion[1]=='A' || osvi.szCSDVersion[1]=='B')
			{
				win_osVersion = OsVersionWindows98Se;
			}
			else
			{
				win_osVersion = OsVersionWindows98;
			}
		}

		if (osvi.dwMajorVersion == 4 && osvi.dwMinorVersion == 90)
		{
			win_osVersion = OsVersionWindowsMe;
		}
		break;

		case VER_PLATFORM_WIN32s:
			win_osVersion = OsVersionWindows95;

		break;

		default:
			win_osVersion = OsVersionWindowsMax;
		break;
		}
	}
}


const int TMT_MSGBOXFONT = 805;
void LoadThemingData()
{

	// Do we have visual styles?

	// Load the theming library: uxTheme, if applicable

	if (win_osVersion >= OsVersionWindowsXp)
	{
		//using visual styles
		//look up uxTheme.dll

		win_uxThemeMod = LoadLibraryW("UxTheme.DLL");

		if (win_uxThemeMod == null)
		{
			//does not exist...
			win_hasVisualStyles = false;
		}
		else
		{
			//get proc addresses of important functions
			//IsAppThemedDLL = (IsAppThemedFunc)GetProcAddress(Djehuty::_pfvars.uxThemeMod, "IsAppThemed");
			OpenThemeDataDLL = cast(OpenThemeDataFunc)GetProcAddress(win_uxThemeMod, "OpenThemeData");
			//DrawThemeBackgroundDLL = (DrawThemeBackgroundFunc)GetProcAddress(Djehuty::_pfvars.uxThemeMod, "DrawThemeBackground");
			//DrawThemeTextDLL = (DrawThemeTextFunc)GetProcAddress(Djehuty::_pfvars.uxThemeMod, "DrawThemeText");
			CloseThemeDataDLL = cast(CloseThemeDataFunc)GetProcAddress(win_uxThemeMod, "CloseThemeData");
			GetThemeSysFontDLL = cast(GetThemeSysFontFunc)GetProcAddress(win_uxThemeMod, "GetThemeSysFont");
			//GetThemeFontDLL = (GetThemeFontFunc)GetProcAddress(Djehuty::_pfvars.uxThemeMod, "GetThemeFont");
			//GetThemePartSizeDLL = (GetThemePartSizeFunc)GetProcAddress(Djehuty::_pfvars.uxThemeMod, "GetThemePartSize");

			//apply visual styles if the application is allowed
			win_hasVisualStyles = true;
		}
	}
	else
	{
		//no visual styles
		win_uxThemeMod = null;

		win_hasVisualStyles = false;
	}

	HDC dcz = GetDC(null);

	if (win_hasVisualStyles)
	{
		HTHEME hTheme;
		hTheme = OpenThemeDataDLL(null, "WINDOW");

		LOGFONTW lfnt = { 0 };

		HRESULT hr = GetThemeSysFontDLL(hTheme, TMT_MSGBOXFONT, &lfnt);

		if (hr != S_OK)
		{
			win_button_font = CreateFontW(-MulDiv(8, GetDeviceCaps(dcz, 90), 72), 0, 0, 0, 400, false, false, false, DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, PROOF_QUALITY, DEFAULT_PITCH, "Microsoft Sans Serif");
		}
		else
		{
			win_button_font = CreateFontIndirectW(&lfnt);
		}

		CloseThemeDataDLL(hTheme);
	}
	else
	{
		win_button_font = CreateFontW(-MulDiv(8, GetDeviceCaps(dcz, 90), 72),0,0,0, 400, false, false, false, DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, PROOF_QUALITY, DEFAULT_PITCH, "MS Sans Serif");
	}

	ReleaseDC(null, dcz);
}

extern(Windows)
int DefaultProc(HWND hWnd, uint uMsg, WPARAM wParam, LPARAM lParam)
{
//			Console.putln("def proc");
	CREATESTRUCTW* cs = cast(CREATESTRUCTW*)lParam;

	if (uMsg == WM_CREATE)
	{
		Window w = cast(Window)cs.lpCreateParams;

		SetWindowLongW(hWnd, GWLP_WNDPROC, cast(ulong)&WindowProc);
		SetWindowLongW(hWnd, GWLP_USERDATA, cast(ulong)cs.lpCreateParams);

		return 0;
	}
	else if (uMsg == WM_UNICHAR)
	{
		return 1;
	}

	return DefWindowProcW(hWnd, uMsg, wParam, lParam);
}

extern(Windows)
int CtrlProc(HWND hWnd, uint uMsg, WPARAM wParam, LPARAM lParam)
{
//			Console.putln("ctrl proc");
	void* ctrl_in = cast(void*)GetWindowLongW(hWnd, GWLP_USERDATA);

	if (ctrl_in !is null)
	{
		WinWidget _ctrlvars = cast(WinWidget)ctrl_in;

		return CallAppLoopMessage(_ctrlvars, uMsg, wParam, lParam);
	}

	return 0;
}

HWND button_hWnd;
HDC button_hdc;
int button_width;
int button_height;
int button_x;
int button_y;

bool indraw;

extern(Windows)
int WindowProc(HWND hWnd, uint uMsg, WPARAM wParam, LPARAM lParam)
{
			//Console.putln("window proc: ", new String("%x", uMsg));
	// resolve the window class reference:
	void* wind_in = cast(void*)GetWindowLongW(hWnd, GWLP_USERDATA);
	WindowHelper wHelper = cast(WindowHelper)(wind_in);
	Window w = wHelper.getWindow();

	WindowPlatformVars* windowVars = wHelper.getPlatformVars();

	Window viewW;

	int ret = IsWindowUnicode(windowVars.hWnd);

	if (true)
	{
		viewW = cast(Window)w;
	}
	else
	{
		viewW = null;
	}

	switch (uMsg)
	{

		// FOR CONTROLS //

		case WM_VSCROLL:
		case WM_HSCROLL:
		case WM_COMMAND:

			if (lParam == 0)
			{
				// menu

				Menu mnuNow = cast(Menu)cast(void*)wParam;

				if (viewW !is null)
				{
					viewW.onMenu(mnuNow);
				}
			}
			else
			{
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









		case WM_ERASEBKGND:

			break;

		case WM_PAINT:

			View* view = wHelper.getView();
			ViewPlatformVars* viewVars = ViewGetPlatformVars(*view);

			indraw = true;

			viewW.onDraw();

			view.lockDisplay();

			PAINTSTRUCT ps;
			HDC dc = BeginPaint(hWnd, &ps);
			BitBlt(ps.hdc, 0, 0, w.width, w.height, viewVars.dc, 0, 0, SRCCOPY);
			EndPaint(hWnd, &ps);

			view.unlockDisplay();

			break;

	    case WM_DESTROY:

			wHelper.uninitialize();
			break;










		/* FOCUS */



	case WM_ACTIVATE:
		int x, y;
		//activation type
		x = wParam & 0xffff;
		//minimization status
		y = (wParam >> 16) & 0xffff;

		if (x == WA_INACTIVE)
		{
			//losing focus
			w.onLostFocus();
		}
		else if (x == WA_ACTIVE || x == WA_CLICKACTIVE)
		{
			//gaining focus
			w.onGotFocus();
		}

		if (y != 0)
		{
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

			uint lp = GetMessageExtraInfo();
			if ((lp & SIGNATURE_MASK) == MI_WP_SIGNATURE)
			{
				//writefln("pen");
			}

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

			_TestNumberOfClicks(wHelper,x,y,1);

			w.onPrimaryMouseDown();
			break;

		case WM_LBUTTONUP:

			ReleaseCapture();

			//window.mouseProps.rightDown = 0;

			//check for double click first
			_TestNumberOfClicksUp(wHelper,1);

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

			_TestNumberOfClicks(wHelper,x,y,2);

			w.onSecondaryMouseDown();
			break;

		case WM_RBUTTONUP:

			ReleaseCapture();
			//window.mouseProps.rightDown = 0;

			//check for double click first
			_TestNumberOfClicksUp(wHelper,2);

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

			_TestNumberOfClicks(wHelper,x,y,3);

			w.onTertiaryMouseDown();
			break;

		case WM_MBUTTONUP:

			ReleaseCapture();
			//window.mouseProps.rightDown = 0;

			//check for double click first
			_TestNumberOfClicksUp(wHelper,3);

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
			if (wParam)
			{
				wParam--;

				_TestNumberOfClicks(wHelper,x,y,4 + cast(uint)wParam);

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
			if (wParam)
			{
				wParam--;

				//check for double click
				_TestNumberOfClicksUp(wHelper,4 + cast(uint)wParam);

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
			if (windowVars.hoverTimerSet == 1)
			{
				KillTimer(hWnd, 0);
				windowVars.hoverTimerSet = 0;
			}

			SetCapture(hWnd);
			break;






		case WM_MOVE:

			RECT rt;
			GetWindowRect(hWnd, &rt);

			if (!windowVars.supress_WM_MOVE)
			{
				wHelper.setWindowXY(rt.left, rt.top);
				w.onMove();
				windowVars.supress_WM_MOVE = false;
			}
			break;







		case WM_KEYDOWN:

			w.onKeyDown(cast(uint)wParam);

			break;

			//might have to translate these keys

		case WM_CHAR:

			if ( (wParam == KeyBackspace) ||
				 (wParam == KeyReturn) ||
				 (wParam == KeyTab) )
			{
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

			if (wParam == 0xFFFF)
			{
				return 1;
			}

			ushort stuff[2] = (cast(ushort*)&wParam)[0 .. 2];

			//printf("%x %x", stuff[0], stuff[1]);

			w.onKeyChar(cast(dchar)wParam);

			break;

		case WM_KEYUP:

			w.onKeyUp(cast(uint)wParam);

			break;












		case WM_SIZE:

			RECT rt;
			GetClientRect(hWnd, &rt);

			if (!windowVars.supress_WM_SIZE)
			{
				wHelper.setWindowSize(rt.right, rt.bottom);
				w.onResize();

				if (cast(GLWindow)w !is null) {
					windowVars.gameLoopCallResize();
				}

				windowVars.supress_WM_SIZE = false;
			}

			// was it minimized? maximized?

			if (w.state != WindowState.Fullscreen)
			{
				if (wParam == SIZE_MAXIMIZED && w.state != WindowState.Minimized)
				{
					if (!windowVars.supress_WM_SIZE_state)
					{
						wHelper.callStateChange(WindowState.Maximized);
						windowVars.supress_WM_SIZE_state = false;
					}
				}
				else if (wParam == SIZE_MINIMIZED && w.state != WindowState.Maximized)
				{
					if (!windowVars.supress_WM_SIZE_state)
					{
						wHelper.callStateChange(WindowState.Minimized);
						windowVars.supress_WM_SIZE_state = false;
					}
				}
				else if (wParam == SIZE_RESTORED && w.state != WindowState.Normal)
				{
					if (!windowVars.supress_WM_SIZE_state)
					{
						wHelper.callStateChange(WindowState.Normal);
						windowVars.supress_WM_SIZE_state = false;
					}
				}
			}

			break;

		case WM_TIMER:

			if (wParam == 0)
			{
				//Internal Timer (mouse hover)

				POINT pt;

				GetCursorPos(&pt);

				if (WindowFromPoint(pt) != hWnd)
				{
					KillTimer(hWnd, 0);
					windowVars.hoverTimerSet = 0;

					SendMessageW(hWnd, WM_MOUSELEAVE, 0,0);
				}
				else
				{
					POINT pnt[2];

					pnt[0].x = 0;
					pnt[0].y = 0;
					pnt[1].x = w.width-1;
					pnt[1].y = w.height-1;

					ClientToScreen(hWnd, &pnt[0]);
					ClientToScreen(hWnd, &pnt[1]);

					if (pt.x < pnt[0].x || pt.y < pnt[0].y || pt.x > pnt[1].x || pt.y > pnt[1].y)
					{
						KillTimer(hWnd,0);

						windowVars.hoverTimerSet = 0;

						SendMessageW(hWnd, WM_MOUSELEAVE, 0, 0);
					}
				}
				//KillTimer(hWnd, 0);
			}
			else if (wParam == 1)
			{
				//Internal Timer (double click test)
				//kill the timer
				windowVars.doubleClickTimerSet = -windowVars.doubleClickTimerSet;
				KillTimer(hWnd, 1);
			}

			break;




			// These are Djehuty Protocol Requests
			// They do not belong in the final release

		case WM_USER + 0xff00:

			writefln("found new app: %x", lParam);
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

void _TestNumberOfClicks(ref WindowHelper w, int x, int y, int clickType)
{
	WindowPlatformVars* windowVars = w.getPlatformVars();
	//check for double click first and within close proximity
	//of the last click

	if (windowVars.doubleClickTimerSet != 0)
	{
		KillTimer(windowVars.hWnd, 1);
	}

	// checks whether within tolerance region
	if ( (windowVars.doubleClickTimerSet == clickType) &&
		(x <= windowVars.doubleClickX + 1) &&
		(x >= windowVars.doubleClickX - 1) &&
		(y <= windowVars.doubleClickY + 1) &&
		(y >= windowVars.doubleClickY - 1) )
	{
		// disable timer, inside tolerance
		windowVars.doubleClickAmount++;

		KillTimer(windowVars.hWnd, 1);
	}
	else
	{
		//reset timer stats, start over with one click
		windowVars.doubleClickTimerSet = clickType;
		windowVars.doubleClickAmount = 1;
	}

	//set up double click tolerance region
	windowVars.doubleClickX = x;
	windowVars.doubleClickY = y;

	SetTimer(windowVars.hWnd, 1, GetDoubleClickTime(), null);

	w.getWindow().mouseProps.clicks = windowVars.doubleClickAmount;
}

void _TestNumberOfClicksUp(ref WindowHelper w, int clickType)
{
	WindowPlatformVars* windowVars = w.getPlatformVars();

	if (windowVars.doubleClickTimerSet == clickType)
	{
		//double click may have occured
		w.getWindow().mouseProps.clicks = windowVars.doubleClickAmount;
	}
	else
	{
		w.getWindow().mouseProps.clicks = 1;
	}
}

BOOL ConsoleProc( DWORD fdwCtrlType )
{
  switch( fdwCtrlType )
  {
    // Handle the CTRL-C signal.
    // CTRL-CLOSE: confirm that the user wants to exit.
    case CTRL_C_EVENT:
    case CTRL_CLOSE_EVENT:
      Console.putln( "Ctrl-Close event\n\n" );

      DjehutyEnd();

      return( TRUE );

    // Pass other signals to the next handler.
    case CTRL_BREAK_EVENT:
      printf( "Ctrl-Break event\n\n" );
      return FALSE;

    case CTRL_LOGOFF_EVENT:
      printf( "Ctrl-Logoff event\n\n" );
      return FALSE;

    case CTRL_SHUTDOWN_EVENT:
      printf( "Ctrl-Shutdown event\n\n" );
      return FALSE;

    default:
	    break;
  }

  return FALSE;
}


bool _last_was_mousepress = false;

int mainloop()
{

	DjehutyStart();

	DWORD cNumRead;

	uint i;

	INPUT_RECORD irInBuf[128];

	if (Djehuty._console_inited)
	{
		// console loop

		// get handle to standard in
		HANDLE hStdin = GetStdHandle(STD_INPUT_HANDLE);

		// get handle to standard out
		HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);

		if (! SetConsoleMode(hStdin, ENABLE_MOUSE_INPUT) )
		{
			printf("Fatal Error: Cannot Set the Console Mode\n");
        }

		if( SetConsoleCtrlHandler( cast(PHANDLER_ROUTINE) &ConsoleProc, TRUE ) )
		{
			while(console_loop)
			{
				if (! ReadConsoleInputW(
						hStdin,      // input buffer handle
						irInBuf.ptr, // buffer to read into
						128,         // size of read buffer
						&cNumRead) ) // number of records read
				{
					printf("Fatal Error: Cannot Read from Console Event Buffer\n");
				}

				for (i=0; i<cNumRead; i++)
				{
					TuiWindow curWindow = (cast(TuiApplication)Djehuty.app).window;
					switch(irInBuf[i].EventType)
					{
						case KEY_EVENT: // keyboard input
							if (irInBuf[i].Event.KeyEvent.bKeyDown == TRUE)
							{
								// KeyDown

								// The Current Console View Receives the Event
								curWindow.onKeyDown(irInBuf[i].Event.KeyEvent.wVirtualKeyCode );

								if (irInBuf[i].Event.KeyEvent.uChar.UnicodeChar > 0)
								{
									curWindow.onKeyChar(irInBuf[i].Event.KeyEvent.uChar.UnicodeChar);
								}
							}
							else
							{
								// KeyUp

								// The Current Console View Receives the Event
								curWindow.onKeyUp(irInBuf[i].Event.KeyEvent.wVirtualKeyCode);
							}
		                    break;

		                case MOUSE_EVENT: // mouse input

							uint curbutton=0;
							bool isPressed = true;
							bool isMovement = false;

							CONSOLE_SCREEN_BUFFER_INFO cinfo;

							GetConsoleScreenBufferInfo(hStdout, &cinfo);

							if (!(irInBuf[i].Event.MouseEvent.dwEventFlags == MOUSE_WHEELED ||
								  irInBuf[i].Event.MouseEvent.dwEventFlags == MOUSE_HWHEELED ))
							{
								if (curWindow.mouseProps.x != irInBuf[i].Event.MouseEvent.dwMousePosition.X - cinfo.srWindow.Left)
								{
									curWindow.mouseProps.x = irInBuf[i].Event.MouseEvent.dwMousePosition.X - cinfo.srWindow.Left;
									isMovement = true;
								}
								if (curWindow.mouseProps.y != irInBuf[i].Event.MouseEvent.dwMousePosition.Y - cinfo.srWindow.Top)
								{
									curWindow.mouseProps.y = irInBuf[i].Event.MouseEvent.dwMousePosition.Y - cinfo.srWindow.Top;
									isMovement = true;
								}
							}

							if (irInBuf[i].Event.MouseEvent.dwButtonState & FROM_LEFT_1ST_BUTTON_PRESSED)
							{
								if (curWindow.mouseProps.leftDown == false)
								{
									curbutton = 1;
									curWindow.mouseProps.leftDown = true;
								}
							}
							else
							{
								if (curWindow.mouseProps.leftDown == true)
								{
									curbutton = 1;
									curWindow.mouseProps.leftDown = false;
									isPressed = false;
								}
							}

							if (irInBuf[i].Event.MouseEvent.dwButtonState & FROM_LEFT_2ND_BUTTON_PRESSED)
							{
								if (curWindow.mouseProps.middleDown == false)
								{
									curbutton = 2;
									curWindow.mouseProps.middleDown = true;
								}
							}
							else
							{
								if (curWindow.mouseProps.middleDown == true)
								{
									curbutton = 2;
									curWindow.mouseProps.middleDown = false;
									isPressed = false;
								}
							}

							if (irInBuf[i].Event.MouseEvent.dwButtonState & FROM_LEFT_3RD_BUTTON_PRESSED)
							{
							/* 	if (cwnd.mouseProps.leftDown == false)
								{
									curbutton = 3;
									cwnd.mouseProps.leftDown = true;
								} */
							}
							else
							{
								/* if (cwnd.mouseProps.rightDown == true)
								{
									curbutton = 5;
									cwnd.mouseProps.rightDown = false;
									isPressed = false;
								} */
							}

							if (irInBuf[i].Event.MouseEvent.dwButtonState & FROM_LEFT_4TH_BUTTON_PRESSED)
							{
								/* if (cwnd.mouseProps.leftDown == false)
								{
									curbutton = 3;
									cwnd.mouseProps.leftDown = true;
								} */
							}
							else
							{
								/* if (cwnd.mouseProps.rightDown == true)
								{
									curbutton = 5;
									cwnd.mouseProps.rightDown = false;
									isPressed = false;
								} */
							}

							if (irInBuf[i].Event.MouseEvent.dwButtonState & RIGHTMOST_BUTTON_PRESSED)
							{
								if (curWindow.mouseProps.rightDown == false)
								{
									curbutton = 5;
									curWindow.mouseProps.rightDown = true;
								}
							}
							else
							{
								if (curWindow.mouseProps.rightDown == true)
								{
									curbutton = 5;
									curWindow.mouseProps.rightDown = false;
									isPressed = false;
								}
							}

							if (isPressed == false)
							{
								if (curbutton == 1)
								{
									_last_was_mousepress = true;
									curWindow.onPrimaryMouseUp();
								}
								else if (curbutton == 2)
								{
									_last_was_mousepress = true;
									curWindow.onTertiaryMouseUp();
								}
								else if (curbutton == 5)
								{
									_last_was_mousepress = true;
									curWindow.onSecondaryMouseUp();
								}
							}
							else if (curbutton > 0)
							{
								if (curbutton == 1)
								{
									_last_was_mousepress = true;
									curWindow.onPrimaryMouseDown();
								}
								else if (curbutton == 2)
								{
									_last_was_mousepress = true;
									curWindow.onTertiaryMouseDown();
								}
								else if (curbutton == 5)
								{
									_last_was_mousepress = true;
									curWindow.onSecondaryMouseDown();
								}
							}
							else
							{
								switch(irInBuf[i].Event.MouseEvent.dwEventFlags)
								{
									case MOUSE_MOVED:
										if (isMovement && !_last_was_mousepress)
										{
											curWindow.onMouseMove();
										}
										_last_was_mousepress = false;
										break;
									case MOUSE_WHEELED:

										short delta = cast(short)(irInBuf[i].Event.MouseEvent.dwButtonState >> 16);

										delta /= 120;

										curWindow.onMouseWheelY(delta);
										break;
									case MOUSE_HWHEELED:

										short delta = cast(short)(irInBuf[i].Event.MouseEvent.dwButtonState >> 16);

										delta /= 120;

										curWindow.onMouseWheelX(delta);
										break;
									default:
										break;
								}
							}


		                    break;

		                case WINDOW_BUFFER_SIZE_EVENT: // scrn buf. resizing
		                    break;

		                default:
		                    break;
		            }

			}
			}
		}
		else
		{
			printf("Fatal Error: Cannot Initialize the Console Handler\n");
		}
	}
	// main message thread

	//MSG msg;
	//while (GetMessageW(&msg, cast(HWND) null, 0, 0))
	//{
	//	TranslateMessage(&msg);
	//	DispatchMessageW(&msg);
	//}

	// HOW AWFUL IS THIS: ?!

	while(!_appEnd) {
		Sleep(1);
	}

	// THIS CODE PRINTS TO THE CONSOLE WINDOW USING GDI

	HWND hwndConsole = GetConsoleWindow();
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
	//TextOutW(dc, 0,0, "Your Score was:\0"w.ptr, 16);

	ConsoleUninit();

	ConsoleUninit();



/*
	// THIS CODE WILL SET THE CONSOLE PALETTE

	HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);
	//_curAttribs = cast(ushort)(_fgclrvalues[fg] | _bgclrvalues[bg] | (FOREGROUND_INTENSITY * cast(ushort)bright));
	//SetConsoleTextAttribute(hStdout, _curAttribs);

	CONSOLE_INFO ci;

	CONSOLE_SCREEN_BUFFER_INFO csbi; HWND hwndConsole = GetConsoleWindow();

	GetConsoleScreenBufferInfo(hStdout, &csbi);

   ci.ScreenBufferSize = csbi.dwSize;
   ci.WindowSize.X     = cast(short)(csbi.srWindow.Right - csbi.srWindow.Left + 1);
   ci.WindowSize.Y     = cast(short)(csbi.srWindow.Bottom - csbi.srWindow.Top + 1);
   ci.WindowPosX       = cast(short)(csbi.srWindow.Left);
   ci.WindowPosY       = cast(short)(csbi.srWindow.Top);

   CONSOLE_FONT_INFO cfi ;
   COORD fsize ;
   HANDLE hConsoleOut = GetStdHandle(STD_OUTPUT_HANDLE);

   GetCurrentConsoleFont(hConsoleOut, FALSE, &cfi) ;
   fsize = GetConsoleFontSize(hConsoleOut, cfi.nFont) ;

   ci.FontSize.X = fsize.X ;
   ci.FontSize.Y = fsize.Y ;

   // wsprintf(tempstr, "Font Size= X%u Y%u\n", fsize.X, fsize.Y) ;
   // OutputDebugString(tempstr) ;

   // set these to zero to keep current settings
   ci.FontFamily = 0;//0x30;//FF_MODERN|FIXED_PITCH;//0x30;
   ci.FontWeight = 0;//0x400;
   ci.FaceName[0]          = '\0';
 COLORREF DefaultColors[16] =
 [
	0x00000000, 0x00800000, 0x00008000, 0x00808000,
	0x00000080, 0x00800080, 0x00008080, 0x00c0c0c0,
	0x00808080,	0x00ff0000, 0x0000ff00, 0x00ffff00,
	0x000000ff, 0x00ff00ff,	0x0000ffff, 0x00ffffff
 ];
	// colour table
	for(i = 0; i < 16; i++) {
		ci.ColorTable[i] = DefaultColors[i];
	}

   ci.CodePage             = 0;//0x352;
	ci.Hwnd						= hwndConsole;
ci.ConsoleTitle[0] = '\0';




	DWORD   dwConsoleOwnerPid;
	HANDLE  hProcess;
	HANDLE	hSection, hDupSection;
	ubyte*   ptrView = null;
	HANDLE  hThread;

	//
	//	Open the process which "owns" the console
	//
	GetWindowThreadProcessId(hwndConsole, &dwConsoleOwnerPid);

	hProcess = OpenProcess(PROCESS_ALL_ACCESS, FALSE, dwConsoleOwnerPid);
   if (hProcess is null) {
	Console.putln("boo a");
      return FALSE;
   }

	//
	// Create a SECTION object backed by page-file, then map a view of
	// this section into the owner process so we can write the contents
	// of the CONSOLE_INFO buffer into it
	//
	hSection = CreateFileMappingW(INVALID_HANDLE_VALUE, null, PAGE_READWRITE, 0, ci.Length, null);
   if (hSection is null) {
	Console.putln("boo b");
      return FALSE;
   }

	//
	//	Copy our console structure into the section-object
	//
	ptrView = cast(ubyte*)MapViewOfFile(hSection, FILE_MAP_WRITE|FILE_MAP_READ, 0, 0, ci.Length);
   if (ptrView is null) {
	Console.putln("boo c");
      return FALSE;
   }

	ptrView[0..ci.Length] = (cast(ubyte*)&ci)[0..ci.Length];

   if (!UnmapViewOfFile(ptrView)) {
	Console.putln("boo d");
      return FALSE;
   }

	//
	//	Map the memory into owner process
	//
   if (!DuplicateHandle(GetCurrentProcess(), hSection, hProcess, &hDupSection, 0, FALSE, DUPLICATE_SAME_ACCESS)) {
	Console.putln("boo ");
	Console.putln("boo e");
      return FALSE;
   }

	Console.putln("woo e");
	//  Send console window the "update" message
	SendMessageW(hwndConsole, WM_SETCONSOLEINFO, cast(WPARAM)hDupSection, 0);

	//
	// clean up
	//
   hThread = CreateRemoteThread(hProcess, null, 0,
      cast(threadProc)&CloseHandle, hDupSection, 0, null);

   if (hThread is null) {
	Console.putln("boo f");
      return FALSE;
   }

	CloseHandle(hThread);
	CloseHandle(hSection);
	CloseHandle(hProcess);

*/



//	SetConsoleInfo(hwndConsole, &ci);

	PostQuitMessage(exitCode);

	/*
	bool close = false;
	for(;;) {
		std.thread.Thread[] threads = std.thread.Thread.getAll();
		close = true;
		foreach(th;threads)
		{
			if (th !is null && th !is std.thread.Thread.getThis())
			{
				close = false;
			}
		}
		if (close) { break; }
		//if (threads.length <= 1 && _appEnd) { break; }
		Sleep(1);
	}	*/

	return exitCode;
}

DWORD threadPoo(void* boo) {
	return 0;
}

/**********************************************************/

/* Note the similarity of this code to the console D startup
 * code in \dmd\src\phobos\dmain2.d
 * You'll also need a .def file with at least the following in it:
 *	EXETYPE NT
 *	SUBSYSTEM WINDOWS
 */

extern (C) void gc_init();
extern (C) void gc_term();
extern (C) void _minit();
extern (C) void _moduleCtor();
extern (C) void _moduleUnitTests();

void registerWindowClass()
{
	WNDCLASSW wc;
	wc.lpszClassName = djehutyClassName.ptr;
	wc.style = CS_OWNDC | CS_HREDRAW | CS_VREDRAW;
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

void TestForPenDevice()
{
	uint numDevices;
	GetRawInputDeviceList(null, &numDevices, RAWINPUTDEVICELIST.sizeof);

	RAWINPUTDEVICELIST[] deviceList = new RAWINPUTDEVICELIST[numDevices];

	GetRawInputDeviceList(deviceList.ptr, &numDevices, RAWINPUTDEVICELIST.sizeof);

	uint size;

	foreach (idx, rawdevice; deviceList)
	{
		if (rawdevice.dwType != RIM_TYPEMOUSE)
		{
			continue;
		}

		writefln("device : ", rawdevice.dwType, " at ", rawdevice.hDevice);

		int ret = GetRawInputDeviceInfoW(rawdevice.hDevice, RIDI_DEVICENAME, null, &size);

		if (ret == 0)
		{
			wchar[] devName = new wchar[size+1];

			ret = GetRawInputDeviceInfoW(rawdevice.hDevice, RIDI_DEVICENAME, cast(void*)devName.ptr, &size);

			if (ret > 0)
			{
				for(int i=4; i<size; i++)
				{
					if (devName[i] == '#')
					{
						devName[i] = '\\';
					}
					else if (devName[i] == '{')
					{
						size = i;
						break;
					}
				}

				wchar[] regCheck = "System\\CurrentControlSet\\Enum\\" ~ devName[4..size] ~ "\0";

				HKEY hkey;

				int rc = RegOpenKeyExW(HKEY_LOCAL_MACHINE, regCheck.ptr, 0, KEY_READ, &hkey);

				uint regtype = REG_SZ;

				rc = RegQueryValueExW(hkey, "DeviceDesc\0"w.ptr, null, &regtype, null, &size);

				if (rc >= 0)
				{
					int keyLength = size / 2;

					wstring devDesc = new wchar[keyLength];

					rc = RegQueryValueExW(hkey, "DeviceDesc\0"w.ptr, null, &regtype, cast(BYTE*)devDesc.ptr, &size);

					// example of devDesc:
					//@hidserv.inf,%hid_device_system_consumer%;HID-compliant consumer control device

					String s = new String(Unicode.toUtf8(devDesc));
					s = s.toLowercase();

					String srch = new String("tablet");

					bool register = false;

					if (s.find(srch) >= 0)
					{
						writefln("tablet?");
						register = true;
					}
					else
					{
						srch = new String("wacom");

						if (s.find(srch) >= 0)
						{
							writefln("tablet?");
							register = true;
						}
					}

					if (register)
					{

					}
				}

				RegCloseKey(hkey);
			}
		}
	}
}

void initAll()
{
	// set buffer to print without newline
	setvbuf (stdout, null, _IONBF, 0);

	//SetConsoleOutputCP(65001);

	GetWindowsVersion();
//	TestForPenDevice();
	LoadThemingData();
	InitCommonControls();
}

import core.arguments;

void parseCommandLine()
{
	wchar* cmdlne = GetCommandLineW();

	if (cmdlne is null) { return; }

	Arguments args = Arguments.instance;

	// tokenize
	int last = 0;

	for(int i = 0; ; i++)
	{
		auto chr = cmdlne[i];

		if (chr == ' ' || chr == '\t' || chr == '\n' || chr == '\0')
		{
			if (last != i)
			{
				String token = new String(Unicode.toUtf8(cmdlne[last..i]));

				args.addItem(token);
			}

			last = i+1;
		}

		if (chr == '\0')
		{
			break;
		}
	}
}

alias extern(C) HDC function(HWND, LPPAINTSTRUCT) BeginPaintFunc;
BeginPaintFunc pBeginPaint;
uint syscall_BeginPaint;
alias extern(C) BOOL function(HWND, LPPAINTSTRUCT) EndPaintFunc;
EndPaintFunc pEndPaint;
uint syscall_EndPaint;

void* pBufferedPaintRenderAnimation;
void* pBeginBufferedPaint;
void* pEndBufferedAnimation;
void* pBeginBufferedAnimation;

extern (Windows)
int WinMain(HINSTANCE hInstance,
	HINSTANCE hPrevInstance,
	LPSTR lpCmdLine,
	int nCmdShow)
{
    int result;

    gc_init();			// initialize garbage collector
    _minit();			// initialize module constructor table

    try
    {
		_moduleCtor();		// call module constructors
		_moduleUnitTests();	// run unit tests (optional)

		registerWindowClass();

		parseCommandLine();

		initAll();

		ubyte* bleh; uint dontcare;

		Hook("USER32.DLL\0"c.ptr, "BeginPaint\0"c.ptr, syscall_BeginPaint, bleh, cast(void*)&HookBeginPaint);
		pBeginPaint = cast(BeginPaintFunc)bleh;
		Hook("USER32.DLL\0"c.ptr, "EndPaint\0"c.ptr, syscall_EndPaint, bleh, cast(void*)&HookEndPaint);
		pEndPaint = cast(EndPaintFunc)bleh;
		Hook("UXTHEME.DLL\0"c.ptr, "BufferedPaintRenderAnimation\0"c.ptr, dontcare, bleh, cast(void*)&HookBufferedPaintRenderAnimation);
		pBufferedPaintRenderAnimation = cast(void*)bleh;
		Hook("UXTHEME.DLL\0"c.ptr, "BeginBufferedPaint\0"c.ptr, dontcare, bleh, cast(void*)&HookBeginBufferedPaint);
		pBeginBufferedPaint = cast(void*)bleh;
		Hook("UXTHEME.DLL\0"c.ptr, "EndBufferedAnimation\0"c.ptr, dontcare, bleh, cast(void*)&HookEndBufferedAnimation);
		pEndBufferedAnimation = cast(void*)bleh;
		Hook("UXTHEME.DLL\0"c.ptr, "BeginBufferedAnimation\0"c.ptr, dontcare, bleh, cast(void*)&HookBeginBufferedAnimation);
		pBeginBufferedAnimation = cast(void*)bleh;

		result = mainloop();	// insert user code here
    }
    catch (Object o)		// catch any uncaught exceptions
    {
		// Catch any unhandled exceptions
		Debugger.raiseException(cast(Exception)o);

		result = 0;		// failed
    }

    gc_term();			// run finalizers; terminate garbage collector

    return result;
}
