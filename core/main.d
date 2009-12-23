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

import core.string;
import core.arguments;
import core.application;
import core.locale;
import core.system;

import io.console;

import synch.semaphore;
import synch.thread;

import gui.apploop;

// Section: Core

// Description: This class is the main class for the framework. It provides base functionality.
class Djehuty {
static:
public:

	void application(Application application) {
		if (app !is null) {
			throw new Exception("Application Already Spawned");
		}

		app = application;
	}

	Application application() {
		return app;
	}

package:

	void start() {
		// Get default locale
		Locale.id = System.Locale.id;
		
		// Allow console output
		Console.unlock();

		// Can only start the framework once
		if (!_hasStarted) {
			_hasStarted = true;
		}
		else {
			throw new Exception("Framework Already Started");
		}

		// Constitute the main thread class
		ThreadModuleInit();

		// Check to make sure the app provided a suitable class to use
		if (app is null) {
			throw new Exception("No Application Class");
		}
		else {
			app.onPreApplicationStart();
			app.onApplicationStart();
		}
	}

	void end(uint code = 0) {
		// Tell all running threads that they should end to allow shutdown to commense
		if (_threads !is null) {
			_threadRegisterSemaphore.down();

			foreach(th; _threads) {
				th.pleaseStop();
			}

			_threadRegisterSemaphore.up();
		}

		// Reset colors to something sane
		Console.setColor(fgColor.White, bgColor.Black);
		if (app !is null) {
			app.onApplicationEnd();
			app.onPostApplicationEnd(code);
		}
	}

	bool _hasStarted = false;

	Thread[] _threads;

	Semaphore _threadRegisterSemaphore;

	Application app;
}

void RegisterThread(ref Thread thread) {
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
