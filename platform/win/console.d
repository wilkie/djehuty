/*
 * console.d
 *
 * This file holds the implementation of the console functionality
 * for Windows.
 *
 * Author: Dave Wilkinson
 *
 */

module platform.win.console;

import platform.win.common;

import core.main;
import core.literals;
import core.unicode;
import core.string;

import synch.thread;

import tui.application;
import tui.window;

ushort _fgclrvalues[] =
[

0,
FOREGROUND_RED,
FOREGROUND_GREEN,
FOREGROUND_GREEN | FOREGROUND_RED,
FOREGROUND_BLUE,
FOREGROUND_RED | FOREGROUND_BLUE,
FOREGROUND_BLUE | FOREGROUND_GREEN,
FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE,

];

ushort _bgclrvalues[] =
[

0,
BACKGROUND_RED,
BACKGROUND_GREEN,
BACKGROUND_GREEN | BACKGROUND_RED,
BACKGROUND_BLUE,
BACKGROUND_RED | BACKGROUND_BLUE,
BACKGROUND_BLUE | BACKGROUND_GREEN,
BACKGROUND_RED | BACKGROUND_GREEN | BACKGROUND_BLUE,

];

// I subclass the console window to detect resizes
extern(Windows)
int ConsoleProc(HWND hWnd, uint uMsg, WPARAM wParam, LPARAM lParam)
{
	switch(uMsg)
	{
		case WM_SIZE:
			(cast(TuiApplication)Djehuty.app).getWindow().OnResize();
			return 0;

		default:
			break;
	}
	return CallWindowProcW(_console_oldproc, hWnd, uMsg, wParam, lParam);
}

static WNDPROC _console_oldproc = null;

Thread t;

int _console_x;
int _console_y;
ushort _curAttribs;

UINT _consoleCP;
UINT _consoleOutputCP;

void thread_proc(bool pleaseStop)
{
	if (pleaseStop)
	{
		// XXX: What to do???
		return;
	}

	// keep looking at the console window for size changes
	CONSOLE_SCREEN_BUFFER_INFO cinfo;

	HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);

	while(1)
	{
		GetConsoleScreenBufferInfo(hStdout, &cinfo);

		if (_console_x != cinfo.srWindow.Right - cinfo.srWindow.Left+1 ||
			_console_y != cinfo.srWindow.Bottom - cinfo.srWindow.Top)
		{
			_console_x = cinfo.srWindow.Right - cinfo.srWindow.Left+1;
			_console_y = cinfo.srWindow.Bottom - cinfo.srWindow.Top;

			(cast(TuiApplication)Djehuty.app).getWindow().OnResize();
		}

		t.sleep(100);
	}
}

void ConsoleInit()
{
	HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);

	_consoleCP = GetConsoleCP();
	_consoleOutputCP = GetConsoleOutputCP();

	SetConsoleOutputCP(65001);
	SetConsoleCP(65001);

	DWORD consoleMode;
	GetConsoleMode(hStdout, &consoleMode);

	// Turn off automatic line advancement
	consoleMode &= ~(0x2);

	SetConsoleMode(hStdout, consoleMode);

	t = new Thread;

	t.setDelegate(&thread_proc);

	t.start();
}

void ConsoleUninit() {
	HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);

	SetConsoleOutputCP(_consoleOutputCP);
	SetConsoleCP(_consoleCP);

	DWORD consoleMode;
	GetConsoleMode(hStdout, &consoleMode);

	// Turn on automatic line advancement
	consoleMode |= 0x2;

	SetConsoleMode(hStdout, consoleMode);
}

void ConsoleSetColors(uint fg, uint bg, int bright)
{
	HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);

	_curAttribs = cast(ushort)(_fgclrvalues[fg] | _bgclrvalues[bg] | (FOREGROUND_INTENSITY * cast(ushort)bright));

	SetConsoleTextAttribute(hStdout, _curAttribs);
}

void ConsoleSetSize(uint width, uint height)
{
}

void ConsoleGetSize(out uint width, out uint height)
{
	CONSOLE_SCREEN_BUFFER_INFO cinfo;

	HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);

	GetConsoleScreenBufferInfo(hStdout, &cinfo);

	width = cinfo.srWindow.Right - cinfo.srWindow.Left+1;
	height = cinfo.srWindow.Bottom - cinfo.srWindow.Top;
}

