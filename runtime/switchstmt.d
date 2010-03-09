/*
 * switchstmt.d
 *
 * This module implements the runtime functions that are responsible
 * for handling switch statements.
 *
 */

module runtime.switchstmt;

extern(C):

int _d_switch_string(char[][] table, char[] ca) {
	return 0;
}

int _d_switch_ustring(wchar[][] table, wchar[] ca) {
	return 0;
}

int _d_switch_dstring(dchar[][] table, dchar[] ca) {
	return 0;
}
