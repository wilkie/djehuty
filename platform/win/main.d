
module platform.win.main;

import platform.win.common;
import platform.win.vars;
import platform.win.oscontrolinterface;

import core.main;
import core.definitions;
import core.window;
import core.view;
import core.menu;
import core.thread;

import console.window;

import core.basewindow;

// import strings
import core.string;

import std.stdio;
import std.thread;

const int WM_MOUSECAPTURE = 0xffff;

const wchar[] djehutyClassName = "djehutyApp\0"w;

bool win_hasVisualStyles = false;
HFONT win_button_font;

HMODULE win_uxThemeMod;

bool console_loop = true;


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
//


bool _appEnd = false;

int win_osVersion = -1;

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
	CREATESTRUCTW* cs = cast(CREATESTRUCTW*)lParam;

	if (uMsg == WM_CREATE)
	{
		BaseWindow w = cast(BaseWindow)cs.lpCreateParams;

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
	void* ctrl_in = cast(void*)GetWindowLongW(hWnd, GWLP_USERDATA);

	if (ctrl_in !is null)
	{
		OSControl _ctrlvars = cast(OSControl)ctrl_in;

		return CallControlAppLoopMessage(_ctrlvars, uMsg, wParam, lParam);
	}

	return 0;
}

extern(Windows)
int WindowProc(HWND hWnd, uint uMsg, WPARAM wParam, LPARAM lParam)
{
	// resolve the window class reference:
	void* wind_in = cast(void*)GetWindowLongW(hWnd, GWLP_USERDATA);
	BaseWindow w = cast(BaseWindow)(wind_in);

	WindowPlatformVars* windowVars = WindowGetPlatformVars(w);

	Window viewW;

	int ret = IsWindowUnicode(windowVars.hWnd);

	if (WindowHasView(w))
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
					viewW.OnMenu(mnuNow);
				}
			}
			else
			{
				// native control

				wind_in = cast(void*)GetWindowLongW(cast(HWND)lParam, GWLP_USERDATA);

				OSControl ctrl = cast(OSControl)wind_in;

				wParam &= 0xFFFF;

				CallControlAppLoopMessage(ctrl, uMsg, wParam, lParam);
			}

			break;

		case WM_CTLCOLORDLG:
		case WM_CTLCOLORBTN:
		case WM_CTLCOLORSTATIC:

			wind_in = cast(void*)GetWindowLongW(cast(HWND)lParam, GWLP_USERDATA);

			OSControl ctrl = cast(OSControl)wind_in;

			// SET FOREGROUND AND BACKGROUND COLORS FOR CONTROLS HERE:
			// TO SUPPORT BACKGROUND AND FOREGROUND CHANGES

	        SetBkMode(cast(HDC)wParam, TRANSPARENT);

			// Lock Display

			int x, y, width, height;

			View ctrl_view = CallControlReturnView(ctrl, x, y, width, height);

			ctrl_view.lockDisplay();

			ViewPlatformVars* viewVars = ViewGetPlatformVars(ctrl_view);

			BitBlt(
				cast(HDC)wParam,
				0, 0,
				width, height,
				viewVars.dc,
				x, y,
				SRCCOPY);

			ctrl_view.unlockDisplay();

	        return cast(LRESULT)GetStockObject(NULL_BRUSH);








		case WM_ERASEBKGND:

			break;

		case WM_PAINT:

			PAINTSTRUCT ps;
			HDC dc = BeginPaint(hWnd, &ps);

			if (viewW !is null)
			{
				View* view = WindowGetView(viewW);
				ViewPlatformVars* viewVars = ViewGetPlatformVars(*view);

				viewW.OnDraw();

				view.lockDisplay();

				BitBlt(ps.hdc, 0, 0, w.getWidth(), w.getHeight(), viewVars.dc, 0, 0, SRCCOPY);

				view.unlockDisplay();

			}

			EndPaint(hWnd, &ps);

			break;

	    case WM_DESTROY:

			UninitializeWindow(w);
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
			w.OnLostFocus();
		}
		else if (x == WA_ACTIVE || x == WA_CLICKACTIVE)
		{
			//gaining focus
			w.OnGotFocus();
		}

		if (y != 0)
		{
			//minimized
		}
		break;







		case WM_INPUT:


			break;




		case WM_LBUTTONDOWN:

			SetFocus(hWnd);

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

			_TestNumberOfClicks(w,x,y,1);

			w.OnPrimaryMouseDown();
			break;

		case WM_LBUTTONUP:

			//window.mouseProps.rightDown = 0;

			//check for double click first
			_TestNumberOfClicksUp(w,1);

			//fill _mouseProps
			int x, y;
			x = lParam & 0xffff;
			w.mouseProps.x = x;
			y = (lParam >> 16) & 0xffff;
			w.mouseProps.y = y;

			w.mouseProps.leftDown = false;
			w.mouseProps.rightDown = ((wParam & MK_RBUTTON) > 0);
			w.mouseProps.middleDown = ((wParam & MK_MBUTTON) > 0);

			w.OnPrimaryMouseUp();
			break;







		case WM_RBUTTONDOWN:

			SetFocus(hWnd);

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

			_TestNumberOfClicks(w,x,y,2);

			w.OnSecondaryMouseDown();
			break;

		case WM_RBUTTONUP:

			//window.mouseProps.rightDown = 0;

			//check for double click first
			_TestNumberOfClicksUp(w,2);

			//fill _mouseProps
			int x, y;
			x = lParam & 0xffff;
			w.mouseProps.x = x;
			y = (lParam >> 16) & 0xffff;
			w.mouseProps.y = y;

			w.mouseProps.leftDown = ((wParam & MK_LBUTTON) > 0);
			w.mouseProps.rightDown = false;
			w.mouseProps.middleDown = ((wParam & MK_MBUTTON) > 0);

			w.OnSecondaryMouseUp();
			break;




		case WM_MBUTTONDOWN:

			SetFocus(hWnd);

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

			_TestNumberOfClicks(w,x,y,3);

			w.OnTertiaryMouseDown();
			break;

		case WM_MBUTTONUP:

			//window.mouseProps.rightDown = 0;

			//check for double click first
			_TestNumberOfClicksUp(w,3);

			//fill _mouseProps
			int x, y;
			x = lParam & 0xffff;
			w.mouseProps.x = x;
			y = (lParam >> 16) & 0xffff;
			w.mouseProps.y = y;

			w.mouseProps.leftDown = ((wParam & MK_LBUTTON) > 0);
			w.mouseProps.rightDown = ((wParam & MK_RBUTTON) > 0);
			w.mouseProps.middleDown = false;

			w.OnTertiaryMouseUp();
			break;




		case WM_XBUTTONDOWN:

			SetFocus(hWnd);

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

				_TestNumberOfClicks(w,x,y,4 + cast(uint)wParam);

				w.OnOtherMouseDown(cast(uint)wParam);
			}
			break;

		case WM_XBUTTONUP:

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
				_TestNumberOfClicksUp(w,4 + cast(uint)wParam);

				w.OnOtherMouseUp(cast(uint)wParam);
			}
			break;








		case WM_MOUSEHWHEEL:

			w.OnMouseWheelX(0);
			break;

		case WM_MOUSEWHEEL:

			w.OnMouseWheelY(0);
			break;









		case WM_MOUSEMOVE:

			int x, y;
			x = lParam & 0xffff;
			w.mouseProps.x = x;
			y = (lParam >> 16) & 0xffff;
			w.mouseProps.y = y;

			w.mouseProps.leftDown = ((wParam & MK_LBUTTON) > 0);
			w.mouseProps.rightDown = ((wParam & MK_RBUTTON) > 0);
			w.mouseProps.middleDown = ((wParam & MK_MBUTTON) > 0);

			if (windowVars.hoverTimerSet==0) {
				SetTimer(hWnd, 0, 55, null);
				windowVars.hoverTimerSet = 1;
			}

			w.OnMouseMove();
			break;








			// Internal Timing Functions
		case WM_MOUSELEAVE:
			w.OnMouseLeave();
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
				SetWindowXY(w, rt.left, rt.top);
				w.OnMove();
				windowVars.supress_WM_MOVE = false;
			}
			break;







		case WM_KEYDOWN:

			w.OnKeyDown(cast(uint)wParam);

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

			w.OnKeyChar(cast(dchar)wParam);

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

			w.OnKeyChar(cast(dchar)wParam);

			break;

		case WM_KEYUP:

			w.OnKeyUp(cast(uint)wParam);

			break;












		case WM_SIZE:

			RECT rt;
			GetClientRect(hWnd, &rt);

			if (!windowVars.supress_WM_SIZE)
			{
				SetWindowSize(w, rt.right, rt.bottom);
				w.OnResize();

				if (windowVars._hasGL)
				{
					windowVars.gameLoopCallResize();
				}

				windowVars.supress_WM_SIZE = false;
			}

			// was it minimized? maximized?

			if (w.getState() != WindowState.Fullscreen)
			{
				if (wParam == SIZE_MAXIMIZED && w.getState() != WindowState.Minimized)
				{
					if (!windowVars.supress_WM_SIZE_state)
					{
						CallStateChange(w, WindowState.Maximized);
						windowVars.supress_WM_SIZE_state = false;
					}
				}
				else if (wParam == SIZE_MINIMIZED && w.getState() != WindowState.Maximized)
				{
					if (!windowVars.supress_WM_SIZE_state)
					{
						CallStateChange(w, WindowState.Minimized);
						windowVars.supress_WM_SIZE_state = false;
					}
				}
				else if (wParam == SIZE_RESTORED && w.getState() != WindowState.Normal)
				{
					if (!windowVars.supress_WM_SIZE_state)
					{
						CallStateChange(w, WindowState.Normal);
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
					pnt[1].x = w.getWidth()-1;
					pnt[1].y = w.getHeight()-1;

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

void _TestNumberOfClicks(ref BaseWindow w, int x, int y, int clickType)
{
	WindowPlatformVars* windowVars = WindowGetPlatformVars(w);
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

	w.mouseProps.clicks = windowVars.doubleClickAmount;
}

void _TestNumberOfClicksUp(ref BaseWindow w, int clickType)
{
	WindowPlatformVars* windowVars = WindowGetPlatformVars(w);

	if (windowVars.doubleClickTimerSet == clickType)
	{
		//double click may have occured
		w.mouseProps.clicks = windowVars.doubleClickAmount;
	}
	else
	{
		w.mouseProps.clicks = 1;
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
      printf( "Ctrl-Close event\n\n" );

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
      return FALSE;
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
					switch(irInBuf[i].EventType)
					{
						case KEY_EVENT: // keyboard input
							if (irInBuf[i].Event.KeyEvent.bKeyDown == TRUE)
							{
								// KeyDown

								// The Current Console View Receives the Event
								ConsoleWindowOnKeyDown( irInBuf[i].Event.KeyEvent.wVirtualKeyCode );

								if (irInBuf[i].Event.KeyEvent.uChar.UnicodeChar > 0)
								{
									ConsoleWindowOnKeyChar( irInBuf[i].Event.KeyEvent.uChar.UnicodeChar );
								}
							}
							else
							{
								// KeyUp

								// The Current Console View Receives the Event
								ConsoleWindowOnKeyUp( irInBuf[i].Event.KeyEvent.wVirtualKeyCode );
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
								if (Djehuty._curConsoleWindow.mouseProps.x != irInBuf[i].Event.MouseEvent.dwMousePosition.X - cinfo.srWindow.Left)
								{
									Djehuty._curConsoleWindow.mouseProps.x = irInBuf[i].Event.MouseEvent.dwMousePosition.X - cinfo.srWindow.Left;
									isMovement = true;
								}
								if (Djehuty._curConsoleWindow.mouseProps.y != irInBuf[i].Event.MouseEvent.dwMousePosition.Y - cinfo.srWindow.Top)
								{
									Djehuty._curConsoleWindow.mouseProps.y = irInBuf[i].Event.MouseEvent.dwMousePosition.Y - cinfo.srWindow.Top;
									isMovement = true;
								}
							}

							if (irInBuf[i].Event.MouseEvent.dwButtonState & FROM_LEFT_1ST_BUTTON_PRESSED)
							{
								if (Djehuty._curConsoleWindow.mouseProps.leftDown == false)
								{
									curbutton = 1;
									Djehuty._curConsoleWindow.mouseProps.leftDown = true;
								}
							}
							else
							{
								if (Djehuty._curConsoleWindow.mouseProps.leftDown == true)
								{
									curbutton = 1;
									Djehuty._curConsoleWindow.mouseProps.leftDown = false;
									isPressed = false;
								}
							}

							if (irInBuf[i].Event.MouseEvent.dwButtonState & FROM_LEFT_2ND_BUTTON_PRESSED)
							{
								if (Djehuty._curConsoleWindow.mouseProps.middleDown == false)
								{
									curbutton = 2;
									Djehuty._curConsoleWindow.mouseProps.middleDown = true;
								}
							}
							else
							{
								if (Djehuty._curConsoleWindow.mouseProps.middleDown == true)
								{
									curbutton = 2;
									Djehuty._curConsoleWindow.mouseProps.middleDown = false;
									isPressed = false;
								}
							}

							if (irInBuf[i].Event.MouseEvent.dwButtonState & FROM_LEFT_3RD_BUTTON_PRESSED)
							{
							/* 	if (Djehuty._curConsoleWindow.mouseProps.leftDown == false)
								{
									curbutton = 3;
									Djehuty._curConsoleWindow.mouseProps.leftDown = true;
								} */
							}
							else
							{
								/* if (Djehuty._curConsoleWindow.mouseProps.rightDown == true)
								{
									curbutton = 5;
									Djehuty._curConsoleWindow.mouseProps.rightDown = false;
									isPressed = false;
								} */
							}

							if (irInBuf[i].Event.MouseEvent.dwButtonState & FROM_LEFT_4TH_BUTTON_PRESSED)
							{
								/* if (Djehuty._curConsoleWindow.mouseProps.leftDown == false)
								{
									curbutton = 3;
									Djehuty._curConsoleWindow.mouseProps.leftDown = true;
								} */
							}
							else
							{
								/* if (Djehuty._curConsoleWindow.mouseProps.rightDown == true)
								{
									curbutton = 5;
									Djehuty._curConsoleWindow.mouseProps.rightDown = false;
									isPressed = false;
								} */
							}

							if (irInBuf[i].Event.MouseEvent.dwButtonState & RIGHTMOST_BUTTON_PRESSED)
							{
								if (Djehuty._curConsoleWindow.mouseProps.rightDown == false)
								{
									curbutton = 5;
									Djehuty._curConsoleWindow.mouseProps.rightDown = true;
								}
							}
							else
							{
								if (Djehuty._curConsoleWindow.mouseProps.rightDown == true)
								{
									curbutton = 5;
									Djehuty._curConsoleWindow.mouseProps.rightDown = false;
									isPressed = false;
								}
							}

							if (isPressed == false)
							{
								if (curbutton == 1)
								{
									_last_was_mousepress = true;
									ConsoleWindowOnPrimaryMouseUp();
								}
								else if (curbutton == 2)
								{
									_last_was_mousepress = true;
									ConsoleWindowOnTertiaryMouseUp();
								}
								else if (curbutton == 5)
								{
									_last_was_mousepress = true;
									ConsoleWindowOnSecondaryMouseUp();
								}
							}
							else if (curbutton > 0)
							{
								if (curbutton == 1)
								{
									_last_was_mousepress = true;
									ConsoleWindowOnPrimaryMouseDown();
								}
								else if (curbutton == 2)
								{
									_last_was_mousepress = true;
									ConsoleWindowOnTertiaryMouseDown();
								}
								else if (curbutton == 5)
								{
									_last_was_mousepress = true;
									ConsoleWindowOnSecondaryMouseDown();
								}
							}
							else
							{
								switch(irInBuf[i].Event.MouseEvent.dwEventFlags)
								{
									case MOUSE_MOVED:
										if (isMovement && !_last_was_mousepress)
										{
											ConsoleWindowOnMouseMove();
										}
										_last_was_mousepress = false;
										break;
									case MOUSE_WHEELED:

										short delta = cast(short)(irInBuf[i].Event.MouseEvent.dwButtonState >> 16);

										delta /= 120;

										ConsoleWindowOnMouseWheelY(delta);
										break;
									case MOUSE_HWHEELED:

										short delta = cast(short)(irInBuf[i].Event.MouseEvent.dwButtonState >> 16);

										delta /= 120;

										ConsoleWindowOnMouseWheelX(delta);
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
	else
	{
		// main message thread

		//MSG msg;
		//while (GetMessageW(&msg, cast(HWND) null, 0, 0))
		//{
		//	TranslateMessage(&msg);
		//	DispatchMessageW(&msg);
		//}

		// HOW AWFUL IS THIS: ?!
		bool close = false;
		for(;;) {
			std.thread.Thread[] threads = std.thread.Thread.getAll();
			//writefln("threadcnt: ", threads.length);
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
		}
	}

	return 1;
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

					StringLiteral16 devDesc = new CharLiteral16[keyLength];

					rc = RegQueryValueExW(hkey, "DeviceDesc\0"w.ptr, null, &regtype, cast(BYTE*)devDesc.ptr, &size);

					// example of devDesc:
					//@hidserv.inf,%hid_device_system_consumer%;HID-compliant consumer control device

					String s = new String(devDesc);
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
		initAll();

		result = mainloop();	// insert user code here
    }
    catch (Object o)		// catch any uncaught exceptions
    {
		MessageBoxA(null, cast(char *)o.toString(), "Error", MB_OK | MB_ICONEXCLAMATION);

		result = 0;		// failed
    }

    gc_term();			// run finalizers; terminate garbage collector

    return result;
}
