/*
 * ncurses.d
 *
 * This module implements bindings for ncurses and translates 'ncurses.h'.
 *
 * Author: Dave Wilkinson
 * Originated: August 15th, 2009
 *
 */

module binding.ncurses.ncurses;

import binding.c;

extern(C):

// << ncurses.h>> //

// These correspond to the values retrieved from the headers I have referenced
const auto NCURSES_VERSION_MAJOR = 5;
const auto NCURSES_VERSION_MINOR = 6;
const auto NCURSES_VERSION_PATCH = 20071124;

// Version
const auto NCURSES_VERSION = "5.6";

// Identify the mouse encoding version
const auto NCURSES_MOUSE_VERSION = 1;

// Internal type for color values
alias short NCURSES_COLOR_T;

// Definition used to make WINDOW and similar structs opaque
const auto NCURSES_OPAQUE = 0;

// Internal type used for window dimensions
alias short NCURSES_SIZE_T;

alias Culong_t chtype;
alias Culong_t mmask_t;

alias chtype NCURSES_CH_T;

// Colors
enum : uint {
	COLOR_BLACK,
	COLOR_RED,
	COLOR_GREEN,
	COLOR_YELLOW,
	COLOR_BLUE,
	COLOR_MAGENTA,
	COLOR_CYAN,
	COLOR_WHITE
}

// VT100 Symbols
/*
extern(C) const chtype[] acs_map;

const auto ACS_ULCORNER = acs_map['l'];
const auto ACS_LLCORNER = acs_map['m'];
const auto ACS_URCORNER = acs_map['k'];
const auto ACS_LRCORNER = acs_map['j'];
const auto ACS_LTEE = acs_map['t'];
const auto ACS_RTEE = acs_map['u'];
const auto ACS_BTEE = acs_map['v'];
const auto ACS_TTEE = acs_map['w'];
const auto ACS_HLINE = acs_map['q'];
const auto ACS_VLINE = acs_map['x'];
const auto ACS_PLUS = acs_map['n'];
const auto ACS_S1 = acs_map['o'];
const auto ACS_S9 = acs_map['s'];
const auto ACS_DIAMOND = acs_map['`'];
const auto ACS_CKBOARD = acs_map['a'];
const auto ACS_DEGREE = acs_map['f'];
const auto ACS_PLMINUS = acs_map['g'];
const auto ACS_BULLET = acs_map['~'];

// Teletype 5410v1 Symbols
const auto ACS_LARROW = acs_map[','];
const auto ACS_RARROW = acs_map['+'];
const auto ACS_DARROW = acs_map['.'];
const auto ACS_UARROW = acs_map['-'];
const auto ACS_BOARD = acs_map['h'];
const auto ACS_LANTERN = acs_map['i'];
const auto ACS_BLOCK = acs_map['0'];

// Undocumented
const auto ACS_S3 = acs_map['p'];
const auto ACS_S7 = acs_map['r'];
const auto ACS_LEQUAL = acs_map['y'];
const auto ACS_GEQUAL = acs_map['z'];
const auto ACS_PI = acs_map['{'];
const auto ACS_NEQUAL = acs_map['|'];
const auto ACS_STERLING = acs_map['}'];

// Line drawing
const auto ACS_BSSB = ACS_ULCORNER;
const auto ACS_SSBB = ACS_LLCORNER;
const auto ACS_BBSS = ACS_URCORNER;
const auto ACS_SBBS = ACS_LRCORNER;
const auto ACS_SBSS = ACS_RTEE;
const auto ACS_SSSB = ACS_LTEE;
const auto ACS_SSBS = ACS_BTEE;
const auto ACS_BSSS = ACS_TTEE;
const auto ACS_BSBS = ACS_HLINE;
const auto ACS_SBSB = ACS_VLINE;
const auto ACS_SSSS = ACS_PLUS;
*/

const auto ERR = -1;
const auto OK = 0;

// Values for _flags
const auto _SUBWIN = 0x01; // Is this a subwindow?
const auto _ENDLINE = 0x02; // Is the window flush right?
const auto _FULLWIN = 0x04; // Is the window fullscreen?
const auto _SCROLLWIN = 0x08; // Is the bottom edge at screen bottom?
const auto _ISPAD = 0x10; // Is the window a pad?
const auto _HASMOVED = 0x20; // Has the cursor moved since last refresh?
const auto _WRAPPED = 0x40; // Cursor was just wrapped

