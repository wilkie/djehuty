// Vector implementation

// Implementation Note:
// It is done in generics to support Vectors of MathObjects
// For instance, an Expression class that holds an expression.
// When the Expression class properly implements overloads, it can perform
//  and keep the results of common vector manipulations in expression form
module math.vector;

// Strings
import core.string;
import core.definitions;

// Math common
import math.sqrt;
import math.sin;
import math.cos;
import math.mathobject;

import io.console;

// math objects?

// Section: Math

// Description: This template class represents a mathematical vector.
class Vector(T = double) {

	this() {
		_data = null;
	}

	// Description: This constructor produces a Vector with the specified component values.
	this(T[] components) {
		// make a copy of the input
		if (components.length == 0) {
			_data = null;
		}
		else {
			_data = components.dup;
		}
	}

	this(uint size) {
		_data = new T[size];
	}

	// Description: This function returns the number of components within the vector.
	// Returns: The number of components.
	int size() {
		// get the number of components
		return _data.length;
	}

	// Description: This function returns the magnitude of the vector. This is the square root of the sum of the squares of each component. That is: sqrt((c1^2) + (c2^2) + ... + (cN^2)).
	T magnitude() {
		static if (is(T : MathObject)) { T sum = new T; } else { T sum = cast(T)(0 + 0i); }

		for (int i=0; i<size(); i++) {
			sum += (_data[i] * _data[i]);
		}

		sum = cast(T)sqrt(sum);

		return sum;
	}

	// Description: This function returns the sum of the components.
	// Returns: The computed value of comp(0) + comp(1) + ... + comp(size()-1)
	T sum() {
		static if (is(T : MathObject)) { T calcsum = new T; } else { T calcsum = cast(T)(0 + 0i); }

		foreach(comp; _data) {
			calcsum += comp;
		}

		return calcsum;
	}

	// Description: This function returns the computed dot product for the vector.
	// operand: The vector to compute the dot product with.
	T dotProduct(Vector!(T) operand) {
		static if (is(T : MathObject)) { T sum = new T; } else { T sum = cast(T)(0 + 0i); }

		if (operand.size() != size()) {
			// error
			return sum;
		}

		for (int i=0; i<size(); i++) {
			sum += (_data[i] * operand._data[i]);
		}

		return sum;
	}

	// Description: This function returns a new vector representing the unit vector in the direction of the current vector.
	// Returns: A unit vector.
	Vector!(T) unitVector() {
		// U = u / ||u||

		Vector!(T) ret = new Vector!(T)();
		ret._data = new T[size()];

		T mag = magnitude();
		for(int i=0; i<size(); i++) {
			ret._data[i] = cast(T)(_data[i] / mag);
		}

		return ret;
	}