void ConsoleClear()
{
	DWORD cCharsWritten;
	CONSOLE_SCREEN_BUFFER_INFO csbi;
	DWORD dwConSize;

	HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);

	// Get the number of character cells in the current window space.

	if( !GetConsoleScreenBufferInfo( hStdout, &csbi ))
	{
	   return;
	}

	COORD coordScreen = {csbi.srWindow.Left,csbi.srWindow.Bottom};   // home for the cursor

	dwConSize = (csbi.srWindow.Right - csbi.srWindow.Left+1);

	do
	{
		coordScreen.Y--;
		// Fill the entire screen with blanks.

		if( !FillConsoleOutputCharacterW( hStdout, ' ',
		   dwConSize, coordScreen, &cCharsWritten ))
		   return;

		// Set the buffer's attributes accordingly.

		if( !FillConsoleOutputAttribute( hStdout, csbi.wAttributes,
		   dwConSize, coordScreen, &cCharsWritten ))
		   return;

	} while (coordScreen.Y >= csbi.srWindow.Top)

	// Put the cursor at its home coordinates.
	SetConsoleCursorPosition( hStdout, coordScreen );
}



void _ConsoleGetPosition(ref uint x, ref uint y)
{
	HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);

	CONSOLE_SCREEN_BUFFER_INFO csbi;

	if( !GetConsoleScreenBufferInfo( hStdout, &csbi ))
	   return;

	x = csbi.dwCursorPosition.X - csbi.srWindow.Left;
	y = csbi.dwCursorPosition.Y - csbi.srWindow.Top;

}

uint cur_x, cur_y;

void ConsoleSavePosition()
{
	_ConsoleGetPosition(cur_x,cur_y);
}

void ConsoleRestorePosition()
{
	ConsoleSetPosition(cur_x,cur_y);
}

void ConsoleSetPosition(uint x, uint y)
{
	HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);

	CONSOLE_SCREEN_BUFFER_INFO csbi;

	if( !GetConsoleScreenBufferInfo( hStdout, &csbi ))
	{
	   return;
	}

	COORD coordScreen = {cast(short)(csbi.srWindow.Left + x),cast(short)(csbi.srWindow.Top + y)};   // home for the cursor

	if (coordScreen.X >= csbi.srWindow.Right)
	{
		coordScreen.X = cast(short)(csbi.srWindow.Right-1);
	}

	SetConsoleCursorPosition( hStdout, coordScreen );
}

void ConsoleSetHome()
{
	HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);

	CONSOLE_SCREEN_BUFFER_INFO csbi;

	if( !GetConsoleScreenBufferInfo( hStdout, &csbi ))
	   return;

	COORD coordScreen = {cast(short)(csbi.srWindow.Left),cast(short)(csbi.dwCursorPosition.Y)};   // home for the cursor

	SetConsoleCursorPosition( hStdout, coordScreen );
}

void ConsoleSetRelative(int x, int y)
{
	HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);

	CONSOLE_SCREEN_BUFFER_INFO csbi;

	if( !GetConsoleScreenBufferInfo( hStdout, &csbi ))
	   return;

	COORD coordScreen = {cast(short)(csbi.dwCursorPosition.X + x),cast(short)(csbi.dwCursorPosition.Y + y)};   // home for the cursor

	if (coordScreen.X >= csbi.srWindow.Right)
	{
		coordScreen.X = cast(short)(csbi.srWindow.Right-1);
	}

	if (coordScreen.X < csbi.srWindow.Left)
	{
		coordScreen.X = csbi.srWindow.Left;
	}

	/* if (coordScreen.Y >= csbi.srWindow.Bottom)
	{
		// scroll down the difference
		uint diff = coordScreen.Y - csbi.srWindow.Bottom;

		diff++;

		SMALL_RECT rt;

		rt.Left = csbi.srWindow.Left;
		rt.Right = csbi.srWindow.Right;
		rt.Top = cast(short)(csbi.srWindow.Top-diff);
		rt.Bottom = cast(short)(csbi.srWindow.Bottom-diff);

		SetConsoleWindowInfo(hStdout, 1, &rt);
	} */

	SetConsoleCursorPosition( hStdout, coordScreen );
