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

mixin(_mathFunc!("sqrt"));

// Abstract standard library (silliness)
version(Tango) {
	// Tango
	public import tango.math.Math;
}
else {
	// Phobos
	public import std.math;

	// OK. DMD has an issue when you redefine intrinsics...
	// that is, it forgets they exist.
	// Eventually, this will cause an error. therefore,

	// XXX: REMOVE when compiler is fixed
	private import Math = std.math;

	alias Math.sqrt sqrt;
}
