/*
 * cui.d
 *
 * This module implements a Cui event loop scaffold for Windows.
 *
 * Author: Dave Wilkinson
 * Originated: August 17th, 2009
 *
 */

module scaffold.cui;

import synch.thread;

import io.console;

import core.main;
import core.definitions;

import binding.win32.winnt;
import binding.win32.windef;
import binding.win32.wincon;
import binding.win32.winuser;
import binding.win32.winbase;

import platform.win.main;

import platform.vars.cui;

import scaffold.console;

import data.queue;

void CuiStart(CuiPlatformVars* vars) {
	// Window Resize Detect Thread (Silly)
	static ResizeThread t;

	vars.events = new Queue!(Event)();

	// get handle to standard out
	vars.stdout = GetStdHandle(STD_OUTPUT_HANDLE);

	// get handle to standard in
	vars.stdin = GetStdHandle(STD_INPUT_HANDLE);

	// Turn off automatic line advancement
	DWORD consoleMode;
	GetConsoleMode(vars.stdout, &consoleMode);
	consoleMode &= ~(0x2);
	SetConsoleMode(vars.stdout, consoleMode);

	// Setup mouse handling
	if (!SetConsoleMode(vars.stdin, ENABLE_MOUSE_INPUT)) {
		Console.putln("Fatal Error: Cannot Set the Console Mode");
    }

	// Spawn a thread to detect window resizes
	//t = new ResizeThread();
	//t.vars = vars;

	//t.start();

	// Set a handler for special signals
	SetConsoleCtrlHandler(cast(PHANDLER_ROUTINE)&consoleProc, TRUE);
}

void CuiNextEvent(Event* evt, CuiPlatformVars* vars) {
	while (vars.events.length == 0) {
		grabEvent(vars);
	}

	*evt = vars.events.remove();
}

void CuiEnd(CuiPlatformVars* vars) {
	ConsoleClear();
}

