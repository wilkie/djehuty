/*
 * switchstmt.d
 *
 * This module implements the runtime functions that are responsible
 * for handling switch statements.
 *
 */

module runtime.switchstmt;

private template _switch_string(T) {
	int _switch_string(T[][] table, T[] compare) {
		if (table.length == 0) {
			return -1;
		}

		// Optimization for empty string, it must be first in sorted table
		if (compare.length == 0) {
			if (table[0] == compare) {
				return 0;
			}
			return -1;
		}

		TypeInfo ti = typeid(T[]);

		// Binary search the table
		size_t min = 0;
		size_t max = table.length;

		// Current comparing position
		size_t cur; // midpoint

		// Temp for compare value
		int cmp;

		while(max > min) {
			cur = (max + min) / 2;
			if (table[cur].length == compare.length) {
				cmp = ti.compare(&table[cur], &compare);
			}
			else {
				cmp = table[cur].length - compare.length;
			}

			if (cmp == 0) {
				return cur;
			}
			else if (cmp > 0) {
				max = cur;
			}		
			else {
				min = cur + 1;
			}
		}

		return -1;
	}
}

extern(C):

// Description: This runtime function will search the given sorted list of
//   UTF8 strings and locate the string given.
// Returns: The index into table where the given string was located and -1
//   if it was not found.
int _d_switch_string(char[][] table, char[] compare) {
	return _switch_string(table, compare);
}

// Description: This runtime function will search the given sorted list of
//   UTF16 strings and locate the string given.
// Returns: The index into table where the given string was located and -1
//   if it was not found.
int _d_switch_ustring(wchar[][] table, wchar[] compare) {
	return _switch_string(table, compare);
}

// Description: This runtime function will search the given sorted list of
//   UTF32 strings and locate the string given.
// Returns: The index into table where the given string was located and -1
//   if it was not found.
int _d_switch_dstring(dchar[][] table, dchar[] compare) {
	return _switch_string(table, compare);
}
