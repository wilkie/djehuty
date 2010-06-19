/*
 * ti_array_creal.d
 *
 * This module implements the TypeInfo for a creal[]
 *
 */

module runtime.typeinfos.ti_array_creal;

import runtime.typeinfos.ti_creal;

class TypeInfo_Ac : TypeInfo {
	char[] toString() {
		return "creal[]";
	}

	hash_t getHash(void *p) {
		creal[] s = *cast(creal[]*)p;
		size_t len = s.length;
		creal *str = s.ptr;
		hash_t hash = 0;

		while (len) {
			hash *= 9;
			hash += (cast(uint *)str)[0];
			hash += (cast(uint *)str)[1];
			hash += (cast(uint *)str)[2];
			hash += (cast(uint *)str)[3];
			hash += (cast(uint *)str)[4];
			str++;
			len--;
		}

		return hash;
	}

	int equals(void *p1, void *p2) {
		creal[] s1 = *cast(creal[]*)p1;
		creal[] s2 = *cast(creal[]*)p2;
		size_t len = s1.length;

		if (len != s2.length) {
			return 0;
		}

		for (size_t u = 0; u < len; u++) {
			int c = TypeInfo_c._equals(s1[u], s2[u]);

			if (c == 0) {
				return 0;
			}
		}

		return 1;
	}

	int compare(void *p1, void *p2) {
		creal[] s1 = *cast(creal[]*)p1;
		creal[] s2 = *cast(creal[]*)p2;
		size_t len = s1.length;

		if (s2.length < len) {
			len = s2.length;
		}

		for (size_t u = 0; u < len; u++) {
			int c = TypeInfo_c._compare(s1[u], s2[u]);

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
		return (creal[]).sizeof;
	}

	uint flags() {
		return 1;
	}

	TypeInfo next() {
		return typeid(creal);
	}
}
