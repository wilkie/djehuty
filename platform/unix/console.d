module platform.unix.console;

import core.main;

import console.window;

import platform.unix.common;
import platform.unix.main;
import core.definitions;
import core.thread;

import core.unicode;

void ConsoleSetColors(uint fg, uint bg, int bright)
{
	printf("\x1B[%d;%d;%dm", bright, 30 + fg, 40 + bg);
}


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
	Djehuty._curConsoleWindow.OnResize();
}

void ConsoleInit()
{
    //get terminal information

    //ioctl(STDIN, TCGETS, &m_term_info_saved);

    //get the current terminal vars

    //ioctl(STDIN, TCGETS, &m_term_info_working);

    m_winsize_state = false;

    ioctl(STDIN, TIOCGWINSZ, &m_winsize_saved);

    m_width = m_winsize_saved.ws_col;
    m_height = m_winsize_saved.ws_row;

    //direct the Size signal to the internal function
    sigset(SIGWINCH, &size_sig_handler);

	// set buffer to print without newline
	setvbuf (stdout, null, _IONBF, 0);

    //get terminal information
    ioctl(STDIN, TCGETS, &m_term_info_saved);

    //get the current terminal vars
    ioctl(STDIN, TCGETS, &m_term_info_working);

    //tell the terminal to not echo anything
    //streamed from stdin
    m_term_info_working.c_iflag &= (~(ISTRIP | INLCR | IGNCR | IXON | IXOFF));
    m_term_info_working.c_lflag &= ~(ECHO | ICANON); //ISIG -- stops ctrl_c, ect
    ioctl(STDIN, TCSETS, &m_term_info_working);
}

void ConsoleUninit()
{
    ioctl(STDIN, TCSETS, &m_term_info_saved);
}

void ConsoleClear()
{
	printf("\x1B[2J\x1B[0;0H");
}

void ConsoleSetRelative(int x, int y)
{
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

void ConsoleSetPosition(uint x, uint y)
{
    if (x >= m_width) { x = m_width-1; }

    if (y >= m_height) { y = m_height-1; }

    if (x < 0) { x = 0; }

    if (y < 0) { y = 0; }

    printf("\x1B[%d;%dH", y + 1, x + 1);
}

void ConsoleSavePosition()
{
	printf("\x1B[s");
}

void ConsoleRestorePosition()
{
	printf("\x1B[u");
}

void ConsoleHideCaret()
{
	printf("\x1B[?25l");
}

void ConsoleShowCaret()
{
	printf("\x1B[?25h");
}

void ConsoleSetHome()
{
	printf("\n");
	printf("\x1B[0E");
}

void ConsolePutString(dchar[] chrs)
{
	chrs ~= '\0';
	char[] utf8 = Unicode.toUtf8(chrs);
	printf("%s", utf8.ptr);
}

void ConsolePutChar(dchar chr)
{
	printf("\n\n");
	dchar[] chrarray = [ chr, '\0' ];
	char[] chrs = Unicode.toUtf8(chrarray);

	printf("%s", chrs.ptr);
}

void ConsoleGetChar(out dchar chr, out uint code)
{
	for (;;)
	{
		//become IO bound

		ulong ky; uint tky;
		ky = consoleGetKey();
		tky = consoleTranslateKey(ky);

		if (ky < 0xfffffff)
		{
			code = tky;
//        	ConsoleWindowOnKeyDown(tky);

			if (tky != KeyBackspace && tky != KeyArrowLeft && tky != KeyArrowRight
				&& tky != KeyArrowUp && tky != KeyArrowDown)
			{
				chr = ky;
				//ConsoleWindowOnKeyChar(cast(uint)ky);
			}
			else
			{
				chr = 0;
			}
			return;
        }

        /* if (m_exit)
        {
            fireEvent(EventUninitState, 0);
            break;
        } */
    }
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