/*
	if (x < 0)
	{
		// move left
	}
	else if (x > 0)
	{
		// move right
	}

	if (y < 0)
	{
		// move up
	}
	else if (y > 0)
	{
		// move down
	} */

}

void ConsoleHideCaret()
{
	CONSOLE_CURSOR_INFO ccinfo;

	HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);

	GetConsoleCursorInfo(hStdout, &ccinfo);

	ccinfo.bVisible = FALSE;

	SetConsoleCursorInfo(hStdout, &ccinfo);
}

void ConsoleShowCaret()
{
	CONSOLE_CURSOR_INFO ccinfo;

	HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);

	GetConsoleCursorInfo(hStdout, &ccinfo);

	ccinfo.bVisible = TRUE;

	SetConsoleCursorInfo(hStdout, &ccinfo);
}


dchar CP866_to_UTF32[] = [

	0x0410, 0x0411, 0x0412, 0x0413, 0x0414, 0x0415, 0x0416, 0x0417, 0x0418, 0x0419, 0x041a, 0x041b, 0x041c, 0x041d, 0x041e, 0x041f,
	0x0420, 0x0421, 0x0422, 0x0423, 0x0424, 0x0425, 0x0426, 0x0427, 0x0428, 0x0429, 0x042a, 0x042b, 0x042c, 0x042d, 0x042e, 0x042f,
	0x0430, 0x0431, 0x0432, 0x0433, 0x0434, 0x0435, 0x0436, 0x0437, 0x0438, 0x0439, 0x043a, 0x043b, 0x043c, 0x043d, 0x043e, 0x043f,

	0x2591, 0x2592, 0x2593, 0x2502, 0x2524, 0x2561, 0x2562, 0x2556, 0x2555, 0x2563, 0x2551, 0x2557, 0x255D, 0x255C, 0x255B, 0x2510,
	0x2514, 0x2534, 0x252C, 0x251C, 0x2500, 0x253C, 0x255E, 0x255F, 0x255A, 0x2554, 0x2569, 0x2566, 0x2560, 0x2550, 0x256C, 0x2567,
	0x2568, 0x2564, 0x2565, 0x2559, 0x2558, 0x2552, 0x2553, 0x256B, 0x256A, 0x2518, 0x250C, 0x2588, 0x2584, 0x258C, 0x2590, 0x2580,

	0x0440, 0x0441, 0x0442, 0x0443, 0x0444, 0x0445, 0x0446, 0x0447, 0x0448, 0x0449, 0x044a, 0x044b, 0x044c, 0x044d, 0x044e, 0x044F,
	0x0401, 0x0451, 0x0404, 0x0454, 0x0407, 0x0457, 0x040E, 0x045E, 0x00B0, 0x2219, 0x00B7, 0x221A, 0x2116, 0x00A4, 0x25A0, 0x00A0,

	];

void ConsolePutString(dchar[] chrs)
{
	HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);

	uint numCharsWritten;

	uint x, y, w, h;
	_ConsoleGetPosition(x,y);
	ConsoleGetSize(w,h);

	// TODO: Worry about codepage?

	// print line by line

	String str = new String(Unicode.toUtf16(chrs));
	uint len = str.length;

	uint pos = 0;
	while (len > 0) {
		uint curlen = w - x;
		if (len > curlen) {
			SetConsoleTitleW("boob"w.ptr);
			WriteConsoleW(hStdout, str[pos..pos+curlen].ptr, curlen, &numCharsWritten, null);
			len -= curlen;
			pos += curlen;
			x = 0;
			if (y <= h) {
				y++;
			}
		}
		else {
			SetConsoleTitleW("boo"w.ptr);
			WriteConsoleW(hStdout, str[pos..str.length].ptr, len, &numCharsWritten, null);
			x += str.length - pos;
			len = 0;
		}
	}
}

