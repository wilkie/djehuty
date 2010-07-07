module math.matrix;

// Matrix implementation, and assorted functions

// Create a 3x3 matrix with the initial values given:
//		Matrix!(double) matrix = Matrix!(double)([1,2,3], [2,3,4], [3,4,5]);


import math.vector;

class Matrix(T) {
protected:

	T[][] _data;

public:
	// Description: Creates a Matrix class based upon the 2 dimensional array of values given.
	// Note: The array dimensions must be balanced.
	this(T[][] operands...) {
		if (operands.length == 0) {
			_data = null;
		}
		else {
			_data = operands.dup;
		}
	}

	// Description: Creates an empty Matrix class with the size specified.
	this(int x, int y) {
	}

	// Description: The copy constructor for the Matrix class.
	this(Matrix!(T) copy) {
		_data = copy._data.dup;
	}

	// Description: This function returns the number of rows in the matrix.
	// Returns: The number of rows.
	uint rows() {
		return _data.length;
	}

	// Description: This function returns the number of columns in the matrix.
	// Returns: The number of columns.
	uint cols() {
		if (rows() > 0) {
			return _data[0].length;
		}

		return 0;
	}


	// Arithmetic Overrides //


	// Description: Overrides the multiply operator to multiply two compatible matrices.
	// operand: A compatible matrix.
	// Returns: The matrix that is the result of the computation. An empty 0x0 matrix if the computation is invalid.
	Matrix!(T) opMul(Matrix!(T) operand) {
		// multiply both matrices, if possible

		Matrix!(T) ret = new Matrix!(T)();

		// [ 2 3     [ 1 4 3 1
		//   4 5   x   2 3 1 1 ]
		//   3 4 ]

		//  rows x cols
		//  3 x 2  x 2 x 4 = 3 x 4

		// a.cols MUST == b.rows

		if (cols() != operand.rows()) {
			// error
			return ret;
		}

		// [ 8  17  9  5
		//   14 31 17  9
		//   11 24 13  7 ]

		// [ a11 * b11 + a21 * b12, a11 * b21 + a21 * b22, a11 * b31 + a21 * b32, a11 * b41 + a21 * b42,
		//   a12 * b11 + a22 * b12, a12 * b21 + a22 * b22, a12 * b31 + a22 * b32, a12 * b41 + a22 * b42,
		//   a13 * b11 + a23 * b12, a13 * b21 + a23 * b22, a13 * b31 + a23 * b32, a13 * b41 + a23 * b42  ]

		// [ a1x * by1 + ... + anx * byn, ... , n is from 1 to cols inclusive

		ret._data = new T[][](rows(), operand.cols());

		for (int y1 = 0; y1<ret.cols(); y1++) {
			for (int x1 = 0; x1<ret.rows(); x1++) {
				ret._data[x1][y1] = 0;
				for (int i = 0; i < cols(); i++) {
					ret._data[x1][y1] += (_data[x1][i] * operand._data[i][y1]);
				}
			}
		}

		return ret;
	}

	// Description: Overrides the multiply and assign operator to multiply two compatible matrices.
	// operand: A compatible matrix.
	void opMulAssign(Matrix!(T) operand) {
	}

	// Description: Overrides the multiply operator to compute the scalar multiplication of the matrix and a value.
	// scalar: A scalar value.
	// Returns: The result of such a computation.
	Matrix!(T) opMul(double scalar) {
		Matrix!(T) ret = new Matrix!(T)(this);

		for (int i = 0; i<rows(); i++) {
			for (int j = 0; j<cols(); j++)
			{
				ret._data[i][j] *= scalar;
			}
		}

		return ret;
	}

	// Description: Overrides the multiply and assign operator to compute the scalar multiplication of the matrix and a value.
	// scalar: A scalar value.
	void opMulAssign(double scalar) {
		for (int i = 0; i<rows(); i++) {
			for (int j = 0; j<cols(); j++) {
				_data[i][j] *= scalar;
			}
		}
	}

	// Description: Overrides the addition operator to compute the addition of two matrices of common dimensions.
	// operand: A matrix of equal dimensions.
	// Returns: An empty 0x0 matrix upon error or the matrix result of the computation.
	Matrix!(T) opAdd(Matrix!(T) operand) {
		Matrix!(T) ret = new Matrix!(T)(this);

		for (int i = 0; i<rows(); i++) {
			for (int j = 0; j<cols(); j++) {
				ret._data[i][j] += operand._data[i][j];
			}
		}

		return ret;
	}

