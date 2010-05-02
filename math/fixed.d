/*
 * fixed.d
 *
 * This module implements a fixed point type.
 *
 * Author: Dave Wilkinson
 * Originated: August 11th, 2009
 *
 */

module math.fixed;

import djehuty;

// Description: This class provides a fixed point arithmetic type.
class Fixed {

	this(long whole, long scale) {
		_whole = whole;
		_scale = scale;
	}

	this(double value) {
		string val = toStr(value);
		int pos = val.find(".");

		if (pos >= 0) {
			_scale = val.length - pos - 1;
			val = val[0..pos] ~ val[pos+1..$];
		}
		else {
			if (val == "inf" || val == "nan") {
				throw new Exception("Invalid Input");
			}
			_scale = 0;
		}

		val.nextInt(_whole);
	}

	// Operator Overloads

	Fixed opAdd(Fixed fixed) {
		Fixed ret = new Fixed(_whole, _scale);
		ret += fixed;
		return ret;
	}

	void opAddAssign(Fixed fixed) {
		while(fixed._scale > _scale) {
			_whole *= 10;
			_scale++;
		}

		long operand_whole = fixed._whole;
		long operand_scale = fixed._scale;
		while(_scale > operand_scale) {
			operand_whole *= 10;
			operand_scale++;
		}

		_whole += operand_whole;
	}

	string toString() {
		string ret;
		string part = toStr(_whole);

		if (part.length <= _scale) {
			ret = "0.";
			ret ~= part;
		}
		else {
			ret = part[0..cast(size_t)(part.length - _scale)].dup;
			ret ~= ".";
			ret ~= part[cast(size_t)(part.length - _scale)..part.length];
		}

		return ret;
	}

	Fixed opSub(Fixed fixed) {
		Fixed ret = new Fixed(_whole, _scale);
		ret -= fixed;
		return ret;
	}

	void opSubAssign(Fixed fixed) {
		while(fixed._scale > _scale) {
			_whole *= 10;
			_scale++;
		}

		long operand_whole = fixed._whole;
		long operand_scale = fixed._scale;
		while(_scale > operand_scale) {
			operand_whole *= 10;
			operand_scale++;
		}

		_whole -= operand_whole;
	}

	Fixed opMul(Fixed fixed) {
		Fixed ret = new Fixed(_whole, _scale);
		ret *= fixed;
		return ret;
	}

	void opMulAssign(Fixed fixed) {
		_whole *= fixed._whole;
		_scale += fixed._scale;
	}

	Fixed opDiv(Fixed fixed) {
		Fixed ret = new Fixed(_whole, _scale);
		ret /= fixed;
		return ret;
	}

	void opDivAssign(Fixed fixed) {
		long argmax_scale = _scale;

		if (fixed._scale > _scale) {
			argmax_scale = fixed._scale;
		}

		long argmax_scale_sq = argmax_scale * argmax_scale;
		argmax_scale_sq *= 2;

		_scale = argmax_scale_sq;
		
		while (argmax_scale_sq > 0) {
			_whole *= 10;
			argmax_scale_sq--;
		}
		_whole /= fixed._whole;
	}

protected:
	long _whole;
	long _scale;
}
