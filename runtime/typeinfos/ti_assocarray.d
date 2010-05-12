/*
 * ti_associativearray.d
 *
 * This module implements the TypeInfo for associative arrays.
 *
 */

module runtime.typeinfos.ti_assocarray;

class TypeInfo_AssociativeArray : TypeInfo {
	char[] toString() {
		return value.toString() ~ "[" ~ key.toString() ~ "]";
	}

	int opEquals(Object o) {
		TypeInfo_AssociativeArray c;

		return this is o ||
				((c = cast(TypeInfo_AssociativeArray)o) !is null &&
				 this.key == c.key &&
				 this.value == c.value);
	}

	// BUG: need to add the rest of the functions

	size_t tsize() {
		return (char[int]).sizeof;
	}

	TypeInfo next() {
		return value;
	}

	uint flags() {
		return 1;
	}

	TypeInfo value;
	TypeInfo key;
}


