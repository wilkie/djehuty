/*
 * integer.d
 *
 * This module implements a flexible integer type.
 *
 * Author: Dave Wilkinson
 * Originated: August 11th, 2009
 *
 */

module math.integer;

import core.string;

// Description: This class represents an integer value.
class Integer {
	this(long value) {
		if (value < 0) {
			value = -value;
			_negative = true;
		}
		_value = [cast(ulong)value];
	}

	char[] toString() {
		return (new String(cast(long)_value[0])).toString();
	}

private:

	ulong[] _value;
	bool _negative;
}