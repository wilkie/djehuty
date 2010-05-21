/*
 * exception.d
 *
 * This module implements the Exception base class and the runtime functions.
 *
 */

module runtime.exception;

import core.exception;

extern(C):

// Description: This function will carefully throw an out of memory exception.
void onOutOfMemoryError() {
	// Throw this without allocation
	throw cast(MemoryException.OutOfMemory)cast(void*)MemoryException.OutOfMemory.classinfo.init;
}

void _d_throw_exception(Object e) {
}
