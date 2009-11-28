/*
 * wincon.d
 *
 * This module binds WinCon.h to D. The original copyright notice is preserved
 * below.
 *
 * Author: Dave Wilkinson
 * Originated: November 25th, 2009
 *
 */

module binding.win32.wincon;

import binding.win32.windef;
import binding.win32.winnt;
import binding.win32.wingdi;
import binding.win32.winbase;

extern(System):

/*++ BUILD Version: 0002    // Increment this if a change has global effects

Copyright (c) Microsoft Corporation. All rights reserved.

Module Name:

    wincon.h

Abstract:

    This module contains the public data structures, data types,
    and procedures exported by the NT console subsystem.

Created:

    26-Oct-1990

Revision History:

--*/

struct COORD {
    SHORT X;
    SHORT Y;
}

alias COORD* PCOORD;

struct SMALL_RECT {
    SHORT Left;
    SHORT Top;
    SHORT Right;
    SHORT Bottom;
}

alias SMALL_RECT* PSMALL_RECT;

struct KEY_EVENT_RECORD {
    BOOL bKeyDown;
    WORD wRepeatCount;
    WORD wVirtualKeyCode;
    WORD wVirtualScanCode;
    union _inner_union {
        WCHAR UnicodeChar;
        CHAR   AsciiChar;
    }
	_inner_union uChar;
    DWORD dwControlKeyState;
}

alias KEY_EVENT_RECORD* PKEY_EVENT_RECORD;

//
// ControlKeyState flags
//

const auto RIGHT_ALT_PRESSED     = 0x0001; // the right alt key is pressed.
const auto LEFT_ALT_PRESSED      = 0x0002; // the left alt key is pressed.
const auto RIGHT_CTRL_PRESSED    = 0x0004; // the right ctrl key is pressed.
const auto LEFT_CTRL_PRESSED     = 0x0008; // the left ctrl key is pressed.
const auto SHIFT_PRESSED         = 0x0010; // the shift key is pressed.
const auto NUMLOCK_ON            = 0x0020; // the numlock light is on.
const auto SCROLLLOCK_ON         = 0x0040; // the scrolllock light is on.
const auto CAPSLOCK_ON           = 0x0080; // the capslock light is on.
const auto ENHANCED_KEY          = 0x0100; // the key is enhanced.
const auto NLS_DBCSCHAR          = 0x00010000; // DBCS for JPN: SBCS/DBCS mode.
const auto NLS_ALPHANUMERIC      = 0x00000000; // DBCS for JPN: Alphanumeric mode.
const auto NLS_KATAKANA          = 0x00020000; // DBCS for JPN: Katakana mode.
const auto NLS_HIRAGANA          = 0x00040000; // DBCS for JPN: Hiragana mode.
const auto NLS_ROMAN             = 0x00400000; // DBCS for JPN: Roman/Noroman mode.
const auto NLS_IME_CONVERSION    = 0x00800000; // DBCS for JPN: IME conversion.
const auto NLS_IME_DISABLE       = 0x20000000; // DBCS for JPN: IME enable/disable.

struct MOUSE_EVENT_RECORD {
    COORD dwMousePosition;
    DWORD dwButtonState;
    DWORD dwControlKeyState;
    DWORD dwEventFlags;
}

alias MOUSE_EVENT_RECORD* PMOUSE_EVENT_RECORD;

//
// ButtonState flags
//

const auto FROM_LEFT_1ST_BUTTON_PRESSED    = 0x0001;
const auto RIGHTMOST_BUTTON_PRESSED        = 0x0002;
const auto FROM_LEFT_2ND_BUTTON_PRESSED    = 0x0004;
const auto FROM_LEFT_3RD_BUTTON_PRESSED    = 0x0008;
const auto FROM_LEFT_4TH_BUTTON_PRESSED    = 0x0010;

//
// EventFlags
//

const auto MOUSE_MOVED   = 0x0001;
const auto DOUBLE_CLICK  = 0x0002;
const auto MOUSE_WHEELED = 0x0004;

const auto MOUSE_HWHEELED = 0x0008;

struct WINDOW_BUFFER_SIZE_RECORD {
    COORD dwSize;
}

