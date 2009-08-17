/*
 * console.d
 *
 * This file implements the Console interfaces for the Linux system.
 *
 * Author: Dave Wilkinson
 *
 */

module scaffold.console;

import core.main;
import core.unicode;
import core.definitions;
import core.string;

import platform.unix.common;
import platform.unix.main;

import synch.thread;

import tui.application;
import tui.window;

void ConsoleSetColors(uint fg, uint bg, int bright) {
//	printf("\x1B[%d;%d;%dm", bright, 30 + fg, 40 + bg);
	int idx = fg << 3;
	idx |= bg;

	if (bright) {
		Curses.attron(Curses.A_BOLD);
	}
	else {
		Curses.attroff(Curses.A_BOLD);
	}

	Curses.init_pair(idx, fg, bg);
	Curses.attron(Curses.COLOR_PAIR(idx));
}

import io.console;

//will return the next character pressed
Key consoleGetKey() {
	Key ret;

	ubyte[18] tmp;
	uint count;

	ret.code = Curses.getch();
//	Curses.move(0,0);
//	Console.put("                                                ");
//	Curses.move(0,0);
//	Console.put(ret.code, " ");

	if (ret.code != 0x1B) {
		// Not an escape sequence

		if (ret.code == Curses.KEY_MOUSE || ret.code == Curses.KEY_RESIZE || ret.code == Curses.KEY_EVENT || ret.code >= Curses.KEY_MAX) {
			return ret;
		}

		if (ret.code == 9 || ret.code == 13) {
		}
		// For ctrl+char
		else if (ret.code < 26) {
			ret.ctrl = true;
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
			ret.ctrl = true;
		}
		else if (ret.code >= 305 && ret.code <= 316) {
			ret.code -= 36;
			ret.ctrl = true;
			ret.shift = true;
		}
		else if (ret.code >= 317 && ret.code <= 328) {
			ret.code -= 48;
			ret.alt = true;
		}

		consoleTranslateKey(ret);
	//Curses.move(1,0);
	//Console.put("                                                ");
	//Curses.move(1,0);
	//Console.put("alt: ", ret.alt, " ctrl: ", ret.ctrl, " shift: ", ret.shift, " code: ", ret.code);

		return ret;
	}

	// Escape sequence...
	ret.code = Curses.getch();
	//Console.put(ret.code, " ");

	// Get extended commands
	if (ret.code == 0x1B) {
		// ESCAPE ESCAPE -> Escape
		ret.code = Key.Escape;
	}
	else if (ret.code == '[') {
		ret.code = Curses.getch();
	//Console.put(ret.code, " ");
		if (ret.code == '1') {
			ret.code = Curses.getch();
	//Console.put(ret.code, " ");
			if (ret.code == '~') {
				ret.code = Key.Home;
			}
			else if (ret.code == '#') {
				ret.code = Curses.getch();
	//Console.put(ret.code, " ");
				if (ret.code == '~') {
					ret.code = Key.F5;
				}
				else if (ret.code == ';') {
					ret.code = Curses.getch();
	//Console.put(ret.code, " ");
					if (ret.code == '2') {
						ret.shift = true;
						ret.code = Key.F5;
					}
				}
			}
			else if (ret.code == '7') {
				ret.code = Curses.getch();
	//Console.put(ret.code, " ");
				if (ret.code == '~') {
					ret.code = Key.F6;
				}
				else if (ret.code == ';') {
					ret.code = Curses.getch();
	//Console.put(ret.code, " ");
					if (ret.code == '2') {
						ret.shift = true;
						ret.code = Key.F6;
					}
				}
			}
			else if (ret.code == ';') {
				// Arrow Keys
				ret.code = Curses.getch();
	//Console.put(ret.code, " ");
				getModifiers(ret);
	//Console.put(ret.code, " ");

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
				ret.code = Curses.getch();
	//Console.put(ret.code, " ");
			}
		}
		else if (ret.code == '2') {
			ret.code = Curses.getch();
	//Console.put(ret.code, " ");
			if (ret.code == '~') {
			}
			else if (ret.code == ';') {
				// Alt + Insert
				ret.code = Curses.getch();
	//Console.put(ret.code, " ");
				getModifiers(ret);
	//Console.put(ret.code, " ");
				if (ret.code == '~') {
					ret.code = Key.Insert;
				}
			}
		}
		else if (ret.code == '3') {
			ret.code = Curses.getch();
	//Console.put(ret.code, " ");
		}
		else if (ret.code == '4') {
			ret.code = Curses.getch();
	//Console.put(ret.code, " ");
		}
		else if (ret.code == '5') {
			ret.code = Curses.getch();
	//Console.put(ret.code, " ");
		}
		else if (ret.code == '6') {
			ret.code = Curses.getch();
	//Console.put(ret.code, " ");
		}
		else {
		}
	}
	else if (ret.code == 'O') {
		ret.code = Curses.getch();

		// F1, F2, F3, F4
		if (ret.code == '1') {
			ret.code = Curses.getch();
	//Console.put(ret.code, " ");
			if (ret.code == ';') {
				ret.code = Curses.getch();
	//Console.put(ret.code, " ");
				getModifiers(ret);
	//Console.put(ret.code, " ");

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
		ret.alt = true;
		consoleTranslateKey(ret);
	}

	//Curses.move(1,0);
	//Console.put("                                                ");
	//Curses.move(1,0);
	//Console.put("alt: ", ret.alt, " ctrl: ", ret.ctrl, " shift: ", ret.shift, " code: ", ret.code);

	return ret;
}

void getModifiers(ref Key key) {
	if (key.code == '2' || key.code == '4' || key.code == '6' || key.code == '8') {
		key.shift = true;
	}

	if (key.code == '3' || key.code == '4' || key.code == '7' || key.code == '8') {
		key.alt = true;
	}

	if (key.code == '5' || key.code == '6' || key.code == '7' || key.code == '8') {
		key.ctrl = true;
	}

	if (key.shift || key.alt || key.ctrl) {
		key.code = Curses.getch();
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
				ky.shift = true;
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
	'\'': Key.Quote,
	'"': Key.Quote,
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




const auto TIOCGWINSZ = 0x5413;
const auto SIGWINCH = 28;

//position tracking

int m_x;
int m_y;

winsize m_winsize_saved;
winsize m_winsize_working;

termios m_term_info_saved;
termios m_term_info_working;



//signal handler for terminal Size

extern(C) void close_sig_handler(int signal) {
	Djehuty.end(0);
//	for(int i=0; i<256; i++) {
//		printf("\x1B[48;5;%dma", i);
//	}
	ConsoleUninit();
	exit(0);
}

extern(C) void size_sig_handler(int signal) {

    ioctl(STDIN, TIOCGWINSZ, &m_winsize_working);

    if (m_width != m_winsize_working.ws_col || m_height != m_winsize_working.ws_row) {
        m_width = m_winsize_working.ws_col;
        m_height = m_winsize_working.ws_row;

        while (m_x >= m_width)
        {
            m_y++;
            m_x -= m_width;
        }

        if (m_y >= m_height) { m_y = m_height-1; }
        if (m_x < 0) { m_x = 0; }
        if (m_y < 0) { m_y = 0; }

        //reset (this will be retained when program exits)
        m_winsize_saved = m_winsize_working;

        //the window resized through the users actions, not through the class' resize()
        //therefore don't change it back to anything on exit
        m_winsize_state = false;
    }

    //fire Size event
	TuiApplication app = cast(TuiApplication)Djehuty.app;
	app.window.onResize();
}

void ConsoleInit()
{
    //direct the Size signal to the internal function
//    signal(SIGWINCH, &size_sig_handler);
//	signal(SIGINT, &close_sig_handler);
	//sigset(SIGKILL, &close_sig_handler);
	//sigset(SIGTERM, &close_sig_handler);

	// set buffer to print without newline
	setvbuf (stdout, null, _IONBF, 0);

	Curses.initscr();
	Curses.start_color();
	Curses.keypad(Curses.stdscr, 1);

	Curses.move(0,0);

	Curses.nonl();
	Curses.cbreak();
	Curses.noecho();

	Curses.raw();

	Curses.mmask_t oldmask;
	Curses.mousemask(Curses.ALL_MOUSE_EVENTS | Curses.REPORT_MOUSE_POSITION, &oldmask);
	Curses.mouseinterval(0);

	// Get current position
	m_x = 0;
	m_y = 0;
}

void ConsoleUninit() {
	Curses.endwin();
}

void ConsoleClear() {
//	printf("\x1B[2J\x1B[0;0H");
	Curses.clear();
	Curses.refresh();
}

void ConsoleSetRelative(int x, int y) {
	int newx;
	int newy;

	Curses.getyx(Curses.stdscr, m_y, m_x);

	newx = m_x + x;
	newy = m_y + y;

	Curses.move(m_y, m_x);
}

uint[] ConsoleGetPosition() {
	Curses.getyx(Curses.stdscr, m_y, m_x);
	return [m_x, m_y];
}

void ConsoleSetPosition(uint x, uint y) {
    if (x >= m_width) { x = m_width-1; }

    if (y >= m_height) { y = m_height-1; }

    if (x < 0) { x = 0; }

    if (y < 0) { y = 0; }

	Curses.move(y,x);
}

void ConsoleHideCaret() {
//	printf("\x1B[?25l");
	Curses.curs_set(0);
}

void ConsoleShowCaret() {
//	printf("\x1B[?25h");
	Curses.curs_set(1);
}

void ConsoleSetHome() {
//	printf("\x1B[0G");
	Curses.getyx(Curses.stdscr, m_y, m_x);
	m_x = 0;
	Curses.move(m_y, m_x);
}

void ConsolePutString(dchar[] chrs) {
	chrs ~= '\0';
	char[] utf8 = Unicode.toUtf8(chrs);
//	printf("%s", utf8.ptr);
	Curses.wprintw(Curses.stdscr, "%s", utf8.ptr);
	Curses.refresh();
}

void ConsolePutChar(dchar chr) {
	dchar[] chrarray = [ chr, '\0' ];
	char[] chrs = Unicode.toUtf8(chrarray);

//	printf("%s", chrs.ptr);
	Curses.wprintw(Curses.stdscr, "%s", chrs.ptr);
	Curses.refresh();
}

void ConsoleGetChar(out dchar chr, out uint code) {
	for (;;) {
		//become IO bound

		Key key; uint tky;
		key = consoleGetKey();
    }
}

void ConsoleGetSize(out uint width, out uint height) {
	Curses.getmaxyx(Curses.stdscr, m_height, m_width);

	width = m_width;
	height = m_height;
}

// key

enum _UNIX_ConsoleKeys:ulong
{

 KeyEscape 		= 27,

 KeyA 			= 'a',
 KeyB 			= 'b',
 KeyC 			= 'c',
 KeyD 			= 'd',
 KeyE 			= 'e',
 KeyF 			= 'f',
 KeyG 			= 'g',
 KeyH 			= 'h',
 KeyI 			= 'i',
 KeyJ 			= 'j',
 KeyK 			= 'k',
 KeyL 			= 'l',
 KeyM 			= 'm',
 KeyN 			= 'n',
 KeyO 			= 'o',
 KeyP 			= 'p',
 KeyQ 			= 'q',
 KeyR 			= 'r',
 KeyS 			= 's',
 KeyT 			= 't',
 KeyU 			= 'u',
 KeyV 			= 'v',
 KeyW 			= 'w',
 KeyX 			= 'x',
 KeyY 			= 'y',
 KeyZ 			= 'z',

 KeyShiftA 		= 'A',
 KeyShiftB 		= 'B',
 KeyShiftC 		= 'C',
 KeyShiftD 		= 'D',
 KeyShiftE 		= 'E',
 KeyShiftF 		= 'F',
 KeyShiftG 		= 'G',
 KeyShiftH 		= 'H',
 KeyShiftI 		= 'I',
 KeyShiftJ 		= 'J',
 KeyShiftK 		= 'K',
 KeyShiftL 		= 'L',
 KeyShiftM 		= 'M',
 KeyShiftN 		= 'N',
 KeyShiftO 		= 'O',
 KeyShiftP 		= 'P',
 KeyShiftQ 		= 'Q',
 KeyShiftR 		= 'R',
 KeyShiftS 		= 'S',
 KeyShiftT 		= 'T',
 KeyShiftU 		= 'U',
 KeyShiftV 		= 'V',
 KeyShiftW 		= 'W',
 KeyShiftX 		= 'X',
 KeyShiftY 		= 'Y',
 KeyShiftZ 		= 'Z',

 KeyAltA 		= (0x1B00) | ('a'),
 KeyAltB 		= (0x1B00) | ('b'),
 KeyAltC 		= (0x1B00) | ('c'),
 KeyAltD 		= (0x1B00) | ('d'),
 KeyAltE 		= (0x1B00) | ('e'),
 KeyAltF 		= (0x1B00) | ('f'),
 KeyAltG 		= (0x1B00) | ('g'),
 KeyAltH 		= (0x1B00) | ('h'),
 KeyAltI 		= (0x1B00) | ('i'),
 KeyAltJ 		= (0x1B00) | ('j'),
 KeyAltK 		= (0x1B00) | ('k'),
 KeyAltL 		= (0x1B00) | ('l'),
 KeyAltM 		= (0x1B00) | ('m'),
 KeyAltN 		= (0x1B00) | ('n'),
 KeyAltO 		= (0x1B00) | ('o'),
 KeyAltP 		= (0x1B00) | ('p'),
 KeyAltQ 		= (0x1B00) | ('q'),
 KeyAltR 		= (0x1B00) | ('r'),
 KeyAltS 		= (0x1B00) | ('s'),
 KeyAltT 		= (0x1B00) | ('t'),
 KeyAltU 		= (0x1B00) | ('u'),
 KeyAltV 		= (0x1B00) | ('v'),
 KeyAltW 		= (0x1B00) | ('w'),
 KeyAltX 		= (0x1B00) | ('x'),
 KeyAltY 		= (0x1B00) | ('y'),
 KeyAltZ 		= (0x1B00) | ('z'),

 Key0 			= '0',
 Key1 			= '1',
 Key2 			= '2',
 Key3 			= '3',
 Key4 			= '4',
 Key5 			= '5',
 Key6 			= '6',
 Key7 			= '7',
 Key8 			= '8',
 Key9 			= '9',

 KeyAlt0			= (0x1B00) | ('0'),
 KeyAlt1			= (0x1B00) | ('1'),
 KeyAlt2			= (0x1B00) | ('2'),
 KeyAlt3			= (0x1B00) | ('3'),
 KeyAlt4			= (0x1B00) | ('4'),
 KeyAlt5			= (0x1B00) | ('5'),
 KeyAlt6			= (0x1B00) | ('6'),
 KeyAlt7			= (0x1B00) | ('7'),
 KeyAlt8			= (0x1B00) | ('8'),
 KeyAlt9			= (0x1B00) | ('9'),

 KeySpace 		= 32,

 KeyExclamation	= '!',
 KeyAt 			= '@',
 KeyPound 		= '#',
 KeyDollar 		= '$',
 KeyPercent 		= '%',
 KeyCaret 		= '^',
 KeyAmp 			= '&',
 KeyAsterisk 	= '*',
 KeyLeftParenth 	= '(',
 KeyRightParenth = ')',

 KeyMinus 		= '-',
 KeyPlus 		= '+',
 KeyEquals 		= '=',
 KeyUnderscore 	= '_',

 KeyAltMinus 	= (0x1B00) | ('-'),
 KeyAltEquals	= (0x1B00) | ('='),

 KeyLeftCurly 	= '{',
 KeyRightCurly 	= '}',

 KeyLeftBracket 	= '[',
 KeyRightBracket = ']',

 KeyAltLeftBracket	= (0x1B00) | ('['),
 KeyAltRightBracket	= (0x1B00) | (']'),

 KeyColon 		= ':',
 KeySemiColon 	= ',',

 KeyAltSemiColon	= (0x1B00) | (','),

 KeyDoubleQuote 	= '"',
 KeyApostrophe 	= '\'',
 KeyTilde 		= '~',
 KeySingleQuote 	= '`',

 KeyAltSingleQuote = (0x1B00) | ('`'),
 KeyAltApostrophe = (0x1B00) | ('\''),
 KeyAltTilde		= (0x1B00) | ('~'),
 KeyAltDoubleQuote	= (0x1B00) | ('"'),

 KeyPipe 		= '|',
 KeyBackslash 	= '\\',
 KeyForeslash 	= '/',

 KeyAltBackslash	= (0x1B00) | ('\\'),
 KeyAltForeslash	= (0x1B00) | ('/'),
 KeyAltPipe		= (0x1B00) | ('|'),

 KeyReturn 		= 10,
 KeyBackspace 	= 127,
 KeyTab 			= 9,

 KeyAltReturn	= (0x1B00) | (10),
 KeyAltBackspace	= (0x1B00) | (127),
 KeyAltTab		= (0x1B00) | (9),

 KeyHome 		= 0x4F48,
 KeyHomeNumpad	= 0x317E,
 KeyEnd 			= 0x4F46,
 KeyEndNumpad	= 0x347E,

 KeyF1			= (0x4F00 | 80),		//system
 KeyF2			= (0x4F00 | 81),
 KeyF3			= (0x4F00 | 82),
 KeyF4			= (0x4F00 | 83),

 KeyShiftF1		= 0x4F3150,
 KeyShiftF2		= 0x4F3151,
 KeyShiftF3		= 0x4F3152,
 KeyShiftF4		= 0x4F3153,

 KeyAltShiftF1	= 0x4F313450,
 KeyAltShiftF2	= 0x4F313451,
 KeyAltShiftF3	= 0x4F313452,
 KeyAltShiftF4	= 0x4F313453,

 KeyF5			= 0x31357E,
 KeyF6			= 0x31377E,
 KeyF7			= 0x31387E,
 KeyF8			= 0x31397E,

 KeyShiftF5		= 0x31353B32,
 KeyShiftF6		= 0x31373B32,
 KeyShiftF7		= 0x31383B32,
 KeyShiftF8		= 0x31393B32,

 KeyAltShiftF5	= 0x31353B34,
 KeyAltShiftF6	= 0x31373B34,
 KeyAltShiftF7	= 0x31383B34,
 KeyAltShiftF8	= 0x31393B34,

 KeyF9			= 0x32307E,
 KeyF10			= 0x32317E,			//typically system
 KeyF11			= 0x32337E,
 KeyF12			= 0x32347E,

 KeyShiftF9		= 0x32303B32,
 KeyShiftF10		= 0x32313B32,			//typically system
 KeyShiftF11		= 0x32333B32,
 KeyShiftF12		= 0x32343B32,

 KeyAltShiftF9	= 0x32303B34,
 KeyAltShiftF10	= 0x32313B34,
 KeyAltShiftF11	= 0x32333B34,
 KeyAltShiftF12	= 0x32343B34,

 KeyUp 			= 0x5B41,
 KeyDown 		= 0x5B42,
 KeyRight 		= 0x5B43,
 KeyLeft 		= 0x5B44,

 KeyAltUp		= 0x313B3341,
 KeyAltDown		= 0x313B3342,
 KeyAltRight		= 0x313B3343,
 KeyAltLeft		= 0x313B3344,

 KeyShiftUp		= 0x313B3241,
 KeyShiftDown	= 0x313B3242,
 KeyShiftRight	= 0x313B3243,
 KeyShiftLeft	= 0x313B3244,

 KeyAltShiftUp	= 0x313B3441,
 KeyAltShiftDown	= 0x313B3442,
 KeyAltShiftRight	= 0x313B3443,
 KeyAltShiftLeft	= 0x313B3444,

 KeyDelete 		= 0x337E,

 KeyShiftDelete	= 0x333b32,
 KeyAltDelete	= 0x333b33,
 KeyShiftAltDelete	= 0x333b34,

 KeyPageUp 		= 0x357E,
 KeyAltPageUp	= 0x353B33,

 KeyPageDown 	= 0x367E,
 KeyAltPageDown	= 0x363B33,

 KeyInsert		= 0x327E,
 KeyShiftInsert	= 0x323B33,
 KeyAltInsert		= 0x323B33,
 KeyShiftAltInsert	= 0x323B34,

}



