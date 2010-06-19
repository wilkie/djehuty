/*
 * ti_tuple.d
 *
 * This module implements the TypeInfo for tuple types.
 *
 */

module runtime.typeinfos.ti_tuple;

class TypeInfo_Tuple : TypeInfo {
	TypeInfo[] elements;

	char[] toString() {
		char[] s;
		s = "(";
		foreach (i, element; elements) {
			if (i)
				s ~= ',';
			s ~= element.toString();
		}
		s ~= ")";
		return s;
	}

	int opEquals(Object o) {
		if (this is o)
			return 1;

		auto t = cast(TypeInfo_Tuple)o;
		if (t && elements.length == t.elements.length) {
			for (size_t i = 0; i < elements.length; i++) {
				if (elements[i] != t.elements[i])
					return 0;
			}
			return 1;
		}
		return 0;
	}

	hash_t getHash(void *p) {
		assert(0);
	}

	int equals(void *p1, void *p2) {
		assert(0);
	}

	int compare(void *p1, void *p2) {
		assert(0);
	}

	size_t tsize() {
		assert(0);
	}

	void swap(void *p1, void *p2) {
		assert(0);
	}
}

