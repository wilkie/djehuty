/*
 * abs.d
 *
 * This module implements the absolute value function.
 *
 */

module math.abs;

import math.mathobject;

template abs(T) {
	T abs(T x) {
		static if (IsMathObject!(T)) {
			return x.opAbs();
		}
		else static if (is(T == float)) {
			uint intRepresentation = *cast(uint*)&x;
			intRepresentation &= 0x7fff_ffff;
			return *cast(float*)&intRepresentation;
		}
		else static if (is(T == double)) {
			ulong intRepresentation = *cast(ulong*)&x;
			intRepresentation &= 0x7fff_ffff_ffff_ffff;
			return *cast(double*)&intRepresentation;
		}
		else static if (is(T : long)) {
			if (x < 0) {
				return -x;
			}
			return x;
		}
		else {
			static assert(false, "Math function abs not defined for type " ~ T.stringof);
		}
	}
}
