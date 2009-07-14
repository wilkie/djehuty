// Vector implementation

// Implementation Note:
// It is done in generics to support Vectors of MathObjects
// For instance, an Expression class that holds an expression.
// When the Expression class properly implements overloads, it can perform
//  and keep the results of common vector manipulations in expression form
module math.vector;

// Imposed runtime import for variadics
import std.stdarg;

// Strings
import core.string;

// Math common
import math.common;
import math.mathobject;

// math objects?

// Section: Math

// Description: This template class represents a mathematical vector.
class Vector(T = double) {

	// Description: This constructor produces a Vector with the specified component values.
	this(T[] components...) {
		// make a copy of the input
		if (components.length == 0) {
			_components = null;
		}
		else {
			_components = components.dup;
		}
	}

	// Description: This function returns the number of components within the vector.
	// Returns: The number of components.
	int size() {
		// get the number of components
		return _components.length;
	}

	// Description: This function returns the magnitude of the vector. This is the square root of the sum of the squares of each component. That is: sqrt((c1^2) + (c2^2) + ... + (cN^2)).
	T magnitude() {
		static if (is(T : MathObject)) { T sum = new T; } else { T sum = 0; }

		for (int i=0; i<size(); i++) {
			sum += (_components[i] * _components[i]);
		}

		sum = cast(T)sqrt(sum);

		return sum;
	}

	// Description: This function returns the sum of the components.
	// Returns: The computed value of comp(0) + comp(1) + ... + comp(size()-1)
	T sum() {
		static if (is(T : MathObject)) { T calcsum = new T; } else { T calcsum = 0; }

		foreach(comp; _components) {
			calcsum += comp;
		}

		return calcsum;
	}

	// Description: This function returns the computed dot product for the vector.
	// operand: The vector to compute the dot product with.
	T dotProduct(Vector!(T) operand) {
		static if (is(T : MathObject)) { T sum = new T; } else { T sum = 0; }

		if (operand.size() != size()) {
			// error
			return sum;
		}

		for (int i=0; i<size(); i++) {
			sum += (_components[i] * operand._components[i]);
		}

		return sum;
	}

	// Description: This function returns a new vector representing the unit vector in the direction of the current vector.
	// Returns: A unit vector.
	Vector!(T) unitVector() {
		// U = u / ||u||

		Vector!(T) ret = new Vector!(T)();
		ret._components = new T[size()];

		T mag = magnitude();
		for(int i=0; i<size(); i++) {
			ret._components[i] = cast(T)(_components[i] / mag);
		}

		return ret;
	}

	bool equals(Vector!(T) compareTo) {
		if (compareTo._components.length != _components.length) {
			return false;
		}

		if (compareTo._components[0..$] == _components[0..$]) {
			return true;
		}

		return false;
	}

	// operator overloading, makes the Vector act like an array
	// all asserts/runtime checks are done through D's own facilities

	// mathematical operator overloads
	int opEquals(Object o) {
		return equals(cast(Vector!(T))o);
	}

	// add the vectors
	Vector!(T) opAdd(Vector!(T) operand) {
		assert(operand.size() == size(), "Vector: opAdd: vector operands do not have equal components.");

		Vector!(T) ret = new Vector!(T)();

//		ret._components = new T[size()];

		for(int i=0;i<size();i++) {
			ret._components[i] = cast(T)(_components[i] + operand._components[i]);
		}

		return ret;
	}

	void opAddAssign(Vector!(T) operand) {
		assert(operand.size() == size(), "Vector: opAdd: vector operands do not have equal components.");

		for(int i=0;i<size();i++) {
			_components[i] += operand._components[i];
		}
	}

	// multiply the vectors

	// scalar multiplication
	Vector!(T) opMul(double operand) {
		Vector!(T) ret = new Vector!(T)();

		ret._components = new T[size()];

		for(int i=0; i<size(); i++) {
			ret._components[i] = cast(T)(_components[i] * operand);
		}

		return ret;
	}

	void opMulAssign(double operand) {
		for(int i=0; i<size(); i++) {
			_components[i] *= operand;
		}
	}

	// vector multiplication (returns a matrix!)
	/* Vector!(T) opMul(double operand)
	{
		for(int i=0; i<size(); i++)
		{
			_components[i] *= operand;
		}

		return this;
	} */



	// array operator overloads
	T[] opSlice() {
		return _components.dup;
	}

	T[] opSlice(size_t x, size_t y) {
		return _components[x..y];
	}

	T[] opSliceAssign(T val) {
		return _components[] = val;
	}

	T[] opSliceAssign(T[] val) {
		return _components[] = val;
	}

	T[] opSliceAssign(T val, size_t x, size_t y) {
		return _components[x..y] = val;
	}

	T[] opSliceAssign(T[] val, size_t x, size_t y) {
		return _components[x..y] = val;
	}

	T opIndex(size_t i) {
		return _components[i];
	}

	T opIndexAssign(T value, size_t i) {
		return _components[i] = value;
	}
	
	string toString() {
		String ret = new String("[");

		int i;
		for (i = 0; i < size()-1; i++) {
			ret ~= _components[i];
			ret ~= ", ";
		}

		if (i == size() - 1) {
			ret ~= _components[i];
			ret ~= "]";
		}

		return ret;
	}

protected:

	bool _dirty;	// computations that have been cached are invalid

	// cached computations
	T _magnitude;
	T _dotProduct;
	T _unitVector;

	T[] _components;
}

/*


// Unit Testing

import core.utest;

unittest
{
	// Tested: construction, opEquals, equals

	Vector!(double) u = new Vector!(double)(1,2,3);
	Vector!(double) v = new Vector!(double)(1,2,3);

	assert(u == v);

	// Tested: opMul

	u = v * 2;
	v *= 4;
	u = u * 2;

	// they should be equal
	assert(u == v);

	// Tested: magnitude

	u = new Vector!(double)(3, 4);
	int mag = cast(int)u.magnitude();

	// magnitude should be 5
	assert(mag == 5);

	// Tested: unitVector
	v = new Vector!(double)(8, 0);
	u = v.unitVector();

	// compare against obvious answer
	v = new Vector!(double)(1, 0);
	assert(u == v);

	// pass
	UnitTestPassed(__FILE__);
}*/
