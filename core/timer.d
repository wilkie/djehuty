module core.timer;

import core.thread;
import core.semaphore;

// Section: Core/Synchronization

// Description: This class offers an abstraction to a periodic timer.  This is implemented currently as a yielding thread.
class Timer
{

public:

	this()
	{
		_thread = new timer_thread();
	}

	~this()
	{
		stop();
	}

	// Description: This function will set the time interval to periodly call the timerProc() function.
	// milliseconds: The number of milliseconds to wait before the next timer fire.
	void setInterval(ulong milliseconds)
	{
		_interval = milliseconds;
	}

	// Description: This function will set the callback for the timer to a member function.
	// callback: The address of a member function or a delegate literal.
	void setDelegate(bool delegate(Timer) callback)
	{
		_callback = callback;
	}

	// Description: This function will set the callback for the timer to a member function.
	// callback: The address of a member function or a delegate literal.
	void setDelegate(bool function(Timer) callback)
	{
		_fcallback = callback;
	}

	// Description: This function will start the timer.
	void start()
	{
		//start the thread
		if (_started) { stop(); }

		_thread._timer = this;

		_thread._inCall = new Semaphore();
		_thread._inCall.init(1);

		_started = true;

		_thread.start();
	}

	// Description: This function will stop the timer when the timerProc returns.
	void stop()
	{
		if (!_started) { return; }

		_started = false;
	}

	// Description: This function will return the state of the timer.
	// Returns: Will return true if the timer is currently in the running state, false otherwise.
	bool isRunning() { return _started; }

	// Description: This function is called on every timer fire. It's normal operation is to call the callback provided by the setDelegate() function.  One can override to provide a class based timer procedure.
	// Returns: If true is returned, the timer is stopped. Otherwise the timer will fire again after the interval depletes. Note: the time it takes to run the function is not accounted for in the interval at this time.
	bool fire()
	{
		if (_callback !is null){
			return _callback(this);
		}

		if (_fcallback !is null){
			return _fcallback(this);
		}

		return false;
	}


protected:

	class timer_thread : Thread
	{
	public:

		this()
		{
		}

		override void run()
		{
			while (_timer._started)
			{
				sleep(_timer._interval);

				if (!_timer._started) { break; }
				_inCall.down();
				if (_timer.fire() == false) { break; }
				_inCall.up();
				if (!_timer._started) { break; }
			}
			_timer._started = false;
		}


		Timer _timer;
		Semaphore _inCall;
	};

	bool delegate (Timer) _callback = null;
	bool function (Timer) _fcallback = null;

	bool _started = false;
	ulong _interval = 0;

	timer_thread _thread;
}

