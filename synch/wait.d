/*
 * wait.d
 *
 * This module implements a conditional wait object.
 *
 * Author: Dave Wilkinson
 * Originated: December 4th, 2009
 *
 */

module synch.wait;

class Wait {
	this() {
	}

	void wait(Waitable forObject) {
	}
}

interface Waitable {
}
