module core.debugger;

import console.main;

import core.basewindow;
import core.string;
import core.unicode;
import core.thread;

// Section: Core

// Description: This class provides a set of functions to facilitate common debugging functions and capabilities to profile code.
// Feature: Provides a method to profile code timing. (Functionality)
// Feature: Provides a method of logging all debug information to a file. (Functionality)
// Feature: The log file can be easily parsed and the information easily extracted. (Usability)
class Debugger
{
static:
public:

	void raiseException(Exception e, BaseWindow w = null, Thread t = null)
	{
		if (_delegate !is null)
		{
			_delegate(e);
		}
		else
		{
			Console.setColor(fgColor.BrightRed);
			if (t is null)
			{
				Console.putln("Unhandled Main Exception: ", e.toString());
			}
			else
			{
				Console.putln("Unhandled Thread Exception: ", e.toString());
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
	}

	void setDelegate(void delegate(Exception) newDelegate)
	{
		_delegate = newDelegate;
	}

protected:

	void delegate(Exception) _delegate;
}