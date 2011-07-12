/*
 * console.d
 *
 * This file implements the Console interfaces for the Linux system.
 *
 * Author: Dave Wilkinson
 *
 */

module scaffold.console;

import djehuty;

import platform.unix.common;
import platform.unix.main;

import Curses = binding.ncurses.ncurses;
import binding.c;

import platform.application;

import synch.thread;
import synch.semaphore;

private Semaphore foo = null;

package void lock() {
	if (foo is null) {
		foo = new Semaphore(1);
	}
	foo.down();
}

package void unlock() {
//	foo = foo;
	foo.up();
}

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

void ConsoleSetColors(Color fg, Color bg) {
	int fgidx = _toNearestConsoleColor(fg);
	int bgidx = _toNearestConsoleColor(bg);

	int bright = 0;
	if (fgidx > 7) {
		fgidx %= 8;
		bright = 1;
	}
	bgidx %= 8;
	if (ApplicationController.instance.usingCurses) {
		int idx = fgidx << 3;
		idx |= bgidx;

		lock();
		if (bright) {
			Curses.wattron(Curses.stdscr, Curses.A_BOLD);
		}
		else {
			Curses.wattroff(Curses.stdscr, Curses.A_BOLD);
		}

		Curses.init_pair(idx, fgidx, bgidx);
		Curses.wattron(Curses.stdscr, Curses.COLOR_PAIR(idx));
		unlock();
	}
	else {
		printf("\x1B[%d;%d;%dm", bright, 30 + fgidx, 40 + bgidx);
	}
}

private int getChar() {
	int ret;
	while(true) {
		if (ApplicationController.instance.usingCurses) {
			lock();
			ret = Curses.wgetch(Curses.stdscr);
			unlock();
			if (ret != Curses.ERR) {
				break;
			}
		}
		else {
			ret = getc(stdin);
			break;
		}
	}

	return ret;
}

//will return the next character pressed
Key ConsoleGetKey() {
	Key ret;

	ubyte[18] tmp;
	uint count;

	ret.code = getChar();

	if (ret.code != 0x1B) {
		// Not an escape sequence

		if (ret.code == Curses.KEY_MOUSE || ret.code == Curses.KEY_RESIZE || ret.code == Curses.KEY_EVENT || ret.code >= Curses.KEY_MAX) {
			return ret;
		}

		if (ret.code == 127 || ret.code == 8 || ret.code == 9 || ret.code == 13 || ret.code == 10) {
		}
		// For ctrl+char
		else if (ret.code < 26) {
			ret.leftControl = true;
			ret.rightControl = true;
			ret.code = Key.A + ret.code - 1;
	//Curses.move(1,0);
	//Console.put("                                                ");
	//Curses.move(1,0);
	//Console.put("alt: ", ret.alt, " ctrl: ", ret.ctrl, " shift: ", ret.shift, " code: ", ret.code);
			return ret;
		}
		// For F5-F16:
		else if (ret.code >= 281 && ret.code <= 292) {
			ret.code -= 12;
			ret.shift = true;
		}
		else if (ret.code >= 293 && ret.code <= 304) {
			ret.code -= 24;
			ret.leftControl = true;
			ret.rightControl = true;
		}
		else if (ret.code >= 305 && ret.code <= 316) {
			ret.code -= 36;
			ret.leftControl = true;
			ret.rightControl = true;
			ret.shift = true;
		}
		else if (ret.code >= 317 && ret.code <= 328) {
			ret.code -= 48;
			ret.leftAlt = true;
			ret.rightAlt = true;
		}

		consoleTranslateKey(ret);

		return ret;
	}

	// Escape sequence...
	ret.code = getChar();

	// Get extended commands
	if (ret.code == 0x1B) {
		// ESCAPE ESCAPE -> Escape
		ret.code = Key.Escape;
	}
	else if (ret.code == '[') {
		ret.code = getChar();
		if (ret.code == '1') {
			ret.code = getChar();
			if (ret.code == '~') {
				ret.code = Key.Home;
			}
			else if (ret.code == '#') {
				ret.code = getChar();
				if (ret.code == '~') {
					ret.code = Key.F5;
				}
				else if (ret.code == ';') {
					ret.code = getChar();
					if (ret.code == '2') {
						ret.shift = true;
						ret.code = Key.F5;
					}
				}
			}
			else if (ret.code == '7') {
				ret.code = getChar();
				if (ret.code == '~') {
					ret.code = Key.F6;
				}
				else if (ret.code == ';') {
					ret.code = getChar();
					if (ret.code == '2') {
						ret.shift = true;
						ret.code = Key.F6;
					}
				}
			}
			else if (ret.code == ';') {
				// Arrow Keys
				ret.code = getChar();
				getModifiers(ret);

				if (ret.code == 'A') {
					ret.code = Key.Up;
				}
				else if (ret.code == 'B') {
					ret.code = Key.Down;
				}
				else if (ret.code == 'C') {
					ret.code = Key.Right;
				}
				else if (ret.code == 'D') {
					ret.code = Key.Left;
				}
			}
			else {
				ret.code = getChar();
			}
		}
		else if (ret.code == '2') {
			ret.code = getChar();
			if (ret.code == '~') {
			}
			else if (ret.code == ';') {
				// Alt + Insert
				ret.code = getChar();
				getModifiers(ret);
				if (ret.code == '~') {
					ret.code = Key.Insert;
				}
			}
		}
		else if (ret.code == '3') {
			ret.code = getChar();
		}
		else if (ret.code == '4') {
			ret.code = getChar();
		}
		else if (ret.code == '5') {
			ret.code = getChar();
		}
		else if (ret.code == '6') {
			ret.code = getChar();
		}
		else {
		}
	}
	else if (ret.code == 'O') {
		ret.code = getChar();

		// F1, F2, F3, F4
		if (ret.code == '1') {
			ret.code = getChar();
			if (ret.code == ';') {
				ret.code = getChar();
				getModifiers(ret);

				if (ret.code == 'P') {
					ret.code = Key.F1;
				}
				else if (ret.code == 'Q') {
					ret.code = Key.F2;
				}
				else if (ret.code == 'R') {
					ret.code = Key.F3;
				}
				else if (ret.code == 'S') {
					ret.code = Key.F4;
				}
			}
		}
		else if (ret.code == 'H') {
			ret.code = Key.Home;
		}
		else if (ret.code == 'F') {
			ret.code = Key.End;
		}
		else if (ret.code == 0x80) {
			ret.code = Key.F1;
		}
		else if (ret.code == 0x81) {
			ret.code = Key.F2;
		}
		else if (ret.code == 0x82) {
			ret.code = Key.F3;
		}
		else if (ret.code == 0x83) {
			ret.code = Key.F4;
		}
	}
	else {
		// Alt + Char
		ret.rightAlt = true;
		ret.leftAlt = true;
		consoleTranslateKey(ret);
	}

	return ret;
}

