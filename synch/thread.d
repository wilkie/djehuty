module synch.thread;

import platform.vars.thread;

import scaffold.thread;

// access to exception handler
import analyzing.debugger;

// Access to the threads array
import core.main;
import core.system;

import io.console;

// Section: Core/Synchronization

// Description: This class represents a thread.  You can create and override the call function to use, or use a delegate to specify an external function to call.
class Thread {
private:

	void end() {
		threadById[_id] = null;
		_inited = false;
	}

	void delegate (bool) _thread_callback = null;
	void function (bool) _thread_f_callback = null;

	bool _inited;
	int _id;

	long startTime;
	long time;

	ThreadPlatformVars _pfvars;

	static Thread[uint] threadById;
	// Description: Will create a normal thread that does not have any external callback functions.

public:
	this() {
		// Check for creating thread
		Thread callee = Thread.current();

		if (callee is null) {
			// We do not know this thread... add it
			threadById[ThreadIdentifier()] = this;
		}

		startTime = time = System.time;
	}

	// Description: Will create a thread using the given delegate as the callback function.
	this(void delegate(bool) callback) {
		_thread_callback = callback;
		_thread_f_callback = null;

		startTime = time = System.time;
	}

	// Description: Will create a thread using the given function as the callback function.
	this(void function(bool) callback) {
		_thread_f_callback = callback;
		_thread_callback = null;

		startTime = time = System.time;
	}

	~this() {
		stop();
	}

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

	// Description: This function will yield the thread for a certain amount of time.
	// milliseconds: The number of milliseconds to yield.
	static void sleep(ulong milliseconds) {
		// we are given a long for length, windows only has an int function
		ThreadSleep(milliseconds);
	}

	// Description: This function will yield the thread.
	static void yield() {
		ThreadYield();
	}

	// Description: This function will start the thread and call the threadProc() function, which will in turn execute an external delegate if provided.
	void start() {
		if (!_inited) {
			_inited = true;
			_id = ThreadStart(_pfvars, this, &end);
			threadById[_id] = this;

			startTime = time = System.time;
		}
	}

	// Description: This function will stop the thread prematurely.
	void stop() {
		if (_inited) {
			ThreadStop(_pfvars);
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

	long getElapsed() {
		return System.time - time;
	}

	long getDelta() {
		long oldTime = time;
		time = System.time;

		return time - oldTime;
	}

	static Thread current() {
		Thread ret;

		uint curID = ThreadIdentifier();

		if (curID in threadById) {
			return threadById[curID];
		}

		return null;
	}
}
