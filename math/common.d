module math.common;

// template the function to accept multiple inputs and outputs
// allow the usage of this template, or a general common form

// common form: generally returns a double and accepts
//		multiple types of inputs

import math.mathobject;

import core.definitions;
import core.util;

import io.console;

template _mathFunc(string func) {
	const char[] _mathFunc = `
		MathObject ` ~ func ~ `(MathObject operand) {
			// call corresponding op for the MathObject
			return operand.op` ~ cast(char)(func[0] - 32) ~ func[1..$] ~ `();
		}

		`;
}

const double PI = 3.14159265;
const double TWOPI = 2*PI;

