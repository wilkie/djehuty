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

template IsInterface(T) {
	const bool IsInterface = is(T == interface);
}

template IsObject(T) {
	const bool IsObject = IsClass!(T) || IsInterface!(T);
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

template SuperClass(T...) {
	static if (T.length == 0) {
		alias Object SuperClass;
	}
	static if (T.length == 1) {
		static if (is(T[0] S == super)) {
			static if (S.length == 1) {
				alias S[0] SuperClass;
			}
			else {
				alias S[1] SuperClass;
			}
		}
		else {
			alias T[0] SuperClass;
		}
	}
	else static if (is(T[1] S == super)) {
		static if (S.length == 1) {
			alias S[0] SuperClass;
		}
		else {
			alias S[1] SuperClass;
		}
	}
	else {
		alias T[$-1] SuperClass;
	}
}

template ArrayType(T) {
	static if (is (T U:U[])) {
		alias U ArrayType;
	}
	else {
		alias T ArrayType;
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

template Tuple(T...) {
	alias T Tuple;
}

// String templates
template Capitalize(char[] foo) {
	static if (foo.length == 0) {
		const char[] Capitalize = "";
	}
	else static if (foo[0] >= 'A' && foo[0] <= 'Z') {
		const char[] Capitalize = foo;
	}
	else {
		const char[] Capitalize = cast(char)(foo[0] - 32) ~ foo[1..$];
	}
}

private template TrimLImpl(char[] foo, uint pos = 0) {
	static if (pos >= foo.length) {
		const char[] TrimLImpl = "";
	}
	else static if (foo[pos] == ' ' || foo[pos] == '\t' || foo[pos] == '\n' || foo[pos] == '\r') {
		const char[] TrimLImpl = TrimLImpl!(foo, pos + 1);
	}
	else {
		const char[] TrimLImpl = foo[pos..$];
	}
}

template TrimL(char[] foo) {
	const char[] TrimL = TrimLImpl!(foo);
}

private template TrimRImpl(char[] foo, int pos = foo.length-1) {
	static if (pos <= -1) {
		const char[] TrimRImpl = "";
	}
	else static if (foo[pos] == ' ' || foo[pos] == '\t' || foo[pos] == '\n' || foo[pos] == '\r') {
		const char[] TrimRImpl = TrimRImpl!(foo, pos - 1);
	}
	else {
		const char[] TrimRImpl = foo[0..pos+1];
	}
}

template TrimR(char[] foo) {
	const char[] TrimR = TrimRImpl!(foo);
}

private template TrimImpl(char[] foo, uint pos = 0) {
}

template Trim(char[] foo) {
	const char[] Trim = TrimL!(TrimR!(foo));
}

private template RemoveSpacesImpl(char[] foo, uint pos = 0) {
	static if (pos >= foo.length) {
		const char[] RemoveSpacesImpl = foo[0..pos];
	}
	else static if (foo[pos] == ' ' || foo[pos] == '\t' || foo[pos] == '\n' || foo[pos] == '\r') {
		const char[] RemoveSpacesImpl = foo[0..pos] ~ RemoveSpacesImpl!(foo[pos+1..$], 0);
	}
	else {
		const char[] RemoveSpacesImpl = RemoveSpacesImpl!(foo, pos + 1);
	}
}

template RemoveSpaces(char[] foo) {
	const char[] RemoveSpaces = RemoveSpacesImpl!(foo);
}