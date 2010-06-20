module runtime.util;

import runtime.types;

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
	ulong ud = cast(ulong)d;
	bool negative = false;

	int divisor = 10;

	// If %d is specified and D is minus, put `-' in the head.
	if(base == 'd' && d < 0) {
		negative = true;
		ud = cast(ulong)-d;
	}
	else if(base == 'x')
		divisor = 16;

	// Divide UD by DIVISOR until UD == 0.
	do {
		int remainder = cast(int)(ud % divisor);
		char nextChar;
		if (remainder < 10) {
			nextChar = remainder + '0';
		}
		else {
			nextChar = (remainder - 10) + 'a';
		}
		buf[p--] = nextChar;
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

	// Some uniformly distributed hash function
	// Reference: http://www.concentric.net/~Ttwang/tech/inthash.htm
	hash_t hash(hash_t value) {
		static if (hash_t.sizeof == 4) {
			// 32 bit hash function
			// The commented lines are equivalent to the following line

			int c2 = 0x27d4eb2d;	// A prime number or odd constant

			value = (value ^ 61) ^ (value >>> 16);

			// value = value * 9
			value = value + (value << 3);

			value = value ^ (value >>> 4);

			value = value * c2;

			value = value ^ (value >>> 15);

			return value;
		}
		else static if (hash_t.sizeof == 8) {
			// 64 bit hash function
			// The commented lines are equivalent to the following line

			// value = (value << 21) - value - 1;
			// NOTE: ~value == -value - 1
			value = ~value + (value << 21);

			value = value ^ (value >>> 24);

			// value = value * 265; // That is, value * (1 + 8 + 256)
			value = (value + (value >> 3)) + (value << 8);

			value = value ^ (value >>> 14);

			// value = value * 21; // That is, value * (1 + 4 + 16)
			value = (value + (value << 2)) + (value << 4);

			value = value ^ (value >>> 28);
			value = value + (value << 31);

			return value;
		}
		else {
			static assert(false, "Need a hash function.");
		}
	}

