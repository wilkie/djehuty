/*
 * debugger.d
 *
 * This file contains the exception sink and other helpful debugging routines.
 *
 * Author: Dave Wilkinson
 *
 */

module analyzing.debugger;

import io.console;

import djehuty;

import synch.thread;

// Description: This class provides a set of functions to facilitate common
//	debugging functions and capabilities to profile code.
// Feature: Provides a method of logging all debug information to a file.
//	(Functionality)
// Feature: The log file can be easily parsed and the information easily
//	extracted. (Usability)
class Debugger {
static:
protected:

	void delegate(Exception) _delegate;

public:

	void raiseException(Exception e) {
		if (_delegate !is null) {
			// Wouldn't it be ridiculous if the handler threw an exception?
			try {
				_delegate(e);
				return;
			}
			catch(Exception exp) {
				// no chance for the handler to be reentered in this case
				e = exp;
			}
		}

		Console.putln("");
		Console.forecolor = Color.Red;

		string cause = e.toString();
		if (cause == "null this") {
			cause = "Null Pointer Exception";
		}

		Console.putln("    cause: ", cause);

		version(LDC) {
			// Tango provides a traceback for us
			Console.putln("    file: ", e.file, " : ", e.line);
		}
		else {
		}

		Console.forecolor = Color.White;
	}

	void receiver(void delegate(Exception) newDelegate) {
		_delegate = newDelegate;
	}

	void delegate(Exception) receiver() {
		return _delegate;
	}

	void raiseSignal(uint signal) {
	}
}
