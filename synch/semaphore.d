module synch.semaphore;

import scaffold.thread;

import platform.vars.semaphore;

import core.definitions;
import binding.c;

// Section: Core/Synchronization

// Description: This class abstracts a counting semaphore.
class Semaphore {

	~this() {
		if (_inited) {
			SemaphoreUninit(_pfvars);
		}
	}

	// Description: Creates an uninitialized semaphore.
	this() {
	}

	// Description: Creates and initializes a semaphore.
	// initialValue: The initial count for the semaphore.
	this(uint initialValue) {
		initialize(initialValue);
	}

	// Description: This function will initialize a semaphore and set it to an initial count.
	// initialValue: The initial count for the semaphore.
	void initialize(uint initialValue) {
		SemaphoreInit(_pfvars, initialValue);
		_inited = true;
	}

	// Description: This function will increment the count of the semaphore.
	void up() {
		SemaphoreUp(_pfvars);
	}

	// Description: This function will decrement the count of the semaphore as long as the count is greater than 0.  If not, it will yield the thread until the count is incremented via an up() call.  This is the blocking call of the semaphore.
	void down() {
		SemaphoreDown(_pfvars);
	}

	// Description: This function will decrement the count of the semaphore as long as the count is greater than 0.  If not, it will yield the thread until the count is incremented via an up() call.  This is the blocking call of the semaphore, but it will only block for as long as it is specified and will continue once there is a timeout.
	// milliseconds: The amount of time to block before continuing if the semaphore should have a count of zero.
	void down(uint milliseconds) {
		SemaphoreDown(_pfvars, milliseconds);
	}

protected:

	SemaphorePlatformVars _pfvars;
	bool _inited = false;
}
