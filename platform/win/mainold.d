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


bool win_hasVisualStyles = false;
HFONT win_button_font;

HMODULE win_uxThemeMod;

bool console_loop = true;
uint exitCode;

const uint MI_WP_SIGNATURE = 0xFF515700;
const uint SIGNATURE_MASK = 0xFFFFFF00;


// Console Libraries (C runtime)
//
// HMODULE win_crt;
// extern (C) alias int function(HANDLE, int) _open_osfhandle_func;
// extern (C) alias FILE* function(int, char*) _fdopen_func;
// _open_osfhandle_func _open_osfhandleDLL;
// _fdopen_func _fdopenDLL;

bool _appEnd = false;

int win_osVersion = -1;




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


bool indraw;





int mainloop()
{

	DjehutyStart();

	if (Djehuty._console_inited) {
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
			if (th !is null && th !is std.\thread.Thread.getThis())
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