private {

	// Translation guide
	uint[256] _translateKey = [
		VK_BACK: Key.Backspace,
		VK_TAB: Key.Tab,
		VK_RETURN: Key.Return,

		VK_LSHIFT: Key.LeftShift,
		VK_RSHIFT: Key.RightShift,

		VK_LMENU: Key.LeftAlt,
		VK_RMENU: Key.RightAlt,

		VK_LCONTROL: Key.LeftControl,
		VK_RCONTROL: Key.RightControl,
		
		VK_CAPITAL: Key.CapsLock,
		
		VK_PAUSE: Key.Pause,
		VK_ESCAPE: Key.Escape,
		VK_SPACE: Key.Space,

		VK_PRIOR: Key.PageUp,
		VK_NEXT: Key.PageDown,

		VK_END: Key.End,
		VK_HOME: Key.Home,

		VK_LEFT: Key.Left,
		VK_UP: Key.Up,
		VK_RIGHT: Key.Right,
		VK_DOWN: Key.Down,
		
		VK_INSERT: Key.Insert,
		VK_DELETE: Key.Delete,
		
		0x30: Key.Zero,
		0x31: Key.One,
		0x32: Key.Two,
		0x33: Key.Three,
		0x34: Key.Four,
		0x35: Key.Five,
		0x36: Key.Six,
		0x37: Key.Seven,
		0x38: Key.Eight,
		0x39: Key.Nine,

		0x41: Key.A,
		0x42: Key.B,
		0x43: Key.C,
		0x44: Key.D,
		0x45: Key.E,
		0x46: Key.F,
		0x47: Key.G,
		0x48: Key.H,
		0x49: Key.I,
		0x4A: Key.J,
		0x4B: Key.K,
		0x4C: Key.L,
		0x4D: Key.M,
		0x4E: Key.N,
		0x4F: Key.O,
		0x50: Key.P,
		0x51: Key.Q,
		0x52: Key.R,
		0x53: Key.S,
		0x54: Key.T,
		0x55: Key.U,
		0x56: Key.V,
		0x57: Key.W,
		0x58: Key.X,
		0x59: Key.Y,
		0x5A: Key.Z,
		
		VK_OEM_3: Key.SingleQuote,
		VK_OEM_1: Key.Semicolon,
		VK_OEM_4: Key.LeftBracket,
		VK_OEM_6: Key.RightBracket,
		VK_OEM_COMMA: Key.Comma,
		VK_OEM_PERIOD: Key.Period,
		VK_OEM_2: Key.Foreslash,
		VK_OEM_5: Key.Backslash,
		VK_OEM_7: Key.Quote,
		VK_OEM_MINUS: Key.Minus,
		VK_OEM_PLUS: Key.Equals,
	];

	// This thread will detect a window resize
	class ResizeThread : Thread {
		void stop() {
			running = false;
			super.stop();
		}

		void run() {

			// For the window resize detect
			static int _console_x;
			static int _console_y;

			// keep looking at the console window for size changes
			CONSOLE_SCREEN_BUFFER_INFO cinfo;

			HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);

			GetConsoleScreenBufferInfo(hStdout, &cinfo);

			_console_x = cinfo.srWindow.Right - cinfo.srWindow.Left+1;
			_console_y = cinfo.srWindow.Bottom - cinfo.srWindow.Top;

			while(running) {
				GetConsoleScreenBufferInfo(hStdout, &cinfo);

				if (_console_x != cinfo.srWindow.Right - cinfo.srWindow.Left+1 ||
					_console_y != cinfo.srWindow.Bottom - cinfo.srWindow.Top) {

					_console_x = cinfo.srWindow.Right - cinfo.srWindow.Left+1;
					_console_y = cinfo.srWindow.Bottom - cinfo.srWindow.Top;

					//(cast(CuiApplication)Djehuty.app).window.onResize();
					Event resizeEvent;
					resizeEvent.type = Event.Size;
					resizeEvent.info.size.x = _console_x;
					resizeEvent.info.size.y = _console_y;
					vars.events.add(resizeEvent);
				}

				sleep(100);
			}
		}

		static CuiPlatformVars* vars;

		bool running = true;
	}

	BOOL consoleProc(DWORD fdwCtrlType) {
		switch(fdwCtrlType) {
			// Handle the CTRL-C signal.
			// CTRL-CLOSE: confirm that the user wants to exit.
			case CTRL_C_EVENT:
			case CTRL_CLOSE_EVENT:
				Console.putln("Ctrl-Close event");

				Event evt;
				evt.type = Event.Close;
				evt.aux = 0;

				ResizeThread.vars.events.add(evt);

				return( TRUE );

			// Pass other signals to the next handler.
			case CTRL_BREAK_EVENT:
				Console.putln("Ctrl-Break event");
				return FALSE;

			case CTRL_LOGOFF_EVENT:
				Console.putln("Ctrl-Logoff event");
				return FALSE;

			case CTRL_SHUTDOWN_EVENT:
				Console.putln( "Ctrl-Shutdown event\n\n" );
				return FALSE;

			default:
				break;
		}

		return FALSE;
	}

	void grabEvent(CuiPlatformVars* vars) {
		DWORD cNumRead;

		if (!GetNumberOfConsoleInputEvents(vars.stdin, &cNumRead)) {
			throw new Exception("Fatal Error: Cannot Read from Console Event Buffer");
		}

		if (cNumRead > 0) {
			if (!ReadConsoleInputW(vars.stdin, vars.irInBuf.ptr, 128, &cNumRead)) {
				throw new Exception("Fatal Error: Cannot Read from Console Event Buffer");
			}
		}

		for (uint i=0; i < cNumRead; i++) {

			Event evt;

			switch(vars.irInBuf[i].EventType) {
				case KEY_EVENT: // keyboard input

					auto code = vars.irInBuf[i].Event.KeyEvent.wVirtualKeyCode;
					evt.info.key.code = Key.Invalid;

					if (code == VK_MENU) {
						// Alt pressed, figure out which one
						if ((vars.irInBuf[i].Event.KeyEvent.dwControlKeyState & 0x0002) > 0) {
							code = VK_LMENU;
						}
						else {
							code = VK_RMENU;
						}
					}

					if (code == VK_CONTROL) {
						// Control pressed, figure out which one
						if ((vars.irInBuf[i].Event.KeyEvent.dwControlKeyState & 0x0008) > 0) {
							code = VK_LCONTROL;
						}
						else {
							code = VK_RCONTROL;
						}
					}

					if (code == VK_SHIFT) {
						// Control pressed, figure out which one (eventually)
						code = VK_LSHIFT;
					}

					evt.info.key.code = _translateKey[code];

					evt.info.key.ctrl = ((vars.irInBuf[i].Event.KeyEvent.dwControlKeyState & 0x000C) > 0);
					evt.info.key.alt = ((vars.irInBuf[i].Event.KeyEvent.dwControlKeyState & 0x0003) > 0);
					evt.info.key.shift = ((vars.irInBuf[i].Event.KeyEvent.dwControlKeyState & 0x0010) > 0);

					if (vars.irInBuf[i].Event.KeyEvent.bKeyDown == TRUE) {
						// KeyDown

						// The Current Console View Receives the Event

						evt.type = Event.KeyDown;
						vars.events.add(evt);
					}
					else {
						// KeyUp

						// The Current Console View Receives the Event
						evt.type = Event.KeyUp;
						vars.events.add(evt);
					}
                    break;

                case MOUSE_EVENT: // mouse input

                	static int last_x;
                	static int last_y;
                	static DWORD last_state;
                	static bool _last_was_mousepress;

					uint curbutton=0;
					bool isPressed = true;
					bool isMovement = false;

					CONSOLE_SCREEN_BUFFER_INFO cinfo;

					GetConsoleScreenBufferInfo(vars.stdout, &cinfo);

					if (!(vars.irInBuf[i].Event.MouseEvent.dwEventFlags == MOUSE_WHEELED ||
						  vars.irInBuf[i].Event.MouseEvent.dwEventFlags == MOUSE_HWHEELED )) {
						if (last_x != vars.irInBuf[i].Event.MouseEvent.dwMousePosition.X - cinfo.srWindow.Left) {
							last_x = vars.irInBuf[i].Event.MouseEvent.dwMousePosition.X - cinfo.srWindow.Left;
							isMovement = true;
						}
						if (last_y != vars.irInBuf[i].Event.MouseEvent.dwMousePosition.Y - cinfo.srWindow.Top) {
							last_y = vars.irInBuf[i].Event.MouseEvent.dwMousePosition.Y - cinfo.srWindow.Top;
							isMovement = true;
						}
					}

					if (vars.irInBuf[i].Event.MouseEvent.dwButtonState & FROM_LEFT_1ST_BUTTON_PRESSED) {
						if (!(last_state & FROM_LEFT_1ST_BUTTON_PRESSED)) {
							curbutton = 1;
							evt.info.mouse.clicks[0] = 1;
						}
					}
					else {
						if (last_state & FROM_LEFT_1ST_BUTTON_PRESSED) {
							curbutton = 1;
							evt.info.mouse.clicks[0] = 0;
							isPressed = false;
						}
					}

					if (vars.irInBuf[i].Event.MouseEvent.dwButtonState & RIGHTMOST_BUTTON_PRESSED) {
						if (!(last_state & RIGHTMOST_BUTTON_PRESSED)) {
							curbutton = 5;
							evt.info.mouse.clicks[1] = 1;
						}
					}
					else {
						if (last_state & RIGHTMOST_BUTTON_PRESSED) {
							curbutton = 5;
							evt.info.mouse.clicks[1] = 0;
							isPressed = false;
						}
					}

					last_state = vars.irInBuf[i].Event.MouseEvent.dwButtonState;

					if (isPressed == false) {
						evt.type = Event.MouseUp;
						if (curbutton == 1) {
							_last_was_mousepress = true;
							evt.aux = 0;
							vars.events.add(evt);
						}
						else if (curbutton == 2) {
							_last_was_mousepress = true;
							evt.aux = 2;
							vars.events.add(evt);
						}
						else if (curbutton == 5) {
							_last_was_mousepress = true;
							evt.aux = 1;
							vars.events.add(evt);
						}
					}
					else if (curbutton > 0) {
						evt.type = Event.MouseDown;
						if (curbutton == 1) {
							_last_was_mousepress = true;
							evt.aux = 0;
							vars.events.add(evt);
						}
						else if (curbutton == 2) {
							_last_was_mousepress = true;
							evt.aux = 2;
							vars.events.add(evt);
						}
						else if (curbutton == 5) {
							_last_was_mousepress = true;
							evt.aux = 1;
							vars.events.add(evt);
						}
					}
					else {
						switch(vars.irInBuf[i].Event.MouseEvent.dwEventFlags) {
							case MOUSE_MOVED:
								if (isMovement && !_last_was_mousepress) {
									evt.type = Event.MouseMove;
									vars.events.add(evt);
								}
								_last_was_mousepress = false;
								break;
							case MOUSE_WHEELED:
								short delta = cast(short)(vars.irInBuf[i].Event.MouseEvent.dwButtonState >> 16);

								delta /= 120;

								evt.type = Event.MouseWheelY;
								evt.aux = delta;
								vars.events.add(evt);
								break;
							case MOUSE_HWHEELED:
								short delta = cast(short)(vars.irInBuf[i].Event.MouseEvent.dwButtonState >> 16);

								delta /= 120;

								evt.type = Event.MouseWheelX;
								evt.aux = delta;
								vars.events.add(evt);
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
