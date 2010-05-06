/*
 * apply.d
 *
 * This module implements the D runtime functions that involve UTF strings
 * and foreach or foreach_reverse loops.
 *
 */

module runtime.apply;

import runtime.common;

import core.unicode;

import io.console;

extern(D) typedef int delegate(void*) apply_dg_t;
extern(D) typedef int delegate(size_t*, void*) apply_dg2_t;

extern(C):

private {
	const char[] applyCode = `
		// Capture the result
		int result;

		foreach(size_t idx, ref chr; array) {
			// Call the loop body of the foreach, passing the pointer to the character
			result = loopBody(&array[idx]);
	
			// It will return nonzero when it breaks out of the loop early
			if (result) {
				return result;
			}
		}

		// Return result
		return result;
	`;

	const char[] indexedApplyCode = `
		// Capture the result
		int result;

		foreach(size_t idx, ref chr; array) {
			// Call the loop body of the foreach, passing the pointer to the character and index
			result = loopBody(&idx, &array[idx]);
	
			// It will return nonzero when it breaks out of the loop early
			if (result) {
				return result;
			}
		}

		// Return result
		return result;
	`;

	const char[] applyReverseCode = `
		int result;

		foreach_reverse(size_t idx, ref chr; array) {
			// Call the loop body of the foreach, passing the pointer to the character and index
			result = loopBody(&array[idx]);
	
			// It will return nonzero when it breaks out of the loop early
			if (result) {
				return result;
			}
		}

		return result;
	`;

	const char[] indexedApplyReverseCode = `
		int result;

		foreach_reverse(size_t idx, ref chr; array) {
			// Call the loop body of the foreach, passing the pointer to the character and index
			result = loopBody(&idx, &array[idx]);
	
			// It will return nonzero when it breaks out of the loop early
			if (result) {
				return result;
			}
		}

		return result;
	`;

	template _apply(T, char[] code) {
		static if (is(T : dchar) && T.sizeof == dchar.sizeof) {
			const char[] _apply = `
				dchar[] array = Unicode.toUtf32(input);` ~ code;
		}
		else static if (is(T : wchar) && T.sizeof == wchar.sizeof) {
			const char[] _apply = `
				wchar[] array = Unicode.toUtf16(input);` ~ code;
		}
		else static if (is(T : char) && T.sizeof == char.sizeof) {
			const char[] _apply = `
				char[] array = Unicode.toUtf8(input);` ~ code;
		}
		else {
			static assert(false, "Runtime mixin for string apply functions has been misused.");
		}
	}
}

// Description: This runtime function will decode a UTF8 string into wchar
// elements. Used with a foreach loop of the form: foreach(wchar ; char[]).
int _aApplycw1(char[] input, apply_dg_t loopBody) {
	mixin(_apply!(wchar, applyCode));
}

// Description: This runtime function will decode a UTF8 string into dchar
// elements. Used with a foreach loop of the form: foreach(dchar ; char[]).
int _aApplycd1(char[] input, apply_dg_t loopBody) {
	mixin(_apply!(dchar, applyCode));
}

// Description: This runtime function will decode a UTF16 string into char
// elements. Used with a foreach loop of the form: foreach(char;: wchar[]).
int _aApplywc1(wchar[] input, apply_dg_t loopBody) {
	mixin(_apply!(char, applyCode));
}

// Description: This runtime function will decode a UTF16 string into dchar
// elements. Used with a foreach loop of the form: foreach(dchar ; wchar[]).
int _aApplywd1(wchar[] input, apply_dg_t loopBody) {
	mixin(_apply!(dchar, applyCode));
}

// Description: This runtime function will decode a UTF32 string into char
// elements. Used with a foreach loop of the form: foreach(char ; dchar[]).
int _aApplydc1(dchar[] input, apply_dg_t loopBody) {
	mixin(_apply!(char, applyCode));
}

// Description: This runtime function will decode a UTF32 string into wchar
// elements. Used with a foreach loop of the form: foreach(wchar ; dchar[]).
int _aApplydw1(dchar[] input, apply_dg_t loopBody) {
	mixin(_apply!(wchar, applyCode));
}

// Description: This runtime function will decode a UTF8 string into wchar
// elements. Used with a foreach loop of the form: foreach(i, wchar ; char[]).
int _aApplycw2(char[] input, apply_dg2_t loopBody) {
	mixin(_apply!(wchar, indexedApplyCode));
}

// Description: This runtime function will decode a UTF8 string into dchar
// elements. Used with a foreach loop of the form: foreach(i, dchar ; char[]).
int _aApplycd2(char[] input, apply_dg2_t loopBody) {
	mixin(_apply!(dchar, indexedApplyCode));
}

