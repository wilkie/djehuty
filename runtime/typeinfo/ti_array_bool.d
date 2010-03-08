/*
 * ti_array_bool.d
 *
 * This module implements the TypeInfo for a bool[]
 *
 */

module mindrt.typeinfo.ti_array_bool;

import mindrt.typeinfo.ti_array_ubyte;

class TypeInfo_Ab : TypeInfo_Ah {
	char[] toString() {
		return "bool[]";
	}

	TypeInfo next() {
		return typeid(bool);
	}
}
