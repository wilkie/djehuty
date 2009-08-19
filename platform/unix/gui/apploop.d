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
		X.XInitThreads();
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
		X.XCloseDisplay(_pfvars.display);
	}

private:

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

		while(_pfvars.running) {

			// will block until an event is received

			X.XNextEvent(_pfvars.display, &event);

			// Find which window spawned this event

			window_test = app.firstWindow();
			window = null;

			if (window_test is null) {
				continue;
			}

			do {
				windowVars = &window_test._pfvars;
				if (windowVars.window == event.xany.window) {
					window = window_test;
					break;
				}
				window_test = window_test.nextWindow();
			} while (window_test !is app.firstWindow())

			if (window is null) {
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

						view.lockDisplay();

						X.XCopyArea(_pfvars.display, viewVars.pixmap, windowVars.window,
								viewVars.gc, 0, 0, window.width, window.height, 0, 0);

						view.unlockDisplay();
					}
					break;

				case X.EventType.ReparentNotify:

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
	}
}
