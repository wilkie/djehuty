/*
 * ti_staticarray.d
 *
 * This module implements the TypeInfo for static arrays.
 *
 */

module runtime.typeinfo.ti_staticarray;

class TypeInfo_StaticArray : TypeInfo {
	char[] toString() {
		char[20] buf;
		return value.toString() ~ "[" ~ itoa(buf, 'd', len) ~ "]";
	}

	int opEquals(Object o) {
		TypeInfo_StaticArray c;

		return cast(int)
			   (this is o ||
				((c = cast(TypeInfo_StaticArray)o) !is null &&
				 this.len == c.len &&
				 this.value == c.value));
	}

	hash_t getHash(void *p) {	
		size_t sz = value.tsize();
		hash_t hash = 0;
		for (size_t i = 0; i < len; i++)
			hash += value.getHash(p + i * sz);
		return hash;
	}

	int equals(void *p1, void *p2) {
		size_t sz = value.tsize();

		for (size_t u = 0; u < len; u++) {
			if (!value.equals(p1 + u * sz, p2 + u * sz))
				return 0;
		}
		return 1;
	}

	int compare(void *p1, void *p2) {
		size_t sz = value.tsize();

		for (size_t u = 0; u < len; u++) {
			int result = value.compare(p1 + u * sz, p2 + u * sz);
			if (result)
				return result;
		}
		return 0;
	}

	size_t tsize() {
		return len * value.tsize();
	}

	void swap(void *p1, void *p2) {
		void* tmp;
		size_t sz = value.tsize();
		ubyte[16] buffer;
		void* pbuffer;

		if (sz < buffer.sizeof)
			tmp = buffer.ptr;
		else
			tmp = pbuffer = (new void[sz]).ptr;

		for (size_t u = 0; u < len; u += sz) {
			size_t o = u * sz;
			tmp[0 .. sz] = (p1 + o)[0 .. sz];
			(p1 + o)[0 .. sz] = (p2 + o)[0 .. sz];
			(p2 + o)[0 .. sz] = tmp[0 .. sz];
		}
		if (pbuffer)
			delete pbuffer;
	}

	void[] init() {
		return value.init();
	}

	TypeInfo next() {
		return value;
	}

	uint flags() {
		return value.flags(); 
	}

	TypeInfo value;
	size_t len;
}


