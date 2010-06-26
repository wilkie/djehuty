/*
 * atomic.d
 *
 * This module implements atomic operations.
 *
 * Date Originated: April 21st, 2010
 */

module synch.atomic;

import io.console;

class Atomic {
static:

	// Description: This function will atomically compare two values and set one if the two values are equal.
	// reference: The value to update atomically with exchange.
	// compare: Will be compared to reference. If equal, reference will be updated with exchange.
	// exchange: This value will be written to reference if the comparison is equal.
	// Returns: Whether or not the exchange occurred.
	template compareExchange(T) {
		bool compareExchange(ref T reference, T compare, T exchange) {
			static if (is(T : Object) || is(T : void*)) {
				static if ((void*).sizeof == 4) {
					return compareExchangeI(cast(uint*)&reference, compare, exchange);
				}
				else static if ((void*).sizeof == 8) {
					return compareExchangeL(cast(ulong*)&reference, compare, exchange);
				}
			}
			else static if (is(T == ubyte) || is(T == byte)) {
				return compareExchangeB(cast(ubyte*)&reference, compare, exchange);
			}
			else static if (is(T == ushort) || is(T == short)) {
				return compareExchangeS(cast(ushort*)&reference, compare, exchange);
			}
			else static if (is(T == uint) || is(T == int)) {
				return compareExchangeI(cast(uint*)&reference, compare, exchange);
			}
			else static if (is(T == ulong) || is(T == long)) {
				return compareExchangeL(cast(ulong*)&reference, compare, exchange);
			}
			else static if (is(T == float)) {
				return compareExchangeF(&reference, compare, exchange);
			}
			else static if (is(T == double)) {
				return compareExchangeD(&reference, compare, exchange);
			}
			else {
				static assert(false, "compareExchange is not implemented for this type");
			}
		}
	}

	// Implementations:

	/*
	bool compareExchange(ulong* reference, ulong compare, ulong exchange) {
		version(X86_64) {
			asm {
				naked;

				// x86-64 ABI:	&reference = RDI, compare = RSI, exchange = RDX
				//				return value = RAX

				// cmpxchg r/m64 r64:	compares first op with RAX,
				//						if equal, set first op with second op
				//						otherwise, set RAX to first op

				mov RAX, RSI;			// set RAX to compare

				lock;					// ensure atomicity
				cmpxchg [RDI], RDX;		// perform compare exchange

				// Afterward, RAX will still be compare if the update occurred
				// otherwise, RAX will be the reference value.

				// set RAX to be 0 when the update did not occur, 1 otherwise
				xor RAX, RSI;
				not RAX;

				ret;					// return RAX
			}
		}
	}
		*/

