/*
 * tui.d
 *
 * This module implements the Tui event loop.
 *
 * Author: Dave Wilkinson
 * Originated: August 17th 2009
 *
 */

module scaffold.tui;

import platform.vars.tui;

import platform.unix.common;

import scaffold.console;

import core.definitions;

import platform.application;

void TuiStart(TuiPlatformVars* vars) {
	ApplicationController app = ApplicationController.instance();
	app.usingCurses = true;

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
}

void TuiEnd(TuiPlatformVars* vars) {
	ConsoleUninit();
}

void TuiNextEvent(TuiEvent* evt, TuiPlatformVars* vars) {

start:

	static int mouse_x = -1;
	static int mouse_y = -1;

	//become IO bound

	ulong ky; uint tky;

	Key key = consoleGetKey();

	if (key.code == Curses.KEY_RESIZE) {
		// Resize
		evt.type = TuiEvent.Type.Size;
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
			evt.type = TuiEvent.Type.MouseDown;
			evt.info.mouse.leftDown = true;
			evt.aux = 0;
			return;
		}
		else if (event.bstate & Curses.BUTTON2_PRESSED) {
			evt.type = TuiEvent.Type.MouseDown;
			evt.info.mouse.rightDown = true;
			evt.aux = 1;
			return;
		}
		else if (event.bstate & Curses.BUTTON3_PRESSED) {
			evt.type = TuiEvent.Type.MouseDown;
			evt.info.mouse.middleDown = true;
			evt.aux = 2;
			return;
		}
		else if (event.bstate & Curses.BUTTON4_PRESSED) {
			evt.type = TuiEvent.Type.MouseDown;
			evt.aux = 3;
			return;
		}
		else if (event.bstate & Curses.BUTTON5_PRESSED) {
			evt.type = TuiEvent.Type.MouseDown;
			evt.aux = 4;
			return;
		}
		else if (event.bstate & Curses.BUTTON1_RELEASED) {
			evt.type = TuiEvent.Type.MouseUp;
			evt.aux = 0;
			return;
		}
		else if (event.bstate & Curses.BUTTON2_RELEASED) {
			evt.type = TuiEvent.Type.MouseUp;
			evt.aux = 1;
			return;
		}
		else if (event.bstate & Curses.BUTTON3_RELEASED) {
			evt.type = TuiEvent.Type.MouseUp;
			evt.aux = 2;
			return;
		}
		else if (event.bstate & Curses.BUTTON4_RELEASED) {
			evt.type = TuiEvent.Type.MouseUp;
			evt.aux = 3;
			return;
		}
		else if (event.bstate & Curses.BUTTON5_RELEASED) {
			evt.type = TuiEvent.Type.MouseUp;
			evt.aux = 4;
			return;
		}

		if ((event.x != mouse_x) || (event.y != mouse_y)) {
			mouse_x = event.x;
			mouse_y = event.y;

			evt.type = TuiEvent.Type.MouseMove;
			return;
		}
		goto start;
	}

	evt.type = TuiEvent.Type.KeyDown;
	evt.info.key = key;
	return;
}