// This value is used in the firstchar and lastchar fields to mark
// unchanged lines
const auto _NOCHANGE = -1;

// This value is used in the oldindex field to mark lines created by
// insertions and scrolls
const auto _NEWINDEX = -1;

extern(C) struct ldat;
extern(C) struct screen;
extern(C) struct _win_st;

alias screen SCREEN;
alias _win_st WINDOW;

// Must be at least as wide as chtype
alias chtype attr_t;

const auto CCHARW_MAX = 5;

struct cchar_t {
	attr_t attr;
	wchar_t chars[CCHARW_MAX];
}

typedef int function(WINDOW*, void*) NCURSES_CALLBACK;

// Function prototypes
int addch(chtype);
int addchnstr(chtype*, int);
int addchstr(chtype*);
int addnstr(char*, int);
int addstr(char*);
int attroff(attr_t);
int attron(attr_t);
int attrset(attr_t);
int attr_get(attr_t*, short*, void*);
int attr_off(attr_t, void*);
int attr_on(attr_t, void*);
int attr_set(attr_t, short, void*);
int baudrate();
int beep();
int bkgd(chtype);
int bkgdset(chtype);
int border(chtype, chtype, chtype, chtype, chtype, chtype, chtype, chtype);
int box(WINDOW*, chtype, chtype);
bool can_change_color();
int cbreak();
int chgat(int, attr_t, short, void*);
int clear();
int clearok(WINDOW*, bool);
int clrtobot();
int clrtoeol();
int color_content(short, short*, short*, short*);
int color_set(short, void*);
int COLOR_PAIR(int);
int copywin(WINDOW*, WINDOW*, int, int, int, int, int, int, int);
int curs_set(int);
int def_prog_mode();
int def_shell_mode();
int delay_output(int);
int delch();
void delscreen(SCREEN*);
int delwin(WINDOW*);
int deleteln();
WINDOW* derwin(WINDOW*, int, int, int, int);
int doupdate();
WINDOW* dupwin(WINDOW*);
int echo();
int echochar(chtype);
int erase();
int endwin();
char erasechar();
void filter();
int flash();
int flushinp();
chtype getbkgd(WINDOW*);
int getch();
int getnstr(char*, int);
int getstr(char*);
WINDOW* getwin(FILE*);
int halfdelay(int);
bool has_colors();
bool has_ic();
bool has_il();
int hline(chtype, int);
void idcok(WINDOW*, bool);
int idlok(WINDOW*, bool);
void immedok(WINDOW*, bool);
chtype inch();
int inchnstr(chtype*, int);
int inchstr(chtype*);
WINDOW* initscr();
int init_color(short, short, short, short);
int init_pair(short, short, short);
int innstr(char*, int);
int insch(chtype);
int insdelln(int);
int insertln();
int insnstr(char*, int);
int insstr(char*);
int instr(char*);
int intrflush(WINDOW*, bool);
bool isendwin();
bool is_linetouched(WINDOW*, int);
bool is_wintouched(WINDOW*);
char* keyname(int);
int keypad(WINDOW*, bool);
char killchar();
int leaveok(WINDOW*, bool);
char* longname();
int meta(WINDOW*, bool);
int move(int, int);
int mvaddch(int, int, chtype);
int mvaddchnstr(int, int, chtype*, int);
int mvaddchstr(int, int, chtype*);
int mvaddnstr(int, int, char*, int);
int mvaddstr(int, int, char*);
int mvchgat(int, int, int, attr_t, short, void*);
int mvcur(int, int, int, int);
int mvdelch(int, int);
int mvderwin(WINDOW*, int, int);
int mvgetch(int, int);
int mvgetnstr(int, int, char*, int);
int mvgetstr(int, int, char*);
int mvhline(int, int, chtype, int);
int mvinch(int, int);
int mvinchnstr(int, int, chtype*, int);
int mvinchstr(int, int, chtype*);
int mvinnstr(int, int, char*, int);
int mvinsch(int, int, chtype);
int mvinsnstr(int, int, char*, int);
int mvinsstr(int, int, char*);
int mvprintw(int, int, char*, ...);
int mvscanw(int, int, char*, ...);
int mvvline(int, int, chtype, int);
int mvwaddch(WINDOW*, int, int, chtype);
int mvwaddchnstr(WINDOW*, int, int, chtype*, int);
int mvwaddchstr(WINDOW*, int, int, chtype*);
int mvwaddnstr(WINDOW*, int, int, char*, int);
int mvwaddstr(WINDOW*, int, int, char*);
int mvwchgat(WINDOW*, int, int, int, attr_t, short, void*);
int mvwdelch(WINDOW*, int, int);
int mvwgetch(WINDOW*, int, int);
int mvwgetnstr(WINDOW*, int, int, char*, int);
int mvwgetstr(WINDOW*, int, int, char*);
int mvwhline(WINDOW*, int, int, chtype, int);
int mvwin(WINDOW*, int, int);
chtype mvwinch(WINDOW*, int, int);
int mvwinchnstr(WINDOW*, int, int, chtype*, int);
int mvwinchstr(WINDOW*, int, int, chtype*);
int mvwinnstr(WINDOW*, int, int, char*, int);
int mvwinsch(WINDOW*, int, int, chtype);
int mvwinsnstr(WINDOW*, int, int, char*, int);
int mvwinsstr(WINDOW*, int, int, char*);
int mvwinstr(WINDOW*, int, int, char*);
int mvwprintw(WINDOW*, int, int, char*, ...);
int mvwscanw(WINDOW*, int, int, char*, ...);
int mvwvline(WINDOW*, int, int, chtype, int);
int napms(int);
WINDOW* newpad(int, int);
SCREEN* newterm(char*, FILE*, FILE*);
WINDOW* newwin(int, int, int, int);
int nl();
int nocbreak();
int nodelay(WINDOW*, bool);
int noecho();
int nonl();
int noqiflush();
int noraw();
int notimeout(WINDOW*, bool);
int overlay(WINDOW*, WINDOW*);
int overwrite(WINDOW*, WINDOW*);
int pair_content(short, short*, short*);
int PAIR_NUMBER(int);
int pechochar(WINDOW*, chtype);
int pnoutrefresh(WINDOW*, int, int, int, int, int, int);
int prefresh(WINDOW*, int, int, int, int, int, int);
int printw(char*, ...);
int putwin(WINDOW*, FILE*);
void qiflush();
int raw();
int redrawwin(WINDOW*);
int refresh();
int resetty();
int reset_prog_mode();
int reset_shell_mode();
int ripoffline(int, int function(WINDOW*, int));
int savetty();
int scanw(char*, ...);
int scr_dump(char*);
int scr_init(char*);
int scrl(int);
int scroll(WINDOW*);
int scrollok(WINDOW*, bool);
int scr_restore(char*);
int scr_set(char*);
int setscrreg(int, int);
SCREEN* set_term(SCREEN*);
int slk_attroff(chtype);
int slk_attr_off(attr_t, void*);
int slk_attron(chtype);
int slk_attr_on(attr_t, void*);
int slk_attrset(chtype);
int slk_attr();
int slk_attr_set(attr_t, short, void*);
int slk_clear();
int slk_color(short);
int slk_init(int);
char* slk_label(int);
int slk_noutrefresh();
int slk_refresh();
int slk_restore();
int slk_set(int, char*, int);
int slk_touch();
int standout();
int standend();
int start_color();
WINDOW* subpad(WINDOW*, int, int, int, int);
WINDOW* subwin(WINDOW*, int, int, int, int);
int syncok(WINDOW*, bool);
chtype termattrs();
char* termname();
void timeout(int);
int touchline(WINDOW*, int, int);
int touchwin(WINDOW*);
int typeahead(int);
int ungetch(int);
int untouchwin(WINDOW*);
void use_env(bool);
int vidattr(chtype);
int vidputs(chtype, int function(int));
int vline(chtype, int);
int vwprintw(WINDOW*, char*, va_list);
int vw_printw(WINDOW*, char*, va_list);
int vwscanw(WINDOW*, char*, va_list);
int waddch(WINDOW*, chtype);
int waddchstr(WINDOW*, chtype*);
int waddnstr(WINDOW*, char*, int);
int waddstr(WINDOW*, char*);
int wattron(WINDOW*, int);
int wattroff(WINDOW*, int);
int wattrset(WINDOW*, int);
int wattr_get(WINDOW*, attr_t*, short*, void*);
int wattr_on(WINDOW*, attr_t, void*);
int wattr_off(WINDOW*, attr_t, void*);
int wattr_set(WINDOW*, attr_t, short, void*);
int wbkgd(WINDOW*, chtype);
void wbkgdset(WINDOW*, chtype);
int wborder(WINDOW*, chtype, chtype, chtype, chtype, chtype, chtype, chtype, chtype);
int wchgat(WINDOW*, int, attr_t, short, void*);
int wclear(WINDOW*);
int wclrtobot(WINDOW*);
int wclrtoeol(WINDOW*);
int wcolor_set(WINDOW*, short, void*);
void wcursyncup(WINDOW*);
int wdelch(WINDOW*);
int wdeleteln(WINDOW*);
int wechochar(WINDOW*, chtype);
int werase(WINDOW*);
int wgetch(WINDOW*);
int wgetnstr(WINDOW*, char*, int);
int wgetstr(WINDOW*, char*);
int whline(WINDOW*, chtype, int);
chtype winch(WINDOW*);
int winchnstr(WINDOW*, chtype*, int);
int winchstr(WINDOW*, chtype*);
int winnstr(WINDOW*, char*, int);
int winsch(WINDOW*, chtype);
int winsdelln(WINDOW*, int);
int winsertln(WINDOW*);
int winsnstr(WINDOW*, char*, int);
int winsnstr(WINDOW*, char*, int);
int winsstr(WINDOW*, char*);
int winstr(WINDOW*, char*);
int wmove(WINDOW*, int, int);
int wnoutrefresh(WINDOW*);
int wprintw(WINDOW*, char*, ...);
int wredrawln(WINDOW*, int, int);
int wrefresh(WINDOW*);
int wscanw(WINDOW*, char*, ...);
int wscrl(WINDOW*, int);
int wsetscrreg(WINDOW*, int, int);
int wstandout(WINDOW*);
int wstandend(WINDOW*);
int wsyncdown(WINDOW*);
void wsyncup(WINDOW*);
void wtimeout(WINDOW*, int);
int wtouchln(WINDOW*, int, int, int);
int wvline(WINDOW*, chtype, int);

