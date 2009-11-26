/*
 * winuser.d
 *
 * This module binds winuser.h to D. The original copyright notice is
 * preserved below.
 *
 * Author: Dave Wilkinson
 * Originated: November 24th, 2009
 *
 */

module binding.win32.winuser;

import binding.c;

import binding.win32.windef;
import binding.win32.winnt;
import binding.win32.winbase;
import binding.win32.wingdi;

/****************************************************************************
*                                                                           *
* winuser.h -- USER procedure declarations, constant definitions and macros *
*                                                                           *
* Copyright (c) Microsoft Corporation. All rights reserved.                 *
*                                                                           *
****************************************************************************/

extern(System):

version(NOUSER) {
}
else {
	alias HANDLE HDWP;
	alias VOID MENUTEMPLATEA;
	alias VOID MENUTEMPLATEW;
	
	version(UNICODE) {
		alias MENUTEMPLATEW MENUTEMPLATE;
	}
	else {
		alias MENUTEMPLATEA MENUTEMPLATE;
	}
	alias PVOID LPMENUTEMPLATEA;
	alias PVOID LPMENUTEMPLATEW;
	
	version(UNICODE) {
		alias LPMENUTEMPLATEW LPMENUTEMPLATE;
	}
	else {
		alias LPMENUTEMPLATEA LPMENUTEMPLATE;
	}
	
	alias LRESULT function(HWND, UINT, WPARAM, LPARAM) WNDPROC;
	
	alias INT_PTR function(HWND, UINT, WPARAM, LPARAM) DLGPROC;
	alias VOID function(HWND, UINT, UINT_PTR, DWORD) TIMERPROC;
	alias BOOL function(HDC, LPARAM, int) GRAYSTRINGPROC;
	alias BOOL function(HWND, LPARAM) WNDENUMPROC;
	alias LRESULT function(int code, WPARAM wParam, LPARAM lParam) HOOKPROC;
	alias VOID function(HWND, UINT, ULONG_PTR, LRESULT) SENDASYNCPROC;
	
	alias BOOL function(HWND, LPCSTR, HANDLE) PROPENUMPROCA;
	alias BOOL function(HWND, LPCWSTR, HANDLE) PROPENUMPROCW;
	
	alias BOOL function(HWND, LPSTR, HANDLE, ULONG_PTR) PROPENUMPROCEXA;
	alias BOOL function(HWND, LPWSTR, HANDLE, ULONG_PTR) PROPENUMPROCEXW;
	
	alias int function(LPSTR lpch, int ichCurrent, int cch, int code) EDITWORDBREAKPROCA;
	alias int function(LPWSTR lpch, int ichCurrent, int cch, int code) EDITWORDBREAKPROCW;
	
	alias BOOL function(HDC hdc, LPARAM lData, WPARAM wData, int cx, int cy) DRAWSTATEPROC;
	
	version(UNICODE) {
		alias PROPENUMPROCW        PROPENUMPROC;
		alias PROPENUMPROCEXW      PROPENUMPROCEX;
		alias EDITWORDBREAKPROCW   EDITWORDBREAKPROC;
	}
	else {
		alias PROPENUMPROCA        PROPENUMPROC;
		alias PROPENUMPROCEXA      PROPENUMPROCEX;
		alias EDITWORDBREAKPROCA   EDITWORDBREAKPROC;
	}
	
	alias BOOL function(LPSTR, LPARAM) NAMEENUMPROCA;
	alias BOOL function(LPWSTR, LPARAM) NAMEENUMPROCW;
	
	alias NAMEENUMPROCA   WINSTAENUMPROCA;
	alias NAMEENUMPROCA   DESKTOPENUMPROCA;
	alias NAMEENUMPROCW   WINSTAENUMPROCW;
	alias NAMEENUMPROCW   DESKTOPENUMPROCW;
	
	version(UNICODE) {
		alias WINSTAENUMPROCW     WINSTAENUMPROC;
		alias DESKTOPENUMPROCW    DESKTOPENUMPROC;
	}
	else {
		alias WINSTAENUMPROCA     WINSTAENUMPROC;
		alias DESKTOPENUMPROCA    DESKTOPENUMPROC;
	}
	
	template IS_INTRESOURCE(uint _r) {
		const bool IS_INTRESOURCE = (((cast(ULONG_PTR)(_r)) >> 16) == 0);
	}
	
	template MAKEINTRESOURCEA(uint i) {
		const LPSTR MAKEINTRESOURCEA = (cast(LPSTR)(cast(ULONG_PTR)(cast(WORD)(i))));
	}

	template MAKEINTRESOURCEW(uint i) {
		const LPWSTR MAKEINTRESOURCEW = (cast(LPWSTR)(cast(ULONG_PTR)(cast(WORD)(i))));
	}

	version(UNICODE) {
		alias MAKEINTRESOURCEW MAKEINTRESOURCE;
	}
	else {
		alias MAKEINTRESOURCEA MAKEINTRESOURCE;
	}

	version(NORESOURCE) {
	}
	else {

		/*
		 * Predefined Resource Types
		 */
		const auto RT_CURSOR            = MAKEINTRESOURCE!(1);
		const auto RT_BITMAP            = MAKEINTRESOURCE!(2);
		const auto RT_ICON              = MAKEINTRESOURCE!(3);
		const auto RT_MENU              = MAKEINTRESOURCE!(4);
		const auto RT_DIALOG            = MAKEINTRESOURCE!(5);
		const auto RT_STRING            = MAKEINTRESOURCE!(6);
		const auto RT_FONTDIR           = MAKEINTRESOURCE!(7);
		const auto RT_FONT              = MAKEINTRESOURCE!(8);
		const auto RT_ACCELERATOR       = MAKEINTRESOURCE!(9);
		const auto RT_RCDATA            = MAKEINTRESOURCE!(10);
		const auto RT_MESSAGETABLE      = MAKEINTRESOURCE!(11);

		const auto DIFFERENCE      = 11;
		const auto RT_GROUP_CURSOR  = MAKEINTRESOURCE!(cast(ULONG_PTR)(RT_CURSOR) + DIFFERENCE);
		const auto RT_GROUP_ICON    = MAKEINTRESOURCE!(cast(ULONG_PTR)(RT_ICON) + DIFFERENCE);
		const auto RT_VERSION       = MAKEINTRESOURCE!(16);
		const auto RT_DLGINCLUDE    = MAKEINTRESOURCE!(17);
		
		const auto RT_PLUGPLAY      = MAKEINTRESOURCE!(19);
		const auto RT_VXD           = MAKEINTRESOURCE!(20);
		const auto RT_ANICURSOR     = MAKEINTRESOURCE!(21);
		const auto RT_ANIICON       = MAKEINTRESOURCE!(22);
		
		const auto RT_HTML          = MAKEINTRESOURCE!(23);

		const auto RT_MANIFEST                         = MAKEINTRESOURCE!(24);
		const auto CREATEPROCESS_MANIFEST_RESOURCE_ID  = MAKEINTRESOURCE!( 1);
		const auto ISOLATIONAWARE_MANIFEST_RESOURCE_ID  = MAKEINTRESOURCE!(2);
		const auto ISOLATIONAWARE_NOSTATICIMPORT_MANIFEST_RESOURCE_ID  = MAKEINTRESOURCE!(3);
		const auto MINIMUM_RESERVED_MANIFEST_RESOURCE_ID  = MAKEINTRESOURCE!( 1 /*inclusive*/);
		const auto MAXIMUM_RESERVED_MANIFEST_RESOURCE_ID  = MAKEINTRESOURCE!(16 /*inclusive*/);
	
	}
	/*
	int
	wvsprintfA(
	     LPSTR,
	      LPCSTR,
	     va_list arglist);
	
	int
	wvsprintfW(
	     LPWSTR,
	      LPCWSTR,
	     va_list arglist);
	
	version(UNICODE) {
		alias wvsprintfW wvsprintf;
	}
	else {
		alias wvsprintfA wvsprintf;
	}
	*/
	
	int
	wsprintfA(
	     LPSTR,
	      LPCSTR,
	    ...);
	int
	wsprintfW(
	     LPWSTR,
	      LPCWSTR,
	    ...);
	
	version(UNICODE) {
		alias wsprintfW wsprintf;
	}
	else {
		alias wsprintfA wsprintf;
	}
	
	/*
	 * SPI_SETDESKWALLPAPER defined constants
	 */
	const auto SETWALLPAPER_DEFAULT     = (cast(LPWSTR)-1);
	
	version(NOSCROLL) {
	}
	else {
	
		/*
		 * Scroll Bar Constants
		 */
		const auto SB_HORZ              = 0;
		const auto SB_VERT              = 1;
		const auto SB_CTL               = 2;
		const auto SB_BOTH              = 3;
		
		/*
		 * Scroll Bar Commands
		 */
		const auto SB_LINEUP            = 0;
		const auto SB_LINELEFT          = 0;
		const auto SB_LINEDOWN          = 1;
		const auto SB_LINERIGHT         = 1;
		const auto SB_PAGEUP            = 2;
		const auto SB_PAGELEFT          = 2;
		const auto SB_PAGEDOWN          = 3;
		const auto SB_PAGERIGHT         = 3;
		const auto SB_THUMBPOSITION     = 4;
		const auto SB_THUMBTRACK        = 5;
		const auto SB_TOP               = 6;
		const auto SB_LEFT              = 6;
		const auto SB_BOTTOM            = 7;
		const auto SB_RIGHT             = 7;
		const auto SB_ENDSCROLL         = 8;
	
	}
	
	version(NOSHOWWINDOW) {
	}
	else {
	
		/*
		 * ShowWindow() Commands
		 */
		const auto SW_HIDE              = 0;
		const auto SW_SHOWNORMAL        = 1;
		const auto SW_NORMAL            = 1;
		const auto SW_SHOWMINIMIZED     = 2;
		const auto SW_SHOWMAXIMIZED     = 3;
		const auto SW_MAXIMIZE          = 3;
		const auto SW_SHOWNOACTIVATE    = 4;
		const auto SW_SHOW              = 5;
		const auto SW_MINIMIZE          = 6;
		const auto SW_SHOWMINNOACTIVE   = 7;
		const auto SW_SHOWNA            = 8;
		const auto SW_RESTORE           = 9;
		const auto SW_SHOWDEFAULT       = 10;
		const auto SW_FORCEMINIMIZE     = 11;
		const auto SW_MAX               = 11;
		
		
		/*
		 * Old ShowWindow() Commands
		 */
		const auto HIDE_WINDOW          = 0;
		const auto SHOW_OPENWINDOW      = 1;
		const auto SHOW_ICONWINDOW      = 2;
		const auto SHOW_FULLSCREEN      = 3;
		const auto SHOW_OPENNOACTIVATE  = 4;
		
		/*
		 * Identifiers for the WM_SHOWWINDOW message
		 */
		const auto SW_PARENTCLOSING     = 1;
		const auto SW_OTHERZOOM         = 2;
		const auto SW_PARENTOPENING     = 3;
		const auto SW_OTHERUNZOOM       = 4;
		
	}
	
	/*
	 * AnimateWindow() Commands
	 */
	const auto AW_HOR_POSITIVE              = 0x00000001;
	const auto AW_HOR_NEGATIVE              = 0x00000002;
	const auto AW_VER_POSITIVE              = 0x00000004;
	const auto AW_VER_NEGATIVE              = 0x00000008;
	const auto AW_CENTER                    = 0x00000010;
	const auto AW_HIDE                      = 0x00010000;
	const auto AW_ACTIVATE                  = 0x00020000;
	const auto AW_SLIDE                     = 0x00040000;
	const auto AW_BLEND                     = 0x00080000;
	
	/*
	 * WM_KEYUP/DOWN/CHAR HIWORD(lParam) flags
	 */
	const auto KF_EXTENDED        = 0x0100;
	const auto KF_DLGMODE         = 0x0800;
	const auto KF_MENUMODE        = 0x1000;
	const auto KF_ALTDOWN         = 0x2000;
	const auto KF_REPEAT          = 0x4000;
	const auto KF_UP              = 0x8000;
	
	version(NOVIRTUALKEYCODES) {
	}
	else {
	
		/*
		 * Virtual Keys, Standard Set
		 */
		const auto VK_LBUTTON         = 0x01;
		const auto VK_RBUTTON         = 0x02;
		const auto VK_CANCEL          = 0x03;
		const auto VK_MBUTTON         = 0x04    /* NOT contiguous with L & RBUTTON */;
		
		const auto VK_XBUTTON1        = 0x05    /* NOT contiguous with L & RBUTTON */;
		const auto VK_XBUTTON2        = 0x06    /* NOT contiguous with L & RBUTTON */;
		
		/*
		 * 0x07 : unassigned
		 */
		
		const auto VK_BACK            = 0x08;
		const auto VK_TAB             = 0x09;
		
		/*
		 * 0x0A - 0x0B : reserved
		 */
		
		const auto VK_CLEAR           = 0x0C;
		const auto VK_RETURN          = 0x0D;
		
		const auto VK_SHIFT           = 0x10;
		const auto VK_CONTROL         = 0x11;
		const auto VK_MENU            = 0x12;
		const auto VK_PAUSE           = 0x13;
		const auto VK_CAPITAL         = 0x14;
		
		const auto VK_KANA            = 0x15;
		const auto VK_HANGEUL         = 0x15  /* old name - should be here for compatibility */;
		const auto VK_HANGUL          = 0x15;
		const auto VK_JUNJA           = 0x17;
		const auto VK_FINAL           = 0x18;
		const auto VK_HANJA           = 0x19;
		const auto VK_KANJI           = 0x19;
		
		const auto VK_ESCAPE          = 0x1B;
		
		const auto VK_CONVERT         = 0x1C;
		const auto VK_NONCONVERT      = 0x1D;
		const auto VK_ACCEPT          = 0x1E;
		const auto VK_MODECHANGE      = 0x1F;
		
		const auto VK_SPACE           = 0x20;
		const auto VK_PRIOR           = 0x21;
		const auto VK_NEXT            = 0x22;
		const auto VK_END             = 0x23;
		const auto VK_HOME            = 0x24;
		const auto VK_LEFT            = 0x25;
		const auto VK_UP              = 0x26;
		const auto VK_RIGHT           = 0x27;
		const auto VK_DOWN            = 0x28;
		const auto VK_SELECT          = 0x29;
		const auto VK_PRINT           = 0x2A;
		const auto VK_EXECUTE         = 0x2B;
		const auto VK_SNAPSHOT        = 0x2C;
		const auto VK_INSERT          = 0x2D;
		const auto VK_DELETE          = 0x2E;
		const auto VK_HELP            = 0x2F;
		
		/*
		 * VK_0 - VK_9 are the same as ASCII '0' - '9' (0x30 - 0x39)
		 * 0x40 : unassigned
		 * VK_A - VK_Z are the same as ASCII 'A' - 'Z' (0x41 - 0x5A)
		 */
		
		const auto VK_LWIN            = 0x5B;
		const auto VK_RWIN            = 0x5C;
		const auto VK_APPS            = 0x5D;
		
		/*
		 * 0x5E : reserved
		 */
		
		const auto VK_SLEEP           = 0x5F;
		
		const auto VK_NUMPAD0         = 0x60;
		const auto VK_NUMPAD1         = 0x61;
		const auto VK_NUMPAD2         = 0x62;
		const auto VK_NUMPAD3         = 0x63;
		const auto VK_NUMPAD4         = 0x64;
		const auto VK_NUMPAD5         = 0x65;
		const auto VK_NUMPAD6         = 0x66;
		const auto VK_NUMPAD7         = 0x67;
		const auto VK_NUMPAD8         = 0x68;
		const auto VK_NUMPAD9         = 0x69;
		const auto VK_MULTIPLY        = 0x6A;
		const auto VK_ADD             = 0x6B;
		const auto VK_SEPARATOR       = 0x6C;
		const auto VK_SUBTRACT        = 0x6D;
		const auto VK_DECIMAL         = 0x6E;
		const auto VK_DIVIDE          = 0x6F;
		const auto VK_F1              = 0x70;
		const auto VK_F2              = 0x71;
		const auto VK_F3              = 0x72;
		const auto VK_F4              = 0x73;
		const auto VK_F5              = 0x74;
		const auto VK_F6              = 0x75;
		const auto VK_F7              = 0x76;
		const auto VK_F8              = 0x77;
		const auto VK_F9              = 0x78;
		const auto VK_F10             = 0x79;
		const auto VK_F11             = 0x7A;
		const auto VK_F12             = 0x7B;
		const auto VK_F13             = 0x7C;
		const auto VK_F14             = 0x7D;
		const auto VK_F15             = 0x7E;
		const auto VK_F16             = 0x7F;
		const auto VK_F17             = 0x80;
		const auto VK_F18             = 0x81;
		const auto VK_F19             = 0x82;
		const auto VK_F20             = 0x83;
		const auto VK_F21             = 0x84;
		const auto VK_F22             = 0x85;
		const auto VK_F23             = 0x86;
		const auto VK_F24             = 0x87;
		
		/*
		 * 0x88 - 0x8F : unassigned
		 */
		
		const auto VK_NUMLOCK         = 0x90;
		const auto VK_SCROLL          = 0x91;
		
		/*
		 * NEC PC-9800 kbd definitions
		 */
		const auto VK_OEM_NEC_EQUAL   = 0x92   ; // '=' key on numpad
		
		/*
		 * Fujitsu/OASYS kbd definitions
		 */
		const auto VK_OEM_FJ_JISHO    = 0x92   ; // 'Dictionary' key
		const auto VK_OEM_FJ_MASSHOU  = 0x93   ; // 'Unregister word' key
		const auto VK_OEM_FJ_TOUROKU  = 0x94   ; // 'Register word' key
		const auto VK_OEM_FJ_LOYA     = 0x95   ; // 'Left OYAYUBI' key
		const auto VK_OEM_FJ_ROYA     = 0x96   ; // 'Right OYAYUBI' key
		
		/*
		 * 0x97 - 0x9F : unassigned
		 */
	
		/*
		 * VK_L* & VK_R* - left and right Alt, Ctrl and Shift virtual keys.
		 * Used only as parameters to GetAsyncKeyState() and GetKeyState().
		 * No other API or message will distinguish left and right keys in this way.
		 */
		const auto VK_LSHIFT          = 0xA0;
		const auto VK_RSHIFT          = 0xA1;
		const auto VK_LCONTROL        = 0xA2;
		const auto VK_RCONTROL        = 0xA3;
		const auto VK_LMENU           = 0xA4;
		const auto VK_RMENU           = 0xA5;
		
		const auto VK_BROWSER_BACK         = 0xA6;
		const auto VK_BROWSER_FORWARD      = 0xA7;
		const auto VK_BROWSER_REFRESH      = 0xA8;
		const auto VK_BROWSER_STOP         = 0xA9;
		const auto VK_BROWSER_SEARCH       = 0xAA;
		const auto VK_BROWSER_FAVORITES    = 0xAB;
		const auto VK_BROWSER_HOME         = 0xAC;
		
		const auto VK_VOLUME_MUTE          = 0xAD;
		const auto VK_VOLUME_DOWN          = 0xAE;
		const auto VK_VOLUME_UP            = 0xAF;
		const auto VK_MEDIA_NEXT_TRACK     = 0xB0;
		const auto VK_MEDIA_PREV_TRACK     = 0xB1;
		const auto VK_MEDIA_STOP           = 0xB2;
		const auto VK_MEDIA_PLAY_PAUSE     = 0xB3;
		const auto VK_LAUNCH_MAIL          = 0xB4;
		const auto VK_LAUNCH_MEDIA_SELECT  = 0xB5;
		const auto VK_LAUNCH_APP1          = 0xB6;
		const auto VK_LAUNCH_APP2          = 0xB7;
		
		/*
		 * 0xB8 - 0xB9 : reserved
		 */
		
		const auto VK_OEM_1           = 0xBA   ; // ';:' for US
		const auto VK_OEM_PLUS        = 0xBB   ; // '+' any country
		const auto VK_OEM_COMMA       = 0xBC   ; // ',' any country
		const auto VK_OEM_MINUS       = 0xBD   ; // '-' any country
		const auto VK_OEM_PERIOD      = 0xBE   ; // '.' any country
		const auto VK_OEM_2           = 0xBF   ; // '/?' for US
		const auto VK_OEM_3           = 0xC0   ; // '`~' for US
		
		/*
		 * 0xC1 - 0xD7 : reserved
		 */
	
		/*
		 * 0xD8 - 0xDA : unassigned
		 */
		
		const auto VK_OEM_4           = 0xDB  ; //  '[{' for US
		const auto VK_OEM_5           = 0xDC  ; //  '\|' for US
		const auto VK_OEM_6           = 0xDD  ; //  ']}' for US
		const auto VK_OEM_7           = 0xDE  ; //  ''"' for US
		const auto VK_OEM_8           = 0xDF;
		
		/*
		 * 0xE0 : reserved
		 */
		
		/*
		 * Various extended or enhanced keyboards
		 */
		const auto VK_OEM_AX          = 0xE1  ; //  'AX' key on Japanese AX kbd
		const auto VK_OEM_102         = 0xE2  ; //  "<>" or "\|" on RT 102-key kbd.
		const auto VK_ICO_HELP        = 0xE3  ; //  Help key on ICO
		const auto VK_ICO_00          = 0xE4  ; //  00 key on ICO
		
		const auto VK_PROCESSKEY      = 0xE5;
		
		const auto VK_ICO_CLEAR       = 0xE6;
		
		
		const auto VK_PACKET          = 0xE7;
		
		/*
		 * 0xE8 : unassigned
		 */
		
		/*
		 * Nokia/Ericsson definitions
		 */
		const auto VK_OEM_RESET       = 0xE9;
		const auto VK_OEM_JUMP        = 0xEA;
		const auto VK_OEM_PA1         = 0xEB;
		const auto VK_OEM_PA2         = 0xEC;
		const auto VK_OEM_PA3         = 0xED;
		const auto VK_OEM_WSCTRL      = 0xEE;
		const auto VK_OEM_CUSEL       = 0xEF;
		const auto VK_OEM_ATTN        = 0xF0;
		const auto VK_OEM_FINISH      = 0xF1;
		const auto VK_OEM_COPY        = 0xF2;
		const auto VK_OEM_AUTO        = 0xF3;
		const auto VK_OEM_ENLW        = 0xF4;
		const auto VK_OEM_BACKTAB     = 0xF5;
	
		const auto VK_ATTN            = 0xF6;
		const auto VK_CRSEL           = 0xF7;
		const auto VK_EXSEL           = 0xF8;
		const auto VK_EREOF           = 0xF9;
		const auto VK_PLAY            = 0xFA;
		const auto VK_ZOOM            = 0xFB;
		const auto VK_NONAME          = 0xFC;
		const auto VK_PA1             = 0xFD;
		const auto VK_OEM_CLEAR       = 0xFE;
	
		/*
		 * 0xFF : reserved
		 */
	
	
	}
	
	version(NOWH) {
	}
	else {
	
		/*
		 * SetWindowsHook() codes
		 */
		const auto WH_MIN               = (-1);
		const auto WH_MSGFILTER         = (-1);
		const auto WH_JOURNALRECORD     = 0;
		const auto WH_JOURNALPLAYBACK   = 1;
		const auto WH_KEYBOARD          = 2;
		const auto WH_GETMESSAGE        = 3;
		const auto WH_CALLWNDPROC       = 4;
		const auto WH_CBT               = 5;
		const auto WH_SYSMSGFILTER      = 6;
		const auto WH_MOUSE             = 7;
		
		const auto WH_HARDWARE          = 8;
		
		const auto WH_DEBUG             = 9;
		const auto WH_SHELL            = 10;
		const auto WH_FOREGROUNDIDLE   = 11;
		
		const auto WH_CALLWNDPROCRET   = 12;
		
		const auto WH_KEYBOARD_LL      = 13;
		const auto WH_MOUSE_LL         = 14;
		
		const auto WH_MAX              = 14;
		
		const auto WH_MINHOOK          = WH_MIN;
		const auto WH_MAXHOOK          = WH_MAX;
		
		/*
		 * Hook Codes
		 */
		const auto HC_ACTION            = 0;
		const auto HC_GETNEXT           = 1;
		const auto HC_SKIP              = 2;
		const auto HC_NOREMOVE          = 3;
		const auto HC_NOREM             = HC_NOREMOVE;
		const auto HC_SYSMODALON        = 4;
		const auto HC_SYSMODALOFF       = 5;
		
		/*
		 * CBT Hook Codes
		 */
		const auto HCBT_MOVESIZE        = 0;
		const auto HCBT_MINMAX          = 1;
		const auto HCBT_QS              = 2;
		const auto HCBT_CREATEWND       = 3;
		const auto HCBT_DESTROYWND      = 4;
		const auto HCBT_ACTIVATE        = 5;
		const auto HCBT_CLICKSKIPPED    = 6;
		const auto HCBT_KEYSKIPPED      = 7;
		const auto HCBT_SYSCOMMAND      = 8;
		const auto HCBT_SETFOCUS        = 9;
		
		/*
		 * HCBT_CREATEWND parameters pointed to by lParam
		 */
		struct CBT_CREATEWNDA {
		    CREATESTRUCTA *lpcs;
		    HWND           hwndInsertAfter;
		}

		alias CBT_CREATEWNDA* LPCBT_CREATEWNDA;
		/*
		 * HCBT_CREATEWND parameters pointed to by lParam
		 */
		struct CBT_CREATEWNDW {
		    CREATESTRUCTW *lpcs;
		    HWND           hwndInsertAfter;
		}
		
		alias CBT_CREATEWNDW* LPCBT_CREATEWNDW;
		
		version(UNICODE) {
			alias CBT_CREATEWNDW CBT_CREATEWND;
			alias LPCBT_CREATEWNDW LPCBT_CREATEWND;
		}
		else {
			alias CBT_CREATEWNDA CBT_CREATEWND;
			alias LPCBT_CREATEWNDA LPCBT_CREATEWND;
		}
		
		/*
		 * HCBT_ACTIVATE structure pointed to by lParam
		 */
		struct CBTACTIVATESTRUCT {
		    BOOL    fMouse;
		    HWND    hWndActive;
		}
		
		alias CBTACTIVATESTRUCT* LPCBTACTIVATESTRUCT;
		
		/*
		 * WTSSESSION_NOTIFICATION struct pointed by lParam, for WM_WTSSESSION_CHANGE
		 */
		struct WTSSESSION_NOTIFICATION {
		    DWORD cbSize;
		    DWORD dwSessionId;
		
		}
		
		alias WTSSESSION_NOTIFICATION* PWTSSESSION_NOTIFICATION;
		
		/*
		 * codes passed in WPARAM for WM_WTSSESSION_CHANGE
		 */
		
		const auto WTS_CONSOLE_CONNECT                 = 0x1;
		const auto WTS_CONSOLE_DISCONNECT              = 0x2;
		const auto WTS_REMOTE_CONNECT                  = 0x3;
		const auto WTS_REMOTE_DISCONNECT               = 0x4;
		const auto WTS_SESSION_LOGON                   = 0x5;
		const auto WTS_SESSION_LOGOFF                  = 0x6;
		const auto WTS_SESSION_LOCK                    = 0x7;
		const auto WTS_SESSION_UNLOCK                  = 0x8;
		const auto WTS_SESSION_REMOTE_CONTROL          = 0x9;
		
		/*
		 * WH_MSGFILTER Filter Proc Codes
		 */
		const auto MSGF_DIALOGBOX       = 0;
		const auto MSGF_MESSAGEBOX      = 1;
		const auto MSGF_MENU            = 2;
		const auto MSGF_SCROLLBAR       = 5;
		const auto MSGF_NEXTWINDOW      = 6;
		const auto MSGF_MAX             = 8                       ; // unused
		const auto MSGF_USER            = 4096;
		
		/*
		 * Shell support
		 */
		const auto HSHELL_WINDOWCREATED         = 1;
		const auto HSHELL_WINDOWDESTROYED       = 2;
		const auto HSHELL_ACTIVATESHELLWINDOW   = 3;
		
		const auto HSHELL_WINDOWACTIVATED       = 4;
		const auto HSHELL_GETMINRECT            = 5;
		const auto HSHELL_REDRAW                = 6;
		const auto HSHELL_TASKMAN               = 7;
		const auto HSHELL_LANGUAGE              = 8;
		const auto HSHELL_SYSMENU               = 9;
		const auto HSHELL_ENDTASK               = 10;
		
		const auto HSHELL_ACCESSIBILITYSTATE    = 11;
		const auto HSHELL_APPCOMMAND            = 12;
		
		const auto HSHELL_WINDOWREPLACED        = 13;
		const auto HSHELL_WINDOWREPLACING       = 14;
		
		const auto HSHELL_HIGHBIT             = 0x8000;
		const auto HSHELL_FLASH               = (HSHELL_REDRAW|HSHELL_HIGHBIT);
		const auto HSHELL_RUDEAPPACTIVATED    = (HSHELL_WINDOWACTIVATED|HSHELL_HIGHBIT);
		
		/* cmd for HSHELL_APPCOMMAND and WM_APPCOMMAND */
		const auto APPCOMMAND_BROWSER_BACKWARD        = 1;
		const auto APPCOMMAND_BROWSER_FORWARD         = 2;
		const auto APPCOMMAND_BROWSER_REFRESH         = 3;
		const auto APPCOMMAND_BROWSER_STOP            = 4;
		const auto APPCOMMAND_BROWSER_SEARCH          = 5;
		const auto APPCOMMAND_BROWSER_FAVORITES       = 6;
		const auto APPCOMMAND_BROWSER_HOME            = 7;
		const auto APPCOMMAND_VOLUME_MUTE             = 8;
		const auto APPCOMMAND_VOLUME_DOWN             = 9;
		const auto APPCOMMAND_VOLUME_UP               = 10;
		const auto APPCOMMAND_MEDIA_NEXTTRACK         = 11;
		const auto APPCOMMAND_MEDIA_PREVIOUSTRACK     = 12;
		const auto APPCOMMAND_MEDIA_STOP              = 13;
		const auto APPCOMMAND_MEDIA_PLAY_PAUSE        = 14;
		const auto APPCOMMAND_LAUNCH_MAIL             = 15;
		const auto APPCOMMAND_LAUNCH_MEDIA_SELECT     = 16;
		const auto APPCOMMAND_LAUNCH_APP1             = 17;
		const auto APPCOMMAND_LAUNCH_APP2             = 18;
		const auto APPCOMMAND_BASS_DOWN               = 19;
		const auto APPCOMMAND_BASS_BOOST              = 20;
		const auto APPCOMMAND_BASS_UP                 = 21;
		const auto APPCOMMAND_TREBLE_DOWN             = 22;
		const auto APPCOMMAND_TREBLE_UP               = 23;
		
		const auto APPCOMMAND_MICROPHONE_VOLUME_MUTE  = 24;
		const auto APPCOMMAND_MICROPHONE_VOLUME_DOWN  = 25;
		const auto APPCOMMAND_MICROPHONE_VOLUME_UP    = 26;
		const auto APPCOMMAND_HELP                    = 27;
		const auto APPCOMMAND_FIND                    = 28;
		const auto APPCOMMAND_NEW                     = 29;
		const auto APPCOMMAND_OPEN                    = 30;
		const auto APPCOMMAND_CLOSE                   = 31;
		const auto APPCOMMAND_SAVE                    = 32;
		const auto APPCOMMAND_PRINT                   = 33;
		const auto APPCOMMAND_UNDO                    = 34;
		const auto APPCOMMAND_REDO                    = 35;
		const auto APPCOMMAND_COPY                    = 36;
		const auto APPCOMMAND_CUT                     = 37;
		const auto APPCOMMAND_PASTE                   = 38;
		const auto APPCOMMAND_REPLY_TO_MAIL           = 39;
		const auto APPCOMMAND_FORWARD_MAIL            = 40;
		const auto APPCOMMAND_SEND_MAIL               = 41;
		const auto APPCOMMAND_SPELL_CHECK             = 42;
		const auto APPCOMMAND_DICTATE_OR_COMMAND_CONTROL_TOGGLE     = 43;
		const auto APPCOMMAND_MIC_ON_OFF_TOGGLE       = 44;
		const auto APPCOMMAND_CORRECTION_LIST         = 45;
		const auto APPCOMMAND_MEDIA_PLAY              = 46;
		const auto APPCOMMAND_MEDIA_PAUSE             = 47;
		const auto APPCOMMAND_MEDIA_RECORD            = 48;
		const auto APPCOMMAND_MEDIA_FAST_FORWARD      = 49;
		const auto APPCOMMAND_MEDIA_REWIND            = 50;
		const auto APPCOMMAND_MEDIA_CHANNEL_UP        = 51;
		const auto APPCOMMAND_MEDIA_CHANNEL_DOWN      = 52;
		
		const auto APPCOMMAND_DELETE                  = 53;
		const auto APPCOMMAND_DWM_FLIP3D              = 54;
		
		const auto FAPPCOMMAND_MOUSE  = 0x8000;
		const auto FAPPCOMMAND_KEY    = 0;
		const auto FAPPCOMMAND_OEM    = 0x1000;
		const auto FAPPCOMMAND_MASK   = 0xF000;
		
		WORD GET_APPCOMMAND_LPARAM(LPARAM lParam) {
			return cast(WORD)(cast(short)(HIWORD(lParam) & ~FAPPCOMMAND_MASK));
		}

		WORD GET_DEVICE_LPARAM(LPARAM lParam) {
			return cast(WORD)(cast(WORD)(HIWORD(lParam) & FAPPCOMMAND_MASK));
		}

		alias GET_DEVICE_LPARAM GET_MOUSEORKEY_LPARAM;

		WORD GET_FLAGS_LPARAM(LPARAM lParam) {
			return LOWORD(lParam);
		}
		
		alias GET_FLAGS_LPARAM GET_KEYSTATE_LPARAM;

		struct SHELLHOOKINFO {
		    HWND    hwnd;
		    RECT    rc;
		}
		
		alias SHELLHOOKINFO* LPSHELLHOOKINFO;

		/*
		 * Message Structure used in Journaling
		 */
		struct EVENTMSG {
		    UINT    message;
		    UINT    param;
		    UINT    paramH;
		    DWORD    time;
		    HWND     hwnd;
		}
	
		alias EVENTMSG* PEVENTMSGMSG;
		alias EVENTMSG* NPEVENTMSGMSG;
		alias EVENTMSG* LPEVENTMSGMSG;
		
		struct CWPSTRUCT {
		    LPARAM  lParam;
		    WPARAM  wParam;
		    UINT    message;
		    HWND    hwnd;
		}
		
		alias CWPSTRUCT* PCWPSTRUCT;
		alias CWPSTRUCT* NPCWPSTRUCT;
		alias CWPSTRUCT* LPCWPSTRUCT;
		
		/*
		 * Message structure used by WH_CALLWNDPROCRET
		 */
		struct CWPRETSTRUCT {
		    LRESULT lResult;
		    LPARAM  lParam;
		    WPARAM  wParam;
		    UINT    message;
		    HWND    hwnd;
		}
		
		alias CWPRETSTRUCT* PCWPRETSTRUCT;
		alias CWPRETSTRUCT* NPCWPRETSTRUCT;
		alias CWPRETSTRUCT* LPCWPRETSTRUCT;
		
		/*
		 * Low level hook flags
		 */
		
		const auto LLKHF_EXTENDED        = (KF_EXTENDED >> 8);
		const auto LLKHF_INJECTED        = 0x00000010;
		const auto LLKHF_ALTDOWN         = (KF_ALTDOWN >> 8);
		const auto LLKHF_UP              = (KF_UP >> 8);
		
		const auto LLMHF_INJECTED        = 0x00000001;
		
		/*
		 * Structure used by WH_KEYBOARD_LL
		 */
		struct KBDLLHOOKSTRUCT {
		    DWORD   vkCode;
		    DWORD   scanCode;
		    DWORD   flags;
		    DWORD   time;
		    ULONG_PTR dwExtraInfo;
		}
		
		alias KBDLLHOOKSTRUCT* LPKBDLLHOOKSTRUCT;
		alias KBDLLHOOKSTRUCT* PKBDLLHOOKSTRUCT;

		/*
		 * Structure used by WH_MOUSE_LL
		 */
		struct MSLLHOOKSTRUCT {
		    POINT   pt;
		    DWORD   mouseData;
		    DWORD   flags;
		    DWORD   time;
		    ULONG_PTR dwExtraInfo;
		}

		alias MSLLHOOKSTRUCT* LPMSLLHOOKSTRUCT;
		alias MSLLHOOKSTRUCT* PMSLLHOOKSTRUCT;

		/*
		 * Structure used by WH_DEBUG
		 */
		struct DEBUGHOOKINFO {
		    DWORD   idThread;
		    DWORD   idThreadInstaller;
		    LPARAM  lParam;
		    WPARAM  wParam;
		    int     code;
		}

		alias DEBUGHOOKINFO* PDEBUGHOOKINFO;
		alias DEBUGHOOKINFO* NPDEBUGHOOKINFO;
		alias DEBUGHOOKINFO* LPDEBUGHOOKINFO;

		/*
		 * Structure used by WH_MOUSE
		 */
		struct MOUSEHOOKSTRUCT {
		    POINT   pt;
		    HWND    hwnd;
		    UINT    wHitTestCode;
		    ULONG_PTR dwExtraInfo;
		}

		alias MOUSEHOOKSTRUCT* LPMOUSEHOOKSTRUCT;
		alias MOUSEHOOKSTRUCT* PMOUSEHOOKSTRUCT;

		struct MOUSEHOOKSTRUCTEX {
		    DWORD   mouseData;
		}

		alias MOUSEHOOKSTRUCTEX* LPMOUSEHOOKSTRUCTEX;
		alias MOUSEHOOKSTRUCTEX* PMOUSEHOOKSTRUCTEX;

		/*
		 * Structure used by WH_HARDWARE
		 */
		struct HARDWAREHOOKSTRUCT {
		    HWND    hwnd;
		    UINT    message;
		    WPARAM  wParam;
		    LPARAM  lParam;
		}

		alias HARDWAREHOOKSTRUCT* LPHARDWAREHOOKSTRUCT;
		alias HARDWAREHOOKSTRUCT* PHARDWAREHOOKSTRUCT;
	}
	
	/*
	 * Keyboard Layout API
	 */
	const auto HKL_PREV             = 0;
	const auto HKL_NEXT             = 1;
	
	
	const auto KLF_ACTIVATE         = 0x00000001;
	const auto KLF_SUBSTITUTE_OK    = 0x00000002;
	const auto KLF_REORDER          = 0x00000008;
	
	const auto KLF_REPLACELANG      = 0x00000010;
	const auto KLF_NOTELLSHELL      = 0x00000080;
	
	const auto KLF_SETFORPROCESS    = 0x00000100;
	
	const auto KLF_SHIFTLOCK        = 0x00010000;
	const auto KLF_RESET            = 0x40000000;
	
	/*
	 * Bits in wParam of WM_INPUTLANGCHANGEREQUEST message
	 */
	const auto INPUTLANGCHANGE_SYSCHARSET  = 0x0001;
	const auto INPUTLANGCHANGE_FORWARD     = 0x0002;
	const auto INPUTLANGCHANGE_BACKWARD    = 0x0004;
	
	
	/*
	 * Size of KeyboardLayoutName (number of characters), including nul terminator
	 */
	const auto KL_NAMELENGTH  = 9;
	
	HKL
	LoadKeyboardLayoutA(
	     LPCSTR pwszKLID,
	     UINT Flags);
	HKL
	LoadKeyboardLayoutW(
	     LPCWSTR pwszKLID,
	     UINT Flags);
	
	version(UNICODE) {
		alias LoadKeyboardLayoutW LoadKeyboardLayout;
	}
	else {
		alias LoadKeyboardLayoutA LoadKeyboardLayout;
	}
	
	
	HKL
	ActivateKeyboardLayout(
	     HKL hkl,
	     UINT Flags);
	
	int
	ToUnicodeEx(
	     UINT wVirtKey,
	     UINT wScanCode,
	    BYTE *lpKeyState,
	    LPWSTR pwszBuff,
	     int cchBuff,
	     UINT wFlags,
	     HKL dwhkl);
	
	BOOL
	UnloadKeyboardLayout(
	     HKL hkl);
	
	BOOL
	GetKeyboardLayoutNameA(
	    LPSTR pwszKLID);
	BOOL
	GetKeyboardLayoutNameW(
	    LPWSTR pwszKLID);
	
	version(UNICODE) {
		alias GetKeyboardLayoutNameW GetKeyboardLayoutName;
	}
	else {
		alias GetKeyboardLayoutNameA GetKeyboardLayoutName;
	}
	
	int
	GetKeyboardLayoutList(
	     int nBuff,
	    HKL *lpList);
	
	HKL
	GetKeyboardLayout(
	     DWORD idThread);
	
	struct MOUSEMOVEPOINT {
	    int   x;
	    int   y;
	    DWORD time;
	    ULONG_PTR dwExtraInfo;
	}
	
	alias MOUSEMOVEPOINT* PMOUSEMOVEPOINT;
	alias MOUSEMOVEPOINT* LPMOUSEMOVEPOINT;
	
	/*
	 * Values for resolution parameter of GetMouseMovePointsEx
	 */
	const auto GMMP_USE_DISPLAY_POINTS           = 1;
	const auto GMMP_USE_HIGH_RESOLUTION_POINTS   = 2;
	
	int
	GetMouseMovePointsEx(
	     UINT cbSize,
	     LPMOUSEMOVEPOINT lppt,
	    LPMOUSEMOVEPOINT lpptBuf,
	     int nBufPoints,
	     DWORD resolution);
	
	version(NODESKTOP) {
	}
	else {
	
		/*
		 * Desktop-specific access flags
		 */
		const auto DESKTOP_READOBJECTS          = 0x0001;
		const auto DESKTOP_CREATEWINDOW         = 0x0002;
		const auto DESKTOP_CREATEMENU           = 0x0004;
		const auto DESKTOP_HOOKCONTROL          = 0x0008;
		const auto DESKTOP_JOURNALRECORD        = 0x0010;
		const auto DESKTOP_JOURNALPLAYBACK      = 0x0020;
		const auto DESKTOP_ENUMERATE            = 0x0040;
		const auto DESKTOP_WRITEOBJECTS         = 0x0080;
		const auto DESKTOP_SWITCHDESKTOP        = 0x0100;
		
		/*
		 * Desktop-specific control flags
		 */
		const auto DF_ALLOWOTHERACCOUNTHOOK     = 0x0001;
		
		version(NOGDI) {
		}
		else {

			HDESK CreateDesktopA(
			     LPCSTR lpszDesktop,
			     LPCSTR lpszDevice,
			     LPDEVMODEA pDevmode,
			     DWORD dwFlags,
			     ACCESS_MASK dwDesiredAccess,
			     LPSECURITY_ATTRIBUTES lpsa);

			HDESK CreateDesktopW(
			     LPCWSTR lpszDesktop,
			    LPCWSTR lpszDevice,
			    LPDEVMODEW pDevmode,
			     DWORD dwFlags,
			     ACCESS_MASK dwDesiredAccess,
			     LPSECURITY_ATTRIBUTES lpsa);

			version(UNICODE) {
				alias CreateDesktopW CreateDesktop;
			}
			else {
				alias CreateDesktopA CreateDesktop;
			}

			HDESK CreateDesktopExA(
			     LPCSTR lpszDesktop,
			     LPCSTR lpszDevice,
			    LPDEVMODEA pDevmode,
			     DWORD dwFlags,
			     ACCESS_MASK dwDesiredAccess,
			     LPSECURITY_ATTRIBUTES lpsa,
			     ULONG ulHeapSize,
			    PVOID pvoid);
			HDESK
			CreateDesktopExW(
			     LPCWSTR lpszDesktop,
			    LPCWSTR lpszDevice,
			    LPDEVMODEW pDevmode,
			     DWORD dwFlags,
			     ACCESS_MASK dwDesiredAccess,
			     LPSECURITY_ATTRIBUTES lpsa,
			     ULONG ulHeapSize,
			    PVOID pvoid);
			
			version(UNICODE) {
				alias CreateDesktopExW CreateDesktopEx;
			}
			else {
				alias CreateDesktopExA CreateDesktopEx;
			}
		
		}
		
		HDESK
		OpenDesktopA(
		     LPCSTR lpszDesktop,
		     DWORD dwFlags,
		     BOOL fInherit,
		     ACCESS_MASK dwDesiredAccess);
		HDESK
		OpenDesktopW(
		     LPCWSTR lpszDesktop,
		     DWORD dwFlags,
		     BOOL fInherit,
		     ACCESS_MASK dwDesiredAccess);
		
		version(UNICODE) {
			alias OpenDesktopW OpenDesktop;
		}
		else {
			alias OpenDesktopA OpenDesktop;
		}
		
		HDESK
		OpenInputDesktop(
		     DWORD dwFlags,
		     BOOL fInherit,
		     ACCESS_MASK dwDesiredAccess);
		
		
		BOOL
		EnumDesktopsA(
		     HWINSTA hwinsta,
		     DESKTOPENUMPROCA lpEnumFunc,
		     LPARAM lParam);
		BOOL
		EnumDesktopsW(
		     HWINSTA hwinsta,
		     DESKTOPENUMPROCW lpEnumFunc,
		     LPARAM lParam);
		
		version(UNICODE) {
			alias EnumDesktopsW EnumDesktops;
		}
		else {
			alias EnumDesktopsA EnumDesktops;
		}
		
		BOOL
		EnumDesktopWindows(
		     HDESK hDesktop,
		     WNDENUMPROC lpfn,
		     LPARAM lParam);
		
		BOOL
		SwitchDesktop(
		     HDESK hDesktop);
		
		
		BOOL
		SetThreadDesktop(
		      HDESK hDesktop);

		BOOL
		CloseDesktop(
		     HDESK hDesktop);
		
		HDESK
		GetThreadDesktop(
		     DWORD dwThreadId);
	
	}
	
	version(NOWINDOWSTATION) {
	}
	else {
		/*
		 * Windowstation-specific access flags
		 */
		const auto WINSTA_ENUMDESKTOPS          = 0x0001;
		const auto WINSTA_READATTRIBUTES        = 0x0002;
		const auto WINSTA_ACCESSCLIPBOARD       = 0x0004;
		const auto WINSTA_CREATEDESKTOP         = 0x0008;
		const auto WINSTA_WRITEATTRIBUTES       = 0x0010;
		const auto WINSTA_ACCESSGLOBALATOMS     = 0x0020;
		const auto WINSTA_EXITWINDOWS           = 0x0040;
		const auto WINSTA_ENUMERATE             = 0x0100;
		const auto WINSTA_READSCREEN            = 0x0200;
		
		const auto WINSTA_ALL_ACCESS            = (WINSTA_ENUMDESKTOPS  | WINSTA_READATTRIBUTES  | WINSTA_ACCESSCLIPBOARD |
		                                     WINSTA_CREATEDESKTOP | WINSTA_WRITEATTRIBUTES | WINSTA_ACCESSGLOBALATOMS |
		                                     WINSTA_EXITWINDOWS   | WINSTA_ENUMERATE       | WINSTA_READSCREEN);
		
		/*
		 * Windowstation creation flags.
		 */
		const auto CWF_CREATE_ONLY           = 0x00000001;
		
		/*
		 * Windowstation-specific attribute flags
		 */
		const auto WSF_VISIBLE                  = 0x0001;
		
		HWINSTA
		CreateWindowStationA(
		     LPCSTR lpwinsta,
		     DWORD dwFlags,
		     ACCESS_MASK dwDesiredAccess,
		     LPSECURITY_ATTRIBUTES lpsa);
		HWINSTA
		CreateWindowStationW(
		     LPCWSTR lpwinsta,
		     DWORD dwFlags,
		     ACCESS_MASK dwDesiredAccess,
		     LPSECURITY_ATTRIBUTES lpsa);
		
		version(UNICODE) {
			alias CreateWindowStationW CreateWindowStation;
		}
		else {
			alias CreateWindowStationA CreateWindowStation;
		}
		
		HWINSTA
		OpenWindowStationA(
		     LPCSTR lpszWinSta,
		     BOOL fInherit,
		     ACCESS_MASK dwDesiredAccess);
		HWINSTA
		OpenWindowStationW(
		     LPCWSTR lpszWinSta,
		     BOOL fInherit,
		     ACCESS_MASK dwDesiredAccess);
		
		version(UNICODE) {
			alias OpenWindowStationW OpenWindowStation;
		}
		else {
			alias OpenWindowStationA OpenWindowStation;
		}
		
		BOOL
		EnumWindowStationsA(
		     WINSTAENUMPROCA lpEnumFunc,
		     LPARAM lParam);
		BOOL
		EnumWindowStationsW(
		     WINSTAENUMPROCW lpEnumFunc,
		     LPARAM lParam);
		
		version(UNICODE) {
			alias EnumWindowStationsW EnumWindowStations;
		}
		else {
			alias EnumWindowStationsA EnumWindowStations;
		}
		
		BOOL
		CloseWindowStation(
		     HWINSTA hWinSta);
		
		BOOL
		SetProcessWindowStation(
		     HWINSTA hWinSta);
		
		HWINSTA
		GetProcessWindowStation();
	}
	
	version(NOSECURITY) {
	}
	else {
		BOOL SetUserObjectSecurity(
		     HANDLE hObj,
		     PSECURITY_INFORMATION pSIRequested,
		     PSECURITY_DESCRIPTOR pSID);
	
		BOOL GetUserObjectSecurity(
		     HANDLE hObj,
		     PSECURITY_INFORMATION pSIRequested,
		    PSECURITY_DESCRIPTOR pSID,
		     DWORD nLength,
		     LPDWORD lpnLengthNeeded);
	
		const auto UOI_FLAGS        = 1;
		const auto UOI_NAME         = 2;
		const auto UOI_TYPE         = 3;
		const auto UOI_USER_SID     = 4;
	
		const auto UOI_HEAPSIZE     = 5;
		const auto UOI_IO           = 6;
	
		struct USEROBJECTFLAGS {
		    BOOL fInherit;
		    BOOL fReserved;
		    DWORD dwFlags;
		}
		
		alias USEROBJECTFLAGS* PUSEROBJECTFLAGS;
		
		BOOL GetUserObjectInformationA(
		     HANDLE hObj,
		     int nIndex,
			 PVOID pvInfo,
		     DWORD nLength,
		     LPDWORD lpnLengthNeeded);
		BOOL GetUserObjectInformationW(
		     HANDLE hObj,
		     int nIndex,
			 PVOID pvInfo,
		     DWORD nLength,
		     LPDWORD lpnLengthNeeded);
	
		version(UNICODE) {
			alias GetUserObjectInformationW GetUserObjectInformation;
		}
		else {
			alias GetUserObjectInformationA GetUserObjectInformation;
		}
	
		BOOL SetUserObjectInformationA(
		     HANDLE hObj,
		     int nIndex,
			 PVOID pvInfo,
		     DWORD nLength);
		BOOL SetUserObjectInformationW(
		     HANDLE hObj,
		     int nIndex,
			 PVOID pvInfo,
		     DWORD nLength);
	
		version(UNICODE) {
			alias SetUserObjectInformationW SetUserObjectInformation;
		}
		else {
			alias SetUserObjectInformationA SetUserObjectInformation;
		}
	
	}
	
	struct WNDCLASSEXA {
	    UINT        cbSize;
	    /* Win 3.x */
	    UINT        style;
	    WNDPROC     lpfnWndProc;
	    int         cbClsExtra;
	    int         cbWndExtra;
	    HINSTANCE   hInstance;
	    HICON       hIcon;
	    HCURSOR     hCursor;
	    HBRUSH      hbrBackground;
	    LPCSTR      lpszMenuName;
	    LPCSTR      lpszClassName;
	    /* Win 4.0 */
	    HICON       hIconSm;
	}
	
	alias WNDCLASSEXA* PWNDCLASSEXA;
	alias WNDCLASSEXA* NPWNDCLASSEXA;
	alias WNDCLASSEXA* LPWNDCLASSEXA;
	
	struct WNDCLASSEXW {
	    UINT        cbSize;
	    /* Win 3.x */
	    UINT        style;
	    WNDPROC     lpfnWndProc;
	    int         cbClsExtra;
	    int         cbWndExtra;
	    HINSTANCE   hInstance;
	    HICON       hIcon;
	    HCURSOR     hCursor;
	    HBRUSH      hbrBackground;
	    LPCWSTR     lpszMenuName;
	    LPCWSTR     lpszClassName;
	    /* Win 4.0 */
	    HICON       hIconSm;
	}
	
	alias WNDCLASSEXW* PWNDCLASSEXW;
	alias WNDCLASSEXW* NPWNDCLASSEXW;
	alias WNDCLASSEXW* LPWNDCLASSEXW;
	
	version(UNICODE) {
		alias WNDCLASSEXW WNDCLASSEX;
		alias PWNDCLASSEXW PWNDCLASSEX;
		alias NPWNDCLASSEXW NPWNDCLASSEX;
		alias LPWNDCLASSEXW LPWNDCLASSEX;
	}
	else {
		alias WNDCLASSEXA WNDCLASSEX;
		alias PWNDCLASSEXA PWNDCLASSEX;
		alias NPWNDCLASSEXA NPWNDCLASSEX;
		alias LPWNDCLASSEXA LPWNDCLASSEX;
	}
	
	struct WNDCLASSA {
	    UINT        style;
	    WNDPROC     lpfnWndProc;
	    int         cbClsExtra;
	    int         cbWndExtra;
	    HINSTANCE   hInstance;
	    HICON       hIcon;
	    HCURSOR     hCursor;
	    HBRUSH      hbrBackground;
	    LPCSTR      lpszMenuName;
	    LPCSTR      lpszClassName;
	}
	
	alias WNDCLASSA* PWNDCLASSA;
	alias WNDCLASSA  *NPWNDCLASSA;
	alias WNDCLASSA  *LPWNDCLASSA;

	struct WNDCLASSW {
	    UINT        style;
	    WNDPROC     lpfnWndProc;
	    int         cbClsExtra;
	    int         cbWndExtra;
	    HINSTANCE   hInstance;
	    HICON       hIcon;
	    HCURSOR     hCursor;
	    HBRUSH      hbrBackground;
	    LPCWSTR     lpszMenuName;
	    LPCWSTR     lpszClassName;
	}
	
	alias WNDCLASSW* PWNDCLASSW;
	alias WNDCLASSW  *NPWNDCLASSW;
	alias WNDCLASSW  *LPWNDCLASSW;
	
	version(UNICODE) {
		alias WNDCLASSW WNDCLASS;
		alias PWNDCLASSW PWNDCLASS;
		alias NPWNDCLASSW NPWNDCLASS;
		alias LPWNDCLASSW LPWNDCLASS;
	}
	else {
		alias WNDCLASSA WNDCLASS;
		alias PWNDCLASSA PWNDCLASS;
		alias NPWNDCLASSA NPWNDCLASS;
		alias LPWNDCLASSA LPWNDCLASS;
	}
	
	BOOL IsHungAppWindow(
	     HWND hwnd);
	
	VOID DisableProcessWindowsGhosting();
	
	version(NOMSG) {
	}
	else {
		/*
		 * Message structure
		 */
		struct MSG {
		    HWND        hwnd;
		    UINT        message;
		    WPARAM      wParam;
		    LPARAM      lParam;
		    DWORD       time;
		    POINT       pt;
		}
	
		alias MSG* PMSG;
		alias MSG  *NPMSG;
		alias MSG  *LPMSG;
	
		/*const auto POINTSTOPOINT(pt,  = pts)                          \;
		        { (pt).x = (LONG)(SHORT)LOWORD(*(LONG*)&pts);   \
		          (pt).y = (LONG)(SHORT)HIWORD(*(LONG*)&pts); }
	
		const auto POINTTOPOINTS(pt)       = (MAKELONG((short)((pt).x), (short)((pt).y)));
		const auto MAKEWPARAM(l,  = h)      ((WPARAM)(DWORD)MAKELONG(l, h));
		const auto MAKELPARAM(l,  = h)      ((LPARAM)(DWORD)MAKELONG(l, h));
		const auto MAKELRESULT(l,  = h)     ((LRESULT)(DWORD)MAKELONG(l, h));
	
		*/
	}
	
	version(NOWINOFFSETS) {
	}
	else {
		/*
		 * Window field offsets for GetWindowLong()
		 */
		const auto GWL_WNDPROC          = (-4);
		const auto GWL_HINSTANCE        = (-6);
		const auto GWL_HWNDPARENT       = (-8);
		const auto GWL_STYLE            = (-16);
		const auto GWL_EXSTYLE          = (-20);
		const auto GWL_USERDATA         = (-21);
		const auto GWL_ID               = (-12);
	
		const auto GWLP_WNDPROC         = (-4);
		const auto GWLP_HINSTANCE       = (-6);
		const auto GWLP_HWNDPARENT      = (-8);
		const auto GWLP_USERDATA        = (-21);
		const auto GWLP_ID              = (-12);
	
		/*
		 * Class field offsets for GetClassLong()
		 */
		const auto GCL_MENUNAME         = (-8);
		const auto GCL_HBRBACKGROUND    = (-10);
		const auto GCL_HCURSOR          = (-12);
		const auto GCL_HICON            = (-14);
		const auto GCL_HMODULE          = (-16);
		const auto GCL_CBWNDEXTRA       = (-18);
		const auto GCL_CBCLSEXTRA       = (-20);
		const auto GCL_WNDPROC          = (-24);
		const auto GCL_STYLE            = (-26);
		const auto GCW_ATOM             = (-32);
	
		const auto GCL_HICONSM          = (-34);
	
		const auto GCLP_MENUNAME        = (-8);
		const auto GCLP_HBRBACKGROUND   = (-10);
		const auto GCLP_HCURSOR         = (-12);
		const auto GCLP_HICON           = (-14);
		const auto GCLP_HMODULE         = (-16);
		const auto GCLP_WNDPROC         = (-24);
		const auto GCLP_HICONSM         = (-34);
	}
	
	version(NOWINMESSAGES) {
	}
	else {
		/*
		 * Window Messages
		 */
		
		const auto WM_NULL                          = 0x0000;
		const auto WM_CREATE                        = 0x0001;
		const auto WM_DESTROY                       = 0x0002;
		const auto WM_MOVE                          = 0x0003;
		const auto WM_SIZE                          = 0x0005;
		
		const auto WM_ACTIVATE                      = 0x0006;
		/*
		 * WM_ACTIVATE state values
		 */
		const auto      WA_INACTIVE     = 0;
		const auto      WA_ACTIVE       = 1;
		const auto      WA_CLICKACTIVE  = 2;
		
		const auto WM_SETFOCUS                      = 0x0007;
		const auto WM_KILLFOCUS                     = 0x0008;
		const auto WM_ENABLE                        = 0x000A;
		const auto WM_SETREDRAW                     = 0x000B;
		const auto WM_SETTEXT                       = 0x000C;
		const auto WM_GETTEXT                       = 0x000D;
		const auto WM_GETTEXTLENGTH                 = 0x000E;
		const auto WM_PAINT                         = 0x000F;
		const auto WM_CLOSE                         = 0x0010;
		
		const auto WM_QUERYENDSESSION               = 0x0011;
		const auto WM_QUERYOPEN                     = 0x0013;
		const auto WM_ENDSESSION                    = 0x0016;
		
		const auto WM_QUIT                          = 0x0012;
		const auto WM_ERASEBKGND                    = 0x0014;
		const auto WM_SYSCOLORCHANGE                = 0x0015;
		const auto WM_SHOWWINDOW                    = 0x0018;
		const auto WM_WININICHANGE                  = 0x001A;
		
		const auto WM_SETTINGCHANGE                 = WM_WININICHANGE;
		
		const auto WM_DEVMODECHANGE                 = 0x001B;
		const auto WM_ACTIVATEAPP                   = 0x001C;
		const auto WM_FONTCHANGE                    = 0x001D;
		const auto WM_TIMECHANGE                    = 0x001E;
		const auto WM_CANCELMODE                    = 0x001F;
		const auto WM_SETCURSOR                     = 0x0020;
		const auto WM_MOUSEACTIVATE                 = 0x0021;
		const auto WM_CHILDACTIVATE                 = 0x0022;
		const auto WM_QUEUESYNC                     = 0x0023;
		
		const auto WM_GETMINMAXINFO                 = 0x0024;
		/*
		 * Struct pointed to by WM_GETMINMAXINFO lParam
		 */
		struct MINMAXINFO {
		    POINT ptReserved;
		    POINT ptMaxSize;
		    POINT ptMaxPosition;
		    POINT ptMinTrackSize;
		    POINT ptMaxTrackSize;
		}
		
		alias MINMAXINFO* PMINMAXINFO;
		alias MINMAXINFO* LPMINMAXINFO;
		
		const auto WM_PAINTICON                     = 0x0026;
		const auto WM_ICONERASEBKGND                = 0x0027;
		const auto WM_NEXTDLGCTL                    = 0x0028;
		const auto WM_SPOOLERSTATUS                 = 0x002A;
		const auto WM_DRAWITEM                      = 0x002B;
		const auto WM_MEASUREITEM                   = 0x002C;
		const auto WM_DELETEITEM                    = 0x002D;
		const auto WM_VKEYTOITEM                    = 0x002E;
		const auto WM_CHARTOITEM                    = 0x002F;
		const auto WM_SETFONT                       = 0x0030;
		const auto WM_GETFONT                       = 0x0031;
		const auto WM_SETHOTKEY                     = 0x0032;
		const auto WM_GETHOTKEY                     = 0x0033;
		const auto WM_QUERYDRAGICON                 = 0x0037;
		const auto WM_COMPAREITEM                   = 0x0039;
		
		const auto WM_GETOBJECT                     = 0x003D;
		
		const auto WM_COMPACTING                    = 0x0041;
		const auto WM_COMMNOTIFY                    = 0x0044  /* no longer suported */;
		const auto WM_WINDOWPOSCHANGING             = 0x0046;
		const auto WM_WINDOWPOSCHANGED              = 0x0047;
		
		const auto WM_POWER                         = 0x0048;
		/*
		 * wParam for WM_POWER window message and DRV_POWER driver notification
		 */
		const auto PWR_OK               = 1;
		const auto PWR_FAIL             = (-1);
		const auto PWR_SUSPENDREQUEST   = 1;
		const auto PWR_SUSPENDRESUME    = 2;
		const auto PWR_CRITICALRESUME   = 3;
		
		const auto WM_COPYDATA                      = 0x004A;
		const auto WM_CANCELJOURNAL                 = 0x004B;
		
		
		/*
		 * lParam of WM_COPYDATA message points to...
		 */
		struct COPYDATASTRUCT {
		    ULONG_PTR dwData;
		    DWORD cbData;
			PVOID lpData;
		}
		
		alias COPYDATASTRUCT* PCOPYDATASTRUCT;
		
		struct MDINEXTMENU {
		    HMENU   hmenuIn;
		    HMENU   hmenuNext;
		    HWND    hwndNext;
		}
		
		alias MDINEXTMENU*  PMDINEXTMENU;
		alias MDINEXTMENU  * LPMDINEXTMENU;
		
		const auto WM_NOTIFY                        = 0x004E;
		const auto WM_INPUTLANGCHANGEREQUEST        = 0x0050;
		const auto WM_INPUTLANGCHANGE               = 0x0051;
		const auto WM_TCARD                         = 0x0052;
		const auto WM_HELP                          = 0x0053;
		const auto WM_USERCHANGED                   = 0x0054;
		const auto WM_NOTIFYFORMAT                  = 0x0055;
		
		const auto NFR_ANSI                              = 1;
		const auto NFR_UNICODE                           = 2;
		const auto NF_QUERY                              = 3;
		const auto NF_REQUERY                            = 4;
		
		const auto WM_CONTEXTMENU                   = 0x007B;
		const auto WM_STYLECHANGING                 = 0x007C;
		const auto WM_STYLECHANGED                  = 0x007D;
		const auto WM_DISPLAYCHANGE                 = 0x007E;
		const auto WM_GETICON                       = 0x007F;
		const auto WM_SETICON                       = 0x0080;
		
		const auto WM_NCCREATE                      = 0x0081;
		const auto WM_NCDESTROY                     = 0x0082;
		const auto WM_NCCALCSIZE                    = 0x0083;
		const auto WM_NCHITTEST                     = 0x0084;
		const auto WM_NCPAINT                       = 0x0085;
		const auto WM_NCACTIVATE                    = 0x0086;
		const auto WM_GETDLGCODE                    = 0x0087;
		
		const auto WM_SYNCPAINT                     = 0x0088;
		
		const auto WM_NCMOUSEMOVE                   = 0x00A0;
		const auto WM_NCLBUTTONDOWN                 = 0x00A1;
		const auto WM_NCLBUTTONUP                   = 0x00A2;
		const auto WM_NCLBUTTONDBLCLK               = 0x00A3;
		const auto WM_NCRBUTTONDOWN                 = 0x00A4;
		const auto WM_NCRBUTTONUP                   = 0x00A5;
		const auto WM_NCRBUTTONDBLCLK               = 0x00A6;
		const auto WM_NCMBUTTONDOWN                 = 0x00A7;
		const auto WM_NCMBUTTONUP                   = 0x00A8;
		const auto WM_NCMBUTTONDBLCLK               = 0x00A9;
		
		const auto WM_NCXBUTTONDOWN                 = 0x00AB;
		const auto WM_NCXBUTTONUP                   = 0x00AC;
		const auto WM_NCXBUTTONDBLCLK               = 0x00AD;
		
		const auto WM_INPUT_DEVICE_CHANGE           = 0x00FE;
		
		const auto WM_INPUT                         = 0x00FF;
		
		const auto WM_KEYFIRST                      = 0x0100;
		const auto WM_KEYDOWN                       = 0x0100;
		const auto WM_KEYUP                         = 0x0101;
		const auto WM_CHAR                          = 0x0102;
		const auto WM_DEADCHAR                      = 0x0103;
		const auto WM_SYSKEYDOWN                    = 0x0104;
		const auto WM_SYSKEYUP                      = 0x0105;
		const auto WM_SYSCHAR                       = 0x0106;
		const auto WM_SYSDEADCHAR                   = 0x0107;
		
		const auto WM_UNICHAR                       = 0x0109;
		const auto WM_KEYLAST                       = 0x0109;
		const auto UNICODE_NOCHAR                   = 0xFFFF;
		
		const auto WM_IME_STARTCOMPOSITION          = 0x010D;
		const auto WM_IME_ENDCOMPOSITION            = 0x010E;
		const auto WM_IME_COMPOSITION               = 0x010F;
		const auto WM_IME_KEYLAST                   = 0x010F;
		
		const auto WM_INITDIALOG                    = 0x0110;
		const auto WM_COMMAND                       = 0x0111;
		const auto WM_SYSCOMMAND                    = 0x0112;
		const auto WM_TIMER                         = 0x0113;
		const auto WM_HSCROLL                       = 0x0114;
		const auto WM_VSCROLL                       = 0x0115;
		const auto WM_INITMENU                      = 0x0116;
		const auto WM_INITMENUPOPUP                 = 0x0117;
		const auto WM_MENUSELECT                    = 0x011F;
		const auto WM_MENUCHAR                      = 0x0120;
		const auto WM_ENTERIDLE                     = 0x0121;
		
		const auto WM_MENURBUTTONUP                 = 0x0122;
		const auto WM_MENUDRAG                      = 0x0123;
		const auto WM_MENUGETOBJECT                 = 0x0124;
		const auto WM_UNINITMENUPOPUP               = 0x0125;
		const auto WM_MENUCOMMAND                   = 0x0126;
		
		const auto WM_CHANGEUISTATE                 = 0x0127;
		const auto WM_UPDATEUISTATE                 = 0x0128;
		const auto WM_QUERYUISTATE                  = 0x0129;
		
		/*
		 * LOWORD(wParam) values in WM_*UISTATE*
		 */
		const auto UIS_SET                          = 1;
		const auto UIS_CLEAR                        = 2;
		const auto UIS_INITIALIZE                   = 3;
		
		/*
		 * HIWORD(wParam) values in WM_*UISTATE*
		 */
		const auto UISF_HIDEFOCUS                   = 0x1;
		const auto UISF_HIDEACCEL                   = 0x2;
		const auto UISF_ACTIVE                      = 0x4;
		
		const auto WM_CTLCOLORMSGBOX                = 0x0132;
		const auto WM_CTLCOLOREDIT                  = 0x0133;
		const auto WM_CTLCOLORLISTBOX               = 0x0134;
		const auto WM_CTLCOLORBTN                   = 0x0135;
		const auto WM_CTLCOLORDLG                   = 0x0136;
		const auto WM_CTLCOLORSCROLLBAR             = 0x0137;
		const auto WM_CTLCOLORSTATIC                = 0x0138;
		const auto MN_GETHMENU                      = 0x01E1;
		
		const auto WM_MOUSEFIRST                    = 0x0200;
		const auto WM_MOUSEMOVE                     = 0x0200;
		const auto WM_LBUTTONDOWN                   = 0x0201;
		const auto WM_LBUTTONUP                     = 0x0202;
		const auto WM_LBUTTONDBLCLK                 = 0x0203;
		const auto WM_RBUTTONDOWN                   = 0x0204;
		const auto WM_RBUTTONUP                     = 0x0205;
		const auto WM_RBUTTONDBLCLK                 = 0x0206;
		const auto WM_MBUTTONDOWN                   = 0x0207;
		const auto WM_MBUTTONUP                     = 0x0208;
		const auto WM_MBUTTONDBLCLK                 = 0x0209;
		
		const auto WM_MOUSEWHEEL                    = 0x020A;
		
		const auto WM_XBUTTONDOWN                   = 0x020B;
		const auto WM_XBUTTONUP                     = 0x020C;
		const auto WM_XBUTTONDBLCLK                 = 0x020D;
		
		const auto WM_MOUSEHWHEEL                   = 0x020E;
		
		const auto WM_MOUSELAST                     = 0x020E;
		
		/* Value for rolling one detent */
		const auto WHEEL_DELTA                      = 120;
		
		WORD GET_WHEEL_DELTA_WPARAM(WPARAM wParam) {
			return cast(WORD)HIWORD(wParam);
		}

		/* Setting to scroll one page for SPI_GET/SETWHEELSCROLLLINES */
		const auto WHEEL_PAGESCROLL                 = (UINT.max);
		
		DWORD GET_KEYSTATE_WPARAM(WPARAM wParam) {
			return LOWORD(wParam);
		}
		
		DWORD GET_NCHITTEST_WPARAM(WPARAM wParam) {
			return cast(short)LOWORD(wParam);
		}
		
		DWORD GET_XBUTTON_WPARAM(WPARAM wParam) {
			return HIWORD(wParam);
		}

		/* XButton values are WORD flags */
		const auto XBUTTON1       = 0x0001;
		const auto XBUTTON2       = 0x0002;
		/* Were there to be an XBUTTON3, its value would be 0x0004 */
		
		const auto WM_PARENTNOTIFY                  = 0x0210;
		const auto WM_ENTERMENULOOP                 = 0x0211;
		const auto WM_EXITMENULOOP                  = 0x0212;
		
		const auto WM_NEXTMENU                      = 0x0213;
		const auto WM_SIZING                        = 0x0214;
		const auto WM_CAPTURECHANGED                = 0x0215;
		const auto WM_MOVING                        = 0x0216;
		
		const auto WM_POWERBROADCAST                = 0x0218;
		
		const auto PBT_APMQUERYSUSPEND              = 0x0000;
		const auto PBT_APMQUERYSTANDBY              = 0x0001;
		
		const auto PBT_APMQUERYSUSPENDFAILED        = 0x0002;
		const auto PBT_APMQUERYSTANDBYFAILED        = 0x0003;
		
		const auto PBT_APMSUSPEND                   = 0x0004;
		const auto PBT_APMSTANDBY                   = 0x0005;
		
		const auto PBT_APMRESUMECRITICAL            = 0x0006;
		const auto PBT_APMRESUMESUSPEND             = 0x0007;
		const auto PBT_APMRESUMESTANDBY             = 0x0008;
		
		const auto PBTF_APMRESUMEFROMFAILURE        = 0x00000001;
		
		const auto PBT_APMBATTERYLOW                = 0x0009;
		const auto PBT_APMPOWERSTATUSCHANGE         = 0x000A;
		
		const auto PBT_APMOEMEVENT                  = 0x000B;
		
		
		const auto PBT_APMRESUMEAUTOMATIC           = 0x0012;
		
		const auto PBT_POWERSETTINGCHANGE           = 0x8013;
		struct POWERBROADCAST_SETTING {
		    GUID PowerSetting;
		    DWORD DataLength;
		    UCHAR[1] Data;
		}
		
		alias POWERBROADCAST_SETTING* PPOWERBROADCAST_SETTING;
		
		const auto WM_DEVICECHANGE                  = 0x0219;
		
		const auto WM_MDICREATE                     = 0x0220;
		const auto WM_MDIDESTROY                    = 0x0221;
		const auto WM_MDIACTIVATE                   = 0x0222;
		const auto WM_MDIRESTORE                    = 0x0223;
		const auto WM_MDINEXT                       = 0x0224;
		const auto WM_MDIMAXIMIZE                   = 0x0225;
		const auto WM_MDITILE                       = 0x0226;
		const auto WM_MDICASCADE                    = 0x0227;
		const auto WM_MDIICONARRANGE                = 0x0228;
		const auto WM_MDIGETACTIVE                  = 0x0229;
		
		
		const auto WM_MDISETMENU                    = 0x0230;
		const auto WM_ENTERSIZEMOVE                 = 0x0231;
		const auto WM_EXITSIZEMOVE                  = 0x0232;
		const auto WM_DROPFILES                     = 0x0233;
		const auto WM_MDIREFRESHMENU                = 0x0234;
		
	
		const auto WM_IME_SETCONTEXT                = 0x0281;
		const auto WM_IME_NOTIFY                    = 0x0282;
		const auto WM_IME_CONTROL                   = 0x0283;
		const auto WM_IME_COMPOSITIONFULL           = 0x0284;
		const auto WM_IME_SELECT                    = 0x0285;
		const auto WM_IME_CHAR                      = 0x0286;
		
		const auto WM_IME_REQUEST                   = 0x0288;
		
		const auto WM_IME_KEYDOWN                   = 0x0290;
		const auto WM_IME_KEYUP                     = 0x0291;
		
		const auto WM_MOUSEHOVER                    = 0x02A1;
		const auto WM_MOUSELEAVE                    = 0x02A3;
		
		const auto WM_NCMOUSEHOVER                  = 0x02A0;
		const auto WM_NCMOUSELEAVE                  = 0x02A2;
		
		const auto WM_WTSSESSION_CHANGE             = 0x02B1;

		const auto WM_TABLET_FIRST                  = 0x02c0;
		const auto WM_TABLET_LAST                   = 0x02df;
		
		const auto WM_CUT                           = 0x0300;
		const auto WM_COPY                          = 0x0301;
		const auto WM_PASTE                         = 0x0302;
		const auto WM_CLEAR                         = 0x0303;
		const auto WM_UNDO                          = 0x0304;
		const auto WM_RENDERFORMAT                  = 0x0305;
		const auto WM_RENDERALLFORMATS              = 0x0306;
		const auto WM_DESTROYCLIPBOARD              = 0x0307;
		const auto WM_DRAWCLIPBOARD                 = 0x0308;
		const auto WM_PAINTCLIPBOARD                = 0x0309;
		const auto WM_VSCROLLCLIPBOARD              = 0x030A;
		const auto WM_SIZECLIPBOARD                 = 0x030B;
		const auto WM_ASKCBFORMATNAME               = 0x030C;
		const auto WM_CHANGECBCHAIN                 = 0x030D;
		const auto WM_HSCROLLCLIPBOARD              = 0x030E;
		const auto WM_QUERYNEWPALETTE               = 0x030F;
		const auto WM_PALETTEISCHANGING             = 0x0310;
		const auto WM_PALETTECHANGED                = 0x0311;
		const auto WM_HOTKEY                        = 0x0312;
		
		const auto WM_PRINT                         = 0x0317;
		const auto WM_PRINTCLIENT                   = 0x0318;
		
		const auto WM_APPCOMMAND                    = 0x0319;
	
		const auto WM_THEMECHANGED                  = 0x031A;
		
		const auto WM_CLIPBOARDUPDATE               = 0x031D;
		
		const auto WM_DWMCOMPOSITIONCHANGED         = 0x031E;
		const auto WM_DWMNCRENDERINGCHANGED         = 0x031F;
		const auto WM_DWMCOLORIZATIONCOLORCHANGED   = 0x0320;
		const auto WM_DWMWINDOWMAXIMIZEDCHANGE      = 0x0321;
		
		const auto WM_GETTITLEBARINFOEX             = 0x033F;
		
		
		const auto WM_HANDHELDFIRST                 = 0x0358;
		const auto WM_HANDHELDLAST                  = 0x035F;
		
		const auto WM_AFXFIRST                      = 0x0360;
		const auto WM_AFXLAST                       = 0x037F;
		
		const auto WM_PENWINFIRST                   = 0x0380;
		const auto WM_PENWINLAST                    = 0x038F;
		
		const auto WM_APP                           = 0x8000;
		
		/*
		 * NOTE: All Message Numbers below 0x0400 are RESERVED.
		 *
		 * Private Window Messages Start Here:
		 */
		const auto WM_USER                          = 0x0400;
		
		/*  wParam for WM_SIZING message  */
		const auto WMSZ_LEFT            = 1;
		const auto WMSZ_RIGHT           = 2;
		const auto WMSZ_TOP             = 3;
		const auto WMSZ_TOPLEFT         = 4;
		const auto WMSZ_TOPRIGHT        = 5;
		const auto WMSZ_BOTTOM          = 6;
		const auto WMSZ_BOTTOMLEFT      = 7;
		const auto WMSZ_BOTTOMRIGHT     = 8;
		
		version(NONCMESSAGES) {
		}
		else {
			/*
			 * WM_NCHITTEST and MOUSEHOOKSTRUCT Mouse Position Codes
			 */
			const auto HTERROR              = (-2);
			const auto HTTRANSPARENT        = (-1);
			const auto HTNOWHERE            = 0;
			const auto HTCLIENT             = 1;
			const auto HTCAPTION            = 2;
			const auto HTSYSMENU            = 3;
			const auto HTGROWBOX            = 4;
			const auto HTSIZE               = HTGROWBOX;
			const auto HTMENU               = 5;
			const auto HTHSCROLL            = 6;
			const auto HTVSCROLL            = 7;
			const auto HTMINBUTTON          = 8;
			const auto HTMAXBUTTON          = 9;
			const auto HTLEFT               = 10;
			const auto HTRIGHT              = 11;
			const auto HTTOP                = 12;
			const auto HTTOPLEFT            = 13;
			const auto HTTOPRIGHT           = 14;
			const auto HTBOTTOM             = 15;
			const auto HTBOTTOMLEFT         = 16;
			const auto HTBOTTOMRIGHT        = 17;
			const auto HTBORDER             = 18;
			const auto HTREDUCE             = HTMINBUTTON;
			const auto HTZOOM               = HTMAXBUTTON;
			const auto HTSIZEFIRST          = HTLEFT;
			const auto HTSIZELAST           = HTBOTTOMRIGHT;
			
			const auto HTOBJECT             = 19;
			const auto HTCLOSE              = 20;
			const auto HTHELP               = 21;
			
			/*
			 * SendMessageTimeout values
			 */
			const auto SMTO_NORMAL          = 0x0000;
			const auto SMTO_BLOCK           = 0x0001;
			const auto SMTO_ABORTIFHUNG     = 0x0002;
			
			const auto SMTO_NOTIMEOUTIFNOTHUNG  = 0x0008;
			
			const auto SMTO_ERRORONEXIT     = 0x0020;
		}
		
		/*
		 * WM_MOUSEACTIVATE Return Codes
		 */
		const auto MA_ACTIVATE          = 1;
		const auto MA_ACTIVATEANDEAT    = 2;
		const auto MA_NOACTIVATE        = 3;
		const auto MA_NOACTIVATEANDEAT  = 4;
		
		/*
		 * WM_SETICON / WM_GETICON Type Codes
		 */
		const auto ICON_SMALL           = 0;
		const auto ICON_BIG             = 1;
		
		const auto ICON_SMALL2          = 2;
		
		UINT RegisterWindowMessageA(
		     LPCSTR lpString);
		
		UINT RegisterWindowMessageW(
		     LPCWSTR lpString);
		
		version(UNICODE) {
			alias RegisterWindowMessageW RegisterWindowMessage;
		}
		else {
			alias RegisterWindowMessageA RegisterWindowMessage;
		}
		
		/*
		 * WM_SIZE message wParam values
		 */
		const auto SIZE_RESTORED        = 0;
		const auto SIZE_MINIMIZED       = 1;
		const auto SIZE_MAXIMIZED       = 2;
		const auto SIZE_MAXSHOW         = 3;
		const auto SIZE_MAXHIDE         = 4;
		
		/*
		 * Obsolete constant names
		 */
		const auto SIZENORMAL           = SIZE_RESTORED;
		const auto SIZEICONIC           = SIZE_MINIMIZED;
		const auto SIZEFULLSCREEN       = SIZE_MAXIMIZED;
		const auto SIZEZOOMSHOW         = SIZE_MAXSHOW;
		const auto SIZEZOOMHIDE         = SIZE_MAXHIDE;
		
		/*
		 * WM_WINDOWPOSCHANGING/CHANGED struct pointed to by lParam
		 */
		struct WINDOWPOS {
		    HWND    hwnd;
		    HWND    hwndInsertAfter;
		    int     x;
		    int     y;
		    int     cx;
		    int     cy;
		    UINT    flags;
		}
		
		alias WINDOWPOS* LPWINDOWPOS;
		alias WINDOWPOS* PWINDOWPOS;
		
		/*
		 * WM_NCCALCSIZE parameter structure
		 */
		struct NCCALCSIZE_PARAMS {
		    RECT       rgrc[3];
		    PWINDOWPOS lppos;
		}
		
		alias NCCALCSIZE_PARAMS* LPNCCALCSIZE_PARAMS;
		
		/*
		 * WM_NCCALCSIZE "window valid rect" return values
		 */
		const auto WVR_ALIGNTOP         = 0x0010;
		const auto WVR_ALIGNLEFT        = 0x0020;
		const auto WVR_ALIGNBOTTOM      = 0x0040;
		const auto WVR_ALIGNRIGHT       = 0x0080;
		const auto WVR_HREDRAW          = 0x0100;
		const auto WVR_VREDRAW          = 0x0200;
		const auto WVR_REDRAW          = (WVR_HREDRAW |
		                            WVR_VREDRAW);
		const auto WVR_VALIDRECTS       = 0x0400;
		
		version(NOKEYSTATES) {
		}
		else {
			/*
			 * Key State Masks for Mouse Messages
			 */
			const auto MK_LBUTTON           = 0x0001;
			const auto MK_RBUTTON           = 0x0002;
			const auto MK_SHIFT             = 0x0004;
			const auto MK_CONTROL           = 0x0008;
			const auto MK_MBUTTON           = 0x0010;
		
			const auto MK_XBUTTON1          = 0x0020;
			const auto MK_XBUTTON2          = 0x0040;
		}
		
		version(NOTRACKMOUSEEVENT) {
		}
		else {
			const auto TME_HOVER        = 0x00000001;
			const auto TME_LEAVE        = 0x00000002;
		
			const auto TME_NONCLIENT    = 0x00000010;
		
			const auto TME_QUERY        = 0x40000000;
			const auto TME_CANCEL       = 0x80000000;
			
			const auto HOVER_DEFAULT    = 0xFFFFFFFF;
			
			struct TRACKMOUSEEVENT {
			    DWORD cbSize;
			    DWORD dwFlags;
			    HWND  hwndTrack;
			    DWORD dwHoverTime;
			}
			
			alias TRACKMOUSEEVENT* LPTRACKMOUSEEVENT;
			
			BOOL TrackMouseEvent(
			     LPTRACKMOUSEEVENT lpEventTrack);
			}
	}
	
	version(NOWINSTYLES) {
	}
	else {
		/*
		 * Window Styles
		 */
		const auto WS_OVERLAPPED        = 0x00000000;
		const auto WS_POPUP             = 0x80000000;
		const auto WS_CHILD             = 0x40000000;
		const auto WS_MINIMIZE          = 0x20000000;
		const auto WS_VISIBLE           = 0x10000000;
		const auto WS_DISABLED          = 0x08000000;
		const auto WS_CLIPSIBLINGS      = 0x04000000;
		const auto WS_CLIPCHILDREN      = 0x02000000;
		const auto WS_MAXIMIZE          = 0x01000000;
		const auto WS_CAPTION           = 0x00C00000;     /* WS_BORDER | WS_DLGFRAME  */
		const auto WS_BORDER            = 0x00800000;
		const auto WS_DLGFRAME          = 0x00400000;
		const auto WS_VSCROLL           = 0x00200000;
		const auto WS_HSCROLL           = 0x00100000;
		const auto WS_SYSMENU           = 0x00080000;
		const auto WS_THICKFRAME        = 0x00040000;
		const auto WS_GROUP             = 0x00020000;
		const auto WS_TABSTOP           = 0x00010000;
		
		const auto WS_MINIMIZEBOX       = 0x00020000;
		const auto WS_MAXIMIZEBOX       = 0x00010000;

		/*
		 * Common Window Styles
		 */
		const auto WS_OVERLAPPEDWINDOW  = (WS_OVERLAPPED     |
		                             WS_CAPTION        |
		                             WS_SYSMENU        |
		                             WS_THICKFRAME     |
		                             WS_MINIMIZEBOX    |
		                             WS_MAXIMIZEBOX);

		const auto WS_POPUPWINDOW       = (WS_POPUP          |
		                             WS_BORDER         |
		                             WS_SYSMENU);

		const auto WS_CHILDWINDOW       = (WS_CHILD);
		
		
		const auto WS_TILED             = WS_OVERLAPPED;
		const auto WS_ICONIC            = WS_MINIMIZE;
		const auto WS_SIZEBOX           = WS_THICKFRAME;
		const auto WS_TILEDWINDOW       = WS_OVERLAPPEDWINDOW;
		
		/*
		 * Extended Window Styles
		 */
		const auto WS_EX_DLGMODALFRAME      = 0x00000001;
		const auto WS_EX_NOPARENTNOTIFY     = 0x00000004;
		const auto WS_EX_TOPMOST            = 0x00000008;
		const auto WS_EX_ACCEPTFILES        = 0x00000010;
		const auto WS_EX_TRANSPARENT        = 0x00000020;
		
		const auto WS_EX_MDICHILD           = 0x00000040;
		const auto WS_EX_TOOLWINDOW         = 0x00000080;
		const auto WS_EX_WINDOWEDGE         = 0x00000100;
		const auto WS_EX_CLIENTEDGE         = 0x00000200;
		const auto WS_EX_CONTEXTHELP        = 0x00000400;

		const auto WS_EX_RIGHT              = 0x00001000;
		const auto WS_EX_LEFT               = 0x00000000;
		const auto WS_EX_RTLREADING         = 0x00002000;
		const auto WS_EX_LTRREADING         = 0x00000000;
		const auto WS_EX_LEFTSCROLLBAR      = 0x00004000;
		const auto WS_EX_RIGHTSCROLLBAR     = 0x00000000;
		
		const auto WS_EX_CONTROLPARENT      = 0x00010000;
		const auto WS_EX_STATICEDGE         = 0x00020000;
		const auto WS_EX_APPWINDOW          = 0x00040000;
		
		
		const auto WS_EX_OVERLAPPEDWINDOW   = (WS_EX_WINDOWEDGE | WS_EX_CLIENTEDGE);
		const auto WS_EX_PALETTEWINDOW      = (WS_EX_WINDOWEDGE | WS_EX_TOOLWINDOW | WS_EX_TOPMOST);
		
		const auto WS_EX_LAYERED            = 0x00080000;
		
		const auto WS_EX_NOINHERITLAYOUT    = 0x00100000L ; // Disable inheritence of mirroring by children
		const auto WS_EX_LAYOUTRTL          = 0x00400000L ; // Right to left mirroring
		
		const auto WS_EX_COMPOSITED         = 0x02000000;

		const auto WS_EX_NOACTIVATE         = 0x08000000;
		
		/*
		 * Class styles
		 */
		const auto CS_VREDRAW           = 0x0001;
		const auto CS_HREDRAW           = 0x0002;
		const auto CS_DBLCLKS           = 0x0008;
		const auto CS_OWNDC             = 0x0020;
		const auto CS_CLASSDC           = 0x0040;
		const auto CS_PARENTDC          = 0x0080;
		const auto CS_NOCLOSE           = 0x0200;
		const auto CS_SAVEBITS          = 0x0800;
		const auto CS_BYTEALIGNCLIENT   = 0x1000;
		const auto CS_BYTEALIGNWINDOW   = 0x2000;
		const auto CS_GLOBALCLASS       = 0x4000;
		
		const auto CS_IME               = 0x00010000;
		
		const auto CS_DROPSHADOW        = 0x00020000;
	}
	
	/* WM_PRINT flags */
	const auto PRF_CHECKVISIBLE     = 0x00000001;
	const auto PRF_NONCLIENT        = 0x00000002;
	const auto PRF_CLIENT           = 0x00000004;
	const auto PRF_ERASEBKGND       = 0x00000008;
	const auto PRF_CHILDREN         = 0x00000010;
	const auto PRF_OWNED            = 0x00000020;
	
	/* 3D border styles */
	const auto BDR_RAISEDOUTER  = 0x0001;
	const auto BDR_SUNKENOUTER  = 0x0002;
	const auto BDR_RAISEDINNER  = 0x0004;
	const auto BDR_SUNKENINNER  = 0x0008;
	
	const auto BDR_OUTER        = (BDR_RAISEDOUTER | BDR_SUNKENOUTER);
	const auto BDR_INNER        = (BDR_RAISEDINNER | BDR_SUNKENINNER);
	const auto BDR_RAISED       = (BDR_RAISEDOUTER | BDR_RAISEDINNER);
	const auto BDR_SUNKEN       = (BDR_SUNKENOUTER | BDR_SUNKENINNER);
	
	
	const auto EDGE_RAISED      = (BDR_RAISEDOUTER | BDR_RAISEDINNER);
	const auto EDGE_SUNKEN      = (BDR_SUNKENOUTER | BDR_SUNKENINNER);
	const auto EDGE_ETCHED      = (BDR_SUNKENOUTER | BDR_RAISEDINNER);
	const auto EDGE_BUMP        = (BDR_RAISEDOUTER | BDR_SUNKENINNER);
	
	/* Border flags */
	const auto BF_LEFT          = 0x0001;
	const auto BF_TOP           = 0x0002;
	const auto BF_RIGHT         = 0x0004;
	const auto BF_BOTTOM        = 0x0008;
	
	const auto BF_TOPLEFT       = (BF_TOP | BF_LEFT);
	const auto BF_TOPRIGHT      = (BF_TOP | BF_RIGHT);
	const auto BF_BOTTOMLEFT    = (BF_BOTTOM | BF_LEFT);
	const auto BF_BOTTOMRIGHT   = (BF_BOTTOM | BF_RIGHT);
	const auto BF_RECT          = (BF_LEFT | BF_TOP | BF_RIGHT | BF_BOTTOM);
	
	const auto BF_DIAGONAL      = 0x0010;
	
	// For diagonal lines, the BF_RECT flags specify the end point of the
	// vector bounded by the rectangle parameter.
	const auto BF_DIAGONAL_ENDTOPRIGHT      = (BF_DIAGONAL | BF_TOP | BF_RIGHT);
	const auto BF_DIAGONAL_ENDTOPLEFT       = (BF_DIAGONAL | BF_TOP | BF_LEFT);
	const auto BF_DIAGONAL_ENDBOTTOMLEFT    = (BF_DIAGONAL | BF_BOTTOM | BF_LEFT);
	const auto BF_DIAGONAL_ENDBOTTOMRIGHT   = (BF_DIAGONAL | BF_BOTTOM | BF_RIGHT);
	
	
	const auto BF_MIDDLE        = 0x0800;  /* Fill in the middle */
	const auto BF_SOFT          = 0x1000;  /* For softer buttons */
	const auto BF_ADJUST        = 0x2000;  /* Calculate the space left over */
	const auto BF_FLAT          = 0x4000;  /* For flat rather than 3D borders */
	const auto BF_MONO          = 0x8000;  /* For monochrome borderas */
	
	BOOL DrawEdge(
	     HDC hdc,
	     LPRECT qrc,
	     UINT edge,
	     UINT grfFlags);
	
	/* flags for DrawFrameControl */
	
	const auto DFC_CAPTION              = 1;
	const auto DFC_MENU                 = 2;
	const auto DFC_SCROLL               = 3;
	const auto DFC_BUTTON               = 4;
	
	const auto DFC_POPUPMENU            = 5;
	
	const auto DFCS_CAPTIONCLOSE        = 0x0000;
	const auto DFCS_CAPTIONMIN          = 0x0001;
	const auto DFCS_CAPTIONMAX          = 0x0002;
	const auto DFCS_CAPTIONRESTORE      = 0x0003;
	const auto DFCS_CAPTIONHELP         = 0x0004;

	const auto DFCS_MENUARROW           = 0x0000;
	const auto DFCS_MENUCHECK           = 0x0001;
	const auto DFCS_MENUBULLET          = 0x0002;
	const auto DFCS_MENUARROWRIGHT      = 0x0004;
	const auto DFCS_SCROLLUP            = 0x0000;
	const auto DFCS_SCROLLDOWN          = 0x0001;
	const auto DFCS_SCROLLLEFT          = 0x0002;
	const auto DFCS_SCROLLRIGHT         = 0x0003;
	const auto DFCS_SCROLLCOMBOBOX      = 0x0005;
	const auto DFCS_SCROLLSIZEGRIP      = 0x0008;
	const auto DFCS_SCROLLSIZEGRIPRIGHT  = 0x0010;
	
	const auto DFCS_BUTTONCHECK         = 0x0000;
	const auto DFCS_BUTTONRADIOIMAGE    = 0x0001;
	const auto DFCS_BUTTONRADIOMASK     = 0x0002;
	const auto DFCS_BUTTONRADIO         = 0x0004;
	const auto DFCS_BUTTON3STATE        = 0x0008;
	const auto DFCS_BUTTONPUSH          = 0x0010;
	
	const auto DFCS_INACTIVE            = 0x0100;
	const auto DFCS_PUSHED              = 0x0200;
	const auto DFCS_CHECKED             = 0x0400;
	
	const auto DFCS_TRANSPARENT         = 0x0800;
	const auto DFCS_HOT                 = 0x1000;
	
	const auto DFCS_ADJUSTRECT          = 0x2000;
	const auto DFCS_FLAT                = 0x4000;
	const auto DFCS_MONO                = 0x8000;
	
	BOOL DrawFrameControl(
	     HDC,
	     LPRECT,
	     UINT,
	     UINT);
	
	/* flags for DrawCaption */
	const auto DC_ACTIVE            = 0x0001;
	const auto DC_SMALLCAP          = 0x0002;
	const auto DC_ICON              = 0x0004;
	const auto DC_TEXT              = 0x0008;
	const auto DC_INBUTTON          = 0x0010;
	
	const auto DC_GRADIENT          = 0x0020;
	
	const auto DC_BUTTONS           = 0x1000;
	
	BOOL DrawCaption(
	     HWND hwnd,
	     HDC hdc,
	     RECT * lprect,
	     UINT flags);
	
	const auto IDANI_OPEN           = 1;
	const auto IDANI_CAPTION        = 3;
	
	BOOL DrawAnimatedRects(
	     HWND hwnd,
	     int idAni,
	     RECT *lprcFrom,
	     RECT *lprcTo);
	
	version(NOCLIPBOARD) {
	}
	else {
		/*
		 * Predefined Clipboard Formats
		 */
		const auto CF_TEXT              = 1;
		const auto CF_BITMAP            = 2;
		const auto CF_METAFILEPICT      = 3;
		const auto CF_SYLK              = 4;
		const auto CF_DIF               = 5;
		const auto CF_TIFF              = 6;
		const auto CF_OEMTEXT           = 7;
		const auto CF_DIB               = 8;
		const auto CF_PALETTE           = 9;
		const auto CF_PENDATA           = 10;
		const auto CF_RIFF              = 11;
		const auto CF_WAVE              = 12;
		const auto CF_UNICODETEXT       = 13;
		const auto CF_ENHMETAFILE       = 14;
		
		const auto CF_HDROP             = 15;
		const auto CF_LOCALE            = 16;
		
		const auto CF_DIBV5             = 17;
		
		const auto CF_MAX               = 18;
		
		const auto CF_OWNERDISPLAY      = 0x0080;
		const auto CF_DSPTEXT           = 0x0081;
		const auto CF_DSPBITMAP         = 0x0082;
		const auto CF_DSPMETAFILEPICT   = 0x0083;
		const auto CF_DSPENHMETAFILE    = 0x008E;

		/*
		 * "Private" formats don't get GlobalFree()'d
		 */
		const auto CF_PRIVATEFIRST      = 0x0200;
		const auto CF_PRIVATELAST       = 0x02FF;
		
		/*
		 * "GDIOBJ" formats do get DeleteObject()'d
		 */
		const auto CF_GDIOBJFIRST       = 0x0300;
		const auto CF_GDIOBJLAST        = 0x03FF;
	}
	
	/*
	 * Defines for the fVirt field of the Accelerator table structure.
	 */
	const auto FVIRTKEY   = TRUE          /* Assumed to be == TRUE */;
	const auto FNOINVERT  = 0x02;
	const auto FSHIFT     = 0x04;
	const auto FCONTROL   = 0x08;
	const auto FALT       = 0x10;
	
	struct ACCEL {
	    BYTE   fVirt;               /* Also called the flags field */
	    WORD   key;
	    WORD   cmd;
	}

	alias ACCEL* LPACCEL;
	
	struct PAINTSTRUCT {
	    HDC         hdc;
	    BOOL        fErase;
	    RECT        rcPaint;
	    BOOL        fRestore;
	    BOOL        fIncUpdate;
	    BYTE[32]        rgbReserved;
	}
	
	alias PAINTSTRUCT* PPAINTSTRUCT;
	alias PAINTSTRUCT* NPPAINTSTRUCT;
	alias PAINTSTRUCT* LPPAINTSTRUCT;
	
	struct CREATESTRUCTA {
	    LPVOID      lpCreateParams;
	    HINSTANCE   hInstance;
	    HMENU       hMenu;
	    HWND        hwndParent;
	    int         cy;
	    int         cx;
	    int         y;
	    int         x;
	    LONG        style;
	    LPCSTR      lpszName;
	    LPCSTR      lpszClass;
	    DWORD       dwExStyle;
	}
	
	alias CREATESTRUCTA* LPCREATESTRUCTA;
	struct CREATESTRUCTW {
	    LPVOID      lpCreateParams;
	    HINSTANCE   hInstance;
	    HMENU       hMenu;
	    HWND        hwndParent;
	    int         cy;
	    int         cx;
	    int         y;
	    int         x;
	    LONG        style;
	    LPCWSTR     lpszName;
	    LPCWSTR     lpszClass;
	    DWORD       dwExStyle;
	}
	
	alias CREATESTRUCTW* LPCREATESTRUCTW;
	
	version(UNICODE) {
		alias CREATESTRUCTW CREATESTRUCT;
		alias LPCREATESTRUCTW LPCREATESTRUCT;
	}
	else {
		alias CREATESTRUCTA CREATESTRUCT;
		alias LPCREATESTRUCTA LPCREATESTRUCT;
	}
	
	struct WINDOWPLACEMENT {
	    UINT  length;
	    UINT  flags;
	    UINT  showCmd;
	    POINT ptMinPosition;
	    POINT ptMaxPosition;
	    RECT  rcNormalPosition;
	}
	
	alias WINDOWPLACEMENT* PWINDOWPLACEMENT;
	alias WINDOWPLACEMENT* LPWINDOWPLACEMENT;
	
	const auto WPF_SETMINPOSITION           = 0x0001;
	const auto WPF_RESTORETOMAXIMIZED       = 0x0002;
	
	const auto WPF_ASYNCWINDOWPLACEMENT     = 0x0004;
	
	struct NMHDR {
	    HWND      hwndFrom;
	    UINT_PTR  idFrom;
	    UINT      code;         // NM_ code
	}
	
	alias NMHDR  * LPNMHDR;
	
	struct STYLESTRUCT {
	    DWORD   styleOld;
	    DWORD   styleNew;
	}
	
	alias STYLESTRUCT*  LPSTYLESTRUCT;
	
	/*
	 * Owner draw control types
	 */
	const auto ODT_MENU         = 1;
	const auto ODT_LISTBOX      = 2;
	const auto ODT_COMBOBOX     = 3;
	const auto ODT_BUTTON       = 4;
	
	const auto ODT_STATIC       = 5;
	
	/*
	 * Owner draw actions
	 */
	const auto ODA_DRAWENTIRE   = 0x0001;
	const auto ODA_SELECT       = 0x0002;
	const auto ODA_FOCUS        = 0x0004;
	
	/*
	 * Owner draw state
	 */
	const auto ODS_SELECTED     = 0x0001;
	const auto ODS_GRAYED       = 0x0002;
	const auto ODS_DISABLED     = 0x0004;
	const auto ODS_CHECKED      = 0x0008;
	const auto ODS_FOCUS        = 0x0010;
	
	const auto ODS_DEFAULT          = 0x0020;
	const auto ODS_COMBOBOXEDIT     = 0x1000;
	
	const auto ODS_HOTLIGHT         = 0x0040;
	const auto ODS_INACTIVE         = 0x0080;
	
	const auto ODS_NOACCEL          = 0x0100;
	const auto ODS_NOFOCUSRECT      = 0x0200;
	
	/*
	 * MEASUREITEMSTRUCT for ownerdraw
	 */
	struct MEASUREITEMSTRUCT {
	    UINT       CtlType;
	    UINT       CtlID;
	    UINT       itemID;
	    UINT       itemWidth;
	    UINT       itemHeight;
	    ULONG_PTR  itemData;
	}
	
	alias MEASUREITEMSTRUCT  *PMEASUREITEMSTRUCT;
	alias MEASUREITEMSTRUCT  *LPMEASUREITEMSTRUCT;
	
	/*
	 * DRAWITEMSTRUCT for ownerdraw
	 */
	struct DRAWITEMSTRUCT {
	    UINT        CtlType;
	    UINT        CtlID;
	    UINT        itemID;
	    UINT        itemAction;
	    UINT        itemState;
	    HWND        hwndItem;
	    HDC         hDC;
	    RECT        rcItem;
	    ULONG_PTR   itemData;
	}
	
	alias DRAWITEMSTRUCT  *PDRAWITEMSTRUCT;
	alias DRAWITEMSTRUCT  *LPDRAWITEMSTRUCT;
	
	/*
	 * DELETEITEMSTRUCT for ownerdraw
	 */
	struct DELETEITEMSTRUCT {
	    UINT       CtlType;
	    UINT       CtlID;
	    UINT       itemID;
	    HWND       hwndItem;
	    ULONG_PTR  itemData;
	}
	
	alias DELETEITEMSTRUCT  *PDELETEITEMSTRUCT;
	alias DELETEITEMSTRUCT  *LPDELETEITEMSTRUCT;
	
	/*
	 * COMPAREITEMSTUCT for ownerdraw sorting
	 */
	struct COMPAREITEMSTRUCT {
	    UINT        CtlType;
	    UINT        CtlID;
	    HWND        hwndItem;
	    UINT        itemID1;
	    ULONG_PTR   itemData1;
	    UINT        itemID2;
	    ULONG_PTR   itemData2;
	    DWORD       dwLocaleId;
	}
	
	alias COMPAREITEMSTRUCT  *PCOMPAREITEMSTRUCT;
	alias COMPAREITEMSTRUCT  *LPCOMPAREITEMSTRUCT;
	
	version(NOMSG) {
	}
	else {
		/*
		 * Message Function Templates
		 */
		
		BOOL GetMessageA(
		     LPMSG lpMsg,
		     HWND hWnd,
		     UINT wMsgFilterMin,
		     UINT wMsgFilterMax);
		
		BOOL GetMessageW(
		     LPMSG lpMsg,
		     HWND hWnd,
		     UINT wMsgFilterMin,
		     UINT wMsgFilterMax);
		
		version(UNICODE) {
			alias GetMessageW GetMessage;
		}
		else {
			alias GetMessageA GetMessage;
		}
		
		BOOL TranslateMessage(
		     MSG *lpMsg);
		
		LRESULT DispatchMessageA(
		     MSG *lpMsg);
		LRESULT DispatchMessageW(
		     MSG *lpMsg);
		
		version(UNICODE) {
			alias DispatchMessageW DispatchMessage;
		}
		else {
			alias DispatchMessageA DispatchMessage;
		}
		
		BOOL SetMessageQueue(
		     int cMessagesMax);
		
		BOOL PeekMessageA(
		     LPMSG lpMsg,
		     HWND hWnd,
		     UINT wMsgFilterMin,
		     UINT wMsgFilterMax,
		     UINT wRemoveMsg);
		BOOL PeekMessageW(
		     LPMSG lpMsg,
		     HWND hWnd,
		     UINT wMsgFilterMin,
		     UINT wMsgFilterMax,
		     UINT wRemoveMsg);
		
		version(UNICODE) {
			alias PeekMessageW PeekMessage;
		}
		else {
			alias PeekMessageA PeekMessage;
		}
		
		
		/*
		 * PeekMessage() Options
		 */
		const auto PM_NOREMOVE          = 0x0000;
		const auto PM_REMOVE            = 0x0001;
		const auto PM_NOYIELD           = 0x0002;
	}
	
	BOOL RegisterHotKey(
	     HWND hWnd,
	     int id,
	     UINT fsModifiers,
	     UINT vk);
	
	BOOL UnregisterHotKey(
	     HWND hWnd,
	     int id);
	
	const auto MOD_ALT          = 0x0001;
	const auto MOD_CONTROL      = 0x0002;
	const auto MOD_SHIFT        = 0x0004;
	const auto MOD_WIN          = 0x0008;
	
	const auto IDHOT_SNAPWINDOW         = (-1)    /* SHIFT-PRINTSCRN  */;
	const auto IDHOT_SNAPDESKTOP        = (-2)    /* PRINTSCRN        */;
	
	const auto ENDSESSION_LOGOFF     = 0x80000000;
	const auto ENDSESSION_CRITICAL   = 0x40000000;
	const auto ENDSESSION_CLOSEAPP   = 0x00000001;
	
	const auto EWX_LOGOFF           = 0;
	const auto EWX_SHUTDOWN         = 0x00000001;
	const auto EWX_REBOOT           = 0x00000002;
	const auto EWX_FORCE            = 0x00000004;
	const auto EWX_POWEROFF         = 0x00000008;
	
	const auto EWX_FORCEIFHUNG      = 0x00000010;
	
	const auto EWX_QUICKRESOLVE     = 0x00000020;
	
	const auto EWX_RESTARTAPPS      = 0x00000040;
	
	BOOL ExitWindows(DWORD dwReserved, UINT Code) {
		return ExitWindowsEx(EWX_LOGOFF, 0xFFFFFFFF);
	}
	
	BOOL ExitWindowsEx(
	     UINT uFlags,
	     DWORD dwReason);

	BOOL SwapMouseButton(
	     BOOL fSwap);
	
	DWORD GetMessagePos();
	
	LONG GetMessageTime();
	
	LPARAM GetMessageExtraInfo();
	
	BOOL IsWow64Message();
	
	LPARAM SetMessageExtraInfo(
	     LPARAM lParam);
	
	LRESULT SendMessageA(
	     HWND hWnd,
	     UINT Msg,
	     WPARAM wParam,
	     LPARAM lParam);
	
	LRESULT SendMessageW(
	     HWND hWnd,
	     UINT Msg,
	     WPARAM wParam,
	     LPARAM lParam);
	
	version(UNICODE) {
		alias SendMessageW SendMessage;
	}
	else {
		alias SendMessageA SendMessage;
	}
	
	LRESULT SendMessageTimeoutA(
	     HWND hWnd,
	     UINT Msg,
	     WPARAM wParam,
	     LPARAM lParam,
	     UINT fuFlags,
	     UINT uTimeout,
	     PDWORD_PTR lpdwResult);
	
	LRESULT SendMessageTimeoutW(
	     HWND hWnd,
	     UINT Msg,
	     WPARAM wParam,
	     LPARAM lParam,
	     UINT fuFlags,
	     UINT uTimeout,
	     PDWORD_PTR lpdwResult);
	
	version(UNICODE) {
		alias SendMessageTimeoutW SendMessageTimeout;
	}
	else {
		alias SendMessageTimeoutA SendMessageTimeout;
	}
	
	BOOL SendNotifyMessageA(
	     HWND hWnd,
	     UINT Msg,
	     WPARAM wParam,
	     LPARAM lParam);
	
	BOOL SendNotifyMessageW(
	     HWND hWnd,
	     UINT Msg,
	     WPARAM wParam,
	     LPARAM lParam);
	
	version(UNICODE) {
		alias SendNotifyMessageW SendNotifyMessage;
	}
	else {
		alias SendNotifyMessageA SendNotifyMessage;
	}
	
	BOOL SendMessageCallbackA(
	     HWND hWnd,
	     UINT Msg,
	     WPARAM wParam,
	     LPARAM lParam,
	     SENDASYNCPROC lpResultCallBack,
	     ULONG_PTR dwData);
	
	BOOL SendMessageCallbackW(
	     HWND hWnd,
	     UINT Msg,
	     WPARAM wParam,
	     LPARAM lParam,
	     SENDASYNCPROC lpResultCallBack,
	     ULONG_PTR dwData);
	
	version(UNICODE) {
		alias SendMessageCallbackW SendMessageCallback;
	}
	else {
		alias SendMessageCallbackA SendMessageCallback;
	}
	
	struct BSMINFO {
	    UINT  cbSize;
	    HDESK hdesk;
	    HWND  hwnd;
	    LUID  luid;
	}
	
	alias BSMINFO* PBSMINFO;
	
	Clong_t BroadcastSystemMessageExA(
	     DWORD flags,
	     LPDWORD lpInfo,
	     UINT Msg,
	     WPARAM wParam,
	     LPARAM lParam,
	     PBSMINFO pbsmInfo);
	Clong_t BroadcastSystemMessageExW(
	     DWORD flags,
	     LPDWORD lpInfo,
	     UINT Msg,
	     WPARAM wParam,
	     LPARAM lParam,
	     PBSMINFO pbsmInfo);
	
	version(UNICODE) {
		alias BroadcastSystemMessageExW BroadcastSystemMessageEx;
	}
	else {
		alias BroadcastSystemMessageExA BroadcastSystemMessageEx;
	}
	
	Clong_t BroadcastSystemMessageA(
	     DWORD flags,
	     LPDWORD lpInfo,
	     UINT Msg,
	     WPARAM wParam,
	     LPARAM lParam);
	
	Clong_t BroadcastSystemMessageW(
	     DWORD flags,
	     LPDWORD lpInfo,
	     UINT Msg,
	     WPARAM wParam,
	     LPARAM lParam);
	
	version(UNICODE) {
		alias BroadcastSystemMessageW BroadcastSystemMessage;
	}
	else {
		alias BroadcastSystemMessageA BroadcastSystemMessage;
	}
	
	//Broadcast Special Message Recipient list
	const auto BSM_ALLCOMPONENTS        = 0x00000000;
	const auto BSM_VXDS                 = 0x00000001;
	const auto BSM_NETDRIVER            = 0x00000002;
	const auto BSM_INSTALLABLEDRIVERS   = 0x00000004;
	const auto BSM_APPLICATIONS         = 0x00000008;
	const auto BSM_ALLDESKTOPS          = 0x00000010;
	
	//Broadcast Special Message Flags
	const auto BSF_QUERY                = 0x00000001;
	const auto BSF_IGNORECURRENTTASK    = 0x00000002;
	const auto BSF_FLUSHDISK            = 0x00000004;
	const auto BSF_NOHANG               = 0x00000008;
	const auto BSF_POSTMESSAGE          = 0x00000010;
	const auto BSF_FORCEIFHUNG          = 0x00000020;
	const auto BSF_NOTIMEOUTIFNOTHUNG   = 0x00000040;
	
	const auto BSF_ALLOWSFW             = 0x00000080;
	const auto BSF_SENDNOTIFYMESSAGE    = 0x00000100;
	
	const auto BSF_RETURNHDESK          = 0x00000200;
	const auto BSF_LUID                 = 0x00000400;
	
	const auto BROADCAST_QUERY_DENY          = 0x424D5144  ; // Return this value to deny a query.
	
	// RegisterDeviceNotification
	
	alias  PVOID           HDEVNOTIFY;
	alias  HDEVNOTIFY     *PHDEVNOTIFY;
	
	const auto DEVICE_NOTIFY_WINDOW_HANDLE           = 0x00000000;
	const auto DEVICE_NOTIFY_SERVICE_HANDLE          = 0x00000001;
	
	const auto DEVICE_NOTIFY_ALL_INTERFACE_CLASSES   = 0x00000004;
	
	HDEVNOTIFY RegisterDeviceNotificationA(
	     HANDLE hRecipient,
	     LPVOID NotificationFilter,
	     DWORD Flags);

	HDEVNOTIFY RegisterDeviceNotificationW(
	     HANDLE hRecipient,
	     LPVOID NotificationFilter,
	     DWORD Flags);
	
	version(UNICODE) {
		alias RegisterDeviceNotificationW RegisterDeviceNotification;
	}
	else {
		alias RegisterDeviceNotificationA RegisterDeviceNotification;
	}
	
	BOOL UnregisterDeviceNotification(
	     HDEVNOTIFY Handle
	    );
	
	alias  PVOID           HPOWERNOTIFY;
	alias  HPOWERNOTIFY   *PHPOWERNOTIFY;
	
	HPOWERNOTIFY RegisterPowerSettingNotification(
	    HANDLE hRecipient,
	    LPCGUID PowerSettingGuid,
	    DWORD Flags
	    );
	
	BOOL UnregisterPowerSettingNotification(
	    HPOWERNOTIFY Handle
	    );
	
	BOOL PostMessageA(
	     HWND hWnd,
	     UINT Msg,
	     WPARAM wParam,
	     LPARAM lParam);
	
	BOOL PostMessageW(
	     HWND hWnd,
	     UINT Msg,
	     WPARAM wParam,
	     LPARAM lParam);
	
	version(UNICODE) {
		alias PostMessageW PostMessage;
	}
	else {
		alias PostMessageA PostMessage;
	}

	BOOL PostThreadMessageA(
	     DWORD idThread,
	     UINT Msg,
	     WPARAM wParam,
	     LPARAM lParam);
	BOOL PostThreadMessageW(
	     DWORD idThread,
	     UINT Msg,
	     WPARAM wParam,
	     LPARAM lParam);
	
	version(UNICODE) {
		alias PostThreadMessageW PostThreadMessage;
	}
	else {
		alias PostThreadMessageA PostThreadMessage;
	}
	
	alias PostThreadMessageA PostAppMessageA;
	alias PostThreadMessageW PostAppMessageW;
	
	version(UNICODE) {
		alias PostAppMessageW PostAppMessage;
	}
	else {
		alias PostAppMessageA PostAppMessage;
	}
	
	/*
	 * Special HWND value for use with PostMessage() and SendMessage()
	 */
	const auto HWND_BROADCAST   = (cast(HWND)0xffff);
	
	const auto HWND_MESSAGE      = (cast(HWND)-3);
	
	BOOL AttachThreadInput(
	     DWORD idAttach,
	     DWORD idAttachTo,
	     BOOL fAttach);
	
	
	BOOL ReplyMessage(
	     LRESULT lResult);
	
	BOOL WaitMessage();
	
	
	DWORD WaitForInputIdle(
	     HANDLE hProcess,
	     DWORD dwMilliseconds);
	
	LRESULT DefWindowProcA(
	     HWND hWnd,
	     UINT Msg,
	     WPARAM wParam,
	     LPARAM lParam);
	
	LRESULT DefWindowProcW(
	     HWND hWnd,
	     UINT Msg,
	     WPARAM wParam,
	     LPARAM lParam);
	
	version(UNICODE) {
		alias DefWindowProcW DefWindowProc;
	}
	else {
		alias DefWindowProcA DefWindowProc;
	}
	
	VOID PostQuitMessage(
	     int nExitCode);
	
	LRESULT CallWindowProcA(
	     WNDPROC lpPrevWndFunc,
	     HWND hWnd,
	     UINT Msg,
	     WPARAM wParam,
	     LPARAM lParam);
	
	LRESULT CallWindowProcW(
	     WNDPROC lpPrevWndFunc,
	     HWND hWnd,
	     UINT Msg,
	     WPARAM wParam,
	     LPARAM lParam);
	
	version(UNICODE) {
		alias CallWindowProcW CallWindowProc;
	}
	else {
		alias CallWindowProcA CallWindowProc;
	}
	
	BOOL InSendMessage();

	DWORD InSendMessageEx(
	    LPVOID lpReserved);
	
	/*
	 * InSendMessageEx return value
	 */
	const auto ISMEX_NOSEND       = 0x00000000;
	const auto ISMEX_SEND         = 0x00000001;
	const auto ISMEX_NOTIFY       = 0x00000002;
	const auto ISMEX_CALLBACK     = 0x00000004;
	const auto ISMEX_REPLIED      = 0x00000008;
	
	UINT GetDoubleClickTime();
	
	BOOL SetDoubleClickTime();
	
	ATOM RegisterClassA(
	     WNDCLASSA *lpWndClass);
	
	ATOM RegisterClassW(
	     WNDCLASSW *lpWndClass);
	
	version(UNICODE) {
		alias RegisterClassW RegisterClass;
	}
	else {
		alias RegisterClassA RegisterClass;
	}
	
	BOOL UnregisterClassA(
	     LPCSTR lpClassName,
	     HINSTANCE hInstance);
	
	BOOL UnregisterClassW(
	     LPCWSTR lpClassName,
	     HINSTANCE hInstance);
	
	version(UNICODE) {
		alias UnregisterClassW UnregisterClass;
	}
	else {
		alias UnregisterClassA UnregisterClass;
	}
	
	BOOL GetClassInfoA(
	     HINSTANCE hInstance,
	     LPCSTR lpClassName,
	     LPWNDCLASSA lpWndClass);
	
	BOOL GetClassInfoW(
	     HINSTANCE hInstance,
	     LPCWSTR lpClassName,
	     LPWNDCLASSW lpWndClass);
	
	version(UNICODE) {
		alias GetClassInfoW GetClassInfo;
	}
	else {
		alias GetClassInfoA GetClassInfo;
	}
	
	ATOM RegisterClassExA(
	     WNDCLASSEXA *);
	
	ATOM RegisterClassExW(
	     WNDCLASSEXW *);
	
	version(UNICODE) {
		alias RegisterClassExW RegisterClassEx;
	}
	else {
		alias RegisterClassExA RegisterClassEx;
	}
	
	BOOL GetClassInfoExA(
	     HINSTANCE hInstance,
	     LPCSTR lpszClass,
	     LPWNDCLASSEXA lpwcx);
	
	BOOL GetClassInfoExW(
	     HINSTANCE hInstance,
	     LPCWSTR lpszClass,
	     LPWNDCLASSEXW lpwcx);
	
	version(UNICODE) {
		alias GetClassInfoExW GetClassInfoEx;
	}
	else {
		alias GetClassInfoExA GetClassInfoEx;
	}
	
	const auto CW_USEDEFAULT        = (cast(int)0x80000000);
	
	/*
	 * Special value for CreateWindow, et al.
	 */
	const auto HWND_DESKTOP         = (cast(HWND)0);
	
	alias BOOLEAN function(LPCWSTR) PREGISTERCLASSNAMEW;
	
	HWND CreateWindowExA(
	     DWORD dwExStyle,
	     LPCSTR lpClassName,
	     LPCSTR lpWindowName,
	     DWORD dwStyle,
	     int X,
	     int Y,
	     int nWidth,
	     int nHeight,
	     HWND hWndParent,
	     HMENU hMenu,
	     HINSTANCE hInstance,
	     LPVOID lpParam);
	
	HWND CreateWindowExW(
	     DWORD dwExStyle,
	     LPCWSTR lpClassName,
	     LPCWSTR lpWindowName,
	     DWORD dwStyle,
	     int X,
	     int Y,
	     int nWidth,
	     int nHeight,
	     HWND hWndParent,
	     HMENU hMenu,
	     HINSTANCE hInstance,
	     LPVOID lpParam);
	
	version(UNICODE) {
		alias CreateWindowExW CreateWindowEx;
	}
	else {
		alias CreateWindowExA CreateWindowEx;
	}
	
	HWND CreateWindowA(
	     LPCSTR lpClassName,
	     LPCSTR lpWindowName,
	     DWORD dwStyle,
	     int X,
	     int Y,
	     int nWidth,
	     int nHeight,
	     HWND hWndParent,
	     HMENU hMenu,
	     HINSTANCE hInstance,
	     LPVOID lpParam) {
	     return CreateWindowExA(0, lpClassName, lpWindowName, dwStyle,
	       X, Y, nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam);
	}
	
	HWND CreateWindowW(
	     LPCWSTR lpClassName,
	     LPCWSTR lpWindowName,
	     DWORD dwStyle,
	     int X,
	     int Y,
	     int nWidth,
	     int nHeight,
	     HWND hWndParent,
	     HMENU hMenu,
	     HINSTANCE hInstance,
	     LPVOID lpParam) {
	     return CreateWindowExW(0, lpClassName, lpWindowName, dwStyle,
	       X, Y, nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam);
	}
	
	version(UNICODE) {
		alias CreateWindowW CreateWindow;
	}
	else {
		alias CreateWindowA CreateWindow;
	}
	
	BOOL IsWindow(
	     HWND hWnd);
	
	BOOL IsMenu(
	     HMENU hMenu);
	
	BOOL IsChild(
	     HWND hWndParent,
	     HWND hWnd);
	
	BOOL DestroyWindow(
	     HWND hWnd);
	
	BOOL ShowWindow(
	     HWND hWnd,
	     int nCmdShow);
	
	BOOL AnimateWindow(
	     HWND hWnd,
	     DWORD dwTime,
	     DWORD dwFlags);
	
	version(NOGDI) {
	}
	else {
		BOOL UpdateLayeredWindow(
		     HWND hWnd,
		     HDC hdcDst,
		     POINT *pptDst,
		     SIZE *psize,
		     HDC hdcSrc,
		     POINT *pptSrc,
		     COLORREF crKey,
		     BLENDFUNCTION *pblend,
		     DWORD dwFlags);
		
		/*
		 * Layered Window Update information
		 */
		
		struct UPDATELAYEREDWINDOWINFO {
		                    DWORD               cbSize;
		                HDC                 hdcDst;
		    POINT *pptDst;
		    SIZE *psize;
		                HDC                 hdcSrc;
		    POINT       *pptSrc;
		                COLORREF            crKey;
		    BLENDFUNCTION *pblend;
		                    DWORD               dwFlags;
		    RECT *prcDirty;
		}
		
		alias UPDATELAYEREDWINDOWINFO* PUPDATELAYEREDWINDOWINFO;
		
		BOOL UpdateLayeredWindowIndirect(
		     HWND hWnd,
		     UPDATELAYEREDWINDOWINFO *pULWInfo);
	}
	
	BOOL GetLayeredWindowAttributes(
	     HWND hwnd,
	     COLORREF *pcrKey,
	     BYTE *pbAlpha,
	     DWORD *pdwFlags);

	const auto PW_CLIENTONLY            = 0x00000001;
	
	BOOL PrintWindow(
	      HWND hwnd,
	      HDC hdcBlt,
	      UINT nFlags);
	
	BOOL SetLayeredWindowAttributes(
	     HWND hwnd,
	     COLORREF crKey,
	     BYTE bAlpha,
	     DWORD dwFlags);
	
	const auto LWA_COLORKEY             = 0x00000001;
	const auto LWA_ALPHA                = 0x00000002;
	
	
	const auto ULW_COLORKEY             = 0x00000001;
	const auto ULW_ALPHA                = 0x00000002;
	const auto ULW_OPAQUE               = 0x00000004;
	
	const auto ULW_EX_NORESIZE          = 0x00000008;
	
	BOOL ShowWindowAsync(
	      HWND hWnd,
	      int nCmdShow);
	
	BOOL FlashWindow(
	      HWND hWnd,
	      BOOL bInvert);
	
	struct FLASHWINFO {
	    UINT  cbSize;
	    HWND  hwnd;
	    DWORD dwFlags;
	    UINT  uCount;
	    DWORD dwTimeout;
	}
	
	alias FLASHWINFO* PFLASHWINFO;
	
	BOOL FlashWindowEx(
	     PFLASHWINFO pfwi);
	
	const auto FLASHW_STOP          = 0;
	const auto FLASHW_CAPTION       = 0x00000001;
	const auto FLASHW_TRAY          = 0x00000002;
	const auto FLASHW_ALL           = (FLASHW_CAPTION | FLASHW_TRAY);
	const auto FLASHW_TIMER         = 0x00000004;
	const auto FLASHW_TIMERNOFG     = 0x0000000C;
	
	BOOL ShowOwnedPopups(
	      HWND hWnd,
	      BOOL fShow);
	
	BOOL OpenIcon(
	      HWND hWnd);
	
	BOOL CloseWindow(
	      HWND hWnd);
	
	BOOL MoveWindow(
	     HWND hWnd,
	     int X,
	     int Y,
	     int nWidth,
	     int nHeight,
	     BOOL bRepaint);
	
	BOOL SetWindowPos(
	     HWND hWnd,
	     HWND hWndInsertAfter,
	     int X,
	     int Y,
	     int cx,
	     int cy,
	     UINT uFlags);
	
	BOOL GetWindowPlacement(
	     HWND hWnd,
	     WINDOWPLACEMENT *lpwndpl);
	
	BOOL SetWindowPlacement(
	     HWND hWnd,
	     WINDOWPLACEMENT *lpwndpl);
	
	version(NODEFERWINDOWPOS) {
	}
	else {
		HDWP BeginDeferWindowPos(
		     int nNumWindows);
	
		HDWP DeferWindowPos(
		     HDWP hWinPosInfo,
		     HWND hWnd,
		     HWND hWndInsertAfter,
		     int x,
		     int y,
		     int cx,
		     int cy,
		     UINT uFlags);
	
		BOOL EndDeferWindowPos(
		     HDWP hWinPosInfo);
	}
	
	BOOL IsWindowVisible(
	     HWND hWnd);
	
	BOOL IsIconic(
	     HWND hWnd);
	
	BOOL AnyPopup();
	
	BOOL BringWindowToTop(
	     HWND hWnd);
	
	BOOL IsZoomed(
	     HWND hWnd);
	
	/*
	 * SetWindowPos Flags
	 */
	const auto SWP_NOSIZE           = 0x0001;
	const auto SWP_NOMOVE           = 0x0002;
	const auto SWP_NOZORDER         = 0x0004;
	const auto SWP_NOREDRAW         = 0x0008;
	const auto SWP_NOACTIVATE       = 0x0010;
	const auto SWP_FRAMECHANGED     = 0x0020  /* The frame changed: send WM_NCCALCSIZE */;
	const auto SWP_SHOWWINDOW       = 0x0040;
	const auto SWP_HIDEWINDOW       = 0x0080;
	const auto SWP_NOCOPYBITS       = 0x0100;
	const auto SWP_NOOWNERZORDER    = 0x0200  /* Don't do owner Z ordering */;
	const auto SWP_NOSENDCHANGING   = 0x0400  /* Don't send WM_WINDOWPOSCHANGING */;
	
	const auto SWP_DRAWFRAME        = SWP_FRAMECHANGED;
	const auto SWP_NOREPOSITION     = SWP_NOOWNERZORDER;
	
	const auto SWP_DEFERERASE       = 0x2000;
	const auto SWP_ASYNCWINDOWPOS   = 0x4000;

	const auto HWND_TOP         = (cast(HWND)0);
	const auto HWND_BOTTOM      = (cast(HWND)1);
	const auto HWND_TOPMOST     = (cast(HWND)-1);
	const auto HWND_NOTOPMOST   = (cast(HWND)-2);
	
	version(NOCTLMGR) {
	}
	else {
		/*
		 * WARNING:
		 * The following structures must NOT be DWORD padded because they are
		 * followed by strings, etc that do not have to be DWORD aligned.
		 */
		
		/*
		 * original NT 32 bit dialog template:
		 */
		align(2) struct DLGTEMPLATE {
		    DWORD style;
		    DWORD dwExtendedStyle;
		    WORD cdit;
		    short x;
		    short y;
		    short cx;
		    short cy;
		}
		
		alias DLGTEMPLATE *LPDLGTEMPLATEA;
		alias DLGTEMPLATE *LPDLGTEMPLATEW;
		
		version(UNICODE) {
			alias LPDLGTEMPLATEW LPDLGTEMPLATE;
		}
		else {
			alias LPDLGTEMPLATEA LPDLGTEMPLATE;
		}
		
		alias DLGTEMPLATE *LPCDLGTEMPLATEA;
		alias DLGTEMPLATE *LPCDLGTEMPLATEW;
		
		version(UNICODE) {
			alias LPCDLGTEMPLATEW LPCDLGTEMPLATE;
		}
		else {
			alias LPCDLGTEMPLATEA LPCDLGTEMPLATE;
		}
		
		/*
		 * 32 bit Dialog item template.
		 */
		align(2) struct DLGITEMTEMPLATE {
		    DWORD style;
		    DWORD dwExtendedStyle;
		    short x;
		    short y;
		    short cx;
		    short cy;
		    WORD id;
		}
		
		alias DLGITEMTEMPLATE *PDLGITEMTEMPLATEA;
		alias DLGITEMTEMPLATE *PDLGITEMTEMPLATEW;
		
		version(UNICODE) {
			alias PDLGITEMTEMPLATEW PDLGITEMTEMPLATE;
		}
		else {
			alias PDLGITEMTEMPLATEA PDLGITEMTEMPLATE;
		}
		alias DLGITEMTEMPLATE *LPDLGITEMTEMPLATEA;
		alias DLGITEMTEMPLATE *LPDLGITEMTEMPLATEW;
		
		version(UNICODE) {
			alias LPDLGITEMTEMPLATEW LPDLGITEMTEMPLATE;
		}
		else {
			alias LPDLGITEMTEMPLATEA LPDLGITEMTEMPLATE;
		}
		
		HWND CreateDialogParamA(
		     HINSTANCE hInstance,
		     LPCSTR lpTemplateName,
		     HWND hWndParent,
		     DLGPROC lpDialogFunc,
		     LPARAM dwInitParam);
		
		HWND CreateDialogParamW(
		     HINSTANCE hInstance,
		     LPCWSTR lpTemplateName,
		     HWND hWndParent,
		     DLGPROC lpDialogFunc,
		     LPARAM dwInitParam);
		
		version(UNICODE) {
			alias CreateDialogParamW CreateDialogParam;
		}
		else {
			alias CreateDialogParamA CreateDialogParam;
		}
		
		HWND CreateDialogIndirectParamA(
		     HINSTANCE hInstance,
		     LPCDLGTEMPLATEA lpTemplate,
		     HWND hWndParent,
		     DLGPROC lpDialogFunc,
		     LPARAM dwInitParam);
		HWND CreateDialogIndirectParamW(
		     HINSTANCE hInstance,
		     LPCDLGTEMPLATEW lpTemplate,
		     HWND hWndParent,
		     DLGPROC lpDialogFunc,
		     LPARAM dwInitParam);
		
		version(UNICODE) {
			alias CreateDialogIndirectParamW CreateDialogIndirectParam;
		}
		else {
			alias CreateDialogIndirectParamA CreateDialogIndirectParam;
		}
		
		HWND CreateDialogA(
		     HINSTANCE hInstance,
		     LPCSTR lpTemplateName,
		     HWND hWndParent,
		     DLGPROC lpDialogFunc) {
		     return CreateDialogParamA(hInstance, lpTemplateName, hWndParent, lpDialogFunc, 0);
		}
		
		HWND CreateDialogW(
		     HINSTANCE hInstance,
		     LPCWSTR lpTemplateName,
		     HWND hWndParent,
		     DLGPROC lpDialogFunc) {
		     return CreateDialogParamW(hInstance, lpTemplateName, hWndParent, lpDialogFunc, 0);
		}
		
		version(UNICODE) {
			alias CreateDialogW CreateDialog;
		}
		else {
			alias CreateDialogA CreateDialog;
		}
		
		HWND CreateDialogIndirectA(
		     HINSTANCE hInstance,
		     LPCDLGTEMPLATEA lpTemplate,
		     HWND hWndParent,
		     DLGPROC lpDialogFunc,
		     LPARAM dwInitParam) {
			return CreateDialogIndirectParamA(hInstance, lpTemplate, hWndParent, lpDialogFunc, 0);
		}
		
		HWND CreateDialogIndirectW(
		     HINSTANCE hInstance,
		     LPCDLGTEMPLATEW lpTemplate,
		     HWND hWndParent,
		     DLGPROC lpDialogFunc,
		     LPARAM dwInitParam) {
			return CreateDialogIndirectParamW(hInstance, lpTemplate, hWndParent, lpDialogFunc, 0);
		}
		
		version(UNICODE) {
			alias CreateDialogIndirectW CreateDialogIndirect;
		}
		else {
			alias CreateDialogIndirectA CreateDialogIndirect;
		}
		
		INT_PTR DialogBoxParamA(
		     HINSTANCE hInstance,
		     LPCSTR lpTemplateName,
		     HWND hWndParent,
		     DLGPROC lpDialogFunc,
		     LPARAM dwInitParam);
		
		INT_PTR DialogBoxParamW(
		     HINSTANCE hInstance,
		     LPCWSTR lpTemplateName,
		     HWND hWndParent,
		     DLGPROC lpDialogFunc,
		     LPARAM dwInitParam);
		
		version(UNICODE) {
			alias DialogBoxParamW DialogBoxParam;
		}
		else {
			alias DialogBoxParamA DialogBoxParam;
		}
		
		INT_PTR DialogBoxIndirectParamA(
		     HINSTANCE hInstance,
		     LPCDLGTEMPLATEA hDialogTemplate,
		     HWND hWndParent,
		     DLGPROC lpDialogFunc,
		     LPARAM dwInitParam);
		
		INT_PTR DialogBoxIndirectParamW(
		     HINSTANCE hInstance,
		     LPCDLGTEMPLATEW hDialogTemplate,
		     HWND hWndParent,
		     DLGPROC lpDialogFunc,
		     LPARAM dwInitParam);
		
		version(UNICODE) {
			alias DialogBoxIndirectParamW DialogBoxIndirectParam;
		}
		else {
			alias DialogBoxIndirectParamA DialogBoxIndirectParam;
		}
		
		INT_PTR DialogBoxA(
		     HINSTANCE hInstance,
		     LPCSTR lpTemplateName,
		     HWND hWndParent,
		     DLGPROC lpDialogFunc) {
		    return DialogBoxParamA(hInstance, lpTemplateName, hWndParent, lpDialogFunc, 0);
		}
		
		INT_PTR DialogBoxW(
		     HINSTANCE hInstance,
		     LPCWSTR lpTemplateName,
		     HWND hWndParent,
		     DLGPROC lpDialogFunc) {
		    return DialogBoxParamW(hInstance, lpTemplateName, hWndParent, lpDialogFunc, 0);
		}
		
		version(UNICODE) {
			alias DialogBoxW DialogBox;
		}
		else {
			alias DialogBoxA DialogBox;
		}
		
		INT_PTR DialogBoxIndirectA(
		     HINSTANCE hInstance,
		     LPCDLGTEMPLATEA hDialogTemplate,
		     HWND hWndParent,
		     DLGPROC lpDialogFunc) {
		    return DialogBoxIndirectParamA(hInstance, hDialogTemplate, hWndParent, lpDialogFunc, 0);
		}
		
		INT_PTR DialogBoxIndirectW(
		     HINSTANCE hInstance,
		     LPCDLGTEMPLATEW hDialogTemplate,
		     HWND hWndParent,
		     DLGPROC lpDialogFunc) {
		    return DialogBoxIndirectParamW(hInstance, hDialogTemplate, hWndParent, lpDialogFunc, 0);
		}
		
		version(UNICODE) {
			alias DialogBoxIndirectW DialogBoxIndirect;
		}
		else {
			alias DialogBoxIndirectA DialogBoxIndirect;
		}
		
		BOOL EndDialog(
		     HWND hDlg,
		     INT_PTR nResult);
		
		HWND GetDlgItem(
		     HWND hDlg,
		     int nIDDlgItem);
		
		BOOL SetDlgItemInt(
		     HWND hDlg,
		     int nIDDlgItem,
		     UINT uValue,
		     BOOL bSigned);
		
		UINT GetDlgItemInt(
		     HWND hDlg,
		     int nIDDlgItem,
		     BOOL *lpTranslated,
		     BOOL bSigned);
		
		BOOL SetDlgItemTextA(
		     HWND hDlg,
		     int nIDDlgItem,
		     LPCSTR lpString);
		
		BOOL SetDlgItemTextW(
		     HWND hDlg,
		     int nIDDlgItem,
		     LPCWSTR lpString);
		
		version(UNICODE) {
			alias SetDlgItemTextW SetDlgItemText;
		}
		else {
			alias SetDlgItemTextA SetDlgItemText;
		}
		
		UINT GetDlgItemTextA(
		     HWND hDlg,
		     int nIDDlgItem,
			 LPSTR lpString,
		     int cchMax);
		
		UINT GetDlgItemTextW(
		     HWND hDlg,
		     int nIDDlgItem,
			 LPWSTR lpString,
		     int cchMax);
		
		version(UNICODE) {
			alias GetDlgItemTextW GetDlgItemText;
		}
		else {
			alias GetDlgItemTextA GetDlgItemText;
		}
		
		BOOL CheckDlgButton(
		     HWND hDlg,
		     int nIDButton,
		     UINT uCheck);
		
		BOOL CheckRadioButton(
		     HWND hDlg,
		     int nIDFirstButton,
		     int nIDLastButton,
		     int nIDCheckButton);
		
		UINT IsDlgButtonChecked(
		     HWND hDlg,
		     int nIDButton);
		
		LRESULT SendDlgItemMessageA(
		     HWND hDlg,
		     int nIDDlgItem,
		     UINT Msg,
		     WPARAM wParam,
		     LPARAM lParam);
		
		LRESULT SendDlgItemMessageW(
		     HWND hDlg,
		     int nIDDlgItem,
		     UINT Msg,
		     WPARAM wParam,
		     LPARAM lParam);
		
		version(UNICODE) {
			alias SendDlgItemMessageW SendDlgItemMessage;
		}
		else {
			alias SendDlgItemMessageA SendDlgItemMessage;
		}
		
		HWND GetNextDlgGroupItem(
		     HWND hDlg,
		     HWND hCtl,
		     BOOL bPrevious);
		
		HWND GetNextDlgTabItem(
		     HWND hDlg,
		     HWND hCtl,
		     BOOL bPrevious);
		
		int GetDlgCtrlID(
		     HWND hWnd);
		
		Clong_t GetDialogBaseUnits();
		
		LRESULT DefDlgProcA(
		     HWND hDlg,
		     UINT Msg,
		     WPARAM wParam,
		     LPARAM lParam);
		
		LRESULT DefDlgProcW(
		     HWND hDlg,
		     UINT Msg,
		     WPARAM wParam,
		     LPARAM lParam);
		
		version(UNICODE) {
			alias DefDlgProcW DefDlgProc;
		}
		else {
			alias DefDlgProcA DefDlgProc;
		}
	
		/*
		 * Window extra byted needed for private dialog classes.
		 */
		const auto DLGWINDOWEXTRA  = 30;
	}
	
	version(NOMSG) {
	}
	else {
		BOOL CallMsgFilterA(
		     LPMSG lpMsg,
		     int nCode);
	
		BOOL CallMsgFilterW(
		     LPMSG lpMsg,
		     int nCode);
	
		version(UNICODE) {
			alias CallMsgFilterW CallMsgFilter;
		}
		else {
			alias CallMsgFilterA CallMsgFilter;
		}
	}
	
	version(NOCLIPBOARD) {
	}
	else {
		/*
		 * Clipboard Manager Functions
		 */
		
		BOOL OpenClipboard(
		     HWND hWndNewOwner);
		
		BOOL CloseClipboard();
		
		DWORD GetClipboardSequenceNumber();
		
		HWND GetClipboardOwner();
		
		HWND SetClipboardViewer(
		     HWND hWndNewViewer);
		
		HWND GetClipboardViewer();
		
		BOOL ChangeClipboardChain(
		     HWND hWndRemove,
		     HWND hWndNewNext);
		
		HANDLE SetClipboardData(
		     UINT uFormat,
		     HANDLE hMem);
		
		HANDLE GetClipboardData(
		     UINT uFormat);
		
		UINT RegisterClipboardFormatA(
		     LPCSTR lpszFormat);
		
		UINT RegisterClipboardFormatW(
		     LPCWSTR lpszFormat);
		
		version(UNICODE) {
			alias RegisterClipboardFormatW RegisterClipboardFormat;
		}
		else {
			alias RegisterClipboardFormatA RegisterClipboardFormat;
		}
		
		int CountClipboardFormats();
		
		UINT EnumClipboardFormats(
		     UINT format);
		
		int GetClipboardFormatNameA(
		     UINT format,
			 LPSTR lpszFormatName,
		     int cchMaxCount);
		
		int GetClipboardFormatNameW(
		     UINT format,
			 LPWSTR lpszFormatName,
		     int cchMaxCount);
		
		version(UNICODE) {
			alias GetClipboardFormatNameW GetClipboardFormatName;
		}
		else {
			alias GetClipboardFormatNameA GetClipboardFormatName;
		}
		
		BOOL EmptyClipboard();
		
		BOOL IsClipboardFormatAvailable(
		     UINT format);
		
		int GetPriorityClipboardFormat(
		     UINT *paFormatPriorityList,
		     int cFormats);

		HWND GetOpenClipboardWindow();
		
		BOOL AddClipboardFormatListener(
		     HWND hwnd);
		
		BOOL RemoveClipboardFormatListener(
		     HWND hwnd);
		
		BOOL GetUpdatedClipboardFormats(
		     PUINT lpuiFormats,
		     UINT cFormats,
		     PUINT pcFormatsOut);
	}
	
	/*
	 * Character Translation Routines
	 */
	
	BOOL CharToOemA(
	     LPCSTR pSrc,
		 LPSTR pDst);
	
	BOOL CharToOemW(
	     LPCWSTR pSrc,
		 LPSTR pDst);
	
	version(UNICODE) {
		alias CharToOemW CharToOem;
	}
	else {
		alias CharToOemA CharToOem;
	}
	
	BOOL OemToCharA(
	     LPCSTR pSrc,
		 LPSTR pDst);
	
	BOOL OemToCharW(
	     LPCSTR pSrc,
		 LPWSTR pDst);
	
	version(UNICODE) {
		alias OemToCharW OemToChar;
	}
	else {
		alias OemToCharA OemToChar;
	}

	BOOL CharToOemBuffA(
	     LPCSTR lpszSrc,
		 LPSTR lpszDst,
	     DWORD cchDstLength);
	
	BOOL CharToOemBuffW(
	     LPCWSTR lpszSrc,
		 LPSTR lpszDst,
	     DWORD cchDstLength);
	
	version(UNICODE) {
		alias CharToOemBuffW CharToOemBuff;
	}
	else {
		alias CharToOemBuffA CharToOemBuff;
	}
	
	BOOL OemToCharBuffA(
	     LPCSTR lpszSrc,
		 LPSTR lpszDst,
	     DWORD cchDstLength);
	
	BOOL OemToCharBuffW(
	     LPCSTR lpszSrc,
		 LPWSTR lpszDst,
	     DWORD cchDstLength);
	
	version(UNICODE) {
		alias OemToCharBuffW OemToCharBuff;
	}
	else {
		alias OemToCharBuffA OemToCharBuff;
	}
	
	LPSTR CharUpperA(
	     LPSTR lpsz);
	
	LPWSTR CharUpperW(
	     LPWSTR lpsz);
	
	version(UNICODE) {
		alias CharUpperW CharUpper;
	}
	else {
		alias CharUpperA CharUpper;
	}
	
	DWORD CharUpperBuffA(
	     LPSTR lpsz,
	     DWORD cchLength);
	
	DWORD CharUpperBuffW(
	     LPWSTR lpsz,
	     DWORD cchLength);
	
	version(UNICODE) {
		alias CharUpperBuffW CharUpperBuff;
	}
	else {
		alias CharUpperBuffA CharUpperBuff;
	}
	
	LPSTR CharLowerA(
	     LPSTR lpsz);
	
	LPWSTR CharLowerW(
	     LPWSTR lpsz);
	
	version(UNICODE) {
		alias CharLowerW CharLower;
	}
	else {
		alias CharLowerA CharLower;
	}
	
	DWORD CharLowerBuffA(
	     LPSTR lpsz,
	     DWORD cchLength);
	
	DWORD CharLowerBuffW(
	     LPWSTR lpsz,
	     DWORD cchLength);
	
	version(UNICODE) {
		alias CharLowerBuffW CharLowerBuff;
	}
	else {
		alias CharLowerBuffA CharLowerBuff;
	}
	
	LPSTR CharNextA(
	     LPCSTR lpsz);
	LPWSTR CharNextW(
	     LPCWSTR lpsz);
	
	version(UNICODE) {
		alias CharNextW CharNext;
	}
	else {
		alias CharNextA CharNext;
	}
	
	LPSTR CharPrevA(
	     LPCSTR lpszStart,
	     LPCSTR lpszCurrent);
	LPWSTR CharPrevW(
	     LPCWSTR lpszStart,
	     LPCWSTR lpszCurrent);
	
	version(UNICODE) {
		alias CharPrevW CharPrev;
	}
	else {
		alias CharPrevA CharPrev;
	}
	
	LPSTR CharNextExA(
	      WORD CodePage,
	      LPCSTR lpCurrentChar,
	      DWORD dwFlags);
	
	LPSTR CharPrevExA(
	      WORD CodePage,
	      LPCSTR lpStart,
	      LPCSTR lpCurrentChar,
	      DWORD dwFlags);
	
	/*
	 * Compatibility defines for character translation routines
	 */
	alias CharToOemA AnsiToOem;
	alias OemToCharA OemToAnsi;
	alias CharToOemBuffA AnsiToOemBuff;
	alias OemToCharBuffA OemToAnsiBuff;
	alias CharUpperA AnsiUpper;
	alias CharUpperBuffA AnsiUpperBuff;
	alias CharLowerA AnsiLower;
	alias CharLowerBuffA AnsiLowerBuff;
	alias CharNextA AnsiNext;
	alias CharPrevA AnsiPrev;
	
	version(NOLANGUAGE) {
	}
	else {
		/*
		 * Language dependent Routines
		 */
		
		BOOL IsCharAlphaA(
		     CHAR ch);
		
		BOOL IsCharAlphaW(
		     WCHAR ch);
		
		version(UNICODE) {
			alias IsCharAlphaW IsCharAlpha;
		}
		else {
			alias IsCharAlphaA IsCharAlpha;
		}
		
		BOOL IsCharAlphaNumericA(
		     CHAR ch);
		
		BOOL IsCharAlphaNumericW(
		     WCHAR ch);
		
		version(UNICODE) {
			alias IsCharAlphaNumericW IsCharAlphaNumeric;
		}
		else {
			alias IsCharAlphaNumericA IsCharAlphaNumeric;
		}
		
		BOOL IsCharUpperA(
		     CHAR ch);
		
		BOOL IsCharUpperW(
		     WCHAR ch);
		
		version(UNICODE) {
			alias IsCharUpperW IsCharUpper;
		}
		else {
			alias IsCharUpperA IsCharUpper;
		}
		
		BOOL IsCharLowerA(
		     CHAR ch);
		
		BOOL IsCharLowerW(
		     WCHAR ch);
		
		version(UNICODE) {
			alias IsCharLowerW IsCharLower;
		}
		else {
			alias IsCharLowerA IsCharLower;
		}
	}
	
	HWND SetFocus(
	     HWND hWnd);
	
	HWND GetActiveWindow();
	
	HWND GetFocus();
	
	UINT GetKBCodePage();
	
	SHORT GetKeyState(
	     int nVirtKey);
	
	SHORT GetAsyncKeyState(
	     int vKey);
	
	BOOL GetKeyboardState(
	     PBYTE lpKeyState);
	
	BOOL SetKeyboardState(
	     LPBYTE lpKeyState);
	
	int GetKeyNameTextA(
	     LONG lParam,
		 LPSTR lpString,
	     int cchSize);
	
	int GetKeyNameTextW(
	     LONG lParam,
		 LPWSTR lpString,
	     int cchSize);
	
	version(UNICODE) {
		alias GetKeyNameTextW GetKeyNameText;
	}
	else {
		alias GetKeyNameTextA GetKeyNameText;
	}
	
	int GetKeyboardType(
	     int nTypeFlag);
	
	int ToAscii(
	     UINT uVirtKey,
	     UINT uScanCode,
		 BYTE *lpKeyState,
	     LPWORD lpChar,
	     UINT uFlags);
	
	int ToAsciiEx(
	     UINT uVirtKey,
	     UINT uScanCode,
		 BYTE *lpKeyState,
	     LPWORD lpChar,
	     UINT uFlags,
	     HKL dwhkl);
	
	int ToUnicode(
	     UINT wVirtKey,
	     UINT wScanCode,
		 BYTE *lpKeyState,
		 LPWSTR pwszBuff,
	     int cchBuff,
	     UINT wFlags);
	
	DWORD OemKeyScan(
	     WORD wOemChar);
	
	SHORT VkKeyScanA(
	     CHAR ch);
	
	SHORT VkKeyScanW(
	     WCHAR ch);
	
	version(UNICODE) {
		alias VkKeyScanW VkKeyScan;
	}
	else {
		alias VkKeyScanA VkKeyScan;
	}
	
	SHORT VkKeyScanExA(
	     CHAR ch,
	     HKL dwhkl);
	
	SHORT VkKeyScanExW(
	     WCHAR ch,
	     HKL dwhkl);
	
	version(UNICODE) {
		alias VkKeyScanExW VkKeyScanEx;
	}
	else {
		alias VkKeyScanExA VkKeyScanEx;
	}
	
	const auto KEYEVENTF_EXTENDEDKEY  = 0x0001;
	const auto KEYEVENTF_KEYUP        = 0x0002;
	
	const auto KEYEVENTF_UNICODE      = 0x0004;
	const auto KEYEVENTF_SCANCODE     = 0x0008;
	
	VOID keybd_event(
	     BYTE bVk,
	     BYTE bScan,
	     DWORD dwFlags,
	     ULONG_PTR dwExtraInfo);
	
	const auto MOUSEEVENTF_MOVE         = 0x0001 /* mouse move */;
	const auto MOUSEEVENTF_LEFTDOWN     = 0x0002 /* left button down */;
	const auto MOUSEEVENTF_LEFTUP       = 0x0004 /* left button up */;
	const auto MOUSEEVENTF_RIGHTDOWN    = 0x0008 /* right button down */;
	const auto MOUSEEVENTF_RIGHTUP      = 0x0010 /* right button up */;
	const auto MOUSEEVENTF_MIDDLEDOWN   = 0x0020 /* middle button down */;
	const auto MOUSEEVENTF_MIDDLEUP     = 0x0040 /* middle button up */;
	const auto MOUSEEVENTF_XDOWN        = 0x0080 /* x button down */;
	const auto MOUSEEVENTF_XUP          = 0x0100 /* x button down */;
	const auto MOUSEEVENTF_WHEEL        = 0x0800 /* wheel button rolled */;
	
	const auto MOUSEEVENTF_HWHEEL       = 0x01000 /* hwheel button rolled */;
	
	const auto MOUSEEVENTF_MOVE_NOCOALESCE  = 0x2000 /* do not coalesce mouse moves */;
	
	const auto MOUSEEVENTF_VIRTUALDESK  = 0x4000 /* map to entire virtual desktop */;
	const auto MOUSEEVENTF_ABSOLUTE     = 0x8000 /* absolute move */;
	
	
	VOID mouse_event(
	     DWORD dwFlags,
	     DWORD dx,
	     DWORD dy,
	     DWORD dwData,
	     ULONG_PTR dwExtraInfo);
	
	struct MOUSEINPUT {
	    LONG    dx;
	    LONG    dy;
	    DWORD   mouseData;
	    DWORD   dwFlags;
	    DWORD   time;
	    ULONG_PTR dwExtraInfo;
	}
	
	alias MOUSEINPUT* PMOUSEINPUT;
	alias MOUSEINPUT * LPMOUSEINPUT;

	struct KEYBDINPUT {
	    WORD    wVk;
	    WORD    wScan;
	    DWORD   dwFlags;
	    DWORD   time;
	    ULONG_PTR dwExtraInfo;
	}
	
	alias KEYBDINPUT* PKEYBDINPUT;
	alias KEYBDINPUT * LPKEYBDINPUT;
	
	struct HARDWAREINPUT {
	    DWORD   uMsg;
	    WORD    wParam;
	    WORD    wParamH;
	}
	
	alias HARDWAREINPUT* PHARDWAREINPUT;
	alias HARDWAREINPUT * LPHARDWAREINPUT;
	
	const auto INPUT_MOUSE      = 0;
	const auto INPUT_KEYBOARD   = 1;
	const auto INPUT_HARDWARE   = 2;
	
	struct INPUT {
	    DWORD   type;
	
	    union _inner_union {
	        MOUSEINPUT      mi;
	        KEYBDINPUT      ki;
	        HARDWAREINPUT   hi;
	    }
	    
	    _inner_union fields;
	}
	
	alias INPUT* PINPUT;
	alias INPUT * LPINPUT;
	
	UINT SendInput(
	     UINT cInputs,                     // number of input in the array
	     LPINPUT pInputs,  // array of inputs
	     int cbSize);                      // sizeof(INPUT)
	
	
	struct LASTINPUTINFO {
	    UINT cbSize;
	    DWORD dwTime;
	}
	
	alias LASTINPUTINFO*  PLASTINPUTINFO;
	
	BOOL GetLastInputInfo(
	     PLASTINPUTINFO plii);
	
	UINT MapVirtualKeyA(
	     UINT uCode,
	     UINT uMapType);
	
	UINT MapVirtualKeyW(
	     UINT uCode,
	     UINT uMapType);
	
	version(UNICODE) {
		alias MapVirtualKeyW MapVirtualKey;
	}
	else {
		alias MapVirtualKeyA MapVirtualKey;
	}
	
	UINT MapVirtualKeyExA(
	     UINT uCode,
	     UINT uMapType,
	     HKL dwhkl);
	UINT MapVirtualKeyExW(
	     UINT uCode,
	     UINT uMapType,
	     HKL dwhkl);
	
	version(UNICODE) {
		alias MapVirtualKeyExW MapVirtualKeyEx;
	}
	else {
		alias MapVirtualKeyExA MapVirtualKeyEx;
	}

	const auto MAPVK_VK_TO_VSC      = (0);
	const auto MAPVK_VSC_TO_VK      = (1);
	const auto MAPVK_VK_TO_CHAR     = (2);
	const auto MAPVK_VSC_TO_VK_EX   = (3);
	
	const auto MAPVK_VK_TO_VSC_EX   = (4);
	
	BOOL GetInputState();
	
	DWORD GetQueueStatus(
	     UINT flags);
	
	
	HWND GetCapture();
	
	HWND SetCapture(
	     HWND hWnd);
	
	BOOL ReleaseCapture();
	
	DWORD MsgWaitForMultipleObjects(
	     DWORD nCount,
		 HANDLE *pHandles,
	     BOOL fWaitAll,
	     DWORD dwMilliseconds,
	     DWORD dwWakeMask);
	
	DWORD MsgWaitForMultipleObjectsEx(
	     DWORD nCount,
		 HANDLE *pHandles,
	     DWORD dwMilliseconds,
	     DWORD dwWakeMask,
	     DWORD dwFlags);
	
	
	const auto MWMO_WAITALL         = 0x0001;
	const auto MWMO_ALERTABLE       = 0x0002;
	const auto MWMO_INPUTAVAILABLE  = 0x0004;
	
	/*
	 * Queue status flags for GetQueueStatus() and MsgWaitForMultipleObjects()
	 */
	const auto QS_KEY               = 0x0001;
	const auto QS_MOUSEMOVE         = 0x0002;
	const auto QS_MOUSEBUTTON       = 0x0004;
	const auto QS_POSTMESSAGE       = 0x0008;
	const auto QS_TIMER             = 0x0010;
	const auto QS_PAINT             = 0x0020;
	const auto QS_SENDMESSAGE       = 0x0040;
	const auto QS_HOTKEY            = 0x0080;
	const auto QS_ALLPOSTMESSAGE    = 0x0100;
	
	const auto QS_RAWINPUT          = 0x0400;
	
	const auto QS_MOUSE            = (QS_MOUSEMOVE     |
	                            QS_MOUSEBUTTON);
	
	const auto QS_INPUT            = (QS_MOUSE         |
	                            QS_KEY           |
	                            QS_RAWINPUT);

	const auto QS_ALLEVENTS        = (QS_INPUT         |
	                            QS_POSTMESSAGE   |
	                            QS_TIMER         |
	                            QS_PAINT         |
	                            QS_HOTKEY);

	const auto QS_ALLINPUT         = (QS_INPUT         |
	                            QS_POSTMESSAGE   |
	                            QS_TIMER         |
	                            QS_PAINT         |
	                            QS_HOTKEY        |
	                            QS_SENDMESSAGE);
	
	version(NOMSG) {
	}
	else {
		const auto PM_QS_INPUT          = (QS_INPUT << 16);
		const auto PM_QS_POSTMESSAGE    = ((QS_POSTMESSAGE | QS_HOTKEY | QS_TIMER) << 16);
		const auto PM_QS_PAINT          = (QS_PAINT << 16);
		const auto PM_QS_SENDMESSAGE    = (QS_SENDMESSAGE << 16);
	}

	const auto USER_TIMER_MAXIMUM   = 0x7FFFFFFF;
	const auto USER_TIMER_MINIMUM   = 0x0000000A;
	
	/*
	 * Windows Functions
	 */
	
	UINT_PTR SetTimer(
	     HWND hWnd,
	     UINT_PTR nIDEvent,
	     UINT uElapse,
	     TIMERPROC lpTimerFunc);
	
	BOOL KillTimer(
	     HWND hWnd,
	     UINT_PTR uIDEvent);
	
	BOOL IsWindowUnicode(
	     HWND hWnd);
	
	BOOL EnableWindow(
	     HWND hWnd,
	     BOOL bEnable);
	
	BOOL IsWindowEnabled(
	     HWND hWnd);
	
	HACCEL LoadAcceleratorsA(
	     HINSTANCE hInstance,
	     LPCSTR lpTableName);
	
	HACCEL LoadAcceleratorsW(
	     HINSTANCE hInstance,
	     LPCWSTR lpTableName);
	
	version(UNICODE) {
		alias LoadAcceleratorsW LoadAccelerators;
	}
	else {
		alias LoadAcceleratorsA LoadAccelerators;
	}
	
	HACCEL CreateAcceleratorTableA(
	     LPACCEL paccel,
	     int cAccel);
	
	HACCEL CreateAcceleratorTableW(
	     LPACCEL paccel,
	     int cAccel);
	
	version(UNICODE) {
		alias CreateAcceleratorTableW CreateAcceleratorTable;
	}
	else {
		alias CreateAcceleratorTableA CreateAcceleratorTable;
	}
	
	BOOL DestroyAcceleratorTable(
	     HACCEL hAccel);
	
	int CopyAcceleratorTableA(
	     HACCEL hAccelSrc,
		 LPACCEL lpAccelDst,
	     int cAccelEntries);
	
	int CopyAcceleratorTableW(
	     HACCEL hAccelSrc,
		 LPACCEL lpAccelDst,
	     int cAccelEntries);

	version(UNICODE) {
		alias CopyAcceleratorTableW CopyAcceleratorTable;
	}
	else {
		alias CopyAcceleratorTableA CopyAcceleratorTable;
	}
	
	version(NOMSG) {
	}
	else {
		int TranslateAcceleratorA(
		     HWND hWnd,
		     HACCEL hAccTable,
		     LPMSG lpMsg);
		int TranslateAcceleratorW(
		     HWND hWnd,
		     HACCEL hAccTable,
		     LPMSG lpMsg);
	
		version(UNICODE) {
			alias TranslateAcceleratorW TranslateAccelerator;
		}
		else {
			alias TranslateAcceleratorA TranslateAccelerator;
		}
	}
	
	version(NOSYSMETRICS) {
	}
	else {
		/*
		 * GetSystemMetrics() codes
		 */
		
		const auto SM_CXSCREEN              = 0;
		const auto SM_CYSCREEN              = 1;
		const auto SM_CXVSCROLL             = 2;
		const auto SM_CYHSCROLL             = 3;
		const auto SM_CYCAPTION             = 4;
		const auto SM_CXBORDER              = 5;
		const auto SM_CYBORDER              = 6;
		const auto SM_CXDLGFRAME            = 7;
		const auto SM_CYDLGFRAME            = 8;
		const auto SM_CYVTHUMB              = 9;
		const auto SM_CXHTHUMB              = 10;
		const auto SM_CXICON                = 11;
		const auto SM_CYICON                = 12;
		const auto SM_CXCURSOR              = 13;
		const auto SM_CYCURSOR              = 14;
		const auto SM_CYMENU                = 15;
		const auto SM_CXFULLSCREEN          = 16;
		const auto SM_CYFULLSCREEN          = 17;
		const auto SM_CYKANJIWINDOW         = 18;
		const auto SM_MOUSEPRESENT          = 19;
		const auto SM_CYVSCROLL             = 20;
		const auto SM_CXHSCROLL             = 21;
		const auto SM_DEBUG                 = 22;
		const auto SM_SWAPBUTTON            = 23;
		const auto SM_RESERVED1             = 24;
		const auto SM_RESERVED2             = 25;
		const auto SM_RESERVED3             = 26;
		const auto SM_RESERVED4             = 27;
		const auto SM_CXMIN                 = 28;
		const auto SM_CYMIN                 = 29;
		const auto SM_CXSIZE                = 30;
		const auto SM_CYSIZE                = 31;
		const auto SM_CXFRAME               = 32;
		const auto SM_CYFRAME               = 33;
		const auto SM_CXMINTRACK            = 34;
		const auto SM_CYMINTRACK            = 35;
		const auto SM_CXDOUBLECLK           = 36;
		const auto SM_CYDOUBLECLK           = 37;
		const auto SM_CXICONSPACING         = 38;
		const auto SM_CYICONSPACING         = 39;
		const auto SM_MENUDROPALIGNMENT     = 40;
		const auto SM_PENWINDOWS            = 41;
		const auto SM_DBCSENABLED           = 42;
		const auto SM_CMOUSEBUTTONS         = 43;
	
		const auto SM_CXFIXEDFRAME            = SM_CXDLGFRAME;  /* ;win40 name change */
		const auto SM_CYFIXEDFRAME            = SM_CYDLGFRAME;  /* ;win40 name change */
		const auto SM_CXSIZEFRAME             = SM_CXFRAME;     /* ;win40 name change */
		const auto SM_CYSIZEFRAME             = SM_CYFRAME;     /* ;win40 name change */
		
		const auto SM_SECURE                = 44;
		const auto SM_CXEDGE                = 45;
		const auto SM_CYEDGE                = 46;
		const auto SM_CXMINSPACING          = 47;
		const auto SM_CYMINSPACING          = 48;
		const auto SM_CXSMICON              = 49;
		const auto SM_CYSMICON              = 50;
		const auto SM_CYSMCAPTION           = 51;
		const auto SM_CXSMSIZE              = 52;
		const auto SM_CYSMSIZE              = 53;
		const auto SM_CXMENUSIZE            = 54;
		const auto SM_CYMENUSIZE            = 55;
		const auto SM_ARRANGE               = 56;
		const auto SM_CXMINIMIZED           = 57;
		const auto SM_CYMINIMIZED           = 58;
		const auto SM_CXMAXTRACK            = 59;
		const auto SM_CYMAXTRACK            = 60;
		const auto SM_CXMAXIMIZED           = 61;
		const auto SM_CYMAXIMIZED           = 62;
		const auto SM_NETWORK               = 63;
		const auto SM_CLEANBOOT             = 67;
		const auto SM_CXDRAG                = 68;
		const auto SM_CYDRAG                = 69;
		
		const auto SM_SHOWSOUNDS            = 70;
		
		const auto SM_CXMENUCHECK           = 71   /* Use instead of GetMenuCheckMarkDimensions()! */;
		const auto SM_CYMENUCHECK           = 72;
		const auto SM_SLOWMACHINE           = 73;
		const auto SM_MIDEASTENABLED        = 74;
		
		const auto SM_MOUSEWHEELPRESENT     = 75;
		
		const auto SM_XVIRTUALSCREEN        = 76;
		const auto SM_YVIRTUALSCREEN        = 77;
		const auto SM_CXVIRTUALSCREEN       = 78;
		const auto SM_CYVIRTUALSCREEN       = 79;
		const auto SM_CMONITORS             = 80;
		const auto SM_SAMEDISPLAYFORMAT     = 81;
		
		const auto SM_IMMENABLED            = 82;
		
		const auto SM_CXFOCUSBORDER         = 83;
		const auto SM_CYFOCUSBORDER         = 84;
	
		const auto SM_TABLETPC              = 86;
		const auto SM_MEDIACENTER           = 87;
		const auto SM_STARTER               = 88;
		const auto SM_SERVERR2              = 89;
	
		const auto SM_MOUSEHORIZONTALWHEELPRESENT     = 91;
		const auto SM_CXPADDEDBORDER        = 92;
	
		const auto SM_CMETRICS              = 93;
	
		const auto SM_REMOTESESSION         = 0x1000;
	
		const auto SM_SHUTTINGDOWN          = 0x2000;
	
		const auto SM_REMOTECONTROL         = 0x2001;
	
		const auto SM_CARETBLINKINGENABLED  = 0x2002;
	
		int GetSystemMetrics(
		     int nIndex);
	}
	
	version(NOMENUS) {
	}
	else {
		HMENU LoadMenuA(
		     HINSTANCE hInstance,
		     LPCSTR lpMenuName);
		
		HMENU LoadMenuW(
		     HINSTANCE hInstance,
		     LPCWSTR lpMenuName);
		
		version(UNICODE) {
			alias LoadMenuW LoadMenu;
		}
		else {
			alias LoadMenuA LoadMenu;
		}
		
		HMENU LoadMenuIndirectA(
		     MENUTEMPLATEA *lpMenuTemplate);
		HMENU LoadMenuIndirectW(
		     MENUTEMPLATEW *lpMenuTemplate);
		
		version(UNICODE) {
			alias LoadMenuIndirectW LoadMenuIndirect;
		}
		else {
			alias LoadMenuIndirectA LoadMenuIndirect;
		}
		
		HMENU GetMenu(
		     HWND hWnd);
		
		BOOL SetMenu(
		     HWND hWnd,
		     HMENU hMenu);
		
		BOOL ChangeMenuA(
		     HMENU hMenu,
		     UINT cmd,
		     LPCSTR lpszNewItem,
		     UINT cmdInsert,
		     UINT flags);
		BOOL ChangeMenuW(
		     HMENU hMenu,
		     UINT cmd,
		     LPCWSTR lpszNewItem,
		     UINT cmdInsert,
		     UINT flags);
		
		version(UNICODE) {
			alias ChangeMenuW ChangeMenu;
		}
		else {
			alias ChangeMenuA ChangeMenu;
		}
		
		BOOL HiliteMenuItem(
		     HWND hWnd,
		     HMENU hMenu,
		     UINT uIDHiliteItem,
		     UINT uHilite);
		
		int GetMenuStringA(
		     HMENU hMenu,
		     UINT uIDItem,
			 LPSTR lpString,
		     int cchMax,
		     UINT flags);
		
		int GetMenuStringW(
		     HMENU hMenu,
		     UINT uIDItem,
			 LPWSTR lpString,
		     int cchMax,
		     UINT flags);
		
		version(UNICODE) {
			alias GetMenuStringW GetMenuString;
		}
		else {
			alias GetMenuStringA GetMenuString;
		}
		
		UINT GetMenuState(
		     HMENU hMenu,
		     UINT uId,
		     UINT uFlags);

		BOOL DrawMenuBar(
		     HWND hWnd);
		
		const auto PMB_ACTIVE       = 0x00000001;
		
		HMENU GetSystemMenu(
		     HWND hWnd,
		     BOOL bRevert);
		
		
		HMENU CreateMenu();
		
		HMENU CreatePopupMenu();
		
		BOOL DestroyMenu(
		     HMENU hMenu);
		
		DWORD CheckMenuItem(
		     HMENU hMenu,
		     UINT uIDCheckItem,
		     UINT uCheck);
		
		BOOL EnableMenuItem(
		     HMENU hMenu,
		     UINT uIDEnableItem,
		     UINT uEnable);
		
		HMENU GetSubMenu(
		     HMENU hMenu,
		     int nPos);
		
		UINT GetMenuItemID(
		     HMENU hMenu,
		     int nPos);
		
		int GetMenuItemCount(
		     HMENU hMenu);
		
		BOOL InsertMenuA(
		     HMENU hMenu,
		     UINT uPosition,
		     UINT uFlags,
		     UINT_PTR uIDNewItem,
		     LPCSTR lpNewItem);
		
		BOOL InsertMenuW(
		     HMENU hMenu,
		     UINT uPosition,
		     UINT uFlags,
		     UINT_PTR uIDNewItem,
		     LPCWSTR lpNewItem);
		
		version(UNICODE) {
			alias InsertMenuW InsertMenu;
		}
		else {
			alias InsertMenuA InsertMenu;
		}
	
		BOOL AppendMenuA(
		     HMENU hMenu,
		     UINT uFlags,
		     UINT_PTR uIDNewItem,
		     LPCSTR lpNewItem);
		
		BOOL AppendMenuW(
		     HMENU hMenu,
		     UINT uFlags,
		     UINT_PTR uIDNewItem,
		     LPCWSTR lpNewItem);
		
		version(UNICODE) {
			alias AppendMenuW AppendMenu;
		}
		else {
			alias AppendMenuA AppendMenu;
		}
		
		BOOL ModifyMenuA(
		     HMENU hMnu,
		     UINT uPosition,
		     UINT uFlags,
		     UINT_PTR uIDNewItem,
		     LPCSTR lpNewItem);
		BOOL ModifyMenuW(
		     HMENU hMnu,
		     UINT uPosition,
		     UINT uFlags,
		     UINT_PTR uIDNewItem,
		     LPCWSTR lpNewItem);
		
		version(UNICODE) {
			alias ModifyMenuW ModifyMenu;
		}
		else {
			alias ModifyMenuA ModifyMenu;
		}
		
		BOOL RemoveMenu(
		     HMENU hMenu,
		     UINT uPosition,
		     UINT uFlags);
		
		BOOL DeleteMenu(
		     HMENU hMenu,
		     UINT uPosition,
		     UINT uFlags);
		
		BOOL SetMenuItemBitmaps(
		     HMENU hMenu,
		     UINT uPosition,
		     UINT uFlags,
		     HBITMAP hBitmapUnchecked,
		     HBITMAP hBitmapChecked);
		
		LONG GetMenuCheckMarkDimensions();
		
		BOOL TrackPopupMenu(
		     HMENU hMenu,
		     UINT uFlags,
		     int x,
		     int y,
		     int nReserved,
		     HWND hWnd,
		     RECT *prcRect);
		
		/* return codes for WM_MENUCHAR */
		const auto MNC_IGNORE   = 0;
		const auto MNC_CLOSE    = 1;
		const auto MNC_EXECUTE  = 2;
		const auto MNC_SELECT   = 3;
		
		struct TPMPARAMS {
		    UINT    cbSize;     /* Size of structure */
		    RECT    rcExclude;  /* Screen coordinates of rectangle to exclude when positioning */
		}
		
		alias TPMPARAMS  *LPTPMPARAMS;
		
		BOOL TrackPopupMenuEx(
		     HMENU,
		     UINT,
		     int,
		     int,
		     HWND,
		     LPTPMPARAMS);
		
		const auto MNS_NOCHECK          = 0x80000000;
		const auto MNS_MODELESS         = 0x40000000;
		const auto MNS_DRAGDROP         = 0x20000000;
		const auto MNS_AUTODISMISS      = 0x10000000;
		const auto MNS_NOTIFYBYPOS      = 0x08000000;
		const auto MNS_CHECKORBMP       = 0x04000000;
		
		const auto MIM_MAXHEIGHT                = 0x00000001;
		const auto MIM_BACKGROUND               = 0x00000002;
		const auto MIM_HELPID                   = 0x00000004;
		const auto MIM_MENUDATA                 = 0x00000008;
		const auto MIM_STYLE                    = 0x00000010;
		const auto MIM_APPLYTOSUBMENUS          = 0x80000000;
		
		struct MENUINFO {
		    DWORD   cbSize;
		    DWORD   fMask;
		    DWORD   dwStyle;
		    UINT    cyMax;
		    HBRUSH  hbrBack;
		    DWORD   dwContextHelpID;
		    ULONG_PTR dwMenuData;
		}
		
		alias MENUINFO *LPMENUINFO;
		alias MENUINFO *LPCMENUINFO;
		
		BOOL GetMenuInfo(
		     HMENU,
		     LPMENUINFO);
		
		BOOL SetMenuInfo(
		     HMENU,
		     LPCMENUINFO);
		
		BOOL EndMenu();
		
		/*
		 * WM_MENUDRAG return values.
		 */
		const auto MND_CONTINUE        = 0;
		const auto MND_ENDMENU         = 1;
		
		struct MENUGETOBJECTINFO {
		    DWORD dwFlags;
		    UINT uPos;
		    HMENU hmenu;
		    PVOID riid;
		    PVOID pvObj;
		}
		
		alias MENUGETOBJECTINFO*  PMENUGETOBJECTINFO;
		
		/*
		 * MENUGETOBJECTINFO dwFlags values
		 */
		const auto MNGOF_TOPGAP          = 0x00000001;
		const auto MNGOF_BOTTOMGAP       = 0x00000002;
		
		/*
		 * WM_MENUGETOBJECT return values
		 */
		const auto MNGO_NOINTERFACE      = 0x00000000;
		const auto MNGO_NOERROR          = 0x00000001;
		
		const auto MIIM_STATE        = 0x00000001;
		const auto MIIM_ID           = 0x00000002;
		const auto MIIM_SUBMENU      = 0x00000004;
		const auto MIIM_CHECKMARKS   = 0x00000008;
		const auto MIIM_TYPE         = 0x00000010;
		const auto MIIM_DATA         = 0x00000020;
		
		const auto MIIM_STRING       = 0x00000040;
		const auto MIIM_BITMAP       = 0x00000080;
		const auto MIIM_FTYPE        = 0x00000100;
		
		const auto HBMMENU_CALLBACK             = (cast(HBITMAP) -1);
		const auto HBMMENU_SYSTEM               = (cast(HBITMAP)  1);
		const auto HBMMENU_MBAR_RESTORE         = (cast(HBITMAP)  2);
		const auto HBMMENU_MBAR_MINIMIZE        = (cast(HBITMAP)  3);
		const auto HBMMENU_MBAR_CLOSE           = (cast(HBITMAP)  5);
		const auto HBMMENU_MBAR_CLOSE_D         = (cast(HBITMAP)  6);
		const auto HBMMENU_MBAR_MINIMIZE_D      = (cast(HBITMAP)  7);
		const auto HBMMENU_POPUP_CLOSE          = (cast(HBITMAP)  8);
		const auto HBMMENU_POPUP_RESTORE        = (cast(HBITMAP)  9);
		const auto HBMMENU_POPUP_MAXIMIZE       = (cast(HBITMAP) 10);
		const auto HBMMENU_POPUP_MINIMIZE       = (cast(HBITMAP) 11);

		struct MENUITEMINFOA {
		    UINT     cbSize;
		    UINT     fMask;
		    UINT     fType;         // used if MIIM_TYPE (4.0) or MIIM_FTYPE (>4.0)
		    UINT     fState;        // used if MIIM_STATE
		    UINT     wID;           // used if MIIM_ID
		    HMENU    hSubMenu;      // used if MIIM_SUBMENU
		    HBITMAP  hbmpChecked;   // used if MIIM_CHECKMARKS
		    HBITMAP  hbmpUnchecked; // used if MIIM_CHECKMARKS
		    ULONG_PTR dwItemData;   // used if MIIM_DATA
			LPSTR    dwTypeData;    // used if MIIM_TYPE (4.0) or MIIM_STRING (>4.0)
		    UINT     cch;           // used if MIIM_TYPE (4.0) or MIIM_STRING (>4.0)
		    HBITMAP  hbmpItem;      // used if MIIM_BITMAP
		}

		alias MENUITEMINFOA  *LPMENUITEMINFOA;
		struct MENUITEMINFOW {
		    UINT     cbSize;
		    UINT     fMask;
		    UINT     fType;         // used if MIIM_TYPE (4.0) or MIIM_FTYPE (>4.0)
		    UINT     fState;        // used if MIIM_STATE
		    UINT     wID;           // used if MIIM_ID
		    HMENU    hSubMenu;      // used if MIIM_SUBMENU
		    HBITMAP  hbmpChecked;   // used if MIIM_CHECKMARKS
		    HBITMAP  hbmpUnchecked; // used if MIIM_CHECKMARKS
		    ULONG_PTR dwItemData;   // used if MIIM_DATA
		    LPWSTR   dwTypeData;    // used if MIIM_TYPE (4.0) or MIIM_STRING (>4.0)
		    UINT     cch;           // used if MIIM_TYPE (4.0) or MIIM_STRING (>4.0)
		    HBITMAP  hbmpItem;      // used if MIIM_BITMAP
		}

		alias MENUITEMINFOW  *LPMENUITEMINFOW;

		version(UNICODE) {
			alias MENUITEMINFOW MENUITEMINFO;
			alias LPMENUITEMINFOW LPMENUITEMINFO;
		}
		else {
			alias MENUITEMINFOA MENUITEMINFO;
			alias LPMENUITEMINFOA LPMENUITEMINFO;
		}
		alias MENUITEMINFOA *LPCMENUITEMINFOA;
		alias MENUITEMINFOW *LPCMENUITEMINFOW;
		
		version(UNICODE) {
			alias LPCMENUITEMINFOW LPCMENUITEMINFO;
		}
		else {
			alias LPCMENUITEMINFOA LPCMENUITEMINFO;
		}
		
		BOOL InsertMenuItemA(
		     HMENU hmenu,
		     UINT item,
		     BOOL fByPosition,
		     LPCMENUITEMINFOA lpmi);
		BOOL InsertMenuItemW(
		     HMENU hmenu,
		     UINT item,
		     BOOL fByPosition,
		     LPCMENUITEMINFOW lpmi);
		
		version(UNICODE) {
			alias InsertMenuItemW InsertMenuItem;
		}
		else {
			alias InsertMenuItemA InsertMenuItem;
		}
		
		BOOL GetMenuItemInfoA(
		     HMENU hmenu,
		     UINT item,
		     BOOL fByPosition,
		     LPMENUITEMINFOA lpmii);
		BOOL GetMenuItemInfoW(
		     HMENU hmenu,
		     UINT item,
		     BOOL fByPosition,
		     LPMENUITEMINFOW lpmii);
		
		version(UNICODE) {
			alias GetMenuItemInfoW GetMenuItemInfo;
		}
		else {
			alias GetMenuItemInfoA GetMenuItemInfo;
		}
		
		BOOL SetMenuItemInfoA(
		     HMENU hmenu,
		     UINT item,
		     BOOL fByPositon,
		     LPCMENUITEMINFOA lpmii);
		BOOL SetMenuItemInfoW(
		     HMENU hmenu,
		     UINT item,
		     BOOL fByPositon,
		     LPCMENUITEMINFOW lpmii);
		
		version(UNICODE) {
			alias SetMenuItemInfoW SetMenuItemInfo;
		}
		else {
			alias SetMenuItemInfoA SetMenuItemInfo;
		}
		
		const auto GMDI_USEDISABLED     = 0x0001;
		const auto GMDI_GOINTOPOPUPS    = 0x0002;
		
		UINT GetMenuDefaultItem(
		     HMENU hMenu,
		     UINT fByPos,
		     UINT gmdiFlags);
		
		BOOL SetMenuDefaultItem(
		     HMENU hMenu,
		     UINT uItem,
		     UINT fByPos);
		
		BOOL GetMenuItemRect(
		     HWND hWnd,
		     HMENU hMenu,
		     UINT uItem,
		     LPRECT lprcItem);
		
		int MenuItemFromPoint(
		     HWND hWnd,
		     HMENU hMenu,
		     POINT ptScreen);
		
		/*
		 * Flags for TrackPopupMenu
		 */
		const auto TPM_LEFTBUTTON   = 0x0000;
		const auto TPM_RIGHTBUTTON  = 0x0002;
		const auto TPM_LEFTALIGN    = 0x0000;
		const auto TPM_CENTERALIGN  = 0x0004;
		const auto TPM_RIGHTALIGN   = 0x0008;
		
		const auto TPM_TOPALIGN         = 0x0000;
		const auto TPM_VCENTERALIGN     = 0x0010;
		const auto TPM_BOTTOMALIGN      = 0x0020;
		
		const auto TPM_HORIZONTAL       = 0x0000L     /* Horz alignment matters more */;
		const auto TPM_VERTICAL         = 0x0040L     /* Vert alignment matters more */;
		const auto TPM_NONOTIFY         = 0x0080L     /* Don't send any notification msgs */;
		const auto TPM_RETURNCMD        = 0x0100;
		
		const auto TPM_RECURSE          = 0x0001;
		const auto TPM_HORPOSANIMATION  = 0x0400;
		const auto TPM_HORNEGANIMATION  = 0x0800;
		const auto TPM_VERPOSANIMATION  = 0x1000;
		const auto TPM_VERNEGANIMATION  = 0x2000;
		
		const auto TPM_NOANIMATION      = 0x4000;
		
		const auto TPM_LAYOUTRTL        = 0x8000;
	}
	
	//
	// Drag-and-drop support
	// Obsolete - use OLE instead
	//
	struct DROPSTRUCT {
	    HWND    hwndSource;
	    HWND    hwndSink;
	    DWORD   wFmt;
	    ULONG_PTR dwData;
	    POINT   ptDrop;
	    DWORD   dwControlData;
	}
	
	alias DROPSTRUCT* PDROPSTRUCT;
	alias DROPSTRUCT* LPDROPSTRUCT;
	
	const auto DOF_EXECUTABLE       = 0x8001      ; // wFmt flags
	const auto DOF_DOCUMENT         = 0x8002;
	const auto DOF_DIRECTORY        = 0x8003;
	const auto DOF_MULTIPLE         = 0x8004;
	const auto DOF_PROGMAN          = 0x0001;
	const auto DOF_SHELLDATA        = 0x0002;
	
	const auto DO_DROPFILE          = 0x454C4946;
	const auto DO_PRINTFILE         = 0x544E5250;
	
	DWORD DragObject(
	     HWND hwndParent,
	     HWND hwndFrom,
	     UINT fmt,
	     ULONG_PTR data,
	     HCURSOR hcur);
	
	BOOL DragDetect(
	     HWND hwnd,
	     POINT pt);
	
	BOOL DrawIcon(
	     HDC hDC,
	     int X,
	     int Y,
	     HICON hIcon);
	
	version(NODRAWTEXT) {
	}
	else {
		/*
		 * DrawText() Format Flags
		 */
		const auto DT_TOP                       = 0x00000000;
		const auto DT_LEFT                      = 0x00000000;
		const auto DT_CENTER                    = 0x00000001;
		const auto DT_RIGHT                     = 0x00000002;
		const auto DT_VCENTER                   = 0x00000004;
		const auto DT_BOTTOM                    = 0x00000008;
		const auto DT_WORDBREAK                 = 0x00000010;
		const auto DT_SINGLELINE                = 0x00000020;
		const auto DT_EXPANDTABS                = 0x00000040;
		const auto DT_TABSTOP                   = 0x00000080;
		const auto DT_NOCLIP                    = 0x00000100;
		const auto DT_EXTERNALLEADING           = 0x00000200;
		const auto DT_CALCRECT                  = 0x00000400;
		const auto DT_NOPREFIX                  = 0x00000800;
		const auto DT_INTERNAL                  = 0x00001000;
		
		const auto DT_EDITCONTROL               = 0x00002000;
		const auto DT_PATH_ELLIPSIS             = 0x00004000;
		const auto DT_END_ELLIPSIS              = 0x00008000;
		const auto DT_MODIFYSTRING              = 0x00010000;
		const auto DT_RTLREADING                = 0x00020000;
		const auto DT_WORD_ELLIPSIS             = 0x00040000;
		
		const auto DT_NOFULLWIDTHCHARBREAK      = 0x00080000;
		
		const auto DT_HIDEPREFIX                = 0x00100000;
		const auto DT_PREFIXONLY                = 0x00200000;
		
		struct DRAWTEXTPARAMS {
		    UINT    cbSize;
		    int     iTabLength;
		    int     iLeftMargin;
		    int     iRightMargin;
		    UINT    uiLengthDrawn;
		}
		
		alias DRAWTEXTPARAMS  *LPDRAWTEXTPARAMS;

		int DrawTextA(
		     HDC hdc,
			 LPCSTR lpchText,
		     int cchText,
		     LPRECT lprc,
		     UINT format);
		
		int DrawTextW(
		     HDC hdc,
			 LPCWSTR lpchText,
		     int cchText,
		     LPRECT lprc,
		     UINT format);
		
		version(UNICODE) {
			alias DrawTextW DrawText;
		}
		else {
			alias DrawTextA DrawText;
		}
		
		int DrawTextExA(
		     HDC hdc,
			 LPSTR lpchText,
		     int cchText,
		     LPRECT lprc,
		     UINT format,
		     LPDRAWTEXTPARAMS lpdtp);
		
		int DrawTextExW(
		     HDC hdc,
			 LPWSTR lpchText,
		     int cchText,
		     LPRECT lprc,
		     UINT format,
		     LPDRAWTEXTPARAMS lpdtp);
		
		version(UNICODE) {
			alias DrawTextExW DrawTextEx;
		}
		else {
			alias DrawTextExA DrawTextEx;
		}
	}
	
	BOOL GrayStringA(
	     HDC hDC,
	     HBRUSH hBrush,
	     GRAYSTRINGPROC lpOutputFunc,
	     LPARAM lpData,
	     int nCount,
	     int X,
	     int Y,
	     int nWidth,
	     int nHeight);
	
	BOOL GrayStringW(
	     HDC hDC,
	     HBRUSH hBrush,
	     GRAYSTRINGPROC lpOutputFunc,
	     LPARAM lpData,
	     int nCount,
	     int X,
	     int Y,
	     int nWidth,
	     int nHeight);
	
	version(UNICODE) {
		alias GrayStringW GrayString;
	}
	else {
		alias GrayStringA GrayString;
	}
	
	/* Monolithic state-drawing routine */
	/* Image type */
	const auto DST_COMPLEX      = 0x0000;
	const auto DST_TEXT         = 0x0001;
	const auto DST_PREFIXTEXT   = 0x0002;
	const auto DST_ICON         = 0x0003;
	const auto DST_BITMAP       = 0x0004;
	
	/* State type */
	const auto DSS_NORMAL       = 0x0000;
	const auto DSS_UNION        = 0x0010  /* Gray string appearance */;
	const auto DSS_DISABLED     = 0x0020;
	const auto DSS_MONO         = 0x0080;
	
	const auto DSS_HIDEPREFIX   = 0x0200;
	const auto DSS_PREFIXONLY   = 0x0400;
	
	const auto DSS_RIGHT        = 0x8000;
	
	BOOL DrawStateA(
	     HDC hdc,
	     HBRUSH hbrFore,
	     DRAWSTATEPROC qfnCallBack,
	     LPARAM lData,
	     WPARAM wData,
	     int x,
	     int y,
	     int cx,
	     int cy,
	     UINT uFlags);
	
	BOOL DrawStateW(
	     HDC hdc,
	     HBRUSH hbrFore,
	     DRAWSTATEPROC qfnCallBack,
	     LPARAM lData,
	     WPARAM wData,
	     int x,
	     int y,
	     int cx,
	     int cy,
	     UINT uFlags);
	
	version(UNICODE) {
		alias DrawStateW DrawState;
	}
	else {
		alias DrawStateA DrawState;
	}
	
	LONG TabbedTextOutA(
	     HDC hdc,
	     int x,
	     int y,
		 LPCSTR lpString,
	     int chCount,
	     int nTabPositions,
		 INT *lpnTabStopPositions,
	     int nTabOrigin);
	
	LONG TabbedTextOutW(
	     HDC hdc,
	     int x,
	     int y,
		 LPCWSTR lpString,
	     int chCount,
	     int nTabPositions,
		 INT *lpnTabStopPositions,
	     int nTabOrigin);

	version(UNICODE) {
		alias TabbedTextOutW TabbedTextOut;
	}
	else {
		alias TabbedTextOutA TabbedTextOut;
	}
	
	DWORD GetTabbedTextExtentA(
	     HDC hdc,
		 LPCSTR lpString,
	     int chCount,
	     int nTabPositions,
		 INT *lpnTabStopPositions);
	
	DWORD GetTabbedTextExtentW(
	     HDC hdc,
		 LPCWSTR lpString,
	     int chCount,
	     int nTabPositions,
		 INT *lpnTabStopPositions);
	
	version(UNICODE) {
		alias GetTabbedTextExtentW GetTabbedTextExtent;
	}
	else {
		alias GetTabbedTextExtentA GetTabbedTextExtent;
	}
	
	BOOL UpdateWindow(
	     HWND hWnd);
	
	HWND SetActiveWindow(
	     HWND hWnd);
	
	HWND GetForegroundWindow();
	
	BOOL PaintDesktop(
	     HDC hdc);
	
	VOID SwitchToThisWindow(
	     HWND hwnd,
	     BOOL fUnknown);
	
	BOOL SetForegroundWindow(
	     HWND hWnd);
	
	BOOL AllowSetForegroundWindow(
	     DWORD dwProcessId);
	
	const auto ASFW_ANY     = (cast(DWORD)-1);
	
	BOOL LockSetForegroundWindow(
	     UINT uLockCode);
	
	const auto LSFW_LOCK        = 1;
	const auto LSFW_UNLOCK      = 2;
	
	HWND WindowFromDC(
	     HDC hDC);
	
	HDC GetDC(
	     HWND hWnd);
	
	HDC GetDCEx(
	     HWND hWnd,
	     HRGN hrgnClip,
	     DWORD flags);
	
	/*
	 * GetDCEx() flags
	 */
	const auto DCX_WINDOW            = 0x00000001;
	const auto DCX_CACHE             = 0x00000002;
	const auto DCX_NORESETATTRS      = 0x00000004;
	const auto DCX_CLIPCHILDREN      = 0x00000008;
	const auto DCX_CLIPSIBLINGS      = 0x00000010;
	const auto DCX_PARENTCLIP        = 0x00000020;
	const auto DCX_EXCLUDERGN        = 0x00000040;
	const auto DCX_INTERSECTRGN      = 0x00000080;
	const auto DCX_EXCLUDEUPDATE     = 0x00000100;
	const auto DCX_INTERSECTUPDATE   = 0x00000200;
	const auto DCX_LOCKWINDOWUPDATE  = 0x00000400;
	
	const auto DCX_VALIDATE          = 0x00200000;
	
	const auto MONITORS_MAX     = 10;
	
	HDC GetWindowDC(
	     HWND hWnd);
	
	int ReleaseDC(
	     HWND hWnd,
	     HDC hDC);
	
	HDC BeginPaint(
	     HWND hWnd,
	     LPPAINTSTRUCT lpPaint);
	
	BOOL EndPaint(
	     HWND hWnd,
	     PAINTSTRUCT *lpPaint);
	
	BOOL GetUpdateRect(
	     HWND hWnd,
	     LPRECT lpRect,
	     BOOL bErase);
	
	int GetUpdateRgn(
	     HWND hWnd,
	     HRGN hRgn,
	     BOOL bErase);
	
	int SetWindowRgn(
	     HWND hWnd,
	     HRGN hRgn,
	     BOOL bRedraw);
	
	
	int GetWindowRgn(
	     HWND hWnd,
	     HRGN hRgn);
	
	int GetWindowRgnBox(
	     HWND hWnd,
	     LPRECT lprc);
	
	int ExcludeUpdateRgn(
	     HDC hDC,
	     HWND hWnd);
	
	BOOL InvalidateRect(
	     HWND hWnd,
	     RECT *lpRect,
	     BOOL bErase);
	
	BOOL ValidateRect(
	     HWND hWnd,
	     RECT *lpRect);
	
	BOOL InvalidateRgn(
	     HWND hWnd,
	     HRGN hRgn,
	     BOOL bErase);

	BOOL ValidateRgn(
	     HWND hWnd,
	     HRGN hRgn);
	
	
	BOOL RedrawWindow(
	     HWND hWnd,
	     RECT *lprcUpdate,
	     HRGN hrgnUpdate,
	     UINT flags);
	
	/*
	 * RedrawWindow() flags
	 */
	const auto RDW_INVALIDATE           = 0x0001;
	const auto RDW_INTERNALPAINT        = 0x0002;
	const auto RDW_ERASE                = 0x0004;
	
	const auto RDW_VALIDATE             = 0x0008;
	const auto RDW_NOINTERNALPAINT      = 0x0010;
	const auto RDW_NOERASE              = 0x0020;
	
	const auto RDW_NOCHILDREN           = 0x0040;
	const auto RDW_ALLCHILDREN          = 0x0080;
	
	const auto RDW_UPDATENOW            = 0x0100;
	const auto RDW_ERASENOW             = 0x0200;
	
	const auto RDW_FRAME                = 0x0400;
	const auto RDW_NOFRAME              = 0x0800;
	
	
	/*
	 * LockWindowUpdate API
	 */
	
	BOOL LockWindowUpdate(
	     HWND hWndLock);
	
	BOOL ScrollWindow(
	     HWND hWnd,
	     int XAmount,
	     int YAmount,
	     RECT *lpRect,
	     RECT *lpClipRect);
	
	BOOL ScrollDC(
	     HDC hDC,
	     int dx,
	     int dy,
	     RECT *lprcScroll,
	     RECT *lprcClip,
	     HRGN hrgnUpdate,
	     LPRECT lprcUpdate);
	
	int ScrollWindowEx(
	     HWND hWnd,
	     int dx,
	     int dy,
	     RECT *prcScroll,
	     RECT *prcClip,
	     HRGN hrgnUpdate,
	     LPRECT prcUpdate,
	     UINT flags);
	
	const auto SW_SCROLLCHILDREN    = 0x0001  /* Scroll children within *lprcScroll. */;
	const auto SW_INVALIDATE        = 0x0002  /* Invalidate after scrolling */;
	const auto SW_ERASE             = 0x0004  /* If SW_INVALIDATE, don't send WM_ERASEBACKGROUND */;
	
	const auto SW_SMOOTHSCROLL      = 0x0010  /* Use smooth scrolling */;
	
	version(NOSCROLL) {
	}
	else {
		int SetScrollPos(
		     HWND hWnd,
		     int nBar,
		     int nPos,
		     BOOL bRedraw);
		
		int GetScrollPos(
		     HWND hWnd,
		     int nBar);
		
		BOOL SetScrollRange(
		     HWND hWnd,
		     int nBar,
		     int nMinPos,
		     int nMaxPos,
		     BOOL bRedraw);
	
		BOOL GetScrollRange(
		     HWND hWnd,
		     int nBar,
		     LPINT lpMinPos,
		     LPINT lpMaxPos);
	
		BOOL ShowScrollBar(
		     HWND hWnd,
		     int wBar,
		     BOOL bShow);
	
		BOOL EnableScrollBar(
		     HWND hWnd,
		     UINT wSBflags,
		     UINT wArrows);
	
		/*
		 * EnableScrollBar() flags
		 */
		const auto ESB_ENABLE_BOTH      = 0x0000;
		const auto ESB_DISABLE_BOTH     = 0x0003;
	
		const auto ESB_DISABLE_LEFT     = 0x0001;
		const auto ESB_DISABLE_RIGHT    = 0x0002;
	
		const auto ESB_DISABLE_UP       = 0x0001;
		const auto ESB_DISABLE_DOWN     = 0x0002;
	
		const auto ESB_DISABLE_LTUP     = ESB_DISABLE_LEFT;
		const auto ESB_DISABLE_RTDN     = ESB_DISABLE_RIGHT;
	}
	
	BOOL SetPropA(
	     HWND hWnd,
	     LPCSTR lpString,
	     HANDLE hData);
	
	BOOL SetPropW(
	     HWND hWnd,
	     LPCWSTR lpString,
	     HANDLE hData);
	
	version(UNICODE) {
		alias SetPropW SetProp;
	}
	else {
		alias SetPropA SetProp;
	}
	
	HANDLE GetPropA(
	     HWND hWnd,
	     LPCSTR lpString);
	HANDLE GetPropW(
	     HWND hWnd,
	     LPCWSTR lpString);
	
	version(UNICODE) {
		alias GetPropW GetProp;
	}
	else {
		alias GetPropA GetProp;
	}
	
	HANDLE RemovePropA(
	     HWND hWnd,
	     LPCSTR lpString);
	
	HANDLE RemovePropW(
	     HWND hWnd,
	     LPCWSTR lpString);
	
	version(UNICODE) {
		alias RemovePropW RemoveProp;
	}
	else {
		alias RemovePropA RemoveProp;
	}
	
	int EnumPropsExA(
	     HWND hWnd,
	     PROPENUMPROCEXA lpEnumFunc,
	     LPARAM lParam);
	
	int EnumPropsExW(
	     HWND hWnd,
	     PROPENUMPROCEXW lpEnumFunc,
	     LPARAM lParam);
	
	version(UNICODE) {
		alias EnumPropsExW EnumPropsEx;
	}
	else {
		alias EnumPropsExA EnumPropsEx;
	}
	
	int EnumPropsA(
	     HWND hWnd,
	     PROPENUMPROCA lpEnumFunc);
	
	int EnumPropsW(
	     HWND hWnd,
	     PROPENUMPROCW lpEnumFunc);
	
	version(UNICODE) {
		alias EnumPropsW EnumProps;
	}
	else {
		alias EnumPropsA EnumProps;
	}
	
	BOOL SetWindowTextA(
	     HWND hWnd,
	     LPCSTR lpString);
	BOOL SetWindowTextW(
	     HWND hWnd,
	     LPCWSTR lpString);
	
	version(UNICODE) {
		alias SetWindowTextW SetWindowText;
	}
	else {
		alias SetWindowTextA SetWindowText;
	}
	
	int GetWindowTextA(
	     HWND hWnd,
		 LPSTR lpString,
	     int nMaxCount);
	
	int GetWindowTextW(
	     HWND hWnd,
		 LPWSTR lpString,
	     int nMaxCount);
	
	version(UNICODE) {
		alias GetWindowTextW GetWindowText;
	}
	else {
		alias GetWindowTextA GetWindowText;
	}
	
	int GetWindowTextLengthA(
	     HWND hWnd);
	
	int GetWindowTextLengthW(
	     HWND hWnd);
	
	version(UNICODE) {
		alias GetWindowTextLengthW GetWindowTextLength;
	}
	else {
		alias GetWindowTextLengthA GetWindowTextLength;
	}
	
	BOOL GetClientRect(
	     HWND hWnd,
	     LPRECT lpRect);
	
	BOOL GetWindowRect(
	     HWND hWnd,
	     LPRECT lpRect);
	
	BOOL AdjustWindowRect(
	     LPRECT lpRect,
	     DWORD dwStyle,
	     BOOL bMenu);
	
	BOOL AdjustWindowRectEx(
	     LPRECT lpRect,
	     DWORD dwStyle,
	     BOOL bMenu,
	     DWORD dwExStyle);
	
	const auto HELPINFO_WINDOW     = 0x0001;
	const auto HELPINFO_MENUITEM   = 0x0002;
	
	struct HELPINFO {
	    UINT    cbSize;             /* Size in bytes of this struct  */
	    int     iContextType;       /* Either HELPINFO_WINDOW or HELPINFO_MENUITEM */
	    int     iCtrlId;            /* Control Id or a Menu item Id. */
	    HANDLE  hItemHandle;        /* hWnd of control or hMenu.     */
	    DWORD_PTR dwContextId;      /* Context Id associated with this item */
	    POINT   MousePos;           /* Mouse Position in screen co-ordinates */
	}
	
	alias HELPINFO  *LPHELPINFO;
	
	BOOL SetWindowContextHelpId(
	     HWND,
	     DWORD);
	
	DWORD GetWindowContextHelpId(
	     HWND);
	
	BOOL SetMenuContextHelpId(
	     HMENU,
	     DWORD);
	
	DWORD GetMenuContextHelpId(
	     HMENU);
	
	version(NOMB) {
	}
	else {
		/*
		 * MessageBox() Flags
		 */
		const auto MB_OK                        = 0x00000000;
		const auto MB_OKCANCEL                  = 0x00000001;
		const auto MB_ABORTRETRYIGNORE          = 0x00000002;
		const auto MB_YESNOCANCEL               = 0x00000003;
		const auto MB_YESNO                     = 0x00000004;
		const auto MB_RETRYCANCEL               = 0x00000005;
		
		const auto MB_CANCELTRYCONTINUE         = 0x00000006;
		
		const auto MB_ICONHAND                  = 0x00000010;
		const auto MB_ICONQUESTION              = 0x00000020;
		const auto MB_ICONEXCLAMATION           = 0x00000030;
		const auto MB_ICONASTERISK              = 0x00000040;
		
		const auto MB_USERICON                  = 0x00000080;
		const auto MB_ICONWARNING               = MB_ICONEXCLAMATION;
		const auto MB_ICONERROR                 = MB_ICONHAND;
		
		const auto MB_ICONINFORMATION           = MB_ICONASTERISK;
		const auto MB_ICONSTOP                  = MB_ICONHAND;
		
		const auto MB_DEFBUTTON1                = 0x00000000;
		const auto MB_DEFBUTTON2                = 0x00000100;
		const auto MB_DEFBUTTON3                = 0x00000200;
		
		const auto MB_DEFBUTTON4                = 0x00000300;
		
		const auto MB_APPLMODAL                 = 0x00000000;
		const auto MB_SYSTEMMODAL               = 0x00001000;
		const auto MB_TASKMODAL                 = 0x00002000;
		
		const auto MB_HELP                      = 0x00004000L ; // Help Button
		
		const auto MB_NOFOCUS                   = 0x00008000;
		const auto MB_SETFOREGROUND             = 0x00010000;
		const auto MB_DEFAULT_DESKTOP_ONLY      = 0x00020000;
		
		const auto MB_TOPMOST                   = 0x00040000;
		const auto MB_RIGHT                     = 0x00080000;
		const auto MB_RTLREADING                = 0x00100000;
		
		const auto MB_SERVICE_NOTIFICATION           = 0x00200000;
		const auto MB_SERVICE_NOTIFICATION_NT3X      = 0x00040000;
		
		const auto MB_TYPEMASK                  = 0x0000000F;
		const auto MB_ICONMASK                  = 0x000000F0;
		const auto MB_DEFMASK                   = 0x00000F00;
		const auto MB_MODEMASK                  = 0x00003000;
		const auto MB_MISCMASK                  = 0x0000C000;
		
		int MessageBoxA(
		     HWND hWnd,
		     LPCSTR lpText,
		     LPCSTR lpCaption,
		     UINT uType);
		
		int MessageBoxW(
		     HWND hWnd,
		     LPCWSTR lpText,
		     LPCWSTR lpCaption,
		     UINT uType);
		
		version(UNICODE) {
			alias MessageBoxW MessageBox;
		}
		else {
			alias MessageBoxA MessageBox;
		}
		
		int MessageBoxExA(
		     HWND hWnd,
		     LPCSTR lpText,
		     LPCSTR lpCaption,
		     UINT uType,
		     WORD wLanguageId);
		int MessageBoxExW(
		     HWND hWnd,
		     LPCWSTR lpText,
		     LPCWSTR lpCaption,
		     UINT uType,
		     WORD wLanguageId);
		
		version(UNICODE) {
			alias MessageBoxExW MessageBoxEx;
		}
		else {
			alias MessageBoxExA MessageBoxEx;
		}
		
		alias VOID function(LPHELPINFO lpHelpInfo) MSGBOXCALLBACK;
		
		struct MSGBOXPARAMSA {
		    UINT        cbSize;
		    HWND        hwndOwner;
		    HINSTANCE   hInstance;
		    LPCSTR      lpszText;
		    LPCSTR      lpszCaption;
		    DWORD       dwStyle;
		    LPCSTR      lpszIcon;
		    DWORD_PTR   dwContextHelpId;
		    MSGBOXCALLBACK      lpfnMsgBoxCallback;
		    DWORD       dwLanguageId;
		}
		
		alias MSGBOXPARAMSA* PMSGBOXPARAMSA;
		alias MSGBOXPARAMSA* LPMSGBOXPARAMSA;
		
		struct MSGBOXPARAMSW {
		    UINT        cbSize;
		    HWND        hwndOwner;
		    HINSTANCE   hInstance;
		    LPCWSTR     lpszText;
		    LPCWSTR     lpszCaption;
		    DWORD       dwStyle;
		    LPCWSTR     lpszIcon;
		    DWORD_PTR   dwContextHelpId;
		    MSGBOXCALLBACK      lpfnMsgBoxCallback;
		    DWORD       dwLanguageId;
		}
		
		alias MSGBOXPARAMSW* PMSGBOXPARAMSW;
		alias MSGBOXPARAMSW* LPMSGBOXPARAMSW;
		
		version(UNICODE) {
			alias MSGBOXPARAMSW MSGBOXPARAMS;
			alias PMSGBOXPARAMSW PMSGBOXPARAMS;
			alias LPMSGBOXPARAMSW LPMSGBOXPARAMS;
		}
		else {
			alias MSGBOXPARAMSA MSGBOXPARAMS;
			alias PMSGBOXPARAMSA PMSGBOXPARAMS;
			alias LPMSGBOXPARAMSA LPMSGBOXPARAMS;
		}

		int MessageBoxIndirectA(
		     MSGBOXPARAMSA * lpmbp);
		
		int MessageBoxIndirectW(
		     MSGBOXPARAMSW * lpmbp);
		
		version(UNICODE) {
			alias MessageBoxIndirectW MessageBoxIndirect;
		}
		else {
			alias MessageBoxIndirectA MessageBoxIndirect;
		}
		
		BOOL MessageBeep(
		     UINT uType);
	}
	
	int ShowCursor(
	     BOOL bShow);
	
	BOOL SetCursorPos(
	     int X,
	     int Y);
	
	
	BOOL SetPhysicalCursorPos(
	     int X,
	     int Y);
	
	HCURSOR SetCursor(
	     HCURSOR hCursor);
	
	BOOL GetCursorPos(
	     LPPOINT lpPoint);
	
	BOOL GetPhysicalCursorPos(
	     LPPOINT lpPoint);
	
	BOOL ClipCursor(
	     RECT *lpRect);
	
	BOOL GetClipCursor(
	     LPRECT lpRect);
	
	HCURSOR GetCursor();
	
	BOOL CreateCaret(
	     HWND hWnd,
	     HBITMAP hBitmap,
	     int nWidth,
	     int nHeight);
	
	UINT GetCaretBlinkTime();
	
	BOOL SetCaretBlinkTime(
	     UINT uMSeconds);
	
	BOOL DestroyCaret();
	
	BOOL HideCaret(
	     HWND hWnd);
	
	BOOL ShowCaret(
	     HWND hWnd);
	
	BOOL SetCaretPos(
	     int X,
	     int Y);
	
	BOOL GetCaretPos(
	     LPPOINT lpPoint);
	
	BOOL ClientToScreen(
	     HWND hWnd,
	     LPPOINT lpPoint);
	
	BOOL ScreenToClient(
	     HWND hWnd,
	     LPPOINT lpPoint);
	
	BOOL LogicalToPhysicalPoint(
	     HWND hWnd,
	     LPPOINT lpPoint);
	
	BOOL PhysicalToLogicalPoint(
	     HWND hWnd,
	     LPPOINT lpPoint);
	
	int MapWindowPoints(
	     HWND hWndFrom,
	     HWND hWndTo,
		 LPPOINT lpPoints,
	     UINT cPoints);
	
	HWND WindowFromPoint(
	     POINT Point);
	
	HWND WindowFromPhysicalPoint(
	     POINT Point);
	
	HWND ChildWindowFromPoint(
	     HWND hWndParent,
	     POINT Point);
	
	const auto CWP_ALL              = 0x0000;
	const auto CWP_SKIPINVISIBLE    = 0x0001;
	const auto CWP_SKIPDISABLED     = 0x0002;
	const auto CWP_SKIPTRANSPARENT  = 0x0004;
	
	HWND ChildWindowFromPointEx(
	     HWND hwnd,
	     POINT pt,
	     UINT flags);
	
	version(NOCOLOR) {
	}
	else {
		/*
		 * Color Types
		 */
		const auto CTLCOLOR_MSGBOX          = 0;
		const auto CTLCOLOR_EDIT            = 1;
		const auto CTLCOLOR_LISTBOX         = 2;
		const auto CTLCOLOR_BTN             = 3;
		const auto CTLCOLOR_DLG             = 4;
		const auto CTLCOLOR_SCROLLBAR       = 5;
		const auto CTLCOLOR_STATIC          = 6;
		const auto CTLCOLOR_MAX             = 7;
		
		const auto COLOR_SCROLLBAR          = 0;
		const auto COLOR_BACKGROUND         = 1;
		const auto COLOR_ACTIVECAPTION      = 2;
		const auto COLOR_INACTIVECAPTION    = 3;
		const auto COLOR_MENU               = 4;
		const auto COLOR_WINDOW             = 5;
		const auto COLOR_WINDOWFRAME        = 6;
		const auto COLOR_MENUTEXT           = 7;
		const auto COLOR_WINDOWTEXT         = 8;
		const auto COLOR_CAPTIONTEXT        = 9;
		const auto COLOR_ACTIVEBORDER       = 10;
		const auto COLOR_INACTIVEBORDER     = 11;
		const auto COLOR_APPWORKSPACE       = 12;
		const auto COLOR_HIGHLIGHT          = 13;
		const auto COLOR_HIGHLIGHTTEXT      = 14;
		const auto COLOR_BTNFACE            = 15;
		const auto COLOR_BTNSHADOW          = 16;
		const auto COLOR_GRAYTEXT           = 17;
		const auto COLOR_BTNTEXT            = 18;
		const auto COLOR_INACTIVECAPTIONTEXT  = 19;
		const auto COLOR_BTNHIGHLIGHT       = 20;
		
		const auto COLOR_3DDKSHADOW         = 21;
		const auto COLOR_3DLIGHT            = 22;
		const auto COLOR_INFOTEXT           = 23;
		const auto COLOR_INFOBK             = 24;
		
		const auto COLOR_HOTLIGHT           = 26;
		const auto COLOR_GRADIENTACTIVECAPTION  = 27;
		const auto COLOR_GRADIENTINACTIVECAPTION  = 28;
		
		const auto COLOR_MENUHILIGHT        = 29;
		const auto COLOR_MENUBAR            = 30;
		
		const auto COLOR_DESKTOP            = COLOR_BACKGROUND;
		const auto COLOR_3DFACE             = COLOR_BTNFACE;
		const auto COLOR_3DSHADOW           = COLOR_BTNSHADOW;
		const auto COLOR_3DHIGHLIGHT        = COLOR_BTNHIGHLIGHT;
		const auto COLOR_3DHILIGHT          = COLOR_BTNHIGHLIGHT;
		const auto COLOR_BTNHILIGHT         = COLOR_BTNHIGHLIGHT;
		
		DWORD GetSysColor(
		     int nIndex);
	
		HBRUSH GetSysColorBrush(
		     int nIndex);
	
		BOOL SetSysColors(
		     int cElements,
			 INT * lpaElements,
			 COLORREF * lpaRgbValues);
	}
	
	BOOL DrawFocusRect(
	     HDC hDC,
	     RECT * lprc);
	
	int FillRect(
	     HDC hDC,
	     RECT *lprc,
	     HBRUSH hbr);
	
	int FrameRect(
	     HDC hDC,
	     RECT *lprc,
	     HBRUSH hbr);
	
	BOOL InvertRect(
	     HDC hDC,
	     RECT *lprc);
	
	BOOL SetRect(
	     LPRECT lprc,
	     int xLeft,
	     int yTop,
	     int xRight,
	     int yBottom);
	
	BOOL SetRectEmpty(
	     LPRECT lprc);
	
	BOOL CopyRect(
	     LPRECT lprcDst,
	     RECT *lprcSrc);
	
	BOOL InflateRect(
	     LPRECT lprc,
	     int dx,
	     int dy);
	
	BOOL IntersectRect(
	     LPRECT lprcDst,
	     RECT *lprcSrc1,
	     RECT *lprcSrc2);
	
	BOOL UnionRect(
	     LPRECT lprcDst,
	     RECT *lprcSrc1,
	     RECT *lprcSrc2);
	
	BOOL SubtractRect(
	     LPRECT lprcDst,
	     RECT *lprcSrc1,
	     RECT *lprcSrc2);
	
	BOOL OffsetRect(
	     LPRECT lprc,
	     int dx,
	     int dy);
	
	BOOL IsRectEmpty(
	     RECT *lprc);
	
	BOOL EqualRect(
	     RECT *lprc1,
	     RECT *lprc2);
	
	BOOL PtInRect(
	     RECT *lprc,
	     POINT pt);
	
	version(NOWINOFFSETS) {
	}
	else {
		WORD GetWindowWord(
		     HWND hWnd,
		     int nIndex);
		
		WORD SetWindowWord(
		     HWND hWnd,
		     int nIndex,
		     WORD wNewWord);
		
		LONG GetWindowLongA(
		     HWND hWnd,
		     int nIndex);
		
		LONG GetWindowLongW(
		     HWND hWnd,
		     int nIndex);
		
		version(UNICODE) {
			alias GetWindowLongW GetWindowLong;
		}
		else {
			alias GetWindowLongA GetWindowLong;
		}
		
		LONG SetWindowLongA(
		     HWND hWnd,
		     int nIndex,
		     LONG dwNewLong);
		
		LONG SetWindowLongW(
		     HWND hWnd,
		     int nIndex,
		     LONG dwNewLong);
		
		version(UNICODE) {
			alias SetWindowLongW SetWindowLong;
		}
		else {
			alias SetWindowLongA SetWindowLong;
		}
		
		version(X86_64) {
			LONG_PTR GetWindowLongPtrA(
			     HWND hWnd,
			     int nIndex);
			
			LONG_PTR GetWindowLongPtrW(
			     HWND hWnd,
			     int nIndex);
			
			version(UNICODE) {
				alias GetWindowLongPtrW GetWindowLongPtr;
			}
			else {
				alias GetWindowLongPtrA GetWindowLongPtr;
			}
			
			LONG_PTR SetWindowLongPtrA(
			     HWND hWnd,
			     int nIndex,
			     LONG_PTR dwNewLong);
			LONG_PTR SetWindowLongPtrW(
			     HWND hWnd,
			     int nIndex,
			     LONG_PTR dwNewLong);
		
			version(UNICODE) {
				alias SetWindowLongPtrW SetWindowLongPtr;
			}
			else {
				alias SetWindowLongPtrA SetWindowLongPtr;
			}
		}
		else {
			alias GetWindowLongA GetWindowLongPtrA;
			alias GetWindowLongW GetWindowLongPtrW;
		
			version(UNICODE) {
				alias GetWindowLongPtrW GetWindowLongPtr;
			}
			else {
				alias GetWindowLongPtrA GetWindowLongPtr;
			}
		
			alias SetWindowLongA SetWindowLongPtrA;
			alias SetWindowLongW SetWindowLongPtrW;
		
			version(UNICODE) {
				alias SetWindowLongPtrW SetWindowLongPtr;
			}
			else {
				alias SetWindowLongPtrA SetWindowLongPtr;
			}
		}
		
		WORD GetClassWord(
		     HWND hWnd,
		     int nIndex);
		
		WORD SetClassWord(
		     HWND hWnd,
		     int nIndex,
		     WORD wNewWord);
		
		DWORD GetClassLongA(
		     HWND hWnd,
		     int nIndex);
		
		DWORD GetClassLongW(
		     HWND hWnd,
		     int nIndex);
		
		version(UNICODE) {
			alias GetClassLongW GetClassLong;
		}
		else {
			alias GetClassLongA GetClassLong;
		}
		
		DWORD SetClassLongA(
		     HWND hWnd,
		     int nIndex,
		     LONG dwNewLong);
		
		DWORD SetClassLongW(
		     HWND hWnd,
		     int nIndex,
		     LONG dwNewLong);
		
		version(UNICODE) {
			alias SetClassLongW SetClassLong;
		}
		else {
			alias SetClassLongA SetClassLong;
		}
		
		version(X86_64) {
			ULONG_PTR GetClassLongPtrA(
			     HWND hWnd,
			     int nIndex);
			ULONG_PTR GetClassLongPtrW(
			     HWND hWnd,
			     int nIndex);
		
			version(UNICODE) {
				alias GetClassLongPtrW GetClassLongPtr;
			}
			else {
				alias GetClassLongPtrA GetClassLongPtr;
			}
		
			ULONG_PTR SetClassLongPtrA(
			     HWND hWnd,
			     int nIndex,
			     LONG_PTR dwNewLong);
		
			ULONG_PTR SetClassLongPtrW(
			     HWND hWnd,
			     int nIndex,
			     LONG_PTR dwNewLong);
		
			version(UNICODE) {
				alias SetClassLongPtrW SetClassLongPtr;
			}
			else {
				alias SetClassLongPtrA SetClassLongPtr;
			}
		}
		else {
			alias GetClassLongA GetClassLongPtrA;
			alias GetClassLongW GetClassLongPtrW;
		
			version(UNICODE) {
				alias GetClassLongPtrW GetClassLongPtr;
			}
			else {
				alias GetClassLongPtrA GetClassLongPtr;
			}

			alias SetClassLongA SetClassLongPtrA;
			alias SetClassLongW SetClassLongPtrW;
		
			version(UNICODE) {
				alias SetClassLongPtrW SetClassLongPtr;
			}
			else {
				alias SetClassLongPtrA SetClassLongPtr;
			}
		}
	}
	
	BOOL GetProcessDefaultLayout(
	     DWORD *pdwDefaultLayout);
	
	BOOL SetProcessDefaultLayout(
	     DWORD dwDefaultLayout);
	
	HWND GetDesktopWindow();
	
	HWND GetParent(
	     HWND hWnd);
	
	HWND SetParent(
	     HWND hWndChild,
	     HWND hWndNewParent);
	
	BOOL EnumChildWindows(
	     HWND hWndParent,
	     WNDENUMPROC lpEnumFunc,
	     LPARAM lParam);
	
	HWND FindWindowA(
	     LPCSTR lpClassName,
	     LPCSTR lpWindowName);
	
	HWND FindWindowW(
	     LPCWSTR lpClassName,
	     LPCWSTR lpWindowName);
	
	version(UNICODE) {
		alias FindWindowW FindWindow;
	}
	else {
		alias FindWindowA FindWindow;
	}
	
	HWND FindWindowExA(
	     HWND hWndParent,
	     HWND hWndChildAfter,
	     LPCSTR lpszClass,
	     LPCSTR lpszWindow);
	
	HWND FindWindowExW(
	     HWND hWndParent,
	     HWND hWndChildAfter,
	     LPCWSTR lpszClass,
	     LPCWSTR lpszWindow);
	
	version(UNICODE) {
		alias FindWindowExW FindWindowEx;
	}
	else {
		alias FindWindowExA FindWindowEx;
	}
	
	HWND GetShellWindow();
	
	BOOL RegisterShellHookWindow(
	     HWND hwnd);
	
	BOOL DeregisterShellHookWindow(
	     HWND hwnd);
	
	BOOL EnumWindows(
	     WNDENUMPROC lpEnumFunc,
	     LPARAM lParam);
	
	BOOL EnumThreadWindows(
	     DWORD dwThreadId,
	     WNDENUMPROC lpfn,
	     LPARAM lParam);
	
	alias EnumThreadWindows EnumTaskWindows;
	
	int GetClassNameA(
	     HWND hWnd,
		 LPSTR lpClassName,
	     int nMaxCount
	    );
	
	int GetClassNameW(
	     HWND hWnd,
		 LPWSTR lpClassName,
	     int nMaxCount
	    );
	
	version(UNICODE) {
		alias GetClassNameW GetClassName;
	}
	else {
		alias GetClassNameA GetClassName;
	}
	
	HWND GetTopWindow(
	     HWND hWnd);
	
	alias GetWindow GetNextWindow;
	
	HWND GetSysModalWindow() {
		return null;
	}
	
	HWND SetSysModalWindow(HWND hWnd) {
		return null;
	}
	
	DWORD GetWindowThreadProcessId(
	     HWND hWnd,
	     LPDWORD lpdwProcessId);
	
	BOOL IsGUIThread(
	     BOOL bConvert);
	
	HANDLE GetWindowTask(HWND hWnd) {
		return cast(HANDLE)GetWindowThreadProcessId(hWnd, null);
	}
	
	HWND GetLastActivePopup(
	     HWND hWnd);
	
	/*
	 * GetWindow() Constants
	 */
	const auto GW_HWNDFIRST         = 0;
	const auto GW_HWNDLAST          = 1;
	const auto GW_HWNDNEXT          = 2;
	const auto GW_HWNDPREV          = 3;
	const auto GW_OWNER             = 4;
	const auto GW_CHILD             = 5;

	const auto GW_ENABLEDPOPUP      = 6;
	const auto GW_MAX               = 6;

	HWND GetWindow(
	     HWND hWnd,
	     UINT uCmd);
	
	version(NOWH) {
	}
	else {
		HHOOK SetWindowsHookA(
		     int nFilterType,
		     HOOKPROC pfnFilterProc);
		
		HHOOK SetWindowsHookW(
		     int nFilterType,
		     HOOKPROC pfnFilterProc);
		
		version(UNICODE) {
			alias SetWindowsHookW SetWindowsHook;
		}
		else {
			alias SetWindowsHookA SetWindowsHook;
		}
		
		BOOL UnhookWindowsHook(
		     int nCode,
		     HOOKPROC pfnFilterProc);
		
		HHOOK SetWindowsHookExA(
		     int idHook,
		     HOOKPROC lpfn,
		     HINSTANCE hmod,
		     DWORD dwThreadId);
		
		HHOOK SetWindowsHookExW(
		     int idHook,
		     HOOKPROC lpfn,
		     HINSTANCE hmod,
		     DWORD dwThreadId);
		
		version(UNICODE) {
			alias SetWindowsHookExW SetWindowsHookEx;
		}
		else {
			alias SetWindowsHookExA SetWindowsHookEx;
		}
		
		BOOL UnhookWindowsHookEx(
		     HHOOK hhk);

		LRESULT CallNextHookEx(
		     HHOOK hhk,
		     int nCode,
		     WPARAM wParam,
		     LPARAM lParam);
		
		/*
		 * Macros for source-level compatibility with old functions.
		 */
		LRESULT DefHookProc(int nCode, WPARAM wParam, LPARAM lParam, HHOOK* phhk) {
			return CallNextHookEx(*phhk, nCode, wParam, lParam);
		}
	}
	
	version(NOMENUS) {
	}
	else {
		/* ;win40  -- A lot of MF_* flags have been renamed as MFT_* and MFS_* flags */
		/*
		 * Menu flags for Add/Check/EnableMenuItem()
		 */
		const auto MF_INSERT            = 0x00000000;
		const auto MF_CHANGE            = 0x00000080;
		const auto MF_APPEND            = 0x00000100;
		const auto MF_DELETE            = 0x00000200;
		const auto MF_REMOVE            = 0x00001000;
		
		const auto MF_BYCOMMAND         = 0x00000000;
		const auto MF_BYPOSITION        = 0x00000400;
		
		const auto MF_SEPARATOR         = 0x00000800;
		
		const auto MF_ENABLED           = 0x00000000;
		const auto MF_GRAYED            = 0x00000001;
		const auto MF_DISABLED          = 0x00000002;
		
		const auto MF_UNCHECKED         = 0x00000000;
		const auto MF_CHECKED           = 0x00000008;
		const auto MF_USECHECKBITMAPS   = 0x00000200;
		
		const auto MF_STRING            = 0x00000000;
		const auto MF_BITMAP            = 0x00000004;
		const auto MF_OWNERDRAW         = 0x00000100;
		
		const auto MF_POPUP             = 0x00000010;
		const auto MF_MENUBARBREAK      = 0x00000020;
		const auto MF_MENUBREAK         = 0x00000040;

		const auto MF_UNHILITE          = 0x00000000;
		const auto MF_HILITE            = 0x00000080;
		
		const auto MF_DEFAULT           = 0x00001000;
		
		const auto MF_SYSMENU           = 0x00002000;
		const auto MF_HELP              = 0x00004000;
		
		const auto MF_RIGHTJUSTIFY      = 0x00004000;
		
		const auto MF_MOUSESELECT       = 0x00008000;
		
		const auto MF_END               = 0x00000080L  /* Obsolete -- only used by old RES files */;
		
		const auto MFT_STRING           = MF_STRING;
		const auto MFT_BITMAP           = MF_BITMAP;
		const auto MFT_MENUBARBREAK     = MF_MENUBARBREAK;
		const auto MFT_MENUBREAK        = MF_MENUBREAK;
		const auto MFT_OWNERDRAW        = MF_OWNERDRAW;
		const auto MFT_RADIOCHECK       = 0x00000200;
		const auto MFT_SEPARATOR        = MF_SEPARATOR;
		const auto MFT_RIGHTORDER       = 0x00002000;
		const auto MFT_RIGHTJUSTIFY     = MF_RIGHTJUSTIFY;
		
		/* Menu flags for Add/Check/EnableMenuItem() */
		const auto MFS_GRAYED           = 0x00000003;
		const auto MFS_DISABLED         = MFS_GRAYED;
		const auto MFS_CHECKED          = MF_CHECKED;
		const auto MFS_HILITE           = MF_HILITE;
		const auto MFS_ENABLED          = MF_ENABLED;
		const auto MFS_UNCHECKED        = MF_UNCHECKED;
		const auto MFS_UNHILITE         = MF_UNHILITE;
		const auto MFS_DEFAULT          = MF_DEFAULT;
		
		BOOL CheckMenuRadioItem(
		     HMENU hmenu,
		     UINT first,
		     UINT last,
		     UINT check,
		     UINT flags);
		
		/*
		 * Menu item resource format
		 */
		struct MENUITEMTEMPLATEHEADER {
		    WORD versionNumber;
		    WORD offset;
		}

		alias MENUITEMTEMPLATEHEADER* PMENUITEMTEMPLATEHEADER;

		struct MENUITEMTEMPLATE {        // version 0
		    WORD mtOption;
		    WORD mtID;
		    WCHAR mtString[1];
		}

		alias MENUITEMTEMPLATE* PMENUITEMTEMPLATE;
		//const auto MF_END              = 0x00000080;
	}
	
	version(NOSYSCOMMANDS) {
	}
	else {
		/*
		 * System Menu Command Values
		 */
		const auto SC_SIZE          = 0xF000;
		const auto SC_MOVE          = 0xF010;
		const auto SC_MINIMIZE      = 0xF020;
		const auto SC_MAXIMIZE      = 0xF030;
		const auto SC_NEXTWINDOW    = 0xF040;
		const auto SC_PREVWINDOW    = 0xF050;
		const auto SC_CLOSE         = 0xF060;
		const auto SC_VSCROLL       = 0xF070;
		const auto SC_HSCROLL       = 0xF080;
		const auto SC_MOUSEMENU     = 0xF090;
		const auto SC_KEYMENU       = 0xF100;
		const auto SC_ARRANGE       = 0xF110;
		const auto SC_RESTORE       = 0xF120;
		const auto SC_TASKLIST      = 0xF130;
		const auto SC_SCREENSAVE    = 0xF140;
		const auto SC_HOTKEY        = 0xF150;
		
		const auto SC_DEFAULT       = 0xF160;
		const auto SC_MONITORPOWER  = 0xF170;
		const auto SC_CONTEXTHELP   = 0xF180;
		const auto SC_SEPARATOR     = 0xF00F;
		
		const auto SCF_ISSECURE     = 0x00000001;
		
		/*
		 * Obsolete names
		 */
		const auto SC_ICON          = SC_MINIMIZE;
		const auto SC_ZOOM          = SC_MAXIMIZE;
	}
	
	/*
	 * Resource Loading Routines
	 */
	
	HBITMAP LoadBitmapA(
	     HINSTANCE hInstance,
	     LPCSTR lpBitmapName);
	
	HBITMAP LoadBitmapW(
	     HINSTANCE hInstance,
	     LPCWSTR lpBitmapName);
	
	version(UNICODE) {
		alias LoadBitmapW LoadBitmap;
	}
	else {
		alias LoadBitmapA LoadBitmap;
	}
	
	HCURSOR LoadCursorA(
	     HINSTANCE hInstance,
	     LPCSTR lpCursorName);
	
	HCURSOR LoadCursorW(
	     HINSTANCE hInstance,
	     LPCWSTR lpCursorName);
	
	version(UNICODE) {
		alias LoadCursorW LoadCursor;
	}
	else {
		alias LoadCursorA LoadCursor;
	}
	
	HCURSOR LoadCursorFromFileA(
	     LPCSTR lpFileName);
	
	HCURSOR LoadCursorFromFileW(
	     LPCWSTR lpFileName);
	
	version(UNICODE) {
		alias LoadCursorFromFileW LoadCursorFromFile;
	}
	else {
		alias LoadCursorFromFileA LoadCursorFromFile;
	}
	
	HCURSOR CreateCursor(
	     HINSTANCE hInst,
	     int xHotSpot,
	     int yHotSpot,
	     int nWidth,
	     int nHeight,
	     VOID *pvANDPlane,
	     VOID *pvXORPlane);
	
	BOOL DestroyCursor(
	     HCURSOR hCursor);
	
	HCURSOR CopyCursor(HCURSOR pcur) {
		return cast(HCURSOR)CopyIcon(cast(HICON)pcur);
	}
	
	/*
	 * Standard Cursor IDs
	 */
	const auto IDC_ARROW            = MAKEINTRESOURCE!(32512);
	const auto IDC_IBEAM            = MAKEINTRESOURCE!(32513);
	const auto IDC_WAIT             = MAKEINTRESOURCE!(32514);
	const auto IDC_CROSS            = MAKEINTRESOURCE!(32515);
	const auto IDC_UPARROW          = MAKEINTRESOURCE!(32516);
	const auto IDC_SIZE             = MAKEINTRESOURCE!(32640);  /* OBSOLETE: use IDC_SIZEALL */
	const auto IDC_ICON             = MAKEINTRESOURCE!(32641);  /* OBSOLETE: use IDC_ARROW */
	const auto IDC_SIZENWSE         = MAKEINTRESOURCE!(32642);
	const auto IDC_SIZENESW         = MAKEINTRESOURCE!(32643);
	const auto IDC_SIZEWE           = MAKEINTRESOURCE!(32644);
	const auto IDC_SIZENS           = MAKEINTRESOURCE!(32645);
	const auto IDC_SIZEALL          = MAKEINTRESOURCE!(32646);
	const auto IDC_NO               = MAKEINTRESOURCE!(32648); /*not in win3.1 */
	
	const auto IDC_HAND             = MAKEINTRESOURCE!(32649);
	
	const auto IDC_APPSTARTING      = MAKEINTRESOURCE!(32650); /*not in win3.1 */
	
	const auto IDC_HELP             = MAKEINTRESOURCE!(32651);
	
	BOOL SetSystemCursor(
	     HCURSOR hcur,
	     DWORD id);
	
	struct ICONINFO {
	    BOOL    fIcon;
	    DWORD   xHotspot;
	    DWORD   yHotspot;
	    HBITMAP hbmMask;
	    HBITMAP hbmColor;
	}
	
	alias ICONINFO *PICONINFO;
	
	HICON LoadIconA(
	     HINSTANCE hInstance,
	     LPCSTR lpIconName);
	HICON LoadIconW(
	     HINSTANCE hInstance,
	     LPCWSTR lpIconName);
	
	version(UNICODE) {
		alias LoadIconW LoadIcon;
	}
	else {
		alias LoadIconA LoadIcon;
	}
	
	
	UINT PrivateExtractIconsA(
	     LPCSTR szFileName,
	     int nIconIndex,
	     int cxIcon,
	     int cyIcon,
		 HICON *phicon,
		 UINT *piconid,
	     UINT nIcons,
	     UINT flags);
	
	UINT PrivateExtractIconsW(
	     LPCWSTR szFileName,
	     int nIconIndex,
	     int cxIcon,
	     int cyIcon,
		 HICON *phicon,
		 UINT *piconid,
	     UINT nIcons,
	     UINT flags);
	
	version(UNICODE) {
		alias PrivateExtractIconsW PrivateExtractIcons;
	}
	else {
		alias PrivateExtractIconsA PrivateExtractIcons;
	}

	HICON CreateIcon(
	     HINSTANCE hInstance,
	     int nWidth,
	     int nHeight,
	     BYTE cPlanes,
	     BYTE cBitsPixel,
	     BYTE *lpbANDbits,
	     BYTE *lpbXORbits);
	
	BOOL DestroyIcon(
	     HICON hIcon);
	
	int LookupIconIdFromDirectory(
	     PBYTE presbits,
	     BOOL fIcon);
	
	int LookupIconIdFromDirectoryEx(
	     PBYTE presbits,
	     BOOL fIcon,
	     int cxDesired,
	     int cyDesired,
	     UINT Flags);
	
	HICON CreateIconFromResource(
	     PBYTE presbits,
	     DWORD dwResSize,
	     BOOL fIcon,
	     DWORD dwVer);
	
	HICON CreateIconFromResourceEx(
	     PBYTE presbits,
	     DWORD dwResSize,
	     BOOL fIcon,
	     DWORD dwVer,
	     int cxDesired,
	     int cyDesired,
	     UINT Flags);
	
	/* Icon/Cursor header */
	struct CURSORSHAPE {
	    int     xHotSpot;
	    int     yHotSpot;
	    int     cx;
	    int     cy;
	    int     cbWidth;
	    BYTE    Planes;
	    BYTE    BitsPixel;
	}
	
	alias CURSORSHAPE  *LPCURSORSHAPE;
	
	const auto IMAGE_BITMAP         = 0;
	const auto IMAGE_ICON           = 1;
	const auto IMAGE_CURSOR         = 2;
	
	const auto IMAGE_ENHMETAFILE    = 3;
	
	const auto LR_DEFAULTCOLOR      = 0x00000000;
	const auto LR_MONOCHROME        = 0x00000001;
	const auto LR_COLOR             = 0x00000002;
	const auto LR_COPYRETURNORG     = 0x00000004;
	const auto LR_COPYDELETEORG     = 0x00000008;
	const auto LR_LOADFROMFILE      = 0x00000010;
	const auto LR_LOADTRANSPARENT   = 0x00000020;
	const auto LR_DEFAULTSIZE       = 0x00000040;
	const auto LR_VGACOLOR          = 0x00000080;
	const auto LR_LOADMAP3DCOLORS   = 0x00001000;
	const auto LR_CREATEDIBSECTION  = 0x00002000;
	const auto LR_COPYFROMRESOURCE  = 0x00004000;
	const auto LR_SHARED            = 0x00008000;
	
	HANDLE LoadImageA(
	     HINSTANCE hInst,
	     LPCSTR name,
	     UINT type,
	     int cx,
	     int cy,
	     UINT fuLoad);
	
	HANDLE LoadImageW(
	     HINSTANCE hInst,
	     LPCWSTR name,
	     UINT type,
	     int cx,
	     int cy,
	     UINT fuLoad);
	
	version(UNICODE) {
		alias LoadImageW LoadImage;
	}
	else {
		alias LoadImageA LoadImage;
	}
	
	HANDLE CopyImage(
	     HANDLE h,
	     UINT type,
	     int cx,
	     int cy,
	     UINT flags);
	
	const auto DI_MASK          = 0x0001;
	const auto DI_IMAGE         = 0x0002;
	const auto DI_NORMAL        = 0x0003;
	const auto DI_COMPAT        = 0x0004;
	const auto DI_DEFAULTSIZE   = 0x0008;
	
	const auto DI_NOMIRROR      = 0x0010;
	
	BOOL DrawIconEx(
	     HDC hdc,
	     int xLeft,
	     int yTop,
	     HICON hIcon,
	     int cxWidth,
	     int cyWidth,
	     UINT istepIfAniCur,
	     HBRUSH hbrFlickerFreeDraw,
	     UINT diFlags);
	
	HICON CreateIconIndirect(
	     PICONINFO piconinfo);
	
	HICON CopyIcon(
	     HICON hIcon);
	
	BOOL GetIconInfo(
	     HICON hIcon,
	     PICONINFO piconinfo);
	
	struct ICONINFOEXA {
	    DWORD   cbSize;
	    BOOL    fIcon;
	    DWORD   xHotspot;
	    DWORD   yHotspot;
	    HBITMAP hbmMask;
	    HBITMAP hbmColor;
	    WORD    wResID;
	    CHAR[MAX_PATH]    szModName;
	    CHAR[MAX_PATH]    szResName;
	}
	
	alias ICONINFOEXA* PICONINFOEXA;
	struct ICONINFOEXW {
	    DWORD   cbSize;
	    BOOL    fIcon;
	    DWORD   xHotspot;
	    DWORD   yHotspot;
	    HBITMAP hbmMask;
	    HBITMAP hbmColor;
	    WORD    wResID;
	    WCHAR[MAX_PATH]   szModName;
	    WCHAR[MAX_PATH]   szResName;
	}
	
	alias ICONINFOEXW* PICONINFOEXW;
	
	version(UNICODE) {
		alias ICONINFOEXW ICONINFOEX;
		alias PICONINFOEXW PICONINFOEX;
	}
	else {
		alias ICONINFOEXA ICONINFOEX;
		alias PICONINFOEXA PICONINFOEX;
	}
	
	BOOL GetIconInfoExA(
	     HICON hicon,
	     PICONINFOEXA piconinfo);
	
	BOOL GetIconInfoExW(
	     HICON hicon,
	     PICONINFOEXW piconinfo);
	
	version(UNICODE) {
		alias GetIconInfoExW GetIconInfoEx;
	}
	else {
		alias GetIconInfoExA GetIconInfoEx;
	}
	
	const auto RES_ICON     = 1;
	const auto RES_CURSOR   = 2;
	
	/*
	 * OEM Resource Ordinal Numbers
	 */
	const auto OBM_CLOSE            = 32754;
	const auto OBM_UPARROW          = 32753;
	const auto OBM_DNARROW          = 32752;
	const auto OBM_RGARROW          = 32751;
	const auto OBM_LFARROW          = 32750;
	const auto OBM_REDUCE           = 32749;
	const auto OBM_ZOOM             = 32748;
	const auto OBM_RESTORE          = 32747;
	const auto OBM_REDUCED          = 32746;
	const auto OBM_ZOOMD            = 32745;
	const auto OBM_RESTORED         = 32744;
	const auto OBM_UPARROWD         = 32743;
	const auto OBM_DNARROWD         = 32742;
	const auto OBM_RGARROWD         = 32741;
	const auto OBM_LFARROWD         = 32740;
	const auto OBM_MNARROW          = 32739;
	const auto OBM_COMBO            = 32738;
	const auto OBM_UPARROWI         = 32737;
	const auto OBM_DNARROWI         = 32736;
	const auto OBM_RGARROWI         = 32735;
	const auto OBM_LFARROWI         = 32734;
	
	const auto OBM_OLD_CLOSE        = 32767;
	const auto OBM_SIZE             = 32766;
	const auto OBM_OLD_UPARROW      = 32765;
	const auto OBM_OLD_DNARROW      = 32764;
	const auto OBM_OLD_RGARROW      = 32763;
	const auto OBM_OLD_LFARROW      = 32762;
	const auto OBM_BTSIZE           = 32761;
	const auto OBM_CHECK            = 32760;
	const auto OBM_CHECKBOXES       = 32759;
	const auto OBM_BTNCORNERS       = 32758;
	const auto OBM_OLD_REDUCE       = 32757;
	const auto OBM_OLD_ZOOM         = 32756;
	const auto OBM_OLD_RESTORE      = 32755;
	
	
	const auto OCR_NORMAL           = 32512;
	const auto OCR_IBEAM            = 32513;
	const auto OCR_WAIT             = 32514;
	const auto OCR_CROSS            = 32515;
	const auto OCR_UP               = 32516;
	const auto OCR_SIZE             = 32640;   /* OBSOLETE: use OCR_SIZEALL */
	const auto OCR_ICON             = 32641;   /* OBSOLETE: use OCR_NORMAL */
	const auto OCR_SIZENWSE         = 32642;
	const auto OCR_SIZENESW         = 32643;
	const auto OCR_SIZEWE           = 32644;
	const auto OCR_SIZENS           = 32645;
	const auto OCR_SIZEALL          = 32646;
	const auto OCR_ICOCUR           = 32647;   /* OBSOLETE: use OIC_WINLOGO */
	const auto OCR_NO               = 32648;
	
	const auto OCR_HAND             = 32649;
	
	const auto OCR_APPSTARTING      = 32650;
	
	const auto OIC_SAMPLE           = 32512;
	const auto OIC_HAND             = 32513;
	const auto OIC_QUES             = 32514;
	const auto OIC_BANG             = 32515;
	const auto OIC_NOTE             = 32516;
	
	const auto OIC_WINLOGO          = 32517;
	const auto OIC_WARNING          = OIC_BANG;
	const auto OIC_ERROR            = OIC_HAND;
	const auto OIC_INFORMATION      = OIC_NOTE;
	
	const auto OIC_SHIELD           = 32518;
	
	const auto ORD_LANGDRIVER     = 1;     /* The ordinal number for the entry point of
	                                ** language drivers.
	                                */
	
	version(NOICONS) {
	}
	else {
		/*
		 * Standard Icon IDs
		 */
		const auto IDI_APPLICATION      = MAKEINTRESOURCE!(32512);
		const auto IDI_HAND             = MAKEINTRESOURCE!(32513);
		const auto IDI_QUESTION         = MAKEINTRESOURCE!(32514);
		const auto IDI_EXCLAMATION      = MAKEINTRESOURCE!(32515);
		const auto IDI_ASTERISK         = MAKEINTRESOURCE!(32516);
	
		const auto IDI_WINLOGO          = MAKEINTRESOURCE!(32517);
	
		const auto IDI_SHIELD           = MAKEINTRESOURCE!(32518);
	
	
		const auto IDI_WARNING      = IDI_EXCLAMATION;
		const auto IDI_ERROR        = IDI_HAND;
		const auto IDI_INFORMATION  = IDI_ASTERISK;
	}
	
	int LoadStringA(
	     HINSTANCE hInstance,
	     UINT uID,
		 LPSTR lpBuffer,
	     int cchBufferMax);

	int LoadStringW(
	     HINSTANCE hInstance,
	     UINT uID,
		 LPWSTR lpBuffer,
	     int cchBufferMax);
	
	version(UNICODE) {
		alias LoadStringW LoadString;
	}
	else {
		alias LoadStringA LoadString;
	}
	
	
	/*
	 * Dialog Box Command IDs
	 */
	const auto IDOK                 = 1;
	const auto IDCANCEL             = 2;
	const auto IDABORT              = 3;
	const auto IDRETRY              = 4;
	const auto IDIGNORE             = 5;
	const auto IDYES                = 6;
	const auto IDNO                 = 7;
	
	const auto IDCLOSE          = 8;
	const auto IDHELP           = 9;
	
	const auto IDTRYAGAIN       = 10;
	const auto IDCONTINUE       = 11;
	
	const auto IDTIMEOUT  = 32000;
	
	version(NOCTLMGR) {
	}
	else {
		/*
		 * Control Manager Structures and Definitions
		 */
		
		version(NOWINSTYLES) {
		}
		else {
			/*
			 * Edit Control Styles
			 */
			const auto ES_LEFT              = 0x0000;
			const auto ES_CENTER            = 0x0001;
			const auto ES_RIGHT             = 0x0002;
			const auto ES_MULTILINE         = 0x0004;
			const auto ES_UPPERCASE         = 0x0008;
			const auto ES_LOWERCASE         = 0x0010;
			const auto ES_PASSWORD          = 0x0020;
			const auto ES_AUTOVSCROLL       = 0x0040;
			const auto ES_AUTOHSCROLL       = 0x0080;
			const auto ES_NOHIDESEL         = 0x0100;
			const auto ES_OEMCONVERT        = 0x0400;
			const auto ES_READONLY          = 0x0800;
			const auto ES_WANTRETURN        = 0x1000;
		
			const auto ES_NUMBER            = 0x2000;
		}
		
		/*
		 * Edit Control Notification Codes
		 */
		const auto EN_SETFOCUS          = 0x0100;
		const auto EN_KILLFOCUS         = 0x0200;
		const auto EN_CHANGE            = 0x0300;
		const auto EN_UPDATE            = 0x0400;
		const auto EN_ERRSPACE          = 0x0500;
		const auto EN_MAXTEXT           = 0x0501;
		const auto EN_HSCROLL           = 0x0601;
		const auto EN_VSCROLL           = 0x0602;
		
		const auto EN_ALIGN_LTR_EC      = 0x0700;
		const auto EN_ALIGN_RTL_EC      = 0x0701;
		
		/* Edit control EM_SETMARGIN parameters */
		const auto EC_LEFTMARGIN        = 0x0001;
		const auto EC_RIGHTMARGIN       = 0x0002;
		const auto EC_USEFONTINFO       = 0xffff;
		
		/* wParam of EM_GET/SETIMESTATUS  */
		const auto EMSIS_COMPOSITIONSTRING         = 0x0001;
	
		/* lParam for EMSIS_COMPOSITIONSTRING  */
		const auto EIMES_GETCOMPSTRATONCE          = 0x0001;
		const auto EIMES_CANCELCOMPSTRINFOCUS      = 0x0002;
		const auto EIMES_COMPLETECOMPSTRKILLFOCUS  = 0x0004;
		
		version(NOWINMESSAGES) {
		}
		else {
			/*
			 * Edit Control Messages
			 */
			const auto EM_GETSEL                = 0x00B0;
			const auto EM_SETSEL                = 0x00B1;
			const auto EM_GETRECT               = 0x00B2;
			const auto EM_SETRECT               = 0x00B3;
			const auto EM_SETRECTNP             = 0x00B4;
			const auto EM_SCROLL                = 0x00B5;
			const auto EM_LINESCROLL            = 0x00B6;
			const auto EM_SCROLLCARET           = 0x00B7;
			const auto EM_GETMODIFY             = 0x00B8;
			const auto EM_SETMODIFY             = 0x00B9;
			const auto EM_GETLINECOUNT          = 0x00BA;
			const auto EM_LINEINDEX             = 0x00BB;
			const auto EM_SETHANDLE             = 0x00BC;
			const auto EM_GETHANDLE             = 0x00BD;
			const auto EM_GETTHUMB              = 0x00BE;
			const auto EM_LINELENGTH            = 0x00C1;
			const auto EM_REPLACESEL            = 0x00C2;
			const auto EM_GETLINE               = 0x00C4;
			const auto EM_LIMITTEXT             = 0x00C5;
			const auto EM_CANUNDO               = 0x00C6;
			const auto EM_UNDO                  = 0x00C7;
			const auto EM_FMTLINES              = 0x00C8;
			const auto EM_LINEFROMCHAR          = 0x00C9;
			const auto EM_SETTABSTOPS           = 0x00CB;
			const auto EM_SETPASSWORDCHAR       = 0x00CC;
			const auto EM_EMPTYUNDOBUFFER       = 0x00CD;
			const auto EM_GETFIRSTVISIBLELINE   = 0x00CE;
			const auto EM_SETREADONLY           = 0x00CF;
			const auto EM_SETWORDBREAKPROC      = 0x00D0;
			const auto EM_GETWORDBREAKPROC      = 0x00D1;
			const auto EM_GETPASSWORDCHAR       = 0x00D2;
			
			const auto EM_SETMARGINS            = 0x00D3;
			const auto EM_GETMARGINS            = 0x00D4;
			const auto EM_SETLIMITTEXT          = EM_LIMITTEXT   /* ;win40 Name change */;
			const auto EM_GETLIMITTEXT          = 0x00D5;
			const auto EM_POSFROMCHAR           = 0x00D6;
			const auto EM_CHARFROMPOS           = 0x00D7;
			
			const auto EM_SETIMESTATUS          = 0x00D8;
			const auto EM_GETIMESTATUS          = 0x00D9;
		}
		
		/*
		 * EDITWORDBREAKPROC code values
		 */
		const auto WB_LEFT             = 0;
		const auto WB_RIGHT            = 1;
		const auto WB_ISDELIMITER      = 2;
		
		/*
		 * Button Control Styles
		 */
		const auto BS_PUSHBUTTON        = 0x00000000;
		const auto BS_DEFPUSHBUTTON     = 0x00000001;
		const auto BS_CHECKBOX          = 0x00000002;
		const auto BS_AUTOCHECKBOX      = 0x00000003;
		const auto BS_RADIOBUTTON       = 0x00000004;
		const auto BS_3STATE            = 0x00000005;
		const auto BS_AUTO3STATE        = 0x00000006;
		const auto BS_GROUPBOX          = 0x00000007;
		const auto BS_USERBUTTON        = 0x00000008;
		const auto BS_AUTORADIOBUTTON   = 0x00000009;
		const auto BS_PUSHBOX           = 0x0000000A;
		const auto BS_OWNERDRAW         = 0x0000000B;
		const auto BS_TYPEMASK          = 0x0000000F;
		const auto BS_LEFTTEXT          = 0x00000020;
		
		const auto BS_TEXT              = 0x00000000;
		const auto BS_ICON              = 0x00000040;
		const auto BS_BITMAP            = 0x00000080;
		const auto BS_LEFT              = 0x00000100;
		const auto BS_RIGHT             = 0x00000200;
		const auto BS_CENTER            = 0x00000300;
		const auto BS_TOP               = 0x00000400;
		const auto BS_BOTTOM            = 0x00000800;
		const auto BS_VCENTER           = 0x00000C00;
		const auto BS_PUSHLIKE          = 0x00001000;
		const auto BS_MULTILINE         = 0x00002000;
		const auto BS_NOTIFY            = 0x00004000;
		const auto BS_FLAT              = 0x00008000;
		const auto BS_RIGHTBUTTON       = BS_LEFTTEXT;
		
		/*
		 * User Button Notification Codes
		 */
		const auto BN_CLICKED           = 0;
		const auto BN_PAINT             = 1;
		const auto BN_HILITE            = 2;
		const auto BN_UNHILITE          = 3;
		const auto BN_DISABLE           = 4;
		const auto BN_DOUBLECLICKED     = 5;
		
		const auto BN_PUSHED            = BN_HILITE;
		const auto BN_UNPUSHED          = BN_UNHILITE;
		const auto BN_DBLCLK            = BN_DOUBLECLICKED;
		const auto BN_SETFOCUS          = 6;
		const auto BN_KILLFOCUS         = 7;
		
		/*
		 * Button Control Messages
		 */
		const auto BM_GETCHECK         = 0x00F0;
		const auto BM_SETCHECK         = 0x00F1;
		const auto BM_GETSTATE         = 0x00F2;
		const auto BM_SETSTATE         = 0x00F3;
		const auto BM_SETSTYLE         = 0x00F4;
		
		const auto BM_CLICK            = 0x00F5;
		const auto BM_GETIMAGE         = 0x00F6;
		const auto BM_SETIMAGE         = 0x00F7;
		
		const auto BM_SETDONTCLICK     = 0x00F8;
		
		const auto BST_UNCHECKED       = 0x0000;
		const auto BST_CHECKED         = 0x0001;
		const auto BST_INDETERMINATE   = 0x0002;
		const auto BST_PUSHED          = 0x0004;
		const auto BST_FOCUS           = 0x0008;
		
		/*
		 * Static Control Constants
		 */
		const auto SS_LEFT              = 0x00000000;
		const auto SS_CENTER            = 0x00000001;
		const auto SS_RIGHT             = 0x00000002;
		const auto SS_ICON              = 0x00000003;
		const auto SS_BLACKRECT         = 0x00000004;
		const auto SS_GRAYRECT          = 0x00000005;
		const auto SS_WHITERECT         = 0x00000006;
		const auto SS_BLACKFRAME        = 0x00000007;
		const auto SS_GRAYFRAME         = 0x00000008;
		const auto SS_WHITEFRAME        = 0x00000009;
		const auto SS_USERITEM          = 0x0000000A;
		const auto SS_SIMPLE            = 0x0000000B;
		const auto SS_LEFTNOWORDWRAP    = 0x0000000C;
		
		const auto SS_OWNERDRAW         = 0x0000000D;
		const auto SS_BITMAP            = 0x0000000E;
		const auto SS_ENHMETAFILE       = 0x0000000F;
		const auto SS_ETCHEDHORZ        = 0x00000010;
		const auto SS_ETCHEDVERT        = 0x00000011;
		const auto SS_ETCHEDFRAME       = 0x00000012;
		const auto SS_TYPEMASK          = 0x0000001F;
		
		const auto SS_REALSIZECONTROL   = 0x00000040;
		
		const auto SS_NOPREFIX          = 0x00000080L /* Don't do "&" character translation */;
		
		const auto SS_NOTIFY            = 0x00000100;
		const auto SS_CENTERIMAGE       = 0x00000200;
		const auto SS_RIGHTJUST         = 0x00000400;
		const auto SS_REALSIZEIMAGE     = 0x00000800;
		const auto SS_SUNKEN            = 0x00001000;
		const auto SS_EDITCONTROL       = 0x00002000;
		const auto SS_ENDELLIPSIS       = 0x00004000;
		const auto SS_PATHELLIPSIS      = 0x00008000;
		const auto SS_WORDELLIPSIS      = 0x0000C000;
		const auto SS_ELLIPSISMASK      = 0x0000C000;
		
		version(NOWINMESSAGES) {
		}
		else {
			/*
			 * Static Control Mesages
			 */
			const auto STM_SETICON          = 0x0170;
			const auto STM_GETICON          = 0x0171;
			
			const auto STM_SETIMAGE         = 0x0172;
			const auto STM_GETIMAGE         = 0x0173;
			const auto STN_CLICKED          = 0;
			const auto STN_DBLCLK           = 1;
			const auto STN_ENABLE           = 2;
			const auto STN_DISABLE          = 3;
			
			const auto STM_MSGMAX           = 0x0174;
		}
		
		/*
		 * Dialog window class
		 */
		const auto WC_DIALOG        = (MAKEINTATOM!(0x8002));
		
		/*
		 * Get/SetWindowWord/Long offsets for use with WC_DIALOG windows
		 */
		const auto DWL_MSGRESULT    = 0;
		const auto DWL_DLGPROC      = 4;
		const auto DWL_USER         = 8;

		const auto DWLP_MSGRESULT   = 0;
		const auto DWLP_DLGPROC     = DWLP_MSGRESULT + LRESULT.sizeof;
		const auto DWLP_USER        = DWLP_DLGPROC + DLGPROC.sizeof;
		
		/*
		 * Dialog Manager Routines
		 */
		
		version(NOMSG) {
		}
		else {
			BOOL IsDialogMessageA(
			     HWND hDlg,
			     LPMSG lpMsg);
		
			BOOL IsDialogMessageW(
			     HWND hDlg,
			     LPMSG lpMsg);
		
			version(UNICODE) {
				alias IsDialogMessageW IsDialogMessage;
			}
			else {
				alias IsDialogMessageA IsDialogMessage;
			}
		}
		
		BOOL MapDialogRect(
		     HWND hDlg,
		     LPRECT lpRect);
		
		int DlgDirListA(
		     HWND hDlg,
		     LPSTR lpPathSpec,
		     int nIDListBox,
		     int nIDStaticPath,
		     UINT uFileType);
	
		int DlgDirListW(
		     HWND hDlg,
		     LPWSTR lpPathSpec,
		     int nIDListBox,
		     int nIDStaticPath,
		     UINT uFileType);
		
		version(UNICODE) {
			alias DlgDirListW DlgDirList;
		}
		else {
			alias DlgDirListA DlgDirList;
		}
		
		/*
		 * DlgDirList, DlgDirListComboBox flags values
		 */
		const auto DDL_READWRITE        = 0x0000;
		const auto DDL_READONLY         = 0x0001;
		const auto DDL_HIDDEN           = 0x0002;
		const auto DDL_SYSTEM           = 0x0004;
		const auto DDL_DIRECTORY        = 0x0010;
		const auto DDL_ARCHIVE          = 0x0020;
		
		const auto DDL_POSTMSGS         = 0x2000;
		const auto DDL_DRIVES           = 0x4000;
		const auto DDL_EXCLUSIVE        = 0x8000;
		
		BOOL DlgDirSelectExA(
		     HWND hwndDlg,
			 LPSTR lpString,
		     int chCount,
		     int idListBox);
		
		BOOL DlgDirSelectExW(
		     HWND hwndDlg,
			 LPWSTR lpString,
		     int chCount,
		     int idListBox);
		
		version(UNICODE) {
			alias DlgDirSelectExW DlgDirSelectEx;
		}
		else {
			alias DlgDirSelectExA DlgDirSelectEx;
		}
		
		int DlgDirListComboBoxA(
		     HWND hDlg,
		     LPSTR lpPathSpec,
		     int nIDComboBox,
		     int nIDStaticPath,
		     UINT uFiletype);
		
		int DlgDirListComboBoxW(
		     HWND hDlg,
		     LPWSTR lpPathSpec,
		     int nIDComboBox,
		     int nIDStaticPath,
		     UINT uFiletype);
		
		version(UNICODE) {
			alias DlgDirListComboBoxW DlgDirListComboBox;
		}
		else {
			alias DlgDirListComboBoxA DlgDirListComboBox;
		}
		
		BOOL DlgDirSelectComboBoxExA(
		     HWND hwndDlg,
			 LPSTR lpString,
		     int cchOut,
		     int idComboBox);
		
		BOOL DlgDirSelectComboBoxExW(
		     HWND hwndDlg,
			 LPWSTR lpString,
		     int cchOut,
		     int idComboBox);
		
		version(UNICODE) {
			alias DlgDirSelectComboBoxExW DlgDirSelectComboBoxEx;
		}
		else {
			alias DlgDirSelectComboBoxExA DlgDirSelectComboBoxEx;
		}
		
		
		
		/*
		 * Dialog Styles
		 */
		const auto DS_ABSALIGN          = 0x01;
		const auto DS_SYSMODAL          = 0x02;
		const auto DS_LOCALEDIT         = 0x20L   /* Edit items get Local storage. */;
		const auto DS_SETFONT           = 0x40L   /* User specified font for Dlg controls */;
		const auto DS_MODALFRAME        = 0x80L   /* Can be combined with WS_CAPTION  */;
		const auto DS_NOIDLEMSG         = 0x100L  /* WM_ENTERIDLE message will not be sent */;
		const auto DS_SETFOREGROUND     = 0x200L  /* not in win3.1 */;
		
		const auto DS_3DLOOK            = 0x0004;
		const auto DS_FIXEDSYS          = 0x0008;
		const auto DS_NOFAILCREATE      = 0x0010;
		const auto DS_CONTROL           = 0x0400;
		const auto DS_CENTER            = 0x0800;
		const auto DS_CENTERMOUSE       = 0x1000;
		const auto DS_CONTEXTHELP       = 0x2000;
		
		const auto DS_SHELLFONT         = (DS_SETFONT | DS_FIXEDSYS);
		
		const auto DS_USEPIXELS         = 0x8000;
		
		const auto DM_GETDEFID          = (WM_USER+0);
		const auto DM_SETDEFID          = (WM_USER+1);
		
		const auto DM_REPOSITION        = (WM_USER+2);
		
		/*
		 * Returned in HIWORD() of DM_GETDEFID result if msg is supported
		 */
		const auto DC_HASDEFID          = 0x534B;
		
		/*
		 * Dialog Codes
		 */
		const auto DLGC_WANTARROWS      = 0x0001      /* Control wants arrow keys         */;
		const auto DLGC_WANTTAB         = 0x0002      /* Control wants tab keys           */;
		const auto DLGC_WANTALLKEYS     = 0x0004      /* Control wants all keys           */;
		const auto DLGC_WANTMESSAGE     = 0x0004      /* Pass message to control          */;
		const auto DLGC_HASSETSEL       = 0x0008      /* Understands EM_SETSEL message    */;
		const auto DLGC_DEFPUSHBUTTON   = 0x0010      /* Default pushbutton               */;
		const auto DLGC_UNDEFPUSHBUTTON  = 0x0020     /* Non-default pushbutton           */;
		const auto DLGC_RADIOBUTTON     = 0x0040      /* Radio button                     */;
		const auto DLGC_WANTCHARS       = 0x0080      /* Want WM_CHAR messages            */;
		const auto DLGC_STATIC          = 0x0100      /* Static item: don't include       */;
		const auto DLGC_BUTTON          = 0x2000      /* Button item: can be checked      */;
		
		const auto LB_CTLCODE           = 0;
		
		/*
		 * Listbox Return Values
		 */
		const auto LB_OKAY              = 0;
		const auto LB_ERR               = (-1);
		const auto LB_ERRSPACE          = (-2);
		
		/*
		**  The idStaticPath parameter to DlgDirList can have the following values
		**  ORed if the list box should show other details of the files along with
		**  the name of the files;
		*/
		                                  /* all other details also will be returned */
		

		/*
		 * Listbox Notification Codes
		 */
		const auto LBN_ERRSPACE         = (-2);
		const auto LBN_SELCHANGE        = 1;
		const auto LBN_DBLCLK           = 2;
		const auto LBN_SELCANCEL        = 3;
		const auto LBN_SETFOCUS         = 4;
		const auto LBN_KILLFOCUS        = 5;
		
		
		version(NOWINMESSAGES) {
		}
		else {
			/*
			 * Listbox messages
			 */
			const auto LB_ADDSTRING             = 0x0180;
			const auto LB_INSERTSTRING          = 0x0181;
			const auto LB_DELETESTRING          = 0x0182;
			const auto LB_SELITEMRANGEEX        = 0x0183;
			const auto LB_RESETCONTENT          = 0x0184;
			const auto LB_SETSEL                = 0x0185;
			const auto LB_SETCURSEL             = 0x0186;
			const auto LB_GETSEL                = 0x0187;
			const auto LB_GETCURSEL             = 0x0188;
			const auto LB_GETTEXT               = 0x0189;
			const auto LB_GETTEXTLEN            = 0x018A;
			const auto LB_GETCOUNT              = 0x018B;
			const auto LB_SELECTSTRING          = 0x018C;
			const auto LB_DIR                   = 0x018D;
			const auto LB_GETTOPINDEX           = 0x018E;
			const auto LB_FINDSTRING            = 0x018F;
			const auto LB_GETSELCOUNT           = 0x0190;
			const auto LB_GETSELITEMS           = 0x0191;
			const auto LB_SETTABSTOPS           = 0x0192;
			const auto LB_GETHORIZONTALEXTENT   = 0x0193;
			const auto LB_SETHORIZONTALEXTENT   = 0x0194;
			const auto LB_SETCOLUMNWIDTH        = 0x0195;
			const auto LB_ADDFILE               = 0x0196;
			const auto LB_SETTOPINDEX           = 0x0197;
			const auto LB_GETITEMRECT           = 0x0198;
			const auto LB_GETITEMDATA           = 0x0199;
			const auto LB_SETITEMDATA           = 0x019A;
			const auto LB_SELITEMRANGE          = 0x019B;
			const auto LB_SETANCHORINDEX        = 0x019C;
			const auto LB_GETANCHORINDEX        = 0x019D;
			const auto LB_SETCARETINDEX         = 0x019E;
			const auto LB_GETCARETINDEX         = 0x019F;
			const auto LB_SETITEMHEIGHT         = 0x01A0;
			const auto LB_GETITEMHEIGHT         = 0x01A1;
			const auto LB_FINDSTRINGEXACT       = 0x01A2;
			const auto LB_SETLOCALE             = 0x01A5;
			const auto LB_GETLOCALE             = 0x01A6;
			const auto LB_SETCOUNT              = 0x01A7;
			
			const auto LB_INITSTORAGE           = 0x01A8;
			const auto LB_ITEMFROMPOINT         = 0x01A9;
			
			const auto LB_MULTIPLEADDSTRING     = 0x01B1;
			
			const auto LB_GETLISTBOXINFO        = 0x01B2;
		
			const auto LB_MSGMAX                = 0x01B3;
		}
		
		version(NOWINSTYLES) {
		}
		else {
			/*
			 * Listbox Styles
			 */
			const auto LBS_NOTIFY             = 0x0001;
			const auto LBS_SORT               = 0x0002;
			const auto LBS_NOREDRAW           = 0x0004;
			const auto LBS_MULTIPLESEL        = 0x0008;
			const auto LBS_OWNERDRAWFIXED     = 0x0010;
			const auto LBS_OWNERDRAWVARIABLE  = 0x0020;
			const auto LBS_HASSTRINGS         = 0x0040;
			const auto LBS_USETABSTOPS        = 0x0080;
			const auto LBS_NOINTEGRALHEIGHT   = 0x0100;
			const auto LBS_MULTICOLUMN        = 0x0200;
			const auto LBS_WANTKEYBOARDINPUT  = 0x0400;
			const auto LBS_EXTENDEDSEL        = 0x0800;
			const auto LBS_DISABLENOSCROLL    = 0x1000;
			const auto LBS_NODATA             = 0x2000;
			
			const auto LBS_NOSEL              = 0x4000;
			
			const auto LBS_COMBOBOX           = 0x8000;
			
			const auto LBS_STANDARD           = (LBS_NOTIFY | LBS_SORT | WS_VSCROLL | WS_BORDER);
		}
		
		
		/*
		 * Combo Box return Values
		 */
		const auto CB_OKAY              = 0;
		const auto CB_ERR               = (-1);
		const auto CB_ERRSPACE          = (-2);
		
		
		/*
		 * Combo Box Notification Codes
		 */
		const auto CBN_ERRSPACE         = (-1);
		const auto CBN_SELCHANGE        = 1;
		const auto CBN_DBLCLK           = 2;
		const auto CBN_SETFOCUS         = 3;
		const auto CBN_KILLFOCUS        = 4;
		const auto CBN_EDITCHANGE       = 5;
		const auto CBN_EDITUPDATE       = 6;
		const auto CBN_DROPDOWN         = 7;
		const auto CBN_CLOSEUP          = 8;
		const auto CBN_SELENDOK         = 9;
		const auto CBN_SELENDCANCEL     = 10;
		
		version(NOWINSTYLES) {
		}
		else {
			/*
			 * Combo Box styles
			 */
			const auto CBS_SIMPLE             = 0x0001;
			const auto CBS_DROPDOWN           = 0x0002;
			const auto CBS_DROPDOWNLIST       = 0x0003;
			const auto CBS_OWNERDRAWFIXED     = 0x0010;
			const auto CBS_OWNERDRAWVARIABLE  = 0x0020;
			const auto CBS_AUTOHSCROLL        = 0x0040;
			const auto CBS_OEMCONVERT         = 0x0080;
			const auto CBS_SORT               = 0x0100;
			const auto CBS_HASSTRINGS         = 0x0200;
			const auto CBS_NOINTEGRALHEIGHT   = 0x0400;
			const auto CBS_DISABLENOSCROLL    = 0x0800;
		
			const auto CBS_UPPERCASE          = 0x2000;
			const auto CBS_LOWERCASE          = 0x4000;
		}
		
		/*
		 * Combo Box messages
		 */
		version(NOWINMESSAGES) {
		}
		else {
			const auto CB_GETEDITSEL                = 0x0140;
			const auto CB_LIMITTEXT                 = 0x0141;
			const auto CB_SETEDITSEL                = 0x0142;
			const auto CB_ADDSTRING                 = 0x0143;
			const auto CB_DELETESTRING              = 0x0144;
			const auto CB_DIR                       = 0x0145;
			const auto CB_GETCOUNT                  = 0x0146;
			const auto CB_GETCURSEL                 = 0x0147;
			const auto CB_GETLBTEXT                 = 0x0148;
			const auto CB_GETLBTEXTLEN              = 0x0149;
			const auto CB_INSERTSTRING              = 0x014A;
			const auto CB_RESETCONTENT              = 0x014B;
			const auto CB_FINDSTRING                = 0x014C;
			const auto CB_SELECTSTRING              = 0x014D;
			const auto CB_SETCURSEL                 = 0x014E;
			const auto CB_SHOWDROPDOWN              = 0x014F;
			const auto CB_GETITEMDATA               = 0x0150;
			const auto CB_SETITEMDATA               = 0x0151;
			const auto CB_GETDROPPEDCONTROLRECT     = 0x0152;
			const auto CB_SETITEMHEIGHT             = 0x0153;
			const auto CB_GETITEMHEIGHT             = 0x0154;
			const auto CB_SETEXTENDEDUI             = 0x0155;
			const auto CB_GETEXTENDEDUI             = 0x0156;
			const auto CB_GETDROPPEDSTATE           = 0x0157;
			const auto CB_FINDSTRINGEXACT           = 0x0158;
			const auto CB_SETLOCALE                 = 0x0159;
			const auto CB_GETLOCALE                 = 0x015A;
			
			const auto CB_GETTOPINDEX               = 0x015b;
			const auto CB_SETTOPINDEX               = 0x015c;
			const auto CB_GETHORIZONTALEXTENT       = 0x015d;
			const auto CB_SETHORIZONTALEXTENT       = 0x015e;
			const auto CB_GETDROPPEDWIDTH           = 0x015f;
			const auto CB_SETDROPPEDWIDTH           = 0x0160;
			const auto CB_INITSTORAGE               = 0x0161;
	
			const auto CB_MULTIPLEADDSTRING         = 0x0163;
			
			const auto CB_GETCOMBOBOXINFO           = 0x0164;
			
			const auto CB_MSGMAX                    = 0x0165;
		}
		
		version(NOWINSTYLES) {
		}
		else {
			/*
			 * Scroll Bar Styles
			 */
			const auto SBS_HORZ                     = 0x0000;
			const auto SBS_VERT                     = 0x0001;
			const auto SBS_TOPALIGN                 = 0x0002;
			const auto SBS_LEFTALIGN                = 0x0002;
			const auto SBS_BOTTOMALIGN              = 0x0004;
			const auto SBS_RIGHTALIGN               = 0x0004;
			const auto SBS_SIZEBOXTOPLEFTALIGN      = 0x0002;
			const auto SBS_SIZEBOXBOTTOMRIGHTALIGN  = 0x0004;
			const auto SBS_SIZEBOX                  = 0x0008;
		
			const auto SBS_SIZEGRIP                 = 0x0010;
		}
		
		/*
		 * Scroll bar messages
		 */
		version(NOWINMESSAGES) {
		}
		else {
			const auto SBM_SETPOS                   = 0x00E0 /*not in win3.1 */;
			const auto SBM_GETPOS                   = 0x00E1 /*not in win3.1 */;
			const auto SBM_SETRANGE                 = 0x00E2 /*not in win3.1 */;
			const auto SBM_SETRANGEREDRAW           = 0x00E6 /*not in win3.1 */;
			const auto SBM_GETRANGE                 = 0x00E3 /*not in win3.1 */;
			const auto SBM_ENABLE_ARROWS            = 0x00E4 /*not in win3.1 */;
			
			const auto SBM_SETSCROLLINFO            = 0x00E9;
			const auto SBM_GETSCROLLINFO            = 0x00EA;
			
			const auto SBM_GETSCROLLBARINFO         = 0x00EB;
			
			const auto SIF_RANGE            = 0x0001;
			const auto SIF_PAGE             = 0x0002;
			const auto SIF_POS              = 0x0004;
			const auto SIF_DISABLENOSCROLL  = 0x0008;
			const auto SIF_TRACKPOS         = 0x0010;
			const auto SIF_ALL              = (SIF_RANGE | SIF_PAGE | SIF_POS | SIF_TRACKPOS);
	
			struct SCROLLINFO {
			    UINT    cbSize;
			    UINT    fMask;
			    int     nMin;
			    int     nMax;
			    UINT    nPage;
			    int     nPos;
			    int     nTrackPos;
			}
	
			alias SCROLLINFO  *LPSCROLLINFO;
			alias SCROLLINFO   *LPCSCROLLINFO;
	
			int SetScrollInfo(
			     HWND hwnd,
			     int nBar,
			     LPCSCROLLINFO lpsi,
			     BOOL redraw);
	
			BOOL GetScrollInfo(
			     HWND hwnd,
			     int nBar,
			     LPSCROLLINFO lpsi);
		}
	}
	
	version(NOMDI) {
	}
	else {
		/*
		 * MDI client style bits
		 */
		const auto MDIS_ALLCHILDSTYLES     = 0x0001;
		
		/*
		 * wParam Flags for WM_MDITILE and WM_MDICASCADE messages.
		 */
		const auto MDITILE_VERTICAL        = 0x0000; /*not in win3.1 */
		const auto MDITILE_HORIZONTAL      = 0x0001; /*not in win3.1 */
		const auto MDITILE_SKIPDISABLED    = 0x0002; /*not in win3.1 */
		
		const auto MDITILE_ZORDER          = 0x0004;
		
		struct MDICREATESTRUCTA {
		    LPCSTR   szClass;
		    LPCSTR   szTitle;
		    HANDLE hOwner;
		    int x;
		    int y;
		    int cx;
		    int cy;
		    DWORD style;
		    LPARAM lParam;        /* app-defined stuff */
		}

		alias MDICREATESTRUCTA* LPMDICREATESTRUCTA;
		
		struct MDICREATESTRUCTW {
		    LPCWSTR  szClass;
		    LPCWSTR  szTitle;
		    HANDLE hOwner;
		    int x;
		    int y;
		    int cx;
		    int cy;
		    DWORD style;
		    LPARAM lParam;        /* app-defined stuff */
		}
		
		alias MDICREATESTRUCTW* LPMDICREATESTRUCTW;
		
		version(UNICODE) {
			alias MDICREATESTRUCTW MDICREATESTRUCT;
			alias LPMDICREATESTRUCTW LPMDICREATESTRUCT;
		}
		else {
			alias MDICREATESTRUCTA MDICREATESTRUCT;
			alias LPMDICREATESTRUCTA LPMDICREATESTRUCT;
		}
		
		struct CLIENTCREATESTRUCT {
		    HANDLE hWindowMenu;
		    UINT idFirstChild;
		}
		
		alias CLIENTCREATESTRUCT* LPCLIENTCREATESTRUCT;
		
		LRESULT DefFrameProcA(
		     HWND hWnd,
		     HWND hWndMDIClient,
		     UINT uMsg,
		     WPARAM wParam,
		     LPARAM lParam);
		
		LRESULT DefFrameProcW(
		     HWND hWnd,
		     HWND hWndMDIClient,
		     UINT uMsg,
		     WPARAM wParam,
		     LPARAM lParam);
		
		version(UNICODE) {
			alias DefFrameProcW DefFrameProc;
		}
		else {
			alias DefFrameProcA DefFrameProc;
		}
		
		LRESULT DefMDIChildProcA(
		     HWND hWnd,
		     UINT uMsg,
		     WPARAM wParam,
		     LPARAM lParam);
		
		LRESULT DefMDIChildProcW(
		     HWND hWnd,
		     UINT uMsg,
		     WPARAM wParam,
		     LPARAM lParam);
		
		version(UNICODE) {
			alias DefMDIChildProcW DefMDIChildProc;
		}
		else {
			alias DefMDIChildProcA DefMDIChildProc;
		}

		version(NOMSG) {
		}
		else {
			BOOL TranslateMDISysAccel(
			     HWND hWndClient,
			     LPMSG lpMsg);
		}
		
		UINT ArrangeIconicWindows(
		     HWND hWnd);
		
		HWND CreateMDIWindowA(
		     LPCSTR lpClassName,
		     LPCSTR lpWindowName,
		     DWORD dwStyle,
		     int X,
		     int Y,
		     int nWidth,
		     int nHeight,
		     HWND hWndParent,
		     HINSTANCE hInstance,
		     LPARAM lParam);
		
		HWND CreateMDIWindowW(
		     LPCWSTR lpClassName,
		     LPCWSTR lpWindowName,
		     DWORD dwStyle,
		     int X,
		     int Y,
		     int nWidth,
		     int nHeight,
		     HWND hWndParent,
		     HINSTANCE hInstance,
		     LPARAM lParam);
		
		version(UNICODE) {
			alias CreateMDIWindowW CreateMDIWindow;
		}
		else {
			alias CreateMDIWindowA CreateMDIWindow;
		}
		
		WORD TileWindows(
		     HWND hwndParent,
		     UINT wHow,
		     RECT * lpRect,
		     UINT cKids,
			 HWND* lpKids);
	
		WORD CascadeWindows(
		     HWND hwndParent,
		     UINT wHow,
		     RECT * lpRect,
		     UINT cKids,
			 HWND * lpKids);
	}
}

/****** Help support ********************************************************/

version(NOHELP) {
}
else {
	alias DWORD HELPPOLY;

	struct MULTIKEYHELPA {
	    DWORD  mkSize;
	    CHAR   mkKeylist;
	    CHAR[1]   szKeyphrase;
	}
	
	alias MULTIKEYHELPA* PMULTIKEYHELPA;
	alias MULTIKEYHELPA* LPMULTIKEYHELPA;
	
	struct MULTIKEYHELPW {
	    DWORD  mkSize;
	    WCHAR  mkKeylist;
	    WCHAR[1]  szKeyphrase;
	}
	
	alias MULTIKEYHELPW* PMULTIKEYHELPW;
	alias MULTIKEYHELPW* LPMULTIKEYHELPW;
	
	version(UNICODE) {
		alias MULTIKEYHELPW MULTIKEYHELP;
		alias PMULTIKEYHELPW PMULTIKEYHELP;
		alias LPMULTIKEYHELPW LPMULTIKEYHELP;
	}
	else {
		alias MULTIKEYHELPA MULTIKEYHELP;
		alias PMULTIKEYHELPA PMULTIKEYHELP;
		alias LPMULTIKEYHELPA LPMULTIKEYHELP;
	}
	
	struct HELPWININFOA {
	    int  wStructSize;
	    int  x;
	    int  y;
	    int  dx;
	    int  dy;
	    int  wMax;
	    CHAR[2]   rgchMember;
	}
	
	alias HELPWININFOA* PHELPWININFOA;
	alias HELPWININFOA* LPHELPWININFOA;
	
	struct HELPWININFOW {
	    int  wStructSize;
	    int  x;
	    int  y;
	    int  dx;
	    int  dy;
	    int  wMax;
	    WCHAR[2]  rgchMember;
	}
	
	alias HELPWININFOW* PHELPWININFOW;
	alias HELPWININFOW* LPHELPWININFOW;
	
	version(UNICODE) {
		alias HELPWININFOW HELPWININFO;
		alias PHELPWININFOW PHELPWININFO;
		alias LPHELPWININFOW LPHELPWININFO;
	}
	else {
		alias HELPWININFOA HELPWININFO;
		alias PHELPWININFOA PHELPWININFO;
		alias LPHELPWININFOA LPHELPWININFO;
	}
	
	/*
	 * Commands to pass to WinHelp()
	 */
	const auto HELP_CONTEXT       = 0x0001;  /* Display topic in ulTopic */
	const auto HELP_QUIT          = 0x0002;  /* Terminate help */
	const auto HELP_INDEX         = 0x0003;  /* Display index */
	const auto HELP_CONTENTS      = 0x0003;
	const auto HELP_HELPONHELP    = 0x0004;  /* Display help on using help */
	const auto HELP_SETINDEX      = 0x0005;  /* Set current Index for multi index help */
	const auto HELP_SETCONTENTS   = 0x0005;
	const auto HELP_CONTEXTPOPUP  = 0x0008;
	const auto HELP_FORCEFILE     = 0x0009;
	const auto HELP_KEY           = 0x0101;  /* Display topic for keyword in offabData */
	const auto HELP_COMMAND       = 0x0102;
	const auto HELP_PARTIALKEY    = 0x0105;
	const auto HELP_MULTIKEY      = 0x0201;
	const auto HELP_SETWINPOS     = 0x0203;
	
	const auto HELP_CONTEXTMENU   = 0x000a;
	const auto HELP_FINDER        = 0x000b;
	const auto HELP_WM_HELP       = 0x000c;
	const auto HELP_SETPOPUP_POS  = 0x000d;
	
	const auto HELP_TCARD               = 0x8000;
	const auto HELP_TCARD_DATA          = 0x0010;
	const auto HELP_TCARD_OTHER_CALLER  = 0x0011;
	
	// These are in winhelp.h in Win95.
	const auto IDH_NO_HELP                      = 28440;
	const auto IDH_MISSING_CONTEXT              = 28441 ; // Control doesn't have matching help context
	const auto IDH_GENERIC_HELP_BUTTON          = 28442 ; // Property sheet help button
	const auto IDH_OK                           = 28443;
	const auto IDH_CANCEL                       = 28444;
	const auto IDH_HELP                         = 28445;

	BOOL WinHelpA(
	     HWND hWndMain,
	     LPCSTR lpszHelp,
	     UINT uCommand,
	     ULONG_PTR dwData);

	BOOL WinHelpW(
	     HWND hWndMain,
	     LPCWSTR lpszHelp,
	     UINT uCommand,
	     ULONG_PTR dwData);

	version(UNICODE) {
		alias WinHelpW WinHelp;
	}
	else {
		alias WinHelpA WinHelp;
	}
}

const auto GR_GDIOBJECTS      = 0;       /* Count of GDI objects */
const auto GR_USEROBJECTS     = 1;       /* Count of USER objects */

DWORD GetGuiResources(
     HANDLE hProcess,
     DWORD uiFlags);

version(NOSYSPARAMSINFO) {
}
else {
	/*
	 * Parameter for SystemParametersInfo()
	 */
	
	const auto SPI_GETBEEP                  = 0x0001;
	const auto SPI_SETBEEP                  = 0x0002;
	const auto SPI_GETMOUSE                 = 0x0003;
	const auto SPI_SETMOUSE                 = 0x0004;
	const auto SPI_GETBORDER                = 0x0005;
	const auto SPI_SETBORDER                = 0x0006;
	const auto SPI_GETKEYBOARDSPEED         = 0x000A;
	const auto SPI_SETKEYBOARDSPEED         = 0x000B;
	const auto SPI_LANGDRIVER               = 0x000C;
	const auto SPI_ICONHORIZONTALSPACING    = 0x000D;
	const auto SPI_GETSCREENSAVETIMEOUT     = 0x000E;
	const auto SPI_SETSCREENSAVETIMEOUT     = 0x000F;
	const auto SPI_GETSCREENSAVEACTIVE      = 0x0010;
	const auto SPI_SETSCREENSAVEACTIVE      = 0x0011;
	const auto SPI_GETGRIDGRANULARITY       = 0x0012;
	const auto SPI_SETGRIDGRANULARITY       = 0x0013;
	const auto SPI_SETDESKWALLPAPER         = 0x0014;
	const auto SPI_SETDESKPATTERN           = 0x0015;
	const auto SPI_GETKEYBOARDDELAY         = 0x0016;
	const auto SPI_SETKEYBOARDDELAY         = 0x0017;
	const auto SPI_ICONVERTICALSPACING      = 0x0018;
	const auto SPI_GETICONTITLEWRAP         = 0x0019;
	const auto SPI_SETICONTITLEWRAP         = 0x001A;
	const auto SPI_GETMENUDROPALIGNMENT     = 0x001B;
	const auto SPI_SETMENUDROPALIGNMENT     = 0x001C;
	const auto SPI_SETDOUBLECLKWIDTH        = 0x001D;
	const auto SPI_SETDOUBLECLKHEIGHT       = 0x001E;
	const auto SPI_GETICONTITLELOGFONT      = 0x001F;
	const auto SPI_SETDOUBLECLICKTIME       = 0x0020;
	const auto SPI_SETMOUSEBUTTONSWAP       = 0x0021;
	const auto SPI_SETICONTITLELOGFONT      = 0x0022;
	const auto SPI_GETFASTTASKSWITCH        = 0x0023;
	const auto SPI_SETFASTTASKSWITCH        = 0x0024;
	
	const auto SPI_SETDRAGFULLWINDOWS       = 0x0025;
	const auto SPI_GETDRAGFULLWINDOWS       = 0x0026;
	const auto SPI_GETNONCLIENTMETRICS      = 0x0029;
	const auto SPI_SETNONCLIENTMETRICS      = 0x002A;
	const auto SPI_GETMINIMIZEDMETRICS      = 0x002B;
	const auto SPI_SETMINIMIZEDMETRICS      = 0x002C;
	const auto SPI_GETICONMETRICS           = 0x002D;
	const auto SPI_SETICONMETRICS           = 0x002E;
	const auto SPI_SETWORKAREA              = 0x002F;
	const auto SPI_GETWORKAREA              = 0x0030;
	const auto SPI_SETPENWINDOWS            = 0x0031;
	
	const auto SPI_GETHIGHCONTRAST          = 0x0042;
	const auto SPI_SETHIGHCONTRAST          = 0x0043;
	const auto SPI_GETKEYBOARDPREF          = 0x0044;
	const auto SPI_SETKEYBOARDPREF          = 0x0045;
	const auto SPI_GETSCREENREADER          = 0x0046;
	const auto SPI_SETSCREENREADER          = 0x0047;
	const auto SPI_GETANIMATION             = 0x0048;
	const auto SPI_SETANIMATION             = 0x0049;
	const auto SPI_GETFONTSMOOTHING         = 0x004A;
	const auto SPI_SETFONTSMOOTHING         = 0x004B;
	const auto SPI_SETDRAGWIDTH             = 0x004C;
	const auto SPI_SETDRAGHEIGHT            = 0x004D;
	const auto SPI_SETHANDHELD              = 0x004E;
	const auto SPI_GETLOWPOWERTIMEOUT       = 0x004F;
	const auto SPI_GETPOWEROFFTIMEOUT       = 0x0050;
	const auto SPI_SETLOWPOWERTIMEOUT       = 0x0051;
	const auto SPI_SETPOWEROFFTIMEOUT       = 0x0052;
	const auto SPI_GETLOWPOWERACTIVE        = 0x0053;
	const auto SPI_GETPOWEROFFACTIVE        = 0x0054;
	const auto SPI_SETLOWPOWERACTIVE        = 0x0055;
	const auto SPI_SETPOWEROFFACTIVE        = 0x0056;
	const auto SPI_SETCURSORS               = 0x0057;
	const auto SPI_SETICONS                 = 0x0058;
	const auto SPI_GETDEFAULTINPUTLANG      = 0x0059;
	const auto SPI_SETDEFAULTINPUTLANG      = 0x005A;
	const auto SPI_SETLANGTOGGLE            = 0x005B;
	const auto SPI_GETWINDOWSEXTENSION      = 0x005C;
	const auto SPI_SETMOUSETRAILS           = 0x005D;
	const auto SPI_GETMOUSETRAILS           = 0x005E;
	const auto SPI_SETSCREENSAVERRUNNING    = 0x0061;
	const auto SPI_SCREENSAVERRUNNING      = SPI_SETSCREENSAVERRUNNING;
	
	const auto SPI_GETFILTERKEYS           = 0x0032;
	const auto SPI_SETFILTERKEYS           = 0x0033;
	const auto SPI_GETTOGGLEKEYS           = 0x0034;
	const auto SPI_SETTOGGLEKEYS           = 0x0035;
	const auto SPI_GETMOUSEKEYS            = 0x0036;
	const auto SPI_SETMOUSEKEYS            = 0x0037;
	const auto SPI_GETSHOWSOUNDS           = 0x0038;
	const auto SPI_SETSHOWSOUNDS           = 0x0039;
	const auto SPI_GETSTICKYKEYS           = 0x003A;
	const auto SPI_SETSTICKYKEYS           = 0x003B;
	const auto SPI_GETACCESSTIMEOUT        = 0x003C;
	const auto SPI_SETACCESSTIMEOUT        = 0x003D;
	
	const auto SPI_GETSERIALKEYS           = 0x003E;
	const auto SPI_SETSERIALKEYS           = 0x003F;
	
	const auto SPI_GETSOUNDSENTRY          = 0x0040;
	const auto SPI_SETSOUNDSENTRY          = 0x0041;
	
	const auto SPI_GETSNAPTODEFBUTTON      = 0x005F;
	const auto SPI_SETSNAPTODEFBUTTON      = 0x0060;
	
	const auto SPI_GETMOUSEHOVERWIDTH      = 0x0062;
	const auto SPI_SETMOUSEHOVERWIDTH      = 0x0063;
	const auto SPI_GETMOUSEHOVERHEIGHT     = 0x0064;
	const auto SPI_SETMOUSEHOVERHEIGHT     = 0x0065;
	const auto SPI_GETMOUSEHOVERTIME       = 0x0066;
	const auto SPI_SETMOUSEHOVERTIME       = 0x0067;
	const auto SPI_GETWHEELSCROLLLINES     = 0x0068;
	const auto SPI_SETWHEELSCROLLLINES     = 0x0069;
	const auto SPI_GETMENUSHOWDELAY        = 0x006A;
	const auto SPI_SETMENUSHOWDELAY        = 0x006B;
	
	const auto SPI_GETWHEELSCROLLCHARS    = 0x006C;
	const auto SPI_SETWHEELSCROLLCHARS    = 0x006D;
	
	const auto SPI_GETSHOWIMEUI           = 0x006E;
	const auto SPI_SETSHOWIMEUI           = 0x006F;
	
	const auto SPI_GETMOUSESPEED          = 0x0070;
	const auto SPI_SETMOUSESPEED          = 0x0071;
	const auto SPI_GETSCREENSAVERRUNNING  = 0x0072;
	const auto SPI_GETDESKWALLPAPER       = 0x0073;
	
	const auto SPI_GETAUDIODESCRIPTION    = 0x0074;
	const auto SPI_SETAUDIODESCRIPTION    = 0x0075;
	
	const auto SPI_GETSCREENSAVESECURE    = 0x0076;
	const auto SPI_SETSCREENSAVESECURE    = 0x0077;
	
	const auto SPI_GETACTIVEWINDOWTRACKING          = 0x1000;
	const auto SPI_SETACTIVEWINDOWTRACKING          = 0x1001;
	const auto SPI_GETMENUANIMATION                 = 0x1002;
	const auto SPI_SETMENUANIMATION                 = 0x1003;
	const auto SPI_GETCOMBOBOXANIMATION             = 0x1004;
	const auto SPI_SETCOMBOBOXANIMATION             = 0x1005;
	const auto SPI_GETLISTBOXSMOOTHSCROLLING        = 0x1006;
	const auto SPI_SETLISTBOXSMOOTHSCROLLING        = 0x1007;
	const auto SPI_GETGRADIENTCAPTIONS              = 0x1008;
	const auto SPI_SETGRADIENTCAPTIONS              = 0x1009;
	const auto SPI_GETKEYBOARDCUES                  = 0x100A;
	const auto SPI_SETKEYBOARDCUES                  = 0x100B;
	const auto SPI_GETMENUUNDERLINES                = SPI_GETKEYBOARDCUES;
	const auto SPI_SETMENUUNDERLINES                = SPI_SETKEYBOARDCUES;
	const auto SPI_GETACTIVEWNDTRKZORDER            = 0x100C;
	const auto SPI_SETACTIVEWNDTRKZORDER            = 0x100D;
	const auto SPI_GETHOTTRACKING                   = 0x100E;
	const auto SPI_SETHOTTRACKING                   = 0x100F;
	const auto SPI_GETMENUFADE                      = 0x1012;
	const auto SPI_SETMENUFADE                      = 0x1013;
	const auto SPI_GETSELECTIONFADE                 = 0x1014;
	const auto SPI_SETSELECTIONFADE                 = 0x1015;
	const auto SPI_GETTOOLTIPANIMATION              = 0x1016;
	const auto SPI_SETTOOLTIPANIMATION              = 0x1017;
	const auto SPI_GETTOOLTIPFADE                   = 0x1018;
	const auto SPI_SETTOOLTIPFADE                   = 0x1019;
	const auto SPI_GETCURSORSHADOW                  = 0x101A;
	const auto SPI_SETCURSORSHADOW                  = 0x101B;
	
	const auto SPI_GETMOUSESONAR                    = 0x101C;
	const auto SPI_SETMOUSESONAR                    = 0x101D;
	const auto SPI_GETMOUSECLICKLOCK                = 0x101E;
	const auto SPI_SETMOUSECLICKLOCK                = 0x101F;
	const auto SPI_GETMOUSEVANISH                   = 0x1020;
	const auto SPI_SETMOUSEVANISH                   = 0x1021;
	const auto SPI_GETFLATMENU                      = 0x1022;
	const auto SPI_SETFLATMENU                      = 0x1023;
	const auto SPI_GETDROPSHADOW                    = 0x1024;
	const auto SPI_SETDROPSHADOW                    = 0x1025;
	const auto SPI_GETBLOCKSENDINPUTRESETS          = 0x1026;
	const auto SPI_SETBLOCKSENDINPUTRESETS          = 0x1027;
	
	const auto SPI_GETUIEFFECTS                     = 0x103E;
	const auto SPI_SETUIEFFECTS                     = 0x103F;
	
	const auto SPI_GETDISABLEOVERLAPPEDCONTENT      = 0x1040;
	const auto SPI_SETDISABLEOVERLAPPEDCONTENT      = 0x1041;
	const auto SPI_GETCLIENTAREAANIMATION           = 0x1042;
	const auto SPI_SETCLIENTAREAANIMATION           = 0x1043;
	const auto SPI_GETCLEARTYPE                     = 0x1048;
	const auto SPI_SETCLEARTYPE                     = 0x1049;
	const auto SPI_GETSPEECHRECOGNITION             = 0x104A;
	const auto SPI_SETSPEECHRECOGNITION             = 0x104B;
	
	const auto SPI_GETFOREGROUNDLOCKTIMEOUT         = 0x2000;
	const auto SPI_SETFOREGROUNDLOCKTIMEOUT         = 0x2001;
	const auto SPI_GETACTIVEWNDTRKTIMEOUT           = 0x2002;
	const auto SPI_SETACTIVEWNDTRKTIMEOUT           = 0x2003;
	const auto SPI_GETFOREGROUNDFLASHCOUNT          = 0x2004;
	const auto SPI_SETFOREGROUNDFLASHCOUNT          = 0x2005;
	const auto SPI_GETCARETWIDTH                    = 0x2006;
	const auto SPI_SETCARETWIDTH                    = 0x2007;
	
	
	const auto SPI_GETMOUSECLICKLOCKTIME            = 0x2008;
	const auto SPI_SETMOUSECLICKLOCKTIME            = 0x2009;
	const auto SPI_GETFONTSMOOTHINGTYPE             = 0x200A;
	const auto SPI_SETFONTSMOOTHINGTYPE             = 0x200B;
	
	/* constants for SPI_GETFONTSMOOTHINGTYPE and SPI_SETFONTSMOOTHINGTYPE: */
	const auto FE_FONTSMOOTHINGSTANDARD             = 0x0001;
	const auto FE_FONTSMOOTHINGCLEARTYPE            = 0x0002;
	const auto FE_FONTSMOOTHINGDOCKING              = 0x8000;
	
	const auto SPI_GETFONTSMOOTHINGCONTRAST            = 0x200C;
	const auto SPI_SETFONTSMOOTHINGCONTRAST            = 0x200D;
	
	const auto SPI_GETFOCUSBORDERWIDTH              = 0x200E;
	const auto SPI_SETFOCUSBORDERWIDTH              = 0x200F;
	const auto SPI_GETFOCUSBORDERHEIGHT             = 0x2010;
	const auto SPI_SETFOCUSBORDERHEIGHT             = 0x2011;
	
	const auto SPI_GETFONTSMOOTHINGORIENTATION            = 0x2012;
	const auto SPI_SETFONTSMOOTHINGORIENTATION            = 0x2013;
	
	/* constants for SPI_GETFONTSMOOTHINGORIENTATION and SPI_SETFONTSMOOTHINGORIENTATION: */
	const auto FE_FONTSMOOTHINGORIENTATIONBGR    = 0x0000;
	const auto FE_FONTSMOOTHINGORIENTATIONRGB    = 0x0001;
	
	const auto SPI_GETMINIMUMHITRADIUS              = 0x2014;
	const auto SPI_SETMINIMUMHITRADIUS              = 0x2015;
	const auto SPI_GETMESSAGEDURATION               = 0x2016;
	const auto SPI_SETMESSAGEDURATION               = 0x2017;
	
	/*
	 * Flags
	 */
	const auto SPIF_UPDATEINIFILE     = 0x0001;
	const auto SPIF_SENDWININICHANGE  = 0x0002;
	const auto SPIF_SENDCHANGE        = SPIF_SENDWININICHANGE;
	
	
	const auto METRICS_USEDEFAULT  = -1;
	
	version(NOGDI) {
	}
	else {
		struct NONCLIENTMETRICSA {
		    UINT    cbSize;
		    int     iBorderWidth;
		    int     iScrollWidth;
		    int     iScrollHeight;
		    int     iCaptionWidth;
		    int     iCaptionHeight;
		    LOGFONTA lfCaptionFont;
		    int     iSmCaptionWidth;
		    int     iSmCaptionHeight;
		    LOGFONTA lfSmCaptionFont;
		    int     iMenuWidth;
		    int     iMenuHeight;
		    LOGFONTA lfMenuFont;
		    LOGFONTA lfStatusFont;
		    LOGFONTA lfMessageFont;
		    int     iPaddedBorderWidth;
		}
		
		alias NONCLIENTMETRICSA* PNONCLIENTMETRICSA;
		alias NONCLIENTMETRICSA * LPNONCLIENTMETRICSA;
		
		struct NONCLIENTMETRICSW {
		    UINT    cbSize;
		    int     iBorderWidth;
		    int     iScrollWidth;
		    int     iScrollHeight;
		    int     iCaptionWidth;
		    int     iCaptionHeight;
		    LOGFONTW lfCaptionFont;
		    int     iSmCaptionWidth;
		    int     iSmCaptionHeight;
		    LOGFONTW lfSmCaptionFont;
		    int     iMenuWidth;
		    int     iMenuHeight;
		    LOGFONTW lfMenuFont;
		    LOGFONTW lfStatusFont;
		    LOGFONTW lfMessageFont;
		    int     iPaddedBorderWidth;
		}
		
		alias NONCLIENTMETRICSW* PNONCLIENTMETRICSW;
		alias NONCLIENTMETRICSW * LPNONCLIENTMETRICSW;
		
		version(UNICODE) {
			alias NONCLIENTMETRICSW NONCLIENTMETRICS;
			alias PNONCLIENTMETRICSW PNONCLIENTMETRICS;
			alias LPNONCLIENTMETRICSW LPNONCLIENTMETRICS;
		}
		else {
			alias NONCLIENTMETRICSA NONCLIENTMETRICS;
			alias PNONCLIENTMETRICSA PNONCLIENTMETRICS;
			alias LPNONCLIENTMETRICSA LPNONCLIENTMETRICS;
		}
	}
	
	const auto ARW_BOTTOMLEFT               = 0x0000;
	const auto ARW_BOTTOMRIGHT              = 0x0001;
	const auto ARW_TOPLEFT                  = 0x0002;
	const auto ARW_TOPRIGHT                 = 0x0003;
	const auto ARW_STARTMASK                = 0x0003;
	const auto ARW_STARTRIGHT               = 0x0001;
	const auto ARW_STARTTOP                 = 0x0002;
	
	const auto ARW_LEFT                     = 0x0000;
	const auto ARW_RIGHT                    = 0x0000;
	const auto ARW_UP                       = 0x0004;
	const auto ARW_DOWN                     = 0x0004;
	const auto ARW_HIDE                     = 0x0008;
	
	struct MINIMIZEDMETRICS {
	    UINT    cbSize;
	    int     iWidth;
	    int     iHorzGap;
	    int     iVertGap;
	    int     iArrange;
	}
	
	alias MINIMIZEDMETRICS* PMINIMIZEDMETRICS;
	alias MINIMIZEDMETRICS* LPMINIMIZEDMETRICS;
	
	version(NOGDI) {
	}
	else {
		struct ICONMETRICSA {
		    UINT    cbSize;
		    int     iHorzSpacing;
		    int     iVertSpacing;
		    int     iTitleWrap;
		    LOGFONTA lfFont;
		}
	
		alias ICONMETRICSA* PICONMETRICSA;
		alias ICONMETRICSA* LPICONMETRICSA;
		struct ICONMETRICSW {
		    UINT    cbSize;
		    int     iHorzSpacing;
		    int     iVertSpacing;
		    int     iTitleWrap;
		    LOGFONTW lfFont;
		}
		
		alias ICONMETRICSW* PICONMETRICSW;
		alias ICONMETRICSW* LPICONMETRICSW;
		
		version(UNICODE) {
			alias ICONMETRICSW ICONMETRICS;
			alias PICONMETRICSW PICONMETRICS;
			alias LPICONMETRICSW LPICONMETRICS;
		}
		else {
			alias ICONMETRICSA ICONMETRICS;
			alias PICONMETRICSA PICONMETRICS;
			alias LPICONMETRICSA LPICONMETRICS;
		}
	}
	
	struct ANIMATIONINFO {
	    UINT    cbSize;
	    int     iMinAnimate;
	}
	
	alias ANIMATIONINFO* LPANIMATIONINFO;
	
	struct SERIALKEYSA {
	    UINT    cbSize;
	    DWORD   dwFlags;
	    LPSTR     lpszActivePort;
	    LPSTR     lpszPort;
	    UINT    iBaudRate;
	    UINT    iPortState;
	    UINT    iActive;
	}
	
	alias SERIALKEYSA* LPSERIALKEYSA;
	struct SERIALKEYSW {
	    UINT    cbSize;
	    DWORD   dwFlags;
	    LPWSTR    lpszActivePort;
	    LPWSTR    lpszPort;
	    UINT    iBaudRate;
	    UINT    iPortState;
	    UINT    iActive;
	}
	
	alias SERIALKEYSW* LPSERIALKEYSW;
	
	version(UNICODE) {
		alias SERIALKEYSW SERIALKEYS;
		alias LPSERIALKEYSW LPSERIALKEYS;
	}
	else {
		alias SERIALKEYSA SERIALKEYS;
		alias LPSERIALKEYSA LPSERIALKEYS;
	}
	
	/* flags for SERIALKEYS dwFlags field */
	const auto SERKF_SERIALKEYSON   = 0x00000001;
	const auto SERKF_AVAILABLE      = 0x00000002;
	const auto SERKF_INDICATOR      = 0x00000004;
	
	
	struct HIGHCONTRASTA {
	    UINT    cbSize;
	    DWORD   dwFlags;
	    LPSTR   lpszDefaultScheme;
	}
	
	alias HIGHCONTRASTA* LPHIGHCONTRASTA;
	struct HIGHCONTRASTW {
	    UINT    cbSize;
	    DWORD   dwFlags;
	    LPWSTR  lpszDefaultScheme;
	}
	
	alias HIGHCONTRASTW* LPHIGHCONTRASTW;
	
	version(UNICODE) {
		alias HIGHCONTRASTW HIGHCONTRAST;
		alias LPHIGHCONTRASTW LPHIGHCONTRAST;
	}
	else {
		alias HIGHCONTRASTA HIGHCONTRAST;
		alias LPHIGHCONTRASTA LPHIGHCONTRAST;
	}
	
	/* flags for HIGHCONTRAST dwFlags field */
	const auto HCF_HIGHCONTRASTON   = 0x00000001;
	const auto HCF_AVAILABLE        = 0x00000002;
	const auto HCF_HOTKEYACTIVE     = 0x00000004;
	const auto HCF_CONFIRMHOTKEY    = 0x00000008;
	const auto HCF_HOTKEYSOUND      = 0x00000010;
	const auto HCF_INDICATOR        = 0x00000020;
	const auto HCF_HOTKEYAVAILABLE  = 0x00000040;
	const auto HCF_LOGONDESKTOP     = 0x00000100;
	const auto HCF_DEFAULTDESKTOP   = 0x00000200;
	
	/* Flags for ChangeDisplaySettings */
	const auto CDS_UPDATEREGISTRY            = 0x00000001;
	const auto CDS_TEST                      = 0x00000002;
	const auto CDS_FULLSCREEN                = 0x00000004;
	const auto CDS_GLOBAL                    = 0x00000008;
	const auto CDS_SET_PRIMARY               = 0x00000010;
	const auto CDS_VIDEOPARAMETERS           = 0x00000020;
	
	const auto CDS_ENABLE_UNSAFE_MODES       = 0x00000100;
	const auto CDS_DISABLE_UNSAFE_MODES      = 0x00000200;
	
	const auto CDS_RESET                     = 0x40000000;
	const auto CDS_NORESET                   = 0x10000000;
	
	// XXX: #include <tvout.h>
	
	/* Return values for ChangeDisplaySettings */
	const auto DISP_CHANGE_SUCCESSFUL        = 0;
	const auto DISP_CHANGE_RESTART           = 1;
	const auto DISP_CHANGE_FAILED           = -1;
	const auto DISP_CHANGE_BADMODE          = -2;
	const auto DISP_CHANGE_NOTUPDATED       = -3;
	const auto DISP_CHANGE_BADFLAGS         = -4;
	const auto DISP_CHANGE_BADPARAM         = -5;
	
	const auto DISP_CHANGE_BADDUALVIEW      = -6;
	
	version(NOGDI) {
	}
	else {
		LONG ChangeDisplaySettingsA(
		     LPDEVMODEA lpDevMode,
		     DWORD dwFlags);
		
		LONG ChangeDisplaySettingsW(
		     LPDEVMODEW lpDevMode,
		     DWORD dwFlags);
		
		version(UNICODE) {
			alias ChangeDisplaySettingsW ChangeDisplaySettings;
		}
		else {
			alias ChangeDisplaySettingsA ChangeDisplaySettings;
		}

		LONG ChangeDisplaySettingsExA(
		     LPCSTR lpszDeviceName,
		     LPDEVMODEA lpDevMode,
		    HWND hwnd,
		     DWORD dwflags,
		     LPVOID lParam);
		
		LONG ChangeDisplaySettingsExW(
		     LPCWSTR lpszDeviceName,
		     LPDEVMODEW lpDevMode,
		    HWND hwnd,
		     DWORD dwflags,
		     LPVOID lParam);
		
		version(UNICODE) {
			alias ChangeDisplaySettingsExW ChangeDisplaySettingsEx;
		}
		else {
			alias ChangeDisplaySettingsExA ChangeDisplaySettingsEx;
		}
		
		const auto ENUM_CURRENT_SETTINGS        = (cast(DWORD)-1);
		const auto ENUM_REGISTRY_SETTINGS       = (cast(DWORD)-2);
		
		BOOL EnumDisplaySettingsA(
		     LPCSTR lpszDeviceName,
		     DWORD iModeNum,
		     LPDEVMODEA lpDevMode);
		BOOL EnumDisplaySettingsW(
		     LPCWSTR lpszDeviceName,
		     DWORD iModeNum,
		     LPDEVMODEW lpDevMode);
		
		version(UNICODE) {
			alias EnumDisplaySettingsW EnumDisplaySettings;
		}
		else {
			alias EnumDisplaySettingsA EnumDisplaySettings;
		}
		
		BOOL EnumDisplaySettingsExA(
		     LPCSTR lpszDeviceName,
		     DWORD iModeNum,
		     LPDEVMODEA lpDevMode,
		     DWORD dwFlags);
		
		BOOL EnumDisplaySettingsExW(
		     LPCWSTR lpszDeviceName,
		     DWORD iModeNum,
		     LPDEVMODEW lpDevMode,
		     DWORD dwFlags);
		
		version(UNICODE) {
			alias EnumDisplaySettingsExW EnumDisplaySettingsEx;
		}
		else {
			alias EnumDisplaySettingsExA EnumDisplaySettingsEx;
		}
		
		/* Flags for EnumDisplaySettingsEx */
		const auto EDS_RAWMODE                    = 0x00000002;
		const auto EDS_ROTATEDMODE                = 0x00000004;
		
		BOOL EnumDisplayDevicesA(
		     LPCSTR lpDevice,
		     DWORD iDevNum,
		     PDISPLAY_DEVICEA lpDisplayDevice,
		     DWORD dwFlags);
		
		BOOL EnumDisplayDevicesW(
		     LPCWSTR lpDevice,
		     DWORD iDevNum,
		     PDISPLAY_DEVICEW lpDisplayDevice,
		     DWORD dwFlags);
		
		version(UNICODE) {
			alias EnumDisplayDevicesW EnumDisplayDevices;
		}
		else {
			alias EnumDisplayDevicesA EnumDisplayDevices;
		}
	
		/* Flags for EnumDisplayDevices */
		const auto EDD_GET_DEVICE_INTERFACE_NAME  = 0x00000001;
	}
	
	BOOL SystemParametersInfoA(
	     UINT uiAction,
	     UINT uiParam,
	     PVOID pvParam,
	     UINT fWinIni);
	
	BOOL SystemParametersInfoW(
	     UINT uiAction,
	     UINT uiParam,
	     PVOID pvParam,
	     UINT fWinIni);

	version(UNICODE) {
		alias SystemParametersInfoW SystemParametersInfo;
	}
	else {
		alias SystemParametersInfoA SystemParametersInfo;
	}
}

/*
 * Accessibility support
 */
struct FILTERKEYS {
    UINT  cbSize;
    DWORD dwFlags;
    DWORD iWaitMSec;            // Acceptance Delay
    DWORD iDelayMSec;           // Delay Until Repeat
    DWORD iRepeatMSec;          // Repeat Rate
    DWORD iBounceMSec;          // Debounce Time
}

alias FILTERKEYS* LPFILTERKEYS;

/*
 * FILTERKEYS dwFlags field
 */
const auto FKF_FILTERKEYSON     = 0x00000001;
const auto FKF_AVAILABLE        = 0x00000002;
const auto FKF_HOTKEYACTIVE     = 0x00000004;
const auto FKF_CONFIRMHOTKEY    = 0x00000008;
const auto FKF_HOTKEYSOUND      = 0x00000010;
const auto FKF_INDICATOR        = 0x00000020;
const auto FKF_CLICKON          = 0x00000040;

struct STICKYKEYS {
    UINT  cbSize;
    DWORD dwFlags;
}

alias STICKYKEYS* LPSTICKYKEYS;

/*
 * STICKYKEYS dwFlags field
 */
const auto SKF_STICKYKEYSON     = 0x00000001;
const auto SKF_AVAILABLE        = 0x00000002;
const auto SKF_HOTKEYACTIVE     = 0x00000004;
const auto SKF_CONFIRMHOTKEY    = 0x00000008;
const auto SKF_HOTKEYSOUND      = 0x00000010;
const auto SKF_INDICATOR        = 0x00000020;
const auto SKF_AUDIBLEFEEDBACK  = 0x00000040;
const auto SKF_TRISTATE         = 0x00000080;
const auto SKF_TWOKEYSOFF       = 0x00000100;

const auto SKF_LALTLATCHED        = 0x10000000;
const auto SKF_LCTLLATCHED        = 0x04000000;
const auto SKF_LSHIFTLATCHED      = 0x01000000;
const auto SKF_RALTLATCHED        = 0x20000000;
const auto SKF_RCTLLATCHED        = 0x08000000;
const auto SKF_RSHIFTLATCHED      = 0x02000000;
const auto SKF_LWINLATCHED        = 0x40000000;
const auto SKF_RWINLATCHED        = 0x80000000;
const auto SKF_LALTLOCKED         = 0x00100000;
const auto SKF_LCTLLOCKED         = 0x00040000;
const auto SKF_LSHIFTLOCKED       = 0x00010000;
const auto SKF_RALTLOCKED         = 0x00200000;
const auto SKF_RCTLLOCKED         = 0x00080000;
const auto SKF_RSHIFTLOCKED       = 0x00020000;
const auto SKF_LWINLOCKED         = 0x00400000;
const auto SKF_RWINLOCKED         = 0x00800000;

struct MOUSEKEYS {
    UINT cbSize;
    DWORD dwFlags;
    DWORD iMaxSpeed;
    DWORD iTimeToMaxSpeed;
    DWORD iCtrlSpeed;
    DWORD dwReserved1;
    DWORD dwReserved2;
}

alias MOUSEKEYS* LPMOUSEKEYS;

/*
 * MOUSEKEYS dwFlags field
 */
const auto MKF_MOUSEKEYSON      = 0x00000001;
const auto MKF_AVAILABLE        = 0x00000002;
const auto MKF_HOTKEYACTIVE     = 0x00000004;
const auto MKF_CONFIRMHOTKEY    = 0x00000008;
const auto MKF_HOTKEYSOUND      = 0x00000010;
const auto MKF_INDICATOR        = 0x00000020;
const auto MKF_MODIFIERS        = 0x00000040;
const auto MKF_REPLACENUMBERS   = 0x00000080;

const auto MKF_LEFTBUTTONSEL    = 0x10000000;
const auto MKF_RIGHTBUTTONSEL   = 0x20000000;
const auto MKF_LEFTBUTTONDOWN   = 0x01000000;
const auto MKF_RIGHTBUTTONDOWN  = 0x02000000;
const auto MKF_MOUSEMODE        = 0x80000000;

struct ACCESSTIMEOUT {
    UINT  cbSize;
    DWORD dwFlags;
    DWORD iTimeOutMSec;
}

alias ACCESSTIMEOUT* LPACCESSTIMEOUT;

/*
 * ACCESSTIMEOUT dwFlags field
 */
const auto ATF_TIMEOUTON        = 0x00000001;
const auto ATF_ONOFFFEEDBACK    = 0x00000002;

/* values for SOUNDSENTRY iFSGrafEffect field */
const auto SSGF_NONE        = 0;
const auto SSGF_DISPLAY     = 3;

/* values for SOUNDSENTRY iFSTextEffect field */
const auto SSTF_NONE        = 0;
const auto SSTF_CHARS       = 1;
const auto SSTF_BORDER      = 2;
const auto SSTF_DISPLAY     = 3;

/* values for SOUNDSENTRY iWindowsEffect field */
const auto SSWF_NONE      = 0;
const auto SSWF_TITLE     = 1;
const auto SSWF_WINDOW    = 2;
const auto SSWF_DISPLAY   = 3;
const auto SSWF_CUSTOM    = 4;

struct SOUNDSENTRYA {
    UINT cbSize;
    DWORD dwFlags;
    DWORD iFSTextEffect;
    DWORD iFSTextEffectMSec;
    DWORD iFSTextEffectColorBits;
    DWORD iFSGrafEffect;
    DWORD iFSGrafEffectMSec;
    DWORD iFSGrafEffectColor;
    DWORD iWindowsEffect;
    DWORD iWindowsEffectMSec;
    LPSTR   lpszWindowsEffectDL;
    DWORD iWindowsEffectOrdinal;
}

alias SOUNDSENTRYA* LPSOUNDSENTRYA;

struct SOUNDSENTRYW {
    UINT cbSize;
    DWORD dwFlags;
    DWORD iFSTextEffect;
    DWORD iFSTextEffectMSec;
    DWORD iFSTextEffectColorBits;
    DWORD iFSGrafEffect;
    DWORD iFSGrafEffectMSec;
    DWORD iFSGrafEffectColor;
    DWORD iWindowsEffect;
    DWORD iWindowsEffectMSec;
    LPWSTR  lpszWindowsEffectDL;
    DWORD iWindowsEffectOrdinal;
}

alias SOUNDSENTRYW* LPSOUNDSENTRYW;

version(UNICODE) {
	alias SOUNDSENTRYW SOUNDSENTRY;
	alias LPSOUNDSENTRYW LPSOUNDSENTRY;
}
else {
	alias SOUNDSENTRYA SOUNDSENTRY;
	alias LPSOUNDSENTRYA LPSOUNDSENTRY;
}

/*
 * SOUNDSENTRY dwFlags field
 */
const auto SSF_SOUNDSENTRYON    = 0x00000001;
const auto SSF_AVAILABLE        = 0x00000002;
const auto SSF_INDICATOR        = 0x00000004;

BOOL SoundSentry();

struct TOGGLEKEYS {
    UINT cbSize;
    DWORD dwFlags;
}

alias TOGGLEKEYS* LPTOGGLEKEYS;

/*
 * TOGGLEKEYS dwFlags field
 */
const auto TKF_TOGGLEKEYSON     = 0x00000001;
const auto TKF_AVAILABLE        = 0x00000002;
const auto TKF_HOTKEYACTIVE     = 0x00000004;
const auto TKF_CONFIRMHOTKEY    = 0x00000008;
const auto TKF_HOTKEYSOUND      = 0x00000010;
const auto TKF_INDICATOR        = 0x00000020;

struct AUDIODESCRIPTION {
    UINT cbSize;   // sizeof(AudioDescriptionType)
    BOOL Enabled;  // On/Off
    LCID Locale;   // locale ID for language
}

alias AUDIODESCRIPTION* LPAUDIODESCRIPTION;

/*
 * Set debug level
 */

VOID SetDebugErrorLevel(
     DWORD dwLevel);

/*
 * SetLastErrorEx() types.
 */

const auto SLE_ERROR        = 0x00000001;
const auto SLE_MINORERROR   = 0x00000002;
const auto SLE_WARNING      = 0x00000003;

VOID SetLastErrorEx(
     DWORD dwErrCode,
     DWORD dwType);

int InternalGetWindowText(
     HWND hWnd,
	 LPWSTR pString,
     int cchMaxCount);

BOOL EndTask(
     HWND hWnd,
     BOOL fShutDown,
     BOOL fForce);

BOOL CancelShutdown();

/*
 * Multimonitor API.
 */

const auto MONITOR_DEFAULTTONULL        = 0x00000000;
const auto MONITOR_DEFAULTTOPRIMARY     = 0x00000001;
const auto MONITOR_DEFAULTTONEAREST     = 0x00000002;

HMONITOR MonitorFromPoint(
     POINT pt,
     DWORD dwFlags);

HMONITOR MonitorFromRect(
     LPCRECT lprc,
     DWORD dwFlags);

HMONITOR MonitorFromWindow(
     HWND hwnd,
     DWORD dwFlags);

const auto MONITORINFOF_PRIMARY         = 0x00000001;

const auto CCHDEVICENAME  = 32;

struct MONITORINFO {
    DWORD   cbSize;
    RECT    rcMonitor;
    RECT    rcWork;
    DWORD   dwFlags;
}

alias MONITORINFO* LPMONITORINFO;

struct MONITORINFOEXA {
    CHAR[CCHDEVICENAME]        szDevice;
}

alias MONITORINFOEXA* LPMONITORINFOEXA;

struct MONITORINFOEXW {
    WCHAR[CCHDEVICENAME]       szDevice;
}

alias MONITORINFOEXW* LPMONITORINFOEXW;

version(UNICODE) {
	alias MONITORINFOEXW MONITORINFOEX;
	alias LPMONITORINFOEXW LPMONITORINFOEX;
}
else {
	alias MONITORINFOEXA MONITORINFOEX;
	alias LPMONITORINFOEXA LPMONITORINFOEX;
}

BOOL GetMonitorInfoA(
     HMONITOR hMonitor,
     LPMONITORINFO lpmi);

BOOL GetMonitorInfoW(
     HMONITOR hMonitor,
     LPMONITORINFO lpmi);

version(UNICODE) {
	alias GetMonitorInfoW GetMonitorInfo;
}
else {
	alias GetMonitorInfoA GetMonitorInfo;
}

alias BOOL function(HMONITOR, HDC, LPRECT, LPARAM) MONITORENUMPROC;

BOOL EnumDisplayMonitors(
     HDC hdc,
     LPCRECT lprcClip,
     MONITORENUMPROC lpfnEnum,
     LPARAM dwData);

version(NOWINABLE) {
}
else {
	/*
	 * WinEvents - Active Accessibility hooks
	 */
	
	VOID NotifyWinEvent(
	     DWORD event,
	     HWND  hwnd,
	     LONG  idObject,
	     LONG  idChild);
	
	alias VOID function(
	    HWINEVENTHOOK hWinEventHook,
	    DWORD         event,
	    HWND          hwnd,
	    LONG          idObject,
	    LONG          idChild,
	    DWORD         idEventThread,
	    DWORD         dwmsEventTime) WINEVENTPROC;
	
	HWINEVENTHOOK SetWinEventHook(
	     DWORD eventMin,
	     DWORD eventMax,
	     HMODULE hmodWinEventProc,
	     WINEVENTPROC pfnWinEventProc,
	     DWORD idProcess,
	     DWORD idThread,
	     DWORD dwFlags);
	
	BOOL IsWinEventHookInstalled(
	     DWORD event);
	
	/*
	 * dwFlags for SetWinEventHook
	 */
	const auto WINEVENT_OUTOFCONTEXT    = 0x0000  ; // Events are ASYNC
	const auto WINEVENT_SKIPOWNTHREAD   = 0x0001  ; // Don't call back for events on installer's thread
	const auto WINEVENT_SKIPOWNPROCESS  = 0x0002  ; // Don't call back for events on installer's process
	const auto WINEVENT_INCONTEXT       = 0x0004  ; // Events are SYNC, this causes your dll to be injected into every process
	
	BOOL UnhookWinEvent(
	     HWINEVENTHOOK hWinEventHook);
	
	/*
	 * idObject values for WinEventProc and NotifyWinEvent
	 */
	
	/*
	 * hwnd + idObject can be used with OLEACC.DLL's OleGetObjectFromWindow()
	 * to get an interface pointer to the container.  indexChild is the item
	 * within the container in question.  Setup a VARIANT with vt VT_I4 and
	 * lVal the indexChild and pass that in to all methods.  Then you
	 * are raring to go.
	 */
	
	
	/*
	 * Common object IDs (cookies, only for sending WM_GETOBJECT to get at the
	 * thing in question).  Positive IDs are reserved for apps (app specific),
	 * negative IDs are system things and are global, 0 means "just little old
	 * me".
	 */
	const auto      CHILDID_SELF        = 0;
	const auto      INDEXID_OBJECT      = 0;
	const auto      INDEXID_CONTAINER   = 0;

	/*
	 * Reserved IDs for system objects
	 */
	const auto      OBJID_WINDOW        = (cast(LONG)0x00000000);
	const auto      OBJID_SYSMENU       = (cast(LONG)0xFFFFFFFF);
	const auto      OBJID_TITLEBAR      = (cast(LONG)0xFFFFFFFE);
	const auto      OBJID_MENU          = (cast(LONG)0xFFFFFFFD);
	const auto      OBJID_CLIENT        = (cast(LONG)0xFFFFFFFC);
	const auto      OBJID_VSCROLL       = (cast(LONG)0xFFFFFFFB);
	const auto      OBJID_HSCROLL       = (cast(LONG)0xFFFFFFFA);
	const auto      OBJID_SIZEGRIP      = (cast(LONG)0xFFFFFFF9);
	const auto      OBJID_CARET         = (cast(LONG)0xFFFFFFF8);
	const auto      OBJID_CURSOR        = (cast(LONG)0xFFFFFFF7);
	const auto      OBJID_ALERT         = (cast(LONG)0xFFFFFFF6);
	const auto      OBJID_SOUND         = (cast(LONG)0xFFFFFFF5);
	const auto      OBJID_QUERYCLASSNAMEIDX = (cast(LONG)0xFFFFFFF4);
	const auto      OBJID_NATIVEOM      = (cast(LONG)0xFFFFFFF0);
	
	/*
	 * EVENT DEFINITION
	 */
	const auto EVENT_MIN            = 0x00000001;
	const auto EVENT_MAX            = 0x7FFFFFFF;
	
	
	/*
	 *  EVENT_SYSTEM_SOUND
	 *  Sent when a sound is played.  Currently nothing is generating this, we
	 *  this event when a system sound (for menus, etc) is played.  Apps
	 *  generate this, if accessible, when a private sound is played.  For
	 *  example, if Mail plays a "New Mail" sound.
	 *
	 *  System Sounds:
	 *  (Generated by PlaySoundEvent in USER itself)
	 *      hwnd            is NULL
	 *      idObject        is OBJID_SOUND
	 *      idChild         is sound child ID if one
	 *  App Sounds:
	 *  (PlaySoundEvent won't generate notification; up to app)
	 *      hwnd + idObject gets interface pointer to Sound object
	 *      idChild identifies the sound in question
	 *  are going to be cleaning up the SOUNDSENTRY feature in the control panel
	 *  and will use this at that time.  Applications implementing WinEvents
	 *  are perfectly welcome to use it.  Clients of IAccessible* will simply
	 *  turn around and get back a non-visual object that describes the sound.
	 */
	const auto EVENT_SYSTEM_SOUND               = 0x0001;
	
	/*
	 * EVENT_SYSTEM_ALERT
	 * System Alerts:
	 * (Generated by MessageBox() calls for example)
	 *      hwnd            is hwndMessageBox
	 *      idObject        is OBJID_ALERT
	 * App Alerts:
	 * (Generated whenever)
	 *      hwnd+idObject gets interface pointer to Alert
	 */
	const auto EVENT_SYSTEM_ALERT               = 0x0002;
	
	/*
	 * EVENT_SYSTEM_FOREGROUND
	 * Sent when the foreground (active) window changes, even if it is changing
	 * to another window in the same thread as the previous one.
	 *      hwnd            is hwndNewForeground
	 *      idObject        is OBJID_WINDOW
	 *      idChild    is INDEXID_OBJECT
	 */
	const auto EVENT_SYSTEM_FOREGROUND          = 0x0003;
	
	/*
	 * Menu
	 *      hwnd            is window (top level window or popup menu window)
	 *      idObject        is ID of control (OBJID_MENU, OBJID_SYSMENU, OBJID_SELF for popup)
	 *      idChild         is CHILDID_SELF
	 *
	 * EVENT_SYSTEM_MENUSTART
	 * EVENT_SYSTEM_MENUEND
	 * For MENUSTART, hwnd+idObject+idChild refers to the control with the menu bar,
	 *  or the control bringing up the context menu.
	 *
	 * Sent when entering into and leaving from menu mode (system, app bar, and
	 * track popups).
	 */
	const auto EVENT_SYSTEM_MENUSTART           = 0x0004;
	const auto EVENT_SYSTEM_MENUEND             = 0x0005;
	
	/*
	 * EVENT_SYSTEM_MENUPOPUPSTART
	 * EVENT_SYSTEM_MENUPOPUPEND
	 * Sent when a menu popup comes up and just before it is taken down.  Note
	 * that for a call to TrackPopupMenu(), a client will see EVENT_SYSTEM_MENUSTART
	 * followed almost immediately by EVENT_SYSTEM_MENUPOPUPSTART for the popup
	 * being shown.
	 *
	 * For MENUPOPUP, hwnd+idObject+idChild refers to the NEW popup coming up, not the
	 * parent item which is hierarchical.  You can get the parent menu/popup by
	 * asking for the accParent object.
	 */
	const auto EVENT_SYSTEM_MENUPOPUPSTART      = 0x0006;
	const auto EVENT_SYSTEM_MENUPOPUPEND        = 0x0007;
	
	
	/*
	 * EVENT_SYSTEM_CAPTURESTART
	 * EVENT_SYSTEM_CAPTUREEND
	 * Sent when a window takes the capture and releases the capture.
	 */
	const auto EVENT_SYSTEM_CAPTURESTART        = 0x0008;
	const auto EVENT_SYSTEM_CAPTUREEND          = 0x0009;
	
	/*
	 * Move Size
	 * EVENT_SYSTEM_MOVESIZESTART
	 * EVENT_SYSTEM_MOVESIZEEND
	 * Sent when a window enters and leaves move-size dragging mode.
	 */
	const auto EVENT_SYSTEM_MOVESIZESTART       = 0x000A;
	const auto EVENT_SYSTEM_MOVESIZEEND         = 0x000B;
	
	/*
	 * Context Help
	 * EVENT_SYSTEM_CONTEXTHELPSTART
	 * EVENT_SYSTEM_CONTEXTHELPEND
	 * Sent when a window enters and leaves context sensitive help mode.
	 */
	const auto EVENT_SYSTEM_CONTEXTHELPSTART    = 0x000C;
	const auto EVENT_SYSTEM_CONTEXTHELPEND      = 0x000D;
	
	/*
	 * Drag & Drop
	 * EVENT_SYSTEM_DRAGDROPSTART
	 * EVENT_SYSTEM_DRAGDROPEND
	 * Send the START notification just before going into drag&drop loop.  Send
	 * the END notification just after canceling out.
	 * Note that it is up to apps and OLE to generate this, since the system
	 * doesn't know.  Like EVENT_SYSTEM_SOUND, it will be a while before this
	 * is prevalent.
	 */
	const auto EVENT_SYSTEM_DRAGDROPSTART       = 0x000E;
	const auto EVENT_SYSTEM_DRAGDROPEND         = 0x000F;
	
	/*
	 * Dialog
	 * Send the START notification right after the dialog is completely
	 *  initialized and visible.  Send the END right before the dialog
	 *  is hidden and goes away.
	 * EVENT_SYSTEM_DIALOGSTART
	 * EVENT_SYSTEM_DIALOGEND
	 */
	const auto EVENT_SYSTEM_DIALOGSTART         = 0x0010;
	const auto EVENT_SYSTEM_DIALOGEND           = 0x0011;
	
	/*
	 * EVENT_SYSTEM_SCROLLING
	 * EVENT_SYSTEM_SCROLLINGSTART
	 * EVENT_SYSTEM_SCROLLINGEND
	 * Sent when beginning and ending the tracking of a scrollbar in a window,
	 * and also for scrollbar controls.
	 */
	const auto EVENT_SYSTEM_SCROLLINGSTART      = 0x0012;
	const auto EVENT_SYSTEM_SCROLLINGEND        = 0x0013;
	
	/*
	 * Alt-Tab Window
	 * Send the START notification right after the switch window is initialized
	 * and visible.  Send the END right before it is hidden and goes away.
	 * EVENT_SYSTEM_SWITCHSTART
	 * EVENT_SYSTEM_SWITCHEND
	 */
	const auto EVENT_SYSTEM_SWITCHSTART         = 0x0014;
	const auto EVENT_SYSTEM_SWITCHEND           = 0x0015;
	
	/*
	 * EVENT_SYSTEM_MINIMIZESTART
	 * EVENT_SYSTEM_MINIMIZEEND
	 * Sent when a window minimizes and just before it restores.
	 */
	const auto EVENT_SYSTEM_MINIMIZESTART       = 0x0016;
	const auto EVENT_SYSTEM_MINIMIZEEND         = 0x0017;
	
	const auto EVENT_SYSTEM_DESKTOPSWITCH       = 0x0020;
	
	const auto EVENT_CONSOLE_CARET              = 0x4001;
	const auto EVENT_CONSOLE_UPDATE_REGION      = 0x4002;
	const auto EVENT_CONSOLE_UPDATE_SIMPLE      = 0x4003;
	const auto EVENT_CONSOLE_UPDATE_SCROLL      = 0x4004;
	const auto EVENT_CONSOLE_LAYOUT             = 0x4005;
	const auto EVENT_CONSOLE_START_APPLICATION  = 0x4006;
	const auto EVENT_CONSOLE_END_APPLICATION    = 0x4007;
	
	/*
	 * Flags for EVENT_CONSOLE_START/END_APPLICATION.
	 */
	version(X86_64) {
		const auto CONSOLE_APPLICATION_16BIT        = 0x0000;
	}
	else {
		const auto CONSOLE_APPLICATION_16BIT        = 0x0001;
	}
	
	/*
	 * Flags for EVENT_CONSOLE_CARET
	 */
	const auto CONSOLE_CARET_SELECTION          = 0x0001;
	const auto CONSOLE_CARET_VISIBLE            = 0x0002;
	
	/*
	 * Object events
	 *
	 * The system AND apps generate these.  The system generates these for
	 * real windows.  Apps generate these for objects within their window which
	 * act like a separate control, e.g. an item in a list view.
	 *
	 * When the system generate them, dwParam2 is always WMOBJID_SELF.  When
	 * apps generate them, apps put the has-meaning-to-the-app-only ID value
	 * in dwParam2.
	 * For all events, if you want detailed accessibility information, callers
	 * should
	 *      * Call AccessibleObjectFromWindow() with the hwnd, idObject parameters
	 *          of the event, and IID_IAccessible as the REFIID, to get back an
	 *          IAccessible* to talk to
	 *      * Initialize and fill in a VARIANT as VT_I4 with lVal the idChild
	 *          parameter of the event.
	 *      * If idChild isn't zero, call get_accChild() in the container to see
	 *          if the child is an object in its own right.  If so, you will get
	 *          back an IDispatch* object for the child.  You should release the
	 *          parent, and call QueryInterface() on the child object to get its
	 *          IAccessible*.  Then you talk directly to the child.  Otherwise,
	 *          if get_accChild() returns you nothing, you should continue to
	 *          use the child VARIANT.  You will ask the container for the properties
	 *          of the child identified by the VARIANT.  In other words, the
	 *          child in this case is accessible but not a full-blown object.
	 *          Like a button on a titlebar which is 'small' and has no children.
	 */
	
	/*
	 * For all EVENT_OBJECT events,
	 *      hwnd is the dude to Send the WM_GETOBJECT message to (unless NULL,
	 *          see above for system things)
	 *      idObject is the ID of the object that can resolve any queries a
	 *          client might have.  It's a way to deal with windowless controls,
	 *          controls that are just drawn on the screen in some larger parent
	 *          window (like SDM), or standard frame elements of a window.
	 *      idChild is the piece inside of the object that is affected.  This
	 *          allows clients to access things that are too small to have full
	 *          blown objects in their own right.  Like the thumb of a scrollbar.
	 *          The hwnd/idObject pair gets you to the container, the dude you
	 *          probably want to talk to most of the time anyway.  The idChild
	 *          can then be passed into the acc properties to get the name/value
	 *          of it as needed.
	 *
	 * Example #1:
	 *      System propagating a listbox selection change
	 *      EVENT_OBJECT_SELECTION
	 *          hwnd == listbox hwnd
	 *          idObject == OBJID_WINDOW
	 *          idChild == new selected item, or CHILDID_SELF if
	 *              nothing now selected within container.
	 *      Word '97 propagating a listbox selection change
	 *          hwnd == SDM window
	 *          idObject == SDM ID to get at listbox 'control'
	 *          idChild == new selected item, or CHILDID_SELF if
	 *              nothing
	 *
	 * Example #2:
	 *      System propagating a menu item selection on the menu bar
	 *      EVENT_OBJECT_SELECTION
	 *          hwnd == top level window
	 *          idObject == OBJID_MENU
	 *          idChild == ID of child menu bar item selected
	 *
	 * Example #3:
	 *      System propagating a dropdown coming off of said menu bar item
	 *      EVENT_OBJECT_CREATE
	 *          hwnd == popup item
	 *          idObject == OBJID_WINDOW
	 *          idChild == CHILDID_SELF
	 *
	 * Example #4:
	 *
	 * For EVENT_OBJECT_REORDER, the object referred to by hwnd/idObject is the
	 * PARENT container in which the zorder is occurring.  This is because if
	 * one child is zordering, all of them are changing their relative zorder.
	 */
	const auto EVENT_OBJECT_CREATE                  = 0x8000  ; // hwnd + ID + idChild is created item
	const auto EVENT_OBJECT_DESTROY                 = 0x8001  ; // hwnd + ID + idChild is destroyed item
	const auto EVENT_OBJECT_SHOW                    = 0x8002  ; // hwnd + ID + idChild is shown item
	const auto EVENT_OBJECT_HIDE                    = 0x8003  ; // hwnd + ID + idChild is hidden item
	const auto EVENT_OBJECT_REORDER                 = 0x8004  ; // hwnd + ID + idChild is parent of zordering children
	/*
	 * NOTE:
	 * Minimize the number of notifications!
	 *
	 * When you are hiding a parent object, obviously all child objects are no
	 * longer visible on screen.  They still have the same "visible" status,
	 * but are not truly visible.  Hence do not send HIDE notifications for the
	 * children also.  One implies all.  The same goes for SHOW.
	 */
	
	
	const auto EVENT_OBJECT_FOCUS                   = 0x8005  ; // hwnd + ID + idChild is focused item
	const auto EVENT_OBJECT_SELECTION               = 0x8006  ; // hwnd + ID + idChild is selected item (if only one), or idChild is OBJID_WINDOW if complex
	const auto EVENT_OBJECT_SELECTIONADD            = 0x8007  ; // hwnd + ID + idChild is item added
	const auto EVENT_OBJECT_SELECTIONREMOVE         = 0x8008  ; // hwnd + ID + idChild is item removed
	const auto EVENT_OBJECT_SELECTIONWITHIN         = 0x8009  ; // hwnd + ID + idChild is parent of changed selected items
	
	/*
	 * NOTES:
	 * There is only one "focused" child item in a parent.  This is the place
	 * keystrokes are going at a given moment.  Hence only send a notification
	 * about where the NEW focus is going.  A NEW item getting the focus already
	 * implies that the OLD item is losing it.
	 *
	 * SELECTION however can be multiple.  Hence the different SELECTION
	 * notifications.  Here's when to use each:
	 *
	 * (1) Send a SELECTION notification in the simple single selection
	 *     case (like the focus) when the item with the selection is
	 *     merely moving to a different item within a container.  hwnd + ID
	 *     is the container control, idChildItem is the new child with the
	 *     selection.
	 *
	 * (2) Send a SELECTIONADD notification when a new item has simply been added
	 *     to the selection within a container.  This is appropriate when the
	 *     number of newly selected items is very small.  hwnd + ID is the
	 *     container control, idChildItem is the new child added to the selection.
	 *
	 * (3) Send a SELECTIONREMOVE notification when a new item has simply been
	 *     removed from the selection within a container.  This is appropriate
	 *     when the number of newly selected items is very small, just like
	 *     SELECTIONADD.  hwnd + ID is the container control, idChildItem is the
	 *     new child removed from the selection.
	 *
	 * (4) Send a SELECTIONWITHIN notification when the selected items within a
	 *     control have changed substantially.  Rather than propagate a large
	 *     number of changes to reflect removal for some items, addition of
	 *     others, just tell somebody who cares that a lot happened.  It will
	 *     be faster an easier for somebody watching to just turn around and
	 *     query the container control what the new bunch of selected items
	 *     are.
	 */
	
	const auto EVENT_OBJECT_STATECHANGE             = 0x800A  ; // hwnd + ID + idChild is item w/ state change
	/*
	 * Examples of when to send an EVENT_OBJECT_STATECHANGE include
	 *      * It is being enabled/disabled (USER does for windows)
	 *      * It is being pressed/released (USER does for buttons)
	 *      * It is being checked/unchecked (USER does for radio/check buttons)
	 */
	const auto EVENT_OBJECT_LOCATIONCHANGE          = 0x800B  ; // hwnd + ID + idChild is moved/sized item
	
	/*
	 * Note:
	 * A LOCATIONCHANGE is not sent for every child object when the parent
	 * changes shape/moves.  Send one notification for the topmost object
	 * that is changing.  For example, if the user resizes a top level window,
	 * USER will generate a LOCATIONCHANGE for it, but not for the menu bar,
	 * title bar, scrollbars, etc.  that are also changing shape/moving.
	 *
	 * In other words, it only generates LOCATIONCHANGE notifications for
	 * real windows that are moving/sizing.  It will not generate a LOCATIONCHANGE
	 * for every non-floating child window when the parent moves (the children are
	 * logically moving also on screen, but not relative to the parent).
	 *
	 * Now, if the app itself resizes child windows as a result of being
	 * sized, USER will generate LOCATIONCHANGEs for those dudes also because
	 * it doesn't know better.
	 *
	 * Note also that USER will generate LOCATIONCHANGE notifications for two
	 * non-window sys objects:
	 *      (1) System caret
	 *      (2) Cursor
	 */
	
	const auto EVENT_OBJECT_NAMECHANGE              = 0x800C  ; // hwnd + ID + idChild is item w/ name change
	const auto EVENT_OBJECT_DESCRIPTIONCHANGE       = 0x800D  ; // hwnd + ID + idChild is item w/ desc change
	const auto EVENT_OBJECT_VALUECHANGE             = 0x800E  ; // hwnd + ID + idChild is item w/ value change
	const auto EVENT_OBJECT_PARENTCHANGE            = 0x800F  ; // hwnd + ID + idChild is item w/ new parent
	const auto EVENT_OBJECT_HELPCHANGE              = 0x8010  ; // hwnd + ID + idChild is item w/ help change
	const auto EVENT_OBJECT_DEFACTIONCHANGE         = 0x8011  ; // hwnd + ID + idChild is item w/ def action change
	const auto EVENT_OBJECT_ACCELERATORCHANGE       = 0x8012  ; // hwnd + ID + idChild is item w/ keybd accel change
	
	const auto EVENT_OBJECT_INVOKED                 = 0x8013  ; // hwnd + ID + idChild is item invoked
	const auto EVENT_OBJECT_TEXTSELECTIONCHANGED    = 0x8014  ; // hwnd + ID + idChild is item w? test selection change
	
	/*
	 * EVENT_OBJECT_CONTENTSCROLLED
	 * Sent when ending the scrolling of a window object.
	 *
	 * Unlike the similar event (EVENT_SYSTEM_SCROLLEND), this event will be
	 * associated with the scrolling window itself. There is no difference
	 * between horizontal or vertical scrolling.
	 *
	 * This event should be posted whenever scroll action is completed, including
	 * when it is scrolled by scroll bars, mouse wheel, or keyboard navigations.
	 *
	 *   example:
	 *          hwnd == window that is scrolling
	 *          idObject == OBJID_CLIENT
	 *          idChild == CHILDID_SELF
	 */
	const auto EVENT_OBJECT_CONTENTSCROLLED         = 0x8015;
	
	/*
	 * Child IDs
	 */
	
	/*
	 * System Sounds (idChild of system SOUND notification)
	 */
	const auto SOUND_SYSTEM_STARTUP             = 1;
	const auto SOUND_SYSTEM_SHUTDOWN            = 2;
	const auto SOUND_SYSTEM_BEEP                = 3;
	const auto SOUND_SYSTEM_ERROR               = 4;
	const auto SOUND_SYSTEM_QUESTION            = 5;
	const auto SOUND_SYSTEM_WARNING             = 6;
	const auto SOUND_SYSTEM_INFORMATION         = 7;
	const auto SOUND_SYSTEM_MAXIMIZE            = 8;
	const auto SOUND_SYSTEM_MINIMIZE            = 9;
	const auto SOUND_SYSTEM_RESTOREUP           = 10;
	const auto SOUND_SYSTEM_RESTOREDOWN         = 11;
	const auto SOUND_SYSTEM_APPSTART            = 12;
	const auto SOUND_SYSTEM_FAULT               = 13;
	const auto SOUND_SYSTEM_APPEND              = 14;
	const auto SOUND_SYSTEM_MENUCOMMAND         = 15;
	const auto SOUND_SYSTEM_MENUPOPUP           = 16;
	const auto CSOUND_SYSTEM                    = 16;
	
	/*
	 * System Alerts (indexChild of system ALERT notification)
	 */
	const auto ALERT_SYSTEM_INFORMATIONAL       = 1       ; // MB_INFORMATION
	const auto ALERT_SYSTEM_WARNING             = 2       ; // MB_WARNING
	const auto ALERT_SYSTEM_ERROR               = 3       ; // MB_ERROR
	const auto ALERT_SYSTEM_QUERY               = 4       ; // MB_QUESTION
	const auto ALERT_SYSTEM_CRITICAL            = 5       ; // HardSysErrBox
	const auto CALERT_SYSTEM                    = 6;
	
	struct GUITHREADINFO {
	    DWORD   cbSize;
	    DWORD   flags;
	    HWND    hwndActive;
	    HWND    hwndFocus;
	    HWND    hwndCapture;
	    HWND    hwndMenuOwner;
	    HWND    hwndMoveSize;
	    HWND    hwndCaret;
	    RECT    rcCaret;
	}
	
	alias GUITHREADINFO* PGUITHREADINFO;
	alias GUITHREADINFO  * LPGUITHREADINFO;
	
	const auto GUI_CARETBLINKING    = 0x00000001;
	const auto GUI_INMOVESIZE       = 0x00000002;
	const auto GUI_INMENUMODE       = 0x00000004;
	const auto GUI_SYSTEMMENUMODE   = 0x00000008;
	const auto GUI_POPUPMENUMODE    = 0x00000010;
	
	version(X86_64) {
		const auto GUI_16BITTASK        = 0x00000000;
	}
	else {
		const auto GUI_16BITTASK        = 0x00000020;
	}
	
	BOOL GetGUIThreadInfo(
	     DWORD idThread,
	     PGUITHREADINFO pgui);
	
	BOOL BlockInput(
	    BOOL fBlockIt);
	
	const auto USER_DEFAULT_SCREEN_DPI  = 96;
	
	BOOL SetProcessDPIAware();
	
	BOOL IsProcessDPIAware();
	
	UINT GetWindowModuleFileNameA(
	     HWND hwnd,
		 LPSTR pszFileName,
	     UINT cchFileNameMax);
	
	UINT GetWindowModuleFileNameW(
	     HWND hwnd,
		 LPWSTR pszFileName,
	     UINT cchFileNameMax);
	
	version(UNICODE) {
		alias GetWindowModuleFileNameW GetWindowModuleFileName;
	}
	else {
		alias GetWindowModuleFileNameA GetWindowModuleFileName;
	}
	
	version(NO_STATE_FLAGS) {
	}
	else {
		const auto STATE_SYSTEM_UNAVAILABLE         = 0x00000001  ; // Disabled
		const auto STATE_SYSTEM_SELECTED            = 0x00000002;
		const auto STATE_SYSTEM_FOCUSED             = 0x00000004;
		const auto STATE_SYSTEM_PRESSED             = 0x00000008;
		const auto STATE_SYSTEM_CHECKED             = 0x00000010;
		const auto STATE_SYSTEM_MIXED               = 0x00000020  ; // 3-state checkbox or toolbar button
		const auto STATE_SYSTEM_INDETERMINATE       = STATE_SYSTEM_MIXED;
		const auto STATE_SYSTEM_READONLY            = 0x00000040;
		const auto STATE_SYSTEM_HOTTRACKED          = 0x00000080;
		const auto STATE_SYSTEM_DEFAULT             = 0x00000100;
		const auto STATE_SYSTEM_EXPANDED            = 0x00000200;
		const auto STATE_SYSTEM_COLLAPSED           = 0x00000400;
		const auto STATE_SYSTEM_BUSY                = 0x00000800;
		const auto STATE_SYSTEM_FLOATING            = 0x00001000  ; // Children "owned" not "contained" by parent
		const auto STATE_SYSTEM_MARQUEED            = 0x00002000;
		const auto STATE_SYSTEM_ANIMATED            = 0x00004000;
		const auto STATE_SYSTEM_INVISIBLE           = 0x00008000;
		const auto STATE_SYSTEM_OFFSCREEN           = 0x00010000;
		const auto STATE_SYSTEM_SIZEABLE            = 0x00020000;
		const auto STATE_SYSTEM_MOVEABLE            = 0x00040000;
		const auto STATE_SYSTEM_SELFVOICING         = 0x00080000;
		const auto STATE_SYSTEM_FOCUSABLE           = 0x00100000;
		const auto STATE_SYSTEM_SELECTABLE          = 0x00200000;
		const auto STATE_SYSTEM_LINKED              = 0x00400000;
		const auto STATE_SYSTEM_TRAVERSED           = 0x00800000;
		const auto STATE_SYSTEM_MULTISELECTABLE     = 0x01000000  ; // Supports multiple selection
		const auto STATE_SYSTEM_EXTSELECTABLE       = 0x02000000  ; // Supports extended selection
		const auto STATE_SYSTEM_ALERT_LOW           = 0x04000000  ; // This information is of low priority
		const auto STATE_SYSTEM_ALERT_MEDIUM        = 0x08000000  ; // This information is of medium priority
		const auto STATE_SYSTEM_ALERT_HIGH          = 0x10000000  ; // This information is of high priority
		const auto STATE_SYSTEM_PROTECTED           = 0x20000000  ; // access to this is restricted
		const auto STATE_SYSTEM_VALID               = 0x3FFFFFFF;
	}
	
	const auto CCHILDREN_TITLEBAR               = 5;
	const auto CCHILDREN_SCROLLBAR              = 5;
	
	/*
	 * Information about the global cursor.
	 */
	struct CURSORINFO {
	    DWORD   cbSize;
	    DWORD   flags;
	    HCURSOR hCursor;
	    POINT   ptScreenPos;
	}
	
	alias CURSORINFO* PCURSORINFO;
	alias CURSORINFO* LPCURSORINFO;
	
	const auto CURSOR_SHOWING      = 0x00000001;
	
	BOOL GetCursorInfo(
	     PCURSORINFO pci);
	
	/*
	 * Window information snapshot
	 */
	struct WINDOWINFO {
	    DWORD cbSize;
	    RECT rcWindow;
	    RECT rcClient;
	    DWORD dwStyle;
	    DWORD dwExStyle;
	    DWORD dwWindowStatus;
	    UINT cxWindowBorders;
	    UINT cyWindowBorders;
	    ATOM atomWindowType;
	    WORD wCreatorVersion;
	}
	
	alias WINDOWINFO* PWINDOWINFO;
	alias WINDOWINFO* LPWINDOWINFO;
	
	const auto WS_ACTIVECAPTION     = 0x0001;
	
	BOOL GetWindowInfo(
	     HWND hwnd,
	     PWINDOWINFO pwi);
	
	/*
	 * Titlebar information.
	 */
	struct TITLEBARINFO {
	    DWORD cbSize;
	    RECT rcTitleBar;
	    DWORD rgstate[CCHILDREN_TITLEBAR + 1];
	}
	
	alias TITLEBARINFO* PTITLEBARINFO;
	alias TITLEBARINFO* LPTITLEBARINFO;
	
	BOOL GetTitleBarInfo(
	     HWND hwnd,
		 PTITLEBARINFO pti);
	
	struct TITLEBARINFOEX {
	    DWORD cbSize;
	    RECT rcTitleBar;
	    DWORD rgstate[CCHILDREN_TITLEBAR + 1];
	    RECT rgrect[CCHILDREN_TITLEBAR + 1];
	}
	
	alias TITLEBARINFOEX* PTITLEBARINFOEX;
	alias TITLEBARINFOEX* LPTITLEBARINFOEX;
	
	/*
	 * Menubar information
	 */
	struct MENUBARINFO {
	    DWORD cbSize;
	    RECT rcBar;          // rect of bar, popup, item
	    HMENU hMenu;         // real menu handle of bar, popup
	    HWND hwndMenu;       // hwnd of item submenu if one
	    BYTE fFocusedFlags;
	    
	    BOOL fBarFocused() { // bar, popup has the focus
			return fFocusedFlags & 1;
	    }
	
	    BOOL fFocused() { // item has the focus
	    	return (fFocusedFlags >> 1) & 1;
	    }
	}
	
	alias MENUBARINFO* PMENUBARINFO;
	alias MENUBARINFO* LPMENUBARINFO;
	
	BOOL GetMenuBarInfo(
	     HWND hwnd,
	     LONG idObject,
	     LONG idItem,
	     PMENUBARINFO pmbi);
	
	/*
	 * Scrollbar information
	 */
	struct SCROLLBARINFO {
	    DWORD cbSize;
	    RECT rcScrollBar;
	    int dxyLineButton;
	    int xyThumbTop;
	    int xyThumbBottom;
	    int reserved;
	    DWORD[CCHILDREN_SCROLLBAR + 1] rgstate;
	}
	
	alias SCROLLBARINFO* PSCROLLBARINFO;
	alias SCROLLBARINFO* LPSCROLLBARINFO;
	
	BOOL GetScrollBarInfo(
	     HWND hwnd,
	     LONG idObject,
	     PSCROLLBARINFO psbi);
	
	/*
	 * Combobox information
	 */
	struct COMBOBOXINFO {
	    DWORD cbSize;
	    RECT rcItem;
	    RECT rcButton;
	    DWORD stateButton;
	    HWND hwndCombo;
	    HWND hwndItem;
	    HWND hwndList;
	}
	
	alias COMBOBOXINFO* PCOMBOBOXINFO;
	alias COMBOBOXINFO* LPCOMBOBOXINFO;
	
	BOOL GetComboBoxInfo(
	     HWND hwndCombo,
	     PCOMBOBOXINFO pcbi);
	
	/*
	 * The "real" ancestor window
	 */
	const auto      GA_PARENT       = 1;
	const auto      GA_ROOT         = 2;
	const auto      GA_ROOTOWNER    = 3;
	
	HWND GetAncestor(
	     HWND hwnd,
	     UINT gaFlags);
	
	
	/*
	 * This gets the REAL child window at the point.  If it is in the dead
	 * space of a group box, it will try a sibling behind it.  But static
	 * fields will get returned.  In other words, it is kind of a cross between
	 * ChildWindowFromPointEx and WindowFromPoint.
	 */
	HWND RealChildWindowFromPoint(
	     HWND hwndParent,
	     POINT ptParentClientCoords);
	
	
	/*
	 * This gets the name of the window TYPE, not class.  This allows us to
	 * recognize ThunderButton32 et al.
	 */
	UINT RealGetWindowClassA(
	     HWND hwnd,
		 LPSTR ptszClassName,
	     UINT cchClassNameMax);
	/*
	 * This gets the name of the window TYPE, not class.  This allows us to
	 * recognize ThunderButton32 et al.
	 */
	UINT RealGetWindowClassW(
	     HWND hwnd,
		 LPWSTR ptszClassName,
	     UINT cchClassNameMax);
	
	version(UNICODE) {
		alias RealGetWindowClassW RealGetWindowClass;
	}
	else {
		alias RealGetWindowClassA RealGetWindowClass;
	}
	
	/*
	 * Alt-Tab Switch window information.
	 */
	struct ALTTABINFO {
	    DWORD cbSize;
	    int cItems;
	    int cColumns;
	    int cRows;
	    int iColFocus;
	    int iRowFocus;
	    int cxItem;
	    int cyItem;
	    POINT ptStart;
	}
	
	alias ALTTABINFO* PALTTABINFO;
	alias ALTTABINFO* LPALTTABINFO;
	
	BOOL GetAltTabInfoA(
	     HWND hwnd,
	     int iItem,
	     PALTTABINFO pati,
		 LPSTR pszItemText,
	     UINT cchItemText);
	
	BOOL GetAltTabInfoW(
	     HWND hwnd,
	     int iItem,
	     PALTTABINFO pati,
		 LPWSTR pszItemText,
	     UINT cchItemText);

	version(UNICODE) {
		alias GetAltTabInfoW GetAltTabInfo;
	}
	else {
		alias GetAltTabInfoA GetAltTabInfo;
	}

	/*
	 * Listbox information.
	 * Returns the number of items per row.
	 */
	DWORD GetListBoxInfo(
	     HWND hwnd);
}

BOOL LockWorkStation();

BOOL UserHandleGrantAccess(
     HANDLE hUserHandle,
     HANDLE hJob,
     BOOL   bGrant);

/*
 * Raw Input Messages.
 */

alias HANDLE HRAWINPUT;;

/*
 * WM_INPUT wParam
 */

/*
 * Use this macro to get the input code from wParam.
 */
DWORD GET_RAWINPUT_CODE_WPARAM(WPARAM wParam) {
	return cast(DWORD)(wParam & 0xff);
}

/*
 * The input is in the regular message flow,
 * the app is required to call DefWindowProc
 * so that the system can perform clean ups.
 */
const auto RIM_INPUT        = 0;

/*
 * The input is sink only. The app is expected
 * to behave nicely.
 */
const auto RIM_INPUTSINK    = 1;


/*
 * Raw Input data header
 */
struct RAWINPUTHEADER {
    DWORD dwType;
    DWORD dwSize;
    HANDLE hDevice;
    WPARAM wParam;
}

alias RAWINPUTHEADER* PRAWINPUTHEADER;
alias RAWINPUTHEADER* LPRAWINPUTHEADER;

/*
 * Type of the raw input
 */
const auto RIM_TYPEMOUSE        = 0;
const auto RIM_TYPEKEYBOARD     = 1;
const auto RIM_TYPEHID          = 2;

/*
 * Raw format of the mouse input
 */
struct RAWMOUSE {
    /*
     * Indicator flags.
     */
    USHORT usFlags;

    /*
     * The transition state of the mouse buttons.
     */
    union _inner_union {
        ULONG ulButtons;
        struct _inner_struct {
            USHORT  usButtonFlags;
            USHORT  usButtonData;
        }
        _inner_struct data;
    }

	_inner_union fields;
    /*
     * The raw state of the mouse buttons.
     */
    ULONG ulRawButtons;

    /*
     * The signed relative or absolute motion in the X direction.
     */
    LONG lLastX;

    /*
     * The signed relative or absolute motion in the Y direction.
     */
    LONG lLastY;

    /*
     * Device-specific additional information for the event.
     */
    ULONG ulExtraInformation;

}

alias RAWMOUSE* PRAWMOUSE;
alias RAWMOUSE* LPRAWMOUSE;

/*
 * Define the mouse button state indicators.
 */

const auto RI_MOUSE_LEFT_BUTTON_DOWN    = 0x0001  ; // Left Button changed to down.
const auto RI_MOUSE_LEFT_BUTTON_UP      = 0x0002  ; // Left Button changed to up.
const auto RI_MOUSE_RIGHT_BUTTON_DOWN   = 0x0004  ; // Right Button changed to down.
const auto RI_MOUSE_RIGHT_BUTTON_UP     = 0x0008  ; // Right Button changed to up.
const auto RI_MOUSE_MIDDLE_BUTTON_DOWN  = 0x0010  ; // Middle Button changed to down.
const auto RI_MOUSE_MIDDLE_BUTTON_UP    = 0x0020  ; // Middle Button changed to up.

const auto RI_MOUSE_BUTTON_1_DOWN       = RI_MOUSE_LEFT_BUTTON_DOWN;
const auto RI_MOUSE_BUTTON_1_UP         = RI_MOUSE_LEFT_BUTTON_UP;
const auto RI_MOUSE_BUTTON_2_DOWN       = RI_MOUSE_RIGHT_BUTTON_DOWN;
const auto RI_MOUSE_BUTTON_2_UP         = RI_MOUSE_RIGHT_BUTTON_UP;
const auto RI_MOUSE_BUTTON_3_DOWN       = RI_MOUSE_MIDDLE_BUTTON_DOWN;
const auto RI_MOUSE_BUTTON_3_UP         = RI_MOUSE_MIDDLE_BUTTON_UP;

const auto RI_MOUSE_BUTTON_4_DOWN       = 0x0040;
const auto RI_MOUSE_BUTTON_4_UP         = 0x0080;
const auto RI_MOUSE_BUTTON_5_DOWN       = 0x0100;
const auto RI_MOUSE_BUTTON_5_UP         = 0x0200;

/*
 * If usButtonFlags has RI_MOUSE_WHEEL, the wheel delta is stored in usButtonData.
 * Take it as a signed value.
 */
const auto RI_MOUSE_WHEEL               = 0x0400;

/*
 * Define the mouse indicator flags.
 */
const auto MOUSE_MOVE_RELATIVE          = 0;
const auto MOUSE_MOVE_ABSOLUTE          = 1;
const auto MOUSE_VIRTUAL_DESKTOP     = 0x02  ; // the coordinates are mapped to the virtual desktop
const auto MOUSE_ATTRIBUTES_CHANGED  = 0x04  ; // requery for mouse attributes

const auto MOUSE_MOVE_NOCOALESCE     = 0x08  ; // do not coalesce mouse moves

/*
 * Raw format of the keyboard input
 */
struct RAWKEYBOARD {
    /*
     * The "make" scan code (key depression).
     */
    USHORT MakeCode;

    /*
     * The flags field indicates a "break" (key release) and other
     * miscellaneous scan code information defined in ntddkbd.h.
     */
    USHORT Flags;

    USHORT Reserved;

    /*
     * Windows message compatible information
     */
    USHORT VKey;
    UINT   Message;

    /*
     * Device-specific additional information for the event.
     */
    ULONG ExtraInformation;


}

alias RAWKEYBOARD* PRAWKEYBOARD;
alias RAWKEYBOARD* LPRAWKEYBOARD;


/*
 * Define the keyboard overrun MakeCode.
 */

const auto KEYBOARD_OVERRUN_MAKE_CODE     = 0xFF;

/*
 * Define the keyboard input data Flags.
 */
const auto RI_KEY_MAKE              = 0;
const auto RI_KEY_BREAK             = 1;
const auto RI_KEY_E0                = 2;
const auto RI_KEY_E1                = 4;
const auto RI_KEY_TERMSRV_SET_LED   = 8;
const auto RI_KEY_TERMSRV_SHADOW    = 0x10;


/*
 * Raw format of the input from Human Input Devices
 */
struct RAWHID {
    DWORD dwSizeHid;    // byte size of each report
    DWORD dwCount;      // number of input packed
    BYTE[1] bRawData;
}

alias RAWHID* PRAWHID;
alias RAWHID* LPRAWHID;

/*
 * RAWINPUT data structure.
 */
struct RAWINPUT {
    RAWINPUTHEADER header;
    union _inner_union {
        RAWMOUSE    mouse;
        RAWKEYBOARD keyboard;
        RAWHID      hid;
    }
    _inner_union data;
}

alias RAWINPUT* PRAWINPUT;
alias RAWINPUT* LPRAWINPUT;

ULONG_PTR RAWINPUT_ALIGN(ULONG_PTR x) {
	return (((x) + QWORD.sizeof - 1) & ~(QWORD.sizeof - 1));
}

PRAWINPUT NEXTRAWINPUTBLOCK(PRAWINPUT ptr) {
	return (cast(PRAWINPUT)RAWINPUT_ALIGN(cast(ULONG_PTR)(cast(PBYTE)(ptr) + ptr.header.dwSize)));
}

/*
 * Flags for GetRawInputData
 */

const auto RID_INPUT                = 0x10000003;
const auto RID_HEADER               = 0x10000005;

UINT GetRawInputData(
     HRAWINPUT hRawInput,
     UINT uiCommand,
	 LPVOID pData,
     PUINT pcbSize,
     UINT cbSizeHeader);

/*
 * Raw Input Device Information
 */
const auto RIDI_PREPARSEDDATA       = 0x20000005;
const auto RIDI_DEVICENAME          = 0x20000007  ; // the return valus is the character length, not the byte size
const auto RIDI_DEVICEINFO          = 0x2000000b;

struct RID_DEVICE_INFO_MOUSE {
    DWORD dwId;
    DWORD dwNumberOfButtons;
    DWORD dwSampleRate;
    BOOL  fHasHorizontalWheel;
}

alias RID_DEVICE_INFO_MOUSE* PRID_DEVICE_INFO_MOUSE;

struct RID_DEVICE_INFO_KEYBOARD {
    DWORD dwType;
    DWORD dwSubType;
    DWORD dwKeyboardMode;
    DWORD dwNumberOfFunctionKeys;
    DWORD dwNumberOfIndicators;
    DWORD dwNumberOfKeysTotal;
}

alias RID_DEVICE_INFO_KEYBOARD* PRID_DEVICE_INFO_KEYBOARD;

struct RID_DEVICE_INFO_HID {
    DWORD dwVendorId;
    DWORD dwProductId;
    DWORD dwVersionNumber;

    /*
     * Top level collection UsagePage and Usage
     */
    USHORT usUsagePage;
    USHORT usUsage;
}

alias RID_DEVICE_INFO_HID* PRID_DEVICE_INFO_HID;

struct RID_DEVICE_INFO {
    DWORD cbSize;
    DWORD dwType;
    union _inner_union {
        RID_DEVICE_INFO_MOUSE mouse;
        RID_DEVICE_INFO_KEYBOARD keyboard;
        RID_DEVICE_INFO_HID hid;
    }
    
    _inner_union fields;
}

alias RID_DEVICE_INFO* PRID_DEVICE_INFO;
alias RID_DEVICE_INFO* LPRID_DEVICE_INFO;

UINT GetRawInputDeviceInfoA(
     HANDLE hDevice,
     UINT uiCommand,
	 LPVOID pData,
     PUINT pcbSize);

UINT GetRawInputDeviceInfoW(
     HANDLE hDevice,
     UINT uiCommand,
	 LPVOID pData,
     PUINT pcbSize);

version(UNICODE) {
	alias GetRawInputDeviceInfoW GetRawInputDeviceInfo;
}
else {
	alias GetRawInputDeviceInfoA GetRawInputDeviceInfo;
}

/*
 * Raw Input Bulk Read: GetRawInputBuffer
 */
UINT GetRawInputBuffer(
     PRAWINPUT pData,
     PUINT pcbSize,
     UINT cbSizeHeader);

/*
 * Raw Input request APIs
 */
struct RAWINPUTDEVICE {
    USHORT usUsagePage; // Toplevel collection UsagePage
    USHORT usUsage;     // Toplevel collection Usage
    DWORD dwFlags;
    HWND hwndTarget;    // Target hwnd. NULL = follows keyboard focus
}

alias RAWINPUTDEVICE* PRAWINPUTDEVICE;
alias RAWINPUTDEVICE* LPRAWINPUTDEVICE;

alias  RAWINPUTDEVICE* PCRAWINPUTDEVICE;

const auto RIDEV_REMOVE             = 0x00000001;
const auto RIDEV_EXCLUDE            = 0x00000010;
const auto RIDEV_PAGEONLY           = 0x00000020;
const auto RIDEV_NOLEGACY           = 0x00000030;
const auto RIDEV_INPUTSINK          = 0x00000100;
const auto RIDEV_CAPTUREMOUSE       = 0x00000200  ; // effective when mouse nolegacy is specified, otherwise it would be an error
const auto RIDEV_NOHOTKEYS          = 0x00000200  ; // effective for keyboard.
const auto RIDEV_APPKEYS            = 0x00000400  ; // effective for keyboard.

const auto RIDEV_EXINPUTSINK        = 0x00001000;
const auto RIDEV_DEVNOTIFY          = 0x00002000;

const auto RIDEV_EXMODEMASK         = 0x000000F0;

template RIDEV_EXMODE(uint mode) {
	const auto RIDEV_EXMODE = ((mode) & RIDEV_EXMODEMASK);
}

/*
 * Flags for the WM_INPUT_DEVICE_CHANGE message.
 */
const auto GIDC_ARRIVAL              = 1;
const auto GIDC_REMOVAL              = 2;

WORD GET_DEVICE_CHANGE_LPARAM(LPARAM lParam) {
	return LOWORD(lParam);
}

BOOL RegisterRawInputDevices(
     PCRAWINPUTDEVICE pRawInputDevices,
     UINT uiNumDevices,
     UINT cbSize);

UINT GetRegisteredRawInputDevices(
     PRAWINPUTDEVICE pRawInputDevices,
     PUINT puiNumDevices,
     UINT cbSize);

struct RAWINPUTDEVICELIST {
    HANDLE hDevice;
    DWORD dwType;
}

alias RAWINPUTDEVICELIST* PRAWINPUTDEVICELIST;

UINT GetRawInputDeviceList(
     PRAWINPUTDEVICELIST pRawInputDeviceList,
     PUINT puiNumDevices,
     UINT cbSize);

LRESULT DefRawInputProc(
     PRAWINPUT* paRawInput,
     INT nInput,
     UINT cbSizeHeader);

const auto MSGFLT_ADD  = 1;
const auto MSGFLT_REMOVE  = 2;

BOOL ChangeWindowMessageFilter(
     UINT message,
     DWORD dwFlag);

const auto MAX_STR_BLOCKREASON  = 256;

BOOL ShutdownBlockReasonCreate(
     HWND hWnd,
     LPCWSTR pwszReason);

BOOL ShutdownBlockReasonQuery(
     HWND hWnd,
	 LPWSTR pwszBuff,
     DWORD *pcchBuff);

BOOL ShutdownBlockReasonDestroy(
     HWND hWnd);