		private {
			bool compareExchangeF(float* reference, float compare, float exchange) {
				version(X86_64) {
					asm {
						naked;

						mov RAX, XMM0;
						mov RDX, XMM1;

						lock;
						cmpxchg [RDI], EDX;

						mov RDX, XMM0;
						cmp RAX, RDX;
						sete AL;

						ret;
					}
				}
				else version(X86) {
					asm {
						naked;

						// Stack:

						// ESP
						// |
						// |RA |exc|cmp|ref|
						//    +4  +8  +12 +16 +20

						mov ECX, [ESP+4];		// assign ECX to exchange

						mov EAX, [ESP+8];		// assign accumulator to compare

						mov EDX, [ESP+12];		// get pointer to reference

						cmpxchg [EDX], ECX;

						// Afterward, EAX will still be compare if the update occurred
						// otherwise, EAX will be the reference value.

						// set EAX to be 0 when the update did not occur, 1 otherwise
						cmp EAX, [ESP+4];
						sete AL;

						ret 12;				// return EAX (and subtract 8 from stack)
					}
				}
				else {
					static assert(false, "compareExchange is not implemented on this architecture");
				}
			}

			bool compareExchangeI(uint* reference, uint compare, int exchange) {
				version(X86_64) {
					asm {
						naked;

						mov RAX, RSI;

						lock;
						cmpxchg [RDI], EDX;

						cmp RAX, RSI;
						sete AL;

						ret;
					}
				}
				else version(X86) {
					asm {
						naked;

						// Stack:

						// ESP
						// |
						// |RA |cmp|ref|
						//    +4  +8  +12 +16 +20
						//
						// EAX = exchange (last parameter gets put into EAX)

						mov ECX, EAX;			// assign ECX to exchange

						mov EAX, [ESP+4];		// assign accumulator to compare

						mov EDX, [ESP+8];

						cmpxchg [EDX], ECX;

						// Afterward, EAX will still be compare if the update occurred
						// otherwise, EAX will be the reference value.

						// set EAX to be 0 when the update did not occur, 1 otherwise
						cmp EAX, [ESP+4];
						sete AL;

						ret 8;				// return EAX (and subtract 8 from stack)
					}
				}
				else {
					static assert(false, "compareExchange is not implemented on this architecture");
				}
			}

			bool compareExchangeD(double* reference, double compare, double exchange) {
				version(X86_64) {
					asm {
						naked;

						mov RAX, XMM0;
						mov RDX, XMM1;

						lock;
						cmpxchg [RDI], RDX;

						mov RDX, XMM0;
						cmp RAX, RDX;
						sete AL;

						ret;
					}
				}
				else version(X86) {
					asm {
						naked;

						// Must preserve:

						push EBX;
						push ESI;

						// Stack:

						// ESP
						// |
						// |RA |EBX|ESI|ex1|ex2|cm1|cm2|ref|
						//    +4  +8  +12 +16 +20 +24 +28

						mov EDX, [ESP+24];	// assign EDX:EAX to compare
						mov EAX, [ESP+20];

						mov ECX, [ESP+16];	// assign ECX:EBX to exchange
						mov EBX, [ESP+12];
						
						mov ESI, [ESP+28];

						// Um. DMD bug. cmpxch8b is not the correct opcode, but oh well.
						cmpxch8b [ESI];		// perform compare exchange

						// Afterward, EDX:EAX will stil be compare if the update occurred
						// otherwise, EDX:EAX will be the reference value.

						// set EAX to be 0 when the update did not occur, 1 otherwise
						xor EDX, [ESP+12];
						xor EAX, [ESP+16];
						and EAX, EDX;
						not EAX;

						pop ESI;			// reclaim old ESI
						pop EBX;			// reclaim old EBX

						ret 20;				// return EAX (and subtract 20 from stack)
					}
				}
				else {
					static assert(false, "compareExchange is not implemented on this architecture");
				}
			}

			bool compareExchangeL(ulong* reference, ulong compare, ulong exchange) {
				version(X86_64) {
					asm {
						naked;

						mov RAX, RSI;

						lock;
						cmpxchg [RDI], RDX;

						cmp RAX, RSI;
						sete AL;

						ret;
					}
				}
				else version(X86) {
					asm {
						naked;

						// Must preserve:

						push EBX;
						push ESI;

						// Stack:

						// ESP
						// |
						// |RA |EBX|ESI|ex1|ex2|cm1|cm2|ref|
						//    +4  +8  +12 +16 +20 +24 +28

						mov EDX, [ESP+24];	// assign EDX:EAX to compare
						mov EAX, [ESP+20];

						mov ECX, [ESP+16];	// assign ECX:EBX to exchange
						mov EBX, [ESP+12];
						
						mov ESI, [ESP+28];

						// Um. DMD bug. cmpxch8b is not the correct opcode, but oh well.
						cmpxch8b [ESI];		// perform compare exchange

						// Afterward, EDX:EAX will stil be compare if the update occurred
						// otherwise, EDX:EAX will be the reference value.

						// set EAX to be 0 when the update did not occur, 1 otherwise
						xor EDX, [ESP+12];
						xor EAX, [ESP+16];
						and EAX, EDX;
						not EAX;

						pop ESI;			// reclaim old ESI
						pop EBX;			// reclaim old EBX

						ret 20;				// return EAX (and subtract 20 from stack)
					}
				}
				else {
					static assert(false, "compareExchange is not implemented on this architecture");
				}
			}

			bool compareExchangeB(ubyte* reference, ubyte compare, ubyte exchange) {
				version(X86_64) {
					asm {
						naked;

						mov RAX, RSI;

						lock;
						cmpxchg [RDI], DL;

						cmp RAX, RSI;
						sete AL;

						ret;
					}
				}
				else version(X86) {
					asm {
						naked;

						// Stack:

						// ESP
						// |
						// |RA |cmp|ref|
						//    +4  +8  +12 +16 +20
						//
						// AX = exchange (last parameter gets put into EAX)

						mov CL, AL;				// assign ECX to exchange

						mov AL, [ESP+4];		// assign accumulator to compare

						mov EDX, [ESP+8];		// get pointer to reference

						cmpxchg [EDX], CL;

						// Afterward, EAX will still be compare if the update occurred
						// otherwise, EAX will be the reference value.

						// set EAX to be 0 when the update did not occur, 1 otherwise
						cmp AL, [ESP+4];
						sete AL;

						ret 8;				// return EAX (and subtract 8 from stack)
					}
				}
				else {
					static assert(false, "compareExchange is not implemented on this architecture");
				}
			}

			bool compareExchangeS(ushort* reference, ushort compare, ushort exchange) {
				version(X86_64) {
					asm {
						naked;

						mov RAX, RSI;

						lock;
						cmpxchg [RDI], DX;

						cmp RAX, RSI;
						sete AL;

						ret;
					}
				}
				else version(X86) {
					asm {
						naked;

						// Stack:

						// ESP
						// |
						// |RA |cmp|ref|
						//    +4  +8  +12 +16 +20
						//
						// AX = exchange (last parameter gets put into EAX)

						mov CX, AX;				// assign ECX to exchange

						mov AX, [ESP+4];		// assign accumulator to compare

						mov EDX, [ESP+8];		// get pointer to reference

						cmpxchg [EDX], CX;

						// Afterward, EAX will still be compare if the update occurred
						// otherwise, EAX will be the reference value.

						// set EAX to be 0 when the update did not occur, 1 otherwise
						cmp AX, [ESP+4];
						sete AL;

						ret 8;				// return EAX (and subtract 8 from stack)
					}
				}
				else {
					static assert(false, "compareExchange is not implemented on this architecture");
				}
			}
		}

