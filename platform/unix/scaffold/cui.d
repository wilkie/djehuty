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

import core.definitions;

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

	Curses.getmaxyx(Curses.stdscr, m_height, m_width);
	setvbuf (stdout, null, _IONBF, 0);
}

void CuiEnd(CuiPlatformVars* vars) {
	if (ApplicationController.instance.usingCurses) {
		ApplicationController.instance.usingCurses = false;
	}
	Curses.endwin();
	Curses.reset_shell_mode();
	Curses.resetterm();
}

void CuiNextEvent(CuiEvent* evt, CuiPlatformVars* vars) {

start:

	static int mouse_x = -1;
	static int mouse_y = -1;

	//become IO bound

	ulong ky; uint tky;

	Key key = consoleGetKey();

	if (key.code == Curses.KEY_RESIZE) {
		// Resize
		evt.type = CuiEvent.Type.Size;
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

		const auto CLICKED = Curses.BUTTON1_CLICKED | Curses.BUTTON2_CLICKED |
				Curses.BUTTON3_CLICKED | Curses.BUTTON4_CLICKED |
				Curses.BUTTON5_CLICKED;
		const auto DOUBLE_CLICKED = Curses.BUTTON1_DOUBLE_CLICKED | Curses.BUTTON2_DOUBLE_CLICKED |
				Curses.BUTTON3_DOUBLE_CLICKED | Curses.BUTTON4_DOUBLE_CLICKED |
				Curses.BUTTON5_DOUBLE_CLICKED;
		const auto TRIPLE_CLICKED = Curses.BUTTON1_DOUBLE_CLICKED | Curses.BUTTON2_DOUBLE_CLICKED |
				Curses.BUTTON3_TRIPLE_CLICKED | Curses.BUTTON4_DOUBLE_CLICKED |
				Curses.BUTTON5_TRIPLE_CLICKED;

		if (event.bstate & CLICKED) {
			evt.info.mouse.clicks = 1;
		}
		else if (event.bstate & DOUBLE_CLICKED) {
			evt.info.mouse.clicks = 2;
		}
		else if (event.bstate & TRIPLE_CLICKED) {
			evt.info.mouse.clicks = 3;
		}

		if (event.bstate & Curses.BUTTON1_PRESSED) {
			evt.type = CuiEvent.Type.MouseDown;
			evt.info.mouse.leftDown = true;
			evt.aux = 0;
			return;
		}
		else if (event.bstate & Curses.BUTTON2_PRESSED) {
			evt.type = CuiEvent.Type.MouseDown;
			evt.info.mouse.rightDown = true;
			evt.aux = 1;
			return;
		}
		else if (event.bstate & Curses.BUTTON3_PRESSED) {
			evt.type = CuiEvent.Type.MouseDown;
			evt.info.mouse.middleDown = true;
			evt.aux = 2;
			return;
		}
		else if (event.bstate & Curses.BUTTON4_PRESSED) {
			evt.type = CuiEvent.Type.MouseDown;
			evt.aux = 3;
			return;
		}
		else if (event.bstate & Curses.BUTTON5_PRESSED) {
			evt.type = CuiEvent.Type.MouseDown;
			evt.aux = 4;
			return;
		}
		else if (event.bstate & Curses.BUTTON1_RELEASED) {
			evt.type = CuiEvent.Type.MouseUp;
			evt.aux = 0;
			return;
		}
		else if (event.bstate & Curses.BUTTON2_RELEASED) {
			evt.type = CuiEvent.Type.MouseUp;
			evt.aux = 1;
			return;
		}
		else if (event.bstate & Curses.BUTTON3_RELEASED) {
			evt.type = CuiEvent.Type.MouseUp;
			evt.aux = 2;
			return;
		}
		else if (event.bstate & Curses.BUTTON4_RELEASED) {
			evt.type = CuiEvent.Type.MouseUp;
			evt.aux = 3;
			return;
		}
		else if (event.bstate & Curses.BUTTON5_RELEASED) {
			evt.type = CuiEvent.Type.MouseUp;
			evt.aux = 4;
			return;
		}

		if ((event.x != mouse_x) || (event.y != mouse_y)) {
			mouse_x = event.x;
			mouse_y = event.y;

			evt.type = CuiEvent.Type.MouseMove;
			return;
		}
		goto start;
	}

	evt.type = CuiEvent.Type.KeyDown;
	evt.info.key = key;
	return;
}
