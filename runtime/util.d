module runtime.util;

int memcmp(void* a, void* b, size_t n) {
	ubyte* str_a = cast(ubyte*)a;
	ubyte* str_b = cast(ubyte*)b;

	for(size_t i = 0; i < n; i++) {
		if(*str_a != *str_b) {
			return *str_a - *str_b;
		}

		str_a++;
		str_b++;
	}

	return 0;
}

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

int isnan(real e) {
    ushort* pe = cast(ushort *)&e;
    ulong*  ps = cast(ulong *)&e;

    return (pe[4] & 0x7FFF) == 0x7FFF &&
	    *ps & 0x7FFFFFFFFFFFFFFF;
}

void memset(void *addr, int val, uint numBytes) {
	ubyte *data = cast(ubyte*) addr;

     for(int i = 0; i < numBytes; i++) {
          data[i] = cast(ubyte)val;
     }
}
