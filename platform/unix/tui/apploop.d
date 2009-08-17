/*
 * apploop.d
 *
 * This is the Gui Application entry point for Linux.
 *
 * Author: Dave Wilkinson
 * Originated: July 25th, 2009
 *
 */

module tui.apploop;

import scaffold.console;

import tui.application;
import tui.window;

import core.main;
import core.definitions;

import io.console;

import platform.unix.common;

class TuiApplicationController {

	// The initial entry for a tui application
	this() {
	}

	void start() {
		consoleLoop();
	}

	void end(uint code) {
		ConsoleUninit();
		exit(code);
	}

private:
	void consoleLoop()
	{
		static int mouse_x = -1;
		static int mouse_y = -1;

		for (;;)
		{
			//become IO bound

			ulong ky; uint tky;

			Key key = consoleGetKey();

			TuiApplication app = cast(TuiApplication)Djehuty.app;
			TuiWindow window = app.window;

			if (key.code == Curses.KEY_RESIZE) {
				// Resize
				window.onResize();
				continue;
			}
			else if (key.code == Curses.KEY_MOUSE) {
				// Mouse
				Curses.MEVENT evt;
				if (Curses.getmouse(&evt) == Curses.ERR) {
					continue;
				}

				window.mouseProps.x = evt.x;
				window.mouseProps.y = evt.y;

				const auto CLICKED = Curses.BUTTON1_CLICKED | Curses.BUTTON2_CLICKED |
					Curses.BUTTON3_CLICKED | Curses.BUTTON4_CLICKED |
					Curses.BUTTON5_CLICKED;
				const auto DOUBLE_CLICKED = Curses.BUTTON1_DOUBLE_CLICKED | Curses.BUTTON2_DOUBLE_CLICKED |
					Curses.BUTTON3_DOUBLE_CLICKED | Curses.BUTTON4_DOUBLE_CLICKED |
					Curses.BUTTON5_DOUBLE_CLICKED;
				const auto TRIPLE_CLICKED = Curses.BUTTON1_DOUBLE_CLICKED | Curses.BUTTON2_DOUBLE_CLICKED |
					Curses.BUTTON3_TRIPLE_CLICKED | Curses.BUTTON4_DOUBLE_CLICKED |
					Curses.BUTTON5_TRIPLE_CLICKED;

				window.mouseProps.clicks = 1;
				if (evt.bstate & CLICKED) {
					window.mouseProps.clicks = 1;
				}
				else if (evt.bstate & DOUBLE_CLICKED) {
					window.mouseProps.clicks = 2;
				}
				else if (evt.bstate & TRIPLE_CLICKED) {
					window.mouseProps.clicks = 3;
				}

				if (evt.bstate & Curses.BUTTON1_PRESSED) {
					window.onPrimaryMouseDown();
				}
				else if (evt.bstate & Curses.BUTTON2_PRESSED) {
					window.onSecondaryMouseDown();
				}
				else if (evt.bstate & Curses.BUTTON3_PRESSED) {
					window.onTertiaryMouseDown();
				}
				else if (evt.bstate & Curses.BUTTON4_PRESSED) {
					window.onOtherMouseDown(0);
				}
				else if (evt.bstate & Curses.BUTTON5_PRESSED) {
					window.onOtherMouseDown(1);
				}
				else if (evt.bstate & Curses.BUTTON1_RELEASED) {
					window.onPrimaryMouseUp();
				}
				else if (evt.bstate & Curses.BUTTON2_RELEASED) {
					window.onSecondaryMouseUp();
				}
				else if (evt.bstate & Curses.BUTTON3_RELEASED) {
					window.onTertiaryMouseUp();
				}
				else if (evt.bstate & Curses.BUTTON4_RELEASED) {
					window.onOtherMouseUp(0);
				}
				else if (evt.bstate & Curses.BUTTON5_RELEASED) {
					window.onOtherMouseUp(1);
				}

				if ((evt.x != mouse_x) || (evt.y != mouse_y)) {
					mouse_x = evt.x;
					mouse_y = evt.y;
					window.onMouseMove();
					Console.setPosition(evt.x, evt.y);
				}
				continue;
			}

			window.onKeyDown(key);

			dchar chr;
			if (isPrintable(key, chr)) {
				window.onKeyChar(chr);
			}

			/* if (m_exit)
			   {
			   fireEvent(EventUninitState, 0);
			   break;
			   } */
		}
	}
}