	void increment(ref ulong reference) {
		version(X86_64) {
			asm {
				naked;
				lock;
				inc [RDI];
				ret;
			}
		}
		else {
			// Atomic Increment (using compareExchange)
			add(reference, cast(ulong)1);
		}
	}

	void increment(ref uint reference) {
		version(X86_64) {
			asm {
				naked;
				lock;
				inc [RDI];
				ret;
			}
		}
		else {
			// Atomic Increment (using compareExchange)
			add(reference, cast(uint)1);
		}
	}

	void decrement(ref ulong reference) {
		version(X86_64) {
			asm {
				naked;
				lock;
				dec [RDI];
				ret;
			}
		}
		else {
			// Atomic Decrement (using compareExchange)
			add(reference, cast(ulong)(-1));
		}
	}

	void decrement(ref uint reference) {
		version(X86_64) {
			asm {
				naked;
				lock;
				dec [RDI];
				ret;
			}
		}
		else {
			// Atomic Decrement (using compareExchange)
			add(reference, cast(uint)(-1));
		}
	}

	void or(ref ulong reference, ulong value) {
		version(X86_64) {
			asm {
				naked;
				lock;
				or [RDI], RSI;
				ret;
			}
		}
		else {
			// Atomic Or (using compareExchange)
			ulong oldVal;
			ulong newVal;
			for(;;) {
				oldVal = reference;
				newVal = oldVal | value;
				if (compareExchange(reference, oldVal, newVal)) {
					return;
				}
			}			
		}
	}

	void and(ref ulong reference, ulong value) {
		version(X86_64) {
			asm {
				naked;
				lock;
				and [RDI], RSI;
				ret;
			}
		}
		else {
			// Atomic And (using compareExchange)
			ulong oldVal;
			ulong newVal;
			for(;;) {
				oldVal = reference;
				newVal = oldVal & value;
				if (compareExchange(reference, oldVal, newVal)) {
					return;
				}
			}			
		}
	}

