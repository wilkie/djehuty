/*
 * application.d
 *
 * This module implements a console application class.
 *
 * Author: Dave Wilkinson
 * Originated: June 9th 2009
 *
 */

module console.application;

import core.application;
import core.string;
import core.main;

import console.window;

class ConsoleApplication : Application {

	this() {
		super();
	}

	this(String appName) {
		super(appName);
	}

	this(StringLiteral appName) {
		super(appName);
	}

	// Description: Will initialize the console and set the current console window to be the one specified.
	// window: An instance of a ConsoleWindow class that will set up a context and replace any that had previously been set.
	void setConsoleWindow(ConsoleWindow window) {
		if (!Djehuty._console_inited) {
			//ConsoleInit();

			Djehuty._console_inited = true;
		}

		_curConsoleWindow = window;

		// Draw Window
		ConsoleWindowOnSet(_curConsoleWindow);
	}
	
	ConsoleWindow getConsoleWindow() {
		return _curConsoleWindow;
	}

protected:
	ConsoleWindow _curConsoleWindow;
}