// Also defined in term.h
int tigetflag(char*);
int tigetnum(char*);
char* tigetstr(char*);
int putp(char*);

// Also used
int getattrs(WINDOW*);
int getcurx(WINDOW*);
int getcury(WINDOW*);
int getbegx(WINDOW*);
int getbegy(WINDOW*);
int getmaxx(WINDOW*);
int getmaxy(WINDOW*);
int getparx(WINDOW*);
int getpary(WINDOW*);

// Extensions
bool is_term_resized(int, int);
char* keybound(int, int);
char* curses_version();
int assume_default_colors(int, int);
int define_key(char*, int);
int key_defined(char*);
int keyok(int, bool);
int resize_term(int, int);
int resizeterm(int, int);
int use_default_colors();
int use_extended_names(bool);
int use_legacy_coding(int);
int use_screen(SCREEN*, NCURSES_CALLBACK, void*);
int use_window(WINDOW*, NCURSES_CALLBACK, void*);
int wresize(WINDOW*, int, int);
void nofilter();

// Extensions to allow access to information stored in the WINDOW
WINDOW* wgetparent(WINDOW*);
bool is_cleared(WINDOW*);
bool is_idcok(WINDOW*);
bool is_idlok(WINDOW*);
bool is_immedok(WINDOW*);
bool is_keypad(WINDOW*);
bool is_leaveok(WINDOW*);
bool is_nodelay(WINDOW*);
bool is_notimeout(WINDOW*);
bool is_scrollok(WINDOW*);
bool is_syncok(WINDOW*);
int wgetscrreg(WINDOW*, int*, int*);

