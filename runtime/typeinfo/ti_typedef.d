/*
 * ti_typedef.d
 *
 * This module implements the TypeInfo for a typedef.
 *
 */

module runtime.typeinfo.ti_typedef;

class TypeInfo_Typedef : TypeInfo {
	char[] toString() { return name; }

	int opEquals(Object o) {
		TypeInfo_Typedef c;

		return cast(int)
			(this is o ||
			 ((c = cast(TypeInfo_Typedef)o) !is null &&
			  this.name == c.name &&
			  this.base == c.base));
	}

	hash_t getHash(void *p) {
		return base.getHash(p);
	}
	
	int equals(void *p1, void *p2) {
		return base.equals(p1, p2);
	}

	int compare(void *p1, void *p2) {
		return base.compare(p1, p2);
	}

	size_t tsize() {
		return base.tsize();
	}

	void swap(void *p1, void *p2) {
		return base.swap(p1, p2);
	}

	TypeInfo next() {
		return base.next();
	}

	uint flags() {
		return base.flags();
	}
	
	void[] init() {
		if (m_init.length > 0) {
			return m_init;
		}
		return base.init();
	}

	TypeInfo base;
	char[] name;
	void[] m_init;
}


