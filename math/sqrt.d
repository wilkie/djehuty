/*
 * sqrt.d
 *
 * This module implements the square root function.
 *
 */

module math.sqrt;

import math.mathobject;
import math.abs;

template sqrt(T) {
	static assert(IsMathType!(T), T.stringof ~ " cannot be used as input to this function.");
	T sqrt(T x) {
		static if (IsMathObject!(T)) {
			return x.opSqrt();
		}
		else static if (is(T : int)) {
			float temp;
			float z, y, rr;
			
			int ret;

			rr = x;
			y = rr * 0.5;
			*cast(uint*)&temp = (0xbe6f0000 - *cast(uint*)&rr) >> 1;
			z = temp;
			z = (1.5 * z) - (z * z) * (z * y);

			// Do another round for extra precision
			if (x > 101123) {
				z = (1.5 * z) - (z * z) * (z * y);
			}

			ret = cast(int)((z * rr) + 0.5);
			ret += (x - (ret * ret)) >> 31;

			return ret;
		}
		else static if (is(T : creal)) {
			if (x == 0.0) {
				return x;
			}

			real a,b;
			a = abs(x.re);
			b = abs(x.im);

			real y,z;
			if (a >= b) {
				y = b / a;
				y *= y;
				z = 1 + sqrt(1+y);
				z *= 0.5;
				z = sqrt(z);
				z *= sqrt(a);
			}
			else {
				y = a / b;
				z = sqrt(1 + (y*y));
				z += y;
				z = sqrt(0.5 * z);
				z *= sqrt(b);
			}

			creal ret;
			if (z.re >= 0) {
				ret = z + (x.im / (z + z)) * 1.0i;
			}
			else {
				if (x.im < 0) {
					z = -z;
				}
				ret = (x.im / (z + z)) + (z * 1.0i);
			}

			return ret;
		}
		else {
			double y, z, temp;

			temp = x;
			uint* ptr = (cast(uint*)&temp) + 1;

			// Use an estimate for 1 / sqrt(x)
			*ptr = (0xbfcdd90a - *ptr) >> 1;

			y = temp;

			// Newton Approximation
			z = x * 0.5;	// 1/2

			// 5 iterations are enough for 64 bits
			y = (1.5 * y) - (y*y) * (y*z);
			y = (1.5 * y) - (y*y) * (y*z);
			y = (1.5 * y) - (y*y) * (y*z);
			y = (1.5 * y) - (y*y) * (y*z);
			y = (1.5 * y) - (y*y) * (y*z);

			// Return the result
			return x * y;
		}
	}
}

template somefunc(T) {
	static assert(IsMathType!(T), T.stringof ~ " cannot be used as input to this function.");
	T somefunc(T x) {
		static if (IsMathObject!(T)) {
			return x.opCos();
		}
		else static if (is(T : int)) {
		}
		else static if (is(T : creal)) {
		}
		else {
			T ret;
			return ret;
		}
	}
}

