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

	// Check to make sure the app provided a suitable name
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
	foreach(th; Djehuty._threads) {
		th.pleaseStop();
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

		// Description: Will initialize the console and set the current console window to be the one specified.
		// window: An instance of a ConsoleWindow class that will set up a context and replace any that had previously been set.
		void setConsoleWindow(ConsoleWindow window) {
			if (!_console_inited) {
				//ConsoleInit();

				_console_inited = true;
			}

			_curConsoleWindow = window;

			// Draw Window
			ConsoleWindowOnSet(_curConsoleWindow);
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

		ConsoleWindow _curConsoleWindow;

		bool _hasStarted = false;

		Thread[] _threads;

		Application app;
}

void RegisterThread(ref Thread thread)
{
	Djehuty._threads ~= thread;
}

void UnregisterThread(ref Thread thread)
{
	synchronized
	{
		foreach(i,th; Djehuty._threads)
		{
			if (th is thread)
			{
				Djehuty._threads = Djehuty._threads[0..i] ~ Djehuty._threads[i+1..$];
			}
		}
	}
}