	void bitComplement(ref ulong reference, byte bit) {
		version(X86_64) {
			asm {
				naked;
				lock;
				btc [RDI], RSI;
				ret;
			}
		}
		else {
			// Atomic Not (using compareExchange)
			ulong oldVal;
			ulong newVal;

			ulong setMask = 1 << bit;
			ulong clearMask = ~setMask;

			for(;;) {
				oldVal = reference;

				// complement it on the old value
				if (oldVal & setMask) {
					// bit is set
					newVal = oldVal & clearMask;
				}
				else {
					// bit is clear
					newVal = oldVal | setMask;
				}

				if (compareExchange(reference, oldVal, newVal)) {
					return;
				}
			}			
		}
	}

	void bitClear(ref ulong reference, byte bit) {
		version(X86_64) {
			asm {
				naked;
				lock;
				btr [RDI], RSI;
				ret;
			}
		}
		else {
			// Atomic Bit Clear (using compareExchange)
			ulong mask = ~(1 << bit);
			and(reference, mask);
		}
	}

	void bitSet(ref ulong reference, byte bit) {
		version(X86_64) {
			asm {
				naked;
				lock;
				bts [RDI], RSI;
				ret;
			}
		}
		else {
			// Atomic Bit Set (using compareExchange)
			ulong mask = 1 << bit;
			or(reference, mask);
		}
	}

	void not(ref ulong reference) {
		version(X86_64) {
			asm {
				naked;
				lock;
				not [RDI];
				ret;
			}
		}
		else {
			// Atomic Not (using compareExchange)
			ulong oldVal;
			ulong newVal;
			for(;;) {
				oldVal = reference;
				newVal = ~oldVal;
				if (compareExchange(reference, oldVal, newVal)) {
					return;
				}
			}			
		}
	}

	void xor(ref ulong reference, ulong value) {
		version(X86_64) {
			asm {
				naked;
				lock;
				xor [RDI], RSI;
				ret;
			}
		}
		else {
			// Atomic Xor (using compareExchange)
			ulong oldVal;
			ulong newVal;
			for(;;) {
				oldVal = reference;
				newVal = oldVal ^ value;
				if (compareExchange(reference, oldVal, newVal)) {
					return;
				}
			}			
		}
	}

	void add(ref ulong reference, ulong value) {
		version(X86_64) {
			asm {
				naked;
				lock;
				xadd [RDI], RSI;
				ret;
			}
		}
		else {
			// Atomic Addition (using compareExchange)
			ulong oldVal;
			ulong newVal;
			for(;;) {
				oldVal = reference;
				newVal = oldVal + value;
				if (compareExchange(reference, oldVal, newVal)) {
					return;
				}
			}
		}
	}

	void add(ref uint reference, uint value) {
		version(X86_64) {
			asm {
				naked;
				lock;
				xadd [RDI], RSI;
				ret;
			}
		}
		else {
			// Atomic Addition (using compareExchange)
			uint oldVal;
			uint newVal;
			for(;;) {
				oldVal = reference;
				newVal = oldVal + value;
				if (compareExchange(reference, oldVal, newVal)) {
					return;
				}
			}
		}
	}

	// Description: This function will atomically update the value of reference with that of exchange.
	// reference: The value to update.
	// exchange: The value to update with.
	// Returns: The old value of reference.
	ulong exchange(ref ulong reference, ulong exchange) {
		version(X86_64) {
			asm {
				naked;

				lock;				// this should not be necessary
				xchg [RDI], RSI;	// perform the exchange

				mov RAX, RSI;		// return old value
				ret;				// return
			}
		}
		else {
			// Atomic Assignment (using compareExchange)
			ulong oldVal;
			ulong newVal;
			for(;;) {
				oldVal = reference;
				newVal = exchange;
				if (compareExchange(reference, oldVal, newVal)) {
					return oldVal;
				}
			}
		}
	}
}