void getModifiers(ref Key key) {
	if (key.code == '2' || key.code == '4' || key.code == '6' || key.code == '8') {
		key.shift = true;
	}

	if (key.code == '3' || key.code == '4' || key.code == '7' || key.code == '8') {
		key.leftAlt = true;
		key.rightAlt = true;
	}

	if (key.code == '5' || key.code == '6' || key.code == '7' || key.code == '8') {
		key.leftControl = true;
		key.rightControl = true;
	}

	if (key.shift || key.alt || key.control) {
		key.code = getChar();
	}
}

void consoleTranslateKey(ref Key ky)
{
	switch(ky.code) {
		case '~':
		case '!':
		case '@':
		case '#':
		case '$':
		case '%':
		case '^':
		case '&':
		case '*':
		case '(':
		case ')':
		case '_':
		case '+':
		case '{':
		case '}':
		case ':':
		case '"':
		case '<':
		case '>':
		case '|':
		case '?':
			ky.shift = true;
			break;
		default:
			if (ky.code >= 'A' && ky.code <= 'Z') {
				ky.shift = true;
			}
			else if (ky.code >= '0' && ky.code <= '9') {
				ky.shift = false;
			}
			break;
	}
	ky.code = keyTranslation[ky.code];
}

uint keyTranslation[Curses.KEY_MAX] = [
	' ': Key.Space,
	'\n': Key.Return,
	'\r': Key.Return,
	'\t': Key.Tab,
	'\b': Key.Backspace,
	127: Key.Backspace,
	'a': Key.A,
	'b': Key.B,
	'c': Key.C,
	'd': Key.D,
	'e': Key.E,
	'f': Key.F,
	'g': Key.G,
	'h': Key.H,
	'i': Key.I,
	'j': Key.J,
	'k': Key.K,
	'l': Key.L,
	'm': Key.M,
	'n': Key.N,
	'o': Key.O,
	'p': Key.P,
	'q': Key.Q,
	'r': Key.R,
	's': Key.S,
	't': Key.T,
	'u': Key.U,
	'v': Key.V,
	'w': Key.W,
	'x': Key.X,
	'y': Key.Y,
	'z': Key.Z,
	'A': Key.A,
	'B': Key.B,
	'C': Key.C,
	'D': Key.D,
	'E': Key.E,
	'F': Key.F,
	'G': Key.G,
	'H': Key.H,
	'I': Key.I,
	'J': Key.J,
	'K': Key.K,
	'L': Key.L,
	'M': Key.M,
	'N': Key.N,
	'O': Key.O,
	'P': Key.P,
	'Q': Key.Q,
	'R': Key.R,
	'S': Key.S,
	'T': Key.T,
	'U': Key.U,
	'V': Key.V,
	'W': Key.W,
	'X': Key.X,
	'Y': Key.Y,
	'Z': Key.Z,
	'0': Key.Zero,
	'1': Key.One,
	'2': Key.Two,
	'3': Key.Three,
	'4': Key.Four,
	'5': Key.Five,
	'6': Key.Six,
	'7': Key.Seven,
	'8': Key.Eight,
	'9': Key.Nine,
	'`': Key.SingleQuote,
	'~': Key.SingleQuote,
	'!': Key.One,
	'@': Key.Two,
	'#': Key.Three,
	'$': Key.Four,
	'%': Key.Five,
	'^': Key.Six,
	'&': Key.Seven,
	'*': Key.Eight,
	'(': Key.Nine,
	')': Key.Zero,
	'-': Key.Minus,
	'_': Key.Minus,
	'=': Key.Equals,
	'+': Key.Equals,
	'[': Key.LeftBracket,
	'{': Key.LeftBracket,
	']': Key.RightBracket,
	'}': Key.RightBracket,
	';': Key.Semicolon,
	':': Key.Semicolon,
	'\'': Key.Apostrophe,
	'"': Key.Apostrophe,
	',': Key.Comma,
	'<': Key.Comma,
	'>': Key.Period,
	'.': Key.Period,
	'/': Key.Foreslash,
	'?': Key.Foreslash,
	'\\': Key.Backslash,
	'|': Key.Backslash,
	Curses.KEY_DOWN: Key.Down,
	Curses.KEY_UP: Key.Up,
	Curses.KEY_LEFT: Key.Left,
	Curses.KEY_RIGHT: Key.Right,
	Curses.KEY_HOME: Key.Home,
	Curses.KEY_BACKSPACE: Key.Backspace,
	Curses.KEY_DC: Key.Delete,
	Curses.KEY_F1: Key.F1,
	Curses.KEY_F2: Key.F2,
	Curses.KEY_F3: Key.F3,
	Curses.KEY_F4: Key.F4,
	Curses.KEY_F5: Key.F5,
	Curses.KEY_F6: Key.F6,
	Curses.KEY_F7: Key.F7,
	Curses.KEY_F8: Key.F8,
	Curses.KEY_F9: Key.F9,
	Curses.KEY_F10: Key.F10,
	Curses.KEY_F11: Key.F11,
	Curses.KEY_F12: Key.F12,
	Curses.KEY_F13: Key.F13,
	Curses.KEY_F14: Key.F14,
	Curses.KEY_F15: Key.F15,
	Curses.KEY_F16: Key.F16,
	Curses.KEY_NPAGE: Key.PageDown,
	Curses.KEY_PPAGE: Key.PageUp,
	Curses.KEY_ENTER: Key.Return,
	Curses.KEY_END: Key.End
];


