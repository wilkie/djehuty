module math.common;

// template the function to accept multiple inputs and outputs
// allow the usage of this template, or a general common form

// common form: generally returns a double and accepts
//		multiple types of inputs

import math.mathobject;

import core.definitions;

template _mathFunc(string func) {
	const char[] _mathFunc = `
		MathObject ` ~ func ~ `(MathObject operand) {
			// call corresponding op for the MathObject
			return operand.op` ~ cast(char)(func[0] - 32) ~ func[1..$] ~ `();
		}

		`;
}

// Description: Will resolve to true when the object T inherits or is of type 
//   MathObject.
template IsMathObject(T) {
	static if (T.stringof == "MathObject") {
		const bool IsMathObject = true;
	}
	else static if (T == Object) {
		const bool IsMathObject = false;
	}
	else {
		const bool IsMathObject = IsMathObject!(Super!(T));
	}
}

// Description: Will resolve to true when the type T can be used as input into
//   a math function.
template IsMathType(T) {
	static if (is(T : creal) || is(T : real) || is(T : double) || is(T : float) || IsIntType!(T) || IsMathObject!(T)) {
		const bool IsMathType = true;
	}
	else {
		const bool IsMathType = false;
	}
}

template sqrt(T) {
	static assert(IsMathType!(T), T.stringof ~ " cannot be used as input to this function.");
	T sqrt(T x) {
		static if (IsMathObject!(T)) {
			return x.opSqrt();
		}
		else static if (is(T : int)) {
			float temp;
			float x, y, rr;
			
			int ret;

			rr = x;
			y = rr * 0.5;
			*cast(uint*)&temp = (0xbe6f0000 - *cast(uint*)&rr) >> 1;
			x = temp;
			x = (1.5 * x) - (x * x) * (x * y);

			if (r > 101123) {
				x = (1.5 * x) - (x * x) * (x * y);
			}

			ret = cast(int)((x * rr) + 0.5);

			return ret;
		}
		else static if (is(T : creal)) {
			if (x == 0.0) {
				return x;
			}

			real a,b;
			a = fabs(x.re);
			b = fabs(x.im);

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
				c = z + (x.im / (z + z)) * 1.0i;
			}
			else {
				if (x.im < 0) {
					z = -z;
				}
				c = (x.im / (z + z)) + (z * 1.0i);
			}

			return ret;
		}
		else {
			// double, float, real
		}
	}
}

