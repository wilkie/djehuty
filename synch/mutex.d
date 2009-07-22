module synch.mutex;

import platform.vars.mutex;

import scaffold.thread;

// Section: Core/Synchronization

// Description: This class provides a simple mutex, also known as a binary semaphore.  This is provided as a means to manually lock critical sections.  It is initially unlocked.
class Mutex {
	this() {
		MutexInit(_pfvars);
	}

	~this() {
		MutexUninit(_pfvars);
	}

	// Description: This function will lock the mutex.  This could be used to enter a critical section.
	void lock() {
		MutexLock(_pfvars);
	}

	// Description: This function will unlock a locked mutex.  This could be used to leave a critical section.
	void unlock() {
		MutexUnlock(_pfvars);
	}

	void lock(uint milliseconds) {
		MutexLock(_pfvars, milliseconds);
	}

	MutexPlatformVars _pfvars;
}
