/*
 * ti_array_ifloat.d
 *
 * This module implements the TypeInfo for ifloat[]
 *
 */

module mindrt.typeinfo.ti_array_ifloat;

import mindrt.typeinfo.ti_array_float;

class TypeInfo_Ao : TypeInfo_Af {
	char[] toString() {
		return "ifloat[]";
	}

	TypeInfo next() {
		return typeid(ifloat);
	}
}
