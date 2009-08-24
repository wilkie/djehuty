/*
 * main.d
 *
 * This is the main entry point for windows applications.
 *
 * Author: Dave Wilkinson
 * Originated: July 20th, 2009
 *
 */

module platform.win.main;

import platform.win.common;

import core.arguments;
import core.string;
import core.unicode;
import core.main;

import io.console;

import binding.c;

import analyzing.debugger;

extern (C) void gc_init();
extern (C) void gc_term();
extern (C) void _minit();
extern (C) void _moduleCtor();
extern (C) void _moduleUnitTests();

// The windows entry point
extern (Windows)
int WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {

	int result;

	gc_init();			// initialize garbage collector
	_minit();			// initialize module constructor table

	int windowsVersion;

	try {

		ApplicationController app = ApplicationController.instance;
		
		windowsVersion = app.windowsVersion;

		_moduleCtor();		// call module constructors
		_moduleUnitTests();	// run unit tests (optional)

		Djehuty.start();
		
		app = null;
	}
	catch (Object o) {
		// Catch any unhandled exceptions
		Debugger.raiseException(cast(Exception)o);

		result = 0;		// failed
	}

	if (windowsVersion != OsVersionWindows7) {
		gc_term();			// run finalizers; terminate garbage collector
	}

    return result;
}

// The main ApplicationController
class ApplicationController {

	this() {
		// Read and formalize the command arguments
		parseCommandLine();

		// some common initialization
		initCommon();
	}

	void exitCode(uint value) {
		_exitCode = value;
	}

	void start() {
	}

	void end() {
	}

	static ApplicationController instance() {
		if (_app is null) {
			_app = new ApplicationController();
		}

		return _app;
	}

private:

	int windowsVersion() {
		return win_osVersion;
	}

	uint _exitCode;

	int win_osVersion = -1;

	static ApplicationController _app;

	void getWindowsVersion() {
		//get windows version
		DWORD verRet = GetVersion();

		OSVERSIONINFOEXW osvi = { 0 };
		BOOL bOsVersionInfoEx;

		// Try calling GetVersionEx using the OSVERSIONINFOEX structure.
		// If that fails, try using the OSVERSIONINFO structure.

		osvi.dwOSVersionInfoSize = OSVERSIONINFOEXW.sizeof;

		win_osVersion = -1;

		bOsVersionInfoEx = GetVersionExW (cast(OSVERSIONINFOW*)&osvi);

		if( !bOsVersionInfoEx ) {
			osvi.dwOSVersionInfoSize = OSVERSIONINFOW.sizeof;
			if (! GetVersionExW ( cast(OSVERSIONINFOW*)&osvi) ) {
				//error
				//just try and assume an OS version
				//lets say Win95, just in case
				win_osVersion = OsVersionWindows95;
			}
		}

		if (win_osVersion == -1) {
			switch (osvi.dwPlatformId) {
				// Test for the Windows NT product family.

				case VER_PLATFORM_WIN32_NT:

				// Test for the specific product.

				if ( osvi.dwMajorVersion == 6 && osvi.dwMinorVersion == 1) {
					if( osvi.wProductType == VER_NT_WORKSTATION ) {
						win_osVersion = OsVersionWindows7;
					}
					else {
						//will be Longhorn Server
						win_osVersion = OsVersionWindowsServer2008;
					}
				}
				else if ( osvi.dwMajorVersion == 6 && osvi.dwMinorVersion == 0 ) {
					if( osvi.wProductType == VER_NT_WORKSTATION ) {
						win_osVersion = OsVersionWindowsVista;
					}
					else {
						//will be Longhorn Server
						win_osVersion = OsVersionWindowsLonghorn;
					}
				}
				else if ( osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 2 ) {
					if( GetSystemMetrics(89) ) {
						//Windows Server 2003
						win_osVersion = OsVersionWindowsServer2003;
					}
					else if( osvi.wProductType == VER_NT_WORKSTATION ) {
						//Windows XP x64
						win_osVersion = OsVersionWindowsXp;
					}
					else {
						//Windows Server 2003
					}
				}
				else if (osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 1) {
					win_osVersion = OsVersionWindowsXp;
				}
				else if (osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 0 ) {
					win_osVersion = OsVersionWindows2000;
				}
				else if ( osvi.dwMajorVersion <= 4 ) {
					win_osVersion = OsVersionWindowsNT;
				}
				break;
	
			// Test for the Windows Me/98/95.
			case VER_PLATFORM_WIN32_WINDOWS:
	
			if (osvi.dwMajorVersion == 4 && osvi.dwMinorVersion == 0) {
				win_osVersion = OsVersionWindows95;
			}

			if (osvi.dwMajorVersion == 4 && osvi.dwMinorVersion == 10) {
				if ( osvi.szCSDVersion[1]=='A' || osvi.szCSDVersion[1]=='B') {
					win_osVersion = OsVersionWindows98Se;
				}
				else {
					win_osVersion = OsVersionWindows98;
				}
			}
	
			if (osvi.dwMajorVersion == 4 && osvi.dwMinorVersion == 90) {
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
	
	void parseCommandLine() {
		wchar* cmdlne = GetCommandLineW();
	
		if (cmdlne is null) {
			return;
		}

		Arguments args = Arguments.instance;
	
		// tokenize
		int last = 0;
	
		for(int i = 0; ; i++) {
			auto chr = cmdlne[i];

			if (chr == ' ' || chr == '\t' || chr == '\n' || chr == '\0') {
				if (last != i) {
					String token = new String(Unicode.toUtf8(cmdlne[last..i]));
	
					args.addItem(token);
				}
	
				last = i+1;
			}
	
			if (chr == '\0') {
				break;
			}
		}
	}

	void initCommon() {
		// set buffer to print without newline
		setvbuf (stdout, null, _IONBF, 0);
		//SetConsoleOutputCP(65001);

		getWindowsVersion();
		InitCommonControls();
	}
}

