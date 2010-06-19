/*
 * cui.d
 *
 * This module implements the Cui event loop.
 *
 * Author: Dave Wilkinson
 * Originated: August 17th 2009
 *
 */

module scaffold.cui;

import platform.vars.cui;

import platform.unix.common;

import scaffold.console;

import djehuty;

import platform.application;

import cui.application;

import binding.c;

private {
	winsize m_winsize_saved;
	winsize m_winsize_working;
}

private extern(C) void size_sig_handler(int signal) {
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

	//CuiApplication app = cast(CuiApplication)Djehuty.app;
	//app.window.onResize();
}

void CuiStart(CuiPlatformVars* vars) {
	Curses.savetty();

	ApplicationController app = ApplicationController.instance();
	app.usingCurses = true;
	setvbuf (stdout, null, _IONBF, 0);

	Curses.initscr();
	setlocale(LC_ALL, "");
	setlocale(LC_CTYPE, "");
	Curses.start_color();
	Curses.wtimeout(Curses.stdscr, 0);
	Curses.keypad(Curses.stdscr, 1);

	Curses.wmove(Curses.stdscr, 0, 0);

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

	Curses.getmaxyx(Curses.stdscr, m_height, m_width);
	setvbuf (stdout, null, _IONBF, 0);

	// Enable mouse movement (in case ncurses chokes and doesn't!)
//	Curses.wprintw(Curses.stdscr, "\x1B[?1002h");
//	Curses.wprintw(Curses.stdscr, "\x1B[?1003h");
	printf("\x1B[?1002h");
	printf("\x1B[?1003h");

	// Hide caret
	Curses.curs_set(0);
}

void CuiEnd(CuiPlatformVars* vars) {
	if (ApplicationController.instance.usingCurses) {
		ApplicationController.instance.usingCurses = false;
	}
	Curses.endwin();
	Curses.reset_shell_mode();
	Curses.resetterm();
}

void CuiNextEvent(Event* evt, CuiPlatformVars* vars) {

start:

	static int lastPressed;
	static bool dragOver = true;
	static Mouse oldMouse;

	//become IO bound

	ulong ky; uint tky;

	Key key = consoleGetKey();

	if (key.code == Curses.KEY_RESIZE) {
		// Resize
		evt.type = Event.Size;
		return;
	}
	else if (key.code == Curses.KEY_MOUSE) {
		// Mouse
		Curses.MEVENT event;
		if (Curses.getmouse(&event) == Curses.ERR) {
			goto start;
		}

		evt.info.mouse.x = event.x;
		evt.info.mouse.y = event.y;

		auto clickedMasks = [
			Curses.BUTTON1_CLICKED | Curses.BUTTON1_DOUBLE_CLICKED | Curses.BUTTON1_TRIPLE_CLICKED,
			Curses.BUTTON2_CLICKED | Curses.BUTTON2_DOUBLE_CLICKED | Curses.BUTTON2_TRIPLE_CLICKED,
			Curses.BUTTON3_CLICKED | Curses.BUTTON3_DOUBLE_CLICKED | Curses.BUTTON3_TRIPLE_CLICKED,
			//Curses.BUTTON4_CLICKED | Curses.BUTTON4_DOUBLE_CLICKED | Curses.BUTTON4_TRIPLE_CLICKED,
			//Curses.BUTTON5_CLICKED | Curses.BUTTON5_DOUBLE_CLICKED | Curses.BUTTON5_TRIPLE_CLICKED,
		];

		auto releasedMasks = [
			Curses.BUTTON1_RELEASED,
			Curses.BUTTON2_RELEASED,
			Curses.BUTTON3_RELEASED,
			//Curses.BUTTON4_RELEASED,
			//Curses.BUTTON5_RELEASED
		];

		auto pressedMasks = [
			Curses.BUTTON1_PRESSED,
			Curses.BUTTON2_PRESSED,
			Curses.BUTTON3_PRESSED,
			//Curses.BUTTON4_PRESSED,
			//Curses.BUTTON5_PRESSED
		];
		
		if (event.bstate & 
			(Curses.BUTTON4_RELEASED | Curses.BUTTON4_CLICKED 
			  | Curses.BUTTON4_DOUBLE_CLICKED | Curses.BUTTON4_TRIPLE_CLICKED)) {
			// Mouse drag over
			evt.aux = lastPressed;
			evt.type = Event.MouseUp;
			dragOver = true;
			return;
		}

		if (event.bstate & Curses.BUTTON4_PRESSED) {
			// Mouse drag
			if (dragOver) {
				evt.aux = lastPressed;
				evt.type = Event.MouseDown;
				dragOver = false;
				return;
			}
		}

		foreach(size_t idx, mask; releasedMasks) {
			if ((event.bstate & mask)
			  || (event.bstate & clickedMasks[idx])) {
				evt.type = Event.MouseUp;
				evt.aux = idx;
				dragOver = false;
				return;
			}
		}

		foreach(size_t idx, mask; pressedMasks) {
			if (event.bstate & mask) {
				evt.type = Event.MouseDown;
				dragOver = true;
				evt.aux = idx;
				lastPressed = idx;
				return;
			}
		}

		if (evt.info.mouse.x != oldMouse.x || evt.info.mouse.y != oldMouse.y) {
			oldMouse.x = evt.info.mouse.x;
			oldMouse.y = evt.info.mouse.y;

			evt.type = Event.MouseMove;
			evt.aux = 0;
			return;
		}

		goto start;
	}

	evt.type = Event.KeyDown;
	evt.info.key = key;
	return;
}