struct winsize {
	ushort ws_row;
	ushort ws_col;
	ushort ws_xpixel;
	ushort ws_ypixel;
}

//window size

int m_width;
int m_height;

bool m_winsize_state;

//position tracking

int m_x;
int m_y;
termios m_term_info_saved;
termios m_term_info_working;

//signal handler for terminal Size

extern(C) int tcgetattr(int, termios*);
extern(C) int tcsetattr(int, int, termios*);

extern(C) void close_sig_handler(int signal) {
	ConsoleUninit();
	exit(0);
}

static const int TCSANOW = 0;

/* Initialize new terminal i/o settings */
void initTermios(bool echo) {
	tcgetattr(0, &m_term_info_saved); /* grab old terminal i/o settings */
	m_term_info_working = m_term_info_saved; /* make new settings same as old settings */
	m_term_info_working.c_lflag &= ~ICANON; /* disable buffered i/o */
	m_term_info_working.c_lflag &= echo ? ECHO : ~ECHO; /* set echo mode */
	tcsetattr(0, TCSANOW, &m_term_info_working); /* use these new terminal i/o settings now */
}

/* Restore old terminal i/o settings */
void resetTermios() {
	tcsetattr(0, TCSANOW, &m_term_info_saved);
}

void ConsoleInit() {
	// Preserve console
	printf("\x1B7");

	setlocale(LC_ALL, "");
	setlocale(LC_CTYPE, "");

	setvbuf (stdout, null, _IONBF, 0);

	setlocale(LC_ALL, "");
	setlocale(LC_CTYPE, "");

	initTermios(false);
}

