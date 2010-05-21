/*
 * error.d
 *
 * This module implements the base class for a non recoverable failure.
 *
 */

module runtime.error;

import core.definitions;
import core.exception;

// Description: This is called when an assertion without a message fails.
// file: The file that contains the error.
// line: The line number of the error.
void _d_assert(string file, uint line ) {
	throw new RuntimeError.Assert(file,line);
}

// Description: This is called when an assertion fails with a message.
// msg: The message associated with the assert.
// file: The file that contains the error.
// line: The line number of the error.
void _d_assert_msg(string msg, string file, uint line ) {
	throw new RuntimeError.Assert(msg, file, line);
}

// Description: This is called when an array bounds check fails.
// file: The file that contains the error.
// line: The line number of the error.
void _d_array_bounds(string file, uint line ) {
	throw new DataException.OutOfBounds("Array");
}

// Description: This is called when there is no valid case for the switch.
// file: The file that contains the error.
// line: The line number of the error.
void _d_switch_error(string file, uint line ) {
	throw RuntimeError.NoDefaultCase(file, line);
}
