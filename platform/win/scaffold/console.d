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
import core.unicode;
import core.string;

import synch.thread;

import cui.application;
import cui.window;

private int _toNearestConsoleColor(Color clr) {
	// 16 colors on console
	// For each channel, it can be 00, 88, or ff
	// That is, something mid range

	int nearRed, nearGreen, nearBlue;
	int ret;

	nearRed = cast(int)((clr.red * 3.0) + 0.5);
	nearGreen = cast(int)((clr.green * 3.0) + 0.5);
	nearBlue = cast(int)((clr.blue * 3.0) + 0.5);

	if ((nearRed == nearGreen) && (nearGreen == nearBlue)) {
		// gray
		if (clr.red < (Color.DarkGray.red / 2.0)) {
			// Closer to black
			ret = 0;
		}
		else if (clr.red < ((Color.Gray.red - Color.DarkGray.red) / 2.0) + Color.DarkGray.red) {
			// Closer to dark gray
			ret = 8;
		}
		else if (clr.red < ((Color.White.red - Color.Gray.red) / 2.0) + Color.Gray.red) {
			// Closer to light gray
			ret = 7;
		}
		else {
			// Closer to white
			ret = 15;
		}
	}
	else {
		// Nearest color match
		static int[3][] translations = [
			[1,0,0],	// 1, Dark Red
			[0,1,0],	// 2, Dark Green
			[1,1,0],	// 3, Dark Yellow
			[0,0,1],	// 4, Dark Blue
			[1,0,1],	// 5, Dark Magenta
			[0,1,1],	// 6, Dark Cyan

			[2,0,0],	// 9, Dark Red
			[0,2,0],	// 10, Dark Green
			[2,2,0],	// 11, Dark Yellow
			[0,0,2],	// 12, Dark Blue
			[2,0,2],	// 13, Dark Magenta
			[0,2,2],	// 14, Dark Cyan
		];

		float mindistance = 4*3;

		foreach(size_t i, coord; translations) {
			// Compare euclidian distance
			float distance = 0.0;
			float intermediate;

			intermediate = coord[0] - nearRed;
			intermediate *= intermediate;

			distance += intermediate;

			intermediate = coord[1] - nearGreen;
			intermediate *= intermediate;

			distance += intermediate;

			intermediate = coord[2] - nearBlue;
			intermediate *= intermediate;

			distance += intermediate;

			// Omitting square root, it is unnecessary for comparison
			if (mindistance > distance) {
				mindistance = distance;
				ret = i;
				ret++;
				if (ret > 6) {
					ret += 2;
				}
			}	
		}
	}

	return ret;
}

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
			(cast(CuiApplication)Djehuty.app).window.onResize();
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

void ConsoleSetColors(Color fg, Color bg) {
	int fgidx = _toNearestConsoleColor(fg);
	int bgidx = _toNearestConsoleColor(bg);
	int bright = 0;
	if (fgidx > 7) {
		fgidx %= 8;
		bright = 1;
	}
	HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);

	_curAttribs = cast(ushort)(_fgclrvalues[fgidx] | _bgclrvalues[bgidx] | (FOREGROUND_INTENSITY * cast(ushort)bright));

	SetConsoleTextAttribute(hStdout, _curAttribs);
}

void ConsoleSetSize(uint width, uint height) {
}

void ConsoleGetSize(out uint width, out uint height) {
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



void ConsoleGetPosition(uint* x, uint* y) {
	HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);

	CONSOLE_SCREEN_BUFFER_INFO csbi;

	if( !GetConsoleScreenBufferInfo( hStdout, &csbi ))
	   return;

	*x = csbi.dwCursorPosition.X - csbi.srWindow.Left;
	*y = csbi.dwCursorPosition.Y - csbi.srWindow.Top;
}

uint cur_x, cur_y;

void ConsoleSetPosition(uint x, uint y) {
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

void ConsoleSetHome() {
	HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);

	CONSOLE_SCREEN_BUFFER_INFO csbi;

	if( !GetConsoleScreenBufferInfo( hStdout, &csbi )) {
	   return;
	}

	COORD coordScreen = {cast(short)(csbi.srWindow.Left),cast(short)(csbi.dwCursorPosition.Y)};   // home for the cursor

	SetConsoleCursorPosition( hStdout, coordScreen );
}