alias WINDOW_BUFFER_SIZE_RECORD* PWINDOW_BUFFER_SIZE_RECORD;

struct MENU_EVENT_RECORD {
    UINT dwCommandId;
}

alias MENU_EVENT_RECORD* PMENU_EVENT_RECORD;

struct FOCUS_EVENT_RECORD {
    BOOL bSetFocus;
}

alias FOCUS_EVENT_RECORD* PFOCUS_EVENT_RECORD;

struct INPUT_RECORD {
    WORD EventType;
    union _inner_union {
        KEY_EVENT_RECORD KeyEvent;
        MOUSE_EVENT_RECORD MouseEvent;
        WINDOW_BUFFER_SIZE_RECORD WindowBufferSizeEvent;
        MENU_EVENT_RECORD MenuEvent;
        FOCUS_EVENT_RECORD FocusEvent;
    }
	_inner_union Event;
}

alias INPUT_RECORD* PINPUT_RECORD;

//
//  EventType flags:
//

const auto KEY_EVENT         = 0x0001; // Event contains key event record
const auto MOUSE_EVENT       = 0x0002; // Event contains mouse event record
const auto WINDOW_BUFFER_SIZE_EVENT = 0x0004; // Event contains window change event record
const auto MENU_EVENT  = 0x0008; // Event contains menu event record
const auto FOCUS_EVENT = 0x0010; // event contains focus change

struct CHAR_INFO {
    union _inner_union {
        WCHAR UnicodeChar;
        CHAR   AsciiChar;
    }
	_inner_union Char;
    WORD Attributes;
}

alias CHAR_INFO* PCHAR_INFO;

//
// Attributes flags:
//

const auto FOREGROUND_BLUE      = 0x0001; // text color contains blue.
const auto FOREGROUND_GREEN     = 0x0002; // text color contains green.
const auto FOREGROUND_RED       = 0x0004; // text color contains red.
const auto FOREGROUND_INTENSITY = 0x0008; // text color is intensified.
const auto BACKGROUND_BLUE      = 0x0010; // background color contains blue.
const auto BACKGROUND_GREEN     = 0x0020; // background color contains green.
const auto BACKGROUND_RED       = 0x0040; // background color contains red.
const auto BACKGROUND_INTENSITY = 0x0080; // background color is intensified.
const auto COMMON_LVB_LEADING_BYTE    = 0x0100; // Leading Byte of DBCS
const auto COMMON_LVB_TRAILING_BYTE   = 0x0200; // Trailing Byte of DBCS
const auto COMMON_LVB_GRID_HORIZONTAL = 0x0400; // DBCS: Grid attribute: top horizontal.
const auto COMMON_LVB_GRID_LVERTICAL  = 0x0800; // DBCS: Grid attribute: left vertical.
const auto COMMON_LVB_GRID_RVERTICAL  = 0x1000; // DBCS: Grid attribute: right vertical.
const auto COMMON_LVB_REVERSE_VIDEO   = 0x4000; // DBCS: Reverse fore/back ground attribute.
const auto COMMON_LVB_UNDERSCORE      = 0x8000; // DBCS: Underscore.

const auto COMMON_LVB_SBCSDBCS        = 0x0300; // SBCS or DBCS flag.


struct CONSOLE_SCREEN_BUFFER_INFO {
    COORD dwSize;
    COORD dwCursorPosition;
    WORD  wAttributes;
    SMALL_RECT srWindow;
    COORD dwMaximumWindowSize;
}

alias CONSOLE_SCREEN_BUFFER_INFO* PCONSOLE_SCREEN_BUFFER_INFO;

struct CONSOLE_SCREEN_BUFFER_INFOEX {
    ULONG cbSize;
    COORD dwSize;
    COORD dwCursorPosition;
    WORD wAttributes;
    SMALL_RECT srWindow;
    COORD dwMaximumWindowSize;
    WORD wPopupAttributes;
    BOOL bFullscreenSupported;
    COLORREF ColorTable[16];
}

alias CONSOLE_SCREEN_BUFFER_INFOEX* PCONSOLE_SCREEN_BUFFER_INFOEX;

struct CONSOLE_CURSOR_INFO {
    DWORD  dwSize;
    BOOL   bVisible;
}

