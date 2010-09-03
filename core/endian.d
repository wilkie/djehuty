/*
 * endian.d
 *
 * This file contains some simple code to switch endian.
 *
 */

module core.endian;

import core.util;

private void _endian64(T)(ref T input) {
	input = (input >> 56) | ((input >> 40) & 0xFF00) | ((input >> 24) & 0xFF0000) | ((input >> 8) & 0xFF000000) | ((input << 8) & 0xFF00000000UL) | ((input << 24) & 0xFF0000000000UL) | ((input << 40) & 0xFF000000000000UL) | ((input << 56) & 0xFF00000000000000UL);
}

private void _endian32(T)(ref T input) {
	input = (input >> 24) | ((input >> 8) & 0xFF00) | ((input << 8) & 0xFF0000) | ((input << 24) & 0xFF000000);
}

private void _endian16(T)(ref T input) {
	input = (input >> 8) | (input << 8);
}

private template EndianStructImpl(T, int idx = 0) {
	static if (idx == T.tupleof.length) {
		const string EndianStructImpl = "";
	}
	else static if (IsStruct!(typeof(T.tupleof[idx]))) {
		const string EndianStructImpl = `
	_endianStruct(input.` ~ GetLastName!(T.tupleof[idx].stringof) ~ `, who);`
		~ EndianStructImpl!(T, idx + 1);
	}
	else static if (IsArray!(typeof(T.tupleof[idx]))) {
		const string EndianStructImpl = `
	_endianArray!(typeof(input.` ~ GetLastName!(T.tupleof[idx].stringof) ~ `), who)(input.` ~ GetLastName!(T.tupleof[idx].stringof) ~ `);`
		~ EndianStructImpl!(T, idx + 1);
	}
	else {
		const string EndianStructImpl = `
	_endian!(typeof(input.` ~ GetLastName!(T.tupleof[idx].stringof) ~ `), who)(input.` ~ GetLastName!(T.tupleof[idx].stringof) ~ `);`
		~ EndianStructImpl!(T, idx + 1);
	}
}

private template _endianStruct(T, string who) {
	void _endianStruct(ref T input) {
		mixin(EndianStructImpl!(T));
	}
}

private template _endianArray(T, string who) {
	void _endianArray(T input) {
		foreach(ref element; input) {
			static if (IsArray!(ArrayType!(T))) {
				_endianArray!(ArrayType!(T), who)(element);
			}
			else {
				_endian!(ArrayType!(T), who)(element);
			}
		}
	}
}

private template _endian(T, string who) {
	void _endian(ref T input) {
		static if (IsArray!(T)) {
			_endianArray!(T, "")(input);
		}
		static if (IsStruct!(T)) {
			_endianStruct!(T, "")(input);
		}
		else static if (IsEnum!(T)) {
			auto foo = cast(EnumType!(T))input;
			_endian!(EnumType!(T), who)(foo);
			input = cast(T)foo;
		}
		else static if (is(T == ulong) || is(T == long)) {
			_endian64(input);
		}
		else static if (is(T == uint) || is(T == int)) {
			_endian32(input);
		}
		else static if (is(T == ushort) || is(T == short)) {
			_endian16(input);
		}
		else static if (is(T == ubyte) || is(T == byte)) {
		}
		else static if (who == "") {
		}
		else {
			static assert(false, who ~ ": Error: " ~ T.stringof ~ " is not a valid type.");
		}
	}
}

template fromBigEndian(T) {
	void fromBigEndian(ref T input) {
		version(BigEndian) {
		}
		else {
			static if (IsArray!(T)) {
				_endianArray!(T,"fromBigEndian")(input);
			}
			else {
				_endian!(T,"fromBigEndian")(input);
			}
		}
	}
}

template fromLittleEndian(T) {
	static if (IsArray!(T)) {
		void fromLittleEndian(T input) {
			version(LittleEndian) {
			}
			else {
				_endian!(T,"fromLittleEndian")(input);
			}
		}
	}
	else {
		void fromLittleEndian(ref T input) {
			version(LittleEndian) {
			}
			else {
				_endian!(T,"fromLittleEndian")(input);
			}
		}
	}
}

alias fromLittleEndian toBigEndian;
alias fromBigEndian toLittleEndian;