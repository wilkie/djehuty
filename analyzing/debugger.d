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

import gui.window;

import core.string;
import core.unicode;
import core.definitions;

import synch.thread;

// Description: This class provides a set of functions to facilitate common
//	debugging functions and capabilities to profile code.
// Feature: Provides a method of logging all debug information to a file.
//	(Functionality)
// Feature: The log file can be easily parsed and the information easily
//	extracted. (Usability)
class Debugger
{
static:
public:

	void raiseException(Exception e, Window w = null, Thread t = null) {
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
		Console.setColor(fgColor.BrightRed);

		if (t is null) {
			Console.putln("Unhandled Main Exception: ");
		}
		else {
			Console.putln("Unhandled Thread Exception: ");
		}

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

		if (w !is null) {
			// get class name
			ClassInfo ci = w.classinfo;
			String className = new String(ci.name);

			Console.putln("    window: ", className.array, " [", w.text.array, "]");
		}

		if (t !is null) {
			// get class name
			ClassInfo ci = t.classinfo;
			String className = new String(ci.name);

			Console.putln("    thread: ", className.array);
		}

		Console.setColor(fgColor.White);
	}

	void receiver(void delegate(Exception) newDelegate) {
		_delegate = newDelegate;
	}

	void delegate(Exception) receiver() {
		return _delegate;
	}

	void raiseSignal(uint signal) {
	}

protected:

	void delegate(Exception) _delegate;
}