alias CONSOLE_CURSOR_INFO* PCONSOLE_CURSOR_INFO;

struct CONSOLE_FONT_INFO {
    DWORD  nFont;
    COORD  dwFontSize;
}

alias CONSOLE_FONT_INFO* PCONSOLE_FONT_INFO;

version(NOGDI) {
}
else {
	struct CONSOLE_FONT_INFOEX {
	    ULONG cbSize;
	    DWORD nFont;
	    COORD dwFontSize;
	    UINT FontFamily;
	    UINT FontWeight;
	    WCHAR[LF_FACESIZE] FaceName;
	}

	alias CONSOLE_FONT_INFOEX* PCONSOLE_FONT_INFOEX;
}

const auto HISTORY_NO_DUP_FLAG = 0x1;

struct CONSOLE_HISTORY_INFO {
    UINT cbSize;
    UINT HistoryBufferSize;
    UINT NumberOfHistoryBuffers;
    DWORD dwFlags;
}

alias CONSOLE_HISTORY_INFO* PCONSOLE_HISTORY_INFO;

struct CONSOLE_SELECTION_INFO {
    DWORD dwFlags;
    COORD dwSelectionAnchor;
    SMALL_RECT srSelection;
}

alias CONSOLE_SELECTION_INFO* PCONSOLE_SELECTION_INFO;

//
// Selection flags
//

const auto CONSOLE_NO_SELECTION            = 0x0000;
const auto CONSOLE_SELECTION_IN_PROGRESS   = 0x0001;   // selection has begun
const auto CONSOLE_SELECTION_NOT_EMPTY     = 0x0002;   // non-null select rectangle
const auto CONSOLE_MOUSE_SELECTION         = 0x0004;   // selecting with mouse
const auto CONSOLE_MOUSE_DOWN              = 0x0008;   // mouse is down

//
// alias for ctrl-c handler routines
//

alias BOOL function(DWORD CtrlType) PHANDLER_ROUTINE;

const auto CTRL_C_EVENT        = 0;
const auto CTRL_BREAK_EVENT    = 1;
const auto CTRL_CLOSE_EVENT    = 2;
// 3 is reserved!
// 4 is reserved!
const auto CTRL_LOGOFF_EVENT   = 5;
const auto CTRL_SHUTDOWN_EVENT = 6;

//
//  Input Mode flags:
//

const auto ENABLE_PROCESSED_INPUT  = 0x0001;
const auto ENABLE_LINE_INPUT       = 0x0002;
const auto ENABLE_ECHO_INPUT       = 0x0004;
const auto ENABLE_WINDOW_INPUT     = 0x0008;
const auto ENABLE_MOUSE_INPUT      = 0x0010;
const auto ENABLE_INSERT_MODE      = 0x0020;
const auto ENABLE_QUICK_EDIT_MODE  = 0x0040;
const auto ENABLE_EXTENDED_FLAGS   = 0x0080;
const auto ENABLE_AUTO_POSITION    = 0x0100;

//
// Output Mode flags:
//

const auto ENABLE_PROCESSED_OUTPUT    = 0x0001;
const auto ENABLE_WRAP_AT_EOL_OUTPUT  = 0x0002;

//
// direct API definitions.
//

BOOL PeekConsoleInputA(
    HANDLE hConsoleInput,
    PINPUT_RECORD lpBuffer,
    DWORD nLength,
    LPDWORD lpNumberOfEventsRead
    );

BOOL PeekConsoleInputW(
    HANDLE hConsoleInput,
    PINPUT_RECORD lpBuffer,
    DWORD nLength,
    LPDWORD lpNumberOfEventsRead
    );

version(UNICODE) {
	alias PeekConsoleInputW PeekConsoleInput;
}
else {
	alias PeekConsoleInputA PeekConsoleInput;
}

BOOL ReadConsoleInputA(
    HANDLE hConsoleInput,
    PINPUT_RECORD lpBuffer,
    DWORD nLength,
    LPDWORD lpNumberOfEventsRead
    );

BOOL ReadConsoleInputW(
    HANDLE hConsoleInput,
    PINPUT_RECORD lpBuffer,
    DWORD nLength,
    LPDWORD lpNumberOfEventsRead
    );