	// Description: Overrides the addition and assign operator to compute the addition of two matrices of common dimensions.
	// operand: A matrix of equal dimensions.
	void opAddAssign(Matrix!(T) operand) {
		for (int i = 0; i<rows(); i++) {
			for (int j = 0; j<cols(); j++) {
				_data[i][j] += operand._data[i][j];
			}
		}
	}

	// Description: Overrides the subtraction operator to compute the addition of two matrices of common dimensions.
	// operand: A matrix of equal dimensions.
	// Returns: An empty 0x0 matrix upon error or the matrix result of the computation.
	Matrix!(T) opSub(Matrix!(T) operand) {
		Matrix!(T) ret = new Matrix!(T)(this);

		for (int i = 0; i<rows(); i++) {
			for (int j = 0; j<cols(); j++) {
				ret._data[i][j] -= operand._data[i][j];
			}
		}

		return ret;
	}

	// Description: Overrides the subtraction and assign operator to compute the addition of two matrices of common dimensions.
	// operand: A matrix of equal dimensions.
	void opSubAssign(Matrix!(T) operand) {
		for (int i = 0; i<rows(); i++) {
			for (int j = 0; j<cols(); j++) {
				_data[i][j] -= operand._data[i][j];
			}
		}
	}

	bool equals(Matrix!(T) compareTo) {
		if (compareTo.rows() != rows()) {
			return false;
		}

		if (compareTo.cols() != cols()) {
			return false;
		}

		if (compareTo._data[0..$][0..$] == _data[0..$][0..$]) {
			return true;
		}

		return false;
	}

	// operator overloading, makes the Vector act like an array
	// all asserts/runtime checks are done through D's own facilities

	// mathematical operator overloads
	int opEquals(Object o) {
		return equals(cast(Matrix!(T))o);
	}

	Vector!(T) row(int index) {
		T[] comps = new T[cols()];

		for (int i = 0; i < cols(); i++) {
			comps[i] = _data[index][i];
		}

		return new Vector!(T)(comps);
	}

	Vector!(T) col(int index) {
		T[] comps = new T[rows()];

		for (int i = 0; i < rows(); i++) {
			comps[i] = _data[i][index];
		}

		return new Vector!(T)(comps);
	}
}

/*

// Unit Testing

import core.utest;

unittest
{
	// Testing: construction, opMul, opMulAssign, opEquals, equals, rows, cols

	// check creation and multiplication
	Matrix!(double) mat1 = new Matrix!(double)([1,2,3],[2,3,4],[3,4,5]);
	Matrix!(double) idy1 = new Matrix!(double)([1,0,0],[0,1,0],[0,0,1]);

	Matrix!(double) mul1 = mat1 * idy1;
	Matrix!(double) mul2 = idy1 * mat1;

	assert(mul1 == mul2);
	assert(mul1 == mat1);
	assert(mul2 == mat1);

	// multiplying uneven matrices
	Matrix!(double) mat2 = new Matrix!(double)([1,1],[1,1],[2,3]);

	mul1 = mat1 * mat2; // 3x3 * 3x2 == 3x2 result
	mul2 = mat2 * mat1; // 3x2 * 3x3 == invalid result

	// check for invalid multiplication and check for rows and cols validity
	assert((mul1.rows() == 3) && (mul1.cols() == 2));
	assert((mul2.rows() == 0) && (mul2.cols() == 0));

	// the actual valid answer must also be checked
	Matrix!(double) ans1 = new Matrix!(double)([9, 12], [13, 17], [17, 22]);

	// check for valid multiplication
	assert(mul1 == ans1);

	// check non square matrices
	mat1 = new Matrix!(double)([1,2,3],[2,3,4],[3,4,5],[4,5,6]);

	mul1 = mat1 * mat2;
	mul2 = mat2 * mat1;

	// check for invalid multiplication and check for rows and cols validity
	assert((mul1.rows() == 4) && (mul1.cols() == 2)); // 4x3 * 3x2 == 4x2
	assert((mul2.rows() == 0) && (mul2.cols() == 0)); // 4x2 * 3x4 == invalid result

	// check for actual answer
	ans1 = new Matrix!(double)([9,12],[13,17],[17,22],[21,27]);

	// check for the valid multiplication
	assert(ans1 == mul1);

	// check for scalar multiplication
	mat1 *= 2;

	mat2 = new Matrix!(double)([2,4,6],[4,6,8],[6,8,10],[8,10,12]);
	assert(mat1 == mat2);

	// Testing: row, col

	// check grabbing a row
	Vector!(double) v = ans1.row(1);
	Vector!(double) u = new Vector!(double)(13,17);

	assert(u == v);

	// check grabbing a column
	v = ans1.col(1);
	u = new Vector!(double)(12,17,22,27);

	assert(u == v);

	// pass
	UnitTestPassed(__FILE__);
}*/
