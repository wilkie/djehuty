/*
 * main.d
 *
 * This file contains the main logic and the main class for handling
 * an Application.
 *
 * Author: Dave Wilkinson
 *
 */

module core.main;

import core.basewindow;
import core.window;
import core.string;
import core.thread;
import core.arguments;
import core.filesystem;
import core.application;
import core.semaphore;

import console.window;
import console.main;

import platform.imports;
mixin(PlatformScaffoldImport!());
mixin(PlatformGenericImport!("definitions"));
mixin(PlatformGenericImport!("console"));
mixin(PlatformGenericImport!("vars"));

void DjehutyStart() {
	// Can only start the framework once
	if (!Djehuty._hasStarted) {
		Djehuty._hasStarted = true;
	}
	else {
		throw new Exception("Framework Already Started");
	}

	// Check to make sure the app provided a suitable class to use
	if (Djehuty.app is null) {
	//	throw new Exception("No Application Class");
	}
	else
	{
		Djehuty.app.setArguments(Arguments.getInstance());
		Djehuty.app.OnApplicationStart();
	}

	// Start the application proper (from platform's point of view)
	Scaffold.AppStart();

	// If no event controllers are in play, then end
	if (Djehuty._windowCount == 0 && Djehuty._console_inited == false) {
		DjehutyEnd();
	}
}

void DjehutyEnd() {
	// Tell all running threads that they should end to allow shutdown to commense
	if (Djehuty._threads !is null) {
		Djehuty._threadRegisterSemaphore.down();

		foreach(th; Djehuty._threads) {
			th.pleaseStop();
		}

		Djehuty._threadRegisterSemaphore.up();
	}

	// End the application proper (from the platform's point of view)
	Scaffold.AppEnd();
}

// Section: Core

// Description: This class is the main class for the framework. It provides base functionality.
class Djehuty {
	static:
	public:

		// Description: Will add and create the window (as long as it hasn't been already) and add it to the root window hierarchy.
		// window: An instance of a BaseWindow class, or any the inherit from BaseWindow.
		void addWindow(BaseWindow window) {
			WindowPlatformVars* wpv = WindowGetPlatformVars(window);

			synchronized {
				// update the window linked list
				UpdateWindowList(window);

				// increase global window count
				_windowCount++;

				// create the window through platform calls
				Scaffold.WindowCreate(window, wpv);
			}

			if (window.getVisibility()) {
				Scaffold.WindowSetVisible(window, wpv, true);
			}
		}

		void setApplication(Application application) {
			if (app !is null) {
				throw new Exception("Application Already Spawned");
			}

			app = application;
		}

	private:
		BaseWindow _windowListHead = null;
		BaseWindow _windowListTail = null;

		int _windowCount;
		int _windowVisibleCount;

		bool _console_inited = false;

		bool _hasStarted = false;

		Thread[] _threads;

		Semaphore _threadRegisterSemaphore;

		Application app;
}

void RegisterThread(ref Thread thread)
{
	if (Djehuty._threadRegisterSemaphore is null) {
		Djehuty._threadRegisterSemaphore = new Semaphore(1);
	}

	Djehuty._threadRegisterSemaphore.down();
	Djehuty._threads ~= thread;
	Djehuty._threadRegisterSemaphore.up();
}

void UnregisterThread(ref Thread thread)
{
	Djehuty._threadRegisterSemaphore.down();

	if (Djehuty._threads !is null) {
		foreach(i, th; Djehuty._threads) {
			if (th is thread) {
				if (Djehuty._threads.length == 1) {
					Djehuty._threads = null;
				}
				else if (i >= Djehuty._threads.length - 1) {
					Djehuty._threads = Djehuty._threads[0..i];
				}
				else {
					Djehuty._threads = Djehuty._threads[0..i] ~ Djehuty._threads[i+1..$];
				}
				break;
			}
		}
	}

	Djehuty._threadRegisterSemaphore.up();
}