version(UNICODE) {
	alias ReadConsoleInputW ReadConsoleInput;
}
else {
	alias ReadConsoleInputA ReadConsoleInput;
}

BOOL WriteConsoleInputA(
    HANDLE hConsoleInput,
    INPUT_RECORD *lpBuffer,
    DWORD nLength,
    LPDWORD lpNumberOfEventsWritten
    );

BOOL WriteConsoleInputW(
    HANDLE hConsoleInput,
    INPUT_RECORD *lpBuffer,
    DWORD nLength,
    LPDWORD lpNumberOfEventsWritten
    );

version(UNICODE) {
	alias WriteConsoleInputW WriteConsoleInput;
}
else {
	alias WriteConsoleInputA WriteConsoleInput;
}

BOOL ReadConsoleOutputA(
    HANDLE hConsoleOutput,
    PCHAR_INFO lpBuffer,
    COORD dwBufferSize,
    COORD dwBufferCoord,
    PSMALL_RECT lpReadRegion
    );

BOOL ReadConsoleOutputW(
    HANDLE hConsoleOutput,
    PCHAR_INFO lpBuffer,
    COORD dwBufferSize,
    COORD dwBufferCoord,
    PSMALL_RECT lpReadRegion
    );

version(UNICODE) {
	alias ReadConsoleOutputW ReadConsoleOutput;
}
else {
	alias ReadConsoleOutputA ReadConsoleOutput;
}

BOOL WriteConsoleOutputA(
    HANDLE hConsoleOutput,
    CHAR_INFO *lpBuffer,
    COORD dwBufferSize,
    COORD dwBufferCoord,
    PSMALL_RECT lpWriteRegion
    );

BOOL WriteConsoleOutputW(
    HANDLE hConsoleOutput,
    CHAR_INFO *lpBuffer,
    COORD dwBufferSize,
    COORD dwBufferCoord,
    PSMALL_RECT lpWriteRegion
    );

version(UNICODE) {
	alias WriteConsoleOutputW WriteConsoleOutput;
}
else {
	alias WriteConsoleOutputA WriteConsoleOutput;
}

BOOL ReadConsoleOutputCharacterA(
    HANDLE hConsoleOutput,
    LPSTR lpCharacter,
    DWORD nLength,
    COORD dwReadCoord,
    LPDWORD lpNumberOfCharsRead
    );

BOOL ReadConsoleOutputCharacterW(
    HANDLE hConsoleOutput,
    LPWSTR lpCharacter,
    DWORD nLength,
    COORD dwReadCoord,
    LPDWORD lpNumberOfCharsRead
    );

version(UNICODE) {
	alias ReadConsoleOutputCharacterW ReadConsoleOutputCharacter;
}
else {
	alias ReadConsoleOutputCharacterA ReadConsoleOutputCharacter;
}

BOOL ReadConsoleOutputAttribute(
    HANDLE hConsoleOutput,
    LPWORD lpAttribute,
    DWORD nLength,
    COORD dwReadCoord,
	LPDWORD lpNumberOfAttrsRead
    );

BOOL WriteConsoleOutputCharacterA(
    HANDLE hConsoleOutput,
    LPCSTR lpCharacter,
    DWORD nLength,
    COORD dwWriteCoord,
    LPDWORD lpNumberOfCharsWritten
    );

BOOL WriteConsoleOutputCharacterW(
    HANDLE hConsoleOutput,
    LPCWSTR lpCharacter,
    DWORD nLength,
    COORD dwWriteCoord,
    LPDWORD lpNumberOfCharsWritten
    );

version(UNICODE) {
	alias WriteConsoleOutputCharacterW WriteConsoleOutputCharacter;
}
else {
	alias WriteConsoleOutputCharacterA WriteConsoleOutputCharacter;
}

BOOL WriteConsoleOutputAttribute(
    HANDLE hConsoleOutput,
    WORD *lpAttribute,
    DWORD nLength,
    COORD dwWriteCoord,
    LPDWORD lpNumberOfAttrsWritten
    );

BOOL FillConsoleOutputCharacterA(
    HANDLE hConsoleOutput,
    CHAR  cCharacter,
    DWORD  nLength,
    COORD  dwWriteCoord,
    LPDWORD lpNumberOfCharsWritten
    );

