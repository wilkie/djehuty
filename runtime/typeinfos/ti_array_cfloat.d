/*
 * ti_array_cfloat.d
 *
 * This module implements the TypeInfo for a cfloat[]
 *
 */

module runtime.typeinfos.ti_array_cfloat;

import runtime.typeinfos.ti_cfloat;

class TypeInfo_Aq : TypeInfo {
	char[] toString() {
		return "cfloat[]";
	}

	hash_t getHash(void *p) {
		cfloat[] s = *cast(cfloat[]*)p;
		size_t len = s.length;
		cfloat *str = s.ptr;
		hash_t hash = 0;

		while (len) {
			hash *= 9;
			hash += (cast(uint *)str)[0];
			hash += (cast(uint *)str)[1];
			str++;
			len--;
		}

		return hash;
	}

	int equals(void *p1, void *p2) {
		cfloat[] s1 = *cast(cfloat[]*)p1;
		cfloat[] s2 = *cast(cfloat[]*)p2;
		size_t len = s1.length;

		if (len != s2.length) {
			return 0;
		}

		for (size_t u = 0; u < len; u++) {
			int c = TypeInfo_q._equals(s1[u], s2[u]);

			if (c == 0) {
				return 0;
			}
		}

		return 1;
	}

	int compare(void *p1, void *p2) {
		cfloat[] s1 = *cast(cfloat[]*)p1;
		cfloat[] s2 = *cast(cfloat[]*)p2;
		size_t len = s1.length;

		if (s2.length < len) {
			len = s2.length;
		}

		for (size_t u = 0; u < len; u++) {
			int c = TypeInfo_q._compare(s1[u], s2[u]);
			
			if (c) {
				return c;
			}
		}

		if (s1.length < s2.length) {
			return -1;
		}
		else if (s1.length > s2.length) {
			return 1;
		}

		return 0;
	}

	size_t tsize() {
		return (cfloat[]).sizeof;
	}

	uint flags() {
		return 1;
	}

	TypeInfo next() {
		return typeid(cfloat);
	}
}
