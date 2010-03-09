/*
 * switchstmt.d
 *
 * This module implements the runtime functions that are responsible
 * for handling switch statements.
 *
 */

module runtime.switchstmt;

extern(C):

// Description: This runtime function will search the given sorted list of
//   UTF8 strings and locate the string given.
// Returns: The index into table where the given string was located and -1
//   if it was not found.
int _d_switch_string(char[][] table, char[] ca) {
	return 0;
}

// Description: This runtime function will search the given sorted list of
//   UTF16 strings and locate the string given.
// Returns: The index into table where the given string was located and -1
//   if it was not found.
int _d_switch_ustring(wchar[][] table, wchar[] ca) {
	return 0;
}

// Description: This runtime function will search the given sorted list of
//   UTF32 strings and locate the string given.
// Returns: The index into table where the given string was located and -1
//   if it was not found.
int _d_switch_dstring(dchar[][] table, dchar[] ca) {
	return 0;
}
