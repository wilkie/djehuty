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
import core.main;
import core.filesystem;
import core.arguments;
import core.event;

import platform.imports;
mixin(PlatformScaffoldImport!());
mixin(PlatformGenericImport!("definitions"));
mixin(PlatformGenericImport!("console"));
mixin(PlatformGenericImport!("vars"));

import analyzing.debugger;

// Description: This class represents the application instance.
class Application : Responder {

	this() {
		// go by classinfo to the application name
		ClassInfo ci = this.classinfo;
		String className = new String(ci.name);

		int pos = className.findReverse(new String("."));

		if (pos > -1) {
			className = className.subString(pos+1);
		}

		if (className == "Application") {
			throw new Exception("Must inherit new instance of Application");
		}

		this(className);
	}

	this(String appName) {
		this.appName = new String(appName);
		Djehuty.setApplication(this);
	}

	this(string appName) {
		this.appName = new String(appName);
		Djehuty.setApplication(this);
	}

	// Properties //

	// Description: This function will return the name of the application, which is used to signify directory structures and executable names.
	// Returns: The application name.
	String getApplicationName() {
		return new String(appName);
	}

	// Description: This function will return true when the application being executed has been installed and is running from the installation directory.
	// Returns: Will return true when the app being ran has been installed, and false otherwise.
	bool isInstalled() {
		// return true when the executable currently being executed is
		// located in the filesystem's installed binaries directory
		return (FileSystem.getBinaryDir() == FileSystem.getApplicationDir());
	}

	void setArguments(Arguments argInstance) {
		arguments = argInstance;
	}

	Arguments getArguments() {
		return arguments;
	}

	// Overrides //

	override char[] toString() {
		return appName.toString();
	}

	// Events //

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
		DjehutyEnd(code);
	}

protected:
	String appName;
	Arguments arguments;

	override bool raiseSignal(uint signal) {
		Debugger.raiseSignal(signal);
		return false;
	}
}