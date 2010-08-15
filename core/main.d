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

import io.console;

import core.string;
import core.arguments;
import core.application;
import core.locale;
import core.system;
import core.color;

import synch.semaphore;
import synch.thread;

// Section: Core

// Description: This class is the main class for the framework. It provides base functionality.
class Djehuty {
static:
private:

	bool _hasStarted = false;

	Application _app;

public:

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
		if (_app is null) {
			throw new Exception("No Application Class");
		}
	}

	void application(Application application) {
		if (_app !is null) {
			throw new Exception("Application Already Spawned");
		}

		_app = application;
	}

	Application application() {
		return _app;
	}
}
