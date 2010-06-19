/*
 * ti_function.d
 *
 * This module implements the TypeInfo for function types.
 *
 */

module runtime.typeinfos.ti_function;

class TypeInfo_Function : TypeInfo {
	char[] toString() {
		return next.toString() ~ "()";
	}

	int opEquals(Object o) {
		TypeInfo_Function c;

		return this is o ||
				((c = cast(TypeInfo_Function)o) !is null &&
				 this.next == c.next);
	}

	// BUG: need to add the rest of the functions

	size_t tsize() {
		return 0;		// no size for functions
	}

	TypeInfo next;
}


