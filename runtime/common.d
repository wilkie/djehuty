/*
 * common.d
 *
 * This module contains any common definitions.
 *
 */

module runtime.common;

extern(C):

package {
	struct Array {
		size_t length;
		byte* data;
	}

	struct aaA {
		aaA* left;
		aaA* right;
		hash_t hash;
		/* key */
		/* value */
	}

	struct BB {
		aaA*[] b;
		size_t nodes;
	}

	struct AA {
		BB* a;
	}

	alias long ArrayRet_t;
	extern(D) typedef int delegate(void*) aa_dg_t;
	extern(D) typedef int delegate(void*, void*) aa_dg2_t;
	extern(D) typedef int delegate(void*) array_dg_t;
	extern(D) typedef int delegate(void*, void*) array_dg2_t;

	enum BlkAttr : uint {
		FINALIZE = 0b0000_0001,
		NO_SCAN = 0b0000_0010,
		NO_MOVE = 0b0000_0100,
		ALL_BITS = 0b1111_1111
	}
}


