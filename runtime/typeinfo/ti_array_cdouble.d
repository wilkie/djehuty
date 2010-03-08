/*
 * ti_array_cdouble
 *
 * This module implements the TypeInfo for a cdouble[]
 *
 */

module mindrt.typeinfo.ti_array_cdouble;

import mindrt.typeinfo.ti_cdouble;

class TypeInfo_Ar : TypeInfo {
	char[] toString() { return "cdouble[]"; }

	hash_t getHash(void *p) {
		cdouble[] s = *cast(cdouble[]*)p;

		size_t len = s.length;
		cdouble *str = s.ptr;
		hash_t hash = 0;

		while (len) {
			hash *= 9;
			hash += (cast(uint *)str)[0];
			hash += (cast(uint *)str)[1];
			hash += (cast(uint *)str)[2];
			hash += (cast(uint *)str)[3];
			str++;
			len--;
		}

		return hash;
	}

	int equals(void *p1, void *p2) {
		cdouble[] s1 = *cast(cdouble[]*)p1;
		cdouble[] s2 = *cast(cdouble[]*)p2;
		size_t len = s1.length;

		if (len != s2.length) {
			return 0;
		}

		for (size_t u = 0; u < len; u++) {
			int c = TypeInfo_r._equals(s1[u], s2[u]);

			if (c == 0) {
				return 0;
			}
		}
		return 1;
	}

	int compare(void *p1, void *p2) {
		cdouble[] s1 = *cast(cdouble[]*)p1;
		cdouble[] s2 = *cast(cdouble[]*)p2;
		size_t len = s1.length;

		if (s2.length < len)
			len = s2.length;
		for (size_t u = 0; u < len; u++) {
			int c = TypeInfo_r._compare(s1[u], s2[u]);

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
		return (cdouble[]).sizeof;
	}

	uint flags() {
		return 1;
	}

	TypeInfo next() {
		return typeid(cdouble);
	}
}
