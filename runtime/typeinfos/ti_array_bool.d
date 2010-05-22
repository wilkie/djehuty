/*
 * ti_array_bool.d
 *
 * This module implements the TypeInfo for a bool[]
 *
 */

module runtime.typeinfos.ti_array_bool;

import runtime.typeinfos.ti_array_ubyte;

class TypeInfo_Ab : TypeInfo_Ah {
	char[] toString() {
		return "bool[]";
	}

	TypeInfo next() {
		return typeid(bool);
	}
}
