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
import core.definitions;

// Description: This class represents an integer value.
class Integer {
	this() {
		_value = [0];
	}

	this(ulong value, ulong[] values...) {
		_value = values.reverse ~ [value];
	}

	this(Integer i) {
		_value = i._value.dup;
		_negative = i._negative;
	}

	Integer opAdd(Integer i) {
		Integer ret = new Integer(this);
		ret += i;
		return ret;
	}

	Integer opAdd(long i) {
		Integer ret = new Integer(this);
		ret += i;
		return ret;
	}
	
	void add(Integer i, bool suppressCarry = false) {
		uint idx;
		ulong sum;
		bool carry;
		for ( ; idx < _value.length; idx++) {
			if (idx >= i._value.length) {
				sum = _value[idx];
			}
			else {
				sum = _value[idx] + i._value[idx];
			}

			if (carry) {
				sum++;
				carry = false;
			}

			if (sum < _value[idx]) {
				// overflow
				carry = true;
			}

			_value[idx] = sum;
		}

		for ( ; idx < i._value.length; idx++) {
			sum = i._value[idx];

			if (carry) {
				sum++;
				carry = false;
			}

			if (sum < i._value[idx]) {
				// overflow
				carry = true;
			}

			_value ~= [sum];
		}

		if (carry && !suppressCarry) {
			_value ~= [1];
		}
	}

	void opAddAssign(Integer i) {
		add(i);
	}

	void opAddAssign(long i) {
		bool carry;

		if (_value.length == 0) {
			_value = [i];
			return;
		}

		foreach (size_t idx, value; _value) {
			ulong newValue = value + i;
			if (newValue < value) {
				_value[idx] = newValue;
				carry = true;
				return;
			}
			_value[idx] = newValue;
		}

		if (carry) {
			_value ~= [1];
		}
	}

	Integer opSub(Integer i) {
		Integer ret = new Integer(this);
		ret -= i;
		return ret;
	}

	void opSubAssign(Integer i) {
		// two's complement
		i = ~i;
		i += 1;

		// add
		add(i, true);
	}

	Integer opCom() {
		Integer ret = new Integer(this);
		foreach(ref value; ret._value) {
			value = ~value;
		}
		return ret;
	}

	Integer opNeg() {
		Integer ret = new Integer(this);
		ret = ~ret;
		ret += 1;
		return ret;
	}

	size_t length() {
		if (_value.length == 0) {
			return 0;
		}
		return cast(size_t)((_value.length * 64) - (64 - _bitoffset));
	}

	string toString() {
		string ret;
		foreach_reverse(value; _value) {
			string section = "{x}".format(value);
			int zeroLength = 16 - section.length;
			if (ret !is null) {
				ret ~= "0000000000000000"c[0..zeroLength];
			}
			ret ~= section;
		}
		return ret;
	}

private:

	ulong[] _value;
	ulong _bitoffset;
	bool _negative;
}
