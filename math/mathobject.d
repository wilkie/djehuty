module math.mathobject;

// Description: Will resolve to true when the object T inherits or is of type 
//   MathObject.
template IsMathObject(T) {
	static if (T.stringof == "MathObject") {
		const bool IsMathObject = true;
	}
	else static if (is(T : Object)) {
		const bool IsMathObject = false;
	}
	else static if (is(T == class)) {
		const bool IsMathObject = IsMathObject!(Super!(T));
	}
	else {
		const bool IsMathObject = false;
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

// this is the root object for classes that want to overload math functionality
class MathObject {

	MathObject opSqrt() {
		return null;
	}

	MathObject opCos() {
		return null;
	}

	MathObject opSin() {
		return null;
	}

	MathObject opTan() {
		return null;
	}

	// arithmetic overloads
	MathObject opDiv(MathObject operand) {
		return null;
	}

	MathObject opDiv(double operand) {
		return null;
	}

	MathObject opMul(MathObject operand) {
		return null;
	}

	MathObject opMul(double operand) {
		return null;
	}

	MathObject opAdd(MathObject operand) {
		return null;
	}

	MathObject opAdd(double operand) {
		return null;
	}

	void opAddAssign(MathObject operand) {
	}

	void opAddAssign(double operand) {
	}

	void opMulAssign(MathObject operand) {
	}

	void opMulAssign(double operand) {
	}
}
