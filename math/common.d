module math.common;

// template the function to accept multiple inputs and outputs
// allow the usage of this template, or a general common form

// common form: generally returns a double and accepts
//		multiple types of inputs

import math.mathobject;

import core.literals;

template _mathFunc(StringLiteral8 func) {
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
	public import tango.math;
}
else {
	// Phobos
	public import std.math;
}