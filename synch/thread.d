module synch.thread;

import gui.window;

// Awww... my only runtime dependency
version(Tango) {
	import Tango = tango.core.Thread;
}
else {
	import Phobos = std.thread;
}

import platform.vars.thread;

import scaffold.thread;
import scaffold.time;

// access to exception handler
import analyzing.debugger;

// Access to the threads array
import core.main;

import io.console;

// Section: Core/Synchronization

// Description: This class represents a thread.  You can create and override the call function to use, or use a delegate to specify an external function to call.
class Thread {

	// Description: Will create a normal thread that does not have any external callback functions.
	this() {
		stdThread = new overrideThread();
		stdThread.thread = this;

		startTime = time = TimeGet();
	}

	// Description: Will create a thread using the given delegate as the callback function.
	this(void delegate(bool) callback) {
		_thread_callback = callback;
		_thread_f_callback = null;

		stdThread = new overrideThread();
		stdThread.thread = this;

		startTime = time = TimeGet();
	}

	// Description: Will create a thread using the given function as the callback function.
	this(void function(bool) callback) {
		_thread_f_callback = callback;
		_thread_callback = null;

		stdThread = new overrideThread();
		stdThread.thread = this;
	}

	~this() {
		stop();
	}

	// the common function for the thread

	// Description: This will be called upon execution of the thread.  Normally, it will call the delegate, but if overriden, you can provide a function within the class to use as the execution space.
	void run() {
		if (_thread_callback !is null) {
			_thread_callback(false);
		}
		else if (_thread_f_callback !is null) {
			_thread_f_callback(false);
		}

		_inited = false;
	}

	// Description: This will allow an arbitrary member function to be used as the execution space.
	// callback: An address to a member function or a delegate literal.
	void callback(void delegate(bool) callback) {
		_thread_callback = callback;
		_thread_f_callback = null;
	}

	// Description: This will allow an arbitrary function to be used as the execution space.
	// callback: An address to a function or a function literal.
	void callback(void function(bool) callback) {
		_thread_f_callback = callback;
		_thread_callback = null;
	}

	// Description: This function will tell whether or not the current thread being executed is the thread created via this class.
	// Returns: Will return true when this thread is the current thread executing and false otherwise.
	bool isCurrentThread() {
		if (_inited) {
			return this is getCurrent(); //return ThreadIsCurrent(_pfvars);
		}

		return false;
	}

	// Description: This function will yield the thread for a certain amount of time.
	// milliseconds: The number of milliseconds to yield.
	void sleep(ulong milliseconds) {
		// we are given a long for length, windows only has an int function
		if (_inited) {
			ThreadSleep(_pfvars, milliseconds);
		}
	}

	// Description: This function will start the thread and call the threadProc() function, which will in turn execute an external delegate if provided.
	void start() {
		if (!_inited) {
			RegisterThread(this);
			//ThreadStart(_pfvars, this);

			startTime = time = TimeGet();

			if (stdThread is null) {
				stdThread = new overrideThread();
			}

			_inited = true;
			stdThread.start();
		}
	}

	// Description: This function will stop the thread prematurely.
	void stop() {
		if (_inited) {
			//ThreadStop(_pfvars);
			stdThread = null;
			UnregisterThread(this);
		}
		_inited = false;
	}

	void pleaseStop() {
		if (_thread_callback !is null) {
			_thread_callback(true);
		}
		else if (_thread_f_callback !is null) {
			_thread_f_callback(true);
		}
	}

	uint getElapsed() {
		return TimeGet() - time;
	}

	uint getDelta() {
		uint oldTime = time;
		time = TimeGet();

		return time - oldTime;
	}

	static Thread getCurrent() {
		Thread ret;

		version(LDC) {
			if (Tango.Thread.getThis() in threadById) {
				ret = threadById[Tango.Thread.getThis()];
			}
		}
		else {
			if (Phobos.Thread.getThis() in threadById) {
				ret = threadById[Phobos.Thread.getThis()];
			}
		}

		if (ret is null) {
		}

		return ret;
	}

protected:

	void delegate (bool) _thread_callback = null;
	void function (bool) _thread_f_callback = null;

	int _threadProc() {
		run();

		stdThread = null;

		return 0;
	}

	bool _inited;

	uint startTime;
	uint time;

	Window wnd;

	ThreadPlatformVars _pfvars;

	overrideThread stdThread;

	version(GNU)
	{
	}
	version(LDC)
	{
		alias Tango.Thread RuntimeThread;
		class overrideThread : Tango.Thread
		{
			Thread thread;
			RuntimeThread runtimeThread;

			this() {
				super(&run);
			}

			void run()
			{
				threadById[Tango.Thread.getThis()] = thread;

				try {
					thread.run();
				}
				catch (Object o) {
					// Catch any unhandled exceptions
					Debugger.raiseException(cast(Exception)o, thread.wnd, thread);
				}

				stdThread = null;

				UnregisterThread(thread);

				return;
			}

			bool isSelf()
			{
				// TODO: IMPLEMENT
				return false;
			}
		}
	}
	else
	{
		alias Phobos.Thread RuntimeThread;
		class overrideThread
		{
			Thread thread;
			RuntimeThread runtimeThread;

			this() {
				runtimeThread = new Phobos.Thread(&run);
			}

			void start() {
				runtimeThread.start();
			}

			int run() {
				threadById[Phobos.Thread.getThis()] = thread;

				try {
					thread.run();
				}
				catch (Object o) {
					// Catch any unhandled exceptions
					Debugger.raiseException(cast(Exception)o, thread.wnd, thread);
				}

				stdThread = null;

				UnregisterThread(thread);

				return 0;
			}
		}
	}

	static Thread[RuntimeThread] threadById;
}

void ThreadModuleInit() {

	// create a Thread for the main thread
	Thread mainThread = new Thread();

	version(Tango) {
		mainThread.stdThread.runtimeThread = Tango.Thread.getThis();
	}
	else {
		mainThread.stdThread.runtimeThread = Phobos.Thread.getThis();
	}

	Thread.threadById[mainThread.stdThread.runtimeThread] = mainThread;
}

void ThreadUninit(ref Thread t)
{
	t._inited = false;
}

void ThreadSetWindow(ref Thread t, Window w)
{
	t.wnd = w;
}
