module math.mathobject;

// this is the root object for classes that want to overload math functionality
class MathObject {

	MathObject opSqrt() {
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
