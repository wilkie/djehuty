/*
 * apploop.d
 *
 * This is the Gui Application entry point for Linux.
 *
 * Author: Dave Wilkinson
 * Originated: July 25th, 2009
 *
 */

module gui.apploop;

import platform.unix.main;

import platform.vars.window;
import platform.vars.view;

import platform.unix.common;

import X = binding.x.Xlib;

import gui.window;
import gui.application;

import graphics.view;

import core.main;
import core.definitions;

import io.console;

class GuiApplicationController {

	// The initial entry for the gui application
	this() {
		// this code is executed at initialization of the application
		auto foo = X.XInitThreads();
		_pfvars.running = true;

		//ATTEMPT TO USE GTK
		//int argc = 0;
		//char* argv[] = ("", null);

		//char** argv_ptr = &argv;

		//use X11
		_pfvars.display = X.XOpenDisplay(null);

		_pfvars.screen = X.XDefaultScreen(_pfvars.display);
		_pfvars.visual = X.XDefaultVisual(_pfvars.display, _pfvars.screen);

		//set up click timer
		_pfvars.clickTimerevp.sigev_notify = SIGEV_THREAD;
		_pfvars.clickTimerevp._sigev_un._sigev_thread._function = &mousetimerproc;

		//get Atoms
		_pfvars.wm_destroy_window = X.XInternAtom(_pfvars.display, "WM_DELETE_WINDOW\0"c.ptr, X.Bool.True);
		_pfvars.private_data = X.XInternAtom(_pfvars.display, "DJEHUTY_PRIVATE_DATA\0"c.ptr, X.Bool.True);
		_pfvars.x_settings = X.XInternAtom(_pfvars.display, "_XSETTINGS_SETTINGS\0"c.ptr, X.Bool.False);

		//	_pfvars.utf8string = X.XInternAtom(_pfvars.display, "UTF8_STRING\0"c.ptr, X.Bool.True);

	}

	void start() {
		mainloop();
	}

	void end(uint code) {
		_pfvars.running = false;
	}

private:

	int[] _keySymToKeyCode = [
		// Misc
		(X.XK_BackSpace & 0x1ff): Key.Backspace,
		(X.XK_Tab & 0x1ff): Key.Tab,
		(X.XK_Return & 0x1ff): Key.Return,
		(X.XK_Pause & 0x1ff): Key.Pause,
		(X.XK_Escape & 0x1ff): Key.Escape,
		(X.XK_Space & 0x1ff): Key.Space,
		(X.XK_Prior & 0x1ff): Key.PageUp,
		(X.XK_Next & 0x1ff): Key.PageDown,
		(X.XK_End & 0x1ff): Key.End,
		(X.XK_Home & 0x1ff): Key.Home,
		(X.XK_Left & 0x1ff): Key.Left,
		(X.XK_Right & 0x1ff): Key.Right,
		(X.XK_Up & 0x1ff): Key.Up,
		(X.XK_Down & 0x1ff): Key.Down,
		(X.XK_Insert & 0x1ff): Key.Insert,
		(X.XK_Delete & 0x1ff): Key.Delete,

		// Numbers
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

		// Letters
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

		// Printable

		'`': Key.SingleQuote,
		';': Key.Semicolon,
		'[': Key.LeftBracket,
		']': Key.RightBracket,
		',': Key.Comma,
		'.': Key.Period,
		'/': Key.Foreslash,
		'\\': Key.Backslash,
		'\'': Key.Quote,
		'-': Key.Minus,
		'=': Key.Equals,

		// Function Keys

		(X.XK_F1 & 0x1ff): Key.F1,
		(X.XK_F2 & 0x1ff): Key.F2,
		(X.XK_F3 & 0x1ff): Key.F3,
		(X.XK_F4 & 0x1ff): Key.F4,
		(X.XK_F5 & 0x1ff): Key.F5,
		(X.XK_F6 & 0x1ff): Key.F6,
		(X.XK_F7 & 0x1ff): Key.F7,
		(X.XK_F8 & 0x1ff): Key.F8,
		(X.XK_F9 & 0x1ff): Key.F9,
		(X.XK_F10 & 0x1ff): Key.F10,
		(X.XK_F11 & 0x1ff): Key.F11,
		(X.XK_F12 & 0x1ff): Key.F12,
		(X.XK_F13 & 0x1ff): Key.F13,
		(X.XK_F14 & 0x1ff): Key.F14,
		(X.XK_F15 & 0x1ff): Key.F15,
		(X.XK_F16 & 0x1ff): Key.F16,

		// Meta Keys

		(X.XK_Num_Lock & 0x1ff): Key.NumLock,
		(X.XK_Scroll_Lock & 0x1ff): Key.ScrollLock,
		(X.XK_Shift_L & 0x1ff): Key.LeftShift,
		(X.XK_Shift_R & 0x1ff): Key.RightShift,
		(X.XK_Control_L & 0x1ff): Key.LeftControl,
		(X.XK_Control_R & 0x1ff): Key.RightControl,
		(X.XK_Meta_L & 0x1ff): Key.LeftAlt,
		(X.XK_Meta_R & 0x1ff): Key.RightAlt,
	];