BOOL FillConsoleOutputCharacterW(
    HANDLE hConsoleOutput,
    WCHAR  cCharacter,
    DWORD  nLength,
    COORD  dwWriteCoord,
    LPDWORD lpNumberOfCharsWritten
    );

version(UNICODE) {
	alias FillConsoleOutputCharacterW FillConsoleOutputCharacter;
}
else {
	alias FillConsoleOutputCharacterA FillConsoleOutputCharacter;
}

BOOL FillConsoleOutputAttribute(
    HANDLE hConsoleOutput,
    WORD   wAttribute,
    DWORD  nLength,
    COORD  dwWriteCoord,
    LPDWORD lpNumberOfAttrsWritten
    );

BOOL GetConsoleMode(
    HANDLE hConsoleHandle,
    LPDWORD lpMode
    );

BOOL GetNumberOfConsoleInputEvents(
    HANDLE hConsoleInput,
    LPDWORD lpNumberOfEvents
    );

const HANDLE CONSOLE_REAL_OUTPUT_HANDLE = (cast(HANDLE)(-2));
const HANDLE CONSOLE_REAL_INPUT_HANDLE = (cast(HANDLE)(-3));

BOOL GetConsoleScreenBufferInfo(
    HANDLE hConsoleOutput,
    PCONSOLE_SCREEN_BUFFER_INFO lpConsoleScreenBufferInfo
    );

BOOL GetConsoleScreenBufferInfoEx(
    HANDLE hConsoleOutput,
    PCONSOLE_SCREEN_BUFFER_INFOEX lpConsoleScreenBufferInfoEx);

BOOL SetConsoleScreenBufferInfoEx(
    HANDLE hConsoleOutput,
    PCONSOLE_SCREEN_BUFFER_INFOEX lpConsoleScreenBufferInfoEx);

COORD GetLargestConsoleWindowSize(
    HANDLE hConsoleOutput
    );

BOOL GetConsoleCursorInfo(
    HANDLE hConsoleOutput,
    PCONSOLE_CURSOR_INFO lpConsoleCursorInfo
    );

BOOL GetCurrentConsoleFont(
    HANDLE hConsoleOutput,
    BOOL bMaximumWindow,
    PCONSOLE_FONT_INFO lpConsoleCurrentFont
    );

version(NOGDI) {
}
else {
	BOOL GetCurrentConsoleFontEx(
	    HANDLE hConsoleOutput,
	    BOOL bMaximumWindow,
	    PCONSOLE_FONT_INFOEX lpConsoleCurrentFontEx);

	BOOL SetCurrentConsoleFontEx(
	    HANDLE hConsoleOutput,
	    BOOL bMaximumWindow,
	    PCONSOLE_FONT_INFOEX lpConsoleCurrentFontEx);
}

BOOL GetConsoleHistoryInfo(
    PCONSOLE_HISTORY_INFO lpConsoleHistoryInfo);

BOOL SetConsoleHistoryInfo(
    PCONSOLE_HISTORY_INFO lpConsoleHistoryInfo);

COORD GetConsoleFontSize(
    HANDLE hConsoleOutput,
    DWORD nFont
    );

BOOL GetConsoleSelectionInfo(
    PCONSOLE_SELECTION_INFO lpConsoleSelectionInfo
    );

BOOL GetNumberOfConsoleMouseButtons(
    LPDWORD lpNumberOfMouseButtons
    );

BOOL SetConsoleMode(
    HANDLE hConsoleHandle,
    DWORD dwMode
    );

BOOL SetConsoleActiveScreenBuffer(
    HANDLE hConsoleOutput
    );

BOOL FlushConsoleInputBuffer(
    HANDLE hConsoleInput
    );

BOOL SetConsoleScreenBufferSize(
    HANDLE hConsoleOutput,
    COORD dwSize
    );

BOOL SetConsoleCursorPosition(
    HANDLE hConsoleOutput,
    COORD dwCursorPosition
    );

BOOL SetConsoleCursorInfo(
    HANDLE hConsoleOutput,
    CONSOLE_CURSOR_INFO *lpConsoleCursorInfo
    );

