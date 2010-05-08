/*
 * common.d
 *
 * This module contains any common definitions.
 *
 */

module runtime.common;

extern(C):

package {
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

	enum BlkAttr : uint {
		FINALIZE = 0b0000_0001,
		NO_SCAN = 0b0000_0010,
		NO_MOVE = 0b0000_0100,
		ALL_BITS = 0b1111_1111
	}
}


