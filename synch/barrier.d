/*
 * barrier.d
 *
 * This module implements a barrier synchronization object.
 *
 * Author: Dave Wilkinson
 * Originated: December 4th, 2009
 *
 */

module synch.barrier;

class Barrier {
	this(uint reportsRequired) {
		_reportsNeeded = reportsRequired;
	}

	// Description: This function will report one task, and if the barrier has received as many reports as the threshold it will return.
	void report() {
		synchronized(this) {
			_reportsIn++;
			if (_reportsIn >= _reportsNeeded) {
				return;
			}
		}

		// XXX: Reimplement with a conditional wait
		while(_reportsIn >= _reportsNeeded) {
		}
	}

protected:

	uint _reportsIn;
	uint _reportsNeeded;
}
