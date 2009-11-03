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
		this();
		_interval = interval;
	}

	~this() {
		stop();
	}

	// Description: This function will set the time interval to periodly call the timerProc() function.
	// milliseconds: The number of milliseconds to wait before the next timer fire.
	void setInterval(ulong milliseconds) {
		_interval = milliseconds;
	}

	// Description: This function will start the timer.
	void start() {
		//start the thread
		if (_started) {
			stop();
		}

		_thread = new timer_thread();

		_thread._timer = this;

		_thread._inCall = new Semaphore();
		_thread._inCall.init(1);

		_started = true;

		_thread.start();
	}

	// Description: This function will stop the timer when the timerProc returns.
	void stop() {
		if (!_started) {
			return;
		}

		_thread._stop = true;
		_started = false;
	}

	// Description: This function will return the state of the timer.
	// Returns: Will return true if the timer is currently in the running state, false otherwise.
	bool isRunning() { return _started; }

	// Description: This function is called on every timer fire. It's normal operation is to call the callback provided by the setDelegate() function.  One can override to provide a class based timer procedure.
	// Returns: If true is returned, the timer is stopped. Otherwise the timer will fire again after the interval depletes. Note: the time it takes to run the function is not accounted for in the interval at this time.
	bool fire() {
		return raiseSignal(0);
	}

protected:

	class timer_thread : Thread {
		this() {
		}

		override void pleaseStop() {
			if (!_stop) {
				_timer.stop();
			}
			_stop = true;
		}
		
		override void stop() {
			pleaseStop();
			super.stop();
		}

		override void run() {
			while (!_stop) {
				sleep(_timer._interval);

				_inCall.down();
				if (_stop || !_inited) { break; }
				if (_timer.fire() == false) { break; }
				_inCall.up();
			}

			_stop = true;
			_inCall.up();
		}

		bool _stop;
		Timer _timer;
		Semaphore _inCall;
	}

	bool _started = false;
	ulong _interval = 0;

	timer_thread _thread;
}