	bool equals(Vector!(T) compareTo) {
		if (compareTo._data.length != _data.length) {
			return false;
		}

		if (compareTo._data[0..$] == _data[0..$]) {
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

//		ret._data = new T[size()];

		for(int i=0;i<size();i++) {
			ret._data[i] = cast(T)(_data[i] + operand._data[i]);
		}

		return ret;
	}

	void opAddAssign(Vector!(T) operand) {
		assert(operand.size() == size(), "Vector: opAdd: vector operands do not have equal components.");

		for(int i=0;i<size();i++) {
			_data[i] += operand._data[i];
		}
	}

	// multiply the vectors

	// scalar multiplication
	Vector!(T) opMul(double operand) {
		Vector!(T) ret = new Vector!(T)();

		ret._data = new T[size()];

		for(int i=0; i<size(); i++) {
			ret._data[i] = cast(T)(_data[i] * operand);
		}

		return ret;
	}

	void opMulAssign(double operand) {
		for(int i=0; i<size(); i++) {
			_data[i] *= operand;
		}
	}

	// vector multiplication (returns a matrix!)
	/* Vector!(T) opMul(double operand)
	{
		for(int i=0; i<size(); i++)
		{
			_data[i] *= operand;
		}

		return this;
	} */

	T[] array() {
		return _data.dup;
	}

	// array operator overloads
	T[] opSlice() {
		return array();
	}

	T[] opSlice(size_t x, size_t y) {
		return _data[x..y];
	}

	T[] opSliceAssign(T val) {
		return _data[] = val;
	}

	T[] opSliceAssign(T[] val) {
		return _data[] = val;
	}

	T[] opSliceAssign(T val, size_t x, size_t y) {
		return _data[x..y] = val;
	}

	T[] opSliceAssign(T[] val, size_t x, size_t y) {
		return _data[x..y] = val;
	}

	T opIndex(size_t i) {
		return _data[i];
	}

	T opIndexAssign(T value, size_t i) {
		return _data[i] = value;
	}

	string toString() {
		string ret = "[";

		int i;
		for (i = 0; i < size()-1; i++) {
			ret ~= toStr(_data[i]);
			ret ~= ", ";
		}

		if (i == size() - 1) {
			ret ~= toStr(_data[i]);
			ret ~= "]";
		}

		return ret;
	}

	void fft() {
		// Only implemented for powers of 2
		if (_data is null || _data.length < 1 || _data.length & (_data.length - 1)) {
			return;
		}

		fftRearrange();
		fftPerform(false);
		fftScale();

		// truncate
		_data = _data[0.._data.length / 2];
	}

	void ifft() {
		// Only implemented for powers of 2
		if (_data is null || _data.length < 1 || _data.length & (_data.length - 1)) {
			return;
		}

		fftRearrange();
		fftPerform(true);
		fftScale();
	}

protected:

	bool _dirty;	// computations that have been cached are invalid

	// cached computations
	T _magnitude;
	T _dotProduct;
	T _unitVector;

	T[] _data;

	void fftPerform(bool inverse) {
		int isign = (inverse) ? -1 : 1;
		size_t N = _data.length;

		size_t i, j, m;
		j = 0;
		for (i = 0; i < N; i++) {
//			Console.putln("i: ", i, " j: ", j);
			if (j > i) {
//				Console.putln("swaping ", _data[j], " with ", _data[i]);
				T tmp = _data[j];
				_data[j] = _data[i];
				_data[i] = tmp;
			}
			m = N >> 1;
			while (m >= 1 && (j+1) > m) {
				//Console.putln("m: ", m);
				j -= m;
				m >>= 1;
			}
			j += m;
		}

		size_t mmax = 2;
		size_t istep;
		while (N*2 > mmax) {
			istep = 2 * mmax;

			double theta = (2.0 * 3.1415926535897932) / (isign * mmax);
			double sine = sin(0.5 * theta);
			cdouble mult = (-2.0 * sine * sine) + (sin(theta) * 1.0i);
			cdouble factor = 1.0 + 0.0i;

//			Console.putln("n: ", N*2, " mmax: ", mmax);

			for (m = 1; m < mmax; m += 2) {
				for (i = m; i <= N*2; i += istep) {
					j = i + mmax;
//					Console.putln("eval i: ", i , " j: ", j);
					cdouble temp = factor * _data[(j-1)/2];
//					Console.putln("temp: ", temp);
					_data[(j-1)/2] = cast(T)(_data[(i-1)/2] - temp);
					_data[(i-1)/2] = cast(T)(_data[(i-1)/2] + temp);
				}
//				Console.putln("factor: ", factor);
//				Console.putln("mult: ", mult);
				factor = mult * factor + factor;
				//Console.putln("factor: ", factor);
			}
			mmax = istep;
		}

		// normalize
		if (isign == 1) {
			for (i = 0; i < N; i++) {
				_data[i] /= N;
//				Console.putln("scaled: ", _data[i]);
			}
		}
	}

	void fftRearrange() {
	}

	void fftScale() {
	}
}

cdouble[] fft(cdouble[] arr) {
	Vector!(cdouble) foo = new Vector!(cdouble)(arr);
	foo.fft();
	return foo._data;
}
