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

import core.window;
import core.string;
import core.arguments;
import core.filesystem;
import core.application;

import synch.semaphore;
import synch.thread;

import console.main;

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
		throw new Exception("No Application Class");
	}
	else
	{
		Djehuty.app.setArguments(Arguments.getInstance());
		Djehuty.app.OnApplicationStart();
	}

	// Start the application proper (from platform's point of view)
	Scaffold.AppStart();

	// If no event controllers are in play, then end
	if (Djehuty.app.isZombie() && Djehuty._console_inited == false) {
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
	
	Djehuty.app.OnApplicationEnd();

	// End the application proper (from the platform's point of view)
	Scaffold.AppEnd();

	Console.setColor(fgColor.White, bgColor.Black);
}

// Section: Core

// Description: This class is the main class for the framework. It provides base functionality.
class Djehuty {
	static:
	public:

	void setApplication(Application application) {
		if (app !is null) {
			throw new Exception("Application Already Spawned");
		}

		app = application;
	}

	private:
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
