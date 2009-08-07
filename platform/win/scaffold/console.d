/*
 * console.d
 *
 * This file holds the implementation of the console functionality
 * for Windows.
 *
 * Author: Dave Wilkinson
 *
 */

module scaffold.console;

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
			(cast(TuiApplication)Djehuty.app).window.onResize();
			return 0;

		default:
			break;
	}
	return CallWindowProcW(_console_oldproc, hWnd, uMsg, wParam, lParam);
}

static WNDPROC _console_oldproc = null;


ushort _curAttribs;

void ConsoleUninit() {
	HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);

	//SetConsoleOutputCP(_consoleOutputCP);
//	SetConsoleCP(_consoleCP);

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

	width = cinfo.srWindow.Right - cinfo.srWindow.Left + 1;
	height = cinfo.srWindow.Bottom - cinfo.srWindow.Top + 1;
}

void ConsoleClear() {
	DWORD cCharsWritten;
	CONSOLE_SCREEN_BUFFER_INFO csbi;
	DWORD dwConSize;

	HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);

	// Get the number of character cells in the current window space.

	if( !GetConsoleScreenBufferInfo( hStdout, &csbi )) {
	   return;
	}

	COORD coordScreen = {csbi.srWindow.Left,csbi.srWindow.Bottom};   // home for the cursor

	dwConSize = (csbi.srWindow.Right - csbi.srWindow.Left+1);

	do {
		coordScreen.Y--;
		// Fill the entire screen with blanks.

		if( !FillConsoleOutputCharacterW( hStdout, ' ',
		   dwConSize, coordScreen, &cCharsWritten )) {

		   return;
		}

		// Set the buffer's attributes accordingly.

		if( !FillConsoleOutputAttribute( hStdout, csbi.wAttributes,
		   dwConSize, coordScreen, &cCharsWritten )) {

		   return;
		}

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

void ConsolePutString(dchar[] chrs)
{
	HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);

	uint numCharsWritten;

	uint x, y, w, h;
	_ConsoleGetPosition(x,y);
	ConsoleGetSize(w,h);

	// print line by line

	String str = new String(Unicode.toUtf8(chrs));

	//wstring str = Unicode.toUtf16(chrs);

	uint len = str.length;

	uint pos = 0;
	while (len > 0) {
		uint curlen = w - x;
		if (len > curlen) {
			wstring toprint = Unicode.toUtf16((str[pos..pos+curlen]));
			WriteConsoleW(hStdout, toprint.ptr, toprint.length, &numCharsWritten, null);
			len -= curlen;
			pos += curlen;
			x = 0;
			if (y <= h) {
				y++;
			}
		}
		else {
			wstring toprint = Unicode.toUtf16((str[pos..str.length]));
			WriteConsoleW(hStdout, toprint.ptr, toprint.length, &numCharsWritten, null);
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

	StringLiteral32 chrs32 = [ chr ];
	StringLiteral16 chrs = Unicode.toUtf16(chrs32);

	WriteConsoleOutputCharacterW(hStdout, chrs.ptr, chrs.length, csbi.dwCursorPosition, &ret);

	COORD coordScreen = {cast(short)(csbi.dwCursorPosition.X + 1),cast(short)(csbi.dwCursorPosition.Y)};   // home for the cursor

	SetConsoleCursorPosition( hStdout, coordScreen );
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
						//ConsoleWindowonKeyUp( irInBuf[i].Event.KeyEvent.wVirtualKeyCode );
					}
					break;

				default:
					break;
			}
        }
    }
}
