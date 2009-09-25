module core.util;

// Contains many templates and other magical functions

template eval( A... )
{
    const typeof(A[0]) eval = A[0];
}

template IsType(T) {
	const bool IsType = !IsArray!(T);
}

template IsClass(T) {
	const bool IsClass = is(T == class);
}

template IsIntType(T) {
	const bool IsIntType = IsUnsigned!(T) || IsSigned!(T);
}

template IsUnsigned(T) {
	const bool IsUnsigned = is(T == uint)
			|| is(T == ushort)
			|| is(T == ulong)
			|| is(T == ubyte);
}

template IsSigned(T) {
	const bool IsSigned = is(T == int)
			|| is(T == short)
			|| is(T == long)
			|| is(T == byte);
}

template IsFloat(T) {
	const bool IsFloat = is(T == float) || is(T == double) || is(T == real);
}

template IsComplex(T) {
	const bool IsComplex = is(T == cfloat) || is(T == cdouble) || is(T == creal);
}

template IsImaginary(T) {
	const bool IsImaginary = is(T == ifloat) || is(T == idouble) || is(T == ireal);
}

template IsStruct(T) {
	const bool IsStruct = is(T == struct);
}

template IsArray(T) {
	static if (is(T U:U[])) {
		const bool IsArray = true;
	}
	else {
		const bool IsArray = false;
	}
}

template BaseType(T) {
	static if (is (T U:U[])) {
		alias BaseType!(U) BaseType;
	}
	else {
		alias T BaseType;
	}
}