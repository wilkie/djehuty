/*
 * exception.d
 *
 * This module defines common exceptions.
 *
 * Author: Dave Wilkinson
 * Originated: August 20th, 2009
 *
 */

module core.exception;

import core.string;
import core.definitions;

template CustomException(char[] name, char[] error, char[] error_more) {
	const char[] CustomException = `
		class `~name~` : Exception {
			this() {
				super("`~error~`");
			}

			this(String msg) {
				super("`~error~error_more~`" ~ msg.toString());
			}

			this(string msg) {
				super("`~error~error_more~`" ~ msg);
			}
		}
	`;
}

// Exceptions for file IO

mixin(CustomException!("FileNotFound", "File Not Found", ": "));

mixin(CustomException!("DirectoryNotFound", "Directory Not Found", ": "));

// Exceptions for data structures

mixin(CustomException!("OutOfElements", "Out of Elements", " in "));

mixin(CustomException!("OutOfBounds", "Out of Bounds", " in "));

mixin(CustomException!("ElementNotFound", "Element Not Found", " in "));