BOOL ScrollConsoleScreenBufferA(
    HANDLE hConsoleOutput,
    SMALL_RECT *lpScrollRectangle,
    SMALL_RECT *lpClipRectangle,
    COORD dwDestinationOrigin,
    CHAR_INFO *lpFill
    );

BOOL ScrollConsoleScreenBufferW(
    HANDLE hConsoleOutput,
    SMALL_RECT *lpScrollRectangle,
    SMALL_RECT *lpClipRectangle,
    COORD dwDestinationOrigin,
    CHAR_INFO *lpFill
    );

version(UNICODE) {
	alias ScrollConsoleScreenBufferW ScrollConsoleScreenBuffer;
}
else {
	alias ScrollConsoleScreenBufferA ScrollConsoleScreenBuffer;
}

BOOL SetConsoleWindowInfo(
    HANDLE hConsoleOutput,
    BOOL bAbsolute,
    SMALL_RECT *lpConsoleWindow
    );

BOOL SetConsoleTextAttribute(
    HANDLE hConsoleOutput,
    WORD wAttributes
    );

BOOL SetConsoleCtrlHandler(
    PHANDLER_ROUTINE HandlerRoutine,
    BOOL Add);

BOOL GenerateConsoleCtrlEvent(
    DWORD dwCtrlEvent,
    DWORD dwProcessGroupId
    );

BOOL AllocConsole();

BOOL FreeConsole();

BOOL AttachConsole(
    DWORD dwProcessId
    );

const auto ATTACH_PARENT_PROCESS = (cast(DWORD)-1);

DWORD GetConsoleTitleA(
    LPSTR lpConsoleTitle,
    DWORD nSize
    );


DWORD GetConsoleTitleW(
    LPWSTR lpConsoleTitle,
    DWORD nSize
    );

version(UNICODE) {
	alias GetConsoleTitleW GetConsoleTitle;
}
else {
	alias GetConsoleTitleA GetConsoleTitle;
}

DWORD GetConsoleOriginalTitleA(
    LPSTR lpConsoleTitle,
    DWORD nSize);

DWORD GetConsoleOriginalTitleW(
    LPWSTR lpConsoleTitle,
    DWORD nSize);

version(UNICODE) {
	alias GetConsoleOriginalTitleW GetConsoleOriginalTitle;
}
else {
	alias GetConsoleOriginalTitleA GetConsoleOriginalTitle;
}

BOOL SetConsoleTitleA(
    LPCSTR lpConsoleTitle
    );

BOOL SetConsoleTitleW(
    LPCWSTR lpConsoleTitle
    );

version(UNICODE) {
	alias SetConsoleTitleW SetConsoleTitle;
}
else {
	alias SetConsoleTitleA SetConsoleTitle;
}

struct CONSOLE_READCONSOLE_CONTROL {
    ULONG nLength;           // sizeof( CONSOLE_READCONSOLE_CONTROL )
    ULONG nInitialChars;
    ULONG dwCtrlWakeupMask;
    ULONG dwControlKeyState;
}

alias CONSOLE_READCONSOLE_CONTROL* PCONSOLE_READCONSOLE_CONTROL;

BOOL ReadConsoleA(
    HANDLE hConsoleInput,
	LPVOID lpBuffer,
    DWORD nNumberOfCharsToRead,
    LPDWORD lpNumberOfCharsRead,
    PCONSOLE_READCONSOLE_CONTROL pInputControl
    );

BOOL ReadConsoleW(
    HANDLE hConsoleInput,
	LPVOID lpBuffer,
    DWORD nNumberOfCharsToRead,
    LPDWORD lpNumberOfCharsRead,
    PCONSOLE_READCONSOLE_CONTROL pInputControl
    );

version(UNICODE) {
	alias ReadConsoleW ReadConsole;
}
else {
	alias ReadConsoleA ReadConsole;
}

BOOL WriteConsoleA(
    HANDLE hConsoleOutput,
    VOID *lpBuffer,
    DWORD nNumberOfCharsToWrite,
    LPDWORD lpNumberOfCharsWritten,
    LPVOID lpReserved
    );

