/*
 * apploop.d
 *
 * This module implements an application loop for TUI apps in Windows.
 *
 * Author: Dave Wilkinson
 * Originated: July 20th, 2009
 *
 */

module tui.apploop;

import tui.application;
import tui.window;

import synch.thread;

import io.console;

import core.main;

import platform.win.common;
import platform.win.main;

class TuiApplicationController {

	// The initial entry for a tui application
	this() {
		init();
	}

	void start() {
		mainloop();
	}

	void end(uint code) {
		_console_loop = false;

		ApplicationController.instance.exitCode = code;
	}

private:

	// Window Resize Detect Thread (Silly)
	Thread t;

	// For the window resize detect
	int _console_x;
	int _console_y;

	// This thread will detect a window resize
	void thread_proc(bool pleaseStop) {
		static bool run = true;

		run = !pleaseStop;

		if (pleaseStop) {
			return;
		}

		// keep looking at the console window for size changes
		CONSOLE_SCREEN_BUFFER_INFO cinfo;

		HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);
	
		while(run) {
			GetConsoleScreenBufferInfo(hStdout, &cinfo);

			if (_console_x != cinfo.srWindow.Right - cinfo.srWindow.Left+1 ||
				_console_y != cinfo.srWindow.Bottom - cinfo.srWindow.Top) {

				_console_x = cinfo.srWindow.Right - cinfo.srWindow.Left+1;
				_console_y = cinfo.srWindow.Bottom - cinfo.srWindow.Top;
	
				(cast(TuiApplication)Djehuty.app).window.onResize();
			}

			t.sleep(100);
		}
	}

	// We will run the event loop until this is false:
	bool _console_loop = true;

	void init() {
		HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);
		DWORD consoleMode;

		GetConsoleMode(hStdout, &consoleMode);

		// Turn off automatic line advancement
		consoleMode &= ~(0x2);

		SetConsoleMode(hStdout, consoleMode);
	}

	BOOL consoleProc(DWORD fdwCtrlType) {
		switch(fdwCtrlType) {
			// Handle the CTRL-C signal.
			// CTRL-CLOSE: confirm that the user wants to exit.
			case CTRL_C_EVENT:
			case CTRL_CLOSE_EVENT:
				Console.putln("Ctrl-Close event");

				Djehuty.end(0);

				return( TRUE );

			// Pass other signals to the next handler.
			case CTRL_BREAK_EVENT:
				Console.putln("Ctrl-Break event");
				return FALSE;

			case CTRL_LOGOFF_EVENT:
				Console.putln("Ctrl-Logoff event");
				return FALSE;

			case CTRL_SHUTDOWN_EVENT:
				printf( "Ctrl-Shutdown event\n\n" );
				return FALSE;

			default:
				break;
		}

		return FALSE;
	}

	void mainloop() {

		t = new Thread;
		t.setDelegate(&thread_proc);
		t.start();

		DWORD cNumRead;
		uint i;
		INPUT_RECORD irInBuf[128];

		bool _last_was_mousepress = false;

		// get handle to standard in
		HANDLE hStdin = GetStdHandle(STD_INPUT_HANDLE);

		// get handle to standard out
		HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);

		if (! SetConsoleMode(hStdin, ENABLE_MOUSE_INPUT) ) {
			Console.putln("Fatal Error: Cannot Set the Console Mode");
        }

		if( SetConsoleCtrlHandler(cast(PHANDLER_ROUTINE)&consoleProc, TRUE))
		{
			while(_console_loop)
			{
				if (! ReadConsoleInputW(
						hStdin,			// input buffer handle
						irInBuf.ptr,	// buffer to read into
						128,			// size of read buffer
						&cNumRead) ) {	// number of records read

					Console.putln("Fatal Error: Cannot Read from Console Event Buffer");
				}

				for (i=0; i<cNumRead; i++) {
					TuiWindow curWindow = (cast(TuiApplication)Djehuty.app).window;
					switch(irInBuf[i].EventType) {
						case KEY_EVENT: // keyboard input
							if (irInBuf[i].Event.KeyEvent.bKeyDown == TRUE) {
								// KeyDown

								// The Current Console View Receives the Event
								curWindow.onKeyDown(irInBuf[i].Event.KeyEvent.wVirtualKeyCode );

								if (irInBuf[i].Event.KeyEvent.uChar.UnicodeChar > 0) {
									curWindow.onKeyChar(irInBuf[i].Event.KeyEvent.uChar.UnicodeChar);
								}
							}
							else {
								// KeyUp

								// The Current Console View Receives the Event
								curWindow.onKeyUp(irInBuf[i].Event.KeyEvent.wVirtualKeyCode);
							}
		                    break;

		                case MOUSE_EVENT: // mouse input

							uint curbutton=0;
							bool isPressed = true;
							bool isMovement = false;

							CONSOLE_SCREEN_BUFFER_INFO cinfo;

							GetConsoleScreenBufferInfo(hStdout, &cinfo);

							if (!(irInBuf[i].Event.MouseEvent.dwEventFlags == MOUSE_WHEELED ||
								  irInBuf[i].Event.MouseEvent.dwEventFlags == MOUSE_HWHEELED )) {
								if (curWindow.mouseProps.x != irInBuf[i].Event.MouseEvent.dwMousePosition.X - cinfo.srWindow.Left) {
									curWindow.mouseProps.x = irInBuf[i].Event.MouseEvent.dwMousePosition.X - cinfo.srWindow.Left;
									isMovement = true;
								}
								if (curWindow.mouseProps.y != irInBuf[i].Event.MouseEvent.dwMousePosition.Y - cinfo.srWindow.Top) {
									curWindow.mouseProps.y = irInBuf[i].Event.MouseEvent.dwMousePosition.Y - cinfo.srWindow.Top;
									isMovement = true;
								}
							}

							if (irInBuf[i].Event.MouseEvent.dwButtonState & FROM_LEFT_1ST_BUTTON_PRESSED) {
								if (curWindow.mouseProps.leftDown == false) {
									curbutton = 1;
									curWindow.mouseProps.leftDown = true;
								}
							}
							else {
								if (curWindow.mouseProps.leftDown == true) {
									curbutton = 1;
									curWindow.mouseProps.leftDown = false;
									isPressed = false;
								}
							}

							if (irInBuf[i].Event.MouseEvent.dwButtonState & FROM_LEFT_2ND_BUTTON_PRESSED) {
								if (curWindow.mouseProps.middleDown == false) {
									curbutton = 2;
									curWindow.mouseProps.middleDown = true;
								}
							}
							else {
								if (curWindow.mouseProps.middleDown == true) {
									curbutton = 2;
									curWindow.mouseProps.middleDown = false;
									isPressed = false;
								}
							}

							if (irInBuf[i].Event.MouseEvent.dwButtonState & FROM_LEFT_3RD_BUTTON_PRESSED) {
							/* 	if (cwnd.mouseProps.leftDown == false)
								{
									curbutton = 3;
									cwnd.mouseProps.leftDown = true;
								} */
							}
							else {
								/* if (cwnd.mouseProps.rightDown == true)
								{
									curbutton = 5;
									cwnd.mouseProps.rightDown = false;
									isPressed = false;
								} */
							}

							if (irInBuf[i].Event.MouseEvent.dwButtonState & FROM_LEFT_4TH_BUTTON_PRESSED) {
								/* if (cwnd.mouseProps.leftDown == false)
								{
									curbutton = 3;
									cwnd.mouseProps.leftDown = true;
								} */
							}
							else {
								/* if (cwnd.mouseProps.rightDown == true)
								{
									curbutton = 5;
									cwnd.mouseProps.rightDown = false;
									isPressed = false;
								} */
							}

							if (irInBuf[i].Event.MouseEvent.dwButtonState & RIGHTMOST_BUTTON_PRESSED) {
								if (curWindow.mouseProps.rightDown == false) {
									curbutton = 5;
									curWindow.mouseProps.rightDown = true;
								}
							}
							else {
								if (curWindow.mouseProps.rightDown == true) {
									curbutton = 5;
									curWindow.mouseProps.rightDown = false;
									isPressed = false;
								}
							}

							if (isPressed == false) {
								if (curbutton == 1) {
									_last_was_mousepress = true;
									curWindow.onPrimaryMouseUp();
								}
								else if (curbutton == 2) {
									_last_was_mousepress = true;
									curWindow.onTertiaryMouseUp();
								}
								else if (curbutton == 5) {
									_last_was_mousepress = true;
									curWindow.onSecondaryMouseUp();
								}
							}
							else if (curbutton > 0) {
								if (curbutton == 1) {
									_last_was_mousepress = true;
									curWindow.onPrimaryMouseDown();
								}
								else if (curbutton == 2) {
									_last_was_mousepress = true;
									curWindow.onTertiaryMouseDown();
								}
								else if (curbutton == 5) {
									_last_was_mousepress = true;
									curWindow.onSecondaryMouseDown();
								}
							}
							else
							{
								switch(irInBuf[i].Event.MouseEvent.dwEventFlags)
								{
									case MOUSE_MOVED:
										if (isMovement && !_last_was_mousepress)
										{
											curWindow.onMouseMove();
										}
										_last_was_mousepress = false;
										break;
									case MOUSE_WHEELED:

										short delta = cast(short)(irInBuf[i].Event.MouseEvent.dwButtonState >> 16);

										delta /= 120;

										curWindow.onMouseWheelY(delta);
										break;
									case MOUSE_HWHEELED:

										short delta = cast(short)(irInBuf[i].Event.MouseEvent.dwButtonState >> 16);

										delta /= 120;

										curWindow.onMouseWheelX(delta);
										break;
									default:
										break;
								}
							}


		                    break;

		                case WINDOW_BUFFER_SIZE_EVENT: // scrn buf. resizing
		                    break;

		                default:
		                    break;
		            }
				}
			}
		}
		else {
			Console.putln("Fatal Error: Cannot Initialize the Console Handler");
		}
		ApplicationController.instance.end;
	}
}