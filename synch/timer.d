module synch.timer;

import synch.thread;
import synch.semaphore;

import core.event;

// Section: Core/Synchronization

// Description: This class offers an abstraction to a periodic timer.  This is implemented currently as a yielding thread.
class Timer : Dispatcher {
	this() {
	}

	this(ulong interval) {
		_interval = interval;
	}

	~this() {
		stop();
	}

	// Description: This function will set the time interval to periodly call the timerProc() function.
	// milliseconds: The number of milliseconds to wait before the next timer fire.
	void interval(ulong milliseconds) {
		_interval = milliseconds;
	}

	ulong interval() {
		return _interval;
	}

	// Description: This function will start the timer.
	void start() {
		//start the thread
		if (isRunning()) {
			stop();
		}

		_thread = new timer_thread(this);

		_thread.start();
	}

	// Description: This function will stop the timer when the timerProc returns.
	void stop() {
		_thread._stop = true;
	}

	// Description: This function will return the state of the timer.
	// Returns: Will return true if the timer is currently in the running state, false otherwise.
	bool isRunning() {
		return (_thread !is null && _thread._stop == false);
	}

	// Description: This function is called on every timer fire. It's normal operation is to call the callback provided by the callback property.  One can override to provide a class based timer procedure.
	// Returns: If true is returned, the timer is stopped. Otherwise the timer will fire again after the interval depletes. Note: the time it takes to run the function is not accounted for in the interval at this time.
	bool fire() {
		return raiseSignal(0);
	}

protected:

	ulong _interval = 0;

	timer_thread _thread;
}

private class timer_thread : Thread {
	this(Timer t) {
		_timer = t;
	}

	override void run() {
		while (_stop == false) {
			sleep(_timer._interval);

			if (_stop == true) { break; }
			_timer.raiseSignal(1);

//			if (_timer.fire() == false) { break; }
		}

		_stop = true;
	}

	bool _stop;
	Timer _timer;
}


