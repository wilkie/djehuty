/*
 * main.d
 *
 * This file implements the main routines for the Linux system.
 * This file is the entry point for a Linux application.
 *
 * Author: Dave Wilkinson
 *
 */

module platform.unix.main;

import platform.unix.common;
import platform.unix.vars;
import platform.unix.scaffolds.directory;
import platform.unix.console;

import core.basewindow;
import core.definitions;
import core.main;
import core.string;
import core.thread;
import core.view;
import core.window;

import analyzing.debugger;

import console.main;
import console.window;

extern(C) void mousetimerproc(sigval val)
{
	Mouse* p_mouseProps;

	p_mouseProps = cast(Mouse*)val.sival_ptr;

	p_mouseProps.clicks = 1;
}

// segfault handler
extern(C) void segfault_handler(int signum)
{
	throw new Exception("Access Violation");
}

void eventLoop()
{
	//for the iterator

	BaseWindow window_test;
	BaseWindow window;
	Window viewWindow;

	WindowPlatformVars* windowVars;

	//poll for events
	//and run the apploop
	X.XEvent event;

	uint i;

	while(_pfvars.running)
	{
		X.XNextEvent(_pfvars.display,&event);

		//reinitGTK();

		//find the window

		window_test = Djehuty._windowListHead;
		window = null;

		if (window_test is null)
		{
			continue;
		}

		do
		{
			windowVars = WindowGetPlatformVars(window_test);
			if (windowVars.window == event.xany.window)
			{
				window = window_test;
				break;
			}
			window_test = WindowGetNext(window_test);
		} while (window_test !is Djehuty._windowListHead);

		if ( window is null )
		{
			continue;
		}


		viewWindow = null;

		if ( windowVars.destroy_called )
		{
			/* WINDOW IS DESTROYED */
			if (event.type == X.EventType.DestroyNotify)
			{
				UninitializeWindow(window);
			}
		}
		else
		{
			if (WindowHasView(window))
			{
				viewWindow = cast(Window)window;
			}

			switch (event.type)
			{

	/* Client Messages */

				case X.EventType.ClientMessage:

					if (event.xclient.data.l[0] == _pfvars.wm_destroy_window)
					{
						window.remove();
					}

					break;

	/* Expose */

				case X.EventType.Expose:
					//Window's client area is newly exposed
					if(event.xexpose.count == 0) {

						// If the window has a drawable view, perform drawing
						if (viewWindow !is null)
						{
							View* view = WindowGetView(viewWindow);
							ViewPlatformVars* viewVars = ViewGetPlatformVars(*view);

							viewWindow.OnDraw();

							view.lockDisplay();

							X.XCopyArea(_pfvars.display, viewVars.pixmap,
							  windowVars.window, viewVars.gc,
							  0, 0, viewWindow.getWidth(), viewWindow.getHeight(), 0, 0);

							view.unlockDisplay();
						}
					}
					break;

				case X.EventType.ReparentNotify:

					if (event.xreparent.override_redirect){}
					break;

				case X.EventType.ConfigureNotify:

					//Size
					if (window.getWidth() != event.xconfigure.width ||
						window.getHeight() != event.xconfigure.height)
					{
						//Size
						SetWindowSize(window, event.xconfigure.width, event.xconfigure.height);
						window.OnResize();
					}
					else
					{
						//simply moved, most likely
					}
					break;

	/* Focus */

				case X.EventType.FocusIn:
					if (event.xfocus.mode == X.NotifyModes.NotifyNormal)
					{
						window.OnGotFocus();
					}
					break;

				case X.EventType.FocusOut:
					if (event.xfocus.mode == X.NotifyModes.NotifyNormal)
					{
						window.OnLostFocus();
					}
					break;

	/* Mouse Button */

				case X.EventType.ButtonPress:

					//here is the plan:

					// fire framework timer...if it expires before
					// a RELEASE, then clicks go to 1

					// during a RELEASE, fire framework timer...if it
					// expires before a PRESS, then clicks go to 1

					// fill in Mouse structure

					// surpress the click timer so the number of clicks is retained
					// if (_pfvars.clickTimerId) {
					// 	timer_delete(_pfvars.clickTimerId);
					// }

					window.mouseProps.x = event.xbutton.x;
					window.mouseProps.y = event.xbutton.y;

					switch (event.xbutton.button)
					{
						case X.ButtonName.Button1: // PRIMARY
							window.mouseProps.leftDown = 1;
							window.mouseProps.rightDown = 0;
							window.mouseProps.middleDown = 0;
							break;
						case X.ButtonName.Button2: // MIDDLE
							window.mouseProps.middleDown = 1;
							window.mouseProps.leftDown = 0;
							window.mouseProps.rightDown = 0;
							break;
						case X.ButtonName.Button3: // SECONDARY
							window.mouseProps.rightDown = 1;
							window.mouseProps.leftDown = 0;
							window.mouseProps.middleDown = 0;
							break;
						case X.ButtonName.Button4:
							window.mouseProps.middleDown = 0;
							window.mouseProps.leftDown = 0;
							window.mouseProps.rightDown = 0;
							break;
						case X.ButtonName.Button5:
							window.mouseProps.middleDown = 0;
							window.mouseProps.leftDown = 0;
							window.mouseProps.rightDown = 0;
							break;
					}

					if (event.xbutton.state & X.ButtonMask.Button1Mask)
					{
						window.mouseProps.leftDown = 1;
					}
					if (event.xbutton.state & X.ButtonMask.Button2Mask)
					{
						window.mouseProps.rightDown = 1;
					}
					if (event.xbutton.state & X.ButtonMask.Button3Mask)
					{
						window.mouseProps.middleDown = 1;
					}

					switch (event.xbutton.button)
					{
						case X.ButtonName.Button1:
							window.OnPrimaryMouseDown();
							break;
						case X.ButtonName.Button2:
							window.OnTertiaryMouseDown();
							break;
						case X.ButtonName.Button3:
							window.OnSecondaryMouseDown();
							break;
						case X.ButtonName.Button4:
							window.OnOtherMouseDown(0);
							break;
						case X.ButtonName.Button5:
							window.OnOtherMouseDown(1);
							break;
					}
					break;


				case X.EventType.ButtonRelease:
					//fill in Mouse structure

					window.mouseProps.x = event.xbutton.x;
					window.mouseProps.y = event.xbutton.y;

					window.mouseProps.leftDown = 0;
					window.mouseProps.rightDown = 0;
					window.mouseProps.middleDown = 0;

					if (event.xbutton.state & X.ButtonMask.Button1Mask)
					{
						window.mouseProps.leftDown = 1;
					}
					if (event.xbutton.state & X.ButtonMask.Button2Mask)
					{
						window.mouseProps.rightDown = 1;
					}
					if (event.xbutton.state & X.ButtonMask.Button3Mask)
					{
						window.mouseProps.middleDown = 1;
					}

					switch (event.xbutton.button)
					{
						case X.ButtonName.Button1:
							window.mouseProps.leftDown = 0;
							window.OnPrimaryMouseUp();
							break;
						case X.ButtonName.Button2:
							window.mouseProps.middleDown = 0;
							window.OnTertiaryMouseUp();
							break;
						case X.ButtonName.Button3:
							window.mouseProps.rightDown = 0;
							window.OnSecondaryMouseUp();
							break;
						case X.ButtonName.Button4:
							window.OnOtherMouseUp(0);
							break;
						case X.ButtonName.Button5:
							window.OnOtherMouseUp(1);
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

	/* Mouse Movement */

				case X.EventType.MotionNotify:

					if (event.xmotion.state & X.ButtonMask.Button1Mask)
					{
						window.mouseProps.leftDown = 1;
					}
					if (event.xmotion.state & X.ButtonMask.Button2Mask)
					{
						window.mouseProps.rightDown = 1;
					}
					if (event.xmotion.state & X.ButtonMask.Button3Mask)
					{
						window.mouseProps.middleDown = 1;
					}

					window.mouseProps.x = event.xmotion.x;
					window.mouseProps.y = event.xmotion.y;

					window.OnMouseMove();

					break;
				case X.EventType.EnterNotify:
					//Cursor enters the client area of the window
					break;
				case X.EventType.LeaveNotify:
					//Cursor leaves the client area of the window
					window.OnMouseLeave();
					break;

	/* Keyboard */

				case X.EventType.KeyPress:

					X.KeySym ksym;
					ksym = X.XLookupKeysym(&event.xkey, 0);

					//interpret the keysymbol...is it a character?
					//convert to unicode character...
					int keyCounter;
					for (keyCounter = 0; keyCounter<_pfvars.numSysKeys; keyCounter++)
					{
						if (ksym == _pfvars.sysKey[keyCounter])
						{
							break;
						}
					}

					if (keyCounter != _pfvars.numSysKeys)
					{
					}
					else
					{
						if (ksym >= 'a' && ksym <= 'z' || ksym == ' ')
						{
							window.OnKeyChar(cast(char)ksym);
						}
					}
					break;

				case X.EventType.KeyRelease:

					X.KeySym ksym2;
					ksym2 = X.XLookupKeysym(&event.xkey, 0);

					window.OnKeyUp(ksym2);
					break;

				default:
					// unknown, unhandled event
					break;
			}
		}
	}
}

//will return the next character pressed
ulong consoleGetKey()
{

	ulong tmp;
	tmp = getchar();

	if (tmp != 0x1B)
	{
		return tmp;
	}
	else
	{
		//wait for extended commands
		tmp = getchar();

		if (tmp == KeyEscape)
		{
			return tmp;
		}
		else if (tmp == 0x5B) // [
		{
			tmp = getchar();

			if (tmp == 0x31)
			{
				tmp <<= 8;
				tmp |= getchar();

				if ((tmp & 0xFF) == 0x7E)
				{
					return tmp;
				}
				else if (((tmp & 0xFF) == 0x35) || ((tmp & 0xFF) == 0x37) || ((tmp & 0xFF) == 0x38) || ((tmp & 0xFF) == 0x39))
				{
					tmp <<= 8;
					tmp |=getchar();

					if ((tmp & 0xFF) == 0x7E)
					{
						return tmp;
					}

					//shift + F5, F6, F7, or F8
					tmp <<= 8;
					tmp |= getchar();

					if ((tmp & 0xFF) == 0x7E) { return tmp; }
					if (getchar() == 0x7E) { return tmp; }
				}
				else if ((tmp & 0xFF) == 0x3B)
				{
					//ALT + ARROW KEYS, SHIFT + ARROW KEYS
					tmp <<= 8;
					tmp |= getchar();

					if ((tmp & 0xFF) == 0x7E) { return tmp; }

					//when we have added a '32' -- shift
					//when we have added a '33' -- alt
					//when we have added a '34' -- shift and alt

					tmp <<= 8;
					tmp |= getchar();
				}
				else
				{
					tmp <<=	8;
					tmp |= getchar();
				}
			}
			else if (tmp == 0x32)
			{
				tmp <<= 8;
				tmp |= getchar();

				if ((tmp & 0xFF) == 0x7E)
				{
					return tmp;
				}

				//ALT + INSERT
				if ((tmp & 0xFF) == 0x3B)
				{
					tmp <<= 8;
					tmp |= getchar();
					if ((tmp & 0xFF) == 0x7E) { return tmp; }
					if (getchar() == 0x7E) { return tmp; }
				}

				//SHIFT + F9, F10, F11, F12

				tmp <<= 8;
				tmp |= getchar();

				if ((tmp & 0xFF) == 0x3B)
				{
					tmp <<= 8;
					tmp |= getchar();
					if ((tmp & 0xFF) == 0x7E) { return tmp; }
					if (getchar() == 0x7E) { return tmp; }
				}
			}
			else if (tmp == 0x33 || tmp == 0x34 || tmp == 0x35 || tmp == 0x36)
			{
				tmp <<= 8;
				tmp |= getchar();

				if ((tmp & 0xFF) != 0x7E)
				{
					tmp <<= 8;
					tmp |= getchar();

					if ((tmp & 0xFF) != 0x7E)
					{
						while (getchar() != 0x7E) {}
					}
				}
			}
			else
			{
				//return this code
				tmp |= 0x5B00;
			}
		}
		else if (tmp == 0x4F)
		{
			tmp = getchar();
			tmp |= 0x4F00;

			//curse for SHIFT + F1, F2, F3, or F4
			if ((tmp & 0xFF) == 0x31)
			{
				if (getchar() == 0x3B)
				{
					tmp <<= 8;
					tmp |= getchar();
					if (((tmp & 0xFF) == 0x32) || ((tmp & 0xFF) == 0x34))
					{
						tmp <<= 8;
						tmp |= getchar();
					}
				}
			}
		}
		else
		{
			//ALT + CHAR
			tmp |= 0x1B00;
		}
	}

	return tmp;
}

uint consoleTranslateKey(ulong ky)
{
	switch (ky)
	{
		case _UNIX_ConsoleKeys.KeyTab:
			return KeyTab;

		case _UNIX_ConsoleKeys.KeyLeft:
			return KeyArrowLeft;

		case _UNIX_ConsoleKeys.KeyUp:
			return KeyArrowUp;

		case _UNIX_ConsoleKeys.KeyDown:
			return KeyArrowDown;

		case _UNIX_ConsoleKeys.KeyRight:
			return KeyArrowRight;

		case _UNIX_ConsoleKeys.KeyBackspace:
			return KeyBackspace;

		case 10:
			return KeyReturn;

		default:
			return cast(uint)ky;
	}

	return 0;
}

void consoleLoop()
{
	for (;;)
	{
		//become IO bound

		ulong ky; uint tky;
		ky = consoleGetKey();
		tky = consoleTranslateKey(ky);

		if (ky < 0xfffffff) {
			ConsoleWindowOnKeyDown(tky);

			if (tky != KeyBackspace && tky != KeyArrowLeft && tky != KeyArrowRight
				&& tky != KeyArrowUp && tky != KeyArrowDown)
			{
				ConsoleWindowOnKeyChar(cast(uint)ky);
			}
        }

        /* if (m_exit)
        {
            fireEvent(EventUninitState, 0);
            break;
        } */
    }
}

void AppInit()
{
	// ------------- */

	// this code is executed at initialization of the application
	X.XInitThreads();

	_pfvars.running = true;

	//create the window

	//start the app

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

	// UTF-8 SUPPORT
//	_pfvars.wm_name = X.XInternAtom(_pfvars.display, "_NET_WM_NAME\0"c.ptr, X.Bool.True);
	setlocale(LC_CTYPE, "");

	// segfault handler
	signal(SIGSEGV, &segfault_handler);
}

int main(char[][] args)
{
	try
	{

		AppInit();

		ConsoleInit();
		DjehutyStart();

		if (Djehuty._console_inited)
		{
			consoleLoop();
		}
		else
		{
			eventLoop();
		}

		ConsoleUninit();
	}
	catch(Object o)
	{
		Debugger.raiseException(cast(Exception)o);
	}

		X.XCloseDisplay(_pfvars.display);

	return 0;
}
