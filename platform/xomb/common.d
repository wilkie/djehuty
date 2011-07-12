extern(C) void abort() {
}

extern(C)
double fmod(double a, double b) {
	return 0;
}

extern(C)
void _d_eh_personality() {
}

/**
This function copies data from a source piece of memory to a destination piece of memory.
	Params:
		dest = A pointer to the piece of memory serving as the copy destination.
		src = A pointer to the piece of memory serving as the copy source.
		count = The number of bytes to copy form src to dest.
	Returns: A void pointer to the start of the destination data (dest).
*/
extern(C) void* memcpy(void* dest, void* src, size_t count)
{
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
extern(C) void* memmove(void* dest, void* src, size_t count)
{
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
extern(C) int memcmp(void* a, void* b, size_t n)
{
	ubyte* str_a = cast(ubyte*)a;
	ubyte* str_b = cast(ubyte*)b;

	for(size_t i = 0; i < n; i++)
	{
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
extern(C) void memset(void *addr, int val, uint numBytes){
     ubyte *data = cast(ubyte*) addr;

     for(int i = 0; i < numBytes; i++){
          data[i] = cast(ubyte)val;
     }
}