// Description: This runtime function will decode a UTF16 string into char
// elements. Used with a foreach loop of the form: foreach(i, char ; wchar[]).
int _aApplywc2(wchar[] input, apply_dg2_t loopBody) {
	mixin(_apply!(char, indexedApplyCode));
}

// Description: This runtime function will decode a UTF16 string into dchar
// elements. Used with a foreach loop of the form: foreach(i, dchar ; wchar[]).
int _aApplywd2(wchar[] input, apply_dg2_t loopBody) {
	mixin(_apply!(dchar, indexedApplyCode));
}

// Description: This runtime function will decode a UTF32 string into char
// elements. Used with a foreach loop of the form: foreach(i, char ; dchar[]).
int _aApplydc2(dchar[] input, apply_dg2_t loopBody) {
	mixin(_apply!(char, indexedApplyCode));
}

// Description: This runtime function will decode a UTF32 string into wchar
// elements. Used with a foreach loop of the form: foreach(i, wchar ; dchar[]).
int _aApplydw2(dchar[] input, apply_dg2_t loopBody) {
	mixin(_apply!(wchar, indexedApplyCode));
}

// Description: This runtime function will decode a UTF8 string into wchar
// elements. Used with a foreach_reverse loop of the form:
// foreach_reverse(wchar ; char[]).
int _aApplyRcw1(char[] input, apply_dg_t loopBody) {
	mixin(_apply!(wchar, applyReverseCode));
}

// Description: This runtime function will decode a UTF8 string into dchar
// elements. Used with a foreach_reverse loop of the form:
// foreach_reverse(dchar ; char[]).
int _aApplyRcd1(char[] input, apply_dg_t loopBody) {
	mixin(_apply!(dchar, applyReverseCode));
}

// Description: This runtime function will decode a UTF16 string into char
// elements. Used with a foreach_reverse loop of the form:
// foreach_reverse(char;: wchar[]).
int _aApplyRwc1(wchar[] input, apply_dg_t loopBody) {
	mixin(_apply!(char, applyReverseCode));
}

// Description: This runtime function will decode a UTF16 string into dchar
// elements. Used with a foreach_reverse loop of the form:
// foreach_reverse(dchar ; wchar[]).
int _aApplyRwd1(wchar[] input, apply_dg_t loopBody) {
	mixin(_apply!(dchar, applyReverseCode));
}

// Description: This runtime function will decode a UTF32 string into char
// elements. Used with a foreach_reverse loop of the form:
// foreach_reverse(char ; dchar[]).
int _aApplyRdc1(dchar[] input, apply_dg_t loopBody) {
	mixin(_apply!(char, applyReverseCode));
}

// Description: This runtime function will decode a UTF32 string into wchar
// elements. Used with a foreach_reverse loop of the form:
// foreach_reverse(wchar ; dchar[]).
int _aApplyRdw1(dchar[] input, apply_dg_t loopBody) {
	mixin(_apply!(wchar, applyReverseCode));
}

// Description: This runtime function will decode a UTF8 string into wchar
// elements. Used with a foreach_reverse loop of the form:
// foreach_reverse(i, wchar ; char[]).
int _aApplyRcw2(char[] input, apply_dg2_t loopBody) {
	mixin(_apply!(wchar, indexedApplyReverseCode));
}

// Description: This runtime function will decode a UTF8 string into dchar
// elements. Used with a foreach_reverse loop of the form:
// foreach_reverse(i, dchar ; char[]).
int _aApplyRcd2(char[] input, apply_dg2_t loopBody) {
	mixin(_apply!(dchar, indexedApplyReverseCode));
}

// Description: This runtime function will decode a UTF16 string into char
// elements. Used with a foreach_reverse loop of the form:
// foreach_reverse(i, char ; wchar[]).
int _aApplyRwc2(wchar[] input, apply_dg2_t loopBody) {
	mixin(_apply!(char, indexedApplyReverseCode));
}

// Description: This runtime function will decode a UTF16 string into dchar
// elements. Used with a foreach_reverse loop of the form:
// foreach_reverse(i, dchar ; wchar[]).
int _aApplyRwd2(wchar[] input, apply_dg2_t loopBody) {
	mixin(_apply!(dchar, indexedApplyReverseCode));
}

// Description: This runtime function will decode a UTF32 string into char
// elements. Used with a foreach_reverse loop of the form: 
// foreach_reverse(i, char ; dchar[]).
int _aApplyRdc2(dchar[] input, apply_dg2_t loopBody) {
	mixin(_apply!(char, indexedApplyReverseCode));
}

// Description: This runtime function will decode a UTF32 string into wchar
// elements. Used with a foreach_reverse loop of the form: 
// foreach_reverse(i, wchar ; dchar[]).
int _aApplyRdw2(dchar[] input, apply_dg2_t loopBody) {
	mixin(_apply!(wchar, indexedApplyReverseCode));
}

