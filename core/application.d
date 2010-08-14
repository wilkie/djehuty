/*
 * application.d
 *
 * This file contains the logic behind the main Application class.
 *
 * Author: Dave Wilkinson
 * Originated: May 20th, 2009
 *
 */

module core.application;

import core.string;
import core.unicode;
import core.system;
import core.main;
import core.arguments;
import core.signal;
import core.definitions;
import core.color;

import platform.application;

import io.console;

import analyzing.debugger;

// Description: This class represents the application instance.
class Application : Responder {
private:
	string _appName;
	Arguments _arguments;

	override bool raiseSignal(uint signal) {
		Debugger.raiseSignal(signal);
		return false;
	}

	ApplicationController _platformAppController;

public:
	this() {
		// go by classinfo to the application name
		ClassInfo ci = this.classinfo;
		string className = ci.name.dup;

		string[] foo = split(className, '.');

		className = foo[$-1];

		this(className);
	}

	this(string appName) {
		this._appName = appName.dup;
		Djehuty.application = this;
	}

	// Properties //

	// Description: This function will return the name of the application, which is used to signify directory structures and executable names.
	// Returns: The application name.
	string name() {
		return _appName.dup;
	}

	// Description: This function will return true when the application being executed has been installed and is running from the installation directory.
	// Returns: Will return true when the app being ran has been installed, and false otherwise.
	bool isInstalled() {
		// return true when the executable currently being executed is
		// located in the filesystem's installed binaries directory
		return (System.FileSystem.binaryDir() == System.FileSystem.applicationDir());
	}

	void arguments(Arguments argInstance) {
		_arguments = argInstance;
	}

	Arguments arguments() {
		return _arguments;
	}

	// Overrides //

	override char[] toString() {
		return _appName;
	}

	// Events //
	void run() {
		static bool _run = false;
		if (!_run) {
			Djehuty.start();

			_platformAppController = ApplicationController.instance;
			_platformAppController.start();

			onApplicationStart();

			_run = true;
			
			// If no event controllers are in play, then end
			if (isZombie) {
				exit(_platformAppController.exitCode);
			}
		}
	}

	// Description: This event will be fired when the application has
	//	finished loading.
	void onApplicationStart() {
	}

	// Description: This event will be fired when the application is about
	//	to close.
	void onApplicationEnd() {
	}

	// Description: Detects whether or not the application is a Zombie app;
	//	that is, whether or not it is in a state of no improvement and is
	//	merely sucking up resources.
	bool isZombie() {
		return true;
	}

	void exit(uint code) {
		// Reset colors to something sane
		Console.forecolor = Color.White;
		Console.backcolor = Color.Black;

		onApplicationEnd();

		if (_platformAppController !is null) {
			_platformAppController.exitCode = code;
			_platformAppController.end();
		}
	}
}
