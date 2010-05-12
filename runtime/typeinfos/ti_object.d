/*
 * ti_object.d
 *
 * This module implements the TypeInfo for a class reference.
 *
 */

module runtime.typeinfos.ti_object;

class TypeInfo_Class : TypeInfo {
	hash_t getHash(void *p) {
		Object o = *cast(Object*)p;
		assert(o);
		return o.toHash();
	}

	int equals(void *p1, void *p2) {
		Object o1 = *cast(Object*)p1;
		Object o2 = *cast(Object*)p2;

		return o1 == o2;
	}

	int compare(void *p1, void *p2) {
		Object o1 = *cast(Object*)p1;
		Object o2 = *cast(Object*)p2;
		int c = 0;

		// Regard null references as always being "less than"
		if (!(o1 is o2)) {
			if (o1) {
				if (!o2) {
					c = 1;
				}
				else {
					c = o1.opCmp(o2);
				}
			}
			else {
				c = -1;
			}
		}

		return c;
	}

	size_t tsize() {
		return Object.sizeof;
	}

	uint flags() {
		return 1;
	}
}
