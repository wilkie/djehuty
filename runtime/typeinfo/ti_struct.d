/*
 * ti_struct.d
 *
 * This module implements the TypeInfo for struct types.
 *
 */

module runtime.typeinfo.ti_struct;

class TypeInfo_Struct : TypeInfo {
	char[] toString() {
		return name;
	}

	int opEquals(Object o) {
		TypeInfo_Struct s;

		return this is o ||
				((s = cast(TypeInfo_Struct)o) !is null &&
				 this.name == s.name &&
				 this.init.length == s.init.length);
	}

	hash_t getHash(void *p) {
		hash_t h;

		assert(p);
		if (xtoHash) {
			h = (*xtoHash)(p);
		}
		else {
			//printf("getHash() using default hash\n");
			// A sorry hash algorithm.
			// Should use the one for strings.
			// BUG: relies on the GC not moving objects
			for (size_t i = 0; i < init.length; i++) {
				h = h * 9 + *cast(ubyte*)p;
				p++;
			}
		}
		return h;
	}

	int equals(void *p2, void *p1) {
		int c;

		if (p1 == p2)
			c = 1;
		else if (!p1 || !p2)
			c = 0;
		else if (xopEquals)
			c = (*xopEquals)(p1, p2);
		else
			// BUG: relies on the GC not moving objects
			c = (memcmp(cast(ubyte*)p1, cast(ubyte*)p2, init.length) == 0);
		return c;
	}

	int compare(void *p2, void *p1) {
		int c = 0;

		// Regard null references as always being "less than"
		if (p1 != p2) {
			if (p1) {
				if (!p2)
					c = 1;
				else if (xopCmp)
					c = (*xopCmp)(p1, p2);
				else
					// BUG: relies on the GC not moving objects
					c = memcmp(cast(ubyte*)p1, cast(ubyte*)p2, init.length);
			}
			else
				c = -1;
		}
		return c;
	}

	size_t tsize() {
		return init.length;
	}

	void[] init() {
		return m_init;
	}

	uint flags() {
		return m_flags;
	}

	char[] name;
	void[] m_init;		// initializer; init.ptr == null if 0 initialize

	hash_t function(void*) xtoHash;
	int function(void*,void*) xopEquals;
	int function(void*,void*) xopCmp;
	char[] function(void*) xtoString;

	uint m_flags;
}