// Attributes
const auto NCURSES_ATTR_SHIFT = 8;
const attr_t A_NORMAL = cast(attr_t)0;
const attr_t A_ATTRIBUTES = cast(attr_t)0xffffff00;
const auto A_CHARTEXT = cast(attr_t)0xff;
const auto A_COLOR = cast(attr_t)0xff00;
const auto A_STANDOUT = cast(attr_t)(1 << 16);
const auto A_UNDERLINE = cast(attr_t)(1 << 17);
const auto A_REVERSE = cast(attr_t)(1 << 18);
const auto A_BLINK = cast(attr_t)(1 << 19);
const auto A_DIM = cast(attr_t)(1 << 20);
const attr_t A_BOLD = cast(attr_t)(1 << 21);
const auto A_ALTCHARSET = cast(attr_t)(1 << 22);
const auto A_INVIS = cast(attr_t)(1 << 23);
const auto A_PROTECT = cast(attr_t)(1 << 24);
const auto A_HORIZONTAL = cast(attr_t)(1 << 25);
const auto A_LEFT = cast(attr_t)(1 << 26);
const auto A_LOW = cast(attr_t)(1 << 27);
const auto A_RIGHT = cast(attr_t)(1 << 28);
const auto A_TOP = cast(attr_t)(1 << 29);
const auto A_VERTICAL = cast(attr_t)(1 << 30);

