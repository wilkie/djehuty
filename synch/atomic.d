/*
 * atomic.d
 *
 * This module implements atomic operations.
 *
 * Date Originated: April 21st, 2010
 */

module synch.atomic;

class Atomic {
static:

	// Description: This function will atomically compare two values and set one if the two values are equal.
	// reference: The value to update atomically with exchange.
	// compare: Will be compared to reference. If equal, reference will be updated with exchange.
	// exchange: This value will be written to reference if the comparison is equal.
	// Returns: Whether or not the exchange occurred.
	template compareExchange(T) {
		bool compareExchange(ref T reference, T compare, T exchange) {
			asm {
				naked;
			}
			static if (is(T : Object) || is(T : void*)) {
				static if ((void*).sizeof == 4) {
					asm {
						jmp compareExchangeI;
					}
				}
				else static if ((void*).sizeof == 8) {
					asm {
						jmp compareExchangeL;
					}
				}
			}
			else static if (is(T : ubyte) || is(T : byte)) {
				asm {
					jmp compareExchangeB;
				}
			}
			else static if (is(T : ushort) || is(T : short)) {
				asm {
					jmp compareExchangeS;
				}
			}
			else static if (is(T : uint) || is(T : int)) {
				asm {
					jmp compareExchangeI;
				}
			}
			else static if (is(T : ulong) || is(T : long)) {
				asm {
					jmp compareExchangeL;
				}
			}
			else static if (is(T : float)) {
				asm {
					jmp compareExchangeF;
				}
			}
			else static if (is(T : double)) {
				asm {
					jmp compareExchangeD;
				}
			}
			else {
				static assert(false, "compareExchange is not implemented for this type");
			}
		}
	}

	// Implementations:
	
	/*
	bool compareExchange(ref ulong reference, ulong compare, ulong exchange) {
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
		*/

		private {
			bool compareExchangeF(ref float reference, float compare, float exchange) {
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
						ret;
					}
				}
				else {
					static assert(false, "compareExchange is not implemented on this architecture");
				}
			}

			bool compareExchangeI(ref int reference, int compare, int exchange) {
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
						ret;
					}
				}
				else {
					static assert(false, "compareExchange is not implemented on this architecture");
				}
			}

			bool compareExchangeD(ref double reference, double compare, double exchange) {
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
						ret;
					}
				}
				else {
					static assert(false, "compareExchange is not implemented on this architecture");
				}
			}

			bool compareExchangeL(ref long reference, long compare, long exchange) {
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
						ret;
					}
				}
				else {
					static assert(false, "compareExchange is not implemented on this architecture");
				}
			}

			bool compareExchangeB(ref byte reference, byte compare, byte exchange) {
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
						ret;
					}
				}
				else {
					static assert(false, "compareExchange is not implemented on this architecture");
				}
			}

			bool compareExchangeS(ref short reference, byte compare, byte exchange) {
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
						ret;
					}
				}
				else {
					static assert(false, "compareExchange is not implemented on this architecture");
				}
			}
		}
/*
bool compareExchange(ref ulong reference, ulong compare, ulong exchange) {
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
else version(X86) {
asm {
naked;

		// x86 ABI:		&reference = ESP+24, compare = ESP+20:ESP+16, exchange = ESP+12:ESP+8
		//				return value = EAX

		// The extra 8 bytes are for the preservation of EBX and ESI

		// cmpxchg8b m64:	compares first op with EDX:EAX
		//					if equal, set first op with ECX:EBX
		//					otherwise, set EDX:EAX with first op

		push ESI;			// preserve ESI (for D ABI)
		push EBX;			// preserve EBX (for D ABI)

				mov EDX, [ESP+20];	// assign EDX:EAX to compare
				mov EAX, [ESP+16];

				mov ECX, [ESP+12];	// assign ECX:EBX to exchange
				mov EBX, [ESP+8];

				mov ESI, [ESP+24];	// assign ESI to pointer for reference

				// Um. DMD bug. cmpxch8b is not the correct opcode, but oh well.
				cmpxch8b [ESI];		// perform compare exchange

				// Afterward, EDX:EAX will stil be compare if the update occurred
				// otherwise, EDX:EAX will be the reference value.

				// set EAX to be 0 when the update did not occur, 1 otherwise
				xor EDX, [ESP+20];
				xor EAX, [ESP+16];
				and EAX, EDX;
				not EAX;

				pop EBX;			// reclaim old EBX
				pop ESI;			// reclaim old ESI

				ret;				// return EAX
			}
		}
		else {
			return false;
		}
	}
*/

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
			add(reference, 1);
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
