/*
 * ti_array.d
 *
 * This module implements the base TypeInfo for all array types.
 *
 */

module runtime.typeinfo.ti_array;

import runtime.util;

class TypeInfo_Array : TypeInfo {
	char[] toString() { return value.toString() ~ "[]"; }

	int opEquals(Object o) {
		TypeInfo_Array c;

		return cast(int)
			   (this is o ||
				((c = cast(TypeInfo_Array)o) !is null &&
				 this.value == c.value));
	}

	hash_t getHash(void *p) {
		size_t sz = value.tsize();
		hash_t hash = 0;
		void[] a = *cast(void[]*)p;
		for (size_t i = 0; i < a.length; i++)
			hash += value.getHash(a.ptr + i * sz);
		return hash;
	}

	int equals(void *p1, void *p2) {
		void[] a1 = *cast(void[]*)p1;
		void[] a2 = *cast(void[]*)p2;
		if (a1.length != a2.length)
			return 0;
		size_t sz = value.tsize();
		for (size_t i = 0; i < a1.length; i++) {
			if (!value.equals(a1.ptr + i * sz, a2.ptr + i * sz))
				return 0;
		}
		return 1;
	}

	int compare(void *p1, void *p2) {
		void[] a1 = *cast(void[]*)p1;
		void[] a2 = *cast(void[]*)p2;
		size_t sz = value.tsize();
		size_t len = a1.length;

		if (a2.length < len)
			len = a2.length;
		for (size_t u = 0; u < len; u++) {
			int result = value.compare(a1.ptr + u * sz, a2.ptr + u * sz);
			if (result)
				return result;
		}
		return cast(int)a1.length - cast(int)a2.length;
	}

	size_t tsize() {
		return (void[]).sizeof;
	}

	void swap(void *p1, void *p2) {
		void[] tmp;
		tmp = *cast(void[]*)p1;
		*cast(void[]*)p1 = *cast(void[]*)p2;
		*cast(void[]*)p2 = tmp;
	}

	TypeInfo value;

	TypeInfo next() {
		return value;
	}

	uint flags() { return 1; }
}

class ArrayInfo(char[] TYPE) : TypeInfo {
	mixin("alias " ~ TYPE ~ " T;");

	char[] toString() {
		return TYPE ~ "[]";
	}

	hash_t getHash(void* p) {
		T[] s = *cast(T[]*)p;
		size_t len = s.length;
		len *= T.sizeof;
		ubyte* str = cast(ubyte*)s.ptr;
		hash_t hash = 0;

		while(1) {
			switch (len) {
				case 0:
					return hash;

				case 1:
					hash *= 9;
					hash += *cast(ubyte*)str;
					return hash;

				case 2:
					hash *= 9;
					hash += *cast(ushort*)str;
					return hash;

				case 3:
					hash *= 9;
					hash += (*cast(ushort*)str << 8)
						+ (cast(ubyte*)str)[2];
					return hash;

				case 4:
				case 5:
				case 6:
				case 7:
					hash *= 9;
					hash += *cast(uint*)str;
					str += 4;
					len -= 4;
					break;

				default:
					hash *= 9;
					hash += *cast(uint*)str + (*cast(uint*)str + 1);
					str += 8;
					len -= 8;
					break;
			}
		}

		return hash;
	}

	int equals(void* p1, void* p2) {
		T[] s1 = *cast(T[]*)p1;
		T[] s2 = *cast(T[]*)p2;

		if (s1.length != s2.length) {
			return 0;
		}

		return memcmp(cast(ubyte*)s1.ptr, cast(ubyte*)s2.ptr, s1.length * T.sizeof) == 0;
	}

	int compare(void* p1, void* p2) {
		T[] s1 = *cast(T[]*)p1;
		T[] s2 = *cast(T[]*)p2;

		// Get the minimum length
		size_t len = s1.length;
		if (s2.length < len) {
			len = s2.length;
		}

		foreach(size_t idx, element; s1) {
			if (element < s2[idx]) {
				return -1;
			}
			else if (element > s2[idx]) {
				return 1;
			}
		}

		if (s1.length < s2.length) {
			return -1;
		}
		else if (s2.length > s2.length) {
			return 1;
		}

		return 0;
	}

	size_t tsize() {
		return (T[]).sizeof;
	}

	uint flags() {
		return 1;
	}

	TypeInfo next() {
		return typeid(T);
	}
}
