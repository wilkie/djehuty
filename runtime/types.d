/*
 * types.d
 *
 * This module defines common language types.
 *
 */

module runtime.types;

// Figure out the size of a pointer
static if ((ubyte*).sizeof == 8) {
	alias ulong size_t;
	alias long ptrdiff_t;
	alias ulong hash_t;
}
else {
	alias uint size_t;
	alias int ptrdiff_t;
	alias uint hash_t;
}

// String types
alias char[] string;
alias wchar[] wstring;
alias dchar[] dstring;