	void mainloop() {

		// for the iterator

		Window window_test;
		Window window;
		Window viewWindow;

		WindowPlatformVars* windowVars;

		// poll for events
		X.XEvent event;

		uint i;

		GuiApplication app = cast(GuiApplication)Djehuty.app;

		X.XLockDisplay(_pfvars.display);
		while(_pfvars.running) {

			// will block until an event is received

			X.XUnlockDisplay(_pfvars.display);
			X.XNextEvent(_pfvars.display, &event);
			X.XLockDisplay(_pfvars.display);

			// Find which window spawned this event

			window_test = app.firstWindow();
			window = null;

			if (window_test !is null) {
				do {
					windowVars = &window_test._pfvars;
					if (windowVars.window == event.xany.window) {
						window = window_test;
						break;
					}
					window_test = window_test.nextWindow();
				} while (window_test !is app.firstWindow())
			}

			if (window is null) {
				if (event.type == X.EventType.CreateNotify) {
				}
				if (event.type == X.EventType.ReparentNotify) {
				}
				continue;
			}

			if (windowVars.destroy_called) {
				// Window is destroyed...
				// Typically by window manager
				if (event.type == X.EventType.DestroyNotify) {
					window.uninitialize();
				}
				continue;
			}

			// Interpret Event

			switch (event.type) {

				// Client Messages

				case X.EventType.ClientMessage:

					if (event.xclient.data.l[0] == _pfvars.wm_destroy_window) {
						window.remove();
					}
					break;

				// Expose

				case X.EventType.Expose:
					if (event.xexpose.count == 0) {
						View view = window._view;
						ViewPlatformVars* viewVars = window._viewVars;

						window.onDraw();

						view.lock();

						X.XCopyArea(_pfvars.display, viewVars.pixmap, windowVars.window,
								viewVars.gc, 0, 0, window.width, window.height, 0, 0);

						view.unlock();
					}
					break;

				case X.EventType.CreateNotify:

					break;
				
				case X.EventType.PropertyNotify:

					break;

					// This is for window managers that will reparent your window inside
					// a decorated frame. This way, we can reposition the window relative
					// to this frame.
				case X.EventType.ReparentNotify:
					windowVars.wm_parent = event.xreparent.event;
					windowVars.wm_x = event.xreparent.x;
					windowVars.wm_y = event.xreparent.y;

					// reposition
					uint w_x;
					uint w_y;

					w_x = window.x;
					w_y = window.y;

					if (window.position == WindowPosition.Center) {
						uint d_width = X.XDisplayWidth(_pfvars.display, _pfvars.screen);
						uint d_height = X.XDisplayHeight(_pfvars.display, _pfvars.screen);

						w_x = d_width - window.width;
						w_y = d_height - window.height;

						w_x >>= 1;
						w_y >>= 1;
					}

					if (window.position != WindowPosition.Default) {
						X.XMoveWindow(_pfvars.display, windowVars.wm_parent, w_x, w_y);
					}

					break;

				case X.EventType.ConfigureNotify:

					// Resize
					if (window.width != event.xconfigure.width ||
						window.height != event.xconfigure.height) {

						// Window was resized
						window._width = event.xconfigure.width;
						window._height = event.xconfigure.height;
						window.onResize;
					}
					else {
						// Window was moved
					}
					break;

				// Focus

				case X.EventType.FocusIn:

					// Window received focus

					if (event.xfocus.mode == X.NotifyModes.NotifyNormal) {
						window.onGotFocus();
					}
					break;

				case X.EventType.FocusOut:

					// Window loses focus

					if (event.xfocus.mode == X.NotifyModes.NotifyNormal) {
						window.onLostFocus();
					}
					break;

				// Mouse

				case X.EventType.ButtonPress:

					window.mouseProps.x = event.xbutton.x;
					window.mouseProps.y = event.xbutton.y;

					window.mouseProps.leftDown = 0;
					window.mouseProps.rightDown = 0;
					window.mouseProps.middleDown = 0;

					switch (event.xbutton.button) {
						case X.ButtonName.Button1: // Primary
							window.mouseProps.leftDown = 1;
							break;
						case X.ButtonName.Button2: // Middle
							window.mouseProps.middleDown = 1;
							break;
						case X.ButtonName.Button3: // Secondary
							window.mouseProps.rightDown = 1;
							break;
						case X.ButtonName.Button4: // Other
							break;
						case X.ButtonName.Button5: // Other
							break;
					}

					if (event.xbutton.state & X.ButtonMask.Button1Mask) {
						window.mouseProps.leftDown = 1;
					}

					if (event.xbutton.state & X.ButtonMask.Button2Mask) {
						window.mouseProps.middleDown = 1;
					}

					if (event.xbutton.state & X.ButtonMask.Button3Mask) {
						window.mouseProps.rightDown = 1;
					}

					switch (event.xbutton.button) {
						case X.ButtonName.Button1:
							window.onPrimaryMouseDown();
							break;
						case X.ButtonName.Button2:
							window.onTertiaryMouseDown();
							break;
						case X.ButtonName.Button3:
							window.onSecondaryMouseDown();
							break;
						case X.ButtonName.Button4:
							window.onOtherMouseDown(0);
							break;
						case X.ButtonName.Button5:
							window.onOtherMouseDown(1);
							break;
					}

					break;

				case X.EventType.ButtonRelease:

					window.mouseProps.x = event.xbutton.x;
					window.mouseProps.y = event.xbutton.y;

					window.mouseProps.leftDown = 0;
					window.mouseProps.rightDown = 0;
					window.mouseProps.middleDown = 0;

					if (event.xbutton.state & X.ButtonMask.Button1Mask) {
						window.mouseProps.leftDown = 1;
					}

					if (event.xbutton.state & X.ButtonMask.Button2Mask) {
						window.mouseProps.rightDown = 1;
					}

					if (event.xbutton.state & X.ButtonMask.Button3Mask) {
						window.mouseProps.middleDown = 1;
					}

					switch (event.xbutton.button) {
						case X.ButtonName.Button1:
							window.mouseProps.leftDown = 0;
							window.onPrimaryMouseUp();
							break;
						case X.ButtonName.Button2:
							window.mouseProps.middleDown = 0;
							window.onTertiaryMouseUp();
							break;
						case X.ButtonName.Button3:
							window.mouseProps.rightDown = 0;
							window.onSecondaryMouseUp();
							break;
						case X.ButtonName.Button4:
							window.onOtherMouseUp(0);
							break;
						case X.ButtonName.Button5:
							window.onOtherMouseUp(1);
							break;
					}

					if (_pfvars.clickTimerId) {
						timer_delete(_pfvars.clickTimerId);
					}

					_pfvars.clickTimerevp.sigev_value.sival_ptr = &window.mouseProps;

					timer_create(CLOCK_REALTIME, &_pfvars.clickTimerevp,
						&_pfvars.clickTimerId);

					timer_settime(_pfvars.clickTimerId, 0,
						&_pfvars.clickTimertime, null);

					window.mouseProps.clicks++;
					break;

				// Mouse Movement

				case X.EventType.MotionNotify:

					if (event.xmotion.state & X.ButtonMask.Button1Mask) {
						window.mouseProps.leftDown = 1;
					}

					if (event.xmotion.state & X.ButtonMask.Button2Mask) {
						window.mouseProps.rightDown = 1;
					}

					if (event.xmotion.state & X.ButtonMask.Button3Mask) {
						window.mouseProps.middleDown = 1;
					}

					window.mouseProps.x = event.xmotion.x;
					window.mouseProps.y = event.xmotion.y;

					window.onMouseMove();

					break;

				case X.EventType.EnterNotify:

					// Mouse enters the client area of the window
					break;

				case X.EventType.LeaveNotify:

					// Mouse leaves the client area of the window
					window.onMouseLeave();
					break;

				// Keyboard

				case X.EventType.KeyPress:

					X.KeySym ksym;
					ksym = X.XLookupKeysym(&event.xkey, 0);

					//interpret the keysymbol...is it a character?
					//convert to unicode character...
					int keyCounter;
					for (keyCounter = 0; keyCounter<_pfvars.numSysKeys; keyCounter++) {
						if (ksym == _pfvars.sysKey[keyCounter]) {
							break;
						}
					}

					Key key;
					key.code = _keySymToKeyCode[(ksym & 0x1ff)];
					window.onKeyDown(key);

					if (keyCounter != _pfvars.numSysKeys) {
					}
					else {
						if (ksym >= 'a' && ksym <= 'z' || ksym == ' ') {
							window.onKeyChar(cast(char)ksym);
						}
					}

					break;

				case X.EventType.KeyRelease:

					X.KeySym ksym2;
					ksym2 = X.XLookupKeysym(&event.xkey, 0);

					Key key;
					key.code = ksym2;
					window.onKeyUp(key);
					break;

				default:
					break;
			}
		}
		X.XCloseDisplay(_pfvars.display);
	}
}
