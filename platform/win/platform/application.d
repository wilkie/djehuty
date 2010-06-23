module platform.application;

import binding.win32.winnt;
import binding.win32.windef;
import binding.win32.winuser;
import binding.win32.winbase;

import core.arguments;
import core.string;
import core.unicode;
import core.main;

import io.console;

import binding.c;

import analyzing.debugger;

enum : uint
{
	OsVersionWindows95			= 0,
	OsVersionWindowsNT			= 1,
	OsVersionWindows98			= 2,
	OsVersionWindows98Se		= 3,
	OsVersionWindowsMe			= 4,
	OsVersionWindows2000		= 5,
	OsVersionWindowsXp			= 6,
	OsVersionWindowsServer2003	= 7,
	OsVersionWindowsVista		= 8,
	OsVersionWindowsLonghorn	= 9,
	OsVersionWindows7			= 10,
	OsVersionWindowsServer2008	= 11,
	OsVersionWindowsMax			= uint.max,
}

//XXX:CommCtrl.h
pragma(lib, "comctl32.lib");
extern(System) void InitCommonControls();

// The main ApplicationController
class ApplicationController {

	this() {
		// some common initialization
		initCommon();
	}

	void exitCode(uint value) {
		_exitCode = value;
	}
	
	uint exitCode() {
		return _exitCode;
	}

	void start() {
	}

	void end() {
		exit(_exitCode);
	}

	static ApplicationController instance() {
		if (_app is null) {
			_app = new ApplicationController();
		}

		return _app;
	}

	// exposed
	int windowsVersion() {
		return win_osVersion;
	}

private:

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
					string token = Unicode.toUtf8(cmdlne[last..i]);
	
					args.add(token);
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
		//setvbuf (stdout, null, _IONBF, 0);
		//SetConsoleOutputCP(65001);

		getWindowsVersion();
		InitCommonControls();
	}
}

