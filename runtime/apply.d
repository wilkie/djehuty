/*
 * apply.d
 *
 * This module implements the D runtime functions that involve UTF strings
 * and foreach or foreach_reverse loops.
 *
 */

module mindrt.array;

import mindrt.common;

extern(C):

// Description: This runtime function will decode a UTF8 string into wchar
// elements. Used with a foreach loop of the form: foreach(wchar ; char[]).
int _aApplycw1(char[] aa, array_dg_t dg) {
	return 0;
}

// Description: This runtime function will decode a UTF8 string into dchar
// elements. Used with a foreach loop of the form: foreach(dchar ; char[]).
int _aApplycd1(char[] aa, array_dg_t dg) {
	return 0;
}

// Description: This runtime function will decode a UTF16 string into char
// elements. Used with a foreach loop of the form: foreach(char;: wchar[]).
int _aApplywc1(wchar[] aa, array_dg_t dg) {
	return 0;
}

// Description: This runtime function will decode a UTF16 string into dchar
// elements. Used with a foreach loop of the form: foreach(dchar ; wchar[]).
int _aApplywd1(wchar[] aa, array_dg_t dg) {
	return 0;
}

// Description: This runtime function will decode a UTF32 string into char
// elements. Used with a foreach loop of the form: foreach(char ; dchar[]).
int _aApplydc1(dchar[] aa, array_dg_t dg) {
	return 0;
}

// Description: This runtime function will decode a UTF32 string into wchar
// elements. Used with a foreach loop of the form: foreach(wchar ; dchar[]).
int _aApplydw1(dchar[] aa, array_dg_t dg) {
	return 0;
}

// Description: This runtime function will decode a UTF8 string into wchar
// elements. Used with a foreach loop of the form: foreach(i, wchar ; char[]).
int _aApplycw2(char[] aa, array_dg2_t dg) {
	return 0;
}

// Description: This runtime function will decode a UTF8 string into dchar
// elements. Used with a foreach loop of the form: foreach(i, dchar ; char[]).
int _aApplycd2(char[] aa, array_dg2_t dg) {
	return 0;
}

// Description: This runtime function will decode a UTF16 string into char
// elements. Used with a foreach loop of the form: foreach(i, char ; wchar[]).
int _aApplywc2(wchar[] aa, array_dg2_t dg) {
	return 0;
}

// Description: This runtime function will decode a UTF16 string into dchar
// elements. Used with a foreach loop of the form: foreach(i, dchar ; wchar[]).
int _aApplywd2(wchar[] aa, array_dg2_t dg) {
	return 0;
}

// Description: This runtime function will decode a UTF32 string into char
// elements. Used with a foreach loop of the form: foreach(i, char ; dchar[]).
int _aApplydc2(dchar[] aa, array_dg2_t dg) {
	return 0;
}

// Description: This runtime function will decode a UTF32 string into wchar
// elements. Used with a foreach loop of the form: foreach(i, wchar ; dchar[]).
int _aApplydw2(dchar[] aa, array_dg2_t dg) {
	return 0;
}

// Description: This runtime function will decode a UTF8 string into wchar
// elements. Used with a foreach_reverse loop of the form:
// foreach_reverse(wchar ; char[]).
int _aApplyRcw1(char[] aa, array_dg_t dg) {
	return 0;
}

// Description: This runtime function will decode a UTF8 string into dchar
// elements. Used with a foreach_reverse loop of the form:
// foreach_reverse(dchar ; char[]).
int _aApplyRcd1(char[] aa, array_dg_t dg) {
	return 0;
}

// Description: This runtime function will decode a UTF16 string into char
// elements. Used with a foreach_reverse loop of the form:
// foreach_reverse(char;: wchar[]).
int _aApplyRwc1(wchar[] aa, array_dg_t dg) {
	return 0;
}

// Description: This runtime function will decode a UTF16 string into dchar
// elements. Used with a foreach_reverse loop of the form:
// foreach_reverse(dchar ; wchar[]).
int _aApplyRwd1(wchar[] aa, array_dg_t dg) {
	return 0;
}

// Description: This runtime function will decode a UTF32 string into char
// elements. Used with a foreach_reverse loop of the form:
// foreach_reverse(char ; dchar[]).
int _aApplyRdc1(dchar[] aa, array_dg_t dg) {
	return 0;
}

// Description: This runtime function will decode a UTF32 string into wchar
// elements. Used with a foreach_reverse loop of the form:
// foreach_reverse(wchar ; dchar[]).
int _aApplyRdw1(dchar[] aa, array_dg_t dg) {
	return 0;
}

// Description: This runtime function will decode a UTF8 string into wchar
// elements. Used with a foreach_reverse loop of the form:
// foreach_reverse(i, wchar ; char[]).
int _aApplyRcw2(char[] aa, array_dg2_t dg) {
	return 0;
}

// Description: This runtime function will decode a UTF8 string into dchar
// elements. Used with a foreach_reverse loop of the form:
// foreach_reverse(i, dchar ; char[]).
int _aApplyRcd2(char[] aa, array_dg2_t dg) {
	return 0;
}

// Description: This runtime function will decode a UTF16 string into char
// elements. Used with a foreach_reverse loop of the form:
// foreach_reverse(i, char ; wchar[]).
int _aApplyRwc2(wchar[] aa, array_dg2_t dg) {
	return 0;
}

// Description: This runtime function will decode a UTF16 string into dchar
// elements. Used with a foreach_reverse loop of the form:
// foreach_reverse(i, dchar ; wchar[]).
int _aApplyRwd2(wchar[] aa, array_dg2_t dg) {
	return 0;
}

// Description: This runtime function will decode a UTF32 string into char
// elements. Used with a foreach_reverse loop of the form: 
// foreach_reverse(i, char ; dchar[]).
int _aApplyRdc2(dchar[] aa, array_dg2_t dg) {
	return 0;
}

// Description: This runtime function will decode a UTF32 string into wchar
// elements. Used with a foreach_reverse loop of the form: 
// foreach_reverse(i, wchar ; dchar[]).
int _aApplyRdw2(dchar[] aa, array_dg2_t dg) {
	return 0;
}

char[] _adSortChar(char[] a) {
	return null;
}

wchar[] _adSortWchar(wchar[] a) {
	return null;
}
