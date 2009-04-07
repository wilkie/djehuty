module math.common;

// template the function to accept multiple inputs and outputs
// allow the usage of this template, or a general common form

// common form: generally returns a double and accepts
//		multiple types of inputs

import math.mathobject;

import core.literals;

template _mathFunc(StringLiteral8 func)
{
	const char[] _mathFunc = `
		MathObject ` ~ func ~ `(MathObject operand)
		{
			// call corresponding op for the MathObject
			return operand.op` ~ cast(char)(func[0] - 32) ~ func[1..$] ~ `();
		}

		`;
}

mixin(_mathFunc!("sqrt"));

double sqrt(double operand)
{
	double x, z, tempf;
	uint *tfptr = (cast(uint *)&tempf) + 1;

	tempf = operand;
	*tfptr = (0xbfcdd90a - *tfptr)>>1;
	x =  tempf;
	z =  operand*0.5;
	x = (1.5*x) - (x*x)*(x*z);
	x = (1.5*x) - (x*x)*(x*z);
	x = (1.5*x) - (x*x)*(x*z);
	x = (1.5*x) - (x*x)*(x*z);
	x = (1.5*x) - (x*x)*(x*z);
	return x*operand;
}