extern WINDOW* curscr;
extern WINDOW* newscr;
extern WINDOW* stdscr;
extern char[] ttytype;
extern int COLORS;
extern int COLOR_PAIRS;
extern int COLS;
extern int ESCDELAY;
extern int LINES;
extern int TABSIZE;

// Macros
void getyx(WINDOW* win, out int y, out int x) {
	y = getcury(win);
	x = getcurx(win);
}

void getbegyx(WINDOW* win, out int y, out int x) {
	y = getbegy(win);
	x = getbegx(win);
}

void getmaxyx(WINDOW* win, out int y, out int x) {
	y = getmaxy(win);
	x = getmaxx(win);
}

void getparyx(WINDOW* win, out int y, out int x) {
	y = getpary(win);
	x = getparx(win);
}

void getsyx(out int y, out int x) {
	if (is_leaveok(newscr)) {
		y = -1;
		x = -1;
	}
	else {
		getyx(newscr, y, x);
	}
}

void setsyx(ref int y, ref int x) {
	if ((y == -1) && (x == -1)) {
		leaveok(newscr, 1);
	}
	else {
		leaveok(newscr, 0);
		wmove(newscr, y, x);
	}
}

int wgetstr(WINDOW* w, char* s) {
	return wgetnstr(w, s, -1);
}

int getnstr(char* s, int n) {
	return wgetnstr(stdscr, s, n);
}

int fixterm() {
	return reset_prog_mode();
}

int resetterm() {
	return reset_shell_mode();
}

int saveterm() {
	return def_prog_mode();
}

int crmode() {
	return cbreak();
}

int nocrmode() {
	return nocbreak();
}

int gettmode() {
	return 0;
}

