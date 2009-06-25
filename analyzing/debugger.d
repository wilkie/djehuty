/*
 * debugger.d
 *
 * This file contains the exception sink and other helpful debugging routines.
 *
 * Author: Dave Wilkinson
 *
 */

module analyzing.debugger;

import console.main;

import gui.window;

import core.string;
import core.unicode;

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

	void raiseException(Exception e, Window w = null, Thread t = null)
	{
		if (_delegate !is null)
		{
			// Wouldn't it be ridiculous if the handler threw an exception?
			try
			{
				_delegate(e);
				return;
			}
			catch(Exception exp)
			{
				// no chance for the handler to be reentered in this case
				e = exp;
			}
		}

		Console.setColor(fgColor.BrightRed);
		if (t is null)
		{
			Console.putln("Unhandled Main Exception: ", e.toString());
		}
		else
		{
			Console.putln("Unhandled Thread Exception: ", e.toString());
		}

		version(LDC)
		{
			// Tango provides a traceback for us
			Console.putln("    from file: ", e.file);
		}
		else
		{
		}

		if (w !is null)
		{
			// get class name
			ClassInfo ci = w.classinfo;
			String className = new String(Unicode.toNative(ci.name));

			Console.putln("    from window: ", className.array, " [", w.getText().array, "]");
		}
		if (t !is null)
		{
			// get class name
			ClassInfo ci = t.classinfo;
			String className = new String(Unicode.toNative(ci.name));

			Console.putln("    from thread: ", className.array);
		}

		Console.setColor(fgColor.White);
	}

	void setDelegate(void delegate(Exception) newDelegate)
	{
		_delegate = newDelegate;
	}

	void raiseSignal(uint signal) {
	}

protected:

	void delegate(Exception) _delegate;
}