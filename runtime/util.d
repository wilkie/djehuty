/*
 * util.d
 *
 * This module contains helpful functions found necessary by the runtime and gcc.
 * contains: itoa, memcpy, memset, memmove, memcmp, strlen, isnan, toString
 *
 */

module runtime.util;

version(LDC) {
	private import ldc.intrinsics;

	version(LLVM64) {
		alias llvm_memcpy_i64 llvm_memcpy;
	}
	else {
		alias llvm_memcpy_i32 llvm_memcpy;
	}
}

/**
This function converts an integer to a string, depending on the base passed in.
	Params:
		buf = The function will save the translated string into this character array.
		base = The base of the integer value. If "d," it will be assumed to be decimal. If "x," the integer
			will be hexadecimal.
		d = The integer to translate.
	Returns: The translated string in a character array.
*/
char[] itoa(char[] buf, char base, long d) {
	size_t p = buf.length - 1;
	size_t startIdx = 0;
	ulong ud = d;
	bool negative = false;

	int divisor = 10;

	// If %d is specified and D is minus, put `-' in the head.
	if(base == 'd' && d < 0) {
		negative = true;
		ud = -d;
	}
	else if(base == 'x')
		divisor = 16;

	// Divide UD by DIVISOR until UD == 0.
	do {
		int remainder = ud % divisor;
		buf[p--] = (remainder < 10) ? remainder + '0' : remainder + 'a' - 10;
	}
	while (ud /= divisor)

	if(negative)
		buf[p--] = '-';

	return buf[p + 1 .. $];
}

/**
This function copies data from a source piece of memory to a destination piece of memory.
	Params:
		dest = A pointer to the piece of memory serving as the copy destination.
		src = A pointer to the piece of memory serving as the copy source.
		count = The number of bytes to copy form src to dest.
	Returns: A void pointer to the start of the destination data (dest).
*/
extern(C) void* memcpy(void* dest, void* src, size_t count) {
	//version(LDC)
	//{
	//	llvm_memcpy(dest, src, count, 0);
	//	return dest;
	//}
	//else
	{
		ubyte* d = cast(ubyte*)dest;
		ubyte* s = cast(ubyte*)src;

		for(size_t i = count; count; count--, d++, s++)
			*d = *s;

		return dest;
	}
}

/**
Memcpy and memmove only really have differences at the user level, where they have slightly
different semantics.  Here, they're pretty much the same.
*/
extern(C) void* memmove(void* dest, void* src, size_t count) {
	ubyte* d = cast(ubyte*)dest;
	ubyte* s = cast(ubyte*)src;

	for(size_t i = count; count; count--, d++, s++)
	  *d = *s;

	return dest;
}

/**
Compare two blocks of memory.

Params:
	a = Pointer to the first block.
	b = Pointer to the second block.
	n = The number of bytes to compare.

Returns:
	 0 if they are equal, < 0 if a is less than b, and > 0 if a is greater than b.
*/
extern(C) int memcmp(void* a, void* b, size_t n) {
	ubyte* str_a = cast(ubyte*)a;
	ubyte* str_b = cast(ubyte*)b;

	for(size_t i = 0; i < n; i++) {
		if(*str_a != *str_b)
			return *str_a - *str_b;

		str_a++;
		str_b++;
	}

	return 0;
}

/**
This function sets a particular piece of memory to a particular value.
	Params:
		addr = The address of the piece of memory you wish to write.
		val = The value you wish to write to memory.
		numBytes = The number of bytes you would like to write to memory.
*/
extern(C) void memset(void *addr, int val, uint numBytes) {
     ubyte *data = cast(ubyte*) addr;

     for(int i = 0; i < numBytes; i++){
          data[i] = cast(ubyte)val;
     }
}

/**
This function determines the size of a passed-in string.
	Params:
		s = A pointer to the beginning of a character array, declaring a string.
	Returns: The size of the string in size_t format.
*/
size_t strlen(char* s) {
	size_t i = 0;
	for( ; *s != 0; i++, s++){}
	return i;
}

/**
This function takes in a character pointer and returns a character array, or a string.
	Params:
		s = A pointer to the character(s) you wish to translate to a string.
	Returns: A character array (string) containing the information.
*/
char[] toString(char* s) {
	return s[0 .. strlen(s)];
}

/**
This function checks to see if a floating point number is a NaN.
	Params:
		e = The value / piece of information you would like to check for number status.
	Returns:
		0 if it isn't a NaN, non-zero if it is.
*/
int isnan(real e) {
    ushort* pe = cast(ushort *)&e;
    ulong*  ps = cast(ulong *)&e;

    return (pe[4] & 0x7FFF) == 0x7FFF &&
	    *ps & 0x7FFFFFFFFFFFFFFF;
}
