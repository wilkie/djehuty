/*
 * ti_interface.d
 *
 * This module implements the TypeInfo for interfaces.
 *
 */

module runtime.typeinfos.ti_interface;

class TypeInfo_Interface : TypeInfo {
	char[] toString() {
		return info.name;
	}

	int opEquals(Object o) {
		TypeInfo_Interface c;

		return this is o ||
				((c = cast(TypeInfo_Interface)o) !is null &&
				 this.info.name == c.classinfo.name);
	}

	hash_t getHash(void *p) {
		Interface* pi = **cast(Interface ***)*cast(void**)p;
		Object o = cast(Object)(*cast(void**)p - pi.offset);
		assert(o);
		return o.toHash();
	}

	int equals(void *p1, void *p2) {
		Interface* pi = **cast(Interface ***)*cast(void**)p1;
		Object o1 = cast(Object)(*cast(void**)p1 - pi.offset);
		pi = **cast(Interface ***)*cast(void**)p2;
		Object o2 = cast(Object)(*cast(void**)p2 - pi.offset);

		return o1 == o2 || (o1 && o1.opCmp(o2) == 0);
	}

	int compare(void *p1, void *p2) {
		Interface* pi = **cast(Interface ***)*cast(void**)p1;
		Object o1 = cast(Object)(*cast(void**)p1 - pi.offset);
		pi = **cast(Interface ***)*cast(void**)p2;
		Object o2 = cast(Object)(*cast(void**)p2 - pi.offset);
		int c = 0;

		// Regard null references as always being "less than"
		if (o1 != o2) {
			if (o1) {
				if (!o2)
					c = 1;
				else
					c = o1.opCmp(o2);
			}
			else
				c = -1;
		}
		return c;
	}

	size_t tsize() {
		return Object.sizeof;
	}

	uint flags() {
		return 1;
	}

	ClassInfo info;
}


