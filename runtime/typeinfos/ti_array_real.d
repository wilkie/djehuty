/*
 * ti_array_real.d
 *
 * This module implements the TypeInfo for real[]
 *
 */

module runtime.typeinfos.ti_array_real;

import runtime.typeinfos.ti_real;

class TypeInfo_Ae : TypeInfo {
	char[] toString() {
		return "real[]";
	}

	hash_t getHash(void *p) {
		real[] s = *cast(real[]*)p;
		size_t len = s.length;
		auto str = s.ptr;
		hash_t hash = 0;

		while (len) {
			hash *= 9;
			hash += (cast(uint *)str)[0];
			hash += (cast(uint *)str)[1];
			hash += (cast(ushort *)str)[4];
			str++;
			len--;
		}

		return hash;
	}

	int equals(void *p1, void *p2) {
		real[] s1 = *cast(real[]*)p1;
		real[] s2 = *cast(real[]*)p2;
		size_t len = s1.length;

		if (len != s2.length) {
			return 0;
		}

		for (size_t u = 0; u < len; u++) {
			int c = TypeInfo_e._equals(s1[u], s2[u]);

			if (c == 0) {
				return 0;
			}
		}

		return 1;
	}

	int compare(void *p1, void *p2) {
		real[] s1 = *cast(real[]*)p1;
		real[] s2 = *cast(real[]*)p2;
		size_t len = s1.length;

		if (s2.length < len) {
			len = s2.length;
		}

		for (size_t u = 0; u < len; u++) {
			int c = TypeInfo_e._compare(s1[u], s2[u]);

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
		return (real[]).sizeof;
	}

	uint flags() {
		return 1;
	}

	TypeInfo next() {
		return typeid(real);
	}
}
