/*
 * error.d
 *
 * This module implements the base class for a non recoverable failure.
 *
 */

module mindrt.error;

import mindrt.exception;

// Description: This is for a non irrecoverable failure.
class Error : Exception {
	Error next;

	// Description: This will provide a descriptive message.
	this(char[] msg) {
		super(msg);
	}

	this(char[] msg, Error next) {
		super(msg);
		this.next = next;
	}
}
