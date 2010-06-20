module runtime.typeinfo;

struct OffsetTypeInfo {
	size_t offset;
	TypeInfo ti;
}

class TypeInfo {
	hash_t toHash() {
		hash_t hash;

		foreach (char c; this.toString()) {
			hash = hash * 9 + c;
		}

		return hash;
	}

	int opCmp(Object o) {
		if (this is o) {
			return 0;
		}

		TypeInfo ti = cast(TypeInfo)o;
		if (ti is null) {
			return 1;
		}

		string t = this.toString();
		string other = this.toString();
		TypeInfo str = typeid(string);

		return str.compare(&t, &other);
	}

	int opEquals(Object o) {
		if (this is o) {
			return 1;
		}

		TypeInfo ti = cast(TypeInfo)o;
		if (ti is null) {
			return 0;
		}

		return cast(int)(this.toString() == ti.toString());
	}

	hash_t getHash(void* ptr) { return cast(uint)ptr; }

	int equals(void* p1, void* p2) {
		return cast(int)(p1 == p2);
	}

	int compare(void* p1, void* p2) {
		return 0;
	}

	size_t tsize() {
		return 0;
	}

	void swap(void* element1, void* element2) {
		size_t n = tsize();
		ubyte[] array1 = (cast(ubyte*)element1)[0..n];
		ubyte[] array2 = (cast(ubyte*)element2)[0..n];
		for (size_t i = 0; i < n; i++) {
			array1[i] ^= array2[i];
			array2[i] ^= array1[i];
			array1[i] ^= array2[i];
		}
	}

	TypeInfo next() {
		return null;
	}

	void[] init() {
		return null;
	}

	uint flags() {
		return 0;
	}

	OffsetTypeInfo[] offTi() {
		return null;
	}
}