BOOL WriteConsoleW(
    HANDLE hConsoleOutput,
    VOID *lpBuffer,
    DWORD nNumberOfCharsToWrite,
    LPDWORD lpNumberOfCharsWritten,
    LPVOID lpReserved
    );

version(UNICODE) {
	alias WriteConsoleW WriteConsole;
}
else {
	alias WriteConsoleA WriteConsole;
}

const auto CONSOLE_TEXTMODE_BUFFER  = 1;

HANDLE CreateConsoleScreenBuffer(
    DWORD dwDesiredAccess,
    DWORD dwShareMode,
    SECURITY_ATTRIBUTES *lpSecurityAttributes,
    DWORD dwFlags,
    LPVOID lpScreenBufferData
    );

UINT GetConsoleCP();

BOOL SetConsoleCP(
    UINT wCodePageID
    );

UINT GetConsoleOutputCP();

BOOL SetConsoleOutputCP(
    UINT wCodePageID
    );

const auto CONSOLE_FULLSCREEN = 1;            // fullscreen console
const auto CONSOLE_FULLSCREEN_HARDWARE = 2;   // console owns the hardware

BOOL GetConsoleDisplayMode(
    LPDWORD lpModeFlags);

const auto CONSOLE_FULLSCREEN_MODE = 1;
const auto CONSOLE_WINDOWED_MODE = 2;

BOOL SetConsoleDisplayMode(
    HANDLE hConsoleOutput,
    DWORD dwFlags,
    PCOORD lpNewScreenBufferDimensions);

HWND GetConsoleWindow();

DWORD GetConsoleProcessList(
    LPDWORD lpdwProcessList,
    DWORD dwProcessCount);

//
// Aliasing apis.
//

BOOL AddConsoleAliasA(
    LPSTR Source,
    LPSTR Target,
    LPSTR ExeName);

BOOL AddConsoleAliasW(
    LPWSTR Source,
    LPWSTR Target,
    LPWSTR ExeName);

version(UNICODE) {
	alias AddConsoleAliasW AddConsoleAlias;
}
else {
	alias AddConsoleAliasA AddConsoleAlias;
}

DWORD GetConsoleAliasA(
    LPSTR Source,
    LPSTR TargetBuffer,
    DWORD TargetBufferLength,
    LPSTR ExeName);

DWORD GetConsoleAliasW(
    LPWSTR Source,
    LPWSTR TargetBuffer,
    DWORD TargetBufferLength,
    LPWSTR ExeName);

version(UNICODE) {
	alias GetConsoleAliasW GetConsoleAlias;
}
else {
	alias GetConsoleAliasA GetConsoleAlias;
}

DWORD GetConsoleAliasesLengthA(
    LPSTR ExeName);

DWORD GetConsoleAliasesLengthW(
    LPWSTR ExeName);

version(UNICODE) {
	alias GetConsoleAliasesLengthW GetConsoleAliasesLength;
}
else {
	alias GetConsoleAliasesLengthA GetConsoleAliasesLength;
}

DWORD GetConsoleAliasExesLengthA();

DWORD GetConsoleAliasExesLengthW();

version(UNICODE) {
	alias GetConsoleAliasExesLengthW GetConsoleAliasExesLength;
}
else {
	alias GetConsoleAliasExesLengthA GetConsoleAliasExesLength;
}

DWORD GetConsoleAliasesA(
    LPSTR AliasBuffer,
    DWORD AliasBufferLength,
    LPSTR ExeName);

DWORD GetConsoleAliasesW(
	LPWSTR AliasBuffer,
    DWORD AliasBufferLength,
    LPWSTR ExeName);

version(UNICODE) {
	alias GetConsoleAliasesW GetConsoleAliases;
}
else {
	alias GetConsoleAliasesA GetConsoleAliases;
}

DWORD GetConsoleAliasExesA(
    LPSTR ExeNameBuffer,
    DWORD ExeNameBufferLength);

DWORD GetConsoleAliasExesW(
    LPWSTR ExeNameBuffer,
    DWORD ExeNameBufferLength);

version(UNICODE) {
	alias GetConsoleAliasExesW GetConsoleAliasExes;
}
else {
	alias GetConsoleAliasExesA GetConsoleAliasExes;
}