void ConsoleUninit() {
	// Reset colors
	printf("\x1B[0m");

	resetTermios();
}

void ConsoleClear() {
	if (ApplicationController.instance.usingCurses) {
		lock();
		Curses.wclear(Curses.stdscr);
		Curses.wrefresh(Curses.stdscr);
		unlock();
	}
	else {
		printf("\x1B[2J\x1B[0;0H");
	}
}

void ConsoleSetRelative(int x, int y) {
	int newx;
	int newy;

	lock();
	Curses.getyx(Curses.stdscr, m_y, m_x);

	newx = m_x + x;
	newy = m_y + y;

	Curses.wmove(Curses.stdscr, newy, newx);
	unlock();
}

void ConsoleGetPosition(uint* x, uint* y) {
	lock();
	Curses.getyx(Curses.stdscr, m_y, m_x);
	unlock();
	*x = m_x;
	*y = m_y;
}

void ConsoleSetPosition(uint x, uint y) {
    if (x >= m_width) { x = m_width-1; }

    if (y >= m_height) { y = m_height-1; }

    if (x < 0) { x = 0; }

    if (y < 0) { y = 0; }

	lock();
	Curses.wmove(Curses.stdscr, y,x);
	unlock();
}

void ConsoleHideCaret() {
	lock();
	printf("\x1B[?25l");
	Curses.curs_set(0);
	unlock();
}

void ConsoleShowCaret() {
	lock();
	printf("\x1B[?25h");
	Curses.curs_set(1);
	unlock();
}

void ConsoleSetHome() {
	if (ApplicationController.instance.usingCurses) {
		lock();
		Curses.getyx(Curses.stdscr, m_y, m_x);
		m_x = 0;
		Curses.wmove(Curses.stdscr, m_y, m_x);
		unlock();
	}
	else {
		printf("\x1B[0G");
	}
}

void ConsolePutString(char[] chrs) {
	lock();
	Curses.getyx(Curses.stdscr, m_y, m_x);
	char[] utf8 = chrs;
	utf8 ~= '\0';
	bool goBackOneLine = false;
	if (ApplicationController.instance.usingCurses) {
		for (uint i; i < utf8.length; i++) {
			if (utf8[i] == '\r' || utf8[i] == '\n' || utf8[i] == '\0') {
				if (utf8[0..i].utflen() + m_x >= m_width) {
					utf8 = utf8.substring(0, m_width - m_x);
					utf8 ~= '\0';
					goBackOneLine = true;
				}
				else {
					utf8[i] = '\0';	
				}
				Curses.wprintw(Curses.stdscr, "%s", utf8.ptr);
				unlock();
				if (goBackOneLine) {
		//			ConsoleSetPosition(m_width - 1, m_y);
				}
				lock();
				Curses.wrefresh(Curses.stdscr);
				unlock();
				return;
			}
		}
	}
	else {
		printf("%s", utf8.ptr);
	}
	unlock();
}

void ConsolePutChar(dchar chr) {
	dchar[] chrarray = [ chr, '\0' ];
	char[] chrs = Unicode.toUtf8(chrarray);

	if (ApplicationController.instance.usingCurses) {
		if (chr == '\r' || chr == '\n') {
			ConsoleSetRelative(0, 1);
			ConsoleSetHome();
		}
		else {
			lock();
			Curses.wprintw(Curses.stdscr, "%s", chrs.ptr);
			Curses.wrefresh(Curses.stdscr);
			unlock();
		}
	}
	else {
		printf("%s", chrs.ptr);
	}
}

void ConsoleGetSize(out uint width, out uint height) {
	lock();
	Curses.getmaxyx(Curses.stdscr, m_height, m_width);

	width = m_width;
	height = m_height;

	unlock();
}

void ConsoleGetChar(out dchar chr, out uint code) {
}