void ConsoleSetRelative(int x, int y) {
	HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);

	CONSOLE_SCREEN_BUFFER_INFO csbi;

	if( !GetConsoleScreenBufferInfo( hStdout, &csbi )) {
	   return;
	}

	COORD coordScreen = {cast(short)(csbi.dwCursorPosition.X + x),cast(short)(csbi.dwCursorPosition.Y + y)};   // home for the cursor

	if (coordScreen.X >= csbi.srWindow.Right) {
		coordScreen.X = cast(short)(csbi.srWindow.Right-1);
	}

	if (coordScreen.X < csbi.srWindow.Left) {
		coordScreen.X = csbi.srWindow.Left;
	}

	/* if (coordScreen.Y >= csbi.srWindow.Bottom) {
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
	if (x < 0) {
		// move left
	}
	else if (x > 0) {
		// move right
	}

	if (y < 0) {
		// move up
	}
	else if (y > 0) {
		// move down
	} */

}

void ConsoleHideCaret() {
	CONSOLE_CURSOR_INFO ccinfo;

	HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);

	GetConsoleCursorInfo(hStdout, &ccinfo);

	ccinfo.bVisible = FALSE;

	SetConsoleCursorInfo(hStdout, &ccinfo);
}

void ConsoleShowCaret() {
	CONSOLE_CURSOR_INFO ccinfo;

	HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);

	GetConsoleCursorInfo(hStdout, &ccinfo);

	ccinfo.bVisible = TRUE;

	SetConsoleCursorInfo(hStdout, &ccinfo);
}

void ConsolePutString(char[] chrs) {
	HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);

	uint numCharsWritten;

	uint x, y, w, h;
	ConsoleGetPosition(&x,&y);
	ConsoleGetSize(w,h);

	// print line by line

	string str = chrs.dup;

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

void ConsolePutChar(dchar chr) {
	ConsolePutString([ chr ]);
/*	HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);

	CONSOLE_SCREEN_BUFFER_INFO csbi;

	if( !GetConsoleScreenBufferInfo( hStdout, &csbi ))
	   return;

	DWORD ret;

	WriteConsoleOutputAttribute(hStdout, &_curAttribs, 1, csbi.dwCursorPosition, &ret);

	dstring chrs32 = [ chr ];
	wstring chrs = Unicode.toUtf16(chrs32);

	WriteConsoleOutputCharacterW(hStdout, chrs.ptr, chrs.length, csbi.dwCursorPosition, &ret);

	COORD coordScreen = {cast(short)(csbi.dwCursorPosition.X + 1),cast(short)(csbi.dwCursorPosition.Y)};   // home for the cursor

	SetConsoleCursorPosition( hStdout, coordScreen );*/
}

void ConsoleGetChar(out dchar chr, out uint code) {
	// get handle to standard in
	HANDLE hStdin = GetStdHandle(STD_INPUT_HANDLE);

	DWORD cNumRead;

	uint i;

	INPUT_RECORD irInBuf[128];

	for(;;) {
		if (! ReadConsoleInputW(
				hStdin,      // input buffer handle
				irInBuf.ptr, // buffer to read into
				128,         // size of read buffer
				&cNumRead) ){// number of records read
			printf("Fatal Error: Cannot Read from Console Event Buffer\n");
		}

		for (i=0; i<cNumRead; i++) {
			switch(irInBuf[i].EventType) {
				case KEY_EVENT: // keyboard input
					if (irInBuf[i].Event.KeyEvent.bKeyDown == TRUE) {
						// KeyDown

						// The Current Console View Receives the Event
						code = irInBuf[i].Event.KeyEvent.wVirtualKeyCode;

						if (irInBuf[i].Event.KeyEvent.uChar.UnicodeChar > 0) {
							chr = irInBuf[i].Event.KeyEvent.uChar.UnicodeChar;
						}
						else {
							chr = 0;
						}

						return;
					}
					else {
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
