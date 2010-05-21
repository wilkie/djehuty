/*
 * types.d
 *
 * This module defines common language types.
 *
 */

module runtime.types;

// Figure out the size of a pointer
static if ((ubyte*).sizeof == 8) {
	version = Arch64;
}
else static if ((ubyte*).sizeof == 4) {
	version = Arch32;
}

// Pointer sizes
version(Arch32) {
	alias uint size_t;
	alias int ptrdiff_t;
	alias uint hash_t;
}
else {
	alias ulong size_t;
	alias long ptrdiff_t;
	alias ulong hash_t;
}

// String types
alias char[] string;
alias wchar[] wstring;
alias dchar[] dstring;
