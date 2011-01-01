module synch.mutex;

import platform.vars.mutex;

import synch.condition;
import synch.semaphore;
import synch.thread;
import synch.atomic;

import scaffold.thread;

// Section: Core/Synchronization

// Description: This class provides a simple mutex, also known as a binary semaphore.  This is provided as a means to manually lock critical sections.  It is initially unlocked.
class Mutex {
private:
	Semaphore _lock = null;

	Thread _owner = null;
	long _count = 0;

public:

	this() {
		_lock = new Semaphore(1);
	}

	~this() {
	}

	// Description: This function will lock the mutex.  This could be used to enter a critical section.
	void lock() {
		if (_owner !is Thread.current) {
			_lock.down();
			_owner = Thread.current;
			_count = 1;
		}
		else {
			_count++;
		}
	}

	// Description: This function will unlock a locked mutex.  This could be used to leave a critical section.
	void unlock() {
		if (_owner !is Thread.current) {
			return;
		}

		_count--;

		if (_count == 0) {
			_owner = null;
			_lock.up();
		}
	}

	bool hasLock() {
		return _owner is Thread.current;
	}

	long depth() {
		return _count;
	}

	void lock(uint milliseconds) {
		if (_owner !is Thread.current) {
			_lock.down(milliseconds);
			_owner = Thread.current;
			_count = 1;
		}
		else {
			_count++;
		}
	}

	void wait(Condition cond) {
	}

	void wait(Waitable forObject) {
		wait(forObject.waitCondition());
	}
}
