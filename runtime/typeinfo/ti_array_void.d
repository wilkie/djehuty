/*
 * ti_array_void.d
 *
 * This module implements the TypeInfo for a void[]
 *
 */

module mindrt.typeinfo.ti_array_void;

import mindrt.typeinfo.ti_array_ubyte;

class TypeInfo_Av : TypeInfo_Ah {
	char[] toString() {
		return "void[]";
	}

	TypeInfo next() {
		return typeid(void);
	}
}
