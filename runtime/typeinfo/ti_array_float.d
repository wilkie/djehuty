/*
 * ti_array_float.d
 *
 * This module implements the TypeInfo for float[]
 *
 */

module mindrt.typeinfo.ti_array_float;

import mindrt.typeinfo.ti_float;

class TypeInfo_Af : TypeInfo {
	char[] toString() {
		return "float[]";
	}

	hash_t getHash(void *p) {
		float[] s = *cast(float[]*)p;
		size_t len = s.length;
		auto str = s.ptr;
		hash_t hash = 0;

		while (len) {
			hash *= 9;
			hash += *cast(uint *)str;
			str++;
			len--;
		}

		return hash;
	}

	int equals(void *p1, void *p2) {
		float[] s1 = *cast(float[]*)p1;
		float[] s2 = *cast(float[]*)p2;
		size_t len = s1.length;

		if (len != s2.length) {
			return 0;
		}

		for (size_t u = 0; u < len; u++) {
			int c = TypeInfo_f._equals(s1[u], s2[u]);

			if (c == 0) {
				return 0;
			}
		}

		return 1;
	}

	int compare(void *p1, void *p2) {
		float[] s1 = *cast(float[]*)p1;
		float[] s2 = *cast(float[]*)p2;
		size_t len = s1.length;

		if (s2.length < len) {
			len = s2.length;
		}

		for (size_t u = 0; u < len; u++) {
			int c = TypeInfo_f._compare(s1[u], s2[u]);

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
		return (float[]).sizeof;
	}

	uint flags() {
		return 1;
	}

	TypeInfo next() {
		return typeid(float);
	}
}