// Key codes
const auto KEY_CODE_YES = 0400;
const auto KEY_MIN = 0401;
const auto KEY_BREAK = 0401;
const auto KEY_SRESET = 0530;
const auto KEY_RESET = 0531;
const auto KEY_DOWN = 0402;
const auto KEY_UP = 0403;
const auto KEY_LEFT = 0404;
const auto KEY_RIGHT	= 0405;
const auto KEY_HOME	= 0406;
const auto KEY_BACKSPACE	= 0407;
const auto KEY_F0 =		0410;
const auto KEY_F1 =		KEY_F0 + 1;
const auto KEY_F2 =		KEY_F0 + 2;
const auto KEY_F3 =		KEY_F0 + 3;
const auto KEY_F4 =		KEY_F0 + 4;
const auto KEY_F5 =		KEY_F0 + 5;
const auto KEY_F6 =		KEY_F0 + 6;
const auto KEY_F7 =		KEY_F0 + 7;
const auto KEY_F8 =		KEY_F0 + 8;
const auto KEY_F9 =		KEY_F0 + 9;
const auto KEY_F10 =		KEY_F0 + 10;
const auto KEY_F11 =		KEY_F0 + 11;
const auto KEY_F12 =		KEY_F0 + 12;
const auto KEY_F13 =		KEY_F0 + 13;
const auto KEY_F14 =		KEY_F0 + 14;
const auto KEY_F15 =		KEY_F0 + 15;
const auto KEY_F16 =		KEY_F0 + 16;
const auto KEY_DL		= 0510;
const auto KEY_IL		= 0511;
const auto KEY_DC		= 0512;
const auto KEY_IC		= 0513;
const auto KEY_EIC		= 0514;
const auto KEY_CLEAR	= 0515;
const auto KEY_EOS		= 0516;
const auto KEY_EOL		= 0517;
const auto KEY_SF		= 0520;
const auto KEY_SR		= 0521;
const auto KEY_NPAGE	= 0522;
const auto KEY_PPAGE	= 0523;
const auto KEY_STAB	= 0524;
const auto KEY_CTAB	= 0525;
const auto KEY_CATAB	= 0526;
const auto KEY_ENTER	= 0527;
const auto KEY_PRINT	= 0532;
const auto KEY_LL		= 0533;
const auto KEY_A1		= 0534;
const auto KEY_A3		= 0535;
const auto KEY_B2		= 0536;
const auto KEY_C1		= 0537;
const auto KEY_C3		= 0540;
const auto KEY_BTAB	= 0541;
const auto KEY_BEG		= 0542;
const auto KEY_CANCEL	= 0543;
const auto KEY_CLOSE	= 0544;
const auto KEY_COMMAND	= 0545;
const auto KEY_COPY	= 0546;
const auto KEY_CREATE	= 0547;
const auto KEY_END		= 0550;
const auto KEY_EXIT	= 0551;
const auto KEY_FIND	= 0552;
const auto KEY_HELP	= 0553;
const auto KEY_MARK	= 0554;
const auto KEY_MESSAGE	= 0555;
const auto KEY_MOVE	= 0556;
const auto KEY_NEXT	= 0557;
const auto KEY_OPEN	= 0560;
const auto KEY_OPTIONS	= 0561;
const auto KEY_PREVIOUS	= 0562;
const auto KEY_REDO	= 0563;
const auto KEY_REFERENCE	= 0564;
const auto KEY_REFRESH	= 0565;
const auto KEY_REPLACE	= 0566;
const auto KEY_RESTART	= 0567;
const auto KEY_RESUME	= 0570;
const auto KEY_SAVE	= 0571;
const auto KEY_SBEG	= 0572;
const auto KEY_SCANCEL	= 0573;
const auto KEY_SCOMMAND	= 0574;
const auto KEY_SCOPY	= 0575;
const auto KEY_SCREATE	= 0576;
const auto KEY_SDC		= 0577;
const auto KEY_SDL		= 0600;
const auto KEY_SELECT	= 0601;
const auto KEY_SEND	= 0602;
const auto KEY_SEOL	= 0603;
const auto KEY_SEXIT	= 0604;
const auto KEY_SFIND	= 0605;
const auto KEY_SHELP	= 0606;
const auto KEY_SHOME	= 0607;
const auto KEY_SIC		= 0610;
const auto KEY_SLEFT	= 0611;
const auto KEY_SMESSAGE	= 0612;
const auto KEY_SMOVE	= 0613;
const auto KEY_SNEXT	= 0614;
const auto KEY_SOPTIONS	= 0615;
const auto KEY_SPREVIOUS	= 0616;
const auto KEY_SPRINT	= 0617;
const auto KEY_SREDO	= 0620;
const auto KEY_SREPLACE	= 0621;
const auto KEY_SRIGHT	= 0622;
const auto KEY_SRSUME	= 0623;
const auto KEY_SSAVE	= 0624;
const auto KEY_SSUSPEND	= 0625;
const auto KEY_SUNDO	= 0626;
const auto KEY_SUSPEND	= 0627;
const auto KEY_UNDO	= 0630;
const auto KEY_MOUSE	= 0631;
const auto KEY_RESIZE	= 0632;
const auto KEY_EVENT	= 0633;

const auto KEY_MAX		= 0777;

// Mouse interface
const auto NCURSES_BUTTON_RELEASED = 001;
const auto NCURSES_BUTTON_PRESSED = 002;
const auto NCURSES_BUTTON_CLICKED = 004;
const auto NCURSES_DOUBLE_CLICKED = 010;
const auto NCURSES_TRIPLE_CLICKED = 020;
const auto NCURSES_RESERVED_EVENT = 040;

const mmask_t BUTTON1_RELEASED = NCURSES_BUTTON_RELEASED;
const mmask_t BUTTON1_PRESSED = NCURSES_BUTTON_PRESSED;
const mmask_t BUTTON1_CLICKED = NCURSES_BUTTON_CLICKED;
const mmask_t BUTTON1_DOUBLE_CLICKED = NCURSES_DOUBLE_CLICKED;
const mmask_t BUTTON1_TRIPLE_CLICKED = NCURSES_TRIPLE_CLICKED;

