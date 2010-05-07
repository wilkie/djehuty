module core.util;

// Contains many templates and other magical functions

// Description: Resolves to the result of the expression given by A[0].
template Eval( A... ) {
    const typeof(A[0]) Eval = A[0];
}

// Description: Resolves to true when T is not an array and false otherwise.
template IsType(T) {
	const bool IsType = !IsArray!(T);
}

// Description: Resolves to true when T is a class and false otherwise.
template IsClass(T) {
	const bool IsClass = is(T == class);
}

// Description: Resolves to true when T is an interface and false otherwise.
template IsInterface(T) {
	const bool IsInterface = is(T == interface);
}

// Description: Resolves to true when T is either true via IsClass or IsInterface and false otherwise.
template IsObject(T) {
	const bool IsObject = IsClass!(T) || IsInterface!(T);
}

// Description: Resolves to true when T is either true via IsSigned or IsUnsigned and false otherwise.
template IsIntType(T) {
	const bool IsIntType = IsUnsigned!(T) || IsSigned!(T);
}

// Description: Resolves to true when T is an ubyte, ushort, uint, or ulong and false otherwise.
template IsUnsigned(T) {
	const bool IsUnsigned = is(T == uint)
			|| is(T == ushort)
			|| is(T == ulong)
			|| is(T == ubyte);
}

// Description: Resolves to true when T is a char, wchar, or dchar and false otherwise.
template IsCharType(T) {
	const bool IsCharType = is(T == char)
		|| is(T == wchar)
		|| is(T == dchar);
}

// Description: Resolves to true when T is a string, wstring, or dstring and false otherwise.
template IsStringType(T) {
	const bool IsStringType = is(T == char[])
		|| is(T == wchar[])
		|| is(T == dchar[]);
}

// Description: Resolves to true when T is an byte, short, int, or long and false otherwise.
template IsSigned(T) {
	const bool IsSigned = is(T == int)
			|| is(T == short)
			|| is(T == long)
			|| is(T == byte);
}

// Description: Resolves to true when T is an float, double, or real and false otherwise.
template IsFloat(T) {
	const bool IsFloat = is(T == float) || is(T == double) || is(T == real);
}

// Description: Resolves to true when T is an cfloat, cdouble, or creal and false otherwise.
template IsComplex(T) {
	const bool IsComplex = is(T == cfloat) || is(T == cdouble) || is(T == creal);
}

// Description: Resolves to true when T is an ifloat, idouble, or ireal and false otherwise.
template IsImaginary(T) {
	const bool IsImaginary = is(T == ifloat) || is(T == idouble) || is(T == ireal);
}

// Description: Resolves to true when T is a struct and false otherwise.
template IsStruct(T) {
	const bool IsStruct = is(T == struct);
}

// Description: Resolves to true when T is an array and false otherwise.
template IsArray(T) {
	static if (is(T U:U[])) {
		const bool IsArray = true;
	}
	else {
		const bool IsArray = false;
	}
}

// Description: Resolves to the class that the given class or TypeTuple resolved from is(Type == super) inherits
//   from.
template Super(T...) {
	static if (T.length == 0) {
		static assert (false, "SuperClass: " ~ T.stringof ~ " is not a class or TypeTuple.");
	}
	else {
		static if (is(T[0] S == super)) {
			alias S[0] Super;
		}
		else {
			static assert (false, "SuperClass: " ~ T.stringof ~ " is not a class or TypeTuple.");
		}
	}
}

// Description: Resolves to a Tuple of the interfaces the given class or interface implements. Could be an
//   empty Tuple when a class does not inherit an interface.
template Interfaces(T) {
	static if (is(T S == super)) {
		static if (S.length > 1) {
			alias S[1..$] Interfaces;
		}
		else {
			alias Tuple!() Interfaces;
		}
	}
	else {
		static assert (false, "Interfaces: " ~ T.stringof ~ " is not a class or interface.");
	}
}

// Description: When given an array, this will resolve to the type iterable by the array.
template ArrayType(T) {
	static if (is (T U:U[])) {
		alias U ArrayType;
	}
	else {
		static assert(false, "ArrayType: " ~ T.stringof ~ " is not an array.");
	}
}

// Description: When given an array, this will resolve to the ultimate type iterable by the array.
template BaseType(T) {
	static if (is (T U:U[])) {
		alias BaseType!(U) BaseType;
	}
	else {
		alias T BaseType;
	}
}

// Description: A collection used by templates.
template Tuple(T...) {
	alias T Tuple;
}

// String templates

// Description: Resolves to a string that represents the capitalization of the input string.
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

// Description: Resolves to a string that has the leftmost whitespace of the input string trimmed.
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

// Description: Resolves to a string that has the rightmost whitespace of the input string trimmed.
template TrimR(char[] foo) {
	const char[] TrimR = TrimRImpl!(foo);
}

private template TrimImpl(char[] foo, uint pos = 0) {
}

// Description: Resolves to a string that has the whitespace on each end of the input string trimmed.
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

// Description: Resolves to a string that has all of the whitespace of the input string removed.
template RemoveSpaces(char[] foo) {
	const char[] RemoveSpaces = RemoveSpacesImpl!(foo);
}

template Itoa(long i) {
	static if(i < 0) {
		const char[] Itoa = "-" ~ IntToStr!(-i, 10);
	}
	else {
		const char[] Itoa = IntToStr!(i, 10);
	}
}

template Itoh(long i) {
	const char[] Itoh = "0x" ~ IntToStr!(i, 16);
}

template Digits(long i) {
	const char[] Digits = "0123456789abcdefghijklmnopqrstuvwxyz"[0 .. i];
}

template IntToStr(ulong i, int base) {
	static if(i >= base) {
		const char[] IntToStr = IntToStr!(i / base, base) ~ Digits!(base)[i % base];
	}
	else {
		const char[] IntToStr = "" ~ Digits!(base)[i % base];
	}
}


