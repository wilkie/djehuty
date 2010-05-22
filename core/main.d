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
import core.color;

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
		// Reset colors to something sane
		Console.forecolor = Color.White;
		Console.backcolor = Color.Black;
		if (app !is null) {
			app.onApplicationEnd();
			app.onPostApplicationEnd(code);
		}
	}

	bool _hasStarted = false;

	Application app;
}