const mmask_t BUTTON2_RELEASED = NCURSES_BUTTON_RELEASED << (1 * 5);
const mmask_t BUTTON2_PRESSED = NCURSES_BUTTON_PRESSED << (1 * 5);
const mmask_t BUTTON2_CLICKED = NCURSES_BUTTON_CLICKED << (1 * 5);
const mmask_t BUTTON2_DOUBLE_CLICKED = NCURSES_DOUBLE_CLICKED << (1 * 5);
const mmask_t BUTTON2_TRIPLE_CLICKED = NCURSES_TRIPLE_CLICKED << (1 * 5);

const mmask_t BUTTON3_RELEASED = NCURSES_BUTTON_RELEASED << (2 * 5);
const mmask_t BUTTON3_PRESSED = NCURSES_BUTTON_PRESSED << (2 * 5);
const mmask_t BUTTON3_CLICKED = NCURSES_BUTTON_CLICKED << (2 * 5);
const mmask_t BUTTON3_DOUBLE_CLICKED = NCURSES_DOUBLE_CLICKED << (2 * 5);
const mmask_t BUTTON3_TRIPLE_CLICKED = NCURSES_TRIPLE_CLICKED << (2 * 5);

const mmask_t BUTTON4_RELEASED = NCURSES_BUTTON_RELEASED << (3 * 5);
const mmask_t BUTTON4_PRESSED = NCURSES_BUTTON_PRESSED << (3 * 5);
const mmask_t BUTTON4_CLICKED = NCURSES_BUTTON_CLICKED << (3 * 5);
const mmask_t BUTTON4_DOUBLE_CLICKED = NCURSES_DOUBLE_CLICKED << (3 * 5);
const mmask_t BUTTON4_TRIPLE_CLICKED = NCURSES_TRIPLE_CLICKED << (3 * 5);

const mmask_t BUTTON5_RELEASED = NCURSES_BUTTON_RELEASED << (4 * 5);
const mmask_t BUTTON5_PRESSED = NCURSES_BUTTON_PRESSED << (4 * 5);
const mmask_t BUTTON5_CLICKED = NCURSES_BUTTON_CLICKED << (4 * 5);
const mmask_t BUTTON5_DOUBLE_CLICKED = NCURSES_DOUBLE_CLICKED << (4 * 5);
const mmask_t BUTTON5_TRIPLE_CLICKED = NCURSES_TRIPLE_CLICKED << (4 * 5);

const mmask_t BUTTON_CTRL = 0001 << (5 * 5);
const mmask_t BUTTON_SHIFT = 0002 << (5 * 5);
const mmask_t BUTTON_ALT = 0004 << (5 * 5);
const mmask_t REPORT_MOUSE_POSITION = 0010 << (5 * 5);

const mmask_t ALL_MOUSE_EVENTS = (REPORT_MOUSE_POSITION - 1);

int BUTTON_RELEASE(int event, int button) {
	return (event & (001 << (6 * (button - 1))));
}

int BUTTON_PRESS(int event, int button) {
	return (event & (002 << (6 * (button - 1))));
}

int BUTTON_CLICK(int event, int button) {
	return (event & (004 << (6 * (button - 1))));
}

int BUTTON_DOUBLE_CLICK(int event, int button) {
	return (event & (010 << (6 * (button - 1))));
}

int BUTTON_TRIPLE_CLICK(int event, int button) {
	return (event & (020 << (6 * (button - 1))));
}

int BUTTON_RESERVED_EVENT(int event, int button) {
	return (event & (040 << (6 * (button - 1))));
}

struct MEVENT {
	short id;
	int x;
	int y;
	int z;
	mmask_t bstate;
}

// Functions
int getmouse(MEVENT*);
int ungetmouse(MEVENT*);
mmask_t mousemask(mmask_t, mmask_t*);
bool wenclose(WINDOW*, int, int);
int mouseinterval(int);
bool wmouse_trafo(WINDOW*, int*, int*, bool);
bool mouse_trafo(int*, int*, bool);

// other non-XSI functions

int mcprint(char*, int);
int has_key(int);

// << term.h >> //

typedef ubyte NCURSES_SBOOL;
const auto NCURSES_XNAMES = 1;
const auto NAMESIZE = 256;

int tputs(char* str, int affcnt, int function(int) putfunc);
