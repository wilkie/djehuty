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

	// Description: This function will atomically update the value of reference with that of exchange.
	// reference: The value to update.
	// exchange: The value to update with.
	void exchange(ref ulong reference, ulong exchange) {
		version(X86_64) {
			asm {
				naked;

				lock;				// this should not be necessary
				xchg [RDI], RSI;	// perform the exchange

				xor RAX, RAX;		// uphold return 0 invariant
				ret;				// return
			}
		}
		else version(X86) {
			compareExchange(reference, reference, exchange);
		}
		else {
		}
	}
}