void ConsolePutChar(dchar chr)
{
	HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);

	CONSOLE_SCREEN_BUFFER_INFO csbi;

	if( !GetConsoleScreenBufferInfo( hStdout, &csbi ))
	   return;

	DWORD ret;

	WriteConsoleOutputAttribute(hStdout, &_curAttribs, 1, csbi.dwCursorPosition, &ret);

	void progressCursor() {
		COORD coordScreen = {cast(short)(csbi.dwCursorPosition.X + 1),cast(short)(csbi.dwCursorPosition.Y)};   // home for the cursor

		SetConsoleCursorPosition( hStdout, coordScreen );
	}

	if (chr >= 0x410 && chr <= 0x43c)
	{
		// this is cp866
		// on windows, we translate the unicode back
		char[] chrs_small = [ cast(char)((chr-0x410)+0x80) ];

		WriteConsoleOutputCharacterA(hStdout, chrs_small.ptr, 1, csbi.dwCursorPosition, &ret);

		return;
	}
	else if (chr >= 0x440 && chr <= 0x44F)
	{
		// this is cp866
		// on windows, we translate the unicode back
		char[] chrs_small = [ cast(char)((chr-0x440)+0xe0) ];

		WriteConsoleOutputCharacterA(hStdout, chrs_small.ptr, 1, csbi.dwCursorPosition, &ret);

		COORD coordScreen = {cast(short)(csbi.dwCursorPosition.X + 1),cast(short)(csbi.dwCursorPosition.Y)};   // home for the cursor

		SetConsoleCursorPosition( hStdout, coordScreen );

		return;
	}
	else if (chr >= 0x2591 && chr <= 0x2593)
	{
		// this is cp866
		// on windows, we translate the unicode back
		char[] chrs_small = [ cast(char)((chr-0x2591)+0xB0) ];

		WriteConsoleOutputCharacterA(hStdout, chrs_small.ptr, 1, csbi.dwCursorPosition, &ret);

		return;
	}
	else if ((chr >= 0x0401 && chr <= 0x045E) || chr == 0x00B0 || chr == 0x00B7 || chr == 0x00A0 || chr == 0x00A4 || chr == 0x2219 || chr ==  0x221A || chr ==  0x2116 || chr ==  0x25A0)
	{
		for (uint i=0x77; i < 0x80; i++)
		{
			if (CP866_to_UTF32[i] == chr)
			{
				// this is cp866
				// on windows, we translate the unicode back
				char[] chrs_small = [ cast(char)(i+0x80) ];

				WriteConsoleOutputCharacterA(hStdout, chrs_small.ptr, 1, csbi.dwCursorPosition, &ret);

				return;
			}
		}
	}
	else if (chr >= 0x2502 && chr <= 0x2580)
	{
		for (uint i=0x70; i < 0x77; i++)
		{
			if (CP866_to_UTF32[i] == chr)
			{
				// this is cp866
				// on windows, we translate the unicode back
				char[] chrs_small = [ cast(char)(i+0x80) ];

				WriteConsoleOutputCharacterA(hStdout, chrs_small.ptr, 1, csbi.dwCursorPosition, &ret);

				return;
			}
		}
	}

	StringLiteral32 chrs32 = [ chr ];
	StringLiteral16 chrs = Unicode.toUtf16(chrs32);

	WriteConsoleOutputCharacterW(hStdout, chrs.ptr, chrs.length, csbi.dwCursorPosition, &ret);
}

void ConsoleGetChar(out dchar chr, out uint code)
{
	// get handle to standard in
	HANDLE hStdin = GetStdHandle(STD_INPUT_HANDLE);

	DWORD cNumRead;

	uint i;

	INPUT_RECORD irInBuf[128];

	for(;;)
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
						code = irInBuf[i].Event.KeyEvent.wVirtualKeyCode;

						if (irInBuf[i].Event.KeyEvent.uChar.UnicodeChar > 0)
						{
							chr = irInBuf[i].Event.KeyEvent.uChar.UnicodeChar;
						}
						else
						{
							chr = 0;
						}

						return;
					}
					else
					{
						// KeyUp

						// The Current Console View Receives the Event
						//ConsoleWindowOnKeyUp( irInBuf[i].Event.KeyEvent.wVirtualKeyCode );
					}
					break;

				default:
					break;
			}
        }
    }
}
